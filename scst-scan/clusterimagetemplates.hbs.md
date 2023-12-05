# Author a ClusterImageTemplate for Supply Chain integration

This topic tells you how to create your own ClusterImageTemplate and customize the embedded ImageVulnerabilityScan to use the scanner of your choice.

## <a id='prerecs'></a> Prerequisites

The following prerequisite is required to author a ClusterImageTemplate for Supply Chain integration:

- You create your own ImageVulnerabilityScan or configured one of the samples provided in [Configure your custom ImageVulnerabilityScan](./ivs-custom-samples.hbs.md).

## <a id='create-clusterimagetemplate'></a> Create a ClusterImageTemplate

This section describes how to create a ClusterImageTemplate using an ImageVulnerabilityScan with Trivy. To use a different scanner, replace the embedded ImageVulnerabilityScan with your own.

1. Create a YAML file with the following content and name it `custom-ivs-template.yaml`.

    ```yaml
    apiVersion: carto.run/v1alpha1
    kind: ClusterImageTemplate
    metadata:
      name: image-vulnerability-scan-custom # input name of your ClusterImageTemplate
    spec:
      imagePath: .status.scannedImage
      retentionPolicy:
        maxFailedRuns: 10
        maxSuccessfulRuns: 10
      lifecycle: immutable

      healthRule:
        multiMatch:
          healthy:
            matchConditions:
              - status: "True"
                type: ScanCompleted
              - status: "True"
                type: Succeeded
          unhealthy:
            matchConditions:
              - status: "False"
                type: ScanCompleted
              - status: "False"
                type: Succeeded

      params:
        - name: image_scanning_workspace_size
          default: 4Gi
        - name: image_scanning_service_account_scanner
          default: scanner
        - name: image_scanning_service_account_publisher
          default: publisher
        - name: image_scanning_active_keychains
          default: []
        - name: trivy_db_repository
          default: ghcr.io/aquasecurity/trivy-db
        - name: trivy_java_db_repository
          default: ghcr.io/aquasecurity/trivy-java-db
        - name: registry
          default:
            server: my-registry.io    # input your registry server
            repository: my-registry-repository    # input your registry repository

      ytt: |
        #@ load("@ytt:data", "data")

        #@ def merge_labels(fixed_values):
        #@   labels = {}
        #@   if hasattr(data.values.workload.metadata, "labels"):
        #@     labels.update(data.values.workload.metadata.labels)
        #@   end
        #@   labels.update(fixed_values)
        #@   return labels
        #@ end

        #@ def scanResultsLocation():
        #@   return "/".join([
        #@    data.values.params.registry.server,
        #@    data.values.params.registry.repository,
        #@    "-".join([
        #@      data.values.workload.metadata.name,
        #@      data.values.workload.metadata.namespace,
        #@      "scan-results",
        #@    ])
        #@   ]) + ":" + data.values.workload.metadata.uid
        #@ end

        #@ def param(key):
        #@   if not key in data.values.params:
        #@     return None
        #@   end
        #@   return data.values.params[key]
        #@ end

        #@ def maven_param(key):
        #@   if not key in data.values.params["maven"]:
        #@     return None
        #@   end
        #@   return data.values.params["maven"][key]
        #@ end

        #@ def correlationId():
        #@   if hasattr(data.values.workload, "annotations") and hasattr(data.values.workload.annotations, "apps.tanzu.vmware.com/correlationid"):
        #@     return data.values.workload.annotations["apps.tanzu.vmware.com/correlationid"]
        #@   end
        #@   if not hasattr(data.values.workload.spec, "source"):
        #@     return ""
        #@   end
        #@   url = ""
        #@   if hasattr(data.values.workload.spec.source, "git"):
        #@     url = data.values.workload.spec.source.git.url
        #@   end
        #@   if hasattr(data.values.workload.spec.source, "image"):
        #@     url = data.values.workload.spec.source.image.split("@")[0]
        #@   end
        #@   if param("maven"):
        #@     url = param("maven_repository_url") + "/" + maven_param("groupId").replace(".", "/") + "/" + maven_param("artifactId")
        #@   end
        #@   return url + "?sub_path=" + getattr(data.values.workload.spec.source, "subPath", "/")
        #@ end

        ---
        apiVersion: app-scanning.apps.tanzu.vmware.com/v1alpha1
        kind: ImageVulnerabilityScan
        metadata:
          labels: #@ merge_labels({ "app.kubernetes.io/component": "image-scan" })
          annotations:
            apps.tanzu.vmware.com/correlationid: #@ correlationId()
          generateName: #@ data.values.workload.metadata.name + "-trivy-scan-"
        spec:
          image: #@ data.values.image
          activeKeychains: #@ data.values.params.image_scanning_active_keychains
          scanResults:
            location: #@ scanResultsLocation()
          workspace:
            size: #@ data.values.params.image_scanning_workspace_size
          serviceAccountNames:
            scanner: #@ data.values.params.image_scanning_service_account_scanner
            publisher: #@ data.values.params.image_scanning_service_account_publisher
          steps:
          - name: trivy-generate-report
            image: my.registry.com/aquasec/trivy:0.41.0     # input the location of your trivy scanner image
            env:
            - name: TRIVY_DB_REPOSITORY
              value: #@ data.values.params.trivy_db_repository
            - name: TRIVY_JAVA_DB_REPOSITORY
              value: #@ data.values.params.trivy_java_db_repository
            - name: TRIVY_CACHE_DIR
              value: /workspace/trivy-cache
            - name: XDG_CACHE_HOME
              value: /workspace/.cache
            - name: TMPDIR
              value: /workspace
            args:
            - image
            - $(params.image)
            - --exit-code=0
            - --no-progress
            - --scanners=vuln
            - --format=cyclonedx
            - --output=scan.cdx.json
          - name: trivy-display-report
            image: my.registry.com/aquasec/trivy:0.41.0     # input the location of your trivy scanner image
            env:
            - name: TRIVY_DB_REPOSITORY
              value: #@ data.values.params.trivy_db_repository
            - name: TRIVY_JAVA_DB_REPOSITORY
              value: #@ data.values.params.trivy_java_db_repository
            - name: TRIVY_CACHE_DIR
              value: /workspace/trivy-cache
            - name: XDG_CACHE_HOME
              value: /workspace/.cache
            - name: TMPDIR
              value: /workspace
            args:
            - image
            - $(params.image)
            - --skip-db-update
            - --skip-java-db-update
            - --exit-code=0
            - --scanners=vuln
            - --severity=HIGH
            - --no-progress
    ```

    Where:

    - `.metadata.name` is the name of your ClusterImageTemplate. Ensure that it does not conflict with the names of packaged templates. See [Author your supply chains](../scc/authoring-supply-chains.hbs.md#providing-your-own-templates).
    - `registry-server` is the registry server.
    - `registry-repository` is the registry repository.

    >**Note** `apps.tanzu.vmware.com/correlationid` contains the metadata of the mapping to the source of the resource being scanned. See [here](../scst-store/amr/cloudevents.hbs.md#cloudevent-extension-attributes).

1. Edit the following in your `custom-ivs-template.yaml` file:

   - `.metadata.name` is the name of your ClusterImageTemplate.
   - `registry-server` and `registry-repository` refer to your registry.
   - The location of your Trivy scanner image

2. (Optional) If you are replacing the embedded ImageVulnerabilityScan with your own, use `ytt` to pass relevant values to the ImageVulnerabilityScan:

    ```yaml
    metadata:
      labels: #@ merge_labels({ "app.kubernetes.io/component": "image-scan" })
      generateName: #@ data.values.workload.metadata.name + "-trivy-scan-"
    spec:
      image: #@ data.values.image
      activeKeychains: #@ data.values.params.image_scanning_active_keychains
      scanResults:
        location: #@ scanResultsLocation()
      workspace:
        size: #@ data.values.params.image_scanning_workspace_size
      serviceAccountNames:
        scanner: #@ data.values.params.image_scanning_service_account_scanner
        publisher: #@ data.values.params.image_scanning_service_account_publisher
    ```

3. Create the ClusterImageTemplate:

    ```console
    kubectl apply -f custom-ivs-template.yaml
    ```

4. After you create your custom ClusterImageTemplate, you can integrate it with SCST - Scan 2.0. See [Add App Scanning to default Test and Scan supply chains](./integrate-app-scanning.hbs.md).

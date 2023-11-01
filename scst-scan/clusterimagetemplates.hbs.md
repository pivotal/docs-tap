# Author a ClusterImageTemplate for Supply Chain integration

This topic tells you how to create your own ClusterImageTemplate and customize the embedded ImageVulnerabilityScan to use the scanner of your choice.

## <a id='prerecs'></a> Prerequisites

The following prerequisite is required to author a ClusterImageTemplate for Supply Chain integration:

- You create your own ImageVulnerabilityScan or configured one of the samples provided in [Configure your custom ImageVulnerabilityScan](./ivs-custom-samples.hbs.md).
- See ClusterImageTemplate [docs](https://cartographer.sh/docs/v0.3.0/reference/template/#clusterimagetemplate) for more details.
- Understand `ytt` templating. See Carvel `ytt` [docs](https://carvel.dev/ytt/) for documentation and playground samples.

## <a id='create-clusterimagetemplate'></a> Create a ClusterImageTemplate

This section describes how to create a ClusterImageTemplate using an ImageVulnerabilityScan with Trivy. To use a different scanner, replace the embedded ImageVulnerabilityScan with your own.

ClusterImageTemplate Notes:
* The `spec.params` in this sample yaml are used to define default values for fields within the ImageVulnerabilityScan. See `params` [docs](https://cartographer.sh/docs/v0.3.0/reference/template/#clusterimagetemplate) for more details.
  * The `spec.params` fields are referenced by `#@ data.values.params` in the `ytt` template block and in the ImageVulnerabilityScan.
* The values in the `data.values.workload` such as `metadata`, `labels`, `annotations`, `spec` come from the supply chain workload.
* The `data.values.image` is the container image built from Buildpacks in the previous step in the SupplyChain that will be scanned for vulnerabilities.
* `ytt` is used in this sample yaml to define a resource template written in `ytt` for the ImageVulnerabilityScan Custom Resource. See `ytt` [docs](https://cartographer.sh/docs/v0.3.0/reference/template/#clusterimagetemplate) for more details.
  * For example, inside the `ytt` template are defined functions that can be used within the ImageVulnerabilityScan.

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
        - name: image_scanning_workspace_bindings
          default: []
        - name: image_scanning_steps_env_vars
          default: []
        - name: trivy_db_repository
          default: ghcr.io/aquasecurity/trivy-db
        - name: trivy_java_db_repository
          default: ghcr.io/aquasecurity/trivy-java-db
        - name: registry
          default:
            server: REGISTRY-SERVER    # input your registry server
            repository: REGISTRY-REPOSITORY    # input your registry repository

      ytt: |
        #@ load("@ytt:data", "data")
        #@ load("@ytt:template", "template")

        #@ def merge_labels(fixed_values):
        #@   labels = {}
        #@   if hasattr(data.values.workload.metadata, "labels"):
        #@     exclusions = ["kapp.k14s.io/app", "kapp.k14s.io/association"]
        #@     for k,v in dict(data.values.workload.metadata.labels).items():
        #@       if k not in exclusions:
        #@         labels[k] = v
        #@       end
        #@     end
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

        #@ def maven_repository_url():
        #@   if maven_param("repository") and "url" in maven_param("repository"):
        #@     return maven_param("repository")["url"]
        #@   elif param("maven_repository_url"):
        #@     return param("maven_repository_url")
        #@   else:
        #@     return None
        #@   end
        #@ end

        #@ def correlationId():
        #@   if hasattr(data.values.workload, "annotations") and hasattr(data.values.workload.annotations, "apps.tanzu.vmware.com/correlationid"):
        #@     return data.values.workload.annotations["apps.tanzu.vmware.com/correlationid"]
        #@   end
        #@   url = ""
        #@   if hasattr(data.values.workload.spec, "source"):
        #@     if hasattr(data.values.workload.spec.source, "git"):
        #@       url = data.values.workload.spec.source.git.url
        #@     elif hasattr(data.values.workload.spec.source, "image"):
        #@       url = data.values.workload.spec.source.image.split("@")[0]
        #@     end
        #@     url = url + "?sub_path=" + getattr(data.values.workload.spec.source, "subPath", "/")
        #@   end
        #@   if param("maven"):
        #@     url = maven_repository_url() + "/" + maven_param("groupId").replace(".", "/") + "/" + maven_param("artifactId")
        #@   end
        #@   if hasattr(data.values.workload.spec, "image"):
        #@     url = data.values.workload.spec.image.split("@",1)[0]
        #@     url = url.split(":",1)[0]
        #@   end
        #@   return url
        #@ end

        ---
        apiVersion: app-scanning.apps.tanzu.vmware.com/v1alpha1
        kind: ImageVulnerabilityScan
        metadata:
          labels: #@ merge_labels({ "app.kubernetes.io/component": "image-scan" })
          annotations:
            apps.tanzu.vmware.com/correlationid: #@ correlationId()
            app-scanning.apps.tanzu.vmware.com/scanner-name: Trivy
          generateName: #@ data.values.workload.metadata.name + "-trivy-scan-"
        spec:
          image: #@ data.values.image
          activeKeychains: #@ data.values.params.image_scanning_active_keychains
          scanResults:
            location: #@ scanResultsLocation()
          workspace:
            size: #@ data.values.params.image_scanning_workspace_size
            #@ if/end data.values.params.image_scanning_workspace_bindings:
            bindings: #@ data.values.params.image_scanning_workspace_bindings
          serviceAccountNames:
            scanner: #@ data.values.params.image_scanning_service_account_scanner
            publisher: #@ data.values.params.image_scanning_service_account_publisher
          steps:
          - name: trivy-generate-report
            image: TRIVY-SCANNER-IMAGE # input the location of your Trivy scanner image
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
            - #@ template.replace(data.values.params.image_scanning_steps_env_vars)
            args:
            - image
            - $(params.image)
            - --exit-code=0
            - --no-progress
            - --scanners=vuln
            - --format=cyclonedx
            - --output=$(params.scan-results-path)/scan.cdx.json

    ```

>**Note** `apps.tanzu.vmware.com/correlationid` contains the metadata of the mapping to the source of the scanned resource.

2. Edit the following in your `custom-ivs-template.yaml` file:
  - `.metadata.name` is the name of your ClusterImageTemplate. Ensure that it does not conflict with the names of packaged templates. See [Author your supply chains](../scc/authoring-supply-chains.hbs.md#providing-your-own-templates).
  - `REGISTRY-SERVER` is the registry server.
  - `REGISTRY-REPOSITORY` is the registry repository.
  - `TRIVY-SCANNER-IMAGE` is the location of your Trivy scanner CLI image
  - `.metadata.annotations.'app-scanning.apps.tanzu.vmware.com/scanner-name'` is the scanner image name reported in the Tanzu Developer Portal, formerly Tanzu Application Platform GUI.

3. Create the ClusterImageTemplate:

    ```console
    kubectl apply -f custom-ivs-template.yaml
    ```

4. After you create your custom ClusterImageTemplate, you can integrate it with SCST - Scan 2.0. See [Supply Chain Security Tools - Scan 2.0](./integrate-app-scanning.hbs.md).

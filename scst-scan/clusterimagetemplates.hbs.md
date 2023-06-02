# Authoring a ClusterImageTemplate for Supply Chain integration

In addition to using a packaged ClusterImageTemplate, you can create your own and customize the ImageVulnerabilityScan to utilize the scanner of your choice. 

Follow the instructions below to create a ClusterImageTemplate using an ImageVulnerabilityScan with Trivy

1. Create a file with the following content and name it `custom-ivs-template.yaml`

```yaml
apiVersion: carto.run/v1alpha1
kind: ClusterImageTemplate
metadata:
  name: image-vulnerability-scan-custom # customized name
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
      default: 3Gi
    - name: image_scanning_service_account_scanner
      default: scanner
    - name: image_scanning_service_account_publisher
      default: publisher
    - name: trivy_db_repository
      default: ghcr.io/aquasecurity/trivy-db
    - name: trivy_java_db_repository
      default: ghcr.io/aquasecurity/trivy-java-db
    - name: registry_server
      default: tapacr.azurecr.io    # input your registry server
    - name: registry_repository
      default: vse-testing-robin    # input your registry repository

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
    #@    data.values.params.registry_server,
    #@    data.values.params.registry_repository,
    #@    "-".join([
    #@      data.values.workload.metadata.name,
    #@      data.values.workload.metadata.namespace,
    #@      "scan-results",
    #@    ])
    #@   ]) + ":" + data.values.workload.metadata.uid
    #@ end

    ---
    apiVersion: app-scanning.apps.tanzu.vmware.com/v1alpha1
    kind: ImageVulnerabilityScan
    metadata:
      labels: #@ merge_labels({ "app.kubernetes.io/component": "image-scan" })
      generateName: #@ data.values.workload.metadata.name + "-trivy-scan-"
      annotations:
        sue: #@ data.values.workload.metadata.uid
    spec:
      image: #@ data.values.image
      scanResults:
        location: #@ scanResultsLocation()
      workspace:
        size: #@ data.values.params.image_scanning_workspace_size
      serviceAccountNames:
        scanner: #@ data.values.params.image_scanning_service_account_scanner
        publisher: #@ data.values.params.image_scanning_service_account_publisher
      steps:
      - name: trivy-generate-report
        image: dev.registry.tanzu.vmware.com/supply-chain-security-tools/aquasec/trivy:0.41.0
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
        image: dev.registry.tanzu.vmware.com/supply-chain-security-tools/aquasec/trivy:0.41.0
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
- `.metadata.name` is the name of your ClusterImageTemplate. It must not conflict with the names of packaged [templates](../scc/authoring-supply-chains.hbs.md#providing-your-own-templates)

1. Modify
1. Create the ClusterImageTemplate:
    ```console
    kubectl apply -f custom-ivs-template.yaml
    ```
1. Once you have created your custom ClusterImageTemplate, you can proceed to integrating it in the [Supply Chain](next)

Below is a sample:

```yaml
apiVersion: carto.run/v1alpha1
kind: ClusterImageTemplate
metadata:
  name: image-vulnerability-scan-trivy-test
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
      default: 3Gi
    - name: image_scanning_service_account_scanner
      default: scanner
    - name: image_scanning_service_account_publisher
      default: publisher
    - name: trivy_db_repository
      default: ghcr.io/aquasecurity/trivy-db
    - name: trivy_java_db_repository
      default: ghcr.io/aquasecurity/trivy-java-db
    - name: registry_server
      default: tapacr.azurecr.io
    - name: registry_repository
      default: vse-testing-robin

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
    #@    data.values.params.registry_server,
    #@    data.values.params.registry_repository,
    #@    "-".join([
    #@      data.values.workload.metadata.name,
    #@      data.values.workload.metadata.namespace,
    #@      "scan-results",
    #@    ])
    #@   ]) + ":" + data.values.workload.metadata.uid
    #@ end

    ---
    apiVersion: app-scanning.apps.tanzu.vmware.com/v1alpha1
    kind: ImageVulnerabilityScan
    metadata:
      labels: #@ merge_labels({ "app.kubernetes.io/component": "image-scan" })
      generateName: #@ data.values.workload.metadata.name + "-trivy-scan-"
      annotations:
        sue: #@ data.values.workload.metadata.uid
    spec:
      image: #@ data.values.image
      scanResults:
        location: #@ scanResultsLocation()
      workspace:
        size: #@ data.values.params.image_scanning_workspace_size
      serviceAccountNames:
        scanner: #@ data.values.params.image_scanning_service_account_scanner
        publisher: #@ data.values.params.image_scanning_service_account_publisher
      steps:
      - name: trivy-generate-report
        image: dev.registry.tanzu.vmware.com/supply-chain-security-tools/aquasec/trivy:0.41.0
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
        image: dev.registry.tanzu.vmware.com/supply-chain-security-tools/aquasec/trivy:0.41.0
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
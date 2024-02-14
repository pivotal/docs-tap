# Set up the Supply Chain Component

This topic describes how to install the Trivy Supply Chain Component, create a custom Supply Chain Component using the SCST - Scan 2.0, and view the components that are available to be used in the Tanzu Supply Chain.

## <a id="install-trivy-sc"></a> Install Trivy Supply Chain Component

This section describes how to install the Trivy Supply Chain Component that uses SCST - Scan 2.0.

1. List version information for the Trivy Supply Chain Component package by running:

    ```console
    tanzu package available list trivy.app-scanning.component.apps.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```console
    tanzu package available list trivy.app-scanning.component.apps.tanzu.vmware.com --namespace tap-install

    NAME                                                VERSION                              RELEASED-AT
    trivy.app-scanning.component.apps.tanzu.vmware.com  TRIVY-COMPONENT-VERSION              2024-01-26 12:35:39 -0500 EST
    ```

2. Install Trivy Supply Chain Component package.

    ```console
    tanzu package install trivy-app-scanning-component --package-name trivy.app-scanning.component.apps.tanzu.vmware.com \
        --version TRIVY-COMPONENT-VERSION \
        --namespace tap-install
    ```

### <a id="customize-scan-component"></a> Customize Scanning Component

This section describes how to create a custom Scanning Supply Chain Component that uses SCST - Scan 2.0

1. Customize a component by retrieving the YAML of the Trivy Supply Chain Component. 
Retrieve component YAML:

    ```console
    kubectl get component trivy-image-scan-1.0.0 -n trivy-app-scanning-catalog -o yaml > component.yaml
    ```

1. Edit the following lines in the `component.yaml`:

    ```yaml
    apiVersion: supply-chain.apps.tanzu.vmware.com/v1alpha1
    kind: Component
    metadata:
      name: trivy-image-scan-1.0.0 # change to SCANNER-image-scan-1.0.0
      namespace: trivy-app-scanning-catalog # change to DEV-NAMESPACE
    ...
      description: Performs a trivy image scan using the scan 2.0 components # change trivy to SCANNER
      ...
        - name: image-scanning-cli
          value: # change to registry url of scanner image
        ...
        - name: image-scanning-steps-env-vars
          value: '[{"name":"<Name of Env var>","value":"<value of Env var>"}]' # insert env vars inside nested {}
        ...
        pipelineRef:
          name: trivy-image-scan-v2 # SCANNER-image-scan-v2. Replace with the name of the pipeline created in the next step.
    ```

1. Customize a pipeline by retrieving the YAML of the Trivy Supply Chain Component's Pipeline. Retrieve pipeline YAML:

    ```console
    kubectl get pipeline trivy-image-scan-v2 -n trivy-app-scanning-catalog -o yaml > pipeline.yaml
    ```

      Edit the following lines in the `pipeline.yaml`:

    ```yaml
    apiVersion: tekton.dev/v1
    kind: Pipeline
    metadata:
      name: trivy-image-scan-v2 # change to SCANNER-image-scan-v2
    spec:
      description: Scans your image for vulnerabilities using Trivy # change Trivy to SCANNER
    ...
            resourceSpec:
              apiVersion: app-scanning.apps.tanzu.vmware.com/v1alpha1
              kind: ImageVulnerabilityScan
              metadata:
                annotations:
                  app-scanning.apps.tanzu.vmware.com/scanner-name: Trivy # change to SCANNER
                ...
                steps:
                - args:
                  - # insert array of steps to run for SCANNER
                ...
                  name: trivy-generate-report # change to any SCANNER
                ...
      ```

      Where `SCANNER` is the name of the scanner from the scanning component

2. Apply the custom component and pipeline:

    ```console
    kubectl apply -f component.yaml
    kubectl apply -f pipeline.yaml
    ```

> **Note** If you create your own component, it requires the following label so that it can be observed by supplychain:

  ```console
  labels:
    supply-chain.apps.tanzu.vmware.com/catalog: tanzu
  ```

### <a id="how-to-view-component"></a> View components

This section covers how to view the available components that were installed or applied.

  ```console
  kubectl get components -A -l "supply-chain.apps.tanzu.vmware.com/catalog=tanzu"
  ```

  Example output:

  ```console
  $ kubectl get components -A -l "supply-chain.apps.tanzu.vmware.com/catalog=tanzu"

  NAMESPACE                    NAME                              RESUMPTIONS   READY   REASON   AGE
  alm-catalog                  aggregator-1.0.0                  False         True    Ready    3d
  alm-catalog                  app-config-server-1.0.0           False         True    Ready    3d
  alm-catalog                  app-config-web-1.0.0              False         True    Ready    3d
  alm-catalog                  app-config-worker-1.0.0           False         True    Ready    3d
  alm-catalog                  carvel-package-1.0.0              False         True    Ready    3d
  alm-catalog                  deployer-1.0.0                    False         True    Ready    3d
  alm-catalog                  source-package-translator-1.0.0   False         True    Ready    3d
  conventions-component        conventions-1.0.0                 False         True    Ready    3d
  git-writer-catalog           git-writer-1.0.0                  False         True    Ready    3d
  git-writer-catalog           git-writer-pr-1.0.0               False         True    Ready    3d
  grype-app-scanning-catalog   grype-image-scan-1.0.0            False         True    Ready    10h
  source-provider              source-git-provider-1.0.0         True          True    Ready    3d
  tbs-catalog                  buildpack-build-1.0.0             True          True    Ready    3d
  trivy-app-scanning-catalog   trivy-image-scan-1.0.0            False         True    Ready    3d
  ```

# Setup Supply Chain Component

This topic tells how to install the Trivy Supply Chain Component and create your own Supply Chain Component where they use the SCST - Scan 2.0 and the components are used in the Tanzu Supply Chain.

## <a id="overview"></a> Overview

* How to install the Trivy Supply Chain Component that uses SCST - Scan 2.0
* How to write your own Component that uses SCST - Scan 2.0
* How to view the component

### <a id="use-trivy-component"></a> How to use the Trivy Supply Chain Component that uses SCST - Scan 2.0

1. List version information for the Trivy Supply Chain Component package by running:
```
tanzu package available list trivy.app-scanning.component.apps.tanzu.vmware.com --namespace tap-install
```

For example:
```
$ tanzu package available list trivy.app-scanning.component.apps.tanzu.vmware.com --namespace tap-install
NAME                                                VERSION                              RELEASED-AT
trivy.app-scanning.component.apps.tanzu.vmware.com  TRIVY-COMPONENT-VERSION              2024-01-26 12:35:39 -0500 EST
```

2. Install Trivy Supply Chain Component package.
```
tanzu package install trivy-app-scanning-component --package-name trivy.app-scanning.component.apps.tanzu.vmware.com \
    --version TRIVY-COMPONENT-VERSION \
    --namespace tap-install
```


### <a id="create-own-component"></a> How to create your own Scanning Component that uses SCST - Scan 2.0

1. Reuse the trivy component by:

  * Create your own component:
    ```
    kubectl get component trivy-image-scan-1.0.0 -n trivy-app-scanning-catalog > component.yaml
    ```
    * Replace the `image-scanning-cli` with another scanner of your choice.
    * Replace the `image-scanning-steps-env-vars` with env vars.
    * Replace the pipelineref to the name of the pipeline you create in the next step.

  * Reuse the pipeline from the trivy component
    ```
    kubectl get pipeline trivy-image-scan-v2 -n trivy-app-scanning-catalog > pipeline.yaml
    ```

  * Apply your new component
  ```
  kubectl apply -f component.yaml
  kubectl apply -f pipeline.yaml
  ```


### <a id="view-component"></a> How to view Component

Prereq:
* cartographer plugin

* Use Tanzu Cartographer plugin
```
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

$ tanzu cartographer supply-chain component list

  NAME                             NAMESPACE                   DESCRIPTION                                                                       RESUMPTIONS  INPUTS                                                        OUTPUTS                                                       AGE
  aggregator-1.0.0                 alm-catalog                 Constructs configuration from a series of inputs                                  False        oci-yaml-files[oci-yaml-files], oci-ytt-files[oci-ytt-files]  config[config]                                                3d1h
  app-config-server-1.0.0          alm-catalog                 Generates a server workload template from a config bundle                         False        conventions[conventions]                                      oci-yaml-files[oci-yaml-files], oci-ytt-files[oci-ytt-files]  3d1h
  app-config-web-1.0.0             alm-catalog                 Generates a web workload template from a config bundle                            False        conventions[conventions]                                      oci-yaml-files[oci-yaml-files], oci-ytt-files[oci-ytt-files]  3d1h
  app-config-worker-1.0.0          alm-catalog                 Generates a worker workload template from a config bundle                         False        conventions[conventions]                                      oci-yaml-files[oci-yaml-files], oci-ytt-files[oci-ytt-files]  3d1h
  carvel-package-1.0.0             alm-catalog                 Generates a carvel package from a config bundle                                   False        oci-yaml-files[oci-yaml-files], oci-ytt-files[oci-ytt-files]  package[package]                                              3d1h
  deployer-1.0.0                   alm-catalog                 Generates a carvel package from a config bundle                                   False        package[package]                                              <none>                                                        3d1h
  source-package-translator-1.0.0  alm-catalog                 Takes the type source and immediately outputs it as type package. In the          False        source[source]                                                package[package]                                              3d1h
                                                               future, will be replaced by input type mapping or some similar feature.
  conventions-1.0.0                conventions-component       Use the Cartographer Conventions service to generate decorated pod template       False        image[image]                                                  conventions[conventions]                                      3d1h
                                                               specs
  git-writer-1.0.0                 git-writer-catalog          Writes carvel package config directly to a gitops repository                      False        package[package]                                              gitops[gitops]                                                3d1h
  git-writer-pr-1.0.0              git-writer-catalog          Writes carvel package config to a gitops repository and opens a PR                False        package[package]                                              gitops[gitops]                                                3d1h
  source-git-provider-1.0.0        source-provider             Monitors a git repository                                                         True         <none>                                                        source[source], git[git]                                      3d1h
  buildpack-build-1.0.0            tbs-catalog                 Builds an app with buildpacks using kpack                                         True         source[source], git[git]                                      image[image]                                                  3d1h
  trivy-image-scan-1.0.0           trivy-app-scanning-catalog  Performs a trivy image scan using the scan 2.0 components                         False        image[image], git[git]                                        <none>                                                        3d
```

Note:
* If you create your own component, it needs the following label so that it can be observed by supplychain:
```
labels:
  supply-chain.apps.tanzu.vmware.com/catalog: tanzu
```
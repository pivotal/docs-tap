# Create Tanzu Supply Chain that uses App Scanning

This topic tells you how to create a Tanzu Supply Chain with App Scanning which replaces the previous solution for Supply Chains Choreographer for Tanzu.

## <a id="overview"></a> Overview

* Prereqs
* Create Tanzu Supply Chain using Tanzu Cartographer Plugin

### <a id="prerequisities"></a> Prerequisities

* Installed Packages:
  * Supplychain:
    * Supply Chain (supply-chain.apps.tanzu.vmware.com)
    * Supply Chain Catalog (supply-chain-catalog.apps.tanzu.vmware.com)
    * Managed Resource Controller (managed-resource-controller.apps.tanzu.vmware.com)
    * Tekton (tekton.apps.tanzu.vmware.com)
  * Components:
    * Source (Source.component.apps.tanzu.vmware.com)
    * Buildpack (buildpack-build.component.apps.tanzu.vmware.com)
    * Trivy Scanning (Trivy.app-scanning.component.apps.tanzu.vmware.com)
  * Scanning:
    * App-Scanning (app.scanning.apps.tanzu.vmware.com)
* Tanzu Cartographer Plugin to create Tanzu Supply Chains and Workloads

### <a id="create-supply-chain"></a> Create Tanzu Supply Chain with App Scanning using Tanzu Cartographer Plugin

* Create a Supply Chain with App Scanning and Trivy Supply Chain Component using Tanzu Cartographer Wizard if you installed the Trivy Supply Chain Component in the previous component [page](./setup-supply-chain-component.md#how-to-use-the-trivy-supply-chain-component-that-uses-scst---scan-20):
```
tanzu cartographer supply-chain wizard --name trivy-supply-chain-1.0.0 \
--description Trivy \
--developer-interface-group example.com \
--developer-interface-kind TrivySC \
--developer-interface-version v1alpha1 \
--stages source-git-provider-1.0.0 \
--stages buildpack-build-1.0.0 \
--stages trivy-image-scan-0.0.1 \
--file trivy-supply-chain.yaml
```

* Create a Supply Chain with App Scanning and the custom Scanning Component if you created your own component in the previous component [page](./setup-supply-chain-component.md#how-to-create-your-own-scanning-component-that-uses-scst---scan-20):
```
tanzu cartographer supply-chain wizard --name SCANNER-supply-chain-1.0.0 \
--description <your scanner> \
--developer-interface-group example.com \
--developer-interface-kind <custom Kind workload> \
--developer-interface-version v1alpha1 \
--stages source-git-provider-1.0.0 \
--stages buildpack-build-1.0.0 \
--stages SCANNING-COMPONENT-NAME \
--file SCANNER-supply-chain.yaml
```
Where:
* SCANNING-COMPONENT-NAME is the name of the scanning component made in the previous page.
* SCANNER is the name of the scanner from the scanning component made in the previous page.

**Note:** See Tanzu Supply Chain [docs](../supply-chain/platform-engineering/how-to/supply-chain-authoring/construct-with-cli.hbs.md) how to construct a Supply Chain using the CLI

* Apply Supply Chain into the DEV-NAMESPACE where you plan to run workload
```
kubectl apply -f <supplychain yaml made in previous step> -n DEV-NAMESPACE
```

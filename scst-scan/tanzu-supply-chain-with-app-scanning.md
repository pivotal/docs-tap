# Create Tanzu Supply Chain that uses App Scanning

This topic tells you how to create a Tanzu Supply Chain with App Scanning which replaces the previous solution for Supply Chains Choreographer for Tanzu.

## Overview

* Prereqs
* Create Tanzu Supply Chain using Tanzu Cartographer Plugin

### Prerequisities

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

### Create Tanzu Supply Chain with App Scanning using Tanzu Cartographer Plugin

* Create a Supply Chain with App Scanning using Trivy Supply Chain Component Tanzu Cartographer Wizard to Create Supply Chain with App-Scanning using either Trivy Supply Chain Component or a Component you created in the previous page.
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

Create a Supply Chain with App Scanning using your custom Scanning Component you created in the previous page:
```
tanzu cartographer supply-chain wizard --name <scanner>-supply-chain-1.0.0 \
--description <your scanner> \
--developer-interface-group example.com \
--developer-interface-kind <your own Kind workload> \
--developer-interface-version v1alpha1 \
--stages source-git-provider-1.0.0 \
--stages buildpack-build-1.0.0 \
--stages <SCANNING-COMPONENT-NAME> \
--file <scanner>-supply-chain.yaml
```
Where:
* SCANNING-COMPONENT-NAME is the name of the scanning component you made in the previous page.

**Note:** See Tanzu Supply Chain [docs](../supply-chain/platform-engineering/how-to/supply-chain-authoring/construct-with-cli.hbs.md) how to construct a Supply Chain using the CLI

* Apply Supply Chain into the DEV-NAMESPACE where you plan to run workload
```
kubectl apply -f <supply-chain yaml made in previous step> -n DEV-NAMESPACE
```

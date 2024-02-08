# Create Tanzu Supply Chain that uses App Scanning

This topic tells you how to create a Tanzu Supply Chain with App Scanning which replaces the previous solution for Supply Chains Choreographer for Tanzu.

## Overview

* Prereqs
* Create Tanzu Supply Chain using Tanzu Cartographer Plugin

### Prerequisities

* Installed Packages:
  * Supplychain:
    * Supply Chain (Supply-chain.apps.tanzu.vmware.com)
    * Supply Chain Catalog (Supply-chain-catalog.apps.tanzu.vmware.com)
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

* Use Tanzu Cartographer Wizard to Create Supply Chain with App-Scanning using either Trivy Supply Chain Component or a Component you created in the previous page.
```
$ tanzu cartographer supply-chain wizard --file example-supply-chain.yaml
? What should this supply chain be called? example-supply-chain-1.0.0
? Give the supply chain a description? TODO
? What Kind would you like to use as the developer interface? Example
? What group would you like to use for the developer interface? example.com
? What version would you like to use for the developer interface? v1alpha1
? Would you like to add stages to the supply chain now? Yes
? Select a Component to add? source-git-provider-1.0.0 (Monitors a git repository)
? Would you like to add another stage? Yes
? Select a Component to add? buildpack-build-1.0.0 (Builds an app with buildpacks using kpack)
? Would you like to add another stage? Yes
? Select a Component to add?  [Use arrows to move, type to filter]
  source-package-translator-1.0.0 (Takes the type source and immediately outputs it as type package.
In the future, will be replaced by input type mapping or some similar feature.
)
  conventions-1.0.0 (Use the Cartographer Conventions service to generate decorated pod template specs)
> trivy-image-scan-1.0.0 (Performs a trivy image scan using the scan 2.0 components)
  <SCANNING-COMPONENT> (Performs a <SCANNING> image scan using the scan 2.0 components)
```

Where:
* SCANNING-COMPONENT is the scanning component made in the previous page
* SCANNING is the scanner name of the scanning component made in the previous page

**Note:** See Tanzu Supply Chain [docs](../supply-chain/platform-engineering/how-to/supply-chain-authoring/construct-with-cli.hbs.md) how to construct a Supply Chain using the CLI

* Apply Supply Chain into the DEV-NAMESPACE where you plan to run workload
```
kubectl apply -f example-supply-chain.yaml -n DEV-NAMESPACE
```

# Upgrading Supply Chain Security Tools - Scan

This document describes how to upgrade Supply Chain Security Tools - Scan from the Tanzu Application Platform package repository.

You can perform a fresh install of Supply Chain Security Tools - Scan by following the instructions in [Install Supply Chain Security Tools - Scan](install-scst-scan.md) 

Here you can find instructions for:

1. [Prerequisites](#prereqs)

2. [General Upgrades for Supply Chain Security Tools - Scan](#general-upgrades)

3. Upgrading to:
   - [Version v1.2.0](#upgrade-to-1-2-0)


## <a id="prereqs"></a> Prerequisites

Before you upgrade Supply Chain Security Tools - Scan:

* Upgrade the Tanzu Application Platform following the instructions in [Upgrading Tanzu Application Platform](../upgrading.md) 

## <a id="general-upgrades"></a> General Upgrades for Supply Chain Security Tools - Scan

When you're upgrading to any version of Supply Chain Security Tools - Scan these are some of the factors you need to keep in top of mind for accomplish this task successfully: 

1. Check the [Release Notes](../release-notes.md) for the version you're upgrading to. There you can find if there is any breaking changes for the installation.
2. Get the values schema for the package version you're upgrading to using `tanzu package available get scanning.apps.tanzu.vmware.com/$VERSION --values-schema -n tap-install` where `$VERSION` is the new version. This will give you insights on the values you can configure in your `tap-values.yaml` for the new version.

## <a id="upgrade-to-1-2-0"></a> Upgrading to Version v1.2.0

If you're upgrading from a previous version of Supply Chain Security Tools - Scan to the version `v1.2.0` you have to follow these steps: 

1. Change the `SecretExports` from Supply Chain Security Tools - Store. 

  Supply Chain Security Tools - Scan need information to connect to the Supply Chain Security Tools - Store deployment, we need to change where this secrets are exported to in order to enable the connection with the version `v1.2.0` of Supply Chain Security Tools - Scan.

  **Single Cluster Deployment**

  Modify the `tap-values.yaml` file you have used to deploy Supply Chain Security Tools - Store to export the ca secret to your developer namespace. 

  ```yaml
  metadata_store:
      ns_for_export_app_cert: "<DEV-NAMESPACE>"
  ```

  >**Note:** The `ns_for_export_app_cert` currently supports only one namespace at a time. If you have multiple namespaces you could replace this value with a `"*"`, but this is discourage due to security reasons.

  Now update Tanzu Application Platform to apply the changes:

  ```console
  tanzu package installed update tap -f tap-values.yaml -n tap-install
  ```

  **Multi-Cluster Deployment**

  We need to reapply the SecretExport by changing the toNamespace: scan-link-system to toNamespace: `DEV-NAMESPACE`

  ```yaml
  ---
  apiVersion: secretgen.carvel.dev/v1alpha1
  kind: SecretExport
  metadata:
    name: store-ca-cert
    namespace: metadata-store-secrets
  spec:
    toNamespace: "<DEV-NAMESPACE>"
  ---
  apiVersion: secretgen.carvel.dev/v1alpha1
  kind: SecretExport
  metadata:
    name: store-auth-token
    namespace: metadata-store-secrets
  spec:
    toNamespace: "<DEV-NAMESPACE>"
  ```
 
2. Update your `tap-values.yaml` file.

  The installation of the Supply Chain Security Tools - Scan and the Grype scanner have some changes. The connection to the Supply Chain Security Tools - Store component have moved to the Grype scanner package. You need to disable the connection from the Supply Chain Security Tools - Scan, which is still present for backwards compatibility, but is deprecated and will be removed by `v1.3.0`.

  ```yaml
  # Disable scan controller embedded Supply Chain Security Tools - Store integration
  scanning:
    metadataStore:
      url: ""
  
  # Install Grype Scanner v1.2.0 
  grype:
    namespace: "<DEV-NAMESPACE>" # The developer namespace where the ScanTemplates are gonna be deployed
    metadataStore:
      url: "<METADATA-STORE-URL>" # The base URL where the Store deployment can be reached
      caSecret:
        name: "<CA-SECRET-NAME>" # The name of the secret containing the ca.crt
        importFromNamespace: "<SECRET-NAMESPACE>" # The namespace where Store is deployed (if single cluster) or where the connection secrets were created (if multi-cluster)
      authSecret:
        name: "<TOKEN-SECRET-NAME>" # The name of the secret containing the auth token to connect to Store
        importFromNamespace: "<SECRET-NAMESPACE>" # The namespace where the connection secrets were created (if multi-cluster)
  ```

  For more insights on how to install Grype, please check out [Install Supply Chain Security Tools - Scan (Grype Scanner)](install-scst-scan.md#install-grype).

  Note: If a mix of Grype templates (`<v1.2.0` and `≥v1.2.0`) are used, both `scanning` and `grype` need to configure the parameters, and the secret needs to export to both scan-link-system and the dev namespace (either by exporting to "*" or by defining multiple secrets and exports. (similarly if grype is installed to multiple namespaces there must be corresponding exports). See [Install Supply Chain Security Tools - Scan (Grype Scanner)](install-scst-scan.md#install-grype)

  Now update Tanzu Application Platform to apply the changes:

  ```console
  tanzu package installed update tap -f tap-values.yaml -n tap-install
  ```
 
3. Update the `ScanPolicy` to include the latest structure changes for `v1.2.0`.

  To update to the latest valid Rego File in the `ScanPolicy`, please take a look at the [Enforce compliance policy using Open Policy Agent](policies.md) page for insights and examples. The `v1.2.0` introduced some breaking changes in the Rego File structure used for the `ScanPolicies`, they're documented in the [Release Notes](../release-notes.md#scst-scan-changes).

4. Verify the upgrade.

  You could run any `ImageScan` or `SourceScan` in your `<DEV-NAMESPACE>` where the Grype Scanner was installed, and it should finish successfully. Here is a sample you can try to run to see if everything upgraded successfully.

  Create the `verify-upgrade.yaml` file in your system with the following content: 

  ```yaml
  ---
  apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
  kind: ScanPolicy
  metadata:
    name: scanpolicy-sample
  spec:
    regoFile: |
      package main

      # Accepted Values: "Critical", "High", "Medium", "Low", "Negligible", "UnknownSeverity"
      notAllowedSeverities := ["Critical", "High"]
      ignoreCves := []

      contains(array, elem) = true {
        array[_] = elem
      } else = false { true }

      isSafe(match) {
        fails := contains(notAllowedSeverities, match.ratings.rating[_])
        not fails
      }

      isSafe(match) {
        ignore := contains(ignoreCves, match.Id)
        ignore
      }

      deny[msg] {
        comp := input.bom.components.component[_]
        vuln := comp.vulnerabilities.vulnerability[_]
        ratings := vuln.ratings.rating[_]
        not isSafe(vuln)
        msg = sprintf("CVE %s %s %s", [comp.name, vuln.id, ratings])
      }
  ---
  apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
  kind: ImageScan
  metadata:
    name: sample-public-image-scan
  spec:
    registry:
      image: "nginx:1.16"
    scanTemplate: public-image-scan-template
    scanPolicy: scanpolicy-sample
  ```

  Deploy the resources

  ```console
  kubectl apply -f verify-upgrade.yaml -n <DEV-NAMESPACE>
  ```

  View the scan results

  ```console
  kubectl describe imagescan sample-public-image-scan -n <DEV-NAMESPACE>
  ```

  If everything is working properly, the `ImageScan` will go to the `Failed` phase and show the results of the scan in the `Status`. 
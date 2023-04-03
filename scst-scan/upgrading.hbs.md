# Upgrade Supply Chain Security Tools - Scan

This topic describes how to upgrade Supply Chain Security Tools - Scan from the Tanzu Application Platform package repository.

You can perform a fresh install of SCST - Scan by following the instructions in [Install Supply Chain Security Tools - Scan](install-scst-scan.md).

This topic includes instructions for:

- [Upgrade Supply Chain Security Tools - Scan](#upgrade-supply-chain-security-tools---scan)
  - [ Prerequisites](#-prerequisites)
  - [ General Upgrades for Supply Chain Security Tools - Scan](#-general-upgrades-for-supply-chain-security-tools---scan)
  - [ Upgrading the scanner in all namespaces](#-upgrading-the-scanner-in-all-namespaces)
    - [ Upgrading to Version v1.2.0](#-upgrading-to-version-v120)


## <a id="prereqs"></a> Prerequisites

Before you upgrade SCST - Scan:

* Upgrade the Tanzu Application Platform by following the instructions in [Upgrading Tanzu Application Platform](../upgrading.md)

## <a id="general-upgrades"></a> General Upgrades for Supply Chain Security Tools - Scan

When you're upgrading to any version of SCST - Scan these are some factors to accomplish this task:

1. Inspect the [Release Notes](../release-notes.md) for the version you're upgrading to. There you can find any breaking changes for the installation.
2. Get the values schema for the package version you're upgrading to by running:

  ```console
  tanzu package available get scanning.apps.tanzu.vmware.com/$VERSION --values-schema -n tap-install
  ```

   Where `$VERSION` is the new version. This gives you insights on the values you can configure in
   your `tap-values.yaml` for the new version.

## <a id="upgrade-scanner"></a> Upgrading the scanner in all namespaces
This section describes how to upgrade the scanner in all namespaces depending on the method of installation.

1. **Installation via Namespace Provisioner** All scanners installed by the Namespace provisioner in all managed namespaces are upgraded automatically. For example, if you upgrade your installation of Tanzu Application Platform and version of Grype gets updated, all the Grype scanners installed by Namespace provisioner for all managed namespaces will be automatically upgraded.

1. **Manual installation**

### <a id="upgrade-to-1-2-0"></a> Upgrading to Version v1.2.0

To upgrade from a previous version of SCST - Scan to the version `v1.2.0`:

1. Change the `SecretExports` from SCST - Store.

  SCST - Scan needs information to connect to the SCST - Store deployment, you must change where these secrets are exported to enable the connection with the version `v1.2.0` of SCST - Scan.

  **Single Cluster Deployment**

  Edit the `tap-values.yaml` file you used to deploy SCST - Store to export the CA certificate to your developer namespace.

  ```yaml
  metadata_store:
      ns_for_export_app_cert: "DEV-NAMESPACE"
  ```

  >**Note** The `ns_for_export_app_cert` supports one namespace at a time. If you have multiple namespaces you can replace this value with a `*`, but this exports the CA certificate to all namespaces. Consider whether this increased visibility presents a risk.

  Update Tanzu Application Platform to apply the changes:

  ```console
  tanzu package installed update tap -f tap-values.yaml -n tap-install
  ```

  **Multi-Cluster Deployment**

  You must reapply the SecretExport by changing the toNamespace: scan-link-system to Namespace: `DEV-NAMESPACE`

      ```yaml
      ---
      apiVersion: secretgen.carvel.dev/v1alpha1
      kind: SecretExport
      metadata:
        name: store-ca-cert
        namespace: metadata-store-secrets
      spec:
        toNamespace: "DEV-NAMESPACE"
      ---
      apiVersion: secretgen.carvel.dev/v1alpha1
      kind: SecretExport
      metadata:
        name: store-auth-token
        namespace: metadata-store-secrets
      spec:
        toNamespace: "DEV-NAMESPACE"
      ```

2. Update your `tap-values.yaml` file.

  The installation of the SCST - Scan and the Grype scanner have some changes. The connection to the SCST - Store component have moved to the Grype scanner package. To deactivate the connection from the SCST - Scan, which is still present for backwards compatibility, but is deprecated and is removed in `v1.3.0`.

      ```yaml
      # Deactivate scan controller embedded Supply Chain Security Tools - Store integration
      scanning:
        metadataStore:
          url: ""

      # Install Grype Scanner v1.2.0
      grype:
        namespace: "DEV-NAMESPACE" # The developer namespace where the ScanTemplates are gonna be deployed
        metadataStore:
          url: "METADATA-STORE-URL" # The base URL where the Store deployment can be reached
          caSecret:
            name: "CA-SECRET-NAME" # The name of the secret containing the ca.crt
            importFromNamespace: "SECRET-NAMESPACE" # The namespace where Store is deployed (if single cluster) or where the connection secrets were created (if multi-cluster)
          authSecret:
            name: "TOKEN-SECRET-NAME" # The name of the secret containing the auth token to connect to Store
            importFromNamespace: "SECRET-NAMESPACE" # The namespace where the connection secrets were created (if multi-cluster)
      ```

  For more insights on how to install Grype, see [Install Supply Chain Security Tools - Scan (Grype Scanner)](install-scst-scan.md#install-grype).

  >**Note** If a mix of Grype templates, such as earlier than v1.2.0 and
  >v1.2.0 and later, are used, both `scanning` and `grype` must configure the
  >parameters. The secret must also export to both scan-link-system and the developer
  >namespace. Do this by exporting to `*` or by defining multiple secrets and
  >exports. If Grype is installed to multiple namespaces there must be
  >corresponding exports. See [Install Supply Chain Security Tools - Scan (Grype
  >Scanner)](install-scst-scan.md#install-grype).

  Now update Tanzu Application Platform to apply the changes:

  ```console
  tanzu package installed update tap -f tap-values.yaml -n tap-install
  ```

3. Update the `ScanPolicy` to include the latest structure changes for `v1.2.0`.

  To update to the latest valid Rego File in the `ScanPolicy`, [Enforce compliance policy using Open Policy Agent](policies.md). `v1.2.0` introduced some breaking changes in the Rego File structure used for the `ScanPolicies`, See the [Release Notes](../release-notes.md#scst-scan-changes).

4. Verify the upgrade.

  You can run any `ImageScan` or `SourceScan` in your `<DEV-NAMESPACE>` where the Grype Scanner was installed, and it finishes. Here is a sample you can try to run to detect if everything upgraded.

  Create the `verify-upgrade.yaml` file in your system with the following content:

    ```yaml
    ---
    apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
    kind: ScanPolicy
    metadata:
      name: scan-policy
      labels:
        'app.kubernetes.io/part-of': 'enable-in-gui'
    spec:
      regoFile: |
        package main

        # Accepted Values: "Critical", "High", "Medium", "Low", "Negligible", "UnknownSeverity"
        notAllowedSeverities := ["Critical", "High", "UnknownSeverity"]
        ignoreCves := []

        contains(array, elem) = true {
          array[_] = elem
        } else = false { true }

        isSafe(match) {
          severities := { e | e := match.ratings.rating.severity } | { e | e := match.ratings.rating[_].severity }
          some i
          fails := contains(notAllowedSeverities, severities[i])
          not fails
        }

        isSafe(match) {
          ignore := contains(ignoreCves, match.id)
          ignore
        }

        deny[msg] {
          comps := { e | e := input.bom.components.component } | { e | e := input.bom.components.component[_] }
          some i
          comp := comps[i]
          vulns := { e | e := comp.vulnerabilities.vulnerability } | { e | e := comp.vulnerabilities.vulnerability[_] }
          some j
          vuln := vulns[j]
          ratings := { e | e := vuln.ratings.rating.severity } | { e | e := vuln.ratings.rating[_].severity }
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
      scanPolicy: scan-policy
    ```

  Deploy the resources

  ```console
  kubectl apply -f verify-upgrade.yaml -n DEV-NAMESPACE
  ```

  View the scan results

  ```console
  kubectl describe imagescan sample-public-image-scan -n DEV-NAMESPACE
  ```

  If it is successful, the `ImageScan` goes to the `Failed` phase and shows the results of the scan in the `Status`.

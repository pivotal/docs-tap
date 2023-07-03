# Upgrade Supply Chain Security Tools - Scan

This topic describes how you can upgrade Supply Chain Security Tools - Scan from the
Tanzu Application Platform package repository.

You can perform a fresh install of SCST - Scan by following the instructions in
[Install Supply Chain Security Tools - Scan](install-scst-scan.md).

## <a id="prereqs"></a> Prerequisites

Before you upgrade SCST - Scan, upgrade the Tanzu Application Platform by following the instructions
in [Upgrading Tanzu Application Platform](../upgrading.md).

## <a id="general-upgrades"></a> General Upgrades for SCST - Scan

When you're upgrading to any version of SCST - Scan these are some factors to accomplish this task:

1. Inspect the [Release Notes](../release-notes.md) for the version you're upgrading to.
There you can find any breaking changes for the installation.

2. Get the values schema for the package version you're upgrading to by running:

    ```console
    tanzu package available get scanning.apps.tanzu.vmware.com/$VERSION --values-schema -n tap-install
    ```

    Where `$VERSION` is the new version. This gives you insights on the values you can configure in
    your `tap-values.yaml` for the new version.

## <a id="upgrade-scanner"></a> Upgrading a scanner in all namespaces

This section describes how to upgrade a supported scanner in all namespaces.
The procedure is different depending on the installation method:

1. Installation by using Namespace Provisioner
2. Manual installation

### <a id="upgrade-scanner-nsp"></a> Installation by using Namespace Provisioner

All scanners installed by the Namespace Provisioner in all managed namespaces
are upgraded automatically. For example, if you upgrade your installation of
Tanzu Application Platform and the version of Grype is updated, all Grype
scanners installed by the Namespace Provisioner for all managed namespaces are
automatically upgraded.

### <a id="upgrade-scanner-manual"></a> Manual installation

1. If a scanner, such as Grype Scanner, was installed as part of Tanzu Application Platform by using
the [full profile](../install-online/profile.hbs.md#full-profile), run to upgrade:

    ```console
    tanzu package installed update tap -p tap.tanzu.vmware.com -v VERSION --values-file tap-values.yaml -n tap-install
    ```

    Where `VERSION` is your Tanzu Application Platform version.

1. If a scanner, such as Grype Scanner, was installed by using
[component installation](../install-online/components.hbs.md) you must manually run:

    ```console
    tanzu package installed update grype -p grype.scanning.apps.tanzu.vmware.com -v GRYPE-VERSION --values-file grype-values.yaml -n NAMESPACE
    ```

    Where:

    - `GRYPE-VERSION` is the version of Grype that you are upgrading to.
    - `NAMESPACE` is the namespace in which Grype is installed in.

## <a id="upgrade-to-1-2-0"></a> Upgrade to Version v1.2.0

To upgrade from a previous version of SCST - Scan to the version `v1.2.0`:

1. Change the `SecretExports` from SCST - Store.

    SCST - Scan needs information to connect to the SCST - Store deployment, you must change where these
    secrets are exported to enable the connection with the version `v1.2.0` of SCST - Scan.

    - **For a single cluster deployment:**

        1. Edit the `tap-values.yaml` file you used to deploy SCST - Store to export the CA certificate
        to your developer namespace.

            ```yaml
            metadata_store:
                ns_for_export_app_cert: "DEV-NAMESPACE"
            ```

            > **Note** The `ns_for_export_app_cert` supports one namespace at a time. If you have
            > multiple namespaces you can replace this value with a `*`, but this exports the CA
            > certificate to all namespaces. Consider whether this increased visibility presents a risk.

        1. Update Tanzu Application Platform to apply the changes:

            ```console
            tanzu package installed update tap -f tap-values.yaml -n tap-install
            ```

    - **For a multi-cluster deployment:**

        You must reapply the SecretExport by changing the `toNamespace: scan-link-system` to
        `Namespace: DEV-NAMESPACE`

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
      namespace: "DEV-NAMESPACE" # The developer namespace where the ScanTemplates are going to be deployed
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

    To update to the latest valid Rego File in the `ScanPolicy`,
    [Enforce compliance policy using Open Policy Agent](policies.md).
    `v1.2.0` introduced some breaking changes in the Rego File structure used for the `ScanPolicies`.
    For more information, see the [Release Notes](../release-notes.md#scst-scan-changes).

4. Verify the upgrade.

    You can run any `ImageScan` or `SourceScan` in your `DEV-NAMESPACE` where the Grype Scanner was
    installed, and it finishes. Here is a sample you can try to run to detect if everything upgraded.

    1. Create the `verify-upgrade.yaml` file in your system with the following content:

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

    1. Deploy the resources

        ```console
        kubectl apply -f verify-upgrade.yaml -n DEV-NAMESPACE
        ```

    1. View the scan results

        ```console
        kubectl describe imagescan sample-public-image-scan -n DEV-NAMESPACE
        ```

    If it is successful, the `ImageScan` goes to the `Failed` phase and shows the results of the scan
    in the `Status`.

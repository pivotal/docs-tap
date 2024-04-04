# Install another scanner for Supply Chain Security Tools - Scan

This topic describes how you can install scanners to work with Supply Chain Security Tools - Scan from the Tanzu Application Platform package repository.

Follow the instructions in this topic to install a scanner other than the out of the box Grype Scanner with SCST - Scan.

## <a id="prerecs"></a> Prerequisites

Before installing a new scanner, install [Supply Chain Security Tools - Scan](./install-scst-scan.hbs.md). It must be present on the same cluster. The prerequisites for Scan are also required.

## <a id="installation"></a> Install

To install a new scanner, follow these steps:

1. Complete scanner specific prerequisites for the scanner you're trying to install. For example, creating an API token to connect to the scanner.

   - [Snyk Scanner (Beta)](install-snyk-integration.hbs.md) is available for image scanning.
   - [Carbon Black Scanner (Beta)](install-carbonblack-integration.hbs.md) is available for image scanning.
1. List the available packages to discover what scanners you can use by running:

    ```console
    tanzu package available list --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list --namespace tap-install
    / Retrieving available packages...
      NAME                                                 DISPLAY-NAME                                                              SHORT-DESCRIPTION
      grype.scanning.apps.tanzu.vmware.com                 Grype Scanner for Supply Chain Security Tools - Scan                      Default scan templates using Anchore Grype
      snyk.scanning.apps.tanzu.vmware.com                  Snyk for Supply Chain Security Tools - Scan                               Default scan templates using Snyk
      carbonblack.scanning.apps.tanzu.vmware.com           Carbon Black Scanner for Supply Chain Security Tools - Scan               Default scan templates using Carbon Black
    ```

1. List version information for the scanner package by running:

    ```console
    tanzu package available list SCANNER-NAME --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list snyk.scanning.apps.tanzu.vmware.com --namespace tap-install
    / Retrieving package versions for snyk.scanning.apps.tanzu.vmware.com...
      NAME                                  VERSION           RELEASED-AT
      snyk.scanning.apps.tanzu.vmware.com   1.0.0-beta.2
    ```

1. (Optional) Confirm that the secret created in Step 1 for scanner specific prerequisites is created.

1. Create a `values.yaml` to apply custom configurations to the scanner:

    > **Note** This step might be required for some scanners but optional for others.

    To list the values you can configure for any scanner, run:

    ```console
    tanzu package available get SCANNER-NAME/VERSION --values-schema -n tap-install
    ```

    Where:

    - `SCANNER-NAME` is the name of the scanner package you retrieved earlier.
    - `VERSION` is your package version number. For example, `snyk.scanning.apps.tanzu.vmware.com/1.0.0-beta.2`.

    For example:

    ```console
    $ tanzu package available get snyk.scanning.apps.tanzu.vmware.com/1.0.0-beta.2 --values-schema -n tap-install

    KEY                                           DEFAULT                                                           TYPE    DESCRIPTION
    metadataStore.authSecret.name                                                                                   string  Name of deployed Secret with key auth_token
    metadataStore.authSecret.importFromNamespace                                                                    string  Namespace from which to import the Insight Metadata Store auth_token
    metadataStore.caSecret.importFromNamespace    metadata-store                                                    string  Namespace from which to import the Insight Metadata Store CA Cert
    metadataStore.caSecret.name                   app-tls-cert                                                      string  Name of deployed Secret with key ca.crt holding the CA Cert of the Insight Metadata Store
    metadataStore.clusterRole                     metadata-store-read-write                                         string  Name of the deployed ClusterRole for read/write access to the Insight Metadata Store deployed in the same cluster
    metadataStore.url                             https://metadata-store-app.metadata-store.svc.cluster.local:8443  string  Url of the Insight Metadata Store
    namespace                                     default                                                           string  Deployment namespace for the Scan Templates
    resources.requests.cpu                        250m                                                              <nil>   Requests describes the minimum amount of cpu resources required.
    resources.requests.memory                     128Mi                                                             <nil>   Requests describes the minimum amount of memory resources required.
    resources.limits.cpu                          1000m                                                             <nil>   Limits describes the maximum amount of cpu resources allowed.
    snyk.tokenSecret.name                                                                                           string  Reference to the secret containing a Snyk API Token as snyk_token.
    targetImagePullSecret                                                                                           string  Reference to the secret used for pulling images from private registry.
    ```

1. Define the `--values-file` flag to customize the default configuration:

    The `values.yaml` file you created earlier is referenced with the `--values-file` flag when running your Tanzu install command:

    ```console
    tanzu package install REFERENCE-NAME \
      --package SCANNER-NAME \
      --version VERSION \
      --namespace tap-install \
      --values-file PATH-TO-VALUES-YAML
    ```

    Where:

    - `REFERENCE-NAME` is the name referenced by the installed package. For example, `grype-scanner`, `snyk-scanner`.
    - `SCANNER-NAME` is the name of the scanner package you retrieved earlier. For example, `snyk.scanning.apps.tanzu.vmware.com`.
    - `VERSION` is your package version number. For example, `1.0.0-beta.2`.
    - `PATH-TO-VALUES-YAML` is the path that points to the `values.yaml` file created earlier.

    For example:

    ```console
    $ tanzu package install snyk-scanner \
      --package snyk.scanning.apps.tanzu.vmware.com \
      --version 1.1.0 \
      --namespace tap-install \
      --values-file values.yaml
    / Installing package 'snyk.scanning.apps.tanzu.vmware.com'
    | Getting namespace 'tap-install'
    | Getting package metadata for 'snyk.scanning.apps.tanzu.vmware.com'
    | Creating service account 'snyk-scanner-tap-install-sa'
    | Creating cluster admin role 'snyk-scanner-tap-install-cluster-role'
    | Creating cluster role binding 'snyk-scanner-tap-install-cluster-rolebinding'
    / Creating package resource
    - Package install status: Reconciling

     Added installed package 'snyk-scanner' in namespace 'tap-install'
    ```

## Verify Installation

To verify the installation create an `ImageScan` or `SourceScan` referencing one of the newly added `ScanTemplates` for the scanner.

1. (Optional) Create a `ScanPolicy` formatted for the output specific to the scanner you are installing, to reference in the `ImageScan` or `SourceScan`.

    ```console
      kubectl apply -n $DEV_NAMESPACE -f SCAN-POLICY-YAML
    ```

    > **Note** As vulnerability scanners output different formats, the `ScanPolicies` can vary. For information about policies and samples, see [Enforce compliance policy using Open Policy Agent](policies.hbs.md).

1. Retrieve available `ScanTemplates` from the namespace where the scanner is installed:

    ```console
    kubectl get scantemplates -n DEV-NAMESPACE
    ```

    Where `DEV-NAMESPACE` is the developer namespace where the scanner is installed.

    For example:

    ```console
    $ kubectl get scantemplates
    NAME                               AGE
    blob-source-scan-template          10d
    private-image-scan-template        10d
    public-image-scan-template         10d
    public-source-scan-template        10d
    snyk-private-image-scan-template   10d
    snyk-public-image-scan-template    10d
    ```

1. Create the following ImageScan YAML:

    > **Note** Some scanners do not support both `ImageScan` and `SourceScan`.

    ```yaml
    apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
    kind: ImageScan
    metadata:
      name: sample-scanner-public-image-scan
    spec:
      registry:
        image: "nginx:1.16"
      scanTemplate: SCAN-TEMPLATE
      scanPolicy: SCAN-POLICY # Optional
    ```

    Where:

    - `SCAN-TEMPLATE` is the name of the installed `ScanTemplate` in the `DEV-NAMESPACE` you retrieved earlier.
    - `SCAN-POLICY` it's an optional reference to an existing `ScanPolicy` in the same `DEV-NAMESPACE`.

    For example:

    ```yaml
    apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
    kind: ImageScan
    metadata:
      name: sample-snyk-public-image-scan
    spec:
      registry:
        image: "nginx:1.16"
      scanTemplate: snyk-public-image-scan-template
      scanPolicy: snyk-scan-policy
    ```

1. Create the following SourceScan YAML:

    > **Note** Some scanners do not support both `ImageScan` and `SourceScan`.

    ```yaml
    apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
    kind: SourceScan
    metadata:
      name: sample-scanner-public-source-scan
    spec:
      git:
        url: "https://github.com/houndci/hound.git"
        revision: "5805c650"
      scanTemplate: SCAN-TEMPLATE
      scanPolicy: SCAN-POLICY # Optional
    ```

    Where:

    - `SCAN-TEMPLATE` is the name of the installed `ScanTemplate` in the `DEV-NAMESPACE` you retrieved earlier.
    - `SCAN-POLICY` is an optional reference to an existing `ScanPolicy` in the same `DEV-NAMESPACE`.

    For example:

    ```yaml
    apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
    kind: SourceScan
    metadata:
      name: sample-grype-public-source-scan
    spec:
      git:
        url: "https://github.com/houndci/hound.git"
        revision: "5805c650"
      scanTemplate: public-source-scan-template
      scanPolicy: scan-policy
    ```

1. Apply the ImageScan and SourceScan YAMLs:

    To run the scans, apply them to the cluster by running these commands:

    `ImageScan`:
    ```console
    kubectl apply -f PATH-TO-IMAGE-SCAN-YAML -n DEV-NAMESPACE
    ```

    Where `PATH-TO-IMAGE-SCAN-YAML` is the path to the YAML file created earlier.

    `SourceScan`:
    ```console
    kubectl apply -f PATH-TO-SOURCE-SCAN-YAML -n DEV-NAMESPACE
    ```

    Where `PATH-TO-SOURCE-SCAN-YAML` is the path to the YAML file created earlier.

    For example:

    ```console
    $ kubectl apply -f imagescan.yaml -n my-apps
    imagescan.scanning.apps.tanzu.vmware.com/sample-snyk-public-image-scan created

    $ kubectl apply -f sourcescan.yaml -n my-apps
    sourcescan.scanning.apps.tanzu.vmware.com/sample-grype-public-source-scan created
    ```

1. To verify the integration, get the scan to see if it completed by running:

    For `ImageScan`:

    ```console
    kubectl get imagescan IMAGE-SCAN-NAME -n DEV-NAMESPACE
    ```

    Where `IMAGE-SCAN-NAME` is the name of the `ImageScan` as defined in the YAML file created earlier.

    For `SourceScan`:
    ```console
    kubectl get sourcescan SOURCE-SCAN-NAME -n DEV-NAMESPACE
    ```

    Where `SOURCE-SCAN-NAME` is the name of the `SourceScan` as defined in the YAML file created earlier.

    For example:

    ```console
    $ kubectl get imagescan sample-snyk-public-image-scan -n my-apps
    NAME                            PHASE       SCANNEDIMAGE   AGE   CRITICAL   HIGH   MEDIUM   LOW   UNKNOWN   CVETOTAL
    sample-snyk-public-image-scan   Completed   nginx:1.16     26h   0          114    58       314   0         486

    $ kubectl get sourcescan sample-grype-public-source-scan -n my-apps
    NAME                                                                      PHASE       SCANNEDREVISION   SCANNEDREPOSITORY                      AGE     CRITICAL   HIGH   MEDIUM   LOW   UNKNOWN   CVETOTAL
    sourcescan.scanning.apps.tanzu.vmware.com/grypesourcescan-sample-public   Completed   5805c650          https://github.com/houndci/hound.git   8m34s   21         121    112      9     0         263
    ```

    > **Note** If you define a `ScanPolicy` for the scans and the evaluation finds a violation, the `Phase` is `Failed` instead of `Completed`. In both cases the scan finished.

1. Clean up:

    ```console
    kubectl delete -f PATH-TO-SCAN-YAML -n DEV-NAMESPACE
    ```

    Where `PATH-TO-SCAN-YAML` is the path to the YAML file created earlier.


## <a id="install-to-multiple-namespaces"></a> Install scanner to multiple namespaces

To install a Scanner to multiple namespaces, VMware recommends using a namespace provisioner. See [Namespace Provisioner](../namespace-provisioner/about.hbs.md)


## <a id="configure-supply-chain"></a> Configure Tanzu Application Platform Supply Chain to use new scanner

In order to scan your images with the new scanner installed in the [Out of the Box Supply Chain with Testing and Scanning](../scc/ootb-supply-chain-testing-scanning.hbs.md), you must update your Tanzu Application Platform installation.

Add the `ootb_supply_chain_testing_scanning.scanning` section to your `tap-values.yaml` and perform a [Tanzu Application Platform update](../upgrading.hbs.md#perform-the-upgrade-of-tanzu-application-platform).

You can define which `ScanTemplates` is used for both `SourceScan` and `ImageScan`. The default values are the Grype Scanner `ScanTemplates`, but they are overwritten by any other `ScanTemplate` present in your `DEV-NAMESPACE`. The same applies to the `ScanPolicies` applied to each kind of scan.

```yaml
ootb_supply_chain_testing_scanning:
  scanning:
    image:
      template: IMAGE-SCAN-TEMPLATE
      policy: IMAGE-SCAN-POLICY
    source:
      template: SOURCE-SCAN-TEMPLATE
      policy: SOURCE-SCAN-POLICY
```

> **Note** For the Supply Chain to work properly, the `SOURCE-SCAN-TEMPLATE` must support blob files and the `IMAGE-SCAN-TEMPLATE` must support private images.

For example:

```yaml
ootb_supply_chain_testing_scanning:
  scanning:
    image:
      template: snyk-private-image-scan-template
      policy: snyk-scan-policy
    source:
      template: blob-source-scan-template
      policy: scan-policy
```

## Uninstall Scanner

To replace the scanner in the Supply Chain, follow the steps mentioned in [Configure TAP Supply Chain to Use New Scanner](#configure-supply-chain). After the scanner is no longer required by the Supply Chain, you can remove the package by running:

```console
tanzu package installed delete REFERENCE-NAME \
    --namespace tap-install
```

Where `REFERENCE-NAME` is the name you identified the package with, when installing in the [Install](#installation) section. For example, `grype-scanner`, `snyk-scanner`.

For example:

```console
$ tanzu package installed delete snyk-scanner \
    --namespace tap-install
```

## <a id="other-scanner-integrations"></a> Other Available Scanner Integrations

In addition to providing the above supported integrations, VMware encourages the broader community to support VMware in our goal of integrating with customers' preferred CVE scanners.

Additional integrations:

- [Prisma Scanner (Alpha)](install-prisma-integration.hbs.md) is available for source and image scanning. 
- [Trivy Scanner (Alpha)](install-trivy-integration.hbs.md) is available for source and image scanning.

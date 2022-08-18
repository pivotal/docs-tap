# Installing Scanners for Supply Chain Security Tools - Scan

This document describes how to install scanners to work with Supply Chain Security Tools - Scan from the Tanzu Application Platform package repository.

## <a id="prerecs"></a> Prerequisites

Before installing a new scanner:

- Install [Supply Chain Security Tools - Scan](install-scst-scan.md). It must be present on the same cluster. The prerequisites for Scan are also required.
- The prerequisites for the scanner you're trying to install must be completed. e.g.: Creating an API token to connect to the scanner.

## <a id="installation"></a> Install

To install a new scanner, please follow these steps:

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
      carbonblack.scanning.apps.tanzu.vmware.com           <CARBON_BLACK_PLACEHOLDER>                                                <CARBON_BLACK_PLACEHOLDER>
    ```

2. List version information for the scanner package by running:
    ```console
    tanzu package available list <SCANNER_NAME> --namespace tap-install
    ```

    For example:
    ```console
    $ tanzu package available list snyk.scanning.apps.tanzu.vmware.com --namespace tap-install
    / Retrieving package versions for snyk.scanning.apps.tanzu.vmware.com...
      NAME                                  VERSION           RELEASED-AT
      snyk.scanning.apps.tanzu.vmware.com   1.0.0-beta.2
    ```

3. (Optional) Create the secrets the scanner package will rely on:

    Take a look at the [Available Scanners Docs](#) to look at the specifics for your choosen scanner.

4. Create a `values.yaml` to apply custom configurations to the scanner:

    > **Note**: This step could be required for some scanners but optional for others.

    To list the values you can configure for any scanner, run the following command:

    ```console
    tanzu package available get <SCANNER_NAME>/<VERSION> --values-schema -n tap-install
    ```

    Where `SCANNER_NAME` is the name of the scanner package you retrieved in step 1 and `VERSION` is your package version number. For example, `snyk.scanning.apps.tanzu.vmware.com/1.0.0-beta.2`.

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

5. Define the `--values-file` flag to customize the default configuration:

    The `values.yaml` file you created in step 4 should be referenced with the `--values-file` flag when running your tanzu install command: 

    ```console
    tanzu package install <REFERENCE_NAME> \
      --package-name <SCANNER_NAME> \
      --version <VERSION> \
      --namespace tap-install \
      --values-file <PATH_TO_VALUES_YAML>
    ```

    Where:
    
    * TODO: Reword this sentence. `<REFERENCE_NAME>` will be how you choose to name the installed package to distinguish from others. e.g.: `grype-scanner`, `snyk-scanner-my-apps`
    * `<SCANNER_NAME>` is the name of the scanner package you retrieved in step 1. e.g.: `snyk.scanning.apps.tanzu.vmware.com`
    * `<VERSION>` is your package version number. For example, `1.0.0-beta.2`.
    * `<PATH_TO_VALUES_YAML>` is the path that points to the `values.yaml` file created in setp 4.

    For example:

    ```console
    $ tanzu package install snyk-scanner \
      --package-name snyk.scanning.apps.tanzu.vmware.com \
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

>**Note**: An `ScanPolicy` can also be referenced in the `ImageScan` or `SourceScan`. Since every scanner can have its output in a different format, the `ScanPolicies` can vary from scanner to scanner. Please refer [Enforce compliance policy using Open Policy Agent ](policies.hbs.md) for more information around this topic.


1. Retrieve available `ScanTemplates` from the namespace where the scanner is installed in:

    ```console
    kubectl get scantemplates -n <DEV_NAMESPACE>
    ```

    Where `<DEV_NAMESPACE>` is the developer namespace where the scanner is installed in.

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

2. Create the following ImageScan YAML:

    >**Note**: Some scanners do not support both `ImageScan` and `SourceScan`. Please refer to the [Available Scanners Docs](#) to look at the specifics for your choosen scanner.

    ```yaml
    apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
    kind: ImageScan
    metadata:
      name: sample-scanner-public-image-scan
    spec:
      registry:
        image: "nginx:1.16"
      scanTemplate: <SCAN_TEMPLATE>
      scanPolicy: <SCAN_POLICY> # Optional
    ```

    Where `<SCAN_TEMPLATE>` would be the name of the installed `ScanTemplate` in the `DEV_NAMESPACE` you retrieved in step 1, and `<SCAN_POLICY>` it's an optional reference to an existing `ScanPolicy` in the same `DEV_NAMESPACE`.

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

3. Create the following SourceScan YAML:

    >**Note**: Some scanners do not support both `ImageScan` and `SourceScan`. Please refer to the [Available Scanners Docs](#) to look at the specifics for your choosen scanner.

    ```yaml
    apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
    kind: SourceScan
    metadata:
      name: sample-scanner-public-source-scan
    spec:
      git:
        url: "https://github.com/houndci/hound.git"
        revision: "5805c650"
      scanTemplate: <SCAN_TEMPLATE>
      scanPolicy: <SCAN_POLICY> # Optional
    ```

    Where `<SCAN_TEMPLATE>` would be the name of the installed `ScanTemplate` in the `DEV_NAMESPACE` you retrieved in step 1, and `<SCAN_POLICY>` it's an optional reference to an existing `ScanPolicy` in the same `DEV_NAMESPACE`.

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

4. Apply the ImageScan and SourceScan YAMLs:

    To run the scans please apply them to the cluster running the following commands:
    For `ImageScan`:
    ```console
    kubectl apply -f <PATH_TO_IMAGE_SCAN_YAML> -n <DEV_NAMESPACE>
    ```
    Where `<PATH_TO_IMAGE_SCAN_YAML>` is the path to the YAML file created in step 2.

    For `SourceScan`:
    ```console
    kubectl apply -f <PATH_TO_SOURCE_SCAN_YAML> -n <DEV_NAMESPACE>
    ```
    Where `<PATH_TO_SOURCE_SCAN_YAML>` is the path to the YAML file created in step 3.

    For example:
    ```console
    $ kubectl apply -f imagescan.yaml -n my-apps
    imagescan.scanning.apps.tanzu.vmware.com/sample-snyk-public-image-scan created

    $ kubectl apply -f sourcescan.yaml -n my-apps
    sourcescan.scanning.apps.tanzu.vmware.com/sample-grype-public-source-scan created
    ```

5. To verify the integration, get the scan to see if it completed successfully by running:

    For `ImageScan`:
    ```console
    kubectl get imagescan <IMAGE_SCAN_NAME> -n <DEV_NAMESPACE>
    ```
    Where `<IMAGE_SCAN_NAME>` is the name of the `ImageScan` as defined in the YAML file created in step 2.

    For `SourceScan`:
    ```console
    kubectl get sourcescan <SOURCE_SCAN_NAME> -n <DEV_NAMESPACE>
    ```
    Where `<SOURCE_SCAN_NAME>` is the name of the `SourceScan` as defined in the YAML file created in step 3.

    For example:

    ```console
    $ kubectl get imagescan sample-snyk-public-image-scan -n my-apps
    NAME                            PHASE       SCANNEDIMAGE   AGE   CRITICAL   HIGH   MEDIUM   LOW   UNKNOWN   CVETOTAL
    sample-snyk-public-image-scan   Completed   nginx:1.16     26h   0          114    58       314   0         486

    $ kubectl get sourcescan sample-grype-public-source-scan -n my-apps
    NAME                                                                      PHASE       SCANNEDREVISION   SCANNEDREPOSITORY                      AGE     CRITICAL   HIGH   MEDIUM   LOW   UNKNOWN   CVETOTAL
    sourcescan.scanning.apps.tanzu.vmware.com/grypesourcescan-sample-public   Completed   5805c650          https://github.com/houndci/hound.git   8m34s   21         121    112      9     0         263
    ```

    >**Note**: If you define a `ScanPolicy` for the scans and the evaluation finds a violation, then the `Phase` would be `Failed` instead of `Completed`. In both cases the scan finnished successfully.

6. Clean-up:

    ```console
    kubectl delete -f <PATH_TO_SCAN_YAML> -n <DEV_NAMESPACE>
    ```

    Where `<PATH_TO_SCAN_YAML>` is the path to the YAML file created in step 3.

## <a if="configure-supply-chain"></a> Configure TAP Supply Chain to Use New Scanner

In order to scan your images with the new scanner installed in the [Out of the Box Supply Chain with Testing and Scanning](../scc/ootb-supply-chain-testing-scanning.md), you must update your Tanzu Application Platform installation.

Add the `ootb_supply_chain_testing_scanning.scanning` section to your `tap-values.yaml` and perform a [Tanzu Application Platform update](../upgrading.md#upgrading-tanzu-application-platform).

In this file you can define which `ScanTemplates` will be used for both `SourceScan` and `ImageScan`. The default values are the Grype Scanner `ScanTemplates`, but it can be overwritten by any other `ScanTemplate` present in your `DEV_NAMESPACE`. The same applies to the `ScanPolicies` applied to each kind of scan.

```yaml
ootb_supply_chain_testing_scanning:
  scanning:
    image:
      template: <IMAGE_SCAN_TEMPLATE>
      policy: <IMAGE_SCAN_POLICY>
    source:
      template: <SOURCE_SCAN_TEMPLATE>
      policy: <SOURCE_SCAN_POLICY>
```

Please note that for the Supply Chain to work properly, the `<SOURCE_SCAN_TEMPLATE>` must support blob files and the `<IMAGE_SCAN_TEMPLATE>` must support private images.

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

To replace the scanner in the Supply Chain just follow the steps mentioned in [Configure TAP Supply Chain to Use New Scanner](#configure-supply-chain). After the scanner is not longer required by the Supply Chain, you can remove the package by running: 

```console
tanzu package installed delete <REFERENCE_NAME> \
    --namespace tap-install
```

Where `<REFERENCE_NAME>` is the name you identified the package with, when installing in the [Install](#installation) section. e.g.: `grype-scanner`, `snyk-scanner`.

For example:

```console
$ tanzu package installed delete snyk-scanner \
    --namespace tap-install
```
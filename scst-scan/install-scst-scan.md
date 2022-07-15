# Install Supply Chain Security Tools - Scan

This document describes how to install Supply Chain Security Tools - Scan
from the Tanzu Application Platform package repository.

>**Note:** Use the instructions on this page if you do not want to use a profile to install packages.
The full profile includes Supply Chain Security Tools - Scan.
For more information about profiles, see [About Tanzu Application Platform components and profiles](../about-package-profiles.md).

## <a id='scst-scan-prereqs'></a> Prerequisites

Before installing Supply Chain Security Tools - Scan:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).
- Install [Supply Chain Security Tools - Store](../scst-store/install-scst-store.md) for scan results to persist. The integration with Supply Chain Security Tools - Store can be handled in:
  - **Single Cluster:** The Supply Chain Security Tools - Store is present in the same cluster where Supply Chain Security Tools - Scan and the `ScanTemplates` will be present.
  - **Multi-Cluster:** The Supply Chain Security Tools - Store is present in a different cluster (e.g.: view cluster) where the Supply Chain Security Tools - Scan and `ScanTemplates` will be present.
  - **Integration Disabled:** The Supply Chain Security Tools - Scan deployment doesn't need to communicate with Supply Chain Security Tools - Store. 

    For usage instructions, see [Using the Supply Chain Security Tools - Store](../scst-store/overview.md).

- Install the Tanzu Insight CLI plug-in to query the Supply Chain Security Tools - Store for CVE results.
  See [Install the Tanzu Insight CLI plug-in](../cli-plugins/insight/cli-installation.md).

## <a id='install-scst-scan'></a> Install

The installation for Supply Chain Security Tools – Scan involves installing two packages:

- Scan controller
- Grype scanner

The Scan controller enables you to use a scanner, in this case, the Grype scanner. Ensure both the Grype scanner and the Scan controller are installed.

To install Supply Chain Security Tools - Scan (Scan controller):

1. List version information for the package by running:

    ```console
    tanzu package available list scanning.apps.tanzu.vmware.com --namespace tap-install
    ```

     For example:

    ```console
    $ tanzu package available list scanning.apps.tanzu.vmware.com --namespace tap-install
    / Retrieving package versions for scanning.apps.tanzu.vmware.com...
      NAME                             VERSION       RELEASED-AT
      scanning.apps.tanzu.vmware.com   1.1.0
    ```

1. (Optional) Make changes to the default installation settings:

    If you're using the Grype Scanner `≥v1.2.0`, or the Snyk Scanner, the following scanning configuration can disable the embedded Supply Chain Security Tools - Store integration with a `scan-values.yaml` file like this:

    ```yaml
    ---
    metadataStore:
      url: ""
    ```

    If you're using the Grype Scanner `<1.2.0`, the scanning configuration needs to configure the store parameters. See the [v1.1 docs](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.1/tap/GUID-scst-scan-install-scst-scan.html) for reference.


    You can retrieve any other configurable setting using the following command, and appending the key-value pair to the previous `scan-values.yaml` file:

    ```console
    tanzu package available get scanning.apps.tanzu.vmware.com/VERSION --values-schema -n tap-install
    ```

    Where `VERSION` is your package version number. For example, `1.1.0`.

2. Install the package by running:

    ```console
    tanzu package install scan-controller \
      --package-name scanning.apps.tanzu.vmware.com \
      --version VERSION \
      --namespace tap-install \
      --values-file scan-values.yaml
    ```

    Where `VERSION` is your package version number. For example, `1.1.0`.

<a id="install-grype"></a> To install Supply Chain Security Tools - Scan (Grype scanner):

1. List version information for the package by running:

    ```console
    tanzu package available list grype.scanning.apps.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list grype.scanning.apps.tanzu.vmware.com --namespace tap-install
    / Retrieving package versions for grype.scanning.apps.tanzu.vmware.com...
      NAME                                  VERSION       RELEASED-AT
      grype.scanning.apps.tanzu.vmware.com  1.1.0
    ```

1. (Optional) Make changes to the default installation settings:

    You need to define the configuration for the Supply Chain Security Tools - Store integration in the `grype-values.yaml` file for the Grype Scanner: 

    ```yaml
    ---
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
    >**Note:** You must either define both the METADATA-STORE-URL and caSecret, or not define them as they depend on each other.

    You can retrieve any other configurable setting using the following command, and appending the key-value pair to the previous `grype-values.yaml` file:

    ```console
    tanzu package available get grype.scanning.apps.tanzu.vmware.com/VERSION --values-schema -n tap-install
    ```

    Where `VERSION` is your package version number. For example, `1.1.0`.

    For example:

    ```console
    $ tanzu package available get grype.scanning.apps.tanzu.vmware.com/1.1.0 --values-schema -n tap-install
    | Retrieving package details for grype.scanning.apps.tanzu.vmware.com/1.1.0...
      KEY                        DEFAULT  TYPE    DESCRIPTION
      namespace                  default  string  Deployment namespace for the Scan Templates
      resources.limits.cpu       1000m    <nil>   Limits describes the maximum amount of cpu resources allowed.
      resources.requests.cpu     250m     <nil>   Requests describes the minimum amount of cpu resources required.
      resources.requests.memory  128Mi    <nil>   Requests describes the minimum amount of memory resources required.
      targetImagePullSecret      <EMPTY>  string  Reference to the secret used for pulling images from private registry.
      targetSourceSshSecret      <EMPTY>  string  Reference to the secret containing SSH credentials for cloning private repositories.
    ```

1. Install the package by running:

    ```console
    tanzu package install grype-scanner \
      --package-name grype.scanning.apps.tanzu.vmware.com \
      --version VERSION \
      --namespace tap-install \
      --values-file grype-values.yaml
    ```

    Where `VERSION` is your package version number. For example, `1.1.0`.

    For example:

    ```console
    $ tanzu package install grype-scanner \
      --package-name grype.scanning.apps.tanzu.vmware.com \
      --version 1.1.0 \
      --namespace tap-install \
      --values-file grype-values.yaml
    / Installing package 'grype.scanning.apps.tanzu.vmware.com'
    | Getting namespace 'tap-install'
    | Getting package metadata for 'grype.scanning.apps.tanzu.vmware.com'
    | Creating service account 'grype-scanner-tap-install-sa'
    | Creating cluster admin role 'grype-scanner-tap-install-cluster-role'
    | Creating cluster role binding 'grype-scanner-tap-install-cluster-rolebinding'
    / Creating package resource
    - Package install status: Reconciling

     Added installed package 'grype-scanner' in namespace 'tap-install'
    ```

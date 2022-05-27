# Install Supply Chain Security Tools - Scan

This document describes how to install Supply Chain Security Tools - Scan
from the Tanzu Application Platform package repository.

>**Note:** Use the instructions on this page if you do not want to use a profile to install packages.
The full profile includes Supply Chain Security Tools - Scan.
For more information about profiles, see [About Tanzu Application Platform package and profiles](../about-package-profiles.md).

## <a id='scst-scan-prereqs'></a> Prerequisites

Before installing Supply Chain Security Tools - Scan:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).
- Install [Supply Chain Security Tools - Store](../install-components.md#install-scst-store) for scan results to persist. It can be present on the same cluster or a different one. You can install Supply Chain Security Tools - Scan by using the CA Secret name for Supply Chain Security Tools - Store present in the same cluster, with Token Secret name for Supply Chain Security Tools - Store in different cluster, or without Supply Chain Security Tools - Store. In this case, skip creating a values file. After you complete installing Supply Chain Security Tools - Store, you must update the Supply Chain Security Tools - Scan values file.

    For usage instructions, see [Using the Supply Chain Security Tools - Store](../scst-store/overview.md).

- Install the Tanzu Insight CLI plug-in to query the Supply Chain Security Tools - Store for CVE results.
  See [Install the Tanzu Insight CLI plug-in](../cli-plugins/insight/cli-installation.md).

## <a id="scanner-support"></a> Scanner support

| Out-Of-The-Box Scanner | Version |
| --- | --- |
| [Anchore Grype](https://github.com/anchore/grype) | v0.37.0 |

Let us know if there's a scanner you'd like us to support.

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

1. (Optional) Make changes to the default installation settings by running:

    ```console
    tanzu package available get scanning.apps.tanzu.vmware.com/VERSION --values-schema -n tap-install
    ```

    Where `VERSION` is your package version number. For example, `1.1.0`.

1. Gather the values schema.

1. Install the package with default configuration by running:

    ```console
    tanzu package install scan-controller \
      --package-name scanning.apps.tanzu.vmware.com \
      --version VERSION \
      --namespace tap-install
    ```

    Where `VERSION` is your package version number. For example, `1.1.0`.

1. (Optional) Configure Supply Chain Security Tools - Store in a different cluster

    ```yaml
    ---
    metadataStore:
    url: META-DATA-STORE-URL
    authSecret:
      name: AUTH-SECRET-NAME
    ```

    Where:

    - `META-DATA-STORE-URL` is the URL pointing to the Supply Chain Security Tools - Store ingress in the cluster that has your Supply Chain Security Tools - Store deployment. For example, `https://metadata-store.example.com:8443`.
    - `AUTH-SECRET-NAME` is the name of the secret that has the auth token to post to the Supply Chain Security Tools - Store.

To install Supply Chain Security Tools - Scan (Grype scanner):

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

1. (Optional) Make changes to the default installation settings by running:

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

1. (Optional) You can define the `--values-file` flag to customize the default configuration. Create a `grype-values.yaml` file by using the following configuration:

    ```yaml
    ---
    namespace: DEV-NAMESPACE
    targetImagePullSecret: TARGET-REGISTRY-CREDENTIALS-SECRET
    targetSourceSshSecret: TARGET-REPOSITORY-CREDENTIALS-SECRET
    ```

    Where:

    - `DEV-NAMESPACE` is your developer namespace.

      >**Note:** To use a namespace other than the default namespace, ensure the namespace exists before you install. If the namespace does not exist, the Grype scanner installation fails.

    - `TARGET-REGISTRY-CREDENTIALS-SECRET` is the name of the secret that contains the credentials to pull an image from a private registry for scanning. If built images are pushed to the same registry as the Tanzu Application Platform images, you can reuse the `tap-registry` secret created earlier in [Add the Tanzu Application Platform package repository](../install.md#add-package-repositories-and-EULAs) for this field.

    - `TARGET-REPOSITORY-CREDENTIALS-SECRET` is the name of the secret that contains the credentials to pull source code from a private repository for scanning. This field is not optional if the source code is located in a public repository.

1. VMware recommends using the default values for this package.
To change the default values, see the Scan controller instructions for more information.

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

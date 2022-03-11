# Install Supply Chain Security Tools - Scan

This document describes how to install Supply Chain Security Tools - Scan
from the Tanzu Application Platform package repository.

>**Note:** Use the instructions on this page if you do not want to use a profile to install packages.
The full profile includes Supply Chain Security Tools - Scan.
For more information about profiles, see [Installing the Tanzu Application Platform Package and Profiles](../install.md).

## <a id='scst-scan-prereqs'></a>Prerequisites

Before installing Supply Chain Security Tools - Scan:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).
- [Supply Chain Security Tools - Store](../install-components.md#install-scst-store) must be installed on the cluster for scan results to persist. Supply Chain Security Tools - Scan can be installed without Supply Chain Security Tools - Store already installed. In this case, skip creating a values file. Once Supply Chain Security Tools - Store is installed, the Supply Chain Security Tools - Scan values file must be updated.
  For usage instructions, see [Using the Supply Chain Security Tools - Store](../scst-store/overview.md).
- Install Supply Chain Security Tools - Store CLI to query the Supply Chain Security Tools - Store for CVE results.
  See [Installing the CLI](../scst-store/cli-installation.md).

## <a id="scanner-support"></a>Scanner support

| Out-Of-The-Box Scanner | Version |
| --- | --- |
| [Anchore Grype](https://github.com/anchore/grype) | v0.33.0 |

Let us know if there's a scanner you'd like us to support.

## <a id='install-scst-scan'></a> Install

The installation for Supply Chain Security Tools – Scan involves installing two packages:

- Scan controller
- Grype scanner

The Scan controller enables you to use a scanner, in this case, the Grype scanner. Ensure both the Grype scanner and the Scan controller are installed.

To install Supply Chain Security Tools - Scan (Scan controller):

1. List version information for the package by running:

    ```
    tanzu package available list scanning.apps.tanzu.vmware.com --namespace tap-install
    ```

     For example:

    ```
    $ tanzu package available list scanning.apps.tanzu.vmware.com --namespace tap-install
    / Retrieving package versions for scanning.apps.tanzu.vmware.com...
      NAME                             VERSION       RELEASED-AT
      scanning.apps.tanzu.vmware.com   1.0.0
    ```

1. (Optional) Make changes to the default installation settings by running:

    ```
    tanzu package available get scanning.apps.tanzu.vmware.com/1.0.0 --values-schema -n tap-install
    ```

1. Gather the values schema.

1. Install the package with default configuration by running:

    ```
    tanzu package install scan-controller \
      --package-name scanning.apps.tanzu.vmware.com \
      --version 1.0.0 \
      --namespace tap-install
    ```

To install Supply Chain Security Tools - Scan (Grype scanner):

1. List version information for the package by running:

    ```
    tanzu package available list grype.scanning.apps.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```
    $ tanzu package available list grype.scanning.apps.tanzu.vmware.com --namespace tap-install
    / Retrieving package versions for grype.scanning.apps.tanzu.vmware.com...
      NAME                                  VERSION       RELEASED-AT
      grype.scanning.apps.tanzu.vmware.com  1.0.0
    ```

1. (Optional) Make changes to the default installation settings by running:

    ```
    tanzu package available get grype.scanning.apps.tanzu.vmware.com/1.0.0 --values-schema -n tap-install
    ```

    For example:

    ```
    $ tanzu package available get grype.scanning.apps.tanzu.vmware.com/1.0.0 --values-schema -n tap-install
    | Retrieving package details for grype.scanning.apps.tanzu.vmware.com/1.0.0...
      KEY                        DEFAULT  TYPE    DESCRIPTION
      namespace                  default  string  Deployment namespace for the Scan Templates
      resources.limits.cpu       1000m    <nil>   Limits describes the maximum amount of cpu resources allowed.
      resources.requests.cpu     250m     <nil>   Requests describes the minimum amount of cpu resources required.
      resources.requests.memory  128Mi    <nil>   Requests describes the minimum amount of memory resources required.
      targetImagePullSecret      <EMPTY>  string  Reference to the secret used for pulling images from private registry.
      targetSourceSshSecret      <EMPTY>  string  Reference to the secret containing SSH credentials for cloning private repositories.
    ```

1. (Optional) You can define the `--values-file` flag to customize the default configuration. Create a `grype-values.yml` file by using the following configuration:

    ```
    grype:
      namespace: DEV-NAMESPACE
      targetImagePullSecret: TARGET-REGISTRY-CREDENTIALS-SECRET
    ```

    Where:

    - `DEV-NAMESPACE` is your developer namespace.

      >**Note:** To use a namespace other than the default namespace, ensure the namespace exists before you install. If the namespace does not exist, the Grype scanner installation fails.

    - `TARGET-REGISTRY-CREDENTIALS-SECRET` is the name of the secret that contains the credentials to pull an image from the registry for scanning. If built images are pushed to the same registry as the Tanzu Application Platform images, this can reuse the `tap-registry` secret created in step 3 of [Add the Tanzu Application Platform package repository](../install.md#add-package-repositories-and-EULAs).

    - `TARGET-REPOSITORY-CREDENTIALS-SECRET` is the name of the secret that contains the credentials to pull source code from a private repository for scanning. This field is not optional if the source code is located in a public repository.

1. VMware recommends using the default values for this package.
To change the default values, see the Scan controller instructions for more information.

1. Install the package by running:

    ```
    tanzu package install grype-scanner \
      --package-name grype.scanning.apps.tanzu.vmware.com \
      --version 1.0.0 \
      --namespace tap-install
    ```

    For example:

    ```
    $ tanzu package install grype-scanner \
      --package-name grype.scanning.apps.tanzu.vmware.com \
      --version 1.0.0 \
      --namespace tap-install
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

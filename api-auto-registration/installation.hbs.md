# Install API Auto Registration

This document describes how to API Autoregistration from the Tanzu Application Platform package repository.

>**Note:** Use the instructions on this page if you do not want to use the full or run profile to install packages.
Only the full and run profiles includes Learning Center.
For more information about profiles, see [About Tanzu Application Platform components and profiles](../about-package-profiles.md).

## <a id='prereqs'></a>Prerequisites

Before installing API Auto Registration:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).

### <a id='install'></a>Install

To install API Auto Registration:

1. List version information for the package by running:

    ```console
    tanzu package available list apis.apps.tanzu.vmware.com --namespace tap-install
    ```

    Example output:

    ```console
     NAME                             VERSION        RELEASED-AT
     apis.apps.tanzu.vmware.com       0.1.0          2022-08-09 16:27:06 -0400 EDT
    ```

1. Create a config file named `api-auto-registration-config.yaml`.

   You will need the url to the tap gui. You can find it in the tap-value.yaml using the command below.

   ```console
   kubectl get secret tap-values -n tap-install -o jsonpath="{.data['tap-values\.yaml']}" | base64 -d | yq '.tap_gui.app_config.backend.baseUrl'
   ```

    Add the following intry into your `api-auto-registration-config.yaml` file.
    ```yaml
    tap_gui_url: YOUR-TAP-GUI-URL
    ```

    Where `YOUR-TAP-GUI-URL` is the domain name for your Kubernetes cluster.

1. Install the package using the Tanzu CLI
   
   ```console
   tanzu package install api-autoregistration 
   --package-name apis.apps.tanzu.vmware.com
   --namespace $(TAP_NAMESPACE)
   --version $(VERSION)
   --values-file api-auto-registration-config.yaml
   --wait=true
   ```
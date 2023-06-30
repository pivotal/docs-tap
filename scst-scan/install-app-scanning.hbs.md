# Installing SCST - Scan 2.0 in a cluster

The following sections describe how to install SCST - Scan 2.0. Since SCST-Scan 2.0 is in beta, it is not currently installed with any profiles and must be installed following these directions.

## <a id="scst-app-scanning-prereqs"></a> Prerequisites

SCST - Scan 2.0 requires the following prerequisites:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.hbs.md).
- Install the [Tekton component](../tekton/install-tekton.hbs.md). Tekton will already be installed if you installed TAP via a profile based installation in both the Full and Build Profiles.

## <a id="configure-app-scanning"></a> Configure properties

When you install SCST - Scan 2.0, you can configure the following optional properties:

| Key | Default | Type | Description |
| --- | --- | --- | --- |
| caCertData | "" | string | The custom certificates trusted by the scan's connections |
| docker.import | true | Boolean | Import `docker.pullSecret` from another namespace (requires secretgen-controller). Set to false if the secret is already present. |
| docker.pullSecret | registries-credentials | string | Name of a Docker pull secret in the deployment namespace to pull the scanner images |
| workspace.storageSize  | 100Mi | string | Size of the PersistentVolume that the Tekton pipelineruns uses |
| workspace.storageClass  | "" | string | Name of the storage class to use while creating the PersistentVolume claims used by tekton pipelineruns |

## <a id="install-scst-app-scanning"></a> Install

To install SCST - Scan 2.0:

1. List version information for the package by running:

    ```console
    tanzu package available list app-scanning.apps.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list app-scanning.apps.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for app-scanning.apps.tanzu.vmware.com...
        NAME                                VERSION              RELEASED-AT
        app-scanning.apps.tanzu.vmware.com  0.1.0-beta          2023-03-01 20:00:00 -0400 EDT
    ```

1. (Optional) Make changes to the default installation settings:

    Retrieve the configurable settings:

    ```console
    tanzu package available get app-scanning.apps.tanzu.vmware.com/VERSION --values-schema --namespace tap-install
    ```

    Where `VERSION` is your package version number. For example, `0.1.0-beta`.

    For example:

    ```console
    tanzu package available get app-scanning.apps.tanzu.vmware.com/0.1.0-beta --values-schema --namespace tap-install
    | Retrieving package details for app-scanning.apps.tanzu.vmware.com/0.1.0-beta...

      KEY                     DEFAULT                 TYPE     DESCRIPTION
      docker.import           true                    boolean  Import `docker.pullSecret` from another namespace (requires
                                                               secretgen-controller). Set to false if the secret will already be present.
      docker.pullSecret       registries-credentials  string   Name of a docker pull secret in the deployment namespace to pull the scanner
                                                               images.
      workspace.storageSize   100Mi                   string   Size of the Persistent Volume to be used by the tekton pipelineruns
      workspace.storageClass                          string   Name of the storage class to use while creating the Persistent Volume Claims
                                                               used by tekton pipelineruns
      caCertData                                      string   The custom certificates to be trusted by the scan's connections
    ```
    To modify any of the default installation settings, create an `app-scanning-values-file.yaml` and append the key-value pairs to be modified to the file. For example:

    ```yaml
    scans:
      workspace:
        storageSize: 200Mi
    ```
1. Install the package by running the following command. If you did not modify the default installation settings, you do not need to specify the `--values-file` flag:

    ```console
    tanzu package install app-scanning-beta --package-name app-scanning.apps.tanzu.vmware.com \
        --version VERSION \
        --namespace tap-install \
        --values-file app-scanning-values-file.yaml
    ```

    Where `VERSION` is your package version number. For example, `0.1.0-beta`.

    For example:

    ```console
    tanzu package install app-scanning-alpha --package-name app-scanning.apps.tanzu.vmware.com \
        --version 0.1.0-beta\
        --namespace tap-install \
        --values-file app-scanning-values-file.yaml

        Installing package 'app-scanning.apps.tanzu.vmware.com'
        Getting package metadata for 'app-scanning.apps.tanzu.vmware.com'
        Creating service account 'app-scanning-default-sa'
        Creating cluster admin role 'app-scanning-default-cluster-role'
        Creating cluster role binding 'app-scanning-default-cluster-rolebinding'
        Creating package resource
        Waiting for 'PackageInstall' reconciliation for 'app-scanning'
        'PackageInstall' resource install status: Reconciling
        'PackageInstall' resource install status: ReconcileSucceeded
    ```

1. (Optional) If you have Artifact Metadata Repository Observer installed, you will need to restart it to observe the new ImageVulerabilityScan Custom Resource that was installed with SCST - Scan 2.0

    ```console
    kubectl -n amr-observer-system rollout restart deployment amr-observer-controller-manager
    ```

## <a id="config-sa-reg-creds"></a> Configure Service Accounts and Registry Credentials

>**Note:** If you used the Namespace Provisioner to provision your developer namespace, the following section has already been completed and you can proceed to [scanning integration](./integrate-app-scanning.hbs.md). For more information, see the [Namespace Provisioner documentation](../namespace-provisioner/default-resources.hbs.md).

The following section describes how to configure service accounts and registry credentials. SCST - Scan 2.0 requires the following access:

  - Read access to the registry containing the Tanzu Application Platform bundles. This is the registry from the [Relocate images to a registry](../install-online/profile.hbs.md#relocate-images-to-a-registry) step or `registry.tanzu.vmware.com`.
  - Read access to the registry containing the image to scan, if scanning a private image
  - Write access to the registry to which results are published

1. Create a secret `scanning-tap-component-read-creds` with read access to the registry containing the Tanzu Application Platform bundles. This pulls the SCST - Scan 2.0 images.

    >**Important** If you followed the directions for [Install Tanzu Application Platform](../install-intro.hbs.md), skip this step and use the `tap-registry` secret with your service account.

    ```console
    read -s TAP_REGISTRY_PASSWORD
    kubectl create secret docker-registry scanning-tap-component-read-creds \
      --docker-username=TAP-REGISTRY-USERNAME \
      --docker-password=$TAP_REGISTRY_PASSWORD \
      --docker-server=TAP-REGISTRY-URL \
      -n DEV-NAMESPACE
    ```

    Where `DEV-NAMESPACE` is the developer namespace where scanning occurs.

1. If you are scanning a private image, create a secret `scan-image-read-creds` with read access to the registry containing that image.

    >**Important** If you followed the directions for [Install Tanzu Application Platform](../install-intro.hbs.md), you can skip this step and use the `targetImagePullSecret` secret with your service account as referenced in your tap-values.yaml [here](../install-online/profile.hbs.md#full-profile).

    ```console
    read -s REGISTRY_PASSWORD
    kubectl create secret docker-registry scan-image-read-creds \
      --docker-username=REGISTRY-USERNAME \
      --docker-password=$REGISTRY_PASSWORD \
      --docker-server=REGISTRY-URL \
      -n DEV-NAMESPACE
    ```

1. Create a secret `write-creds` with write access to the registry for the scanner to upload the scan results to.

    ```console
    read -s WRITE_PASSWORD
    kubectl create secret docker-registry write-creds \
      --docker-username=WRITE-USERNAME \
      --docker-password=$WRITE_PASSWORD \
      --docker-server=DESTINATION-REGISTRY-URL \
      -n DEV-NAMESPACE
    ```

1. Create the service account `scanner` which enables SCST - Scan 2.0 to pull the image to scan. Attach the read secret created earlier under `imagePullSecrets` and the write secret under `secrets`.

    ```yaml
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: scanner
      namespace: DEV-NAMESPACE
    imagePullSecrets:
    - name: scanning-tap-component-read-creds
    secrets:
    - name: scan-image-read-creds
    ```

    Where:

    - `imagePullSecrets.name` is the name of the secret used by the component to pull the scan component image from the registry.
    - `secrets.name` is the name of the secret used by the component to pull the image to scan. This is required if the image you are scanning is private.

1. Create the service account `publisher` which enables SCST - Scan 2.0 to push the scan results to a user specified registry.

    ```yaml
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: publisher
      namespace: DEV-NAMESPACE
    imagePullSecrets:
    - name: scanning-tap-component-read-creds
    secrets:
    - name: write-creds
    ```

    Where:

    - `imagePullSecrets.name` is the name of the secret used by the component to pull the scan component image from the registry.
    - `secrets.name` is the name of the secret used by the component to publish the scan results.

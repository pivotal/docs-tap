# Install Supply Chain Security Tools - Scan 2.0 in a cluster

The following sections describe how to install Supply Chain Security Tools (SCST) - Scan 2.0. SCST-Scan 2.0 is in beta and is not installed with any profiles and must be installed following these directions.

## <a id="scst-app-scanning-prereqs"></a> Prerequisites

SCST - Scan 2.0 requires the following prerequisites:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.hbs.md).
- Install the [Tekton component](../tekton/install-tekton.hbs.md). Tekton is already installed if you installed Tanzu Application Platform by using a profile based installation in both the Full and Build Profiles.
- Downstream Tanzu Application Platform services, such as Tanzu Developer Portal and Tanzu CLI, depend on scan results stored in the SCST - Store component to display them correctly. You must enable AMR (beta) and AMR Observer (alpha) components. See the [AMR documentation](../scst-store/amr/install-amr-observer.hbs.md).

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
      workspace.storageSize   2Gi                     string   Size of the Persistent Volume to be used by the tekton pipelineruns
      workspace.storageClass                          string   Name of the storage class to use while creating the Persistent Volume Claims
                                                               used by tekton pipelineruns
      caCertData                                      string   The custom certificates to be trusted by the scan's connections
    ```

    To edit any of the default installation settings, create an `app-scanning-values-file.yaml` and append the key-value pairs to be modified to the file. For example:

    ```yaml
    scans:
      workspace:
        storageSize: 200Mi
    ```
2. Install the package. If you did not edit the default installation settings, you do not need to specify the `--values-file` flag.

    ```console
    tanzu package install app-scanning-beta --package-name app-scanning.apps.tanzu.vmware.com \
        --version VERSION \
        --namespace tap-install \
        --values-file app-scanning-values-file.yaml
    ```

    Where `VERSION` is your package version number. For example, `0.1.0-beta`.

    For example:

    ```console
    tanzu package install app-scanning-alpha --package app-scanning.apps.tanzu.vmware.com \
        --version 0.1.0-beta \
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

## <a id="config-sa-reg-creds"></a> Configure service accounts and registry credentials

This section contains instructions for users that are running a standalone ImageVulnerabilityScan or using multiple registries.

If the image that you are scanning, or if you are bringing your own scanner, and
your vulnerability scanner image are located in private registries different
from the `Tanzu Application Platform bundles registry`, you must edit your
scanner service account to include registry credentials for these registries.

>**Important** If your use case is listed below, skip this topic and proceed to [scanning integration](./integrate-app-scanning.hbs.md).

  > - You are running an ImageVulnerabilityScan in the context of a supply chain.
  > - You used the Namespace Provisioner to provision your developer namespace. For more information, see the [Namespace Provisioner documentation](../namespace-provisioner/default-resources.hbs.md).

To configure service accounts and registry credentials, SCST - Scan 2.0 requires the following access:

| Registry | Permission | Service Account | Example |
| --- | --- | --- | --- |
| Tanzu Application Platform bundles registry| Read | scanner | registry.tanzu.vmware.com |
| Target image registry | Read | scanner | your-registry.io |
| Vulnerability scanner image registry | Read | scanner | your-registry.io |
| Scan results location registry | Write | publisher | your-registry.io |

Where:

  - `Tanzu Application Platform bundles registry` is the registry containing the Tanzu Application Platform bundles. This is the registry from the [Relocate images to a registry](../install-online/profile.hbs.md#relocate-images-to-a-registry) step or `registry.tanzu.vmware.com`.
  - `Target image registry` is the registry containing the image to scan. This registry credential is required if you are scanning a private image. The `image to scan is` called the `target image` or `TARGET-IMAGE`.
  - `Vulnerability scanner image registry` is the registry containing your vulnerability scanner image. This is only needed if you are bringing your own scanner and your vulnerability scanner image is located in a private registry different from the `Tanzu Application Platform bundles registry`.
  - `Scan results location registry` is the registry where scan results are published.

To configure service accounts and registry credentials:

1. Create a secret `scanning-tap-component-read-creds` with read access to the registry containing the Tanzu Application Platform bundles. This pulls the SCST - Scan 2.0 images. If you previously relocated the Tanzu Application Platform bundles to your own registry, you can also place your vulnerability scanner image in this registry.

    ```console
    read -s TAP_REGISTRY_PASSWORD
    kubectl create secret docker-registry scanning-tap-component-read-creds \
      --docker-username=TAP-REGISTRY-USERNAME \
      --docker-password=$TAP_REGISTRY_PASSWORD \
      --docker-server=TAP-REGISTRY-URL \
      -n DEV-NAMESPACE
    ```

    Where `DEV-NAMESPACE` is the developer namespace where scanning occurs.

2. If you are scanning a private target image, create a secret `target-image-read-creds` with read access to the registry containing that target image.

    >**Important** If you followed the directions for [Install Tanzu Application Platform](../install-intro.hbs.md), you can skip this step and use the `targetImagePullSecret` secret with your service account as referenced in your `tap-values.yaml`. See [Full profile](../install-online/profile.hbs.md#full-profile).

    ```console
    read -s REGISTRY_PASSWORD
    kubectl create secret docker-registry target-image-read-creds \
      --docker-username=REGISTRY-USERNAME \
      --docker-password=$REGISTRY_PASSWORD \
      --docker-server=REGISTRY-URL \
      -n DEV-NAMESPACE
    ```

3. Create a secret `write-creds` with write access to the registry for the scanner to upload the scan results to.

    ```console
    read -s WRITE_PASSWORD
    kubectl create secret docker-registry write-creds \
      --docker-username=WRITE-USERNAME \
      --docker-password=$WRITE_PASSWORD \
      --docker-server=DESTINATION-REGISTRY-URL \
      -n DEV-NAMESPACE
    ```

4. (Optional) If you are bringing your own vulnerability scanner and your vulnerability scanner image is located in a private registry different from the registry containing your Tanzu Application Platform bundles, you must create a secret `vulnerability-scanner-image-read-creds` with read access to the registry.

    ```console
    read -s WRITE_PASSWORD
    kubectl create secret docker-registry vulnerability-scanner-image-read-creds \
      --docker-username=WRITE-USERNAME \
      --docker-password=$WRITE_PASSWORD \
      --docker-server=REGISTRY-URL \
      -n DEV-NAMESPACE
    ```

5. Create a `scanner-sa.yaml` file containing the service account `scanner` which enables SCST - Scan 2.0 to pull both the vulnerability scanner image and target image. Attach the one or more read secrets created earlier pulling the Tanzu Application Platform bundles, and optionally, your vulnerability scanner image under `imagePullSecrets`. Attach the read secret created earlier for your target image under `secrets`.

    ```yaml
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: scanner
      namespace: DEV-NAMESPACE
    imagePullSecrets:
    - name: scanning-tap-component-read-creds
    - name: vulnerability-scanner-image-read-creds # optional
    secrets:
    - name: target-image-read-creds
    ```

    Where:

    - `imagePullSecrets.name` includes the name of the secret used to pull the scan component from the registry. If you are bringing your own vulnerability scanner and the vulnerability scanner image is located in a separate private registry, you must also include the name of the secret with those registry credentials.
    - `secrets.name` is the name of the secret used to pull the target image to scan. This is required if the image you are scanning is private.

6. Apply the service account to your developer namespace by running:
   
   ```console
   kubectl apply -f scanner-sa.yaml
   ```

7. Create a `publisher-sa.yaml` file containing the service account `publisher` which enables SCST - Scan 2.0 to push the scan results to a user specified registry.

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

    - `imagePullSecrets.name` is the name of the secret used to pull the scan component image from the registry.
    - `secrets.name` is the name of the secret used to publish the scan results.

8. Apply the service account to your developer namespace by running:
   ```console
   kubectl apply -f publisher-sa.yaml
   ```

## <a id="registry-retention-policy"></a> (Optional) Set up your registry retention policy

Although Tanzu Application Platform ingests scan artifacts into the Metadata
Store, and stores information such as packages and parsed vulnerabilities, only
a pointer to the the original SBOM location is stored. The original SBOM
generated by the scan is not preserved within the Metadata Store. VMware
recommends that you keep these original artifacts according to your
organizations archival requirements.

If the registry specified to push scan results to supports retention policies,
you can configure the registry to delete old scan results automatically,
depending on your archival requirements. Scan result artifacts accumulate over
time and can quickly consume hard disk space.

For information about configuring Harbor tag retention rules, see the [Harbor documentation](https://goharbor.io/docs/2.5.0/working-with-projects/working-with-images/create-tag-retention-rules/#configure-tag-retention-rules). For example, you can configure Harbor to retain the most recently pushed # artifacts or retain the artifacts pushed within the last # days.

Retention policy setup differs between registry providers. Check with your specific registry's documentation on configuration options.
# Install Snyk scanner

This document describes how to install Supply Chain Security Tools - Scan
(Snyk Scanner) from the Tanzu Application Platform package repository.

## Prerequisites

Before installing Supply Chain Security Tools - Scan (Snyk Scanner):

- Install [Supply Chain Security Tools - Scan](../install-components.md#install-scst-scan). It must be present on the same cluster. The prerequisites for Scan will also be required.

## Scanner support

| Scanner | Version |
| --- | --- |
| [Snyk](https://github.com/snyk/cli) |  |

## Install

To install Supply Chain Security Tools - Scan (Snyk scanner):

1. List version information for the package by running:

    ```console
    tanzu package available list snyk.scanning.apps.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list snyk.scanning.apps.tanzu.vmware.com --namespace tap-install
    / Retrieving package versions for snyk.scanning.apps.tanzu.vmware.com...
      NAME                                  VERSION       RELEASED-AT
      snyk.scanning.apps.tanzu.vmware.com   1.0.0
    ```

1. (Optional) Make changes to the default installation settings by running:

    ```console
    tanzu package available get snyk.scanning.apps.tanzu.vmware.com/VERSION --values-schema -n tap-install
    ```

    Where `VERSION` is your package version number. For example, `1.0.0`.

    For example:

    ```console
    $ tanzu package available get snyk.scanning.apps.tanzu.vmware.com/1.0.0 --values-schema -n scan-install

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

1. Define the `--values-file` flag to customize the default configuration. Create a `values.yaml` file by using the following configuration:

  The Grype and Snyk Scanner Integrations both enable the Metadata Store. As such, the configuration values will be slightly different based on whether the Grype Scanner Integration is installed or not. (If TAP was installed via the Full Profile, then the Grype Scanner Integration was installed, unless it was explicitly excluded.)

  * If the Grype Scanner Integration is installed:
    ```yaml
    ---
    namespace: DEV-NAMESPACE
    targetImagePullSecret: TARGET-REGISTRY-CREDENTIALS-SECRET
    snyk:
      tokenSecret:
        name: SNYK-TOKEN-SECRET
    metadataStore:
      caSecret:
        importFromNamespace: "" #! since both snyk and grype both enable store, one must leave importFromNamespace blank
      authSecret:
        importFromNamespace: "" #! since both snyk and grype both enable store, one must leave importFromNamespace blank
    ```

  * If the Grype Scanner Integration is NOT installed:
    ```yaml
    ---
    namespace: DEV-NAMESPACE
    targetImagePullSecret: TARGET-REGISTRY-CREDENTIALS-SECRET
    snyk:
      tokenSecret:
        name: SNYK-TOKEN-SECRET
    ```

    In either case, where:

    - `DEV-NAMESPACE` is your developer namespace.

      >**Note:** To use a namespace other than the default namespace, ensure the namespace exists before you install. If the namespace does not exist, the scanner installation fails.

    - `TARGET-REGISTRY-CREDENTIALS-SECRET` is the name of the secret that contains the credentials to pull an image from a private registry for scanning. If built images are pushed to the same registry as the Tanzu Application Platform images, you can reuse the `tap-registry` secret created earlier in [Add the Tanzu Application Platform package repository](../install.md#add-package-repositories-and-EULAs) for this field.

    - `SNYK-TOKEN-SECRET` is the name of the secret that contains the SNYK_TOKEN to connect to the [Snyk API](https://docs.snyk.io/snyk-cli/configure-the-snyk-cli#environment-variables). This field is not optional.

1. Install the package by running:

    ```console
    tanzu package install snyk-scanner \
      --package-name snyk.scanning.apps.tanzu.vmware.com \
      --version VERSION \
      --namespace tap-install \
      --values-file values.yaml
    ```

    Where `VERSION` is your package version number. For example, `1.0.0`.

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

## Using the Synk scanner to run an ImageScan

The OOTB Scanning Supply Chain implements a `SourceScan` and `ImageScan`, which references `ScanTemplate`s that use the Grype scanner. To use the Snyk scanner for the `ImageScan` (the Snyk `SourceScan` is not yet supported), the `ImageScan` `ScanTemplate` will need to be used instead. In the OOTB Scanning Supply Chain, update `spec.scanTemplate` from `public-image-scan-template` to `snyk-public-image-scan-template`.

Similarly, to run a scan manually, apply the following to the developer namespace:
```yaml
apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
kind: ImageScan
metadata:
  name: sample-snyk-public-image-scan
spec:
  registry:
    image: "nginx:1.16"
  scanTemplate: snyk-public-image-scan-template
  scanPolicy: scan-policy
```

Applying both of these into a developer namespace would result in an image scan being run using the Snyk scanner instead of the Grype scanner.

*NOTE:* Currently, the Snyk Scanner Integration is only available for an image scan, not a source scan.

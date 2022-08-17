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
    ```
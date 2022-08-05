# Install Snyk Scanner (Beta)

This document describes how to install Supply Chain Security Tools - Scan 
(Snyk Scanner) from the Tanzu Application Platform package repository.

>**Note:** Snyk's image scanning capability is in beta. Snyk might only return a partial list of CVEs when scanning Buildpack images.

## <a id="prerecs"></a> Prerequisites

Before installing Supply Chain Security Tools - Scan (Snyk Scanner):

- Install [Supply Chain Security Tools - Scan](install-scst-scan.md). It must be present on the same cluster. The prerequisites for Scan are also required.
- Obtain a Snyk API Token from the [Snyk Docs](https://docs.snyk.io/snyk-cli/authenticate-the-cli-with-your-account).

## <a id="install-snyk"></a> Install

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

2. (Optional) Make changes to the default installation settings by running:

    ```console
    tanzu package available get snyk.scanning.apps.tanzu.vmware.com/VERSION --values-schema -n tap-install
    ```

    Where `VERSION` is your package version number. For example, `1.0.0`.

    For example:

    ```console
    $ tanzu package available get snyk.scanning.apps.tanzu.vmware.com/1.0.0 --values-schema -n tap-install

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

3. Create a Snyk secret YAML file and insert the Snyk API token (base64 encoded) into the `snyk_token` key as follows:

    ```yaml
    apiVersion: v1
    kind: Secret
    metadata:
      name: snyk-token-secret
      namespace: my-apps
    data:
      snyk_token: BASE64-SNYK-API-TOKEN
    ```

4. Apply the Snyk secret YAML file by running:

    ```console
    kubectl apply -f YAML-FILE
    ```

    Where `YAML-FILE` is the name of the Snyk secret YAML file you created.

5. Define the `--values-file` flag to customize the default configuration. Create a `values.yaml` file by using the following configuration:

    You must define the following fields in the `values.yaml` file for the Snyk Scanner configuration. You can add fields as needed to enable or disable behaviors. You can append the values to this file as shown later in this document. 

    ```yaml
    ---
    namespace: DEV-NAMESPACE
    targetImagePullSecret: TARGET-REGISTRY-CREDENTIALS-SECRET
    snyk:
      tokenSecret:
        name: SNYK-TOKEN-SECRET
    ```

     - `DEV-NAMESPACE` is your developer namespace.

       >**Note:** To use a namespace other than the default namespace, ensure the namespace exists before you install. If the namespace does not exist, the scanner installation fails.

     - `TARGET-REGISTRY-CREDENTIALS-SECRET` is the name of the secret that contains the credentials to pull an image from a private registry for scanning. If built images are pushed to the same registry as the Tanzu Application Platform images, you can reuse the `tap-registry` secret created earlier in [Add the Tanzu Application Platform package repository](../install.md#add-package-repositories-and-EULAs) for this field.

     - `SNYK-TOKEN-SECRET` is the name of the secret you created that contains the `snyk_token` to connect to the [Snyk API](https://docs.snyk.io/snyk-cli/configure-the-snyk-cli#environment-variables). This field is required.

    The Snyk Scanner integration can work with or without the Supply Chain Security Tools - Store integration. The `values.yaml` file is slightly different for each configuration.

    **Using Supply Chain Security Tools - Store Integration:** To persist the results found by the Snyk Scanner, you can enable the Supply Chain Security Tools - Store integration by appending the fields to the `values.yaml` file. 

    The Grype and Snyk Scanner Integrations both enable the Metadata Store. To prevent conflicts, the configuration values are slightly different based on whether the Grype Scanner Integration is installed or not. If Tanzu Application Platform was installed using the Full Profile, the Grype Scanner Integration was installed, unless it was explicitly excluded.

     * If the Grype Scanner Integration is installed in the same `dev-namespace` Snyk Scanner is installed:

       ```yaml
       #! ...
       metadataStore:
         #! The url where the Store deployment is accesible.
         #! Default value is: "https://metadata-store-app.metadata-store.svc.cluster.local:8443"
         url: "<STORE-URL>" 
         caSecret:
           #! The name of the secret that contains the ca.crt to connect to the Store Deployment.
           #! Default value is: "app-tls-cert"
           name: "<CA-SECRET-NAME>"
           importFromNamespace: "" #! since both Snyk and Grype both enable store, one must leave importFromNamespace blank
         #! authSecret is for multicluster configurations.
         authSecret:
           #! The name of the secret that contains the auth token to authenticate to the Store Deployment.
           name: "<AUTH-SECRET-NAME>"
           importFromNamespace: "" #! since both Snyk and Grype both enable store, one must leave importFromNamespace blank
       ```

     * If the Grype Scanner Integration is not installed in the same `dev-namespace` Snyk Scanner is installed:

       ```yaml
       #! ...
       metadataStore:
         #! The url where the Store deployment is accesible.
         #! Default value is: "https://metadata-store-app.metadata-store.svc.cluster.local:8443"
         url: "<STORE-URL>" 
         caSecret:
           #! The name of the secret that contains the ca.crt to connect to the Store Deployment.
           #! Default value is: "app-tls-cert"
           name: "<CA-SECRET-NAME>"
           #! The namespace where the secrets for the Store Deployment live. 
           #! Default value is: "metadata-store"
           importFromNamespace: "<STORE-SECRETS-NAMESPACE>"
         #! authSecret is for multicluster configurations.
         authSecret:
           #! The name of the secret that contains the auth token to authenticate to the Store Deployment.
           name: "<AUTH-SECRET-NAME>"
           #! The namespace where the secrets for the Store Deployment live.
           importFromNamespace: "<STORE-SECRETS-NAMESPACE>"
       ```

    **Without Supply Chain Security Tools - Store Integration:** If you don't want to enable the Supply Chain Security Tools - Store integration, explicitly disable the integration by appending the next fields to the `values.yaml` file, since it's enabled by default: 

    ```yaml
    # ... 
    metadataStore:
      url: "" # Disable Supply Chain Security Tools - Store integration
    ```

6. Install the package by running:

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

## <a id="verify"></a> Verify integration with Snyk

To verify the integration with Snyk, apply the following `ImageScan` and its `ScanPolicy` in the developer namespace and review the result.

1. Create a ScanPolicy YAML with a Rego file for scanner output in the SPDX JSON format. Here is a sample scan policy resource:

    ```yaml
    apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
    kind: ScanPolicy
    metadata:
      name: snyk-scan-policy
    spec:
      regoFile: |
        package main

        notAllowedSeverities := ["Low"]
        ignoreCves := []

        contains(array, elem) = true {
          array[_] = elem
        } else = false { true }

        isSafe(match) {
          fails := contains(notAllowedSeverities, match.relationships[_].ratedBy.rating[_].severity)
          not fails
        }

        isSafe(match) {
          ignore := contains(ignoreCves, match.id)
          ignore
        }

        deny[msg] {
          vuln := input.vulnerabilities[_]
          ratings := vuln.relationships[_].ratedBy.rating[_].severity
          comp := vuln.relationships[_].affect.to[_]
          not isSafe(vuln)
          msg = sprintf("%s %s %s", [comp, vuln.id, ratings])
        }
    ```

1. Apply the earlier created YAML:

    ```console
    kubectl apply -n $DEV_NAMESPACE -f <SCAN-POLICY-YAML>
    ```

1. Create the following ImageScan YAML:

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

1. Apply the earlier created YAML:

    ```console
    kubectl apply -n $DEV_NAMESPACE -f <IMAGE-SCAN-YAML>
    ``` 

1. To verify the integration, run:

    ```bash
    kubectl get imagescan sample-snyk-public-image-scan -n $DEV_NAMESPACE
    ```

    For example:

    ```console
    kubectl get imagescan sample-snyk-public-image-scan -n $DEV_NAMESPACE
    NAME                            PHASE       SCANNEDIMAGE   AGE   CRITICAL   HIGH   MEDIUM   LOW   UNKNOWN   CVETOTAL
    sample-snyk-public-image-scan   Completed   nginx:1.16     26h   0          114    58       314   0         486
    ```

1. Cleanup:

    ```bash
    kubectl delete imagescan sample-snyk-public-image-scan -n $DEV_NAMESPACE
    ```

## <a id="sc-config"></a> Configure Supply Chains

In order to scan your images with Snyk instead of the default Grype scanner in the [Out of the Box Supply Chain with Testing and Scanning](../scc/ootb-supply-chain-testing-scanning.md), you must update your Tanzu Application Platform installation.
 
Add the `ootb_supply_chain_testing_scanning.scanning` section later to your `tap-values.yaml` and perform a [Tanzu Application Platform update](../upgrading.md#upgrading-tanzu-application-platform).

```yaml
ootb_supply_chain_testing_scanning:
  scanning:
    image:
      template: snyk-private-image-scan-template
      policy: snyk-scan-policy
```

>**Note:** The Snyk Scanner integration is only available for an image scan, not a source scan.

## <a id="opt-out-of-snyk"></a> Opt-out of using Snyk

You can opt out of using Snyk for either a specific supply chain or for all of Tanzu Application Platform.

### <a id="opt-out-of-snyk-supply-chain"></a> Opt-out of Snyk for a Supply Chain

To opt-out of Snyk for a specific Supply Chain, reconfigure the supply chain to use another scanner:

-  Edit the `ootb_supply_chain_testing_scanning.scanning.image.template` value to use a scan template that does not use Snyk, such as Grype.

      ```yaml
      ootb_supply_chain_testing_scanning:
        scanning:
          image:
            template: "ALTERNATIVE-SCAN-TEMPLATE"
            policy: scan-policy
      ```

### <a id="opt-out-of-snyk-entirely"></a> Opt-out of Snyk Entirely

To opt-out of Snyk for all of Tanzu Application Platform:

1. To uninstall Snyk, run:

  ```console
  tanzu package installed delete snyk-scanner \
    --namespace tap-install
  ```
2. Follow the [Opt-out of Snyk for a specific Supply Chain](#-opt-out-of-snyk-for-a-supply-chain) for all Supply Chains in the environment to not use Snyk and use another scanner such as Grype.

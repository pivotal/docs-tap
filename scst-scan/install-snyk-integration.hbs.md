# Prerequisites for Snyk Scanner (Beta)

This topic describes the prerequisites for installing Supply Chain Security Tools - Scan (Snyk Scanner) from the Tanzu Application Platform package repository.

>**Important** Snyk's image scanning capability is in beta. Snyk might only return a partial list of CVEs when scanning Buildpack images.

## <a id="prerecs"></a> Prepare the Snyk Scanner configuration

1. Obtain a Snyk API Token from the [Snyk documentation](https://docs.snyk.io/snyk-cli/authenticate-the-cli-with-your-account).

2. Create a Snyk secret YAML file and insert the base64 encoded Snyk API token into the `snyk_token`:

    ```yaml
    apiVersion: v1
    kind: Secret
    metadata:
      name: snyk-token-secret
      namespace: my-apps
    data:
      snyk_token: BASE64-SNYK-API-TOKEN
    ```

    Where `BASE64-SNYK-API-TOKEN` is the Snyk API Token obtained earlier.

3. Apply the Snyk secret YAML file by running:

    ```console
    kubectl apply -f YAML-FILE
    ```

    Where `YAML-FILE` is the name of the Snyk secret YAML file you created.

4. Define the `--values-file` flag to customize the default configuration. You must define the following fields in the `values.yaml` file for the Snyk Scanner configuration. You can add fields as needed to activate or deactivate behaviors. You can append the values to this file as shown later in this topic. Create a `values.yaml` file by using the following configuration:

    ```yaml
    ---
    namespace: DEV-NAMESPACE
    targetImagePullSecret: TARGET-REGISTRY-CREDENTIALS-SECRET
    snyk:
      tokenSecret:
        name: SNYK-TOKEN-SECRET
    ```

    Where:

    - `DEV-NAMESPACE` is your developer namespace.

        >**Note** To use a namespace other than the default namespace, ensure that the namespace exists before you install. If the namespace does not exist, the scanner installation fails.

    - `TARGET-REGISTRY-CREDENTIALS-SECRET` is the name of the secret that contains the credentials to pull an image from a private registry for scanning.

    - `SNYK-TOKEN-SECRET` is the name of the secret you created that contains the `snyk_token` to connect to the [Snyk API](https://docs.snyk.io/snyk-cli/configure-the-snyk-cli#environment-variables). This field is required.

    The Snyk Scanner integration can work with or without the SCST - Store integration. The `values.yaml` file is slightly different for each configuration.

## <a id="store-integration"></a> SCST - Store integration

**Using SCST - Store Integration:** To persist the results found by the Snyk Scanner, you can enable the SCST - Store integration by appending the fields to the `values.yaml` file.

The Grype and Snyk Scanner Integrations both enable the Metadata Store. To prevent conflicts, the configuration values are slightly different based on whether the Grype Scanner Integration is installed or not. If Tanzu Application Platform is installed using the Full Profile, the Grype Scanner Integration is installed, unless it is explicitly excluded.

- If the Grype Scanner Integration is installed in the same `dev-namespace` Snyk Scanner is installed:

    ```yaml
    #! ...
    metadataStore:
      #! The url where the Store deployment is accesible.
      #! Default value is: "https://metadata-store-app.metadata-store.svc.cluster.local:8443"
      url: "STORE-URL"
      caSecret:
        #! The name of the secret that contains the ca.crt to connect to the Store Deployment.
        #! Default value is: "app-tls-cert"
        name: "CA-SECRET-NAME"
        importFromNamespace: "" #! since both Snyk and Grype both enable store, one must leave importFromNamespace blank
      #! authSecret is for multicluster configurations.
      authSecret:
        #! The name of the secret that contains the auth token to authenticate to the Store Deployment.
        name: "AUTH-SECRET-NAME"
        importFromNamespace: "" #! since both Snyk and Grype both enable store, one must leave importFromNamespace blank
    ```

- If the Grype Scanner Integration is not installed in the same `dev-namespace` Snyk Scanner is installed:

    ```yaml
    #! ...
    metadataStore:
      #! The url where the Store deployment is accesible.
      #! Default value is: "https://metadata-store-app.metadata-store.svc.cluster.local:8443"
      url: "STORE-URL"
      caSecret:
        #! The name of the secret that contains the ca.crt to connect to the Store Deployment.
        #! Default value is: "app-tls-cert"
        name: "CA-SECRET-NAME"
        #! The namespace where the secrets for the Store Deployment live.
        #! Default value is: "metadata-store"
        importFromNamespace: "STORE-SECRETS-NAMESPACE"
      #! authSecret is for multicluster configurations.
      authSecret:
        #! The name of the secret that contains the auth token to authenticate to the Store Deployment.
        name: "AUTH-SECRET-NAME"
        #! The namespace where the secrets for the Store Deployment live.
        importFromNamespace: "STORE-SECRETS-NAMESPACE"
    ```

**Without SCST - Store Integration:** The SCST - Store integration is enabled by default. If you don’t want to use this integration, deactivate the integration by appending the following field to the `values.yaml` file:

```yaml
# ...
metadataStore: {} # Deactivate Supply Chain Security Tools - Store integration
```

## <a id="snyk-scan-policy"></a> Sample ScanPolicy for Snyk in SPDX JSON format

1. Create a ScanPolicy YAML with a Rego file for scanner output in the SPDX JSON format. Here is a sample scan policy resource:

    ```yaml
    apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
    kind: ScanPolicy
    metadata:
      name: snyk-scan-policy
      labels:
        'app.kubernetes.io/part-of': 'enable-in-gui'
    spec:
      regoFile: |
        package main

        # Accepted Values: "Critical", "High", "Medium", "Low", "Negligible", "UnknownSeverity"
        notAllowedSeverities := ["Critical", "High", "UnknownSeverity"]
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
          msg = sprintf("CVE %s %s %s", [comp, vuln.id, ratings])
        }
    ```

1. Apply the YAML file by running:

    ```console
    kubectl apply -n $DEV_NAMESPACE -f SCAN-POLICY-YAML
    ```

>**Note** The Snyk Scanner integration is only available for an image scan, not a source scan.

After all prerequisites are completed, follow the steps in [Install another scanner for Supply Chain Security Tools - Scan](install-scanners.hbs.md) to install the Snyk Scanner.

# Prerequisites for Carbon Black Scanner for Supply Chain Security Tools - Scan(Beta)

This topic describes prerequisites you must complete to install Supply Chain Security Tools - Scan (Carbon Black Scanner) from the Tanzu Application Platform package repository. The Carbon Black Scanner integration is only available for an image scan, not a source scan.

>**Important** Carbon Black's image scanning capability is in beta. Carbon Black might only return
a partial list of CVEs when scanning Buildpack images.

## <a id="prerecs"></a> Prepare the Carbon Black Scanner configuration

To prepare the Carbon Black Scanner configuration before you install any scanners:

1. Obtain a Carbon Black API Token from Carbon Black Cloud.

2. Create a Carbon Black secret YAML file and insert the Carbon Black API configuration key. Obtain all values from your CBC console.

    ```yaml
    apiVersion: v1
    kind: Secret
    metadata:
      name: CARBONBLACK-CONFIG-SECRET
      namespace: my-apps
    stringData:
      cbc_api_id: CBC-API-ID
      cbc_api_key: CBC-API-KEY
      cbc_org_key: CBC-ORG-KEY
      cbc_saas_url: CBC-SAAS-URL
    ```

    Where:

    - `CBC-API-ID` is the API ID obtained from CBC.
    - `CBC-API-KEY` is the API Key obtained from CBC.
    - `CBC-ORG-KEY` is the Org Key of your CBC organization.
    - `CBC-SAAS-URL` is the CBC Backend URL.
  
3. Apply the Carbon Black secret YAML file by running:

    ```console
    kubectl apply -f YAML-FILE
    ```

    Where `YAML-FILE` is the name of the Carbon Black secret YAML file you created.

4. Define the `--values-file` flag to customize the default configuration.
Create a `values.yaml` file by using the following configuration:

    You must define the following fields in the `values.yaml` file for the Carbon Black Scanner configuration.
    You can add fields as needed to enable or deactivate behaviors.
    You can append the values to this file as shown later in this topic.

    ```yaml
    ---
    namespace: DEV-NAMESPACE
    targetImagePullSecret: TARGET-REGISTRY-CREDENTIALS-SECRET
    carbonBlack:
      configSecret:
        name: CARBONBLACK-CONFIG-SECRET
    ```

     - `DEV-NAMESPACE` is your developer namespace.

       >**Important** To use a namespace other than the default namespace, ensure that the namespace exists before you install.
       If the namespace does not exist, the scanner installation fails.

     - `TARGET-REGISTRY-CREDENTIALS-SECRET` is the name of the secret that contains the credentials to pull an image from a private registry for scanning.

     - `CARBONBLACK-CONFIG-SECRET` is the name of the secret you created that contains the Carbon Black configuration to connect to CBC.
       This field is required.

    The Carbon Black Scanner integration can work with or without the SCST - Store integration.
    The `values.yaml` file is slightly different for each configuration.

## <a id="store-integration"></a> Supply Chain Security Tools - Store integration

To Integrate:

1. Do one of the following procedures:

   - [Use the Supply Chain Security Tools - Store](#with-store)
   - [Without using the Supply Chain Security Tools - Store](#without-store)

2. Apply the YAML.

### <a id="with-store"></a> Using Supply Chain Security Tools - Store Integration

To persist the results found by the Carbon Black Scanner,
  you can enable the SCST - Store integration
  by appending the fields to the `values.yaml` file.

  The Grype and Carbon Black Scanner Integrations both enable the Metadata Store.
  To prevent conflicts, the configuration values are slightly different based on whether the Grype Scanner Integration is installed or not.
  If Tanzu Application Platform was installed using the Full Profile, the Grype Scanner Integration was installed, unless it was explicitly excluded.

  * If the Grype Scanner Integration is installed in the same `dev-namespace` Carbon Black Scanner is installed:

       ```yaml
       #! ...
       metadataStore:
         #! The url where the Store deployment is accessible.
         #! Default value is: "https://metadata-store-app.metadata-store.svc.cluster.local:8443"
         url: "STORE-URL"
         caSecret:
           #! The name of the secret that contains the ca.crt to connect to the Store Deployment.
           #! Default value is: "app-tls-cert"
           name: "CA-SECRET-NAME"
           importFromNamespace: "" #! since both Carbon Black and Grype both enable store, one must leave importFromNamespace blank
         #! authSecret is for multicluster configurations.
         authSecret:
           #! The name of the secret that contains the auth token to authenticate to the Store Deployment.
           name: "AUTH-SECRET-NAME"
           importFromNamespace: "" #! since both Carbon Black and Grype both enable store, one must leave importFromNamespace blank
       ```

  * If the Grype Scanner Integration is not installed in the same `dev-namespace` Carbon Black Scanner is installed:

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

### <a id="without-store"></a> Without Supply Chain Security Tools - Store Integration

If you don't want to enable the
  SCST - Store integration, explicitly deactivate the integration by appending
  the next field to the `values.yaml` file, because it's enabled by default:

  ```yaml
  # ...
  metadataStore:
    url: "" # Deactivate Supply Chain Security Tools - Store integration
  ```

## <a id="carbonblack-scan-policy"></a> Sample ScanPolicy in CycloneDX format

1. Create a ScanPolicy YAML with a Rego file for scanner output in the CycloneDX format.
    For example:

    ```yaml
    apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
    kind: ScanPolicy
    metadata:
      name: scan-policy
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
          severities := { e | e := match.ratings.rating.severity } | { e | e := match.ratings.rating[_].severity }
          some i
          fails := contains(notAllowedSeverities, severities[i])
          not fails
        }

        isSafe(match) {
          ignore := contains(ignoreCves, match.id)
          ignore
        }

        deny[msg] {
          comps := { e | e := input.bom.components.component } | { e | e := input.bom.components.component[_] }
          some i
          comp := comps[i]
          vulns := { e | e := comp.vulnerabilities.vulnerability } | { e | e := comp.vulnerabilities.vulnerability[_] }
          some j
          vuln := vulns[j]
          ratings := { e | e := vuln.ratings.rating.severity } | { e | e := vuln.ratings.rating[_].severity }
          not isSafe(vuln)
          msg = sprintf("CVE %s %s %s", [comp.name, vuln.id, ratings])
        }
    ```

1. Apply the YAML:

    ```console
    kubectl apply -n $DEV_NAMESPACE -f SCAN-POLICY-YAML
    ```

After all prerequisites are completed, follow the steps in [Install another scanner for Supply Chain Security Tools - Scan](install-scanners.hbs.md) to install the Carbon Black Scanner.
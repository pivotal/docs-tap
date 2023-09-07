# Configure Artifact Metadata Repository

This tells you how to configure Artifact Metadata Repository (AMR).

## <a id='amr-observer'></a> AMR Observer

You can obtain the Tanzu Application Platform values schema with the following command:

```console
tanzu package available get amr-observer.apps.tanzu.vmware.com/0.1.0-alpha.8 --values-schema --namespace tap-install
```

Values are under the `amr` root key, not under the `metadata_store` root key. 

>**Note** If AMR Observer is deployed [standalone](./install-amr-observer.hbs.md#installing-artifact-metadata-repository-observer-standalone) and not through Tanzu Application Platform package, the values file for a standalone package installation does not have the Tanzu Application Platform value root keys of `amr.observer` or `amr.deploy_observer`.

A template of the AMR Observer Tanzu Application Platform values:

```yaml
amr: 
  observer:
    location: |
      labels:
      - key: environment
        value: prod
    resync_period: "5h"
    cloudevent_handler:
      endpoint: "https://amr-persister.<DOMAIN>"
      liveness_period_seconds: 25
    ca_cert_data: |
      -----BEGIN CERTIFICATE-----
      Custom CA certificate for AMR CloudEvent Handler's HTTPProxy with custom TLS certs
      -----END CERTIFICATE-----
```

Configuration options:

- `amr.observer.location`
  - Default: ""
  - Location is the multiline string configuration for the location.conf content.
  - The YAML string can contain additional fields:
    - `labels`: Consists of an array for key and value pairing. Useful for adding searchable and identifiable metadata.

- `amr.observer.resync_period`
  - Default: "10h"
  - resync_period determines the minimum frequency at which watched resources are reconciled. A lower period will correct entropy more quickly, but reduce responsiveness to change if there are many watched resources. Change this value only if you know what you are doing. Defaults to 10 hours if unset.

- `amr.observer.ca_cert_data` or `shared.ca_cert_data`
  - Default: ""
  - `ca_cert_data` is used to add certificates to the truststore that is used by the AMR Observer.
    ```console
    kubectl -n metadata-store get secrets/amr-cloudevent-handler-ingress-cert -o jsonpath='{.data."crt.ca"}' | base64 -d
    ```

- `amr.observer.cloudevent_handler.endpoint`
  - Default: `http://amr-cloudevent-handler.metadata-store.svc.cluster.local:80`
  - The URL of the AMR CloudEvent Handler endpoint.
  - On the view or full Tanzu Application Platform profile cluster, obtain the AMR CloudEvent Handler ingress address. Obtain the FQDN of the AMR CloudEvent Handler:
    
    ```console
    kubectl -n metadata-store get httpproxies.projectcontour.io amr-cloudevent-handler-ingress -o jsonpath='{.spec.virtualhost.fqdn}'
    ```

  >**Note** Ensure that the correct protocol is set. If there is TLS, `https://` must be prepended. If there is no TLS, `http://` must be prepended.

- `amr.observer.cloudevent_handler.liveness_period_seconds`
  - Default: 25
  - The period in seconds between executed health checks to the AMR CloudEvent Handler endpoint.

- `amr.observer.autoconfiguration.create_kubernetes_service_accounts`
  - Default: ""
  - For tap 'full' profile, delegates creation of service accounts to the Metadata Store.

- `amr.observer.auth.kubernetes_service_accounts`
  - `.enabled`
    - Default: `true`
    - Include Authorization header when communicating with AMR CloudEvent Handler.
  - `.secret`
    - The secret with the access token for communicating with the cloudevent-handler
    - `.ref`
      - Default: ""
      - Secret name which contains the access token.
    - `.value`
      - Default: ""
      - Secret as a plain text string. This allows integrating with TMC secret imports.

- `amr.observer.create_auth_autoconfig_secretimport`
  - Default: `null`
  - Import the AMR CloudEvent Handler Service Account Token Secret required by for communicating with the AMR CloudEvent Handler. For single cluster only

- `amr.observer.deployed_through_tmc`
  - Default: `null`
  - Tap Multi Cluster deployment will happen through Tanzu Mission Control when `deployed_through_tmc` is set to true


## <a id='amr-observer'></a> AMR Observer

- `amr.graphql.auth.kubernetes_service_accounts.enabled`
  - Default: true
  - Requires Authorization header when communicating with AMR GraphQL.

- `amr.cloudevent_handler.auth.kubernetes_service_accounts.enabled`
  - Default: true
  - Requires Authorization header when communicating with AMR CloudEvent Handler.
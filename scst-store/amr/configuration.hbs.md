# Configure Artifact Metadata Repository

This topic tells you how to configure Artifact Metadata Repository (AMR).

## <a id='amr-observer'></a> AMR Observer

You can obtain the Tanzu Application Platform values schema by running:

```console
tanzu package available get amr-observer.apps.tanzu.vmware.com/0.1.0-alpha.8 --values-schema --namespace tap-install
```

Values are under the `amr` root key, not under the `metadata_store` root key. 

>**Note** If AMR Observer is deployed [standalone](./install-amr-observer.hbs.md#installing-artifact-metadata-repository-observer-standalone) not through a Tanzu Application Platform package, the values file for a standalone package installation does not have the Tanzu Application Platform value root keys of `amr.observer` or `amr.deploy_observer`.

The following is an example template of the AMR Observer Tanzu Application Platform values:

```yaml
amr: 
  observer:
    location: |
      labels:
      - key: environment
        value: prod
    resync_period: "5h"
    cloudevent_handler:
      endpoint: "https://amr-cloudevent-handler.DOMAIN"
      liveness_period_seconds: 25
    ca_cert_data: |
      -----BEGIN CERTIFICATE-----
      Custom CA certificate for AMR CloudEvent Handler's HTTPProxy with custom TLS certs
      -----END CERTIFICATE-----
```

Where `DOMAIN` is the domain you want to target.

Configuration options:

- `amr.observer.location`
  - Default: ""
  - Location is the multiline string configuration for the location content.
  - The YAML string can contain additional fields:
    - `labels`: Consists of an array for key and value pairing. Useful for adding searchable and identifiable metadata.

- `amr.observer.resync_period`
  - Default: "10h"
  - `resync_period` sets the minimum frequency at which watched resources are reconciled. A lower period corrects entropy more quickly, but reduce responsiveness to change if there are many watched resources. Defaults to 10 hours if unset.

- `amr.observer.ca_cert_data` or `shared.ca_cert_data`
  - Default: ""
  - `ca_cert_data` adds certificates to the trust store that the AMR Observer uses.

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

  >**Note** Ensure that you set the correct protocol. If there is TLS, you must prepend `https://`. If there is no TLS, you must prepend `http://`.

- `amr.observer.cloudevent_handler.liveness_period_seconds`
  - Default: 25
  - The period in seconds between executed health checks to the AMR CloudEvent Handler endpoint.

- `amr.observer.autoconfiguration.create_kubernetes_service_accounts`
  - Default: ""
  - For the Full profile, this delegates creation of service accounts to the Metadata Store.

- `amr.observer.auth.kubernetes_service_accounts`
  - `.enabled`
    - Default: `true`
    - Include an Authorization header when communicating with AMR CloudEvent Handler.
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
  - Tanzu Application Platform multicluster deployment happens through Tanzu Mission Control when you set `deployed_through_tmc` to true.

## <a id='amr-graphql'></a> AMR GraphQL

- `amr.graphql.auth.kubernetes_service_accounts.enabled`
  - Default: true
  - Requires Authorization header when communicating with AMR GraphQL.

## <a id='amr-cloudevent-handler'></a> AMR CloudEvent Handler

- `amr.cloudevent_handler.auth.kubernetes_service_accounts.enabled`
  - Default: true
  - Requires Authorization header when communicating with AMR CloudEvent Handler.
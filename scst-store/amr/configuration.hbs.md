# Configure Artifact Metadata Repository

This tells you how to configure Supply Chain Security Tools (SCST) - Artifact Metadata Repository (AMR).

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
  deploy_observer: true
  observer:
    location: |
      alias: CLUSTER_ALIAS # Optional
      labels:
      - key: environment
        value: prod
    resync_period: "5h"
    eventhandler:
      endpoint: "https://amr-persister.<DOMAIN>"
      liveness_period_seconds: 25
    ca_cert_data: |
      -----BEGIN CERTIFICATE-----
      Custom CA certificate for AMR CloudEvent Handler's HTTPProxy with custom TLS certs
      -----END CERTIFICATE-----
```

Configuration options:

- `amr.deploy_observer`
  - Default: `false`
  - If deployed on a full profile Tanzu Application Platform cluster and `metadata-store.amr.deploy` is `false`, this overrides `amr.deploy_observer` to be `false`.

- `amr.observer.location`
  - Default: ""
  - Location is the multiline string configuration for the location.conf content.
  - The YAML string can contain additional fields:
    - `alias`: An alias for the cluster's location. If no alias is specified, the reference of the `kube-system` namespace UID is used.
    - `labels`: Consists of an array for key and value pairing. Useful for adding searchable and identifiable metadata.

- `amr.observer.resync_period`
  - Default: "10h"
  - Determines the minimum frequency at which watched resources are reconciled. A lower period corrects entropy more quickly, but reduce responsiveness to change if there are many watched resources. Change this value only if you know what you are doing.

- `amr.observer.ca_cert_data` or `shared.ca_cert_data`
  - Default: ""
  - The AMR Observer uses the truststore to add certificates. You can get the CA Certificate on the cluster running AMR CloudEvent Handler:
 
    ```console
    kubectl -n metadata-store get secrets/amr-persister-ingress-cert -o jsonpath='{.data."crt.ca"}' | base64 -d
    ```

- `amr.observer.eventhandler.endpoint`
  - Default: ""
  - The URL of the CloudEvent handler endpoint.
  - On the view or full Tanzu Application Platform profile cluster, obtain the AMR CloudEvent Handler ingress address. Obtain the FQDN of the AMR CloudEvent Handler:
    
    ```console
    kubectl -n metadata-store get httpproxies.projectcontour.io amr-persister-ingress -o jsonpath='{.spec.virtualhost.fqdn}'
    ```

  >**Note** Ensure that the correct protocol is set. If there is TLS, `https://` must be prepended. If there is no TLS, `http://` must be prepended.

- `amr.observer.eventhandler.liveness_period_seconds`
  - Default: 25
  - The period in seconds between executed health checks to the Artifact Metadata Repository CloudEvent Handler endpoint.

# Configuration

This topic describes the configuration options available for Supply Chain Security Tools (SCST) – Artifact Metadata Repository (AMR).

## AMR Observer

The TAP Values schema can be obtained with the following command:
```bash
tanzu package available get amr-observer.apps.tanzu.vmware.com/0.1.0-alpha.8 --values-schema --namespace tap-install
```

**Note:** The AMR Observer TAP Values are not under the metadata_store root key. It is in the amr root key.

A template of the AMR Observer TAP values.

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


* `amr.deploy_observer`
	* Default: False
  * If deployed on a full profile TAP cluster and `metadata-store.amr.deploy` is false, this will override `amr.deploy_observer` to be false.

* `amr.observer.location`
	* Default: ""
  * Location is the multiline string configuration for the location.conf content.
  * The YAML string can contain additional fields:
    * `alias`: An alias for the cluster's location. If no alias is specified, the reference of the `kube-system` namespace UID will be used.
    * `labels`: Consists of an array for key and value pairing. Useful for adding searchable and identifiable metadata.

* `amr.observer.resync_period`
	* Default: "10h"
  * Determines the minimum frequency at which watched resources are reconciled. A lower period will correct entropy more quickly, but reduce responsiveness to change if there are many watched resources. Change this value only if you know what you are doing.

* `amr.observer.ca_cert_data` or `shared.ca_cert_data`
	* Default: ""
  * Used to add certificates to the truststore that is used by the AMR Observer. The CA Certificate can be obtained with the following command on the cluster running AMR CloudEvent Handler. 
    ```bash
    kubectl -n metadata-store get secrets/amr-persister-ingress-cert -o jsonpath='{.data."crt.ca"}' | base64 -d
    ```

* `amr.observer.eventhander.endpoint`
	* Default: ""
  * The URL of the CloudEvent handler endpoint.
  * On the view or full profile cluster, obtain the AMR CloudEvent Handler ingress address. The following command can be used to obtain the FQDN of the AMR CloudEvent Handler:
    ```bash
    kubectl -n metadata-store get httpproxies.projectcontour.io amr-persister-ingress -o jsonpath='{.spec.virtualhost.fqdn}'
    ```
  **Note:** Ensure that the correct protocol is set. If there is TLS, `https://` needs to be prepended. If there is no TLS, `http://` needs to be prepended.

* `amr.observer.eventhandler.liveness_period_seconds`
	* Default: 25
  * The period in seconds between executed health checks to the CloudEvent Handler endpoint.

# Artifact Metadata Repository Observer

## Prerequisite

If on a Full Profile, AMR and AMR CloudEvent Handler also need to be deployed. To do so, additional TAP Values are required.

```yaml
metadata_store:
    amr:
        deploy: true
```

Alternatively, AMR and AMR CloudEvent Handler must be deployed and accessible by the cluster where AMR Observer is to be deployed.

## Install
To deploy AMR Observer on a Full, Build, or Run TAP profile, the TAP values must be updated with:

```yaml
amr: 
  deploy_observer: true
```

**Note:** If deployed on a full profile TAP cluster and metadata-store.amr.deploy is false, this will override amr.deploy_observer to be false.

When AMR Observer is being installed on a different cluster from AMR and AMR CloudEvent Handler, additional values will be required.
* `amr.observer.eventhandler.endpoint` is required for the Observer to send to the AMR CloudEvent Handler.
* `amr.observer.eventhandler.ca_cert_data` or `shared.ca_cert_data` are required for AMR CloudEvent Handlers that use Custom CA certs to generate the associated TLS certificate for the ingress endpoint.


**Note:** If SCST - Scan 2.0 is installed after AMR Observer has already been deployed, a deployment restart will be required for AMR Observer to observe the new ImageVulerabilityScan Custom Resource that was installed with SCST - Scan 2.0. The following command can be used:
```bash
kubectl -n amr-observer-system rollout restart deployment amr-observer-controller-manager
```

See [Configuration - AMR Observer](./configuration.hbs.md#amr-observer) for more information.
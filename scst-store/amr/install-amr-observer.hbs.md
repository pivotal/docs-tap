# Artifact Metadata Repository Observer

## Prerequisite

If on a Full Profile, AMR and AMR CloudEvent Handler also need to be deployed. To do so, additional TAP Values are required.

```yaml
metadata_store:
    amr:
        deploy: true
```

Alternatively, AMR and AMR CloudEvent Handler must be deployed and accessible by the cluster where AMR Observer is to be deployed.

## Switching Context

If Artifact Metadata Repository Observer is installed on a separate cluster from AMR CloudEvent Handler, it is important that the correct cluster is targeted when updating the installation.

```bash
# Switch context to cluster with AMR Observer
kubectl config use-context OBSERVER-CLUSTER-NAME

# update the tap-values in an editor according to the desired configuration

# update the installed TAP package on the cluster
tanzu package installed update tap --values-file tap-values.yaml -n tap-install
```

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

## Installing Artifact Metadata Repository Observer Standalone

1. To install AMR Observer standalone from a TAP profile, determine the available version for installation:
  ```bash
  $ tanzu package available list amr-observer.apps.tanzu.vmware.com -n tap-install

    NAME                                VERSION        RELEASED-AT
    amr-observer.apps.tanzu.vmware.com  0.1.0-alpha.8  2023-06-08 16:17:22 -0400 EDT
  ```

2. Get the values-schema to create the desire values file
  ```bash
  $ tanzu package available get amr-observer.apps.tanzu.vmware.com/0.1.0-alpha.8 --values-schema --namespace tap-install

    KEY                                   DEFAULT  TYPE     DESCRIPTION
    ca_cert_data                                   string   ca_cert_data is used to add certificates to the truststore that is used by the amr-observer.
    eventhandler.endpoint                          string   The URL of the cloudevent handler endpoint.
    eventhandler.liveness_period_seconds           integer  The period in seconds between executed health checks to the cloudevent handler endpoint.
    location                                       string   location is the multiline string configuration for the location.conf content.
    resync_period                                  string   resync_period determines the minimum frequency at which watched resources are reconciled. A lower period will correct entropy more quickly, but reduce responsiveness to change if there are many watched resources. Change this value only if you know what you are doing. Defaults to 10 hours if unset.
  ```

3. A sample `values-file.yaml` for installing AMR Observer standalone where AMR CloudEvent Handler is also deployed.

```yaml
eventhandler:
  endpoint: http://amr-persister.metadata-store.svc.cluster.local
```

It is important to note that the values file for a standalone package installation does not have the TAP value root key of `amr`, `amr.observer`, or `amr.deploy_observer`.

For more information, see [Configuration](./configuration.hbs.md#Configuration).

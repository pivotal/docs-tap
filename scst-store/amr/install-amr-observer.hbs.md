# Artifact Metadata Repository Observer for Supply Chain Security Tools - Store

This topic tells you how to install Artifact Metadata Repository (AMR) Observer for Supply Chain Security Tools (SCST) - Store.

## <a id='prerecs'></a> Prerequisites

You must deploy AMR and AMR CloudEvent Handler if you are using the Full profile. To do so, additional Tanzu Application Platform values are required.

```yaml
metadata_store:
    amr:
        deploy: true
```

Alternatively, AMR and AMR CloudEvent Handler must be deployed and accessible by the cluster where AMR Observer is deployed.

## <a id='switch-context'></a> Switching Context

If Artifact Metadata Repository Observer is installed on a separate cluster from AMR CloudEvent Handler, you must ensure that the correct cluster is targeted before updating package values.

```console
# 1. Switch context to cluster with AMR Observer
kubectl config use-context OBSERVER-CLUSTER-NAME

# 2. Update the tap-values.yaml in an editor according to the desired configuration

# 3. Update the installed TAP package on the cluster
tanzu package installed update tap --values-file tap-values.yaml -n tap-install
```

Where `OBSERVER-CLUSTER-NAME` is the name of the cluster you want to use.

## <a id='install'></a> Install

To deploy AMR Observer on a Full, Build, or Run Tanzu Application Platform profile, update the Tanzu Application Platform values:

```yaml
amr: 
  deploy_observer: true
```

>**Note** If deployed on a full profile Tanzu Application Platform cluster and `metadata-store.amr.deploy` is `false`, this overrides `amr.deploy_observer` to `false`.

When AMR Observer is installed on a different cluster from AMR and AMR CloudEvent Handler, the following values are required:

- `amr.observer.eventhandler.endpoint` is required for the Observer to send to the AMR CloudEvent Handler.
- `amr.observer.eventhandler.ca_cert_data` or `shared.ca_cert_data` are required for AMR CloudEvent Handlers that use Custom CA certificates to generate the associated TLS certificate for the ingress endpoint.

>**Note** If SCST - Scan 2.0 is installed after AMR Observer has already been deployed, a deployment you must restart AMR Observer to observe the new ImageVulerabilityScan Custom Resource that was installed with SCST - Scan 2.0.

```console
kubectl -n amr-observer-system rollout restart deployment amr-observer-controller-manager
```

The following log appears if the AMR Observer is observing the ImageVulnerabilityScan Custom Resource:

```log
2023-06-28T17:56:43Z  INFO  Starting Controller  {"controller": "imagevulnerabilityscan", "controllerGroup": "app-scanning.apps.tanzu.vmware.com", "controllerKind": "ImageVulnerabilityScan"}
```

For information about logging, see [Troubleshoot - AMR Observer Logs](./troubleshooting.hbs.md#amr-observer-logs).

See [Configuration - AMR Observer](./configuration.hbs.md#amr-observer).

## <a id='standalone-install'></a> Installing Artifact Metadata Repository Observer Standalone

1. To install AMR Observer standalone from a Tanzu Application Platform profile, verify the available version:
  
  ```console
  $ tanzu package available list amr-observer.apps.tanzu.vmware.com -n tap-install

    NAME                                VERSION        RELEASED-AT
    amr-observer.apps.tanzu.vmware.com  0.1.0-alpha.8  2023-06-08 16:17:22 -0400 EDT
  ```

1. Get the values-schema to create the values file:
  
  ```console
  $ tanzu package available get amr-observer.apps.tanzu.vmware.com/0.1.0-alpha.8 --values-schema --namespace tap-install

    KEY                                   DEFAULT  TYPE     DESCRIPTION
    ca_cert_data                                   string   ca_cert_data is used to add certificates to the truststore that is used by the amr-observer.
    eventhandler.endpoint                          string   The URL of the cloudevent handler endpoint.
    eventhandler.liveness_period_seconds           integer  The period in seconds between executed health checks to the cloudevent handler endpoint.
    location                                       string   location is the multiline string configuration for the location.conf content.
    resync_period                                  string   resync_period determines the minimum frequency at which watched resources are reconciled. A lower period will correct entropy more quickly, but reduce responsiveness to change if there are many watched resources. Change this value only if you know what you are doing. Defaults to 10 hours if unset.
  ```

1. A sample `values-file.yaml` for installing AMR Observer standalone on a cluster where AMR CloudEvent Handler is present.

  ```yaml
  eventhandler:
    endpoint: http://amr-persister.metadata-store.svc.cluster.local
  ```

The values file for a standalone package installation does not have the Tanzu Application Platform value root key of `amr.observer` or `amr.deploy_observer`.

For more information, see [Configuration](./configuration.hbs.md#Configuration).

# Artifact Metadata Repository Observer for Supply Chain Security Tools - Store

This topic tells you how to install Artifact Metadata Repository (AMR) Observer for Supply Chain Security Tools (SCST) - Store.

## <a id='prerecs'></a> Prerequisites

The AMR Observer is deployed by default on the Tanzu Application Platform Full, Build and Run profiles.

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

## <a id='install'></a> Configuring AMR Observer in a multicluster deployment

When you install AMR Observer on a different cluster from the AMR CloudEvent
Handler, the following values are required:

- `amr.observer.cloudevent_handler.endpoint` is required for the Observer to send to the AMR CloudEvent Handler.
- `amr.observer.cloudevent_handler.ca_cert_data` or `shared.ca_cert_data` are required for AMR CloudEvent Handlers that use Custom CA certificates to generate the associated TLS certificate for the ingress endpoint.

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
    amr-observer.apps.tanzu.vmware.com  0.2.0          2023-10-05 16:17:22 -0400 EDT
  ```

1. Look at the package values-schema to create the values file. For more
   information, see [Configuration](./configuration.hbs.md#Configuration).
  
  ```console
  $ tanzu package available get amr-observer.apps.tanzu.vmware.com/0.2.0 --values-schema --namespace tap-install

    KEY                                                                    DEFAULT                                                                TYPE     DESCRIPTION
    deployed_through_tmc                                                   false                                                                  boolean  TAP Multi Cluster deployment will happen through Tanzu Mission Control when `deployed_through_tmc` is set to true
    observer.auth.kubernetes_service_accounts.autoconfigure                true                                                                   boolean  Delegate creation of auth token secret to AMR Observer. By default it is set to true.
    observer.auth.kubernetes_service_accounts.enable                       true                                                                   boolean  Include Authorization header when communicating with AMR CloudEvent Handler.
    observer.auth.kubernetes_service_accounts.secret.ref                   amr-observer-edit-token                                                string   Secret name which contains the access token.
    observer.auth.kubernetes_service_accounts.secret.value                 ""                                                                     string   Secret as a plain text string. This allows integrating with Tanzu Mission Control secret imports.
    observer.ca_cert_data                                                  ""                                                                     string   ca_cert_data is used to add certificates to the truststore that is used by the amr-observer.
    observer.cloudevent_handler.endpoint                                   "http://amr-cloudevent-handler.metadata-store.svc.cluster.local:80"    string   The URL of the cloudevent handler endpoint.
    observer.cloudevent_handler.liveness_period_seconds                    10                                                                     integer  The period in seconds between executed health checks to the cloudevent handler endpoint.
    observer.location                                                      ""                                                                     string   location is the multiline string configuration for the location.conf content.
    observer.max_concurrent_reconciles.image_vulnerability_scans           1                                                                      integer  Max concurrent reconciles for observing ImageVulnerabilityScans.
    observer.resync_period                                                 10h                                                                    string   resync_period determines the minimum frequency at which watched resources are reconciled.
                                                                                                                                                           A lower period will correct entropy more quickly, but reduce
                                                                                                                                                           responsiveness to change if there are many watched resources. Change this value only if you
                                                                                                                                                           know what you are doing. Defaults to 10 hours if unset.
    ```

1. Install the package using `tanzu package install`.

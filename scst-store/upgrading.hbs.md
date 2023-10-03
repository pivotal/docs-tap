# Upgrading Supply Chain Security Tools - Store

This topic describes how you can troubleshoot upgrading issues in Supply Chain
Security Tools (SCST) - Store.

## <a id="upgrading-1-7"></a>Upgrading to 1.7

In TAP 1.7, we introduce the Artifact Metadata Repository (AMR) into SCST - Store.
AMR components will be installed by default after the upgrade.

How AMR needs to be configured depends on how TAP was deployed.

* TAP is installed in a single cluster (Full profile) deployment
* TAP is installed in a multicluster deployment

###<a id="full-profile-upgrade"></a> Single cluster (Full profile) upgrade

In a Full profile, AMR does not need any additional user configuration. See
[AMR architecture](amr/architecture.hbs.md) and
[deployment details](deployment-details.hbs.md) for more information.

### <a id="multicluster-upgrade"></a> Multicluster upgrade

In a multicluster deployment, AMR components are installed on the View, Build and
Run clusters. The AMR Observer is installed on the Build and Run clusters, and
needs to be configured to talk to the AMR CloudEvent Handler installed on the View
cluster.

Read [SCST - Store multicluster setup](multicluster-setup.hbs.md) for the new
configuration in detail. The doc includes instructions for configuring both the
AMR (new) and the Metadata Store (existing). The new configurations for 1.7 are:

1. [Copy AMR CloudEvent Handler CA certificate data from the View
   cluster](multicluster-setup.hbs.md#copy-ceh-ca)
1. [Copy AMR CloudEvent Handler edit token from the View
   cluster](multicluster-setup.hbs.md#copy-ceh-token)
1. [Apply the CloudEvent Handler CA certificate data and edit token to the Build
   and Run clusters](multicluster-setup.hbs.md#apply-ceh-ca-token)


## <a id="troubleshoot"></a>Troubleshoot upgrading

### <a id="observer-cannot-talk-to-ceh"></a> AMR Observer cannot talk to AMR CloudEvent Handler

To see the AMR Observer pod, use this command.

```console
kubectl get pods -n amr-observer-system
```

To view AMR Observer logs, use this command.

```console
kubectl logs OBSERVER-POD-NAME -n amr-observer-system
```

Where:

* `OBSERVER-POD-NAME` is the name of the AMR observer pod

If you encounter errors relating to the authentication token, check that you have
configured the AMR Observer correctly. It may be missing the edit token for the AMR
CloudEvent Handler. See [SCST - Store multicluster setup](multicluster-setup.hbs.md)
for more information on how to configure the edit token, as well as the CA cert and
endpoint.


### <a id="deploy-does-not-exist"></a> Database deployment does not exist

To prevent issues with the metadata store database, such as the ones described in
this topic, the database deployment is `StatefulSet` in

* Tanzu Application Platform v1.2 and later
* Metadata Store v1.1 and later

If you have scripts searching for a `metadata-store-db` deployment, edit the scripts to
instead search for `StatefulSet`.


### <a id="invalid-checkpoint-record"></a> Invalid checkpoint record

When using Tanzu to upgrade to a new version of the store, there is occasionally data
corruption. Here is an example of how this shows up in the log:

```console
PostgreSQL Database directory appears to contain a database; Skipping initialization

2022-01-21 21:53:38.799 UTC [1] LOG:  starting PostgreSQL 13.5 (Ubuntu 13.5-1.pgdg18.04+1) on x86_64-pc-linux-gnu, compiled by gcc (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0, 64-bit
2022-01-21 21:53:38.799 UTC [1] LOG:  listening on IPv4 address "0.0.0.0", port 5432
2022-01-21 21:53:38.799 UTC [1] LOG:  listening on IPv6 address "::", port 5432
2022-01-21 21:53:38.802 UTC [1] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
2022-01-21 21:53:38.807 UTC [14] LOG:  database system was shut down at 2022-01-21 21:21:12 UTC
2022-01-21 21:53:38.807 UTC [14] LOG:  invalid record length at 0/1898BE8: wanted 24, got 0
2022-01-21 21:53:38.807 UTC [14] LOG:  invalid primary checkpoint record
2022-01-21 21:53:38.807 UTC [14] PANIC:  could not locate a valid checkpoint record
2022-01-21 21:53:39.496 UTC [1] LOG:  startup process (PID 14) was terminated by signal 6: Aborted
2022-01-21 21:53:39.496 UTC [1] LOG:  aborting startup due to startup process failure
2022-01-21 21:53:39.507 UTC [1] LOG:  database system is shut down
```

The log shows a database pod in a failure loop. For steps to fix the issue so that the
upgrade can proceed, see the [SysOpsPro documentation](https://sysopspro.com/fix-postgresql-error-panic-could-not-locate-a-valid-checkpoint-record/).


### <a id="upgraded-pod-hanging"></a> Upgraded pod hanging

Because the default access mode in the PVC is `ReadWriteOnce`, if you are deploying in an
environment with multiple nodes then each pod might be on a different node.
This causes the upgraded pod to spin up but then get stuck initializing because the original
pod does not stop.
To resolve this issue, find and delete the original pod so that the new pod can attach to the
persistent volume:

1. Discover the name of the app pod that is not in a pending state by running:

    ```console
    kubectl get pods -n metadata-store
    ```

1. Delete the pod by running:

    ```console
    kubectl delete pod METADATA-STORE-APP-POD-NAME -n metadata-store
    ```

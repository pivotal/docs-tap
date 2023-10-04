# Upgrade Supply Chain Security Tools - Store

This topic tells you how to upgrade Supply Chain Security Tools (SCST) - Store and how to troubleshoot upgrade issues.

## <a id="upgrading-1-7"></a>Upgrading to 1.7

In Tanzu Application Platform v1.7, VMware introduces Artifact Metadata Repository (AMR) to SCST - Store.
Tanzu Application Platform installs AMR components by default after upgrading.

How you must configure AMR depends on how Tanzu Application Platform was deployed:

* Tanzu Application Platform is installed in a single cluster, Full profile, deployment.
* Tanzu Application Platform is installed in a multicluster deployment.

### <a id="full-profile-upgrade"></a> Single cluster or Full profile upgrade

In a Full profile, AMR does not need any additional user configuration. See
[AMR architecture](amr/architecture.hbs.md) and
[deployment details](deployment-details.hbs.md).

### <a id="multicluster-upgrade"></a> Multicluster upgrade

In a multicluster deployment, AMR components are installed on the View, Build and
Run clusters. The AMR Observer is installed on the Build and Run clusters, and
must be configured to talk to the AMR CloudEvent Handler installed on the View
cluster.

Read [SCST - Store multicluster setup](multicluster-setup.hbs.md) for the new
configuration in detail. The documentation includes instructions for configuring both the
new AMR and the existing Metadata Store. The new configurations for 1.7 are:

1. [Copy AMR CloudEvent Handler CA certificate data from the View
   cluster](multicluster-setup.hbs.md#copy-ceh-ca)
2. [Copy AMR CloudEvent Handler edit token from the View
   cluster](multicluster-setup.hbs.md#copy-ceh-token)
3. [Apply the CloudEvent Handler CA certificate data and edit token to the Build
   and Run clusters](multicluster-setup.hbs.md#apply-ceh-ca-token)

## <a id="troubleshoot"></a>Troubleshoot upgrading

The following sections tell you how to troubleshoot AMR upgrades.

### <a id="observer-cannot-talk-to-ceh"></a> AMR Observer cannot talk to AMR CloudEvent Handler

To see the AMR Observer pod:

```console
kubectl get pods -n amr-observer-system
```

To view AMR Observer logs:

```console
kubectl logs OBSERVER-POD-NAME -n amr-observer-system
```

Where:

* `OBSERVER-POD-NAME` is the name of the AMR observer pod.

If you encounter errors relating to the authentication token, verify that you
configured the AMR Observer correctly. It might be missing the edit token for the AMR
CloudEvent Handler. For information about how to configure the edit token, and the CA certificate and
endpoint, see [SCST - Store multicluster setup](multicluster-setup.hbs.md).

### <a id="deploy-does-not-exist"></a> Database deployment does not exist

To prevent issues with the metadata store database, such as the ones described in
this topic, the database deployment is `StatefulSet` in:

* Tanzu Application Platform v1.2 and later
* Metadata Store v1.1 and later

If you have scripts searching for a `metadata-store-db` deployment, edit the scripts to
instead search for `StatefulSet`.

### <a id="invalid-checkpoint-record"></a> Invalid checkpoint record

When you use Tanzu to upgrade SCST - Store, there is occasionally data
corruption. For example:

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

The log shows a database pod in a failure loop. For information about how to fix the issue, see the [SysOpsPro documentation](https://sysopspro.com/fix-postgresql-error-panic-could-not-locate-a-valid-checkpoint-record/).

### <a id="upgraded-pod-hanging"></a> Upgraded pod stops responding

Because the default access mode in the PVC is `ReadWriteOnce`, if you are deploying in an
environment with multiple nodes then each pod might be on a different node.
This causes the upgraded pod to spin up but then get stuck initializing because the original
pod does not stop.
To resolve this issue, find, and delete the original pod so that the new pod can attach to the
persistent volume:

1. Discover the name of the app pod that is not in a pending state by running:

    ```console
    kubectl get pods -n metadata-store
    ```

2. Delete the pod by running:

    ```console
    kubectl delete pod METADATA-STORE-APP-POD-NAME -n metadata-store
    ```
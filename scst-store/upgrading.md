# Troubleshooting upgrading

This topic describes upgrading issues and resolutions.

## <a id="deploy-does-not-exist"></a> Database deployment does not exist

To prevent issues with the metadata store database, such as the ones described in
this topic, the database deployment is `StatefulSet` in

* Tanzu Application Platform v1.2 and later
* Metadata Store v1.1 and later

If you have scripts searching for a `metadata-store-db` deployment, edit the scripts to
instead search for `StatefulSet`.


## <a id="invalid-checkpoint-record"></a> Invalid checkpoint record

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


## <a id="upgraded-pod-hanging"></a> Upgraded pod hanging

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

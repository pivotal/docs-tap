## Upgrading

### DB deployment does not exist

In order to prevent issues with the metadata store database such as the ones below, the database deployment is now a `StatefulSet`.
If you have scripts looking for a `metadata-store-db` `Deployment`, this will need to be changed to instead look for the `StatefulSet`.

### Invalid checkpoint record
When using tanzu to upgrade to a new version of the store, there is occasionally data corruption identified by something like this in the log:

```
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

You will see the DB pod in a crash loop. There are steps to correct the issue so that the upgrade can proceed: https://sysopspro.com/fix-postgresql-error-panic-could-not-locate-a-valid-checkpoint-record/


### Upgraded pod hanging

Due to the default access mode in the PVC being `ReadWriteOnce`, if you are deploying in an environment with multiple nodes,
there is a chance that each pod is on a different node. This means that the upgraded pod spins up but is stuck initializing
because the original pod does not terminate. This means the new pod cannot attach to the persistent volume until the original
pod is deleted. This can be done manually to solve this issue.

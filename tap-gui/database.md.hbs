# Configuring the Tanzu Application Platform GUI database

The Tanzu Application Platform GUI catalog allows for two approaches for storing catalog information:

- **In-memory database:** The default option uses an in-memory database and is suitable for test and
  development scenarios only.
  The in-memory database reads the catalog data from Git URLs that you write in `tap-values.yaml`.

  This data is temporary. Any operations that cause the `server` pod in the `tap-gui` namespace
  to be re-created also cause this data to be rebuilt from the Git location.

  This can cause issues when you manually register entities by using the UI because they only exist
  in the database and are lost when that in-memory database is rebuilt.
  If you choose this method, you lose all user preferences and any manually registered entities when
  the Tanzu Application Platform GUI server pod is re-created.

- **PostgreSQL database:** For production use-cases, use a PostgreSQL database that exists outside
  the Tanzu Application Platform packaging.
  The PostgreSQL database stores all the catalog data persistently both from the Git locations and
  the UI manual entity registrations.

For production or general-purpose use-cases, VMware recommends using a PostgreSQL database.

## <a id="config-postgresql"></a> Configure a PostgreSQL database

To use a PostgreSQL database:

1. Use the following values in `tap-values.yaml`:

    ```yaml
        backend:
          baseUrl: http://tap-gui.INGRESS-DOMAIN
          cors:
            origin: http://tap-gui.INGRESS-DOMAIN
        # Existing tap-values.yaml above
          database:
          client: pg
            connection:
              host: PG-SQL-HOSTNAME
              port: 5432
              user: PG-SQL-USERNAME
              password: PG-SQL-PASSWORD
              ssl: {rejectUnauthorized: false} # Set to true if using SSL
    ```

    Where:

    - `PG-SQL-HOSTNAME` is the host name of your PostgreSQL database.
    - `PG-SQL-USERNAME` is the user name of your PostgreSQL database.
    - `PG-SQL-PASSWORD` is the password of your PostgreSQL database.

2. Update the package profile by running:

    ```console
    tanzu package installed update  tap --package-name tap.tanzu.vmware.com --version VERSION-NUMBER --values-file tap-values.yaml -n tap-install
    ```

    Where `VERSION-NUMBER` is your Tanzu Application Platform version. For example, `{{ vars.tap_version }}`.

    For example:

    ```console
    $ tanzu package installed update  tap --package-name tap.tanzu.vmware.com --version {{ vars.tap_version }} --values-file tap-values.yaml -n tap-install
    | Updating package 'tap'
    | Getting package install for 'tap'
    | Getting package metadata for 'tap.tanzu.vmware.com'
    | Updating secret 'tap-tap-install-values'
    | Updating package install for 'tap'
    / Waiting for 'PackageInstall' reconciliation for 'tap'


    Updated package install 'tap' in namespace 'tap-install'
    ```

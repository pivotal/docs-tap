# Configure the Tanzu Developer Portal database

The Tanzu Developer Portal (formerly called Tanzu Application Platform GUI) catalog gives you two
approaches for storing catalog information:

- **In-memory database:**

  The default option uses an in-memory database and is suitable for test and development scenarios only.
  The in-memory database reads the catalog data from Git URLs that you write in `tap-values.yaml`.

  This data is temporary. Any operations that cause the `server` pod in the `tap-gui` namespace
  to be re-created also cause this data to be rebuilt from the Git location.

  This can cause issues when you manually register entities by using the UI because they only exist
  in the database and are lost when that in-memory database is rebuilt.
  If you choose this method, you lose all user preferences and any manually registered entities when
  the Tanzu Developer Portal server pod is re-created.

- **PostgreSQL database:**

  For production use-cases, use a PostgreSQL database that exists outside the
  Tanzu Application Platform packaging.
  The PostgreSQL database stores all the catalog data persistently both from the Git locations and
  the UI manual entity registrations.

For production or general-purpose use-cases, a PostgreSQL database is recommended.

## <a id="config-postgresql"></a> Configure a PostgreSQL database

See the following sections for configuring Tanzu Developer Portal to use a PostgreSQL database.

### <a id="postgresql-edit-values"></a> Edit `tap-values.yaml`

Apply the following values in `tap-values.yaml`:

```yaml
# ... existing tap-values.yaml above
tap_gui:
  # ... existing tap_gui values
  app_config:
    backend:
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

- `PG-SQL-HOSTNAME` is the host name of your PostgreSQL database
- `PG-SQL-USERNAME` is the user name of your PostgreSQL database
- `PG-SQL-PASSWORD` is the password of your PostgreSQL database

#### <a id="config-extras"></a> (Optional) Configure extra parameters

Beyond the minimum configuration options needed to make Tanzu Developer Portal work with the
`pg` driver, there are many more configuration options for other purposes.
For example, you can restrict Tanzu Developer Portal to a single database.
For more information about this restriction, see the
[Backstage documentation](https://backstage.io/docs/tutorials/switching-sqlite-postgres#using-a-single-database).

By default, Tanzu Developer Portal creates a database for each plug-in, but you can configure
it to divide plug-ins based on different PostgreSQL schemas and use a single specified database.

See the following example of extra configuration parameters:

```yaml
# ... existing tap-values.yaml above
tap_gui:
  # ... existing tap_gui values
  app_config:
    backend:
      # ... other backend details
      database:
        client: pg

        # This parameter tells Tanzu Developer Portal to put plug-ins in their own schema instead
        # of their own database.
        # default: database
        pluginDivisionMode: schema

        connection:
          # ... other connection details
          database: PG-SQL-DATABASE
```

Where `PG-SQL-DATABASE` is the database name for Tanzu Developer Portal to use

For the complete list of these configuration options, see the
[node-postgres documentation](https://node-postgres.com/apis/client).

### <a id="update-package-profile"></a> Update the package profile

You can apply your new configuration by updating Tanzu Application Platform with your modified values.
Doing so updates Tanzu Developer Portal because it belongs to Tanzu Application Platform.

To apply your new configuration, run:

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

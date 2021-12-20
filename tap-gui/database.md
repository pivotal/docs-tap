### Configuring the Tanzu Application Platform GUI Database

The default database mechanism for Tanzu Application Platform GUI is an in-memory
database that is recommended for testing and development only.
If you choose to use this method, when the Tanzu Application Platform GUI server pod gets re-created, you'll lose all user preferences and any manually registered entities.
For production or general-purpose use-cases, VMware recommends using a PostgreSQL database.
To use a PostgreSQL database, use the following values in your `tap-values-file.yml`:

```
    backend:
        baseUrl: http://tap-gui.INGRESS-DOMAIN
        cors:
            origin: http://tap-gui.INGRESS-DOMAIN
    # Existing tap-values.yml above
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
- `PG-SQL-HOSTNAME` is the hostname of your PostgreSQL database.    
- `PG-SQL-USERNAME` is the username of your PostgreSQL database.
- `PG-SQL-PASSWORD` is the password of your PostgreSQL database.

Now you can update the package profile by running:

```
tanzu package installed update  tap --package-name tap.tanzu.vmware.com --version 1.0.0 --values-file tap-values-file.yml -n tap-install
```

For example:

```
$ tanzu package installed update  tap --package-name tap.tanzu.vmware.com --version 1.0.0 --values-file tap-values-file.yml -n tap-install
| Updating package 'tap'
| Getting package install for 'tap'
| Getting package metadata for 'tap.tanzu.vmware.com'
| Updating secret 'tap-tap-install-values'
| Updating package install for 'tap'
/ Waiting for 'PackageInstall' reconciliation for 'tap'


Updated package install 'tap' in namespace 'tap-install'
```
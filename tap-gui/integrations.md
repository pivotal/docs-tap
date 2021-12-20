### Tanzu Application Platform GUI Integrations

Tanzu Application Platform GUI supports integrating with a number of Git providers. Inorder to leverage this integration, you'll need to enable it and provide the necessary token or credentials in your `tap-values-file.yml`. 

Below is an example of this integration using the GitHub provider integration:

```yaml
      app_config:
        app:
          baseUrl: http://EXTERNAL-IP:7000
        # Existing tap-values-file.yml above  
        integrations:
          github: # Other integrations available see NOTE below
            - host: github.com
              token: GITHUB-TOKEN
```

Where `GITHUB-TOKEN` is a valid token generated from your Git infrastructure of choice with the necessary read permissions for the catalog definition files you extracted from the Blank Software Catalog we covered in the prerequisites documentation.

>**Note:** The `integrations` section above uses Github. If you want additional integrations, see the
>format in the [Backstage integration documentation](https://backstage.io/docs/integrations/).

Once you've made the changes to the `tap-values-file.yml` you can update the package profile by running:

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
# Tanzu Application Platform GUI integrations

Tanzu Application Platform GUI supports integrating with several Git providers.
To leverage this integration, you must enable it and provide the necessary token or credentials in
your `tap-values-file.yml`.

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

Where `GITHUB-TOKEN` is a valid token generated from your Git infrastructure of choice with the
necessary read permissions for the catalog definition files you extracted from the Blank Software Catalog
introduced in the prerequisites documentation.

>**Note:** The `integrations` section earlier mentioned uses GitHub. For additional integrations,
see the format in the [Backstage integration documentation](https://backstage.io/docs/integrations/).

To allow Tanzu Application GUI to read non-GitHub repositories containing component information,
add the following to the `tap-values-file.yml` file:

```yaml
  app_config:
    # Existing tap-values-file.yml above
    backend:
      reading:
        allow:
          - host: "GIT-CATALOG-URL-1"
          - host: "GIT-CATALOG-URL-2" # Including more than one URL is optional
```

Where `GIT-CATALOG-URL-1` and `GIT-CATALOG-URL-2` are URLs in a list of URLs that
Tanzu Application Platform GUI can read when registering new components.
For example, `git.example.com.`
For more information about registering new components, see
[Adding catalog entities](catalog/catalog-operations.html#add-cat-entities).

Specifying this section of the `tap-values-file.yml` file currently causes the Accelerators page to
break and not show any accelerators. 
A temporary workaround is to provide a value for Application Accelerator:

```yaml
  app_config:
    # Existing tap-values-file.yml above
    backend:
      reading:
        allow:
          - host: acc-server.accelerator-system.svc.cluster.local
```

Specifying this section of the `tap-values-file.yml` file currently causes the Accelerators page to
break and not show any accelerators.
A temporary workaround is to provide a value for Application Accelerator:

```yaml
  app_config:
    # Existing tap-values-file.yml above
    backend:
      reading:
        allow:
          - host: acc-server.accelerator-system.svc.cluster.local
```

After making changes to the `tap-values-file.yml`, update the package profile by running:

```console
tanzu package installed update  tap --package-name tap.tanzu.vmware.com --version VERSION-NUMBER --values-file tap-values-file.yml -n tap-install
```

Where `VERSION-NUMBER` is the Tanzu Application Platform version. For example, `1.1.0`.

For example:

```console
$ tanzu package installed update  tap --package-name tap.tanzu.vmware.com --version 1.0.0 --values-file tap-values-file.yml -n tap-install
| Updating package 'tap'
| Getting package install for 'tap'
| Getting package metadata for 'tap.tanzu.vmware.com'
| Updating secret 'tap-tap-install-values'
| Updating package install for 'tap'
/ Waiting for 'PackageInstall' reconciliation for 'tap'


Updated package install 'tap' in namespace 'tap-install'
```

# Add Tanzu Developer Portal integrations

You can integrate Tanzu Developer Portal (formerly called Tanzu Application Platform GUI) with several
Git providers. To use an integration, you must enable it and provide the necessary token or credentials
in `tap-values.yaml`.

## <a id="add-github-integration"></a> Add a GitHub provider integration

To add a GitHub provider integration, edit `tap-values.yaml` as in this example:

```yaml
  app_config:
    app:
      baseUrl: http://EXTERNAL-IP:7000
    # Existing tap-values.yaml above
    integrations:
      github: # Other integrations available see NOTE below
        - host: github.com
          token: GITHUB-TOKEN
```

Where:

- `EXTERNAL-IP` is the external IP address.
- `GITHUB-TOKEN` is a valid token generated from your Git infrastructure of choice. Ensure that
  `GITHUB-TOKEN` has the necessary read permissions for the catalog definition files you extracted
  from the blank software catalog introduced in the
  [Tanzu Developer Portal prerequisites](../prerequisites.hbs.md#tap-gui).

## <a id="add-non-gh-integration"></a> Add a Git-based provider integration that isn't GitHub

To enable Tanzu Developer Portal to read Git-based non-GitHub repositories containing component
information:

1. Add the following YAML to `tap-values.yaml`:

    ```yaml
    app_config:
      # Existing tap-values.yaml above
      backend:
        reading:
          allow:
            - host: "GIT-CATALOG-URL-1"
            - host: "GIT-CATALOG-URL-2" # Including more than one URL is optional
    ```

   Where `GIT-CATALOG-URL-1` and `GIT-CATALOG-URL-2` are URLs in a list of URLs that
   Tanzu Developer Portal can read when registering new components.
   For example, `git.example.com.`
   For more information about registering new components, see
   [Adding catalog entities](catalog/catalog-operations.hbs.md#add-cat-entities).

2. Adding the YAML from the previous step currently causes the **Accelerators** page to break and not
   show any accelerators. Provide a value for Application Accelerator as a workaround, as in this
   example:

    ```yaml
    app_config:
      # Existing tap-values.yaml above
      backend:
        reading:
          allow:
            - host: acc-server.accelerator-system.svc.cluster.local
    ```

## <a id="add-non-git-integration"></a> Add a non-Git provider integration

To add an integration for a provider that isn't associated with GitHub, see the
[Backstage documentation](https://backstage.io/docs/integrations/).

## <a id="update-package-profile"></a> Update the package profile

After changing `tap-values.yaml`, update the package profile by running:

```console
tanzu package installed update  tap --package tap.tanzu.vmware.com --version VERSION-NUMBER \
--values-file tap-values.yaml -n tap-install
```

Where `VERSION-NUMBER` is the Tanzu Application Platform version. For example, `{{ vars.tap_version }}`.

For example:

```console
$ tanzu package installed update  tap --package tap.tanzu.vmware.com --version \
{{ vars.tap_version }} --values-file tap-values.yaml -n tap-install
| Updating package 'tap'
| Getting package install for 'tap'
| Getting package metadata for 'tap.tanzu.vmware.com'
| Updating secret 'tap-tap-install-values'
| Updating package install for 'tap'
/ Waiting for 'PackageInstall' reconciliation for 'tap'


Updated package install 'tap' in namespace 'tap-install'
```

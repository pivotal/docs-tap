# Uninstalling AppSSO from TAP

Uninstall the AppSSO package and repository following resource naming introduced
in the [Installation](installation.md) section:

```shell
tanzu package installed delete appsso --namespace tap-install
```

To permanently delete and exclude AppSSO package from your TAP install, modify your TAP values file and include the
following configuration:

```yaml
excluded_packages:
  - sso.apps.tanzu.vmware.com
```

For more information, navigate
to [Excluding packages from a Tanzu Application Platform profile](../../install.md#exclude-packages).

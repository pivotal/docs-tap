# Uninstall Application Single Sign-On

Uninstall the AppSSO package and repository following resource naming introduced
in the [Installation](installation.md) section:

```shell
tanzu package installed delete appsso --namespace tap-install
```

To permanently delete and exclude AppSSO package from your Tanzu Application Platform install, edit your Tanzu Application Platform values file by including the
following configuration:

```yaml
excluded_packages:
  - sso.apps.tanzu.vmware.com
```

For more information, navigate
to [Exclude packages from a Tanzu Application Platform profile](../../install-online/profile.hbs.md#exclude-packages).

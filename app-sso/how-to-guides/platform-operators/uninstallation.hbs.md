# Uninstall Application Single Sign-On

This topic tells you how to uninstall Application Single Sign-On (commonly called AppSSO). 

Delete the AppSSO package by running:

```shell
tanzu package installed delete appsso --namespace tap-install
```

To permanently delete and exclude AppSSO package from your Tanzu Application Platform install, edit your Tanzu Application Platform values file by including the following configuration:

```yaml
excluded_packages:
  - sso.apps.tanzu.vmware.com
```

For more information, navigate
to [Exclude packages from a Tanzu Application Platform profile](../../../install-online/profile.hbs.md#exclude-packages).

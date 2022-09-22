# Upgrades

The AppSSO package is upgraded as part of your TAP package installation. For specific help on migrating your resources
in between versions refer to the [release notes](../../release-notes.md#app-sso-features).

To upgrade `AppSSO` specifically, run:

```
tanzu package installed update APP_NAME -p sso.apps.tanzu.vmware.com -v 2.0.0 --values-file PATH_TO_YOUR_VALUES_YAML -n YOUR_INSTALL_NAMESPACE
```
    
If you use `Carvel`, you can also run:

```bash
ytt \
  --file PATH_TO_YOUR_VALUES_YAML \
  --data-value selected_version=YOUR_VERSION |
kapp deploy \
  --app APP_NAME \
  --namespace YOUR_INSTALL_NAMESPACE \
  --file - \
  --diff-changes \
  --yes
```

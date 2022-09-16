# Uninstalling AppSSO from TAP

Uninstall the AppSSO package and repository following resource naming introduced
in the [Installation](installation.md) section:

```shell
# Delete the Package
tanzu package installed delete appsso \
  --yes --namespace tap-install

# Delete the PackageRepository (if installed separately from TAP)
tanzu package repository delete appsso-package-repository \
  --yes --namespace tap-install

# Delete the TanzuNet credentials secret
tanzu secret registry delete appsso-registry --yes
```

# Install with the 'authoring' profile (Recommended)

{{> 'partials/supply-chain/beta-banner' }} 

The recommended way to install Tanzu Supply Chain is to use the `authoring` beta profile. This installs all the
required packages. The `authoring` profile has the following additional packages that the `iterate` profile does not have:

* Tanzu Supply Chain Packages
  * supply-chain.apps.tanzu.vmware.com
  * supply-chain-catalog.apps.tanzu.vmware.com
  * managed-resource-controller.apps.tanzu.vmware.com

* Catalog Component Packages
  * alm-catalog.component.apps.tanzu.vmware.com
  * buildpack-build.component.apps.tanzu.vmware.com
  * conventions.component.apps.tanzu.vmware.com
  * git-writer.component.apps.tanzu.vmware.com
  * source.component.apps.tanzu.vmware.com
  * trivy.app-scanning.component.apps.tanzu.vmware.com

* App Scanning
  * app-scanning.apps.tanzu.vmware.com


## Install Tanzu Supply Chain

Update your `tap-values.yaml` file to contain:

```yaml
profile: authoring
```

>**Note** As the `authoring` profile adds the above mentioned packages to what gets installed in the `iterate` profile, the `tap-values.yaml` file for both profiles can look the same except for the `profile` value.

After the installation of the `authoring` profile is complete and all packages are successfully reconciled, follow the [Post Installation Configuration](./post-install-configuration.hbs.md) documentation to configure Tanzu Supply Chain.

# Install with the 'authoring' profile (Recommended)

{{> 'partials/supply-chain/beta-banner' }} 

The recommended way to install Tanzu Supply Chain is to use the `authoring` beta profile. This installs all the
required packages. The `authoring` profile has the following additional packages that the `iterate` profile does not have:

- Tanzu Supply Chain Packages
  - supply-chain.apps.tanzu.vmware.com
  - supply-chain-catalog.apps.tanzu.vmware.com
  - managed-resource-controller.apps.tanzu.vmware.com

- Catalog Component Packages
  - alm-catalog.component.apps.tanzu.vmware.com
  - buildpack-build.component.apps.tanzu.vmware.com
  - conventions.component.apps.tanzu.vmware.com
  - git-writer.component.apps.tanzu.vmware.com
  - source.component.apps.tanzu.vmware.com
  - trivy.app-scanning.component.apps.tanzu.vmware.com

- App Scanning
  - app-scanning.apps.tanzu.vmware.com

## Install Tanzu Supply Chain

1. Update your `tap-values.yaml` file to contain:

  ```yaml
  profile: authoring
  ```

1. Confirm if the required packages are installed and reconciled successfully. Run:

  ```console
  kubectl get pkgi -A
  ```

  Example output

  ```console
  NAMESPACE     NAME                               PACKAGE NAME                                          PACKAGE VERSION                       DESCRIPTION           AGE
  tap-install   alm-catalog-component              alm-catalog.component.apps.tanzu.vmware.com           0.1.4                                 Reconcile succeeded   15d
  ...
  tap-install   buildpack-build-component          buildpack-build.component.apps.tanzu.vmware.com       0.0.2                                 Reconcile succeeded   15d
  ...
  tap-install   conventions-component              conventions.component.apps.tanzu.vmware.com           0.0.3                                 Reconcile succeeded   15d
  ...
  tap-install   git-writer-component               git-writer.component.apps.tanzu.vmware.com            0.1.3                                 Reconcile succeeded   15d
  ...
  tap-install   managed-resource-controller        managed-resource-controller.apps.tanzu.vmware.com     0.1.2                                 Reconcile succeeded   15d
  ...
  tap-install   namespace-provisioner              namespace-provisioner.apps.tanzu.vmware.com           0.6.2                                 Reconcile succeeded   15d
  ...
  tap-install   source-component                   source.component.apps.tanzu.vmware.com                0.0.1                                 Reconcile succeeded   15d
  ...
  tap-install   supply-chain                       supply-chain.apps.tanzu.vmware.com                    0.1.16                                Reconcile succeeded   15d
  tap-install   supply-chain-catalog               supply-chain-catalog.apps.tanzu.vmware.com            0.1.1                                 Reconcile succeeded   15d
  ...
  tap-install   trivy-app-scanning-component       trivy.app-scanning.component.apps.tanzu.vmware.com    0.0.1-alpha.build.40376886+b5f4e614   Reconcile succeeded   15d
  ...
  ```

  >**Note** As the `authoring` profile adds the above mentioned packages to what is installed with the `iterate` profile, the `tap-values.yaml` file for both profiles can look the same except for the `profile` value.

1. After the installation of the `authoring` profile is complete and all packages are successfully reconciled, follow the [Post Installation Configuration](./post-install-configuration.hbs.md) documentation to configure Tanzu Supply Chain.

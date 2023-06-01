# Use a pre-existing or out-of-band installation of Crossplane with Tanzu Application Platform

This topic describes options for installing Tanzu Application Platform to a cluster which already has an installation of Crossplane, or for which you wish to install Crossplane using an out-of-band mechanism (e.g. through Helm install).

## About

The crossplane.tanzu.vmware.com Package is included in Tanzu Application Platform's Full, Iterate and Run profiles. By default, any installation of Tanzu Appliation Platform using one of these profiles will result in the installation of Crossplane to the cluster via the Package. In most cases, this is desirable behaviour as Crossplane is required to support many of the services capabilities offered by Tanzu Application Platform.

However there are cases where this is not desirable, for example if you are planning to install Tanzu Application Platform to a cluster which already has an installation of Crossplane on it, or if you would like to install Crossplane via some other, out-of-band mechanism (e.g. through Helm install). This guide details how to exclude the crossplane.tanzu.vmware.com Package in tap-values.yaml.

## Exclude the crossplane.tanzu.vmware.com Package in tap-values.yaml file

Simply add the crossplane.tanzu.vmware.com Package to the `excluded_packages` array in tap-values.yaml.

```yaml
# tap-values.yaml

excluded_packages:
- crossplane.tanzu.vmware.com
```

This configuration has the effect of completely disabling the crossplane.tanzu.vmware.com Package from the Tanzu Application Platform install, which leaves you free to manage the Crossplane installation in whatever way you see fit.

It is important to note that other Tanzu Application Platform components may depend on the availability of the crossplane.tanzu.vmware.com Package. One such example is [Bitnami Services](../../bitnami-services/about.hbs.md). Therefore if you are planning to exclude the crossplane.tanzu.vmware.com Package, you will also need to exclude any other Tanzu Application Platform Package which depends on it.
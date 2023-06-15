# Use your existing Crossplane installation

This topic describes how to install Tanzu Application Platform (commonly known as TAP)
to a cluster that already has Crossplane installed.
This also applies if you want to install Crossplane without using the Tanzu application Platform
package, for example, through Helm install.

## <a id="about"></a>About installing the Crossplane package

The `crossplane.tanzu.vmware.com` package is included with the Full, Iterate and Run profiles.
By default, any installation of Tanzu Application Platform using one of these profiles installs
Crossplane to the cluster through the package.
In most cases, this is desirable because Crossplane is necessary to support many of the service related
capabilities that Tanzu Application Platform offers.

There are some cases where installing the Crossplane package by default is not desirable.
For example, if you plan to install Tanzu Application Platform to a cluster that already has Crossplane
installed on it, or if you want to install Crossplane by some other means.

## <a id="exclude"></a>Exclude the Crossplane package from the installation

If you want to install Crossplane by other means, exclude the Crossplane package from the
Tanzu Application Platform installation.

To do so, add the `crossplane.tanzu.vmware.com` package to  the `excluded_packages` array in the
`tap-values.yaml` file as follows:

```yaml
# tap-values.yaml

excluded_packages:
- crossplane.tanzu.vmware.com
```

> **Important** Other Tanzu Application Platform components might depend on the the Crossplane package,
> for example, [Bitnami Services](../../bitnami-services/about.hbs.md).
> If you exclude the Crossplane package, you must also exclude any other Tanzu Application Platform
> package that depends on it.

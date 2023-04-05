# Dependencies

Bitnami Services is an integration Package, meaning that it provides configuration for other Tanzu Application Platform components.
As such it has a number of dependencies that must be met before you can use it. These are:

- Crossplane and two Providers `provider-helm` and `provider-kubernetes`: See [Install Crossplane](../../crossplane/install-crossplane.hbs.md)
- Services Toolkit: see [Install Services Toolkit](../../services-toolkit/install-services-toolkit.hbs.md)

These dependencies are met if you install Tanzu Application Platform using the full, iterate, or run profiles.

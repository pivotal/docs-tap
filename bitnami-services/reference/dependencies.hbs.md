# Dependencies

Bitnami Services is an integration Package, meaning that it provides configuration for other Tanzu Application Platform components. As such it has a number of dependencies which must be met in order to be used successfully. These are:

* Crossplane and two Providers - `provider-helm` and `provider-kubernetes` - see [Install Crossplane](../../crossplane/install-crossplane.hbs.md)
* Services Toolkit - see [Install Services Toolkit](../../services-toolkit/install-services-toolkit.hbs.md)

All of these dependencies will have been met if Tanzu Application Platform has been installed using either the iterate, build or run profiles.

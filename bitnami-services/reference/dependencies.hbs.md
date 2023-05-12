# Dependencies for Bitnami Services

Bitnami Services is an integration package, which means that it provides configuration for other
Tanzu Application Platform components.
As such, it has a number of dependencies that must be met before you can use it. These are:

- **Crossplane and the two providers `provider-helm` and `provider-kubernetes`**: See [Install Crossplane](../../crossplane/install-crossplane.hbs.md)
- **Services Toolkit**: See [Install Services Toolkit](../../services-toolkit/install-services-toolkit.hbs.md)

These dependencies are met if you install Tanzu Application Platform using the full, iterate,
or run profiles.

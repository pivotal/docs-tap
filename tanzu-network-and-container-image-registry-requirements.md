# Tanzu Network and container image registry requirements

Installation requires:

* A [Tanzu Network](https://network.tanzu.vmware.com/) account to download
Tanzu Application Platform packages.

* A container image registry, such as [Harbor](https://goharbor.io/) or
[Docker Hub](https://hub.docker.com/) for application images, base images, and runtime dependencies.
When available, VMware recommends using a paid registry account to avoid potential rate-limiting
associated with some free registry offerings.
    * If installing using the `lite` descriptor for Tanzu Build Service, 1&nbsp;GB of available
    storage is recommended.
    * If installing using the `full` descriptor for Tanzu Build Service, which is intended for production use
    and offline environments, 10&nbsp;GB of available storage is recommended.

* Registry credentials with push and write access made available to Tanzu Application Platform to
store images.

* Network access to https://registry.tanzu.vmware.com

* Network access to your chosen container image registry.

* Latest version of Chrome, Firefox, or Edge.
Tanzu Application Platform GUI currently does not support Safari browser.

* After your installation is complete, you must identify at least one Developer Namespace. [Instructions for setting up a Developer Namespace](install-components.md#setup) are available at the end of installation.

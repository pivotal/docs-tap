# Supply Chain Security Tools for VMware Tanzu – Store

Supply Chain Security Tools - Store’s identifies vulnerable software packages by providing a CLI to query image, package, and vulnerability relationships after Supply Chain Security Tools - Scan runs source code and image vulnerability scans.
​
The Supply Chain Security Tools - Store component is designed to integrate seamlessly with the [Supply Chain Security Tools - Scan component](../scst-scan/overview.md). 
​
The Supply Chain Security Tools - Store has four components:

* Postgres database
* API
* client library
* CLI

Currently, there is support for the Cyclone DX XML SBoM formats.

See the following pages to begin:

* [TAP instructions for installing packages](../install.md#install-scst-store)
* [Using Supply Chain Security Tools - Store](using_metadata_store.md)

## Installed Resources

The installation will create the following in your Kubernetes cluster:

* 2 components — an API backend, and a database. Each component includes:
    * service
    * deployment
    * replicaset
    * pod
* Persistent volume, and persistent volume claim.
* External IP (if you've [customized the deployment configuration](../install.md#install-scst-store) to use `LoadBalancer`).
* A Kubernetes secret to allow pulling Supply Chain Security Tools - Store images from a registry.
* A namespace called `metadata-store`.

# CLI

See [CLI](cli.md).

# Known Issues

See [Troubleshooting and Known Issues](known_issues.md).

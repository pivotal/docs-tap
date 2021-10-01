# Supply Chain Tools for Tanzu – Store

SCST - Store’s enables faster identification of vulnerable software packages by providing a CLI to query image, package, and vulnerability relationships after the [SCST - Scan] has run source code and image vulnerability scans.
​
The SCST - Store component is designed to integrate seamlessly with the SCST - Scan component <add link>. 
​
The SCST - Store has four components:

* Postgres database
* API
* client library
* CLI
​
Currently, there is support for the Cyclone DX XML SBoM formats.
​
See the following pages to begin:
​
* [TAP instructions for installing packages](../install.md#install-scst-store)
* [Using the Metadata Store](using_metadata_store.md)

## Installed Resources

The installation will create the following in your k8s cluster:
* 2 components — an API backend, and a database. Each component includes:
    * service
    * deployment
    * replicaset
    * pod
* Persistent volume, and persistent volume claim
* External IP (if you've [customized the deployment configuration](../install.md#install-scst-store) to use `LoadBalancer`)
* A k8s secret to allow pulling metadata store images from a registry
* A namespace called `metadata-store`

# CLI

See [CLI](cli.md).

# Known Issues

See [Known Issues](known_issues.md).

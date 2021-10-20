# Supply Chain Security Tools for VMware Tanzu – Store

Supply Chain Security Tools - Store saves software bills of materials (SBoMs) to a database and allows you to query for image, source, package, and vulnerability relationships.  Supply Chain Security Tools - Store supports Cyclone DX XML SBoM formats.  It answers questions such as:

* What images contain a specific dependency?
* What dependencies are affected by a specific CVE?
* How many CVEs does a specific image or dependency contain?

Supply Chain Security Tools - Store integrates with [Supply Chain Security Tools - Scan](../scst-scan/overview.md) to automatically store the resulting source and image vulnerability reports.

Supply Chain Security Tools - Store has three components:

* Postgres database
* API
* CLI (`insight`)

# Installation

See [TAP instructions for installing the Supply Chain Security Tools - Store](../install.md#install-scst-store)

The installation creates the following in your Kubernetes cluster:

* 2 components — an API backend and a database. 
Each component includes:
    * service
    * deployment
    * replicaset
    * pod
* Persistent volume, and persistent volume claim.
* External IP (if you have [customized the deployment configuration](../install.md#install-scst-store) to use `LoadBalancer`).
* A Kubernetes secret to allow pulling Supply Chain Security Tools - Store images from a registry.
* A namespace called `metadata-store`.

# Usage

For information about using Supply Chain Security Tools - Store, see [Using Supply Chain Security Tools - Store](using_metadata_store.md). 

# Known Issues

See [Troubleshooting and Known Issues](known_issues.md).

# Supply Chain Tools for Tanzu – Store
SCST - Store’s goal is to make it faster to identify and remediate vulnerable software packages across an enterprise’s codebase.

We store image, package, and vulnerability metadata in a postgres database, which is queryable via our API, client lib, or
[CLI](cli.md). We currently support posting Cyclone DX-formatted reports.

The Metadata Store is part of the Scan/Store MVP, which enables teams to add source and image scanning to their pipeline, add an enforcement policy, save the output
in the Metadata Store, and query for the data.

# Installation
See [TAP instructions for installing packages](../install.md#install-scst-store) section.

## Installed Resources

The installation will create the following in your k8s cluster:
* 2 components — an API backend, and a database. Each component includes:
    * service
    * deployment
    * replicaset
    * pod
* Persistent volume, and persistent volume claim
* External IP (if you're [customized the deployment configuration](../install.md#install-scst-store) to use `LoadBalancer`)
* A k8s secret to allow pulling metadata store images from a registry
* A namespace called `metadata-store`

# Using the Metadata Store

See [Using the Metadata Store](using_metadata_store.md).

# Known Issues

See [Known Issues](known_issues.md).

# CLI

See [CLI](cli.md).
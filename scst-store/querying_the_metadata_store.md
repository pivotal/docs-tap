# Querying Supply Chain Security Tools - Store

You can query the Supply Chain Security Tools - Store to understand vulnerability, image, and dependency relationships. Before you query, you must add scan reports or SBoMs to the Supply Chain Security Tools - Store from the [Supply Chain Security Tools - Scan](../scst-scan/running-scans.md) or [manually](add_cyclonedx_to_store.md).
​
## Prerequisites

The following prerequisites are required to query Supply Chain Security Tools - Store:

- Prerequisites included in [Supply Chain Security Tools - Store](using_metadata_store.md).
- [Supply Chain Security Tools - Scan installed](../install.md#install-scst-scan).

## Querying Methods
There are two different ways of querying the database:

* CLI
* API
​
## Example Use Cases for Supply Chain Security Tools - Store Queries

The following example instructions use the CLI to query.

The following use cases apply to Supply Chain Security Tools - Store:

* What images contain a specific dependency?
* What dependencies are affected by a specific CVE?
* How many CVEs does a specific image or dependency contain?
​
## Querying the Supply Chain Security Tools - Store

Once the CVE report is created, you can query information about the image using `image get`. You need the image's component version from the earlier CycloneDX report. Pass the component version as a parameter to the `--digest` flag. Run:

```sh
insight image get --digest <digest>
```

Where:

- `digest` is the digest of the image you're interested in.

For example:

```sh
$ insight image get --digest sha256:407d7099d6ce7e3632b6d00682a43028d75d3b088600797a833607bd629d1ed5
Registry:	docker.io
Image Name:	checkr/flagr:1.1.12
Digest:    	sha256:407d7099d6ce7e3632b6d00682a43028d75d3b088600797a833607bd629d1ed5
Packages:
	1. alpine-baselayout@3.1.2-r0
	2. alpine-keys@2.1-r2
	3. apk-tools@2.10.4-r2
	CVEs:
		1. CVE-2021-30139 (High)
		2. CVE-2021-36159 (Critical)
	4. busybox@1.30.1-r3
	CVEs:
		1. CVE-2021-28831 (High)
...
```

It will return the found packages of the repo as well as any discovered CVEs for those images.

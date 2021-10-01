# Querying SCST - Store

After adding scan reports or SBoMs to the store from the [SCST - Scan](../scst-scan/running-scans.md) or [manually](add_cyclonedx_to_store.md), query the store to understand vulnerability, image, and dependency relationships.
​
## Prerequisites

Besides the prerequisites from the page [SCST - Store](using_metadata_store.md), make sure you've [installed SCST - Scan](../install.md#install-scst-scan).

## Different methods of querying
There are two different ways of querying the database

* CLI
* API

The following instructions follow the CLI, as it is the easiest way to query
​
## Example use cases supported by the Metadata Store queries

* What images contain a specific dependency?
* What dependencies are affected by a specific CVE?
* How many CVEs does a specific image or dependency contain?
​
## Query the Metadata Store

Once the CVE report has been created, you can query information about the image using `image get`. We'll need the image's component version from the earlier CycloneDX report. Pass that as a parameter to the `--digest` flag.

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

# Query Data

Query the database to understand vulnerability, image, and dependency relationships. 

## Prerequisites

See Prerequisites in [Using Supply Chain Security Tools - Store](using_metadata_store.md) 

## Add Data

Data must be added before querying; see [Add Data](../scst-store/add_cyclone_dx_to_store.md)

## Querying Methods

There are two different ways of querying the database:

* [Supply Chain Security Tools - Store API](../scst-store/getting_started_api.md)
* `insight` CLI - see below
​
## Supported Use Cases

The following examples are supported by the Supply Chain Security Tools - Store API and CLI:

1. What images contain a specific dependency?
1. What dependencies are affected by a specific CVE?
1. How many CVEs does a specific image or dependency contain?
​
## Querying with `insight` CLI

The following commands are designed for querying:

- `image get`
- `image package`
- `image vulnerabilities`
- `package get`
- `package image`
- `package source`
- `package vulnerabilities`
- `source get`
- `source package`
- `source vulnerabilities`
- `vulnerabilities get`
- `vulnerabilities image`
- `vulnerabilities package`
- `vulnerabilities source`

Use `insight -h` for the full list of commands and for additional examples.

### Example #1: What images contain a specific dependency?

Use the following command:

```sh
insight image get --digest DIGEST
```

Where:

- `DIGEST` is the component's version or image's digest

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
### Example #2: What dependencies are affected by a specific CVE?

Use the following command:

```sh
insight vulnerability get --cveid CVE-IDENTIFIER 
```

Where:

- `CVE-IDENTIFIER` is xxxxxxxxxxxx

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

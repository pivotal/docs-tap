# Querying Data

This topic describes how to query the database to understand vulnerability, image, and dependency relationships.

## Add Data

Data must be added before querying, see [Add Data](add_cyclonedx_to_store.md).

## Methods

There are two different ways of querying the database:

* [Supply Chain Security Tools - Store API](../scst-store/getting_started_api.md)
* [Query with insight CLI](#query-with-insight) below


## Supported Use Cases

The following are a few examples supported by the Supply Chain Security Tools - Store API and CLI:

+  What images contain a specific dependency?
+  What dependencies are affected by a specific CVE?
+  How many CVEs does a specific image or dependency contain?


## <a id='query-with-insight'></a> Query with insight CLI

Use the following commands for querying:

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

Use `insight -h` in the terminal or see the [full CLI documentation](cli_docs/insight.md) for more information.

## Example #1: What images contain a specific dependency?

Use the following command:

```sh
insight image get --digest DIGEST
```

Where `DIGEST` is the component version or image digest.

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
## Example #2: What dependencies are affected by a specific CVE?

Use the following command:

```sh
insight vulnerability get --cveid CVE-IDENTIFIER
```

Where `CVE-IDENTIFIER` is the CVE identifier, for example, CVE-2021-30139.

For example:

```sh
$ insight vulnerabilities get --cveid CVE-2010-4051
1. CVE-2010-4051 (Low)
Packages:
	1. libc-bin@2.28-10
	2. libc-l10n@2.28-10
	3. libc6@2.28-10
	4. locales@2.28-10
```

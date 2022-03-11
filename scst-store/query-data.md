# Query data

This topic describes how to query the database to understand vulnerability, image, and dependency relationships.

## <a id='sup-usecase'></a>Supported use cases

The following are a few use cases supported by the CLI:

+  What images contain a specific dependency?
+  What dependencies are affected by a specific CVE?
+  How many CVEs does a specific image or dependency contain?

## <a id='query-insight'></a> Query using the Tanzu Insight plug-in

See [CLI plug-in installation](cli-installation.md) if you have not previously installed the `insight` CLI plug-in.

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

Use `tanzu insight -h` in the terminal or see [tanzu insight details](cli_docs/insight.md) for more information.

## <a id='example1'></a>Example #1: What images contain a specific dependency?

Use the following command:

```
tanzu insight image get --digest DIGEST
```

Where `DIGEST` is the component version or image digest.

For example:

```
$ tanzu insight image get --digest sha256:407d7099d6ce7e3632b6d00682a43028d75d3b088600797a833607bd629d1ed5
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
## <a id='example2'></a>Example #2: What dependencies are affected by a specific CVE?

Use the following command:

```
tanzu insight vulnerabilities get --cveid CVE-IDENTIFIER
```

Where `CVE-IDENTIFIER` is the CVE identifier, for example, CVE-2021-30139.

For example:

```
$ tanzu insight vulnerabilities get --cveid CVE-2010-4051
1. CVE-2010-4051 (Low)
Packages:
	1. libc-bin@2.28-10
	2. libc-l10n@2.28-10
	3. libc6@2.28-10
	4. locales@2.28-10
```

## <a id='add-data'></a>Add data

See [Add Data](add-data.md) for more information about manually adding data.

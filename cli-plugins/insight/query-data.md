# Query data

This topic describes how to query the database to understand vulnerability, image, and dependency relationships. The Tanzu Insight CLI plug-in queries the database for vulnerability scan reports or Software Bill of Materials (SBoM) files.

## <a id='sup-usecase'></a>Supported use cases

The following are a few use cases supported by the CLI:

+  What packages and CVEs exist in a particular image? (`image`)
+  What packages and CVEs exist in my source code? (`source`)
+  What dependencies are affected by a specific CVE? (`vulnerabilities`)

## <a id='query-insight'></a> Query using the Tanzu Insight CLI plug-in

[Install the Tanzu Insight CLI plug-in](cli-installation.md) if you have not already done so.

There are four commands for querying and adding data.

+ `image` - [Post an image SBOM](add-data.md) or query images for packages and vulnerabilities.
+ `package` - Query packages for vulnerabilities or by image or source code.
+ `source` - [Post a source code SBOM](add-data.md) or query source code for packages and vulnerabilties.
+ `vulnerabilities` - Query vulnerabilities by image, package, or source code.

Use `tanzu insight -h` or see [Tanzu Insight Details](cli-docs/insight.md) for more information.

## <a id='example1'></a>Example #1: What packages & CVEs does a specific image contain?

Run:

```console
tanzu insight image get --digest DIGEST
```

Where:

- `DIGEST` is the component version or image digest.

For example:

```console
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

## <a id='example2'></a>Example #2: What packages & CVEs does my source code contain?

Run:

```console
tanzu insight source get --repo REPO --org ORG
```

Where:

- `REPO` specifies XML or JSON, the two supported file types
- `ORG` is the source code's organization


> You may also use `tanzu insight source get --commit COMMIT` where `COMMIT` is the commit sha.  `--repo` and `--org` must be used together.

For example, to get a recent scan for https://github.com/pivotal/kpack.git:

```console
$ tanzu insight source get --repo kpack --org pivotal
ID:       	2
Repository:  kpack
Commit:  b66668e
Organization:	pivotal
Packages:
		1. cloud.google.com/go/kms@v1.0.0
		2. github.com/BurntSushi/toml@v3.1.1
		CVEs:
			1. CVE-2021-30999 (Low)
		3. github.com/Microsoft/go-winio@v0.5.2
```

## <a id='example3'></a>Example #3: What dependencies are affected by a specific CVE?

Run:

```console
tanzu insight vulnerabilities get --cveid CVE-IDENTIFIER
```

Where:

- `CVE-IDENTIFIER` is the CVE identifier, for example, CVE-2021-30139.

For example:

```console
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

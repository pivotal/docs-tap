# Query vulnerabilities, images, and packages

This topic describes how to query the database to understand vulnerability, image, and dependency relationships. The Tanzu Insight CLI plug-in queries the database for vulnerability scan reports or Software Bill of Materials (SBoM) files.

## <a id='sup-usecase'></a>Supported use cases

The following are a few use cases supported by the CLI:

-  What packages and CVEs exist in a particular image? (`image`)
-  What packages and CVEs exist in my source code? (`source`)
-  What dependencies are affected by a specific CVE? (`vulnerabilities`)

## <a id='query-insight'></a> Query using the Tanzu Insight CLI plug-in

[Install the Tanzu Insight CLI plug-in](cli-installation.md) if you have not already done so.

There are four commands for querying and adding data.

- `image` - [Post an image SBOM](add-data.md) or query images for packages and vulnerabilities.
- `package` - Query packages for vulnerabilities or by image or source code.
- `source` - [Post a source code SBOM](add-data.md) or query source code for packages and vulnerabilities.
- `vulnerabilities` - Query vulnerabilities by image, package, or source code.

<!--Use `tanzu insight -h` or for more information see [Tanzu Insight Details](cli-docs/insight.md).-->

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

### Determining source code org, repo, and commit SHA

In order to query a source scan for vulnerabilities, you need a Git org and Git repository, or the commit SHA.  Find these by examining the source scan resource.

Run:

```console
kubectl describe sourcescan <workload name> -n <workload namespace>
```

For example:

```console
kubectl describe sourcescan tanzu-java-web-app -n my-apps
```

In the resource look for the `Spec.Blob` field. Within, there's `Revision` and `URL`.

For example:

```yaml
Spec:
  Blob:
    Revision:     master/c7e4c27ba43250a4b7c46f030355c108aa73cc39
    URL:          http://source-controller.flux-system.svc.cluster.local./gitrepository/my-apps/tanzu-java-web-app-gitops/c7e4c27ba43250a4b7c46f030355c108aa73cc39.tar.gz
```

In the earlier example, the URL is parsed and split into the org and repo. Revision is parsed as the commit SHA.

* Org is parsed as `gitrepository`
* Repo is parsed as `my-apps/tanzu-java-web-app-gitops/c7e4c27ba43250a4b7c46f030355c108aa73cc39.tar.gz`
* Commit SHA is parsed as `master/c7e4c27ba43250a4b7c46f030355c108aa73cc39`

Use this information to perform your search.

### Source code query with repo & org

Run:

```console
tanzu insight source get --repo REPO --org ORG
```

Where:

- `REPO` specifies the repository
	- E.g., java-web-app
	- E.g., my-apps/java-web-app/c7ls8bakd87sakjda8d7.tar.gz
- `ORG` is the source code's organization
	- E.g., gitrepository
	- E.g., gitrepositiory-kj32kal8

For example:

```console
$ tanzu insight source get --repo my-apps/java-web-app/c7ls8bakd87sakjda8d7.tar.gz --org gitrepository
ID:       	1
Repository:  my-apps/java-web-app/c7ls8bakd87sakjda8d7.tar.gz
Commit:  c7e4c27ba43250a4b7c46f030355c108aa73cc39
Organization:	gitrepository
Packages:
		1. go.uber.org/atomic@v1.7.0
		CVEs:
			1. CVE-2022-42322 (Low)
		2. golang.org/x/crypto@v0.0.0-20220518034528-6f7dac969898
		3. github.com/valyala/bytebufferpool@v1.0.0
```

### Source code query with commit SHA

Run:

```console
tanzu insight source get --commit COMMIT
```

Where:

- `COMMIT` specifies the commit
	- E.g., d7e4c27ba43250a4b7c46f030355c108aa73cc39
	- E.g., master/d7e4c27ba43250a4b7c46f030355c108aa73cc39

For example:

```console
$ tanzu insight source get --commit b66668e
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

For more information about manually adding data see [Add Data](add-data.md).

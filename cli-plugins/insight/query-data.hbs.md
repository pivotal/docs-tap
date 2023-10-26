# Query vulnerabilities, images, and packages

This topic tells you how to query the database to understand vulnerability, image,
and dependency relationships. The Tanzu Insight CLI plug-in queries the database
for vulnerability scan reports or Software Bill of Materials (commonly known as SBoM)
files.

## <a id='sup-usecase'></a>Supported use cases

The following are use cases supported by the CLI:

- What packages and CVEs exist in a particular image? (`image`)
- What dependencies are affected by a specific CVE? (`vulnerabilities`)

## <a id='query-insight'></a> Query using the Tanzu Insight CLI plug-in

Install the Tanzu Insight plug-in. The Tanzu Insight plug-in is in the Tanzu Application
Platform plug-ins group, see [Install Tanzu CLI plug-ins](../../install-tanzu-cli.hbs.md#install-plugins).

There are four commands for querying and adding data.

- `image` - [Post an image SBOM](add-data.md) or query images for packages and vulnerabilities.
- `package` - Query packages for vulnerabilities or by image or source code.
- `source` - [Post a source code SBOM](add-data.md) or query source code for packages and vulnerabilities.
- `vulnerabilities` - Query vulnerabilities by image, package, or source code.

For more information about Tanzu Insight CLI plug-in commands, see the
[VMware Tanzu CLI](https://docs.vmware.com/en/VMware-Tanzu-CLI/1.0/tanzu-cli/index.html) documentation.

## <a id='example1'></a>Example 1: What packages and CVEs does a specific image contain?

To query an image scan for vulnerabilities, you need the image digest value, which you can get from the
image scan resource.

### Find an image digest value

Find an image digest value using Supply Chain Tools - Scan 2.0 or Supply Chain Tools - Scan Pre-2.0.

#### Find an image digest using Supply Chain Tools - Scan 2.0

When using Supply Chain Tools - Scan 2.0, find the image digest value by looking inside the corresponding
image vulnerability scan custom resource.

To get a list of image vulnerability scans, run:

```console
kubectl get imagevulnerabilityscan -n WORKLOAD-NAMESPACE
```

For example:

```console
$ kubectl get imagevulnerabilityscan -n my-apps
NAME                                  SUCCEEDED   REASON
tanzu-java-web-app-grype-scan-jb76m   True        Succeeded
```

The name of the image vulnerability scan starts with the name of the workload.

To describe the image vulnerability scan, run:

```console
kubectl describe imagevulnerabilityscan IMAGE-VULNERABILITY-SCAN-NAME -n WORKLOAD-NAMESPACE
```

For example:

```console
kubectl describe imagevulnerabilityscan tanzu-java-web-app-grype-scan-jb76m -n my-apps
```

In the resource, look for the `Spec.Image` field. The value points to the image that was scanned,
including its digest.

For example:

```yaml
Spec:
  Image: fake.oci-registry.io/dev-cluster/supply-chain-apps/tanzu-java-web-app-my-apps@sha256:a24a8d8eb724b6816f244925cc6625a84c15f6ced6a19335121343424be693cd
```

In this example, the image digest value is: `sha256:a24a8d8eb724b6816f244925cc6625a84c15f6ced6a19335121343424be693cd`

#### Find an image digest value using Supply Chain Tools - Scan Pre-2.0

When using Supply Chain Tools - Scan Pre-2.0, find the image digest value by looking inside the
corresponding image scan custom resource.

Run:

```console
kubectl get imagescan WORKLOAD-NAME -n WORKLOAD-NAMESPACE
```

For example:

```console
kubectl get imagescan tanzu-java-web-app -n my-apps
```

In the resource, look for the `Spec.Registry.Image` field. The value points to the image that was
scanned, including its digest.

For example:

```yaml
Spec:
  Registry:
    Image: fake.oci-registry.io/dev-cluster/supply-chain-apps/tanzu-java-web-app-my-apps@sha256:e8c648533c4c7440ee9a93142ac7480205e0f7669e4f86771cede8bfaacdc2cf
```

In this example, the image digest is: `sha256:e8c648533c4c7440ee9a93142ac7480205e0f7669e4f86771cede8bfaacdc2cf`

### Query an image with the image digest value

Run:

```console
tanzu insight image get --digest DIGEST
```

Where:

- `DIGEST` is the component version or image digest.

For example:

```console
$ tanzu insight image get --digest sha256:sha256:e8c648533c4c7440ee9a93142ac7480205e0f7669e4f86771cede8bfaacdc2cf
Registry:	fake.oci-registry.com
Image Name:	dev-cluster/supply-chain-apps/tanzu-java-web-app-my-apps
Digest:    	sha256:sha256:e8c648533c4c7440ee9a93142ac7480205e0f7669e4f86771cede8bfaacdc2cf
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

## <a id='example2'></a>Example #: What dependencies are affected by a specific CVE?

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

For more information about manually adding data, see [Add Data](Add data to your Supply Chain
Security Tools - Store.hbs.md).

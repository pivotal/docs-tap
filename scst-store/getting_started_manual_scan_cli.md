# Getting Start with Create Manual Scans and using the CLI

This examples shows how to use the CLI to import a CVE scan into the metadata store.

# Prerequisites

Besides the prerequisites from the page [Supply Chain Security Tools - Store](using_metadata_store.md), you need to [install *grype*](https://github.com/anchore/grype), which is used for generating a CVE report

## Generate a CVE Report

Use grype to scan an image and generate an CVE report in CycloneDX format. In this example we're scanning `docker.io/checkr/flagr` with tag `1.1.12` and outputting the resulting CVE report into `cve-report`.

```sh
$ grype docker.io/checkr/flagr:1.1.12 -o cyclonedx > cve-report
 ✔ Vulnerability DB        [updated]
 ✔ Parsed image
 ✔ Cataloged packages      [21 packages]
 ✔ Scanned image           [8 vulnerabilities]
```

If you examine `cve-report` you'll see the image's *component version* is reported as `sha256:407d7099d6ce7e3632b6d00682a43028d75d3b088600797a833607bd629d1ed5`.

## Import the CVE report

To import the CVE report we created into the metadata store, use the `image create` command.

```sh
$ insight image create --cyclonedx cve-report
Image report created.
```

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

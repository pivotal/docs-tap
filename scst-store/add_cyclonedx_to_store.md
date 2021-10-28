# Add Data

Add Software Bill of Materials (SBoM) files to the database to understand your dependencies via [querying](../scst-store/querying_the_metadata_store.md)

## Prerequisites

See Prerequisites in [Using Supply Chain Security Tools - Store](using_metadata_store.md) 

## Methods

Data may be added by posting CycloneDX files through the following methods:

- [Supply Chain Security Tools - Scan](../scst-scan/overview.md)
- [Supply Chain Security Tools - Store API](../scst-store/getting_started_api.md)
- `insight` CLI - see below

## Supported Formats

Currently, CycloneDX XML and CycloneDX JSON files are accepted.

> Additional format support (e.g., SPDX) is planned for future releases

## Generate a CycloneDX File

A CycloneDX file is needed to post data.  CycloneDX files can be generated using many tools. This topic uses [Grype](https://github.com/anchore/grype).  Additional tools can be found on the [CycloneDX Tool Center](https://cyclonedx.org/tool-center/).

Use Grype to scan an image and generate an image report in CycloneDX format by running:

```sh
grype REPO:TAG -o cyclonedx > IMAGE-CVE-REPORT
```
Where:

- `REPO` is the name of your repository.
- `TAG` is the name of a tag.
- `IMAGE-CVE-REPORT` is the resulting file name of the Grype image scan report

For example:

```sh
$ grype docker.io/checkr/flagr:1.1.12 -o cyclonedx > image-cve-report
 ✔ Vulnerability DB        [updated]
 ✔ Parsed image
 ✔ Cataloged packages      [21 packages]
 ✔ Scanned image           [8 vulnerabilities]
```

In the example above, image's *component version* is reported as `sha256:407d7099d6ce7e3632b6d00682a43028d75d3b088600797a833607bd629d1ed5` in the `cve-report`.

## Adding Data with `insight` CLI

The following commands are designed for adding data

- `image create`
- `source create`

## Example #1: Create an Image Report

Using an CycloneDX-formatted image report, run:

```sh
insight image create --cyclonedx IMAGE-CVE-REPORT
```

Where:

- `IMAGE-CVE-REPORT` is the name of a Cyclone DX formatted file

For example:

```sh
$ insight image create --cyclonedx cve-report
Image report created.
```
> **Note:** The Metadata Store only stores a subset of a CycloneDX file’s data.  Support for more data may be added in the future.

## Example #2: Create a Source Report

Using an CycloneDX-formatted source report, run:

```sh
insight source create --cyclonedx SOURCE-CVE-REPORT
```

Where:

- `SOURCE-CVE-REPORT` is the name of a Cyclone DX formatted file

For example:

```sh
$ insight source create --cyclonedx cve-report
Source report created.
```
> **Note:** The Metadata Store only stores a subset of a CycloneDX file’s data.  Support for more data may be added in the future.

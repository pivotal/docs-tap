# Manually Adding CycloneDx-formatted Files to the Metadata Store

Manually adding CycloneDx-formatted files to the Metadata Store is helpful for quickly adding data to the store, in order to better understand the available queries.
​
A CycloneDX file is a widely supported SBoM format. The Metadata Store supports CycloneDX XML and JSON files.

> **Note:** The Metadata Store only stores a subset of a CycloneDX file’s data.  Support for more data may be added in the future.
​​
## Generate CycloneDx Files

You can use many tools to generate CycloneDX files. This topic uses [Grype](https://github.com/anchore/grype) to generate CycloneDX files.
​
### Generate an Image Report with Grype

Use Grype to scan an image and generate an image report in CycloneDX format by running:

```sh
grype REPO:TAG -o cyclonedx > CVE-REPORT
```
Where:

- `REPO` is the name of your repository.
- `TAG` is the name of a tag.
- `CVE-REPORT` is the resulting CVE report. 

For example:

```sh
$ grype docker.io/checkr/flagr:1.1.12 -o cyclonedx > cve-report
 ✔ Vulnerability DB        [updated]
 ✔ Parsed image
 ✔ Cataloged packages      [21 packages]
 ✔ Scanned image           [8 vulnerabilities]
```

The image's *component version* is reported as `sha256:407d7099d6ce7e3632b6d00682a43028d75d3b088600797a833607bd629d1ed5` in the `cve-report`.

## Add CycloneDx Files to the Metadata Store

Import the CVE report you created into the metadata store by running:

```sh
insight image create --cyclonedx cve-report
```

For example:

```sh
$ insight image create --cyclonedx cve-report
Image report created.
```

## View Data
For information about viewing data, see [Querying the Store](querying_the_metadata_store.md).
​

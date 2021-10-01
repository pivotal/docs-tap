# Manually add CycloneDx-formatted files to the Metadata Store

This is helpful for quickly adding data to the store, in order to better understand the available queries.
​
A CycloneDX file is a widely supported SBoM format (SPDX and SWID being the two other major SBoM formats).  The Metadata Store currently supports CycloneDX xml files (json files should also work).
​​
## Generating CycloneDx files

There are numerous tools to generate CycloneDX files. One tool our team has successfully used is [Grype](https://github.com/anchore/grype).
​
Note - the Metadata Store only stores a subset of a CycloneDX file’s data.  More data will be stored and made queryable in a future release.
​
## Adding CycloneDx files to the Metadata Store

After generating CycloneDX files, the files must be added to the Metadata Store
​
### Generate an Image Report

Use grype to scan an image and generate an image report in CycloneDX format. In this example we're scanning `docker.io/checkr/flagr` with tag `1.1.12` and outputting the resulting CVE report into `cve-report`.

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

### Viewing data
See [Querying the Store](querying_the_metadata_store.md).
​

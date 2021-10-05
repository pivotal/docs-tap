# Manually Adding CycloneDx-formatted Files to the Metadata Store

Manually adding CycloneDx-formatted files to the Metadata Store is helpful for quickly adding data to the store, in order to better understand the available queries.
​
A CycloneDX file is a widely supported SBoM format. The Metadata Store supports CycloneDX XML and JSON files.
​​
## Generating CycloneDx Files

You can use many tools to generate CycloneDX files. For example, [Grype](https://github.com/anchore/grype).
​
> **Note:** The Metadata Store stores a subset of a CycloneDX file’s data.
​
## Adding CycloneDx Files to the Metadata Store

After generating CycloneDX files, you must add the files to the Metadata Store.
​
### Generating an Image Report

Use Grype to scan an image and generate an image report in CycloneDX format. The following example sans `docker.io/checkr/flagr` with tag `1.1.12` and outputs the resulting CVE report into `cve-report`.

```sh
$ grype docker.io/checkr/flagr:1.1.12 -o cyclonedx > cve-report
 ✔ Vulnerability DB        [updated]
 ✔ Parsed image
 ✔ Cataloged packages      [21 packages]
 ✔ Scanned image           [8 vulnerabilities]
```

The image's *component version* is reported as `sha256:407d7099d6ce7e3632b6d00682a43028d75d3b088600797a833607bd629d1ed5` in the `cve-report`.

## Importing the CVE Report

Import the CVE report you created into the metadata store. Run the `image create` command:

```sh
$ insight image create --cyclonedx cve-report
Image report created.
```

### Viewing data
For information about viewing data, see [Querying the Store](querying_the_metadata_store.md).
​

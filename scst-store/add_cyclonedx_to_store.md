# Adding Data

This topic describes how add Software Bill of Materials (SBoM) files to the database to understand your dependencies by querying.
For instructions on querying, see [Querying Data](../scst-store/querying_the_metadata_store.md).


## Methods

Add data by posting CycloneDX files using the following methods:

- [Supply Chain Security Tools - Scan](../scst-scan/overview.md)
- [Supply Chain Security Tools - Store API](../scst-store/getting_started_api.md)
- [Add Data with the `insight` CLI](#insight-cli) below


## Supported Formats

Currently, only CycloneDX XML files are accepted.

Additional format support, for example, SPDX and CycloneDX JSON, is planned for future releases

## Generate a CycloneDX File

A CycloneDX file is needed to post data.  CycloneDX files can be generated using many tools. This topic uses [Grype](https://github.com/anchore/grype).  Additional tools can be found on the [CycloneDX Tool Center](https://cyclonedx.org/tool-center/).

To use Grype to scan an image and generate an image report in CycloneDX format:

1. Run:

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


## <a id='insight-cli'></a>Add Data with the insight CLI

Use the following commands to add data:

- `image create`
- `source create`

## Example #1: Create an Image Report

To use an CycloneDX-formatted image report:

1. Run:

    ```sh
    insight image create --cyclonedx IMAGE-CVE-REPORT
    ```

    Where `IMAGE-CVE-REPORT` is the name of a Cyclone DX formatted file.

    For example:

    ```sh
    $ insight image create --cyclonedx image-cve-report
    Image report created.
    ```

> **Note:** The Metadata Store only stores a subset of a CycloneDX file data.
  Support for more data might be added in the future.


## Example #2: Create a Source Report

To use an CycloneDX-formatted source report:

1. Run:

    ```sh
    insight source create --cyclonedx SOURCE-CVE-REPORT
    ```

    Where `SOURCE-CVE-REPORT` is the name of a Cyclone DX formatted file.

    For example:

    ```sh
    $ insight source create --cyclonedx source-cve-report
    Source report created.
    ```

> **Note:** The Metadata Store only stores a subset of a CycloneDX file’s data.
  Support for more data might be added in the future.

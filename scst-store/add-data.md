# Add data

This topic describes how to add Software Bill of Materials (SBoM) files to Supply Chain Security Tools - Store to understand your dependencies by querying. For instructions on querying, see [Query Data](../scst-store/query-data.md).


## <a id='methods'></a>Methods

Add data by posting CycloneDX files using the following methods:

- [Supply Chain Security Tools - Scan](../scst-scan/overview.md)
- [Supply Chain Security Tools - Store API](../scst-store/api-walkthrough.md)
- [Add Data with the Insight CLI](#insight-cli) below


## <a id='supported-formats'></a>Supported Formats and File Types

Currently, only CycloneDX XML and JSON files are accepted.

Source commits and image files are tested. Additional file types, for example, JAR, might work because they are not fully tested.

>**Note:** If using a non-source commit or image file type, you must ensure the `component.version` field in the CycloneDX file is non-null, because the database expects a unique identifier.

## <a id='gen-cyclone'></a>Generate a CycloneDX File

A CycloneDX file is needed to post data.  CycloneDX files can be generated using many tools. This topic uses [Grype](https://github.com/anchore/grype).  Additional tools can be found on the [CycloneDX Tool Center](https://cyclonedx.org/tool-center/).

To use Grype to scan an image and generate an image report in CycloneDX format:

1. Run:

    ```
    grype REPO:TAG -o cyclonedx > IMAGE-CVE-REPORT
    ```
    Where:

    - `REPO` is the name of your repository
    - `TAG` is the name of a tag
    - `IMAGE-CVE-REPORT` is the resulting file name of the Grype image scan report

    For example:

    ```
    $ grype docker.io/checkr/flagr:1.1.12 -o cyclonedx > image-cve-report
     ✔ Vulnerability DB        [updated]
     ✔ Parsed image
     ✔ Cataloged packages      [21 packages]
     ✔ Scanned image           [8 vulnerabilities]
    ```


## <a id='insight-cli'></a>Add Data with the Insight CLI

Use the following commands to add data:

- `image create`
- `source create`

>**Note:** If using a non-source commit or image file type, you can select either option.

Use `insight -h` in the terminal or see [CLI details](cli-docs/insight.md) for more information.

## <a id='example1'></a>Example #1: Create an Image Report

To use a CycloneDX-formatted image report:

1. Run:

    ```
    insight image create --cyclonedxtype TYPE --path IMAGE-CVE-REPORT
    ```

    Where:
    
    - `TYPE` specifies XML or JSON, the two supported file types
    - `IMAGE-CVE-REPORT` is the location of a Cyclone DX formatted file

    For example:

    ```
    $ insight image create --cyclonedxtype xml --path downloads/image-cve-report
    Image report created.
    ```

> **Note:** The Metadata Store only stores a subset of CycloneDX file data.
  Support for more data might be added in the future.


## <a id='example2'></a>Example #2: Create a Source Report

To use a CycloneDX-formatted source report:

1. Run:

    ```
    insight source create --cyclonedxtype TYPE --path SOURCE-CVE-REPORT
    ```

    Where:
    
    - `TYPE` specifies XML or JSON, the two supported file types
    - `SOURCE-CVE-REPORT` is the location of a Cyclone DX formatted file

    For example:

    ```
    $ insight source create --cyclonedxtype json --path source-cve-report
    Source report created.
    ```

> **Note:** The Metadata Store only stores a subset of a CycloneDX file’s data.
  Support for more data might be added in the future.

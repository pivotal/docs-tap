# Add data

This topic describes how to add Software Bill of Materials (SBoM) files to Supply Chain Security Tools - Store to understand your dependencies by querying.
For instructions on querying, see [Query Data](../scst-store/query_data.md).

## <a id='supported-formats'></a>Supported Formats

Currently, only CycloneDX XML files are accepted.

For example, additional format support is planned for future releases, for example, SPDX and CycloneDX JSON.

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


## <a id='insight-cli'></a>Add Data with the Tanzu Insight Plug-in

Use the following commands to add data:

- `image create`
- `source create`

Use `tanzu insight -h` in the terminal or see [Tanzu insight](cli_docs/insight.md) for more information.

## <a id='example1'></a>Example #1: Create an Image Report

To use a CycloneDX-formatted image report:

1. Run:

    ```
    tanzu insight image create --cyclonedxtype TYPE --path IMAGE-CVE-REPORT
    ```

    Where:
    
    - `TYPE` specifies XML or JSON, the two supported file types
    - `IMAGE-CVE-REPORT` is the location of a Cyclone DX formatted file

    For example:

    ```
    $ tanzu insight image create --cyclonedxtype xml --path downloads/image-cve-report
    Image report created.
    ```

> **Note:** The Metadata Store only stores a subset of CycloneDX file data.
  Support for more data might be added in the future.


## <a id='example2'></a>Example #2: Create a Source Report

To use a CycloneDX-formatted source report:

1. Run:

    ```
    tanzu insight source create --cyclonedxtype TYPE --path SOURCE-CVE-REPORT
    ```

    Where:
    
    - `TYPE` specifies XML or JSON, the two supported file types
    - `SOURCE-CVE-REPORT` is the location of a Cyclone DX formatted file

    For example:

    ```
    $ tanzu insight source create --cyclonedxtype json --path source-cve-report
    Source report created.
    ```

> **Note:** Supply Chain Security Tools - Store only stores a subset of a CycloneDX file’s data.
  Support for more data might be added in the future.

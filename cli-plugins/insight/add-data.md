# Add data

This topic describes how to add vulnerability scan reports or Software Bill of Materials (SBoM) files to the Supply Chain Security Tools - Store.

## <a id='supported-formats'></a>Supported Formats and File Types

Currently, only CycloneDX XML and JSON files are accepted.

Source commits and image files have been tested. Additional file types may work, but are not fully supported (e.g., JAR files).

>**Note:** If not using a source commit or image file, you must ensure the `component.version` field in the CycloneDX file is non-null.

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

- `image add`
- `source add`

>**Note:** If not using a source commit or image file, you can select either option.

## <a id='example1'></a>Example #1: Add an Image Report

To use a CycloneDX-formatted image report:

1. Run:

    ```
    tanzu insight image add --cyclonedxtype TYPE --path IMAGE-CVE-REPORT
    ```

    Where:
    
    - `TYPE` specifies XML or JSON, the two supported file types
    - `IMAGE-CVE-REPORT` is the location of a Cyclone DX formatted file

    For example:

    ```
    $ tanzu insight image add --cyclonedxtype xml --path downloads/image-cve-report
    Image report created.
    ```

> **Note:** The Metadata Store only stores a subset of CycloneDX file data.
  Support for more data might be added in the future.


## <a id='example2'></a>Example #2: Add a Source Report

To use a CycloneDX-formatted source report:

1. Run:

    ```
    tanzu insight source add --cyclonedxtype TYPE --path SOURCE-CVE-REPORT
    ```

    Where:
    
    - `TYPE` specifies XML or JSON, the two supported file types
    - `SOURCE-CVE-REPORT` is the location of a Cyclone DX formatted file

    For example:

    ```
    $ tanzu insight source add --cyclonedxtype json --path source-cve-report
    Source report created.
    ```

> **Note:** Supply Chain Security Tools - Store only stores a subset of a CycloneDX file’s data.
  Support for more data might be added in the future.

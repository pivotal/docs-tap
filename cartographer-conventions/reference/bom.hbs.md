# BOM for Cartographer Conventions

This reference topic describes the `BOM` structure you can use with Cartographer Conventions.

## Overview

The `BOM` is a type/structure wrapping a Software Bill of Materials (SBOM) describing the software components and their dependencies.

## Structure

The structure of the `BOM` is defined as follows:

```toml
{
  "name": "BOM-NAME",
  "raw": "BYTE-ARRAY"
}
```

Where:

- `BOM-NAME` is the prefix `cnb-sbom:`, followed by the location of the BOM definition in the layer
  for a cloud native buildpack (CNB) SBOM.
  For example: `cnb-sbom:/layers/sbom/launch/paketo-buildpacks_executable-jar/sbom.cdx.json`.
  For a non-CNB SBOM, the value of `name` might change.

- `BYTE-ARRAY`: The content of the BOM. The content may be in any format or encoding.
  Consult the name to infer how the content is structured.

The convention controller forwards BOMs to the convention servers that it can discover from
known sources, including:

- [CNB-SBOM](https://github.com/buildpacks/rfcs/blob/main/text/0095-sbom.md)

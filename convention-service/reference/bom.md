# BOM

The `BOM` is a type/structure wrapping a Software Bill of Materials (SBOM) describing the software components and their dependencies.

The structure of the `BOM` is defined as follows:

```toml
{
  "name": "bom-name",
  "raw": "`some byte array`"
}
```

Where:

  + `name`: For a cloud native buildpack SBOM, it starts with prefix `cnb-sbom:` and is followed by the location of the BOM definition in the *layer*. For example: `cnb-sbom:/layers/sbom/launch/paketo-buildpacks_executable-jar/sbom.cdx.json`. For any non CNB-SBOM, the `name` might change.

  + `raw`: The content of the BOM. The content may be in any format or encoding. Consult the name to infer how the content is structured.

The convention controller will forward BOMs to the convention servers that it can discover from known sources, including:

+ [*CNB-SBOM*](https://github.com/buildpacks/rfcs/blob/main/text/0095-sbom.md)

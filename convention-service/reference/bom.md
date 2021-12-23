# BOM

The `BOM` is an type/structure wrapping a Software Bill of Materials (SBOM) in which described the software components and their dependencies.

The structure of the `BOM` is defined as follows:

```json
{
  "name": "bom-name",
  "raw": "`some byte array`"
}
```
Where:

  + `name`: When it is a cloud native buildpack SBOM then it will start with prefix `cnb-sbom:` and followed by location of the bom definition inside the *layer*, for example `cnb-sbom:/layers/sbom/launch/paketo-buildpacks_executable-jar/sbom.cdx.json`, if not a *CNB-SBOM* then name may change.

  + `raw`: the content of the BOM. The content may be in any format or encoding. Consult the name to infer how the content is structured.

The convention controller will forward BOMs to convention servers that it is able to discover from known sources, including:

+ [*CNB-SBOM*](https://github.com/buildpacks/rfcs/blob/main/text/0095-sbom.md)
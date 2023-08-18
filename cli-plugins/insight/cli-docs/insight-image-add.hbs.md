# tanzu insight image add

This topic tells you how to use the Tanzu Insight CLI 
`tanzu insight image add` command to add an image report.

```console
tanzu insight image add [--cyclonedxtype <json|xml>] [--spdxtype json] --path <filepath>
```

If report  type is not specified, it will be defaulted to `--cyclonedxtype=xml`

## <a id='examples'></a>Examples

```console
tanzu insight image add --cyclonedxtype json --path /path/to/file.json
```

## <a id='options'></a>Options

```console
      --cyclonedxtype string   cyclonedx file type(xml/json, default: xml)
  -h, --help                   help for add
      --path string            path to file
      --spdxtype string        spdx file type(json)
```

## <a id='see-also'></a>See also

* [Tanzu insight image](insight-image.md) - Image commands

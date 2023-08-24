# tanzu insight source add

This topic tells you how to use the Tanzu Insight CLI
`tanzu insight source add` command to add a source report.

```console
tanzu insight source add [--cyclonedxtype <json|xml>] [--spdxtype json] --path <filepath>
```

If report type is not specified, it defaults to `--cyclonedxtype=xml`

## <a id='examples'></a>Examples

```console
tanzu insight source add --cyclonedxtype json --path  /path/to/file.json
```

## <a id='options'></a>Options

```console
      --cyclonedxtype string   cyclonedx file type (xml/json, default: xml)
  -h, --help                   help for add
      --path string            path to file
      --spdxtype string        spdx file type (json)
```

## <a id='see-also'></a>See also

* [Tanzu insight source](insight-source.md)	 - Source commands

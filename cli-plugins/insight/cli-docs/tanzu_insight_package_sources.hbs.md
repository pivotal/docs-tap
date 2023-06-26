## tanzu insight package sources

Get sources that contain the given package by name

## <a id='synopsis'></a>Synopsis

Get sources that contain the given package by name

```console
tanzu insight package sources --name <package name> [flags]
```

## <a id='examples'></a>Examples

```console
insight package sources --name client
  insight package sources --name client --output-format api-json
```

## <a id='options'></a>Options

```console
  -h, --help                   help for sources
  -n, --name string            name of the package
      --output-format string   specify the response's SBOM report format and file type format, options=[text, api-json] (default: text)
```

## <a id='see-also'></a>See also

* [tanzu insight package](tanzu_insight_package.hbs.md)	 - Package commands


# tanzu insight package vulnerabilities

Use this command to get package vulnerabilities.

## <a id='synopsis'></a>Synopsis

Get package vulnerabilities

```console
tanzu insight package vulnerabilities --name <package name> [flags]
```

## <a id='examples'></a>Examples

```console
insight package vulnerabilities --name client
  insight package vulnerabilities --name client --output-format api-json
```

## <a id='options'></a>Options

```console
  -h, --help                   help for vulnerabilities
  -n, --name string            name of the package
      --output-format string   specify the response's SBOM report format and file type format, options=[text, api-json] (default: text)
```

## <a id='see-also'></a>See also

* [tanzu insight package](tanzu_insight_package.hbs.md)	 - Package commands

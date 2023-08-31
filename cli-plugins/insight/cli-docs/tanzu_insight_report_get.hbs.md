# tanzu insight report get

This topic tells you how to use the Tanzu Insight CLI
`tanzu insight report get` command to get the package vulnerabilities.

## <a id='synopsis'></a>Synopsis

Get a report by its unique identifier

```console
tanzu insight report get --uid <report-unique-identifier> [flags]
```

## <a id='examples'></a>Examples

```console
insight report get --uid d38c3962-2351-44d5-8603-1d147f3d2367
  insight report get --uid d38c3962-2351-44d5-8603-1d147f3d2367 --format api-json
```

## <a id='options'></a>Options

```console
  -h, --help                   help for get
      --output-format string   specify the response's SBOM report format and file type format, options=[text, api-json, cyclonedx-xml, spdx-json] (default: text)
      --uid string             the unique identifier of the SBOM report
```

## <a id='see-also'></a>See also

* [tanzu insight report](tanzu_insight_report.hbs.md)	 - Report commands

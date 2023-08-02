# tanzu insight vulnerabilities get

This topic tells you how to use the Tanzu Insight CLI plug-in 
`tanzu insight vulnerabilities get` to get a vulnerability by CVE ID.

## <a id='synopsis'></a>Synopsis

Get vulnerability by CVE id.

```console
tanzu insight vulnerabilities get --cveid CVE-ID [flags]
```

## <a id='examples'></a>Examples

```console
insight vulnerabilities get --cveid CVE-123123-2021
  insight vulnerabilities get --cveid CVE-123123-2021 --output-format api-json
```

## <a id='options'></a>Options

```console
  -c, --cveid string           CVE id
  -h, --help                   help for get
      --output-format string   specify the response's SBOM report format and file type format, options=[text, api-json] (default: text)
```

## <a id='see-also'></a>See also

* [tanzu insight vulnerabilities](tanzu_insight_vulnerabilities.hbs.md)	 - Vulnerabilities commands

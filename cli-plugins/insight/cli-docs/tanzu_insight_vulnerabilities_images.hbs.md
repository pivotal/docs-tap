# tanzu insight vulnerabilities images

Use this command to get images with a given vulnerability.

## <a id='synopsis'></a>Synopsis

Get images with a given vulnerability.

```console
tanzu insight vulnerabilities images --cveid <cve-id> [flags]
```

## <a id='examples'></a>Examples

```console
insight vulnerabilities images --cveid CVE-123123-2021
  insight vulnerabilities images --cveid CVE-123123-2021 --output-format api-json
```

## <a id='options'></a>Options

```console
  -c, --cveid string           CVE id
  -h, --help                   help for images
      --output-format string   specify the response's SBOM report format and file type format, options=[text, api-json] (default: text)
```

## <a id='see-also'></a>See also

* [tanzu insight vulnerabilities](tanzu_insight_vulnerabilities.hbs.md)	 - Vulnerabilities commands

# tanzu insight image vulnerabilities

Use this command to get image vulnerabilities.

## <a id='synopsis'></a>Synopsis

Get image vulnerabilities

```console
tanzu insight image vulnerabilities --digest <image-digest> [flags]
```

## <a id='examples'></a>Examples

```console
insight image vulnerabilities --digest sha256:a86859ac1946065d93df9ecb5cb7060adeeb0288fad610b1b659907
insight image vulnerabilities --digest sha256:a86859ac1946065d93df9ecb5cb7060adeeb0288fad610b1b659907 --output-format api-json
```

## <a id='options'></a>Options

```console
  -d, --digest string          image digest
  -h, --help                   help for vulnerabilities
      --output-format string   specify the response's SBOM report format and file type format, options=[text, api-json] (default: text)
```

## <a id='see-also'></a>See also

* [tanzu insight image](tanzu_insight_image.hbs.md)	 - Image commands

## tanzu insight image get

Get image by digest

## <a id='synopsis'></a>Synopsis

Get image by digest

```console
tanzu insight image get --digest <image-digest> [flags]
```

## <a id='examples'></a>Examples

```console
insight image get --digest sha256:a86859ac1946065d93df9ecb5cb7060adeeb0288fad610b1b659907
  insight image get --digest sha256:a86859ac1946065d93df9ecb5cb7060adeeb0288fad610b1b659907 --output-format api-json
  insight image get --digest sha256:a86859ac1946065d93df9ecb5cb7060adeeb0288fad610b1b659907 --output-format cyclonedx-xml
```

## <a id='options'></a>Options

```console
  -d, --digest string          image digest
  -h, --help                   help for get
      --output-format string   specify the response's SBOM report format and file type format, options=[text, api-json, cyclonedx-xml, spdx-json] (default: text)
```

## <a id='see-also'></a>See also

* [tanzu insight image](tanzu_insight_image.hbs.md)	 - Image commands


## tanzu insight image packages

Get image packages

## <a id='synopsis'></a>Synopsis

Get image packages

```console
tanzu insight image packages [--digest <image-digest>] [--name <name>] [flags]
```

## <a id='examples'></a>Examples

```console
insight image packages --digest sha256:a86859ac1946065d93df9ecb5cb7060adeeb0288fad610b1b659907
  insight image packages --name ubuntu --output-format api-json
```

## <a id='options'></a>Options

```console
  -d, --digest string          image digest
  -h, --help                   help for packages
  -n, --name string            image name
      --output-format string   specify the response's SBOM report format and file type format, options=[text, api-json] (default: text)
```

## <a id='see-also'></a>See also

* [tanzu insight image](tanzu_insight_image.hbs.md)	 - Image commands


# Tanzu insight image get

Get image by digest.

## <a id='synopsis'></a>Synopsis

Get image by digest.

```
tanzu insight image get --digest <image-digest> [--format <image-format>] [flags]
```

## <a id='examples'></a>Examples

```
tanzu insight image get --digest sha256:a86859ac1946065d93df9ecb5cb7060adeeb0288fad610b1b659907 --format json
```

## <a id='options'></a>Options

```
  -d, --digest string   image digest
  -f, --format string   output format (default "text")
  -h, --help            help for get
```

## <a id='see-also'></a>See Also

* [Tanzu insight image](insight-image.md)	 - Image commands

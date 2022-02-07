# Insight image packages

Get image packages.

## <a id='synopsis'></a>Synopsis

Get image packages.

```
insight image packages --digest <image-digest> [--format <image-format>] [flags]
```

## <a id='examples'></a>Examples

```
insight image packages --digest sha256:a86859ac1946065d93df9ecb5cb7060adeeb0288fad610b1b659907 --format json
```

## <a id='options'></a>Options

```
  -d, --digest string   image digest
  -f, --format string   output format (default "text")
  -h, --help            help for packages
```

## <a id='see-also'></a>See also

* [insight image](insight_image.md)	 - Image commands

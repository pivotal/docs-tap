# Tanzu insight image packages

Get image packages.

## <a id='synopsis'></a>Synopsis

Get image packages.

```
tanzu insight image packages [--digest <image-digest>] [--name <name>] [--format <image-format>] [flags]
```

## <a id='examples'></a>Examples

```
tanzu insight image packages --digest sha256:a86859ac1946065d93df9ecb5cb7060adeeb0288fad610b1b659907 --format json
```

## <a id='options'></a>Options

```
  -d, --digest string   image digest
  -f, --format string   output format (default "text")
  -h, --help            help for packages
  -n, --name string     image name
```

## <a id='see-also'></a>See also

* [Tanzu insight image](insight_image.md)	 - Image commands

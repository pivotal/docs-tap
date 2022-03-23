# Tanzu insight image vulnerabilities

Get image vulnerabilities:

```
tanzu insight image vulnerabilities --digest <image-digest> [--format <image-format>] [flags]
```

## <a id='examples'></a>Examples

```
tanzu insight image vulnerabilities --digest sha256:a86859ac1946065d93df9ecb5cb7060adeeb0288fad610b1b659907 --format json
```

## <a id='options'></a>Options

```
  -d, --digest string   image digest
  -f, --format string   output format (default "text")
  -h, --help            help for vulnerabilities
```

## <a id='see-also'></a>See also

* [Tanzu insight image](insight-image.md)	 - Image commands

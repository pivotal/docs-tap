# Tanzu insight vulnerabilities images

Get images with a given vulnerability.

## <a id='synopsis'></a>Synopsis

Get images with a given vulnerability.

```console
tanzu insight vulnerabilities images --cveid <cve-id> [--format <format>] [flags]
```

## <a id='examples'></a>Examples

```console
tanzu insight vulnerabilities images --cveid CVE-123123-2021
```

## <a id='options'></a>Options

```console
  -c, --cveid string    CVE id
  -f, --format string   output format which can be in 'json' or 'text'. If not present, defaults to text. (default "text")
  -h, --help            help for images
```

## <a id='see-also'></a>See also

* [Tanzu insight vulnerabilities](insight-vulnerabilities.md)	 - Vulnerabilities commands

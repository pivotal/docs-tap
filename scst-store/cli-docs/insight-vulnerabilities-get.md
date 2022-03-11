# Tanzu insight vulnerabilities get

Get vulnerability by CVE id.

## <a id='synopsis'></a>Synopsis

Get vulnerability by CVE id.

```
tanzu insight vulnerabilities get --cveid <cve-id> [--format <format>] [flags]
```

## <a id='examples'></a>Examples

```
tanzu insight vulnerabilities get --cveid CVE-123123-2021
```

## <a id='options'></a>Options

```
  -c, --cveid string    CVE id
  -f, --format string   output format which can be in 'json' or 'text'. If not present, defaults to text. (default "text")
  -h, --help            help for get
```

## <a id='see-also'></a>See also

* [Tanzu insight vulnerabilities](insight-vulnerabilities.md)	 - Vulnerabilities commands

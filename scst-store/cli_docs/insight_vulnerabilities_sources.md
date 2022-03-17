# Insight vulnerabilities sources

Get sources with a given vulnerability.

## <a id='synopsis'></a>Synopsis

Get sources with a given vulnerability.

```
insight vulnerabilities sources --cveid <cve-id> [--format <format>] [flags]
```

## <a id='examples'></a>Examples

```
insight vulnerabilities sources --cveid CVE-123123-2021
```

## <a id='options'></a>Options

```
  -c, --cveid string    CVE id
  -f, --format string   output format which can be in 'json' or 'text'. If not present, defaults to text. (default "text")
  -h, --help            help for sources
```

## <a id='see-also'></a>See also

* [insight vulnerabilities](insight-vulnerabilities.md)	 - Vulnerabilities commands

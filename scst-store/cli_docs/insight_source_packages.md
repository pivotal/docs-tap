# Tanzu insight source packages

Get source packages.

## <a id='synopsis'></a>Synopsis

Get source packages.

```
tanzu insight source packages [--commit <commit-hash>] [--repo <repo-url>] [--format <format>] [flags]
```

## <a id='examples'></a>Examples

```
tanzu insight sources packages --commit 0b1b659907 --format json
```

## <a id='options'></a>Options

```
  -c, --commit string   commit hash
  -f, --format string   output format (default "text")
  -h, --help            help for packages
  -r, --repo string     source repository url
```

## <a id='see-also'></a>See also

* [Tanzu insight source](insight_source.md)	 - Source commands

# Insight source get

Get sources by repository, commit, or organization.

## <a id='synopsis'></a>Synopsis

Get sources by repository, commit, or organization.

```
insight source get --repo <repository> --commit <commit-hash> --org <organization-name> [--format <format>] [flags]
```

## <a id='examples'></a>Examples

```
insight source get --repo github.com/org/example --commit b33dfee51 --org company
```

## <a id='options'></a>Options

```
  -c, --commit string   commit hash
  -f, --format string   output format which can be in 'json' or 'text'. If not present, defaults to text. (default "text")
  -h, --help            help for get
  -o, --org string      organization that owns the source
  -r, --repo string     repository name
```

## <a id='see-also'></a>See also

* [insight source](insight_source.md)	 - Source commands

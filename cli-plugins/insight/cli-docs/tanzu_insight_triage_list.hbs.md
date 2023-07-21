# tanzu insight triage list

Use this command to return the list of existing vulnerability triages.

```console
tanzu insight triage list [flags]
```

## <a id='examples'></a>Examples

```console
insight triage list --img-digest sha256:123456789
insight triage list --src-commit a1s2d3f4 --limit 5
insight triage list --output-format api-json
insight triage list --page 5 --limit 20
```

## <a id='options'></a>Options

```console
  -h, --help                help for list
  -d, --img-digest string   Image digest
  -l, --limit uint          Limits the number of analysis to show (default 10)
  -p, --page uint           Allows to paginate the results based on the specified limit (default 1)
  -c, --src-commit string   Source commit
```

## <a id='options'></a>Options inherited from parent commands

```console
      --output-format string   specify the response's format, options=[text, api-json] (default "text")
```

## <a id='see-also'></a>See also

* [tanzu insight triage](tanzu_insight_triage.hbs.md)	 - Vulnerability analysis commands

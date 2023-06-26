## tanzu insight source packages

Get source packages

## <a id='synopsis'></a>Synopsis

Get source packages

```console
tanzu insight source packages [--commit <commit-hash>] [--repo <repository-name>] [flags]
```

## <a id='examples'></a>Examples

```console
insight sources packages --commit 0b1b659907 --repo example-repo
  insight sources packages --commit 0b1b659907 --repo example-repo --output-format api-json
```

## <a id='options'></a>Options

```console
  -c, --commit string          commit hash
  -h, --help                   help for packages
      --output-format string   specify the response's SBOM report format and file type format, options=[text, api-json] (default: text)
  -r, --repo string            repository name
```

## <a id='see-also'></a>See also

* [tanzu insight source](tanzu_insight_source.hbs.md)	 - Source commands


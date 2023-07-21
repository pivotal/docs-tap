# tanzu insight source vulnerabilities

Use this command to get source vulnerabilities.

## <a id='synopsis'></a>Synopsis

Get source vulnerabilities. You can specify either commit or repo.

```console
tanzu insight source vulnerabilities [--commit <commit-hash>] [--repo <repository-name>] [flags]
```

## <a id='examples'></a>Examples

```console
insight sources vulnerabilities --commit eb55fc13 --repo example-repo
  insight sources vulnerabilities --commit eb55fc13 --repo example-repo --output-format api-json
```

## <a id='options'></a>Options

```console
  -c, --commit string          commit hash
  -h, --help                   help for vulnerabilities
      --output-format string   specify the response's SBOM report format and file type format, options=[text, api-json] (default: text)
  -r, --repo string            repository name
```

## <a id='see-also'></a>See also

* [tanzu insight source](tanzu_insight_source.hbs.md)	 - Source commands

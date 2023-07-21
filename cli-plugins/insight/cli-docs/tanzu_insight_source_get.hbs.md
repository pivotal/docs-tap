# tanzu insight source get

Use this command to get sources by repository, commit or organization.

## <a id='synopsis'></a>Synopsis

Get sources by repository, commit or organization

```console
tanzu insight source get --repo <repository-name> --commit <commit-hash> --org <organization-name> [flags]
```

## <a id='examples'></a>Examples

```console
insight source get --org company --repo example-repo --commit b33dfee51
  insight source get --org company --repo example-repo --commit b33dfee51 --output-format api-json
  insight source get --org company --repo example-repo --commit b33dfee51 --output-format cyclonedx-xml
```

## <a id='options'></a>Options

```console
  -c, --commit string          commit hash
  -h, --help                   help for get
  -o, --org string             organization that owns the source
      --output-format string   specify the response's SBOM report format and file type format, options=[text, api-json, cyclonedx-xml, spdx-json] (default: text)
  -r, --repo string            repository name
```

## <a id='see-also'></a>See also

* [tanzu insight source](tanzu_insight_source.hbs.md)	 - Source commands

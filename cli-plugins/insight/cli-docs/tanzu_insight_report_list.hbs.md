# tanzu insight report list

This topic tells you how to use the Tanzu Insight CLI
`tanzu insight report list` command to get the package vulnerabilities.

## <a id='synopsis'></a>Synopsis

List reports by image digest, source commit hash, or original location

```console
tanzu insight report list (--digest <image-digest> | --commit <commit-sha> | --original-location <location>) [flags]
```

## <a id='examples'></a>Examples

```console
insight report list --digest sha256:a86859ac1946065d93df9ecb5cb7060adeeb0288fad610b1b659907
  insight report list --commit b33dfee51 --order ASC
  insight report list --original-location tanzu-java-web-app-my-apps-scan-results@sha256:cd541f747a78a1df3e1055da3e8c1b3bdd9a4aa8b0750bcb7b053a18d3833e81
```

## <a id='options'></a>Options

```console
  -c, --commit string              commit hash
  -d, --digest string              image digest
  -h, --help                       help for list
      --namespace string           the Kubernetes namespace of the workload that submitted the report. Cannot be used with workload-uid
      --order string               the order in which the list of reports will be returned. When set to 'ASC', will return the list in ascending order (oldest to newest) by date/time the report was generated. When set to 'DESC', will return the list in descending order (newest to oldest) (default: DESC)
      --original-location string   the URI location of where the original SBOM scan results are stored that is associated with the report
      --output-format string       specify the response's SBOM report format and file type format, options=[text, api-json] (default: text)
      --workload-name string       the name of the workload associated with the report. Cannot be used with workload-uid
      --workload-uid string        the UID of the workload associated with the report. Cannot be used with workload-name or namespace
```

## <a id='see-also'></a>See also

* [tanzu insight report](tanzu_insight_report.hbs.md)	 - Report commands

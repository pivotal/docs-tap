# tanzu insight triage rebase

This topic tells you how to use the Tanzu Insight CLI
`tanzu insight triage rebase` command to get a list of the existing vulnerability triages.

## <a id='synopsis'></a>Synopsis

This command takes all the existing analyses within an artifact group that are
valid for the target image and copies them over. An analysis is considered valid
for an image within an artifact group when the following conditions are met:

- The analysis exists for a vulnerability that the target image is affected by and
is linked to a "previous version" of an image.
- There is no existing analysis for the same vulnerability and the target image,
  or their state is 'in_triage'

For example, Image A is considered to be a previous version of  Image
B when they have the same name, different digests and Image A was created before
Image B.

```console
tanzu insight triage rebase --img-digest <digest> --artifact-group-uid <ag-uid> [flags]
```

## <a id='examples'></a>Examples

```console
insight triage rebase --img-digest sha256:192369123812 --artifact-group-uid BEC0F39C-FE99-4F18-A0AF-069A4AA8D71A
```

## <a id='options'></a>Options

```console
  -a, --artifact-group-uid string   Artifact group uid
  -h, --help                        help for rebase
  -d, --img-digest string           Image digest
      --img-registry string         Image registry
  -y, --yes                         Force update
```

## <a id='options'></a>Options inherited from parent commands

```console
      --output-format string   specify the response's format, options=[text, api-json] (default "text")
```

## <a id='see-also'></a>See also

* [tanzu insight triage](tanzu_insight_triage.hbs.md)	 - Vulnerability analysis commands

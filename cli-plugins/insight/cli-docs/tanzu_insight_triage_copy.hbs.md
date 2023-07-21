# tanzu insight triage copy

Use this command to copy an existing analysis to a new image, source or artifact group.

## <a id='synopsis'></a>Synopsis

This command takes an existing triage and copies the latest analysis to target a
new image, source or artifact group affected by the vulnerability of the
existing triage. This allows you to easily copy analysis between images and
sources that belong to different artifact groups, or different versions of an
image/source that belong to the same artifact group. 

If an image or source are provided, validations will run to make sure they
contain the affected package and vulnerability, and that they belong to the
existing triage's artifact group. If an artifact group is provided, validations
will run to make sure it contains the provided image/source, or the original
ones from the existing triage.

```console
tanzu insight triage copy --triage-uid-to-copy <uid> [--img-digest <digest>] [--src-commit <commit>] [--artifact-group-uid <ag-uid>] [flags]
```

## <a id='examples'></a>Examples

```console
insight triage copy --triage-uid-to-copy BEC0F39C-FE99-4F18-A0AF-069A4AA8D71A --img-digest sha256:192369123812
insight triage copy --triage-uid-to-copy BEC0F39C-FE99-4F18-A0AF-069A4AA8D71A --src-commit 5025112c8b1 --artifact-group-uid AG-00003
insight triage copy --triage-uid-to-copy BEC0F39C-FE99-4F18-A0AF-069A4AA8D71A --artifact-group-uid AG-00002
```

## <a id='options'></a>Options

```console
  -a, --artifact-group-uid string   Artifact group uid
  -h, --help                        help for copy
  -d, --img-digest string           Image digest
      --img-registry string         Image registry
  -c, --src-commit string           Source commit
      --src-org string              Source organization
      --src-repo string             Source repository
  -u, --triage-uid-to-copy string   Triage UID to copy from
  -y, --yes                         Force update
```

## <a id='options'></a>Options inherited from parent commands

```console
      --output-format string   specify the response's format, options=[text, api-json] (default "text")
```

## <a id='see-also'></a>See also

* [tanzu insight triage](tanzu_insight_triage.hbs.md)	 - Vulnerability analysis commands


# Triage vulnerabilities

This topic tells you how to add analyze vulnerabilities associated with a workload
in the Supply Chain Security Tools (SCST) - Store. This is an experimental feature, and the
API is prone to changes in subsequent releases.

## <a id='triage-description'></a>What is triaging?

Vulnerability analysis, or triage is the process of evaluating a reported vulnerability to
decide an effective remediation plan. Triage helps application teams to
generate useful insights about the vulnerabilities in their software so that they can make the right
decisions about when and how to mitigate them. The current implementation of triage follows
[CycloneDX's Vulnerability Exploitability eXchange (VEX)](https://cyclonedx.org/capabilities/vex/)
specification, and is designed specifically to work with Tanzu workloads.

For information about this feature, see [SCST - Store data model definition](../../scst-store/data-models-and-concepts.md).

## <a id='prerequisites'></a>Prerequisites

Before you begin vulnerability analysis, you must:

- Install the [Tanzu Insight CLI plug-in](cli-installation.hbs.md).
- Add vulnerability scan reports to the SCST - Store. You can do this either
by using the `tanzu insight image add` command or by installing the SCST - Scan.
For more information, see [Add data](add-data.hbs.md) and [Supply Chain Security Tools - Scan](../../scst-scan/overview.hbs.md).

## <a id='creating-analysis'></a>Create vulnerability analyses

A vulnerability analysis contains the following data:

1. *state*: Declares the current state of an occurrence of a vulnerability, after automated or
   manual analysis.
2. *justification*: The rationale of why the impact analysis state was asserted.
3. *response*: A response to the vulnerability by the manufacturer, supplier, or project responsible
   for the affected component or service.
4. *comment*: Free form comments to provide additional details.

For more information about the supported values for each of these fields, see
[tanzu insight triage update](./cli-docs/tanzu_insight_triage_update.hbs.md).

For example, if you are interested in a vulnerability affecting a specific image in your workload,
and are investigating its impact, you can add this information to the SCST - Store:

```console
tanzu insight triage update \
  --cveid $CVEID \
  --pkg-name $PKG-NAME \
  --pkg-version $PKG-VERSION \
  --img-digest $IMG-DIGEST \
  --artifact-group-uid $AG-UID \
  --state in_triage
```

Where:

- `CVEID` is the unique identifier of the vulnerability
- `PKG-NAME` and `PKG-VERSION` are the name and version of the Application and OS package affected
by the vulnerability
- `IMG-DIGEST` is the digest of the image that contains the affected Application and OS package
- `AG-UID` is the unique identifier for the workload that contains the image
  - If your workload was deployed with Tanzu CLI, you can find its unique identifier with the command:
    
    ```console
    kubectl get workload $MY_WORKLOAD_NAME --namespace $MY_WORKLOAD_NAMESPACE --output jsonpath='{.metadata.uid}'
    ```

> **Note** If your affected package is linked to a source instead of an image, you can use `--src-commit`
> instead of `--img-digest`

As you continue to investigate the vulnerability, you can update your analysis with the latest
findings by using the `tanzu insight triage update` command as many times as needed.

## <a id='viewing-analysis'></a>View existing analysis

To view all the existing analysis in SCST - Store:

```console
tanzu insight triage list
```

The results are paginated by default. You can switch the current page or the number of results
returned by providing the `--page` or `--limit` flags respectively. You can also filter the
results by image or source. For more information, use the `--help` flag or see
[tanzu insight triage list](./cli-docs/tanzu_insight_triage_list.hbs.md).

## <a id='copying-analysis'></a>Copying an analysis

Sometimes, you might run into scenarios where an existing analysis might be shared between multiple
images, for example, when a new version of an existing image is deployed by your workload and it
contains the same vulnerability as the previous version, or when you create an analysis for an image
that is shared between multiple workloads.

To speed up triage in those cases, you can use the `copy` subcommand:

```console
tanzu insight triage copy \
  --triage-uid-to-copy $TRIAGE-UID \
  --img-digest $TARGET-IMAGE
```

Where:
- `TRIAGE-UID` is the uid of an existing analysis
- `TARGET-IMAGE` is the digest of an image you want to copy the analysis to

The following conditions are required for this action:

1. If specified, the targeted image or source must contain the package affected by the vulnerability
   in the existing analysis.
2. If only an image or source are specified, they must belong to the same workload as the one in the
   existing analysis.
3. If only an `artifact-group-uid` is specified, it must contain the image or source associated in
   the existing analysis.

> **Note** The responsibility of assessing a vulnerability's impact is up to the person in charge of
> triage. Images and sources with the same package and version might use the
> package in a different way and might not have the same analysis values.

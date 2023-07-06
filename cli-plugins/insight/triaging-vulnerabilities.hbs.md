# Triaging vulnerabilities

This topic describes how to add analyses to any vulnerability associated to a workload
in the Supply Chain Security Tools - Store. Keep in mind this is an experimental feature, and the
API is prone to changes in subsequent releases.

## <a id='triage-description'></a>What is triaging?

Vulnerability analysis, triaging or triage is the process of evaluating a reported vulnerability in
order to determine an effective remediation plan. It is through triage that app teams are able to
generate useful insights about the vulnerabilities in their software so that they can make the right
decisions about when and how to mitigate them. The current implementation of triage follows
[CycloneDX's Vulnerability Exploitability eXchange (VEX)](https://cyclonedx.org/capabilities/vex/)
specification, and is designed specifically to work with Tanzu workloads.

## <a id='prerequisites'></a>Prerequisites

Previous to triage, you need to [install the Tanzu Insight CLI plug-in](cli-installation.md) and
have vulnerability data loaded into the Supply Chain Security Tools - Store. You can load data using
the [Tanzu Insight CLI plug-in](add-data.md) or by installing the [Supply Chain Security Tools -
Scan](../../scst-scan/overview.md).

## <a id='creating-analysis'></a>Creating vulnerability analyses

Currently, a vulnerability analysis can contain the following data:

1. *state*: Declares the current state of an occurrence of a vulnerability, after automated or
   manual analysis.
1. *justification*: The rationale of why the impact analysis state was asserted.
1. *response*: A response to the vulnerability by the manufacturer, supplier, or project responsible
   for the affected component or service.
1. *comment*: Free form comments to provide additional details

You can read more about the supported values for each of this fields
[here](./cli-docs/tanzu_insight_triage_update.md).

For example, if you are interested in a vulnerability affecting an specific image in your workload,
and are currently investigating its impact, you can add this information to the SCST - Store by
running the following command:

```console
tanzu insight triage update \
  --cveid $CVEID \
  --pkg-name $PKG_NAME \
  --pkg-version $PKG_VERSION \
  --img-digest $IMG_DIGEST \
  --artifact-group-uid $AG_UID \
  --state in_triage
```

Where:

- `CVEID` is the unique identifier of the vulnerability
- `PKG_NAME` and `PKG_VERSION` are the name and version of the Application/OS package affected by the vulnerability
- `IMG_DIGEST` is the digest of the image that contains the affected Application/OS package
- `AG_UID` is the unique identifier for the workload that contains the image
  - If your workload was deployed with Tanzu CLI, you can find its unique identifier with the command:
    ```console
    kubectl get workload $MY_WORKLOAD_NAME --namespace $MY_WORKLOAD_NAMESPACE --output jsonpath='{.metadata.uid}'
    ```

> **Note** If your affected package is linked to a source instead of an image, you can use `--src-commit`
> instead of `--img-digest`

As you continue to investigate the vulnerability, you can update your analysis with the latest
findings by using the `tanzu insight triage update` command as many times as needed.

## <a id='viewing-analysis'></a>View existing analysis

To view all the existing analysis in SCST - Store, use the following command:

```console
tanzu insight triage list
```

The results will be paginated by default. You can switch the current page or the amount of results
returned by providing the `--page` and/or `--limit` flags respectively. You can also filter the
results by image or source. For more information, use the `--help` flag or read through
[this doc](./cli-docs/tanzu_insight_triage_list.md).

## <a id='copying-analysis'></a>Copying an analysis

Sometimes, you might run into scenarios where an existing analysis could be shared between multiple
images, for example, when a new version of an existing image gets deployed by your workload and it
contains the same vulnerability as the previous version, or when you create an analysis for an image
that is shared between multiple workloads.

To speed up the triage process in those cases, you can use the `copy` subcommand:

```console
tanzu insight triage copy \
  --triage-uid-to-copy $TRIAGE_UID \
  --img-digest $TARGET_IMAGE
```

Where:
- `TRIAGE_UID` is the uid of an existing analysis
- `TARGET_IMAGE` is the digest of an image you want to copy the analysis to

Keep in mind that there are a couple of conditions for this action to work:

1. If specified, the targeted image or source must contain the package affected by the vulnerability
   in the existing analysis
2. If only an image or source are specified, they must belong to the same workload as the one in the
   existing analysis
3. If only an `artifact-group-uid` is specified, it must contain the image or source associated in
   the existing analysis

> **Note** The responsibility of assessing a vulnerability's impact is up to the person in charge of
> the triage process. Images and sources with the same package and version may be utilizing the
> package in a different manner and, thus, may not have the same analysis values.

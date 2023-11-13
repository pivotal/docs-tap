# Troubleshoot Tanzu Developer Portal Configurator

This topic helps you troubleshoot Tanzu Developer Portal Configurator.

<a id='supply-chain-not-found'></a> No supply chain found in `tdp-workload.yaml`

## Symptom

No supply chain is found in `tdp-workload.yaml`

## Cause

You might not have specified all of the correct information regarding your workload if you're using
a supply chain other than `basic`. This documentation has the assumption that you're running the
`basic` supply chain, so it doesn't tell you to add any tests.
Because supply chains are configurable, there might be stages unique to your configuration.

## Solution

If you have a supply chain that requires testing, use a no-op set of tests to make the workload
pass through. For more information about no-op, see [Wikipedia](https://en.wikipedia.org/wiki/NOP_(code)).

Add the following test YAML to your developer namespace:

```yaml
apiVersion: tekton.dev/v1beta1
kind: Pipeline
metadata:
  labels:
    apps.tanzu.vmware.com/pipeline: noop-pipeline
  name: developer-defined-noop-tekton-pipeline
  namespace: DEVELOPER-NAMESPACE
spec:
  params:
  - name: source-url
    type: string
  - name: source-revision
    type: string
  tasks:
  - name: noop-task
    params:
    - name: source-url
      value: $(params.source-url)
    - name: source-revision
      value: $(params.source-revision)
    taskSpec:
      metadata: {}
      params:
      - name: source-url
        type: string
      - name: source-revision
        type: string
      steps:
      - image: bash
        name: noop
        resources: {}
        script: |
          echo "Nothing to do for $(params.source-url)/$(params.source-revision)"%
```

Where `DEVELOPER-NAMESPACE` is an appropriately configured developer namespace on the cluster

Add the following YAML to your workload definition:

```yaml
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  labels:
    # Existing labels
    apps.tanzu.vmware.com/has-tests: 'true'
spec:
  # Existing parameters
  params:
    - name: testing_pipeline_matching_labels
      value:
        apps.tanzu.vmware.com/pipeline: noop-pipeline
    - name: testing_pipeline_params
      value: {}
```

Now when you submit your workload, the testing stage finishes.

<a id='freq-conv-cntrllr-fail'></a> Convention controller fails frequently

## Symptom

Convention controller fails frequently and prevents other workloads from completing.

## Cause

The frequent failures are caused by the large memory limit of the Software Bill of Materials (SBOM).
The Tanzu Developer Portal Configurator build process produces this SBOM, and `PodIntent` reports an
out-of-memory error.

## Solution

Create an overlay to increase the memory limit of `PodIntent` to 512&nbsp;MB.
To learn how to do so, see
[Troubleshoot Cartographer Conventions](../../cartographer-conventions/troubleshooting.hbs.md#oom-killed).
# Troubleshooting Tanzu Developer Portal Customizer

### Symptom

No Supplychain Found on tdp-workload.yaml

### Cause

You may not have specified all of the correct information regarding your workload if you're using a supplychain other than `basic`. Our documentation assumes that you're running the `basic` supplychain, so it doesn't add any tests. Since supplychains are configurable, there can be stages unique to your configuration.

### Solution

If you have a supplychain that requires testing, you can use a [no-op](https://en.wikipedia.org/wiki/NOP_(code)) set of tests to make the workload pass through.

Add the following test to your developer namespace:

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
      - image:  bash
        name: noop
        resources: {}
        script: |
          echo "Nothing to do for $(params.source-url)/$(params.source-revision)"%
```

Where:

- `DEVELOPER-NAMESPACE` is an appropriately configured developer namespace on the cluster

Then, add to following to your workload definition:

```yaml
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  labels:
    # Existing labels
    apps.tanzu.vmware.com/has-tests: 'true'
spec:
  # Existing paramters
  params:
    - name: testing_pipeline_matching_labels
      value:
        apps.tanzu.vmware.com/pipeline: noop-pipeline
    - name: testing_pipeline_params
      value: {}
```
Now when you submit your workload, the testing stage will complete and move on.
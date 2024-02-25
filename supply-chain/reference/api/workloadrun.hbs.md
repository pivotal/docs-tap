# WorkloadRun CRD

{{> 'partials/supply-chain/beta-banner' }}

WorkloadRuns are [Custom Kubernetes Resources (CRDs)][CRD] created by [SupplyChains].
They are also one of the two [Duck Typed Resources] in Tanzu Supply chain

## Static CustomResourceDefinitions API

All WorkloadRuns are defined as CustomResourceDefinitions:

```yaml
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
```

### `metadata.labels`

Workload CRDs always have the following labels.
The `chain-name` and `chain-namespace` labels reference the location of the [SupplyChain] resource that created this WorkloadRun.
The `chain-role` identifies this as a WorkloadRun. The other possible value is `workload`.

```yaml
metadata:
  labels:
    supply-chain.apps.tanzu.vmware.com/chain-name: apps.example.com-1.0.0
    supply-chain.apps.tanzu.vmware.com/chain-namespace: app-sc
    supply-chain.apps.tanzu.vmware.com/chain-role: workload-run
```

### `metadata.name`

The name of the resource is always in the form `<singular>runs.<group>` from the [Supply Chain Defines API](./supplychain.hbs.md#specdefines)

#### Example

```yaml
metadata:
  name: appv1runs.widget.com
```

### `spec.group`, `spec.names` and `spec.versions`

The CRD's `group`, `names` and `versions` is filled in with the details found in the [Supply Chain Defines API](./supplychain.hbs.md#specdefines).
However most names have the word "run" appended.

Additionally, the `spec.names[].categories[]` array includes a category of `all-runs`. This ensures that
commands such as `kubectl get all-runs` will find all the [SupplyChain] defined WorkloadRuns a user can access.

#### Example
```yaml
spec:
  conversion:
    strategy: None
  group: example.com
  names:
    categories:
      - all-runs
    kind: AppV1Run
    listKind: AppV1RunList
    plural: appv1runs
    singular: appv1run
  scope: Namespaced
  versions:
      name: v1alpha1
      schema:
        openAPIV3Schema:
          ...
```

## Self-Replicating State

WorkloadRuns have a complex self-referencing status, that is described in detail in [Core Concepts: WorkloadRuns](../../platform-engineering/explanation/workload-runs.hbs.md). 
The majority of the WorloadRun specification appears again in `status.workloadRun`. In this document we'll not repeat the definition, just take it as given, that they're essentially the same.

This image shows the static and dynamic sections of a WorkloadRun. 

![duck-type.png](images%2Fduck-type.png)

> **Note**
> The duplication of the WorkloadRun `spec` into `spec.status.workloadRun.spec` is shown here.

> **Note**
> The `status` **is not** duplicated again into the `status.workloadRun` field.

## Static Workload API



## Dynamic Workload API







------------



## Conditions

There are three conditions in a WorkloadRun:

1. PipelinesSucceeded
2. ResumptionsSucceeded
3. Succeeded (Top Level)

### PipelinesSucceeded

| Status  | Reason         | Message                                 |                                                                                                                                               |
|---------|----------------|-----------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------|
| Unknown | Running        | \<processing details>                   | The pipeline is still running.                                                                                                                |
| True    | Succeeded      | \<processing details>                   | The pipeline completed successfully.                                                                                                          |
| False   | Failed         | \<processing details and error message> | The pipeline failed, and it's likely that the developer can remedy any issues by following the guidance in the message.                       | 
| False   | PlatformFailed | \<processing details and error message> | The pipeline failed, and it's unlikely the problem can be remedied with changes to the workload or developer provided input (such as source). |

`Message` contains processing information and error messages produced in the pipeline. This information must be
specifically appended to the Tekton result named `message`

### ResumptionsSucceeded

| Status  | Reason         | Message                                 |                                                                                                                                           |
|---------|----------------|-----------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------|
| Unknown | Running        | \<processing details>                   | The task is still running.                                                                                                                |
| True    | Succeeded      | \<processing details>                   | The task completed successfully.                                                                                                          |
| False   | Failed         | \<processing details and error message> | The task failed, and it's likely that the developer can remedy any issues by following the guidance in the message.                       | 
| False   | PlatformFailed | \<processing details and error message> | The task failed, and it's unlikely the problem can be remedied with changes to the workload or developer provided input (such as source). |

`Message` contains processing information and error messages produced in the taskRun. This information must be
specifically appended to the Tekton result named `message`

### Type: Succeeded

| Status  | Reason         | Message                                 |                                                                                                                                                                                          |
|---------|----------------|-----------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Unknown | Running        | \<processing details>                   | The component is still running.                                                                                                                                                          |
| True    | Succeeded      | \<processing details>                   | The component completed successfully.                                                                                                                                                    |
| False   | Failed         | \<processing details and error message> | The component failed in either the Resumptions or the Pipeline, and it's likely that the developer can remedy any issues by following the guidance in the message.                       | 
| False   | PlatformFailed | \<processing details and error message> | The component failed in either the Resumptions or the Pipeline, and it's unlikely the problem can be remedied with changes to the workload or developer provided input (such as source). |

`Message` contains processing information and error messages produced in the resumptions and pipeline. This information
must be
specifically appended to the Tekton result named `message`

The Succeeded condition reflects whichever is the least-desirable condition
from [PipelinesSucceeded](#pipelinessucceeded) or
[ResumptionsSuceeded](#resumptionssucceeded).

Least desirable to most desirable state is `False` &#2192; `Unknown` &#2192; `True`

[Duck Typed Resources]: ./duck-types.hbs.md
[SupplyChain]: ./supplychain.hbs.md
[SupplyChains]: supplychain.hbs.md
[Workload]: ./workload.hbs.md
[Component]: component.hbs.md
[Components]: component.hbs.md
[WorkloadRun]: workloadrun.hbs.md
[CRD]: https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/ "Kubernetes Custom Resource documentation"
[Kind]: https://kubernetes.io/docs/concepts/overview/working-with-objects/ "Kebernetes documentation for Objects"

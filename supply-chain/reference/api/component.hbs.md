# Component API

This topic gives you reference information about the `Component` resource for Tanzu Supply Chain.

{{> 'partials/supply-chain/beta-banner' }}

Components define the work to be done in one [Stage](supplychain.hbs.md#specstages) of the `SupplyChain`.

## Type and Object Metadata

```yaml
apiVersion: supply-chain.apps.tanzu.vmware.com/v1alpha1
kind: Component
```

### `metadata.name`

`metadata.name:` must have a `-M.m.p` suffix, representing the major, minor and patch of this
version of the component. Changes to the config section should coincide with a bump to major or
minor versions. Reserve patch increments for changes that do not alter the API, or the behavior
significantly.

```yaml
metadata:
  name: source-1.0.0
```

## Spec

### `spec.description`

`spec.description` describes the component's purpose.
You will see this description in `tanzu workload run list`.

```yaml
spec:
  description: Gets the latest source and stores it in an OCI Image
```

### <a id='spec-config'></a>`spec.config`

`spec.config` defines the configuration in a workload (`spec` of the workload) that is required for
the component to operate.

`spec.config` is an array with three fields:

- `path:` describes the path in the workload where this configuration is appended/merged. It must
  start with `spec.`
- `schema` and `required` define a property. See the (Kubernetes)[https://kubernetes.io/docs/home/]
  documentation.

#### Example

```yaml
  config:
    - path: spec.source.git
      schema:
        type: object
        description: |
          Fill this object in if you want your source to come from git.
          The tag, commit and branch fields are mutually exclusive,
          use only one.
        properties:
          tag:
            description: A git tag ref to watch for new source
            type: string
          commit:
            description: A git commit sha to use
            type: string
          branch:
            description: A git branch ref to watch for new source
            type: string
          url:
            description: The url to the git source repository
            type: string
        required:
          - url
```

### `spec.pipelineRun`

The `spec.pipelineRun` section defines the work done by this component.
`spec.pipelineRun` is used to create a [Tekton PipelineRun] and has many similarities.

#### `spec.pipelineRun.pipelineRef`

The `spec.pipelineRun.pipelineRef` is required, and it has one field `name` that must refer to the
`metadata.name` of a [Tekton Pipeline] that resides in the same namespace as the `Component` and
`SupplyChain`.

#### `spec.pipelineRun.workspaces`

If you need to define workspaces to pass to the Tekton `PipelineRun`, use `spec.pipelineRun.workspaces`.
This field is an array of workspace definitions, and is identical to the Tekton Workspaces specification.

#### `spec.pipelineRun.params`

`spec.pipelineRun.params` are the same as [Tekton PipelineRun Parameters] with one major difference:
you can populate them using templates.

The available references for templating are:

| reference                                     | source                                  | examples                                                   |
|-----------------------------------------------|-----------------------------------------|------------------------------------------------------------|
| `$(workload.spec...)`                         | The workload spec                       | `$(workload.spec.source.git.url)`                          |
| `$(workload.metadata...)`                     | The workload metadata                   | `$(workload.metadata.labels)`, `$(workload.metadata.name)` |
| `$(inputs.<input-name>.[url\|digest])`        | An input url or digest                  | `$(inputs.image.url)`, `$(inputs.image.digest)`            |
| `$(resumptions.<resumption-name>.results...)` | A [resumption](#specresumptions) result | `$(resumptions.check-source.results.sha)`                  |

#### Example

```yaml
spec:
  pipelineRun:
    pipelineRef:
      name: source
    params:
      - name: git-url
        value: $(workload.spec.source.git.url)
      - name: sha
        value: $(resumptions.check-source.results.sha)
    workspaces:
      - name: shared-data
        volumeClaimTemplate:
          spec:
            accessModes:
              - ReadWriteOnce
            resources:
              requests:
                storage: 1Gi
```

### `spec.outputs`

```yaml
  outputs:
    - name: source
      type: source
```

### `spec.resumptions[]`

`spec.resumptions[]` define Tekton `TaskRuns`. They are optional, but useful to describe small, fast
tasks that check for dependency changes, such as new source, or new base images.

For a detailed explanation of resumptions, see
[Core Concepts: Resumptions](../../platform-engineering/explanation/resumptions.hbs.md).

#### `spec.resumptions[].name`

`spec.resumptions[].name` is visible to end users, so make sure it's suitably meaningful. It's
recommended that it's in the form: `check-RESOURCE-TYPE` where `RESOURCE-TYPE` is the kind of
resource being polled, such as `source` or `base-image`.

#### `spec.resumptions[].trigger.runaAfter`

`spec.resumptions[].trigger.runaAfter` describes the rerun period for the task. The task is
executed, and after it completes (successfully or otherwise), Tanzu Supply Chain waits the
`runaAfter` period and then executes the task again. This continues indefinitely.

`runAfter` can be specified using the
[`time.ParseDuration()`](https://pkg.go.dev/maze.io/x/duration#ParseDuration) specification.

#### `spec.resumptions[].taskRef`

The `spec.resumptions[].taskRef` has one field `name` that must refer to the `metadata.name`
of a Tekton `Task` that resides in the same namespace as the `Component` and `SupplyChain`.

This is the task that run's on the resumptions `spec.resumptions[].trigger`

#### `spec.resumptions[].params`

`spec.resumptions[].params` are the same as Tekton `TaskRun` Parameters with one major difference:
you can populate them using templates.

The available references for templating references are:

| reference                              | source                 | examples                                                   |
|----------------------------------------|------------------------|------------------------------------------------------------|
| `$(workload.spec...)`                  | The workload spec      | `$(workload.spec.source.git.url)`                          |
| `$(workload.metadata...)`              | The workload metadata  | `$(workload.metadata.labels)`, `$(workload.metadata.name)` |
| `$(inputs.<input-name>.[url\|digest])` | An input url or digest | `$(inputs.image.url)`, `$(inputs.image.digest)`            |

#### Example

```yaml
  resumptions:
    - name: check-source
      trigger:
        runAfter: 60s
      taskRef:
        name: check-source
      params:
        - name: git-branch
          value: $(workload.spec.source.git.branch)
        - name: git-url
          value: $(workload.spec.source.git.url)
        - name: git-commit
          value: $(workload.spec.source.git.commit)
        - name: git-tag
          value: $(workload.spec.source.git.tag)
```

## Status

### `status.conditions[]`

Every `status.conditions[]` in Tanzu Supply Chain resources follows a
[strict set of conventions](statuses.hbs.md)

`Component` resources are "living", however they are resistant to changes in their spec, They're
designed to be immutable on production servers, so that accidental spec changes do not break the API
delivered to end users.

If a `Component`'s top level condition `Ready` is ever something other than `status: "True"` then
the `reason` field should describe the problem with the component.

### `status.details`

`status.details` describe some of the observations that Tanzu Supply Chains made about this
component. These fields are used to improve the output of `kubernetes get component <name> -owide`,
and they summarize the component for platform engineers when they author a `SupplyChain`.

```yaml
status:
  conditions:
  - lastTransitionTime: "2024-02-25T00:40:46Z"
    message: ""
    reason: Ready
    status: "True"
    type: Ready
  details:
    hasResumptions: "False"
    inputs: conventions[conventions[]
    outputs: oci-yaml-files[oci-yaml-files[], oci-ytt-files[oci-ytt-files[]
  observedGeneration: 1
```

### <a id='status-docs'></a>`status.docs`

`status.docs` contains a human-readable explanation of the content of the component.
It's useful for CLIs and UIs, and provides a clean summary of the component.

#### Example

```
docs: |
  # source

  Version: 1.0.0

  ## Description

  Monitors a git repository

  ## Inputs

  * _none_

  ## Outputs

  | Name  | Type |
  | ---   | ---  |
  | source | [source](./output-types.hbs.md#source) |

  ## Config

  ``yaml
  spec:
    source:
      # Fill this object in if you want your source to come from git.
      # The tag, commit and branch fields are mutually exclusive, use only one.
      git:
        # A git branch ref to watch for new source
        branch:
        # A git commit sha to use
        commit:
        # A git tag ref to watch for new source
        tag:
        # The url to the git source repository
        # +required
        url:
  ``
```

<!--
[SupplyChain]: supplychain.hbs.md
[Workload]: workload.hbs.md
[Component]: ./component.hbs.md
[Components]: ./component.hbs.md
[WorkloadRun]: workloadrun.hbs.md
[OpenAPI Structural Schema]: https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/#specifying-a-structural-schema
[Tekton PipelineRun]: https://tekton.dev/docs/pipelines/pipelineruns/
[Tekton PipelineRuns]: https://tekton.dev/docs/pipelines/pipelineruns/
[Tekton Pipeline]: https://tekton.dev/docs/pipelines/pipelines/
[Tekton Pipelines]: https://tekton.dev/docs/pipelines/pipelines/
[Tekton Workspaces]: https://tekton.dev/docs/pipelines/pipelineruns/#specifying-workspaces
[Tekton PipelineRun Parameters]: https://tekton.dev/docs/pipelines/pipelineruns/#specifying-parameters
[Tekton TaskRun Parameters]: https://tekton.dev/docs/pipelines/taskruns/#specifying-parameters
[Tekton Taskruns]: https://tekton.dev/docs/pipelines/taskruns/
[Tekton Task]: https://tekton.dev/docs/pipelines/tasks/
-->
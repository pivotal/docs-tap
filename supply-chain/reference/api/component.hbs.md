# Component API

{{> 'partials/supply-chain/beta-banner' }}

This section describes the Component resource of Tanzu Supply Chains.

Components define the work to be done in one [Stage](./supplychain.hbs.md#specstages) of the [SupplyChain]

## Type and Object Metadata

```yaml
apiVersion: supply-chain.tanzu.vmware.com/v1alpha1
kind: Component
```

### `metadata.name`

`matadata.name:` must have a `-M.m.p` suffix, representing the major, minor and patch of this version of the component.
Changes to the config section [(described below)](#specconfig) should coincide with a bump to major or minor versions.
Reserve patch increments for changes that do not alter the API, or the behavior significantly.

```
metadata:
  name: source-1.0.0
```

## Spec

### `spec.description`

`spec.description` describes the component's purpose.
TBD two commands here Users will see this description in `tanzu workload run list`

```yaml
spec:
  description: Gets the latest source and stores it in an OCI Image 
```

### `spec.config`

`spec.config` defines the configuration in a workload (`spec` of the workload) that is required for the component to
operate

`spec.config` is an array with three fields:

* `path:` describes the path in the workload where this configuration is appended/merged. It must start with `spec.`
* `schema` and `required` define a property. See the [OpenAPI Structural Schema] kubernetes docs for more details.

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

The `spec.pipelineRun.pipelineRef` is required, and it has one field `name` that **must** refer to the `metadata.name`
of a [Tekton Pipeline] that resides
in the same namespace as the Component and SupplyChain.

#### `spec.pipelineRun.workspaces`

If you need to define workspaces to pass to the [Tekton PipelineRun], use `spec.pipelineRun.workspaces`.
This field is an array of workspace definitions, and is identical to the [Tekton Workspaces] specification.

#### `spec.pipelineRun.params`

`spec.pipelineRun.params` are the same as [Tekton PipelineRun Parameters] with one major difference: you can populate
them using templates.

The available references for template references are:

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

### `spec.resumptions`

<tbd>

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

[//]: # (Components:)

[//]: # ()

[//]: # (1. Specify the work to do for the stage)

[//]: # (    * as a Tekton PipelineRun &#40;*line 44*&#41;)

[//]: # (3. Optionally specify small tasks used to check for dependency changes, such as new source, base images)

[//]: # (    * as Tekton TaskRuns &#40;*line 29*&#41;)

[//]: # (4. Are used to specify the work to be done in a [SupplyChain] `stage`)

### Status

<tbd>

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
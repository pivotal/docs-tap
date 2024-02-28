# SupplyChain API

{{> 'partials/supply-chain/beta-banner' }}

This topic describes the SupplyChain resource of Tanzu Supply Chain.

The supply chain defines the Object Kind of the Workload, the Components used, and their order.

## Type and Object Metadata

```yaml
apiVersion: supply-chain.apps.tanzu.vmware.com/v1alpha1
kind: SupplyChain
```

### `metadata.name`

`metadata.name` is in the form:

`<plural-name>.<group>-<Major>.<minor>.<patch>`

- `plural-name` must match the plural form of `defines.kind`, without the version.
  For example: `kind: JavaServerAppV3` would have a `plural-name` of `javaserverappv3s`
- `group` must mach `defines.group` (see [`spec.defines.group`](#specdefines) below )
- `<Major>.<minor>.<patch>` is the version definition.

```yaml
metadata:
  name: hostedapps.widget.com-0.0.1
```

## Spec

### `spec.description`

The `spec.description` field is visible to an app developer when they use the CLI to discover available workload kinds:

```console
tanzu workload kind list --wide

KIND                      VERSION     AGE   DESCRIPTION
serverappv2.example.com   v1alpha1    12m   Server application supply chain
```

**Recommendation:** embed complete documentation in the description.

The description field supports multi-line Plain text or Markdown.

### `spec.defines`

The `spec.defines` object defines the Workload [CustomResourceDefinition].

#### `spec.defines.group`

`spec.defines.group` (**required**) is used to fill in the `group` field in the [CustomResourceDefinitionSpec].

`spec.defines.group` is the classic domain-formatted group of any Kubernetes object.
Use your organization's top level domain, or a departmental domain.

#### `spec.defines.kind`

`spec.defines.kind` (**required**) is the name of the resource in CamelCase.

#### `spec.defines.plural`

`spec.defines.plural` (**required**) is typically the plural down-cased form of the kind.
It must be all lowercase.

**Recommendation:** pluralize the name after the version, e.g: `WebAppV1` becomes `webappv1s`

#### `spec.defines.singular`

`spec.defines.singular` is optional and defaults to the lowercase of `kind`, for example `ServerAppv1`
becomes `serverappv1`.

#### `spec.defines.shortnames`

`spec.defines.shortnames` is a list and defaults to empty.
Use this to specify an array of aliases for your kind.
These are great to simplify `kubectl` commands.

##### Example

```console
kind: ServerAppV1
plural: serverappv1s
shortnames:
  - serverapp1
  - sa1
```

#### `spec.defines.categories`

`spec.defines.categories` is a list and defaults to empty.
`spec.defines.categories` specify a collection term for a group of kinds, so that `kubectl get <category>` returns
instances of all kinds in the category.

##### Example

Using `kubectl get apps` would include this kind in the listing

```console
kind: ServerAppV1
plural: serverappv1s
categories:
  - apps
```

#### Complete Example

```console
spec:
  defines: # Describes the workload
    kind: HostedApp
    pluralName: hostedapps
    group: example.com
    version: v1alpha1
    categories:
      - apps
    shortnames:
      - hosted1
      - ha1
```

### `spec.stages[]`

`spec.stages` break the work to be done by this supply chain into a serial collection of "stages", each with
a component.

This is where you define the operations of this SupplyChain.

### `spec.stages[].name`

Each stage has a `name`, which is shown to the user in the CLI and UI.
`name` can only be composed of hyphens(`-`) and lower case alphanumeric characters (`a-z0-9`).

### `spec.stages[].componentRef`

Each stage also has a `componentRef` with a single field `name`.
`componentRef.Name` refers to the name of a Tanzu Supply Chain [Component] resource.
The [Component] must exist in the same namespace as the SupplyChain. This will change, see [Known Issue: Workload Creation](../../known-issues.hbs.md#workload-creation).

The supply chain returns an error if a component expects an input that has not been output by a previous stage.

#### Example

```yaml
apiVersion: supply-chain.apps.tanzu.vmware.com/v1alpha1
kind: SupplyChain
spec:
  stages:
    - name: fetch-source
      componentRef:
        name: source-git-provider-1.0.0
    - name: build
      componentRef:
        name: golang-builder-1.0.0
    - name: commit
      componentRef:
        name: commit-writer-1.0.0
```

## Status

### `status.conditions[]`

Every `status.conditions[]` in Tanzu Supply Chain resources follows a [strict set of conventions](./statuses.hbs.md)

The top-level condition type is `Ready` as SupplyChain is a "living" resource.

The sub-types are:

#### RBACDefined

| Reason        | Meaning                                                                                                                                                  |
|---------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|
| Ready         | The RoleBindings for the kind declared in [`spec.defines`](#specdefines) was created on cluster                                                          |
| AlreadyExists | The RoleBinding record already exists.</br>Most common cause of this issue is another Supply Chain with the same [`spec.defines`](#specdefines) section. |
| UnknownError  | The RoleBinding record failed due to an exceptional error. Look at the reconciler logs and contact Tanzu Support                                         |

#### APIsDefined

| Reason        | Meaning                                                                                                                                                                         |
|---------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Ready         | The CRD for the kind declared in [`spec.defines`](#specdefines) was created on cluster                                                                                          |
| Conflict      | The CRD already exists and is managed by another SupplyChain.</br>Most common cause of this issue is another Supply Chain with the same [`spec.defines`](#specdefines) section. |
| Invalid       | The CRD is invalid</br>Most common cause of this is an illegal OpenAPIV3Schema in the [Component].                                                                              |
| Unknown error | The CRD could not be created due to an exceptional error. Look at the reconciler logs and contact Tanzu Support                                                                 |

#### StageMapping

| Reason                      | Meaning                                                                                                                                      |
|-----------------------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| Ready                       | The [stages](#specstages) pass all the [validation rules](../../platform-engineering/explanation/supply-chains.hbs.md#integrity-validation). |
| NoSuchComponent             | The referenced component cannot be found.                                                                                                    |
| NoSuchInput                 | The input to the stage is not emitted by any stage.                                                                                          |
| InputNotSatisfiedUntilLater | The input to the stage is not emitted by a previous stage.                                                                                   |
| InputMismatch               | The input matches a previous output by name, however the type does not match.                                                                |
| OutputRedefined             | The output redefines an existing output. Shadowing of outputs is not supported.                                                              |

<!--
[Workload]: workload.hbs.md
[WorkloadRun]: workloadrun.hbs.md
[Components]: component.hbs.md
[Component]: component.hbs.md
[Input]: component.hbs.md#inputs
[Output]: component.hbs.md#outputs
[Object Kind]: https://kubernetes.io/docs/concepts/overview/working-with-objects/ "Kubernetes documentation for Objects"
[CRD]: https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/ "Kubernetes Custom Resource documentation"
[CustomResourceDefinition]: https://kubernetes.io/docs/reference/kubernetes-api/extend-resources/custom-resource-definition-v1/ "Kuberneted Custom Resource Definition API specification"
[CustomResourceDefinitionSpec]: https://kubernetes.io/docs/reference/kubernetes-api/extend-resources/custom-resource-definition-v1/#CustomResourceDefinitionSpec "Kuberneted CRD Spec API specification"
-->
# SupplyChain API

{{> 'partials/supply-chain/beta-banner' }}

The supply chain defines the [Object Kind] of the [Workload], the [Components] used, and their order.

<!-- Not Implemented: Also any overriding configuration that the platform engineer wishes to control. -->

```yaml
apiVersion: supply-chain.tanzu.vmware.com/v1alpha1
kind: SupplyChain
metadata:
  name: hostedapps.widget.com-0.0.1
spec:
  description: # describe the purpose of this supply chain.
  defines: # Describes the workload
    kind: HostedApp
    pluralName: hostedapps
    group: widget.com
    version: v1alpha1
  stages: # Describes the stages
    - name: source-provider
      componentRef: # References the components
        name: source-1.0.0
    - name: builder-dev
      componentRef: # References the components
        name: go-build-1.0.0
```

## `metadata.name`

The name of the SupplyChain in the form:

`<plural-name>.<group>-<Major>.<minor>.<patch>`
 
* `plural-name` must match the plural form of `defines.kind`, without the version.
  For example: `kind: JavaServerAppV3` would have a `plural-name` of `javaserverapps`
* `group` must mach `defines.group` (see [`spec.defines.group`](#specdefines) below )
* `<Major>.<minor>.<patch>` is the version definition.

### Supply Chains cannot change an API once it is on-cluster

The version of your SupplyChain, as embedded in the name, must follow the following rules.

A patch bump is required to update the supply chain without an API change.
The controller will ensure this rule cannot be broken when comparing supply chains on cluster.

For example, imagine you apply to a cluster:

* a SupplyChain with the name `serverapps.example.com-1.0.0` with kind `ServerAppsV1`
* a SupplyChain with the name `serverapps.example.com-1.0.1` with kind `ServerAppsV1`

If the generated API for the kind is unchanged, then the higher version is accepted.
If there is a change, the first applied supply chain wins, and the others reflect the error in their status.
This ensures that **you can't accidentally break the running kind API**.

These rules ensure that potentially thousands of Workloads and Runs on the cluster do not suddenly break.

**Recommended** version guidelines:

* If the API and general behavior is unchanged by a change to the [`spec.stages`](#specstages):
  * Use a patch bump such as `1.2.5` to `1.2.6`
  * Keep the same kind, such as `ServerAppV1`
* If the API is unchanged, but something significantly different occurs because of changes to the [`spec.stages`](#specstages), consider:
  * a bump to the minor or major version, such as `1.2.5` to `1.3.0`
  * a bump to the kind, such as `ServerAppV2`
  * or a change of kind, such as `ServerAppWithApprovalV1`
* If the API changes:
  * a bump to the minor or major version, such as `1.2.5` to `1.3.0`
  * a bump to the kind, such as `ServerAppV2`

This ensures cleat communication to your users. New kind versions typically indicate that the user 
needs to migrate their resources to the new API.


## `spec.description`

The `spec.description` field is visible to an app developer when they use the CLI to discover available workload kinds:

```
tanzu workload kind list --wide

KIND                      VERSION     AGE   DESCRIPTION
serverappv2.example.com   v1alpha1    12m   Server application supply chain   
```
**Recommendation** embed complete documentation in the description.

The description field supports multi-line Plain text or Markdown. 

If you plan to use markdown, ensure your first line is a top level heading, for example:
```shell
# Server application supply chain
```
The CLI summary only shows the first line, and for markdown, it will remove the leading `# `



## `spec.defines`
The `spec.defines` object defines the Workload [CustomResourceDefinition].

### `spec.defines.group`
`group` (**required**) is used to fill in the `group` field in the [CustomResourceDefinitionSpec].

`group` is the classic domain-formatted group of any kubernetes object.
We recommend using, at least, your organization's top level domain, or a departmental domain.

Eg:

* `vmware.com`
* `supply-chains.vmware.com`

### `spec.defines.kind`
`kind` (**required**) is the name of the resource in CamelCase.

### `spec.defines.plural`
`plural` (**required**) is typically the plural down-cased form of the kind. 
It must be all lowercase.

**Note:** Supply chain requires this field to avoid the creation of strange natural language interpretations of the kind.
For example, some natural language libraries pluralize "Demo" to "Demoes".

**Recommendation:** pluralize the name before the version, e.g: `WebAppV1` becomes `webappsv1`, not `webappv1s`

### `spec.defines.singular`
`singular` defaults to the lowercase of `kind`, for example `ServerAppv1` becomes `serverappv1`

### `spec.defines.shortnames`
`shortnames` is a list and defaults to empty.
Use this to specify an array of aliases for your kind. 
These are great to simplify `kubectl` commands.

For example:
```
kind: ServerAppV1
plural: serverappsv1
shortnames:
  - serverapp1
  - sa1
```

### `spec.defines.categories` 
`categories` is a list and defaults to empty.
`categories` specify a collection term for a group of kinds, so that `kubectl get <category>` returns instances of all kinds in the category.

For example, imagine 2 SupplyChains:
```
kind: ServerAppV1
plural: serverappsv1
categories:
  - apps
```

and

```
kind: WebAppV1
plural: webappsv1
categories:
  - apps
```

Using `kubectl get apps` will list instances of both kinds.

## `spec.stages`

Each SupplyChain resource has a section for stages found at `spec.stages`

This is where you define the operations of this SupplyChain.

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

Each stage has a `name`, which is shown to the user in the CLI and UI.
`name` can only be composed of hyphens(`-`) and lower case alphanumeric characters (`a-z0-9`).

Each stage also has a `componentRef` with a single field `name`.
`componentRef.Name` refers to the name of a Tanzu Supply Chain [Component] resource.
The [Component] **must** exist in the same namespace as the SupplyChain.

The supply chain will return an error if a component expects an [input] that has not been [output] by a previous stage.

## Integrity validation of SupplyChains

A SupplyChain is **not valid** if:

* A required field is missing
* The [Components] referenced are not in the same namespace
* The [Components] referenced contain inputs that are not satisfied by their position in the [`spec.stages`](#specstages)
* The name does not match the [`spec.defines`](#specdefines) section
* The SupplyChain breaks the [versioning rules](#supply-chains-cannot-change-an-api-once-it-is-on-cluster).
    
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
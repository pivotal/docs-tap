# Workload

{{> 'partials/supply-chain/beta-banner' }}

Workloads are [Custom Kubernetes Resources (CRDs)][CRD] created by [SupplyChains]. 
They are also one of the two [Duck Typed Resources] in Tanzu Supply chain

## Static CustomResourceDefinitions API

All Workloads are defined as CustomResourceDefinitions:

```yaml
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
```

### `metadata.labels`

Workload CRDs always have the following labels. 
The `chain-name` and `chain-namespace` labels reference the location of the [SupplyChain]  resource that created this Workload.
The `chain-role` identifies this as a Workload. The other possible value is `workload-run`.

```yaml
metadata:
  labels:
    supply-chain.apps.tanzu.vmware.com/chain-name: apps.example.com-1.0.0
    supply-chain.apps.tanzu.vmware.com/chain-namespace: app-sc
    supply-chain.apps.tanzu.vmware.com/chain-role: workload
```

### `metadata.name`

The name of the resource is always in the form `<plural>.<group>` from the [Supply Chain Defines API](./supplychain.hbs.md#specdefines)

#### Example

```yaml
metadata:
  name: appv1s.widget.com
```

### `spec.group`, `spec.names` and `spec.versions`

The CRD's `group`, `names` and `versions` is filled in with the details found in the [Supply Chain Defines API](./supplychain.hbs.md#specdefines).

Additionally, the `spec.names[].categories[]` array includes a category of `all-workloads`. This ensures that
commands such as `kubectl get all-workloads` will find all the [SupplyChain] defined Workloads a user can access.   

#### Example
```yaml
spec:
  conversion:
    strategy: None
  group: example.com
  names:
    categories:
      - all-workloads
    kind: AppV1
    listKind: AppV1List
    plural: appv1s
    singular: appv1
  scope: Namespaced
  versions:
      name: v1alpha1
      schema:
        openAPIV3Schema:
          ...
```

## Static Workload API

### `metadata.labels`

Workloads always have the following labels. These labels reference the location of the [SupplyChain] resource on cluster.

```yaml
metadata:
  labels:
    supply-chain.apps.tanzu.vmware.com/chain-name: apps.example.com-1.0.0
    supply-chain.apps.tanzu.vmware.com/chain-namespace: app-sc
```
`## Dynamic Workload API`

### `spec`

The `spec` of a Workload is dynamic, however it is immutable once applied. 
The spec is derived by combining the [Component configurations](./component.hbs.md#specconfig) of all the [SupplyChain Stages](./supplychain.hbs.md#specstages)

[Duck Typed Resources]: ./duck-types.hbs.md
[SupplyChain]: ./supplychain.hbs.md
[SupplyChains]: supplychain.hbs.md
[Workload]: ./workload.hbs.md
[Component]: component.hbs.md
[Components]: component.hbs.md
[WorkloadRun]: workloadrun.hbs.md
[CRD]: https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/ "Kubernetes Custom Resource documentation"
[Kind]: https://kubernetes.io/docs/concepts/overview/working-with-objects/ "Kebernetes documentation for Objects"

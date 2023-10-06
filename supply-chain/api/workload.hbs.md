# Workload CRD

Workloads are custom Kubernetes resources (CRDs). Tanzu Supply Chain does not provide specific Workload CRDs, instead a
platform engineer declares a [**SupplyChain**](supplychain.hbs.md) including the Kind of CRD to use as it's workload (eg
SpringOneAppWorkload). The [**Components**](./component.hbs.md) used in the [**SupplyChain**](./supplychain.hbs.md) define the schema (
shape) of the Workload CRD.

See [**SupplyChain**](./supplychain.hbs.md)'s `defines` field.

Once the SupplyChain is applied to the cluster, and is valid, then the `defined` CRD is created on the cluster. It can
be inspected:

```
$ kubectl get crd hostedapps.widget.com -oyaml # hostedapp is only an example
```

```yaml
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  creationTimestamp: "2023-08-16T18:45:44Z"
  generation: 1
  labels:
    supply-chain.tanzu.vmware.com/chain-name: hostedapps.widget.com-0.0.1
    supply-chain.tanzu.vmware.com/chain-namespace: default
  name: hostedapps.widget.com
  resourceVersion: "709886"
  uid: 880a287f-7aa9-4ffe-a463-e8625c92bdc8
spec:
  conversion:
    strategy: None
  group: widget.com
  names:
    kind: HostedApp
    listKind: HostedAppList
    plural: hostedapps
    singular: hostedapp
  scope: Namespaced
  versions:
    - name: v1alpha1
      schema:
        openAPIV3Schema:
          properties:
            spec:
              properties:
                source:
                  properties:
                    git:
                      description: |
                        Fill this object in if you want your source to come from 
                        git. The tag, commit and branch fields are mutually 
                        exclusive, use only one.
  ... etc ...
```

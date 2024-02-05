# Workload CRD

**Workloads** are [Custom Kubernetes Resources (CRDs)][CRD]. 

[**SupplyChains**] define the Workload CRD by 
* specifying the [Kind] (see [**SupplyChain**]'s `defines` field) 
* specifying the [**Components**] that constitute the Supply Chain. 

The [**Components**] used in the [**SupplyChain**] define the schema of the Workload CRD.

Once a valid SupplyChain is applied to the cluster, then the `defined` CRD is created on the cluster.

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


[**SupplyChain**]: supplychain.hbs.md
[**SupplyChains**]: supplychain.hbs.md
[**Workload**]: ./workload.hbs.md
[**Component**]: component.hbs.md
[**Components**]: component.hbs.md
[**WorkloadRun**]: workloadrun.hbs.md
[CRD]: https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/ "Kubernetes Custom Resource documentation"
[Kind]: https://kubernetes.io/docs/concepts/overview/working-with-objects/ "Kebernetes documentation for Objects"

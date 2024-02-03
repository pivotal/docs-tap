# SupplyChain API

A SupplyChain pulls together components to define the path to production for a [**Components**]. 

The supply chain defines the [Object Kind] of the [**Workload**], the [**Components**] used and their order, and any overriding
configuration that the platform engineer wishes to control.

```yaml
apiVersion: supply-chain.tanzu.vmware.com/v1alpha1
kind: SupplyChain
metadata:
  name: hostedapps.widget.com-0.0.1
spec:
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

## `defines`
This section describes the Workload [CRD] to generate.

## `stages`
Stages define the steps of the supply chain.

Each stage has a 
  * `name`: describes the purpose of the stage and identifies the work within the [**WorkloadRun**]
    * Should be less than 32 Characters long
    * Must contain only lowercase letters, numbers and `-` [a-z0-9\\-]
  * `componentRef`: references the [**Component**] resource _within the same namespace_ that is used to execute this stage.
    * `name`: the name of the [**Component**].
      * Must contain only lowercase letters, numbers, `-` and `.` [a-z0-9\\-.]
      * Must define a simple `-major.minor.patch` suffix, eg: `my-component-1.0.1`
    
[**Workload**]: ./workload.hbs.md
[**WorkloadRun**]: ./workloadrun.hbs.md
[**Components**]: ./component.hbs.md
[**Component**]: ./component.hbs.md
[Object Kind]: https://kubernetes.io/docs/concepts/overview/working-with-objects/ "Kebernetes documentation for Objects"
[CRD]: https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/ "Kubernetes Custom Resource documentation"

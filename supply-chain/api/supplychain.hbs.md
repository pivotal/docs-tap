# SupplyChain API

A SupplyChain pulls together components to define the path to production for a [**Components**](./component.hbs.md). The
supply chain defines the Kind of the Workload, the [**Workloads**](#Workloads) and their order, and any overriding
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

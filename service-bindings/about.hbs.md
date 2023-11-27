# Overview of Service Bindings

This topic tells you about using Service Bindings in Tanzu Application Platform (commonly know as TAP).

## Supported service binding specifications

Service Bindings packages the [Service Binding for Kubernetes](https://servicebinding.io/) open
source project.

It implements the [Service Binding Specification for Kubernetes v1.0](https://servicebinding.io/spec/core/1.0.0/).

This implementation provides support for:

- [Provisioned Service](https://github.com/k8s-service-bindings/spec/tree/12a9f2e376c50f051cc9aa913443bdecb0a24a01#provisioned-service)
- [Workload Projection](https://github.com/k8s-service-bindings/spec/tree/12a9f2e376c50f051cc9aa913443bdecb0a24a01#workload-projection)
- [Service Binding](https://github.com/k8s-service-bindings/spec/tree/12a9f2e376c50f051cc9aa913443bdecb0a24a01#service-binding)
- [Direct Secret Reference](https://github.com/k8s-service-bindings/spec/tree/12a9f2e376c50f051cc9aa913443bdecb0a24a01#direct-secret-reference)
- [Role-Based Access Control (RBAC)](https://github.com/k8s-service-bindings/spec/tree/12a9f2e376c50f051cc9aa913443bdecb0a24a01#role-based-access-control-rbac)

The following are not supported:

- [Workload Resource Mapping](https://github.com/k8s-service-bindings/spec/tree/12a9f2e376c50f051cc9aa913443bdecb0a24a01#workload-resource-mapping)
- Extensions including:
  - [Binding Secret Generation Strategies](https://github.com/k8s-service-bindings/spec/tree/12a9f2e376c50f051cc9aa913443bdecb0a24a01#binding-secret-generation-strategies)

## Known Issue

`ServiceBinding` is not immediately reconciled when `status.binding.name` changes on a previously
bound service resource. This impacts the timely rollout of new connection secrets to workloads. The reconciler eventually picks up the change but this might take up to 10 hours.
As a temporary workaround, you can do one of the following:

- Delete the existing `ServiceBinding` and create a new one that is identical.
- Trigger reconciliation of the existing `ServiceBinding` by adding an arbitrary annotation or label.
- Delete and recreate the application workload referred to by the `ServiceBinding`.

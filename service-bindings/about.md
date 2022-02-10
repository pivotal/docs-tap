# Service Bindings for Kubernetes

Service Bindings for Kubernetes implements the
[Service Binding Specification for Kubernetes](https://github.com/k8s-service-bindings/spec). VMware is
tracking changes to the specifications as it approaches a stable release, currently targeting
[pre-RC3](https://github.com/k8s-service-bindings/spec/tree/12a9f2e376c50f051cc9aa913443bdecb0a24a01) in
GitHub. Backwards and forwards compatibility should not be expected for alpha versioned resources.

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

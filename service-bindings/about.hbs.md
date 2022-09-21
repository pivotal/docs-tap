# Service Bindings for Kubernetes

Service Bindings for Kubernetes implements the
[Service Binding Specification for Kubernetes](https://github.com/k8s-service-bindings/spec). VMware is
tracking changes to the specifications as it approaches a stable release, currently targeting
[pre-RC3](https://github.com/k8s-service-bindings/spec/tree/12a9f2e376c50f051cc9aa913443bdecb0a24a01) in
GitHub. Backwards and forwards compatibility are not be expected for alpha versioned resources.

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

## How to use Service Bindings

Service Bindings is open source and very amourophus in how it works. For these reasons there is no
quick explination on how to use Service Binding. However there are many resouces that are
available to assist in the understanding of the many ways that Service Bindings can be used. See [Service Binding Specification for Kubernetes](https://github.com/servicebinding/spec)
to understand the specifications that Service Bindings uses for Kubernetes and a comunity section
to understand it's use. For a full indebth dive of Service Binder see
[Servicebindings.io](https://servicebinding.io/) which is the offical open source page for Service
Bindings that have the most detailed up to date information about how to use Service Bindings and any upcoming new features.
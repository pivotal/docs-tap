# Service Bindings for Kubernetes

Service Bindings for Kubernetes implements the [Service Binding Specification for Kubernetes](https://github.com/k8s-service-bindings/spec). We are tracking changes to the spec as it approaches a stable release (currently targeting [pre-RC3](https://github.com/k8s-service-bindings/spec/tree/12a9f2e376c50f051cc9aa913443bdecb0a24a01)). Backwards and forwards compatibility should not be expected for alpha versioned resources.

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

## Collecting logs from service binding manager

If you have trouble, you can retrieve and examine the logs from the service binding manager to help identify issues.

To retrieve pod logs from the `manager` running in the `service-bindings` namespace:

  ```bash
  kubectl -n service-bindings logs -l role=manager
  ```

For example:

   ```bash
    2021/11/05 15:25:28 Registering 3 clients
    2021/11/05 15:25:28 Registering 3 informer factories
    2021/11/05 15:25:28 Registering 7 informers
    2021/11/05 15:25:28 Registering 8 controllers
    {"severity":"INFO","timestamp":"2021-11-05T15:25:28.483823208Z","caller":"logging/config.go:116","message":"Successfully created the logger."}
    {"severity":"INFO","timestamp":"2021-11-05T15:25:28.48392361Z","caller":"logging/config.go:117","message":"Logging level set to: info"}
    {"severity":"INFO","timestamp":"2021-11-05T15:25:28.483999911Z","caller":"logging/config.go:79","message":"Fetch GitHub commit ID from kodata failed","error":"open /var/run/ko/HEAD: no such file or directory"}
    {"severity":"INFO","timestamp":"2021-11-05T15:25:28.484035711Z","logger":"webhook","caller":"profiling/server.go:64","message":"Profiling enabled: false"}
    {"severity":"INFO","timestamp":"2021-11-05T15:25:28.522884909Z","logger":"webhook","caller":"leaderelection/context.go:46","message":"Running with Standard leader election"}
    {"severity":"INFO","timestamp":"2021-11-05T15:25:28.523358615Z","logger":"webhook","caller":"provisionedservice/controller.go:31","message":"Setting up event handlers."}
    ...
    {"severity":"ERROR","timestamp":"2021-11-17T12:30:24.557178813Z","logger":"webhook","caller":"controller/controller.go:548","message":"Reconcile error","duration":"276.504µs","error":"deployments.apps \"spring-petclinic\" not found","stacktrace":"knative.dev/pkg/controller.(*Impl).handleErr\n\tknative.dev/pkg@v0.0.0-20210331065221-952fdd90dbb0/controller/controller.go:548\nknative.dev/pkg/controller.(*Impl).processNextWorkItem\n\tknative.dev/pkg@v0.0.0-20210331065221-952fdd90dbb0/controller/controller.go:531\nknative.dev/pkg/controller.(*Impl).RunContext.func3\n\tknative.dev/pkg@v0.0.0-20210331065221-952fdd90dbb0/controller/controller.go:468"}
    {"severity":"ERROR","timestamp":"2021-11-17T12:47:04.558217679Z","logger":"webhook","caller":"controller/controller.go:548","message":"Reconcile error","duration":"249.103µs","error":"deployments.apps \"spring-petclinic\" not found","stacktrace":"knative.dev/pkg/controller.(*Impl).handleErr\n\tknative.dev/pkg@v0.0.0-20210331065221-952fdd90dbb0/controller/controller.go:548\nknative.dev/pkg/controller.(*Impl).processNextWorkItem\n\tknative.dev/pkg@v0.0.0-20210331065221-952fdd90dbb0/controller/controller.go:531\nknative.dev/pkg/controller.(*Impl).RunContext.func3\n\tknative.dev/pkg@v0.0.0-20210331065221-952fdd90dbb0/controller/controller.go:468"}
    {"severity":"ERROR","timestamp":"2021-11-17T13:03:44.558683121Z","logger":"webhook","caller":"controller/controller.go:548","message":"Reconcile error","duration":"177.403µs","error":"deployments.apps \"spring-petclinic\" not found","stacktrace":"knative.dev/pkg/controller.(*Impl).handleErr\n\tknative.dev/pkg@v0.0.0-20210331065221-952fdd90dbb0/controller/controller.go:548\nknative.dev/pkg/controller.(*Impl).processNextWorkItem\n\tknative.dev/pkg@v0.0.0-20210331065221-952fdd90dbb0/controller/controller.go:531\nknative.dev/pkg/controller.(*Impl).RunContext.func3\n\tknative.dev/pkg@v0.0.0-20210331065221-952fdd90dbb0/controller/controller.go:468"}
    {"severity":"ERROR","timestamp":"2021-11-17T13:20:24.559192644Z","logger":"webhook","caller":"controller/controller.go:548","message":"Reconcile error","duration":"223.203µs","error":"deployments.apps \"spring-petclinic\" not found","stacktrace":"knative.dev/pkg/controller.(*Impl).handleErr\n\tknative.dev/pkg@v0.0.0-20210331065221-952fdd90dbb0/controller/controller.go:548\nknative.dev/pkg/controller.(*Impl).processNextWorkItem\n\tknative.dev/pkg@v0.0.0-20210331065221-952fdd90dbb0/controller/controller.go:531\nknative.dev/pkg/controller.(*Impl).RunContext.func3\n\tknative.dev/pkg@v0.0.0-20210331065221-952fdd90dbb0/controller/controller.go:468"}
    {"severity":"ERROR","timestamp":"2021-11-17T13:37:04.559648412Z","logger":"webhook","caller":"controller/controller.go:548","message":"Reconcile error","duration":"173.003µs","error":"deployments.apps \"spring-petclinic\" not found","stacktrace":"knative.dev/pkg/controller.(*Impl).handleErr\n\tknative.dev/pkg@v0.0.0-20210331065221-952fdd90dbb0/controller/controller.go:548\nknative.dev/pkg/controller.(*Impl).processNextWorkItem\n\tknative.dev/pkg@v0.0.0-20210331065221-952fdd90dbb0/controller/controller.go:531\nknative.dev/pkg/controller.(*Impl).RunContext.func3\n\tknative.dev/pkg@v0.0.0-20210331065221-952fdd90dbb0/controller/controller.go:468"}
    {"severity":"ERROR","timestamp":"2021-11-17T13:53:44.56010516Z","logger":"webhook","caller":"controller/controller.go:548","message":"Reconcile error","duration":"182.402µs","error":"deployments.apps \"spring-petclinic\" not found","stacktrace":"knative.dev/pkg/controller.(*Impl).handleErr\n\tknative.dev/pkg@v0.0.0-20210331065221-952fdd90dbb0/controller/controller.go:548\nknative.dev/pkg/controller.(*Impl).processNextWorkItem\n\tknative.dev/pkg@v0.0.0-20210331065221-952fdd90dbb0/controller/controller.go:531\nknative.dev/pkg/controller.(*Impl).RunContext.func3\n\tknative.dev/pkg@v0.0.0-20210331065221-952fdd90dbb0/controller/controller.go:468"}
    {"severity":"ERROR","timestamp":"2021-11-17T14:10:24.560536033Z","logger":"webhook","caller":"controller/controller.go:548","message":"Reconcile error","duration":"155.603µs","error":"deployments.apps \"spring-petclinic\" not found","stacktrace":"knative.dev/pkg/controller.(*Impl).handleErr\n\tknative.dev/pkg@v0.0.0-20210331065221-952fdd90dbb0/controller/controller.go:548\nknative.dev/pkg/controller.(*Impl).processNextWorkItem\n\tknative.dev/pkg@v0.0.0-20210331065221-952fdd90dbb0/controller/controller.go:531\nknative.dev/pkg/controller.(*Impl).RunContext.func3\n\tknative.dev/pkg@v0.0.0-20210331065221-952fdd90dbb0/controller/controller.go:468"}
    {"severity":"ERROR","timestamp":"2021-11-17T14:27:04.560960243Z","logger":"webhook","caller":"controller/controller.go:548","message":"Reconcile error","duration":"171.002µs","error":"deployments.apps \"spring-petclinic\" not found","stacktrace":"knative.dev/pkg/controller.(*Impl).handleErr\n\tknative.dev/pkg@v0.0.0-20210331065221-952fdd90dbb0/controller/controller.go:548\nknative.dev/pkg/controller.(*Impl).processNextWorkItem\n\tknative.dev/pkg@v0.0.0-20210331065221-952fdd90dbb0/controller/controller.go:531\nknative.dev/pkg/controller.(*Impl).RunContext.func3\n\tknative.dev/pkg@v0.0.0-20210331065221-952fdd90dbb0/controller/controller.go:468"}
    {"severity":"ERROR","timestamp":"2021-11-17T14:43:44.56142548Z","logger":"webhook","caller":"controller/controller.go:548","message":"Reconcile error","duration":"179.203µs","error":"deployments.apps \"spring-petclinic\" not found","stacktrace":"knative.dev/pkg/controller.(*Impl).handleErr\n\tknative.dev/pkg@v0.0.0-20210331065221-952fdd90dbb0/controller/controller.go:548\nknative.dev/pkg/controller.(*Impl).processNextWorkItem\n\tknative.dev/pkg@v0.0.0-20210331065221-952fdd90dbb0/controller/controller.go:531\nknative.dev/pkg/controller.(*Impl).RunContext.func3\n\tknative.dev/pkg@v0.0.0-20210331065221-952fdd90dbb0/controller/controller.go:468"}
    {"severity":"ERROR","timestamp":"2021-11-17T15:00:24.561881861Z","logger":"webhook","caller":"controller/controller.go:548","message":"Reconcile error","duration":"167.902µs","error":"deployments.apps \"spring-petclinic\" not found","stacktrace":"knative.dev/pkg/controller.(*Impl).handleErr\n\tknative.dev/pkg@v0.0.0-20210331065221-952fdd90dbb0/controller/controller.go:548\nknative.dev/pkg/controller.(*Impl).processNextWorkItem\n\tknative.dev/pkg@v0.0.0-20210331065221-952fdd90dbb0/controller/controller.go:531\nknative.dev/pkg/controller.(*Impl).RunContext.func3\n\tknative.dev/pkg@v0.0.0-20210331065221-952fdd90dbb0/controller/controller.go:468"}
   ```

## Resources

### ServiceBinding (servicebinding.io/v1alpha3)

The `ServiceBinding` resource shape and behavior is defined by the spec.

```
apiVersion: servicebinding.io/v1alpha3
kind: ServiceBinding
metadata:
  name: account-db
spec:
  service:
    apiVersion: bindings.labs.vmware.com/v1alpha1
    kind: ProvisionedService
    name: account-db
  workload:
    apiVersion: apps/v1
    kind: Deployment
    name: account-service
```

### ProvisionedService (bindings.labs.vmware.com/v1alpha1)

The `ProvisionedService` exposes a resource `Secret` by implementing the upstream [Provisioned Service duck type](https://github.com/k8s-service-bindings/spec#provisioned-service), and may be the target of the `.spec.service` reference for a `ServiceBinding`. It is intended for compatibility with existing services that do not directly implement the duck type.

For example, to expose a service with an existing `Secret` named `account-db-service`:

```
apiVersion: bindings.labs.vmware.com/v1alpha1
kind: ProvisionedService
metadata:
  name: account-db
spec:
  binding:
    name: account-db-service

---
apiVersion: v1
kind: Secret
metadata:
  name: account-db-service
type: Opaque
stringData:
  type: mysql
  # use appropriate values
  host: localhost
  database: default
  password: ""
  port: "3306"
  username: root
```

The controller writes the resource's status to implement the duck type.

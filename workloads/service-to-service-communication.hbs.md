# Service-to-Service Communication

This topic explores service-to-service communication within a cluster, providing insights into how workloads
interact with each other.

## <a id="communication"></a> Calling `web` workloads within a cluster

When a  `web` workload type is created, a Knative service is deployed to the cluster.
To access your application, you need the URL for the route created by the Knative Service.
Obtain it by running one of these commands:

```console
tanzu apps workload get WORKLOAD-NAME --namespace DEVELOPER-NAMESPACE
kubectl get ksvc WORKLOAD-NAME -n YOUR-DEVELOPER-NAMESPACE -ojsonpath="{status.address.url}"
```

> **Note** When calling a Knative service, both the Service name and namespace are required.
This behavior is distinct from `server` type workloads, which do not rely on the namespace name to
establish service-to-service communication between applications within the same namespace.

## Example of service-to-service communication for `web` and `server` workloads

You have three applications deployed to the namespace called `dev-namespace`:

1. A `server` type workload named `server-workload`
2. A `web` type workload named `web-workload`
3. A pod running the busybox image with `curl`, named `busybox`

Open a shell to the running container of the `busybox` pod and send requests to the `server` and `web`
workloads using curl. Specify the namespace for both, as follows:

```console
kubectl exec busybox -n dev-namespace -- curl server-workload.dev-namespace.svc.cluster.local -v
kubectl exec busybox -n dev-namespace -- curl web-workload.dev-namespace.svc.cluster.local -v
```

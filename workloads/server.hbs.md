# Using Server workloads

This topic describes how to use the `server` workload type.

## <a id="overview"></a>Overview

The `server` workload type allows you to deploy traditional network applications on
Tanzu Application Platform.
Using an application workload specification, you can build and deploy application
source code to a manually-scaled Kubernetes deployment which exposes an in-cluster Service endpoint.
If required, you can use environment-specific LoadBalancer Services or Ingress resources to
expose these applications outside the cluster.

The `server` workload is a good match for traditional applications, including HTTP applications,
which have the following implementation:

* Store state locally
* Run background tasks outside of requests
* Provide multiple network ports or non-HTTP protocols
* Are not a good match for the `web` workload type

An application using the `server` workload type has the following features:

* Does not natively autoscale, but you can use these applications with the Kubernetes Horizontal Pod Autoscaler.
* By default, is exposed only within the cluster using a `ClusterIP` service
* Uses health checks if defined by a convention
* Uses a rolling update pattern by default

When creating a workload with `tanzu apps workload create`, you can use the
`--type=server` argument to select the `server` workload type.
For more information, see [Use the server Workload Type](#using) later in this topic.
You can also use the `apps.tanzu.vmware.com/workload-type:server` annotation in the
YAML workload description to support this deployment type.

## <a id="using"></a> Use the `server` workload type

The `spring-sensors-consumer-web` workload in the getting started example
[using Service Toolkit claims](../getting-started/consume-services.md#stk-bind)
is a good match for the `server` workload type.
This is because it runs continuously to extract information from a RabbitMQ queue,
and stores the resulting data locally in-memory and presents it through a web UI.

If you have followed the Services Toolkit example, you can update the `spring-sensors-consumer-web`
to use the `server` supply chain by changing the workload type by running:

```console
tanzu apps workload update spring-sensors-consumer-web --type=server
```

This shows the change in the workload label, and prompts you to accept the change.
After the workload completes the new deployment, there are a few differences:

- The workload no longer advertises a URL. It's available within the cluster as
`spring-sensors-consumer-web` within the namespace, but you must use
`kubectl port-forward service/spring-sensors-consumer-web 8080` to access the web service on port 8080.

    You can also set up a Kubernetes ingress rule to direct traffic from outside the cluster to the workload.
    Using an ingress rule, you can specify that specific host names or paths must be routed to the application.
    For more information about ingress rules, see the [Kubernetes documentation](https://kubernetes.io/docs/concepts/services-networking/ingress/)

- The workload no longer autoscales based on request traffic.
For the `spring-sensors-consumer-web` workload, this means that it never spawns
a second instance that consumes part of the request queue.
Also, it does not scale down to zero instances.

## <a id="params"></a> `server`-specific workload parameters

In addition to the common supply chain parameters, `server` workloads can expose one or more network
ports from the application to the Kubernetes cluster by using the `ports` parameter.
This parameter is a list of port objects, similar to a Kubernetes service specification.
If you do not configure the `ports` parameter, the applied container conventions in the cluster
establishes the set of exposed ports.

The following configuration exposes two ports on the Kubernetes cluster under the `my-app` host name:

```yaml
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  name: my-app
  labels:
    apps.tanzu.vmware.com/workload-type: server
spec:
  params:
  - name: ports
    value:
    - containerPort: 2025
      name: smtp
      port: 25
    - port: 8080
  ...
```

This snippet configures:

- One service on port 25, which is redirected to port 2025 on the application.
- One service on port 8080, which is routed to port 8080 on the application.

You can set the `ports` parameter from the `tanzu apps workload create` command line as `--param-yaml 'ports=[{"port": 8080}]'`.

The following values are valid within the `ports` argument:

| field | value |
|-------|-------|
| `port` | The port on which the application is exposed to the rest of the cluster |
| `containerPort` | The port on which the application listens for requests. Defaults to `port` if not set. |
| `name` | A human-readable name for the port. Defaults to `port` if not set. |

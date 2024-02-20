# Use server workloads

This topic tells you how to use the `server` workload type in Tanzu Application Platform
(commonly known as TAP).

## <a id="overview"></a> Overview

The `server` workload type allows you to deploy traditional network applications on
Tanzu Application Platform.

Using an application workload specification, you can build and deploy application source code to a
manually-scaled Kubernetes deployment which exposes an in-cluster Service endpoint. If required, you
can use environment-specific LoadBalancer Services or Ingress resources to expose these applications
outside the cluster.

The `server` workload is suitable for traditional applications, including HTTP applications,
which have the following characteristics:

- Store state locally
- Run background tasks outside of requests
- Provide multiple network ports or non-HTTP protocols
- Are not a good match for the `web` workload type

An application using the `server` workload type has the following features:

- Does not natively autoscale, but you can use these applications with the Kubernetes Horizontal Pod
  Autoscaler.
- By default, is exposed only within the cluster using a `ClusterIP` service.
- Uses health checks if defined by a convention.
- Uses a rolling update pattern by default.

When creating a workload with the `tanzu apps workload create` command, you can use the
`--type=server` argument to select the `server` workload type.
For more information, see [Use the server Workload Type](#using) later in this topic.
You can also use the `apps.tanzu.vmware.com/workload-type:server` annotation in the
YAML workload description to support this deployment type.

## <a id="using"></a> Use the `server` workload type

The `spring-sensors-consumer-web` workload in
[Bind an application workload to the service instance](../getting-started/consume-services.hbs.md#stk-bind)
in the Get started guide is a good match for the `server` workload type.

This is because it runs continuously to extract information from a RabbitMQ queue, and stores the
resulting data locally in memory and presents it through a web UI.

In the Services Toolkit example in
[Bind an application workload to the service instance](../getting-started/consume-services.hbs.md#stk-bind),
you can update the `spring-sensors-consumer-web` workload to use the `server` supply chain by
changing the workload:

```console
tanzu apps workload apply spring-sensors-consumer-web --type=server
```

This shows the change in the workload label and prompts you to accept the change.
After the workload finishes the new deployment, there are a few differences:

- The workload no longer exposes a URL. It's available within the cluster as
  `spring-sensors-consumer-web` within the namespace, but you must use
  `kubectl port-forward service/spring-sensors-consumer-web 8080` to access the web service on port
  8080.

  You can set up a Kubernetes Ingress rule to direct traffic from outside the cluster to the workload.
  Use an Ingress rule to specify that specific host names or paths must be routed to the application.
  For more information about Ingress rules, see the
  [Kubernetes documentation](https://kubernetes.io/docs/concepts/services-networking/ingress/)

- The workload no longer autoscales based on request traffic. For the `spring-sensors-consumer-web`
  workload, this means that it never spawns a second instance that consumes part of the request
  queue. Also, it does not scale down to zero instances.

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

- One service on port 25, which is redirected to port 2025 on the application
- One service on port 8080, which is routed to port 8080 on the application

You can set the `ports` parameter from the `tanzu apps workload create` command as
`--param-yaml 'ports=[{"port": 8080}]'`.

The following values are valid within the `ports` argument:

| Field           | Value                                                                                  |
|-----------------|----------------------------------------------------------------------------------------|
| `port`          | The port on which the application is exposed to the rest of the cluster                |
| `containerPort` | The port on which the application listens for requests. Defaults to `port` if not set. |
| `name`          | A human-readable name for the port. Defaults to `port` if not set.                     |

## <a id="exposing-server-workloads"></a> Expose `server` workloads outside the cluster

You have several options for exposing `server` workloads outside the cluster:

- [Expose server workloads outside the cluster automatically](expose-server-workloads/auto.hbs.md)
- [Expose HTTP server workloads outside the cluster manually](expose-server-workloads/manually-config-http.hbs.md)
- [Define a workload type that exposes server workloads outside the cluster](expose-server-workloads/define-a-workload-type.hbs.md)
- [Expose workloads outside the cluster using AVI L4/L7](expose-server-workloads/expose-with-avi-l4-l7.hbs.md)

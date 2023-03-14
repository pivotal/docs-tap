# Using web workloads

This topic describes how to use the `web` workload type.

## <a id="overview"></a>Overview

The `web` workload type allows you to deploy web applications on Tanzu Application Platform.
Using an application workload specification, you can turn source code into a scalable, stateless
application that runs in a container with an automatically-assigned URL.
This type of application is often called "serverless", and is deployed using Knative.

The `web` workload is a good match for modern web applications that store state in external databases
and follow the [12-factor principles](https://12factor.net).

The `web` workload is a good match for 12-factor and modern stateless applications,
which have the following implementation:

* Perform all work through HTTP requests, including gRPC and WebSocket.
* Do not perform work except when processing a request.
* Start up quickly.
* Do not store state locally.

Applications using the `web` workload type have the following features:

* Automatic request-based scaling, including scale-to-zero.
* Automatic URL provisioning and optional certificate provisioning.
* Automatic health check definitions, if not provided by a convention.
* Blue-green application roll outs.

When creating a workload with `tanzu apps workload create`, you can use the
`--type=web` argument to select the `web` workload type.
For more information, see the [Use the web Workload Type](#using) later in this topic.
You can also use the `apps.tanzu.vmware.com/workload-type:web` label in the
YAML workload description to support this deployment type.

## <a id="using"></a> Use the `web` workload type

The `tanzu-java-web-app` workload [in the getting started example](../getting-started/deploy-first-app.md)
is a good match for the `web` workload type.
This is because it serves HTTP requests and does not perform any background processing.

If you have followed the getting started example, you've already deployed a `web` workload.
You can experiment with the differences between the `web` and [`server` workloads](./server.md)
by changing the workload type by running:

```console
tanzu apps workload update tanzu-java-web-app --type=server
```

After changing the workload type to `server`, the app will no longer autoscale and
no longer expose an external URL.
You can switch back to the `web` workload by running:

```console
tanzu apps workload update tanzu-java-web-app --type=web
```

You can use this to test which applications can function well as serverless web applications,
and which are more suited to the `server` application style.

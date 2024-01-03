# Use worker workloads

This topic tells you how to create and install a supply chain for the `worker` workload type in
Tanzu Application Platform (commonly known as TAP).

## <a id="overview"></a> Overview

The `worker` workload type allows you to deploy applications that run continuously without network
input on Tanzu Application Platform. Using an application workload specification, you can build and
deploy application source code to a manually scaled Kubernetes deployment with no network exposure.

The `worker` workload is a good match for applications that manage their own work by reading from a
worker or a background scheduled time source, and don't expose any network interfaces.

An application using the `worker` workload type has the following features:

- Does not natively auto-scale but you can use it with the Kubernetes Horizontal Pod Autoscaler
- Does not expose any network services
- Uses health checks if defined by a convention
- Uses a rolling update pattern by default

When creating a workload with `tanzu apps workload create`, you can use the `--type=worker` argument
to select the `worker` workload type. For more information, see the [Use the worker Workload Type](#using)
section. You can also use the `apps.tanzu.vmware.com/workload-type:worker` annotation in the YAML
workload description to support this deployment type.

## <a id="using"></a> Use the `worker` workload type

The `spring-sensors-producer` workload in the example in
[Consume services on Tanzu Application Platform](../getting-started/consume-services.hbs.md)
is a good match for the `worker` workload type.
This is because it runs continuously without a UI to report sensor information to a RabbitMQ topic.

If you followed the Services Toolkit example, you can update the `spring-sensors-producer`
to use the `worker` supply chain by changing the workload type. To do so, run:

```console
tanzu apps workload apply spring-sensors-producer --type=worker
```

This shows a difference in the workload label, and prompts you to accept the change. After the
workload finishes the new deployment, there are a few differences:

- The workload no longer has a URL. Because the workload does not present a web UI, this more
  closely matches the original application intent.

- The workload no longer auto-scales based on request traffic. For the `spring-sensors-producer`
  workload, this means that it does not scale down to zero instances when there is no request
  traffic.

# Configure Envoy for Contour

This topic tells you how to configure the Envoy for Contour in Tanzu 
Application Platform (commonly known as TAP) to eliminate upgrade downtime.

By default, Tanzu Application Platform v1.7 installs the Contour's Envoy pods as 
a `Deployment` with 2 replicas instead of a `DaemonSet`. 
If you switch from `DaemonSet` to `Deployment`, the Envoy pods must be deleted 
and recreated, which causes downtime during the Tanzu Application Platform v1.7 
upgrade.

When running as a `Deployment`, Contour includes affinity rules such that 
no Envoy pod runs on the same node as another Envoy pod. 
This mimics the `DaemonSet` behavior, without requiring a pod on every node. 
As a result, your cluster must have as many nodes as the desired replicas for 
an Envoy deployment.

To avoid the upgrade downtime for Tanzu Application Platform v1.7 and later, 
you can keep running Envoy as a `DaemonSet` by adding `contour.envoy.workload.type` 
to your values file and setting it to `DaemonSet` before performing the upgrade:

```yaml
contour:
  envoy:
    workload:
      type: DaemonSet
```

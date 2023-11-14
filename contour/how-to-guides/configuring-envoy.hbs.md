# Congigure the Envoy pods for Contour

This topic tells you how to configure the Envoy pods for Contour in Tanzu 
Application Platform (commonly known as TAP) to reduce upgrade downtime.

By default, Tanzu Application Platform v1.7 installs Contour's Envoy pods as a 
`Deployment` instead of a `DaemonSet`. It defaults to two replicas, which causes 
downtime when performing the upgrade.

You can choose either of the following methods to reduce upgrade downtime:

## <a id="daemonset"></a> Congigure the Envoy pods as a `DaemonSet`

When upgrading to Tanzu Application Platform v1.7, the Envoy pods are deleted 
and recreated. This causes downtime for all workloads exposed publicly, including 
all Web Workloads, Tanzu Application Platform GUI, and any Server workloads exposed 
manually through an HTTPProxy.

To install the Envoy pods as a `DaemonSet`, you must update your values file by 
adding `contour.envoy.workload.type` and setting it to `DaemonSet` before performing 
the upgrade:
  
```yaml
contour:
  envoy:
    workload:
      type: DaemonSet
```

## <a id="daemonset"></a> Congigure the Envoy pods as a `Deployment`

When running Envoy as a `Deployment`, the pods include anti-affinity rules 
so that they are not installed on the same node. The default value `2` means 
your cluster needs a minimum of two nodes for a successful install.

If you run a single node cluster, you must update your values file by adding `contour.envoy.workload.replicas` and setting it to `1` before performing the 
upgrade:
  
```yaml
contour:
  envoy:
    workload:
    type: Deployment
      replicas: 1
```

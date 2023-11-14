# Configuring Envoy for Contour

This topic tells you how to configure the Envoy for Contour in Tanzu 
Application Platform (commonly known as TAP) to reduce upgrade downtime.

By default, Tanzu Application Platform v1.7 installs Contour's Envoy pods as a 
`Deployment` with 2 replicas instead of a `DaemonSet`. If you switch from DaemonSet to Deployment, the Envoy pods must be deleted and recreated. As a result, **there will be downtime during the update**.

Without intervention, this will happen when upgrading to TAP v1.7.

Additionally, when running as a Deployment, Contour includes affinity rules such that no Envoy pod should run on the same node as another Envoy pod. This essentially mimics the DaemonSet behavior, without requiring a pod on every node. This also means that your cluster must have as many nodes as replicas are desired for an Envoy Deployment.

There are a couple options to avoid this downtime.

## <a id="daemonset"></a> Keep Running the Envoy Pods as a `DaemonSet`

The easiest way to avoid downtime is to keep running Envoy as a DaemonSet in TAP v1.7 and beyond.

To do this, you must update your values file by adding `contour.envoy.workload.type` and setting it to `DaemonSet` _before performing the upgrade_:
  
```yaml
contour:
  envoy:
    workload:
      type: DaemonSet
```

## <a id="daemonset"></a> Configure the Envoy pods as a `Deployment`

Currently, we do not have steps to make this switch without downtime. Look out for improvements in future versions!

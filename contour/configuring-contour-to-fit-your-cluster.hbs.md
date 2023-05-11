# Configure Contour

This topic tells you how to configure Contour to best suit your cluster.

By default, Contour installs with the Controllers as a `Deployment` and the Envoys 
as a `DaemonSet`. In most cases, this is sufficient. However, VMware recommends 
running Envoy as a `Deployment` in the following scenarios:

- [Smaller Clusters](#small-clusters)
- [Larger Clusters](#large-clusters)

## <a id="small-clusters"></a>Smaller Clusters

On most clusters, a `DaemonSet` works without any issues. However, if you limit resources per node and the nodes are heavily used, deploying Envoy as a `DaemonSet` might consume unnecessary resources on every node. In this case, VMware recommends using `Deployment` with a fixed number of replicas.

## <a id="large-clusters"></a>Larger Clusters

On larger clusters, running Envoy as a `DaemonSet` might be inefficient. The more Envoys in the cluster, the more resources the Contour controller needs to keep them updated. If the Contour controllers use lots of resources, VMware recommends running Envoy as a `Deployment`.

## <a id="configure-envoy"></a>Configuring Envoy as a Deployment

To configure Envoy as a `Deployment`, update your Contour values file as follows:

```yaml
envoy:
  workload:
    type: Deployment
    replicas: N
```

If you use a Tanzu Application Platform values file, you can add the these configurations to the `contour` section.

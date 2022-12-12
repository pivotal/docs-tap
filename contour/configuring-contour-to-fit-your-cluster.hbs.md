# Configuring Contour to Best Suit your Cluster

By default, Contour installs with the Controllers as a Deployment, and the Envoys as a DaemonSet. In most cases, this is sufficient. However, in certain scenarios you may need something different.

## Smaller Clusters
On most clusters, a DaemonSet will work just fine. However, if you limited on resources per node and find that the nodes are heavily utilized, deploying Envoy as a DaemonSet may be using unnecessary resources on every node. In this case, perhaps a Deployment with a fixed number of replicas may suit your needs.

## Larger Clusters
On larger clusters, running Envoy as a DaemonSet may also prove to be inefficient. The more Envoys in the cluster, the more resources the Contour controller will need to keep them updated. If you are noticing that the Contour controllers are using lots of resources, one option may be to run Envoy as a Deployment.

## Configuring Envoy as a Deployment

To configure Envoy as a Deployment, update your Contour values file like the following:

```yaml
envoy:
  workload:
    type: Deployment
    replicas: N
```

If you are using a TAP values file, simply add the above config to the `contour` section.

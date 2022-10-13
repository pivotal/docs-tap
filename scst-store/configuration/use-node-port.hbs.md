# Using NodePort

>**Note** The recommended service type is use of [Ingress](../ingress.hbs.md). NodePort is only recommended when the cluster does not support [Ingress](../ingress.hbs.md) or the cluster does not support [LoadBalancer](use-load-balancer.hbs.md) service type.  `NodePort` is not supported for a multi-cluster setup, as certificates cannot be modified.

Port forwarding is needed when using the `NodePort` configuration.

{{> 'partials/scst-store/port-forwarding' }}

## Configure the Insight plug-in

{{> 'partials/cli-plugins/insight-set-target' ingress=false }}
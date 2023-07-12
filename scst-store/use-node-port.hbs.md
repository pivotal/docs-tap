# Use your NodePort with Supply Chain Security Tools - Store

This topic describes how you can use your NodePort with Supply Chain Security Tools (SCST) - Store.

## Overview

>**Note** The recommended service type is [Ingress](ingress.hbs.md).
>NodePort is only recommended when the cluster does not support
>[Ingress](ingress.hbs.md) or the cluster does not support the
>[LoadBalancer](use-load-balancer.hbs.md) service type.  `NodePort` is not
>supported for a multicluster setup, as certificates cannot be modified.

You must use port forwarding when using the `NodePort` configuration.

{{> 'partials/scst-store/port-forwarding' }}

## Configure the Insight plug-in

{{> 'partials/cli-plugins/insight-set-target' ingress=false }}
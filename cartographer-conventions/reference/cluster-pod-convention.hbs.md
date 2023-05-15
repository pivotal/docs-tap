# ClusterPodConvention for Cartographer Conventions

This reference topic describes the `ClusterPodConvention` that you can use with Cartographer Conventions.

## Overview

A `ClusterPodConvention` defines how to connect to convention servers. It provides a way to apply a set of conventions to a [PodTemplateSpec](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-template-v1/#PodTemplateSpec) and artifact metadata. A convention typically focuses on a particular application framework, but might be cross cutting. Applied conventions must be pure functions.

## Define conventions

Webhook servers are the only way to define conventions.

```yaml
apiVersion: conventions.carto.run/v1alpha1
kind: ClusterPodConvention
metadata:
  name: base-convention
  annotations:
    conventions.carto.run/inject-ca-from: "convention-template/webhook-cert"
spec:
  selectorTarget: PodTemplateSpec # optional, defaults to PodTemplateSpec; field options include PodTemplateSpec|PodIntent  
  webhook:
    clientConfig:
      service:
        name: webhook
        namespace: convention-template
```

# PodIntent for Cartographer Conventions

This reference topic describes `PodIntent` that you can use with Cartographer Conventions.

## <a id='overview'></a> Overview

The conditional criteria governing the application of a convention is
customizable and is based on the evaluation of a custom Kubernetes resource
called PodIntent.

`PodIntent` applies conventions to a workload. A PodIntent is created, or
updated, when a workload is run by using a Tanzu Application Platform supply
chain.

The `.spec.template`'s PodTemplateSpec is enriched by the conventions and
exposed as the `.status.template`s PodTemplateSpec. A log of which sources and
conventions are applied is captured with the
`conventions.carto.run/applied-conventions` annotation on the PodTemplateSpec.

```yaml
apiVersion: conventions.carto.run/v1alpha1
kind: PodIntent
metadata:
  name: sample
spec:
  template:
    spec:
      containers:
      - name: workload
        image: ubuntu
```

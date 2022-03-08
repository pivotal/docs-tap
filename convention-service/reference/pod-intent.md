# PodIntent

`PodIntent` applies conventions to a workload. The `.spec.template`'s PodTemplateSpec is enriched by the conventions and exposed as the `.status.template`s PodTemplateSpec. A log of which sources and conventions applied is captured with the `conventions.apps.tanzu.vmware.com/applied-conventions` annotation on the PodTemplateSpec.

```
apiVersion: conventions.apps.tanzu.vmware.com/v1alpha1
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

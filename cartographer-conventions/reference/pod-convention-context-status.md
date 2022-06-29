# PodConventionContextStatus

The Pod convention context status type is used to represent the current status of the context retrieved by the request.
It holds the applied conventions by the server and the modified version of the `PodTemplateSpec`.
For more information about `PodTemplateSpec`, see the [Kubernetes documentation](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-template-v1/#PodTemplateSpec).

The field `.template` is populated with the enriched [PodTemplateSpec](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-template-v1/#PodTemplateSpec). The field `.appliedConventions` is populated with the names of any applied conventions.

```console
{
    "template": {
        "metadata": {
            ...
        },
        "spec": {
            ...
        }
    },
    "appliedConventions": [
        "convention-1",
        "convention-2",
        "convention-4"
    ]
}
```

yaml version:

```yaml
---
apiVersion: webhooks.conventions.carto.run/v1alpha1
kind: PodConventionContext
metadata:
  name: sample # the name of the ClusterPodConvention
spec: # the request
  imageConfig:
  template:
    <corev1.PodTemplateSpec>
status: # the response
  appliedConventions: # list of names of conventions applied
  - my-convention
  template:
  spec:
      containers:
      - name : workload
        image: helloworld-go-mod
```

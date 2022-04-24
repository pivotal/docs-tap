# PodConventionContextSpec

The Pod convention context specification is a wrapper of the [`PodTemplateSpec`](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-template-v1/#PodTemplateSpec) and the [`ImageConfig`](image-config.md) provided in the request body of the server. It represents the original `PodTemplateSpec`. For more information on `PodTemplateSpec`, see the [Kubernetes documentation](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-template-v1/#PodTemplateSpec).

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
"imageConfig": {
    ...
  "name": "oci-image-name",
  "config": {
        ...
    }
  }
}
```

# Source Controller <!-- omit in toc -->

The controller follows the spirit of the FluxCD Source Controller. An [`ImageRepository`](#imagerepository) resource is able to resolve source from the content of an image in an image registry.

## Troubleshooting

For basic troubleshooting Source Controller, please see the troubleshooting guide [here](./troubleshooting.md).

## Reference Documentation

### ImageRepository

```yaml
apiVersion: source.apps.tanzu.vmware.com/v1alpha1
kind: ImageRepository
spec:
  image: registry.example/image/repository:tag
  # optional fields
  interval: 5m
  imagePullSecrets: []
  serviceAccountName: default
```

`ImageRepository` resolves source code defined in an OCI image repository, exposing the resulting source artifact at a URL defined by `.status.artifact.url`.

The interval determines how often to check tagged images for changes. Setting this value too high will result in delays discovering new sources, while setting it to low may trigger a registry's rate limits.

Repository credentials may be defined as image pull secrets either referenced directly from the resources at `.spec.imagePullSecrets`, or attached to a service account referenced at `.spec.serviceAccountName`. The default service account name `"default"` is used if not otherwise specified. The default credential helpers for the registry are also used, for example, pulling from GCR on a GKE cluster.

# Configure Contour to propagate header with Domain Mapping

This topic tells you how to configure Contour for header propagation with Knative Domain Mapping and autoTLS certs.

After `autoTLS` is enabled, a request for a Knative service with Domain Mapping might not maintain the `x-forwaded-proto` header. This can cause issues when the request is forwarded to a system expecting this header to be set to `https`, for example, Spring Security SSO.

You can solve this issue by configuring Contour with `num-trusted-hops: 1`. This allows the header to correctly propagate by using Domain Mapping.

> **Important** To update the configmap, you must configure it in the Tanzu Application Platform values file. 
If you change it directly in the configmap, kapp-controller reverts all the changes you made.

Example configuration for Contour by using the Tanzu Application Platform values file (commonly called `tap-values.yaml`):

```yaml
contour:
  contour:
    configFileContents:
      num-trusted-hops: 1
```

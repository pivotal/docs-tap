# Configure Contour for header propagation with Knative Domain Mapping and autoTLS certs

With autoTLS is enabled, a request for a Knative service going through Domain Mapping may not maintain `x-forwaded-proto` header. This can cause issues when the request is forwarded to a system expecting this header to be set to `https` for example: Spring Security SSO.

This issue can be solved by configuring contour with `num-trusted-hops: 1` which allows the header to correctly propagate via Domain Mapping.

> **Important** To update the configmap, you must configure it through Tanzu Application Platform values file. 
If you change it directly in the configmap, kapp-controller reverts all the changes you made.

Example configuration for contour via TAP values file(typically called `tap-values.yaml`):

```
contour:
  contour:
    configFileContents:
      num-trusted-hops: 1
```

# cert-manager, Contour and FluxCD Source Controller

## <a id='cert-manager'></a>cert-manager

cert-manager adds certificates and certificate issuers as resource types to Kubernetes clusters. It also helps you to
obtain, renew, and use those certificates. For more information about cert-manager, see
the [cert-manager documentation](https://cert-manager.io/docs).

The cert-manager package allows you to, optionally, configure a number of `ClusterIssuer`. 
When you install Tanzu Application Platform by using profiles, 
a self-signed `ClusterIssuer` is included by default.

As of `cert-manager.tanzu.vmware.com/2.0.0`, versioning departs from the upstream, open-source project's 
version. The contained cert-manager version is reflected in `Package.spec.includedSoftware`. You can 
identify the version of cert-manager as follows:

```shell
kubectl get package -n tap-install cert-manager.tanzu.vmware.com.2.0.0 -ojsonpath='{.spec.includedSoftware}' | jq
[
 {
   "description": "X.509 certificate management for Kubernetes and OpenShift",
   "displayName": "cert-manager",
   "version": "1.9.1"
 }
]
```

## <a id='contour'></a>Contour

Contour is an ingress controller for Kubernetes that supports dynamic configuration updates and multi-team ingress
delegation. It provides the control plane for the Envoy edge and service proxy. For more information about Contour, see
the [Contour documentation](https://projectcontour.io/docs/v1.20.0/).

## <a id='fluxcd'></a>FluxCD Source Controller

FluxCD Source Controller provides APIs for acquiring resources on the cluster. For more information about FluxCD Source
Controller, see [FluxCD Source Controller documentation](https://fluxcd.io/flux/components/source/). 

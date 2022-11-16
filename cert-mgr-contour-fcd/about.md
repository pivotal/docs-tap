# cert-manager, Contour and FluxCD Source Controller

## cert-manager

cert-manager adds certificates and certificate issuers as resource types to Kubernetes clusters. It also helps you to
obtain, renew, and use those certificates. For more information about cert-manager, see
the [cert-manager's documentation](https://cert-manager.io/docs).

The cert-manager package allows one to, optionally, configure a number of `ClusterIssuer`. When TAP is installed via one
of its profiles, then a self-signed `ClusterIssuer` will be included by default.

> **Note** As of `cert-manager.tanzu.vmware.com/2.0.0`, versioning has departed from the upstream, open-source project's
> version. Instead, The contained cert-manager's version is reflected in `Package.spec.includedSoftware`. You can
> identify the version of cert-manager like so:
>
> ```shell
> kubectl get package -n tap-install cert-manager.tanzu.vmware.com.2.0.0 -ojsonpath='{.spec.includedSoftware}' | jq
> [
>   {
>     "description": "X.509 certificate management for Kubernetes and OpenShift",
>     "displayName": "cert-manager",
>     "version": "1.9.1"
>   }
> ]
> ```

## Contour

Contour is an ingress controller for Kubernetes that supports dynamic configuration updates and multi-team ingress
delegation. It provides the control plane for the Envoy edge and service proxy. For more information about Contour, see
the [Contour documentation](https://projectcontour.io/docs/v1.20.0/).

## FluxCD Source Controller

FluxCD Source Controller provides APIs for acquiring resources on the cluster. For more information about FluxCD Source
Controller, see [FluxCD Source Controller documentation](https://fluxcd.io/flux/components/source/). 

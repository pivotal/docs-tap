# Overview of cert-manager

cert-manager adds certificates and certificate issuers as resource types to
Kubernetes clusters. It also helps you to obtain, renew, and use those
certificates. For more information about cert-manager, see [cert-manager
documentation](https://cert-manager.io/docs).

The cert-manager package allows you to, optionally, configure a number of
`ClusterIssuer`. When you install Tanzu Application Platform by using profiles,
a self-signed `ClusterIssuer` is included by default.

As of `cert-manager.tanzu.vmware.com/2.0.0`, versioning departs from the
upstream, open-source project's version. The contained cert-manager version is
reflected in `Package.spec.includedSoftware`. You can identify the version of
cert-manager as follows:

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

> **Caution** ACME HTTP01 challenges can fail under certain conditions. 
> For more information, see [ACME challenges](acme-challenges.hbs.md).

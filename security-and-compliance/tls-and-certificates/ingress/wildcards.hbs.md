# Wildcard certificates

You can use wildcard certificates, but Tanzu Application Platform
does not offer support.

Wildcard certificates require component-level configuration. For more information about which components support wildcards, see [Inventory](./inventory.hbs.md).

When using wildcard certificates the approach differs between
components that have a fixed set of ingress endpoints and those that have
a variably set of ingress endpoints:

- Components with a fixed set of ingress endpoints can receive a reference to
  the wildcard certificate's `Secret` and an ingress domain, for example, Tanzu Application Platform
  GUI.

- Components with a variably set of ingress endpoints usually offer Kubernetes
  APIs that create ingress resources. These components allow
  configuration of domain templating so that wildcard certificates can be used,
  for example, CNRs and Application Single Sign-On.

>**Note** You can use a mixed approach for configuring TLS for components.
>For example, use a shared ingress issuer, but override TLS configuration for select
>components while using wildcard certificates for some.


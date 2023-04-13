# Wildcard certificates

It is possible to use wildcard certificates, but Tanzu Application Platform
does not offer first-class support.

Generally, wildcard certificate requires component-level configuration. Refer
to [inventory](./inventory.hbs.md) to understand which components support
wildcards and where to find their documentation.

In a nutshell, when using wildcard certificates the approach differs between
components which have a fixed set of ingress endpoints and those which vary:

* Components with a fixed set of ingress endpoints can receive a reference to
  the wildcard certificate's `Secret` and an ingress domain, e.g. TAP GUI.

* Components with a variably set of ingress endpoints usually offer Kubernetes
  APIs which create ingress resources. These components commonly allow for
  configuration of domain templating so that wildcard certificates can be used,
  e.g. CNRs and Application Single Sign-On.

>**Note** The approaches for configuring TLS for TAP's components can be mixed;
>use a shared ingress issuer, but override TLS configuration for select
>components while using wildcard certificates for some.


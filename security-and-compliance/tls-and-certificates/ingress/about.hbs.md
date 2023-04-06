# Ingress certificates

Tanzu Application Platform exposes ingress endpoints so that:

* Platform operator and application developers can interact with the platform
* End-users can interact with applications running on the platform

Refer to the [inventory](./inventory.hbs.md) for an accounting of ingress endpoints.

To secure these endpoints with TLS, i.e. `https://`, Tanzu Application Platform
has two primary ways of configuring ingress certificates:

* **A shared ingress issuer**

  This is the recommended best practice for issuing ingress certificates on
  Tanzu Application Platform.

  The ingress issuer is an on-platform representation of a _certificate
  authority_. All participating components will get their certificates issued
  by it. It is designated by the single TAP configuration value
  `shared.ingress_issuer`. Unless customized, all components obtain their
  ingress certificates from this issuer.

  By default, the ingress issuer is self-signed.

  Refer to [shared ingress issuer](./issuer.hbs.md) to learn about its
  prerequisites, defaults and how to bring your own issuer.

* **Component-level configuration**

  In some situations the shared ingress issuer is not the right choice(see [its
  prerequisites](./issuer.hbs.md#prerequisites)). It is possible to override
  configuration of TLS and certificates per component. A component's
  ingress/TLS configuration takes precedence over the shared ingress issuer.

  Refer to the [inventory](./inventory.hbs.md) for a listing of components with
  ingress and how to customize them.

  TAP also has limited support for [wildcard certificates](./wildcards.hbs.md).

>**Note** The approaches can be mixed; use a shared ingress issuer, but
>override TLS configuration for select components.


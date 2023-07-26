# Secure Ingress certificates in Tanzu Application Platform

This topic tells you how to secure exposed ingress endpoints with TLS in Tanzu Application Platform (commonly known as TAP).

Tanzu Application Platform exposes ingress endpoints so that:

- Platform operators and application developers can interact with the platform.
- End users can interact with applications running on the platform.

For information about ingress endpoints and their certificates, see [Ingress
certificates inventory](./inventory.hbs.md).

To secure these endpoints with TLS, such as  `https://`, Tanzu Application Platform
has two ways of configuring ingress certificates:

## A shared ingress issuer

VMware recommends a shared ingress issuer as the best practice for issuing ingress certificates on
Tanzu Application Platform.

The ingress issuer is an on-platform representation of a certificate
authority. All participating components get their certificates issued
by it. It is designated by the single Tanzu Application Platform configuration value
`shared.ingress_issuer`. Unless customized, all components obtain their
ingress certificates from this issuer.

By default, the ingress issuer is self-signed.

For more information about prerequisites, default values, and how to bring your own issuer, see
[Shared ingress issuer](./issuer.hbs.md).

## Component-level configuration

In some situations, depending on [prerequisites](./issuer.hbs.md#prerequisites), the shared ingress
issuer is not the right choice. You can override
configuration of TLS and certificates per component. A component's
ingress and TLS configuration takes precedence over the shared ingress issuer.

For a list of components with ingress and how to customize them, see [Inventory](./inventory.hbs.md).

Tanzu Application Platform also has limited support for [wildcard certificates](./wildcards.hbs.md).

>**Note** The approaches can be mixed, for example, you can use a shared ingress issuer, but
override TLS configuration for select components.

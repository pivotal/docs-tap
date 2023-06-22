# Custom CA certificates

This topic tells you about configuring custom CA certificates in Tanzu Application Platform
(commonly known as TAP).

You configure trust for custom CAs. This is helpful if any Tanzu Application Platforms components
are connecting to services that serve certificates issued by private certificate authorities.

The `shared.ca_cert_data` installation value can contain a PEM-encoded CA bundle. Each component
then trusts the CAs contained in the bundle.

You can also configure trust per component by providing a CA bundle in the component's installation
values. The component then trusts those CAs and the CAs configured in `shared.ca_cert_data`.
For more information, see [components](../../components.hbs.md).

For example:

```yaml
#! my-tap-values.yaml

shared:
  ca_cert_data: |
    Corporate CA 1
    -----BEGIN CERTIFICATE-----
    MIIFmDCCA4....
    -----END CERTIFICATE-----
    Corporate CA 2
    -----BEGIN CERTIFICATE-----
    MIIFkzCCA3....
    -----END CERTIFICATE-----

```

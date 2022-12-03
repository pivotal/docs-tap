# Custom CA certificates

You configure trust for custom CAs. This is helpful if any of Tanzu Application Platforms components
are connecting to services which serve certificates issued by private certificate authorities.

The `shared.ca_cert_data` installation value can contain a PEM-encoded CA bundle. Each component
will then trusts the CAs contained in the bundle.

You can also configure trust per component by providing a CA bundle in the component's installation
values. The component then trusts those CAs and the CAs configured in `shared.ca_cert_data`.
For more information see [components](../components.hbs.md).

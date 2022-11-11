# Custom CA certificates

You configure trust for custom CAs. This is helpful if any of TAP's components are connecting to services which serve
certificates issued by private certificate authorities.

The `shared.ca_cert_data` installation value can contain a PEM-encoded CA bundle. Each component will then trust the
CAs contained in the bundle.

You can also configure trust per component by providing a CA bundle in the component's installation values. The
component will then trust those CAs **and** the CAs configured in `shared.ca_cert_data`. Refer to the docs of [the
component in question](../components.hbs.md).

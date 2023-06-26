# Reference

This topic gives you reference information for Local Source Proxy.

## Default resources

Local Source Proxy is automatically installed when using the standard iterate and full installation
profiles. The default set of resources provisioned in a namespace is mostly predefined.
However, certain resources are determined based on the configuration entries in `tap-values.yaml`
under the `local_source_proxy` section.

For more information about installation profiles, see
[Installation profiles in Tanzu Application Platform](../about-package-profiles.hbs.md#profiles-and-packages).

The following table shows the list of resources that are templated in the installation of applicable
profiles:

| Namespace                                                  | Kind           | Name                                | Reconcile |
|------------------------------------------------------------|----------------|-------------------------------------|-----------|
| tap-local-source-system                                    | Service        | local-source-proxy                  | No        |
| tap-local-source-system                                    | Secret         | local-source-proxy-values           | Yes       |
| local_source_proxy.push_secret.namespace (tap-values.yaml) | SecretExport   | local_source_proxy.push_secret.name | Yes       |
| tap-local-source-system                                    | SecretImport   | local_source_proxy.push_secret.name | Yes       |
| tap-local-source-system                                    | Deployment     | local-source-proxy                  | No        |
| tap-local-source-system                                    | Role           | local-source-proxy-manager          | No        |
| tap-local-source-system                                    | RoleBinding    | proxy-manager                       | No        |
| tap-local-source-system                                    | ServiceAccount | proxy-manager                       | No        |
| tap-local-source-system                                    | Role           | push-artifact                       | No        |
| tap-local-source-system                                    | RoleBinding    | service-proxy-role-binding          | Yes       |

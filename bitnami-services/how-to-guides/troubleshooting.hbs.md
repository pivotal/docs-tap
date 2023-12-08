# Troubleshoot Bitnami Services

This topic explains how you troubleshoot issues related to Bitnami Services on Tanzu Application Platform
(commonly known as TAP).

## <a id="private-reg"></a> Private registry or VMware Tanzu Application Catalog configuration does not take effect

**Symptom:**

If you [configure private registry integration for the Bitnami services](../../bitnami-services/how-to-guides/configure-private-reg-integration.hbs.md)
after creating a claim for a Bitnami service using the default configuration,
the updated private registry configuration does not appear to take effect.

**Cause:**

This is due to caching behavior in the system that is not accounted for during configuration
updates.

**Solution:**

Delete the `provider-helm-*` pods in the `crossplane-system` namespace and wait for new pods to come
back online after having applied the updated registry configuration.

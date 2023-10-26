# Troubleshoot Bitnami Services

This topic explains how you troubleshoot issues related to Bitnami Services on Tanzu Application Platform
(commonly known as TAP).

## <a id="private-reg"></a> Private registry or VMware Application Catalog configuration does not take effect

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

## <a id="tkr-126"></a> Services aren't starting after upgrading to TKG/TKR 1.26

**Symptom:**

After updating to TKG/TKR 1.26, Bitnami services are not starting.
Inspecting the `Statefulset`s or `Replicaset`s associated with the services reveals issues with the cluster's
Pod Security Standard:

```console
Error creating: pods "xxx" is forbidden: violates PodSecurity "restricted:latest": ...
```

**Cause:**

Newer versions of TKG/TKR enforce a [`restricted` Pod Security
Standard](https://kubernetes.io/docs/concepts/security/pod-security-standards/#restricted).
This prevents services created with TAP 1.6 or older to start.

**Solution:**

Follow the [_Upgrading to TKR 1.26 or newer_](upgrading-tkr.hbs.md) guide.

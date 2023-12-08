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

## <a id="tkr-126"></a> Services aren't starting after upgrading to Tanzu Kubernetes releases v1.26

**Symptom:**

After upgrading to Tanzu Kubernetes releases v1.26, Bitnami services are not starting.
When you inspect a `Statefulset` or `Replicaset` associated with the service, you see an error message
about an issue with the Pod Security Standard for the cluster:

```console
Error creating: pods "xxx" is forbidden: violates PodSecurity "restricted:latest": ...
```

**Cause:**

Tanzu Kubernetes releases v1.26 and later enforces a
[`restricted` Pod Security Standard](https://kubernetes.io/docs/concepts/security/pod-security-standards/#restricted).
This prevents services created with Tanzu Application Platform v1.6 or earlier from starting.

**Solution:**

Follow the steps in [Upgrading to Tanzu Kubernetes releases v1.26 or later](upgrading-tkr.hbs.md).

# Troubleshoot Crossplane

This topic explains how you troubleshoot issues related to Crossplane on Tanzu Application Platform
(commonly known as TAP).

For the limitations of Crossplane, see [Crossplane limitations](../reference/known-limitations.hbs.md).

## <a id=“resource-already-exists”></a> Resource already exists error when installing Crossplane

**Symptom:**

Installation of Crossplane, or a Tanzu Application Platform profile that includes Crossplane, fails
with the error:

```console
Resource already exists
```

**Explanation:**

Crossplane is already installed on the cluster. You cannot install the Crossplane package on a cluster
that already has Crossplane installed on it by using another method, such as Helm install.

**Solution:**

Exclude the Crossplane package in the `tap-values.yaml` file.
For more information, see [Use your existing Crossplane installation](./use-existing-crossplane.hbs.md).

---

## <a id="validatingwebhookconfig"></a>The `validatingwebhookconfiguration` is not removed when you uninstall the Crossplane Package

**Symptom:**

The Crossplane Package deploys a `validatingwebhookconfiguration` named `crossplane` during installation.
This resource is not deleted when you uninstall the Package.

**Solution:**

Delete the `validatingwebhookconfiguration` manually by running:

```console
kubectl delete validatingwebhookconfiguration crossplane
```

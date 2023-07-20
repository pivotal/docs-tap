# Troubleshoot Crossplane

This topic explains how you troubleshoot issues related to Crossplane on Tanzu Application Platform
(commonly known as TAP).

For more information about troubleshooting and limitations for services on Tanzu Application Platform, see
[Known issues and limitations for services on Tanzu Application Platform](../../services-toolkit/reference/known-limitations.hbs.md) and [Troubleshoot Services Toolkit](../../services-toolkit/how-to-guides/troubleshooting.hbs.md)
in the Services Toolkit component documentation.

## <a id=“resource-already-exists”></a> Resource already exists error when installing Crossplane

**Symptom:**

Installation of Crossplane, or a Tanzu Application Platform profile that includes Crossplane, fails
with the error:

```console
Resource already exists
```

**Explanation:**

Crossplane is already installed on the cluster. You cannot install the Crossplane package on a cluster
that already has Crossplane installed on it by using another method, such as, Helm install.

**Solution:**

Exclude the Crossplane package in the `tap-values.yaml` file.
For more information, see [Use your existing Crossplane installation](./use-existing-crossplane.hbs.md).

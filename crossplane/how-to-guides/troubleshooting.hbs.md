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

---

## <a id="error-reinstallation"></a>Claims never transition to `READY=True` after reinstallation to the same cluster

**Symptom:**

After you uninstall the Crossplane package and reinstall it on the same cluster,
service claims you create never transition to `READY=True`. If you inspect the underlying
Crossplane managed resource, you see a TLS certificate verification error similar to the following:

```console
Warning  ComposeResources   39s (x23 over 17m)  defined/compositeresourcedefinition.apiextensions.crossplane.io  cannot compose
resources: cannot run Composition pipeline step "patch-and-transform": cannot run Function "function-patch-and-transform": rpc error:
code = Unavailable desc = last connection error: connection error: desc = "transport: authentication handshake failed: tls: failed to
verify certificate: x509: certificate signed by unknown authority (possibly because of \"crypto/rsa: verification error\" while trying
to verify candidate authority certificate \"Crossplane\")"
```

**Explanation:**

This issue occurs due to the way Crossplane manages the life cycles of TLS certificates, in particular
the root CA certificate in the `crossplane-root-ca` secret in the `crossplane-system` namespace.
This certificate signs all other certificates used by Crossplane.

When you uninstall Crossplane, the root CA certificate is deleted but the certificates that it
signed are not deleted.
After Crossplane is reinstalled, a new root CA certificate is generated.
As a result, the certificates stored in secrets that were not deleted are no longer valid.

This behavior is described in [Function: certificate signed by unknown authority "Crossplane" #5456](https://github.com/crossplane/crossplane/issues/5456) in GitHub.

**Solution:**

As a workaround, delete all secrets in the `crossplane-system` namespace when you uninstall the Crossplane package.
The certificates are then regenerated when reinstalling the package.
A fix for this issue is planned for a future Tanzu Application Platform release.

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

## <a id="tls-verification-error-after-reinstallation"></a>Claims never transition to READY=True after uninstallation of the Crossplane Package followed by reinstallation to the same cluster

**Symptom:**

When uninstalling the Crossplane Package and then reinstalling it again on the same cluster, any tanzu service claim you create will never transition into READY=True. If you inspect the underlying crossplane Managed Resource, you will see a TLS certificate verification error similar to the following:

```console
Warning  ComposeResources   39s (x23 over 17m)  defined/compositeresourcedefinition.apiextensions.crossplane.io  cannot compose
resources: cannot run Composition pipeline step "patch-and-transform": cannot run Function "function-patch-and-transform": rpc error:
code = Unavailable desc = last connection error: connection error: desc = "transport: authentication handshake failed: tls: failed to
verify certificate: x509: certificate signed by unknown authority (possibly because of \"crypto/rsa: verification error\" while trying
to verify candidate authority certificate \"Crossplane\")"
```

**Explanation:**

This issue occurs due to the way Crossplane manages the lifecycles of various TLS certificates, in particular the root CA certificate found in the `crossplane-root-ca` Secret in the `crossplane-system` namespace. This cert is used to sign all other certificates used by Crossplane. It gets deleted when Crossplane is uninstalled, however other certificates that have been signed by this root CA do not get deleted. Once Crossplane is reinstalled again, a new root CA certificate is generated meaning that the certificates stored in the `Secrets` that were not deleted are now no longer valid.

This behaviour is described in [Function: certificate signed by unknown authority "Crossplane" #5456](https://github.com/crossplane/crossplane/issues/5456) in GitHub.

**Solution:**

As a workaround, you can simply delete all Secrets in the `crossplane-system` namespace whenever uninstalling the Crossplane Package. They will all then be generated anew when reinstalling the Package.
A fix for this issue is due to be released in TAP 1.8.2.

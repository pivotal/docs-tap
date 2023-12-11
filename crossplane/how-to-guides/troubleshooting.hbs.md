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
that already has Crossplane installed on it by using another method, such as, Helm install.

**Solution:**

Exclude the Crossplane package in the `tap-values.yaml` file.
For more information, see [Use your existing Crossplane installation](./use-existing-crossplane.hbs.md).

## <a id="cp-custom-cert-inject"></a>Crossplane Providers cannot communicate with systems using a custom CA

**Symptom:**

A known issue occurs when a Crossplane Provider needs to communicate with systems that are set up
with a custom CA.
For example, when the Crossplane Helm Provider uses `releases.helm.crossplane.io` to try to pull a
Helm chart from a registry that uses a custom CA, you see that:

- The `releases.helm.crossplane.io` never reports the status condition `Ready=True`.
- The `releases.helm.crossplane.io` shows a certificate verification error either:
  - Under the status condition of type `SYNCED`.
  - For the event on the `release.helm.crossplane.io`.

To confirm whether you are affected by this issue:

1. Verify the status by running:

    ```console
    kubectl get releases.helm.crossplane.io
    ```

    Example output if you are affected by the issue:

    ```console
    NAME                CHART   VERSION   SYNCED   READY   STATE   REVISION   DESCRIPTION   AGE
    wordpress-example           15.2.5    False    False                                    7m37s
    ```

1. Find out more about the reason by running the following command, or similar:

    ```console
    kubectl get event --namespace default --field-selector involvedObject.name=wordpress-example,involvedObject.kind=Release,type!=Normal | grep -e 'LAST SEEN' -e 'failed to login'
    ```

    Example output if you are affected by the issue:

    ```console
    LAST SEEN   TYPE      REASON                            OBJECT                      MESSAGE
    3m41s       Warning   CannotCreateExternalResource      release/wordpress-example   failed to install release: failed to login to registry: Get "https://insecure-registry:443/v2/": tls: failed to verify certificate: x509: certificate signed by unknown authority
    ```

**Cause:**

This issue occurs because the Providers are installed by Crossplane itself rather than directly by the
Tanzu Application Platform [Crossplane Package](../../crossplane/about.hbs.md).
CA certificate data configured through the `tap-values.yaml` file is not passed down to Crossplane
Providers. Therefore, the Providers are unable to connect to the systems they need to communicate with,
such as, the Helm Provider connecting to a registry hosting the Helm charts or the Kubernetes Provider
connecting to a Kubernetes APIServer.

**Solution:**

Use admission control that allows you to mutate objects, in this case pods, and injects the appropriate
CA certificates.
You can use any system that can mutate objects at admission to mutate the Crossplane Provider pods.
For example, to inject CA certificates you can use this sample in the [Kyverno documentation](https://kyverno.io/policies/other/add-certificates-volume/add-certificates-volume/).

> **Note** From Tanzu Application Platform v1.7, the Crossplane Package will inherit this data through
> `shared.ca_cert_data` of `tap-values.yaml` and configure the Crossplane Providers accordingly.
> This workaround will no longer be needed.

## <a id="validatingwebhookconfig"></a>The `validatingwebhookconfiguration` is not removed when you uninstall the Crossplane Package

**Symptom:**

The Crossplane Package deploys a `validatingwebhookconfiguration` named `crossplane` during installation.
This resource is not deleted when you uninstall the Package.

**Solution:**

Delete the `validatingwebhookconfiguration` manually by running:

```console
kubectl delete validatingwebhookconfiguration crossplane
```

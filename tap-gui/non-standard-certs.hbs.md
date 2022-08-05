# Configuring custom certificate authorities for Tanzu Application Platform GUI

This topic describes how to configure Tanzu Application Platform GUI to trust unusual certificate
authorities (CA) when making outbound connections.
You do this by using overlays with PackageInstalls. There are two ways to implement this workaround:

- [Deactivate all SSL verification](#deactivate-ssl)
- [Add a custom CA](#add-custom-ca)

## <a id='deactivate-ssl'></a> Deactivate all SSL verification

To deactivate SSL verification to allow for self-signed certificates, set the
Tanzu Application Platform GUI pod's environment variable as `NODE_TLS_REJECT_UNAUTHORIZED=0`.
When the value equals `0`, certificate validation is deactivated for TLS connections.

To do this, use the `package_overlays` key in the Tanzu Application Platform values file.
For instructions, see [Customizing Package Installation](../customize-package-installation.md).

The following is an example overlay to deactivate TLS:

```yaml
#@ load("@ytt:overlay", "overlay")

#@overlay/match by=overlay.subset({"kind":"Deployment", "metadata": {"name": "server", "namespace": "NAMESPACE"}}),expects="1+"
---
spec:
  template:
    spec:
      containers:
        #@overlay/match by=overlay.all,expects="1+"
        #@overlay/match-child-defaults missing_ok=True
        - env:
          - name: NODE_TLS_REJECT_UNAUTHORIZED
            value: "0"
```

Where `NAMESPACE` is the namespace in which your Tanzu Application Platform GUI instance is deployed.
For example, `tap-gui`.

## <a id='add-custom-ca'></a> Add a custom CA

If you want to keep verification enabled, you can add a custom CA and mount it to the
Tanzu Application Platform GUI pod, and then set the pod's environment variable as
`NODE_EXTRA_CA_CERTS=PATH-TO-MOUNTED-FILE`.

To do so:

1. Encode the extra CA certificates you want to trust in base64.
You can provide many certificates in PEM format in the same file.
Get the output you need for the next step by running:

    ```console
    cat FILENAME | base64 -w0
    ```

    Where `FILENAME` is your filename. For example, `cert-chain.pem`.

1. Copy the output from the previous command into the example field `tap-gui-certs.crt` into the
following example `secret.yaml`:

    ```yaml
    ---
    apiVersion: v1
    kind: Secret
    metadata:
      name: tap-gui-extra-certs
      namespace: tap-gui
    type: Opaque
    data:
      tap-gui-certs.crt: "ENCODED-LIST-OF-CERTS"
    ```

    Adjust metadata and naming from this example accordingly.

1. Apply the secret to your cluster by running:

    ```console
    kubectl apply -f secret.yaml
    ```

1. To set the environment variable `NODE_EXTRA_CA_CERTS`, use the `package_overlays` key in the
Tanzu Application Platform values file.
For instructions, see [Customizing Package Installation](../customize-package-installation.md).

    The following is an example overlay to add a custom CA.
    It assumes that your Tanzu Application Platform GUI instance is deployed in the namespace `tap-gui`.
    Adjust all names accordingly.

    ```yaml
    #@ load("@ytt:overlay", "overlay")

    #@overlay/match by=overlay.subset({"kind": "Deployment", "metadata": {"name": "server", "namespace": "tap-gui"}}), expects="1+"
    ---
    spec:
      template:
        spec:
          containers:
            #@overlay/match by=overlay.subset({"name": "backstage"}),expects="1+"
            #@overlay/match-child-defaults missing_ok=True
            - env:
                - name: NODE_EXTRA_CA_CERTS
                  value: /etc/tap-gui-certs/tap-gui-certs.crt
              volumeMounts:
                - name: tap-gui-extra-certs
                  mountPath: /etc/tap-gui-certs
                  readOnly: true
          volumes:
            - name: tap-gui-extra-certs
              secret:
                secretName: tap-gui-extra-certs
    ```

## <a id='next-steps'></a>Next steps

- [Configuring Application Accelerator](../application-accelerator/configuration.html)

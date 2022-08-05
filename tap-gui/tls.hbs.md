# Configuring TLS Certificate for Tanzu Application Platform GUI

To configure a TLS certificate for Tanzu Application Platform GUI:

1. Create a `certificate.yaml` file that defines an Issuer and a Certificate. For example:

    ```yaml
    apiVersion: cert-manager.io/v1
    kind: Issuer
    metadata:
      name: ca-issuer
      namespace: tap-gui
    spec:
      selfSigned: {}
    ---
    apiVersion: cert-manager.io/v1
    kind: Certificate
    metadata:
      name: tap-gui-cert
      namespace: tap-gui
    spec:
      secretName: tap-gui-cert
      dnsNames:
      - tap-gui.INGRESS-DOMAIN
      issuerRef:
        name: ca-issuer
    ```

    Where `INGRESS-DOMAIN` is your domain value.

1. Add the Issuer and Certificate to your cluster by running:

    ```console
    kubectl apply -f certificate.yaml
    ```

1. Update your `tap-gui` values to include:

   - a top-level `tls` key with subkeys for `namespace` and `secretName`
   - a namespace referring to the namespace containing the above `Certificate` object
   - a secret name referring to the `secretName` value defined in your `Certificate` resource earlier

     Example:

     ```yaml
     tls:
       namespace: tap-gui
       secretName: tap-gui-cert
     ```

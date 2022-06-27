# Configuring TLS Certificate for Tanzu Application Platform GUI

In order to configure a TLS certificate for Tanzu Application Platform GUI, follow the steps:

1. Add a certificate to your cluster, in the `tap-gui` namespace. A simple example is provided.
    
    * Create a certificate.yaml file defining an Issuer and a Certificate, replacing `INGRESS-DOMAIN` with the value of your domain.

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
    * add the Issuer and Certificate to your cluster:

        ```kubectl apply -f certificate.yaml```

2. Update your `tap-gui` values to include a top level `tls` key, with subkeys for `namespace` and `secretName`. The namespace should refer to the namespace containing the above `Certificate` object. The secret name should refer to the `secretName` value defined in your Certificate resource above.
   ```yaml
    tls:
        namespace: tap-gui
        secretName: tap-gui-cert
   ```
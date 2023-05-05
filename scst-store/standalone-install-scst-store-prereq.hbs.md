
# Prerequisite for Standalone SCST - Store

The following prerequisites are required to install SCST - Store individually, instead of using a profile:

- Install the SelfSigned Cluster Issuer:

  ```console
  # Install `tap-ingress-selfsigned` ClusterIssuer
  cat << EOF > /tmp/tap-ingress-selfsigned-cluster-issuer.yaml
  apiVersion: cert-manager.io/v1
  kind: ClusterIssuer
  metadata:
    name: tap-ingress-selfsigned
  spec:
    selfSigned: {}
  EOF

  kapp deploy -a issuer -f /tmp/tap-ingress-selfsigned-cluster-issuer.yaml -y
  ```

- Install `SCST - Store` and update the certificate:

  ```console
  cat << EOF > /tmp/ingress-issuer-cert.yaml
  apiVersion: cert-manager.io/v1
  kind: Certificate
  metadata:
    name: ingress-cert
    namespace: metadata-store
  spec:
    isCA: true
    dnsNames:
      - metadata-store.${INGRESS_DOMAIN}
    issuerRef:
      kind: ClusterIssuer
      name: tap-ingress-selfsigned
      group: cert-manager.io
    secretName: ingress-cert
    commonName: metadata-store-ca
  EOF
  kubectl apply -f /tmp/ingress-issuer-cert.yaml
  # `ingress-cert` is deleted. It will be automatically created again with newly applied ClusterIssuer cert
  kubectl delete secret ingress-cert -n metadata-store
  ```

These steps ensure that you have valid certificate after `SCST-Store` installation is complete.
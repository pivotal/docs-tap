
# Prerequisite for Standalone SCST - Store

Make sure to install SelfSigned Cluster Issuer

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

Now complete installation of `SCST - Store` and then update the cert as mentioned below


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
kubectl delete secret ingress-cert -n metadata-store
```

These steps will ensure that you have valid cert once `SCST-Store` install is complete.
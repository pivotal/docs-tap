# Ingress and multicluster support

Supply Chain Security Tools - Store has ingress support by using Contour's HTTPProxy resources. To enable ingress support, a Contour installation must be available in the cluster.

Supply Chain Security Tools - Store's configuration includes two options to configure the proxy: `ingress_enabled` and `ingress_domain`. If needed, you can override the `shared.ingress_domain` TAP-level setting with the `ingress_domain` parameter.

For example:

```yaml
ingress_enabled: "true"
ingress_domain: "example.com"
app_service_type: "ClusterIP"  # recommended if ingress is enabled
```

Supply Chain Security Tools - Store installation creates an HTTPProxy entry with host routing by using the qualified name `metadata-store.<ingress_domain>` (`metadata-store.example.com`). The create route supports HTTPS communication through a self-signed certificate with the same subject Alternative Name.

Contour and DNS setup are not part of Supply Chain Security Tools - Store installation. Access to Supply Chain Security Tools - Store through Contour depends on the correct configuration of these two components.

Make the proper DNS record available to clients to resolve `metadata-store.<ingress_domain>` to Envoy service's external IP address.

DNS setup example:

```bash
$ kubectl describe svc envoy -n tanzu-system-ingress
> ...
  Type:                     LoadBalancer
  ...
  LoadBalancer Ingress:     100.2.3.4
  ...
  Port:                     https  443/TCP
  ...

$ nslookup metadata-store.example.com
> Server:		8.8.8.8
  Address:	8.8.8.8#53

  Non-authoritative answer:
  Name:	metadata-store.example.com
  Address: 100.2.3.4

$ curl https://metadata-store.example.com/api/health -k -v
> ...
  < HTTP/2 200
  ...
```

>**Note:** The preceding curl example uses the insecure (`-k`) flag to skip TLS verification because the Store installs a self-signed certificate. The following section shows how to access the CA certificate to enable TLS verification for HTTP clients.

## <a id="multicluster-setup"></a>Multicluster setup

To support multicluster setup of Supply Chain Security Tools - Store, some communication secrets must be shared across the cluster.

Set up the cluster containing Supply Chain Security Tools - Store first and enable Supply Chain Security Tools - Store ingress for ease of installation. When configuring a second Tanzu Application Platform cluster, components such as Supply Chain Security Tools - Scan need access to the Store's API. This requires access to the TLS CA certificate for HTTPS support and the Authorization access token.

## <a id="tls"></a>TLS CA certificate

To get Supply Chain Security Tools - Store's TLS CA certificate, run:

```bash
# On the Supply Chain Security Tools - Store's cluster
$ CA_CERT=$(kubectl get secret -n metadata-store ingress-cert -o json | jq -r ".data.\"ca.crt\"")
$ cat <<EOF > store_ca.yaml
---
apiVersion: v1
kind: Secret
type: kubernetes.io/tls
metadata:
  name: store-ca-cert
  namespace: metadata-store-secrets
data:
  ca.crt: $CA_CERT
  tls.crt: ""
  tls.key: ""
EOF

# On the second Cluster

# Create secrets namespace
$ kubectl create ns metadata-store-secrets

# Create the CA Certificate secret
$ kubectl apply -f store_ca.yaml
```

## <a id="rbac-auth-token"></a>RBAC Auth token

To get the Supply Chain Security Tools - Store's Auth token, run:

```bash
$ AUTH_TOKEN=$(kubectl get secrets -n metadata-store -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='metadata-store-read-write-client')].data.token}" | base64 -d)
```

Create the corresponding secret on the second cluster. Run:

```bash
$ kubectl create secret generic store-auth-token --from-literal=auth_token=$AUTH_TOKEN -n scan-link-system
```

This secret is created in the Supply Chain Security Tools - Scan namespace, which is `scan-link-system` by default.

## <a id="scst-scan-install"></a>Supply Chain Security Tools - Scan installation

To allow Supply Chain Security Tools - Scan to access the created secrets, `SecretExport` resources must be created.

>**Note:** Corresponding `SecretImport` resources that receive the exported secrets are installed with the Supply Chain Security Tools - Scan package.

Here is an example for supporting Supply Chain Security Tools - Scan installation on the default namespace `scan-link-system`:

```bash
$ cat <<EOF > store_secrets_export.yaml
---
apiVersion: secretgen.carvel.dev/v1alpha1
kind: SecretExport
metadata:
  name: store-ca-cert
  namespace: metadata-store-secrets
spec:
  toNamespace: scan-link-system
---
apiVersion: secretgen.carvel.dev/v1alpha1
kind: SecretExport
metadata:
  name: store-auth-token
  namespace: metadata-store-secrets
spec:
  toNamespace: scan-link-system
EOF

# Export secrets to the Supply Chain Security Tools - Scan namespace
$ kubectl apply -f store_secrets_export.yaml
```

Install Supply Chain Security Tools - Scan with the following configuration:

```yaml
---
scanning:
  metadataStore:
    url: https://metadata-store.example.com
    caSecret:
        name: store-ca-cert
        importFromNamespace: metadata-store-secrets
    authSecret:
        name: store-auth-token
        importFromNamespace: metadata-store-secrets
```

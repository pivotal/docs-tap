Ingress support
===

The Supply Chain Security Tools - Store has ingress support using Contour's HTTPProxy resources. To enable ingress support, a Contour installation must be available in the cluster.

The Supply Chain Security Tools - Store's configuration includes two options to configure the proxy: `ingress_enabled` and `ingress_domain`. 

Example:
```yml
ingress_enabled: "true"
ingress_domain: "example.com"
```

The Supply Chain Security Tools - Store installation will create an HTTPProxy entry with host routing using the qualified name `metadata-store.<ingress_domain>` (`metadata-store.example.com`). The create route supports HTTPS communication via a self-signed certificate with the same subject Alternative Name.

Contour and DNS setup are not part of the Supply Chain Security Tools - Store installation and access to the Supply Chain Security Tools - Store through Contour depends on the correct configuration of these two components.

The proper DNS record should be available to clients to resolve `metadata-store.<ingress_domain>` to Envoy service's external IP. 

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

**Note:** The curl example above uses the insecure (`-k`) flag to skip TLS verification since the Store installs a self-signed certificate. In the section below, we'll explore how to access the CA certificate to enable TLS verification for HTTP clients.

Multi Cluster setup
===

To support Multi Cluster setup of the Supply Chain Security Tools - Store, some communication secrets must be shared across cluster. 

The cluster containing the Supply Chain Security Tools - Store should be setup first and the Supply Chain Security Tools - Store ingress should be enabled for ease of installation. When configuring a second TAP Cluster, components such as Supply Chain Security Tools - Scan will need access to the Store's API which requires access to the TLS CA Certificate (for HTTPS support) and the Authorization access token.

## TLS CA Certificate

Get the Supply Chain Security Tools - Store's TLS CA certificate:

```bash
# On the Supply Chain Security Tools - Store's cluster
$ CA_CERT=$(kubectl get secret -n metadata-store ingress-cert -o json | jq -r ".data.\"ca.crt\"")
$ cat <<EOF > store_ca.yml
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
$ kubectl apply -f store_ca.yml
```

## RBAC Auth token

Get the Supply Chain Security Tools - Store's Auth token:

```bash
$ AUTH_TOKEN=$(kubectl get secrets -n metadata-store -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='metadata-store-read-write-client')].data.token}" | base64 -d)
```

Create the corresponding secret on the second Cluster:

```bash
$ kubectl create secret generic store-auth-token --from-literal=auth_token=$AUTH_TOKEN -n scan-link-system
```

Note that this secret should be created in the Supply Chain Security Tools - Scan namespace (`scan-link-system` by default).

## Supply Chain Security Tools - Scan Installation

To allow Supply Chain Security Tools - Scan to access the created secrets, `SecretExport` resources should be created.

Example for supporting Supply Chain Security Tools - Scan installation on the default namespace `scan-link-system`:

```bash
$ cat <<EOF > store_secrets_export.yml
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
$ kubectl apply -f store_secrets_export.yml
```

At this point, Supply Chain Security Tools - Scan can be installed with the following configuration:

```yml
---
metadataStore:
    url: https://metadata-store.example.com
    caSecret:
        name: store-ca-cert
        importFromNamespace: metadata-store-secrets
    authSecret:
        name: store-auth-token
```

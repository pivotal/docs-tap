# Multicluster setup

Deploying Tanzu Application Platform in a multicluster setup includes installing multiple profiles: View, Build, Run, Iterate. Supply Chain Security Tools (SCST) - Store is deployed with the View profile. After installing the View profile but before installing the Build profile, you must add configuration related to SCST - Store to the Kubernetes cluster where you intend to install the Build profile. This guide helps you add that configuration which allows components in the Build cluster to communicate with the SCST - Store in the View cluster.

## Prerequisites

You must have already installed the View profile. Follow the steps in [Install View profile](../multicluster/installing-multicluster.hbs.md#install-view).

## Summary of Steps

1. Copy SCST - Store CA certificate from the View cluster
2. Copy SCST - Store authentication token from the View cluster
3. Apply the CA certificate and authentication token to the Kubernetes cluster where you intend to install the Build profile
4. Install the Build profile

## Copy SCST - Store CA certificate from View cluster

With you kubectl targeted at the View cluster, you can view SCST - Store's TLS CA certificate. Run these commands to copy the CA certificate into a file `store_ca.yaml`.

```bash
CA_CERT=$(kubectl get secret -n metadata-store CERT-NAME -o json | jq -r ".data.\"ca.crt\"")
cat <<EOF > store_ca.yaml
---
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: store-ca-cert
  namespace: metadata-store-secrets
data:
  ca.crt: $CA_CERT
EOF
```

Example

```bash
$ CA_CERT=$(kubectl get secret -n metadata-store ingress-cert -o json | jq -r ".data.\"ca.crt\"")
$ cat <<EOF > store_ca.yaml
---
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: store-ca-cert
  namespace: metadata-store-secrets
data:
  ca.crt: $CA_CERT
EOF
```

## Copy SCST - Store authentication token from the View cluster

Copy the SCST - Store authentication token into an environment variable. You use this environment variable in the next step.

```bash
AUTH_TOKEN=$(kubectl get secrets metadata-store-read-write-client -n metadata-store -o jsonpath="{.data.token}" | base64 -d)
```

## Apply the CA certificate and authentication token to a new Kubernetes cluster

Before you deploy the Build profile, you must apply the CA certificate and authentication token from the earlier steps. Then the Build profile deployment has access to these values.

With you kubectl targeted at the Build cluster, create a namespace for the CA certificate and authentication token.

```bash
kubectl create ns metadata-store-secrets
```

Apply the CA certificate `store_ca.yaml` secret YAML generated earlier.

```bash
kubectl apply -f store_ca.yaml
```

Create a secret to store the access stoken. This uses the `AUTH_TOKEN` environment variable from before.

```bash
kubectl create secret generic store-auth-token \
  --from-literal=auth_token=$AUTH_TOKEN -n metadata-store-secrets
```

The cluster now has a CA certificate named  `store-ca-cert` and authentication token named `store-auth-token` in the namespace `metadata-store-secrets`. 

## Install Build profile

If you came into this guide from the [Install multicluster Tanzu Application Platform profiles](../multicluster/installing-multicluster.hbs.md) topic after installing the View profile, return to that topic to [install the Build profile](../multicluster/installing-multicluster.hbs.md#install-build).

The Build profile `values.yaml` contains configuration that references the secrets in the `metadata-store-secrets` namespace you created in this guide. The names of these secrets are already hard coded in that example `values.yaml`.

### More information about how Build profile uses the configuration

The secrets you created are used in the Build profile `values.yaml` to configure the Grype scanner which talks to SCST - Store. After performing vulnerabilities scan, the Grype scanner sends the results to SCST - Store. Here's a snippet of what the configuration might look like.

```yaml
...
grype:
  metadataStore:
    caSecret:
        name: store-ca-cert
        importFromNamespace: metadata-store-secrets
    authSecret:
        name: store-auth-token
        importFromNamespace: metadata-store-secrets
...
```

## Configure the developer namespace

After you finish the entire Tanzu Application Platform installation process, you are ready to configure developer namespaces. To prepare developer namespaces, you must export the secrets you created earlier to those namespaces.

### Exporting SCST - Store secrets to developer namespace in a Tanzu Application Platform multicluster deployment

Export secrets to a developer namespace by creating `SecretExport` resources on the developer namespace. Run the following command to create the `SecretExport` resources. You must have created and populated the `metadata-store-secrets` namespace.

```bash
cat <<EOF | kubectl apply -f -
---
apiVersion: secretgen.carvel.dev/v1alpha1
kind: SecretExport
metadata:
  name: store-ca-cert
  namespace: metadata-store-secrets
spec:
  toNamespaces: [DEV-NAMESPACE]
---
apiVersion: secretgen.carvel.dev/v1alpha1
kind: SecretExport
metadata:
  name: store-auth-token
  namespace: metadata-store-secrets
spec:
  toNamespaces: [DEV-NAMESPACE]
EOF
```

Where `toNamespaces: [DEV-NAMESPACE]` is an array of developer namespaces where the secrets are exported.

## Additional resources

* [Ingress support](ingress.hbs.md)

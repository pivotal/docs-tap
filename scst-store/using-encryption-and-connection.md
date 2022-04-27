# Configure target endpoint and certificate

The connection to the Store requires TLS encryption, the configuration depends on the kind of installation. Use the following instructions to set up the TLS connection, depending on which type of setup you are using:

1. <a href="#ingress">Using `Ingress`</a>
1. <a href="#no-ingress">Without `Ingress`</a>
    - <a href="#use-lb">Using `LoadBalancer`</a>
    - <a href="#use-np">Using `NodePort`</a> — commonly used with local clusters such as kind or minikube


## <a id="ingress"></a>Using `Ingress`

When using an [Ingress setup](./ingress-multicluster.md), the Store creates a specific TLS Certificate for HTTPS communications under the `metadata-store` namespace.

To get such certificate you can use the following command:

```bash
kubectl get secret ingress-cert -n metadata-store -o json | jq -r '.data."ca.crt"' | base64 -d > insight-ca.crt
```

Additionally, the endpoint host will be set to `metadata-store.<ingress-domain>` (ex: `metadata-store.example.domain.com`), depending on the value of `ingress_domain` set during the setup.

If no accessible DNS record exists for such domain, you can edit your `/etc/hosts` file to add a local record.

```bash
ENVOY_IP=$(kubectl get svc envoy -n tanzu-system-ingress -o jsonpath="{.status.loadBalancer.ingress[0].ip}")

# replace with your domain
METADATA_STORE_DOMAIN="metadata-store.example.domain.com"

# delete any previously added entry
sudo sed -i '' "/$METADATA_STORE_DOMAIN/d" /etc/hosts

echo "$ENVOY_IP $METADATA_STORE_DOMAIN" | sudo tee -a /etc/hosts > /dev/null
```

Finally, set the target 

```bash
tanzu insight config set-target https://$METADATA_STORE_DOMAIN --ca-cert insight-ca.crt
```

## <a id="no-ingress"></a>Without `Ingress`

When the Store installation is done without using the Ingress alternative, a different Certificate resource should be used for HTTPS communication, in this case the `app-tls-cert` should be queried to get the CA Certificate:

```bash
kubectl get secret app-tls-cert -n metadata-store -o json | jq -r '.data."ca.crt"' | base64 -d > insight-ca.crt
```

### <a id='use-lb'></a>Using `LoadBalancer`

If you are using a `LoadBalancer` configuration, you need to find the external IP address of the `metadata-store-app` service. You can use kubectl to do this.

>**Note**: For all kubectl commands, use the `--namespace metadata-store` flag.

```bash
METADATA_STORE_IP=$(kubectl get service/metadata-store-app --namespace metadata-store -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
METADATA_STORE_PORT=$(kubectl get service/metadata-store-app --namespace metadata-store -o jsonpath="{.spec.ports[0].port}")
METADATA_STORE_DOMAIN="metadata-store-app.metadata-store.svc.cluster.local"

# delete any previously added entry
sudo sed -i '' "/$METADATA_STORE_DOMAIN/d" /etc/hosts

echo "$METADATA_STORE_IP $METADATA_STORE_DOMAIN" | sudo tee -a /etc/hosts > /dev/null
```

Finally, set the target 

```bash
tanzu insight config set-target https://$METADATA_STORE_DOMAIN:$METADATA_STORE_PORT --ca-cert insight-ca.crt
```

## <a id='use-np'></a>Using `NodePort`

To use NodePort, obtain the CA certificate as illustrated at the <a href="no-ingress">top of this section</a>, configure portforwarding and modify the `/etc/hosts` file.

### <a id='config-pf'></a>Configuring port forwarding

When using `NodePort`, configure port forwarding for the service for the CLI to access Supply Chain Security Tools - Store. Run:

```console
kubectl port-forward service/metadata-store-app 8443:8443 -n metadata-store
```

Run this command in a separate terminal window.

### <a id='mod-etchost'></a>Modifying your `/etc/hosts` file

The following script illustrates how to add a new local entry to `/etc/hosts`:

```bash
METADATA_STORE_PORT=$(kubectl get service/metadata-store-app --namespace metadata-store -o jsonpath="{.spec.ports[0].port}")
METADATA_STORE_DOMAIN="metadata-store-app.metadata-store.svc.cluster.local"

# delete any previously added entry
sudo sed -i '' "/$METADATA_STORE_DOMAIN/d" /etc/hosts

echo "127.0.0.1 $METADATA_STORE_DOMAIN" | sudo tee -a /etc/hosts > /dev/null
```

Finally, set the target 

```bash
tanzu insight config set-target https://$METADATA_STORE_DOMAIN:$METADATA_STORE_PORT --ca-cert insight-ca.crt
```

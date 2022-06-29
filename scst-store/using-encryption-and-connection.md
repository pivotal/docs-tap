# Configure target endpoint and certificate

The connection to the Store requires TLS encryption, the configuration depends on the kind of installation. 
Use the following instructions to set up the TLS connection according to the type of your setup:

- [Using `Ingress`](#ingress)
- [Without `Ingress`](#no-ingress)
    - [Using `LoadBalancer`](#use-lb)
    - [Using `NodePort`](#use-np)
    
        >**Note:** `NodePort`is commonly used with local clusters such as kind or minikube.

For a production environment, it is suggested that the Store should be installed with ingress enabled. 

## <a id="ingress"></a>Using `Ingress`

When using an [Ingress setup](ingress-multicluster.md), the Store creates a 
specific TLS Certificate for HTTPS communications under the `metadata-store` namespace.

To get such certificate, run the following command:

```bash
kubectl get secret ingress-cert -n metadata-store -o json | jq -r '.data."ca.crt"' | base64 -d > insight-ca.crt
```

The endpoint host is set to `metadata-store.<ingress-domain>`, 
for example, `metadata-store.example.domain.com`). 
This value matches the value of `ingress_domain`.

If no accessible DNS record exists for such domain, edit the `/etc/hosts` file to add a local record:

```bash
ENVOY_IP=$(kubectl get svc envoy -n tanzu-system-ingress -o jsonpath="{.status.loadBalancer.ingress[0].ip}")

# replace with your domain
METADATA_STORE_DOMAIN="metadata-store.example.domain.com"

# delete any previously added entry
sudo sed -i '' "/$METADATA_STORE_DOMAIN/d" /etc/hosts

echo "$ENVOY_IP $METADATA_STORE_DOMAIN" | sudo tee -a /etc/hosts > /dev/null
```

Set the target by running:

```bash
tanzu insight config set-target https://$METADATA_STORE_DOMAIN --ca-cert insight-ca.crt
```

## <a id="no-ingress"></a>Without `Ingress`

If you install the Store without using the Ingress alternative, 
you must use a different Certificate resource for HTTPS communication. 
In this case, query the `app-tls-cert` to get the CA Certificate:

```bash
kubectl get secret app-tls-cert -n metadata-store -o json | jq -r '.data."ca.crt"' | base64 -d > insight-ca.crt
```

### <a id='use-lb'></a>Use `LoadBalancer`

To use a `LoadBalancer` configuration, you must find the external IP address of the `metadata-store-app` service by using kubectl.

```bash
METADATA_STORE_IP=$(kubectl get service/metadata-store-app --namespace metadata-store -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
METADATA_STORE_PORT=$(kubectl get service/metadata-store-app --namespace metadata-store -o jsonpath="{.spec.ports[0].port}")
METADATA_STORE_DOMAIN="metadata-store-app.metadata-store.svc.cluster.local"

# delete any previously added entry
sudo sed -i '' "/$METADATA_STORE_DOMAIN/d" /etc/hosts

echo "$METADATA_STORE_IP $METADATA_STORE_DOMAIN" | sudo tee -a /etc/hosts > /dev/null
```

> On EKS, you will need to get the IP address for the LoadBalancer. The IP can be found by running something similar to the following: `dig RANDOM-SHA.us-east-2.elb.amazonaws.com`, where RANDOM-SHA is the EXTERNAL-IP received for the LoadBalancer. Select one of the IPs returned from the `dig` command to be written to the `/etc/hosts` file.

Set the target by running:

```bash
tanzu insight config set-target https://$METADATA_STORE_DOMAIN:$METADATA_STORE_PORT --ca-cert insight-ca.crt
```

## <a id='use-np'></a>Using `NodePort`

To use `NodePort`, you must obtain the CA certificate by following the instructions in [Without `Ingress`](#no-ingress), then [Configure port forwarding](#config-pf) and [Modify your `/etc/hosts` file](#mod-etchost).

### <a id='config-pf'></a>Configure port forwarding

When using `NodePort`, configure port forwarding for the service so the CLI can access Supply Chain Security Tools - Store. Run:

```console
kubectl port-forward service/metadata-store-app 8443:8443 -n metadata-store
```

>**Note:** You must run this command in a separate terminal window. Or run the command in the background: `kubectl port-forward service/metadata-store-app 8443:8443 -n metadata-store &`

### <a id='mod-etchost'></a>Modify your `/etc/hosts` file

Use the following script to add a new local entry to `/etc/hosts`:

```bash
METADATA_STORE_PORT=$(kubectl get service/metadata-store-app --namespace metadata-store -o jsonpath="{.spec.ports[0].port}")
METADATA_STORE_DOMAIN="metadata-store-app.metadata-store.svc.cluster.local"

# delete any previously added entry
sudo sed -i '' "/$METADATA_STORE_DOMAIN/d" /etc/hosts

echo "127.0.0.1 $METADATA_STORE_DOMAIN" | sudo tee -a /etc/hosts > /dev/null
```

Set the target by running:

```bash
tanzu insight config set-target https://$METADATA_STORE_DOMAIN:$METADATA_STORE_PORT --ca-cert insight-ca.crt
```

# Configure target endpoint and certificate

The connection to the Store requires TLS encryption and the configuration depends on the kind of installation. Use the following instructions to set up the TLS connection according to the your setup:

- [With `Ingress`](#ingress)
- [Without `Ingress`](#no-ingress)
    - [`LoadBalancer`](#use-lb)
    - [Port forwarding](#config-pf)
    - [`NodePort`](#use-np)
    
VMware recommended connection methods based on Tanzu Application Platform setup:

* Single or multi-cluster with Contour = `Ingress`
* Single cluster without Contour and with `LoadBalancer` support = `LoadBalancer`
* Single cluster without Contour and without `LoadBalancer` = Port forwarding
* Single cluster without Contour, without `LoadBalancer` and user does not have port forwarding access = `NodePort`
* Multi-cluster without Contour = Not supported

For a production environment, VMware recommends that the Store is installed with ingress enabled. 

## <a id="ingress"></a>Using `Ingress`

When using an [Ingress setup](ingress-multicluster.md), the Store creates a 
specific TLS Certificate for HTTPS communications under the `metadata-store` namespace.

To get a certificate, run:

```bash
kubectl get secret ingress-cert -n metadata-store -o json | jq -r '.data."ca.crt"' | base64 -d > insight-ca.crt
```

The endpoint host is set to `metadata-store.<ingress-domain>`,
for example, `metadata-store.example.domain.com`). 
This value matches the value of `ingress_domain`.

If no accessible DNS record exists for the domain, edit the `/etc/hosts` file to add a local record:

```bash
ENVOY_IP=$(kubectl get svc envoy -n tanzu-system-ingress -o jsonpath="{.status.loadBalancer.ingress[0].ip}")

# Replace with your domain
METADATA_STORE_DOMAIN="metadata-store.example.domain.com"

# Delete any previously added entry
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

### <a id='use-lb'></a>`LoadBalancer`

To use a `LoadBalancer` configuration, you must find the external IP address of the `metadata-store-app` service by using kubectl.

```bash
METADATA_STORE_IP=$(kubectl get service/metadata-store-app --namespace metadata-store -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
METADATA_STORE_PORT=$(kubectl get service/metadata-store-app --namespace metadata-store -o jsonpath="{.spec.ports[0].port}")
METADATA_STORE_DOMAIN="metadata-store-app.metadata-store.svc.cluster.local"

# Delete any previously added entry
sudo sed -i '' "/$METADATA_STORE_DOMAIN/d" /etc/hosts

echo "$METADATA_STORE_IP $METADATA_STORE_DOMAIN" | sudo tee -a /etc/hosts > /dev/null
```

> On EKS, you must get the IP address for the LoadBalancer. The IP address is found by running something similar to the following: `dig RANDOM-SHA.us-east-2.elb.amazonaws.com`. Where `RANDOM-SHA` is the EXTERNAL-IP received for the LoadBalancer. Select one of the IP addresses returned from the `dig` command written to the `/etc/hosts` file.

Set the target by running:

```bash
tanzu insight config set-target https://$METADATA_STORE_DOMAIN:$METADATA_STORE_PORT --ca-cert insight-ca.crt
```

### <a id='config-pf'></a>Port forwarding

Configure port forwarding for the service so the CLI can access Supply Chain Security Tools - Store. Run:

```console
kubectl port-forward service/metadata-store-app 8443:8443 -n metadata-store
```
To use `Port Forward`, you must obtain the CA certificate by using the following instructions:
- [Without `Ingress`](#no-ingress),
- [Configure port forwarding](#config-pf)
- [Modify your `/etc/hosts` file for Port Forwarding](#mod-etchost-port-forward)

#### <a id='mod-etchost-port-forward'></a>Modify your `/etc/hosts` file for Port Forwarding

Use the following script to add a new local entry to `/etc/hosts`:

```bash
METADATA_STORE_PORT=$(kubectl get service/metadata-store-app --namespace metadata-store -o jsonpath="{.spec.ports[0].port}")
METADATA_STORE_DOMAIN="metadata-store-app.metadata-store.svc.cluster.local"

# delete any previously added entry
sudo sed -i '' "/$METADATA_STORE_DOMAIN/d" /etc/hosts

echo "127.0.0.1 $METADATA_STORE_DOMAIN" | sudo tee -a /etc/hosts > /dev/null
```
>**Note:** You must run the above commands in a separate terminal window of the port forwarding.
>
Set the target by running:
```bash
tanzu insight config set-target https://$METADATA_STORE_DOMAIN:$METADATA_STORE_PORT --ca-cert insight-ca.crt
```

### <a id='use-np'></a>`NodePort`

`NodePort` is used to connect the CLI and Metadata Store as an alternative to port forwarding.  This is useful when the user does not have port forward access to the cluster.

>**Note:** NodePort is only recommended when: the cluster does not support ingress or the cluster does not support `LoadBalancer` type to services.  `NodePort` is not supported for a multi-cluster set up, as certificates cannot be modified. For example, the Metadata Store does not currently support a BYO-certificate.

To use `NodePort`, you must obtain the CA certificate by following the instructions in [Without `Ingress`](#no-ingress),
then [Modify your `/etc/hosts` file for Node Port](#mod-etchost-node-port).

To use `NodePort`, you must obtain the CA certificate by using the following instructions:
- [Without `Ingress`](#no-ingress),
- [Configure port forwarding](#config-pf)
- [Modify your `/etc/hosts` file for Node Port](#mod-etchost-node-port)

#### <a id='mod-et

#### <a id='mod-etchost-node-port'></a>Edit your `/etc/hosts` file for Node Port


Use the following script to add a new local entry to `/etc/hosts`:

```bash
METADATA_STORE_PORT=$(kubectl get service/metadata-store-app -n metadata-store -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')

METADATA_STORE_HOST_IP=$(kubectl get pods -n metadata-store -o jsonpath='{.items[?(@.metadata.labels.app=="metadata-store-app")].status.hostIP}' | xargs -n1 | head -n1)

METADATA_STORE_DOMAIN="metadata-store-app.metadata-store.svc.cluster.local"

# Delete any previously added entry
sudo sed -i '' "/$METADATA_STORE_DOMAIN/d" /etc/hosts

echo "$METADATA_STORE_HOST_IP $METADATA_STORE_DOMAIN" | sudo tee -a /etc/hosts > /dev/null
```

Set the target by running:

```bash
tanzu insight config set-target https://$METADATA_STORE_DOMAIN:$METADATA_STORE_PORT --ca-cert insight-ca.crt
```

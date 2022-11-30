<!-- Configure certificate and end point for insight cli when ingress is enabled -->

The endpoint host is set to `metadata-store.<ingress-domain>` (such as `metadata-store.example.domain.com`), where `<ingress-domain>` matches the value of the `ingress_domain` property in your deployment YAML.

> **Note** In a multicluster setup, a DNS record is **required** for the domain. The instructions for single cluster setup do not apply, skip to [Set Target](#set-target).

# Single Cluster setup

In a single-cluster setup, VMware reccomends a DNS record. If no accessible DNS record exists for the domain, edit the `/etc/hosts` file to add a local record:

```bash
ENVOY_IP=$(kubectl get svc envoy -n tanzu-system-ingress -o jsonpath="{.status.loadBalancer.ingress[0].ip}")

# Replace with your domain
METADATA_STORE_DOMAIN="metadata-store.example.domain.com"

# Delete any previously added entry
sudo sed -i '' "/$METADATA_STORE_DOMAIN/d" /etc/hosts

echo "$ENVOY_IP $METADATA_STORE_DOMAIN" | sudo tee -a /etc/hosts > /dev/null
```

# <a id='set-target'></a>Set Target

{{> 'partials/cli-plugins/insight-set-target' ingress=true }}
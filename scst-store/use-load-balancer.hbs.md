# Use your LoadBalancer with Supply Chain Security Tools - Store

This topic describes how to use your LoadBalancer with Supply Chain Security Tools (SCST) - Store. 

## Configure LoadBalancer

>**Note** `LoadBalancer` is not the recommended service type.
>Consider the recommended configuration of enabling
>[Ingress](ingress.hbs.md).

To configure a `LoadBalancer`: 

1. Edit `/etc/hosts/` to use the
external IP address of the `metadata-store-app` service.

    ```bash
    METADATA_STORE_IP=$(kubectl get service/metadata-store-app --namespace metadata-store -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
    METADATA_STORE_PORT=$(kubectl get service/metadata-store-app --namespace metadata-store -o jsonpath="{.spec.ports[0].port}")
    METADATA_STORE_DOMAIN="metadata-store-app.metadata-store.svc.cluster.local"

    # Delete any previously added entry
    sudo sed -i '' "/$METADATA_STORE_DOMAIN/d" /etc/hosts

    echo "$METADATA_STORE_IP $METADATA_STORE_DOMAIN" | sudo tee -a /etc/hosts > /dev/null
    ```

    >**Note** On EKS, you must get the IP address for the LoadBalancer. Find the IP
    >address by running something similar to the following: `dig
    >RANDOM-SHA.us-east-2.elb.amazonaws.com`.
    >Where `RANDOM-SHA` is the EXTERNAL-IP received for the LoadBalancer. 

1. Select one of the IP addresses returned from the `dig` command and write it to the
`/etc/hosts` file.

## Port forwarding

If you want to use port forwarding instead of the external IP address from the
`LoadBalancer`, follow these steps:

{{> 'partials/scst-store/port-forwarding' }}

## Configure the Insight plug-in

{{> 'partials/cli-plugins/insight-set-target' ingress=false }}
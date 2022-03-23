# Run profile

The following is the YAML file sample for the run-profile:

```yaml
profile: run
ceip_policy_disclosed: true # The value must be true for installation to succeed
supply_chain: basic

cnrs:
  domain_name: INGRESS-DOMAIN

contour:
  envoy:
    service:
      type: LoadBalancer #NodePort can be used if your Kubernetes cluster doesn't support LoadBalancing

appliveview_connector:
  backend:
    sslDisabled: TRUE-OR-FALSE-VALUE
    host: appliveview.APP-LIVE-VIEW-INGRESS-DOMAIN
```

Where:

- `INGRESS-DOMAIN` is the subdomain for the host name that you point at the `tanzu-shared-ingress`
service's external IP address.
- `APP-LIVE-VIEW-INGRESS-DOMAIN` is the subdomain you setup on the View profile cluster. This matches the value key `appliveview.ingressDomain`. Include the default host name `applieview.` ahead of the domain.

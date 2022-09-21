# Iterate profile

The following is the YAML file sample for the iterate-profile:

```yaml
profile: iterate

ceip_policy_disclosed: true

shared:
  kubernetes_distribution: "openshift" # To be passed only for Openshift. Defaults to "".

buildservice:
  kp_default_repository: "TAP-REGISTRY-SERVER/build-service"
  kp_default_repository_username: "TAP-REGISTRY-USER"
  kp_default_repository_password: "TAP-REGISTRY-PASSWORD"
  tanzunet_username: "TANZUNET-REGISTRY-USERNAME"
  tanzunet_password: "TANZUNET-REGISTRY-PASSWORD"
  descriptor_name: "full"
  enable_automatic_dependency_updates: true

supply_chain: basic
ootb_supply_chain_basic:
  registry:
    server: "TAP-REGISTRY-SERVER"
    repository: "supply-chain"
  gitops:
    ssh_secret: ""

metadata_store:
  app_service_type: LoadBalancer

image_policy_webhook:
  allow_unmatched_tags: true

contour:
  envoy:
    service:
      type: LoadBalancer

cnrs:
  domain_name: "TAP-ITERATE-CNRS-DOMAIN"

appliveview_connector:
  backend:
    sslDisabled: TRUE-OR-FALSE-VALUE
    ingressEnabled: true
    host: appliveview.VIEW-CLUSTER-INGRESS-DOMAIN
tap_telemetry:
  customer_entitlement_account_number: "CUSTOMER-ENTITLEMENT-ACCOUNT-NUMBER" # (optional) identify data for creation of TAP usage reports
```

Where:

- `TAP-REGISTRY-SERVER` is the URI of your image registry.
- `TAP-REGISTRY-USER` is the user with write access to your image registry.
- `TAP-REGISTRY-PASSWORD` is the password for your image registry.
- `TANZUNET-REGISTRY-USERNAME` is your user name of the VMware Tanzu Network.
- `TANZUNET-REGISTRY-PASSWORD` is your password of the VMware Tanzu Network.
- `TAP-GITHUB-TOKEN` is your GitHub personal access token.
- `TAP-ITERATE-CNRS-DOMAIN` is the iterate cluster CNRS domain.
- `VIEW-CLUSTER-INGRESS-DOMAIN` is the subdomain you setup on the View profile cluster. This matches the value key `appliveview.ingressDomain` or `shared.ingress_domain` on the view cluster. Include the default host name `appliveview.` ahead of the domain.
- `CUSTOMER-ENTITLEMENT-ACCOUNT-NUMBER` (optional) The Entitlement Account Number (EAN) is a unique identifier VMware assigns to its customers. Tanzu Application Platform telemetry uses this number to identify data that belongs to a particular customers and prepare usage reports. See [Kubernetes Grid documentation](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/1.5/vmware-tanzu-kubernetes-grid-15/GUID-cluster-lifecycle-ceip.html#identify-the-entitlement-account-number-2) for more information about identifying the Entitlement Account Number.

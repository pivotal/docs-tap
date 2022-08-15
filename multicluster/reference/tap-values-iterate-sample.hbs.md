# Iterate profile

The following is the YAML file sample for the iterate-profile:

```yaml
profile: iterate

ceip_policy_disclosed: true

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
```

Where:

- `TAP-REGISTRY-SERVER` is the URI of your image registry.
- `TAP-REGISTRY-USER` is the user with write access to your image registry.
- `TAP-REGISTRY-PASSWORD` is the password for your image registry.
- `TANZUNET-REGISTRY-USERNAME` is your username of the VMware Tanzu Network.
- `TANZUNET-REGISTRY-PASSWORD` is your password of the VMware Tanzu Network.
- `TAP-GITHUB-TOKEN` is your GitHub personal access token.
- `TAP-ITERATE-CNRS-DOMAIN` is the iterate cluster CNRS domain.

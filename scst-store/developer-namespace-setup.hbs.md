# Developer namespace setup

After you've finished the entire TAP installation process, you are ready to configure the developer namespace. When you configure a developer namespace, you need to export the Supply Chain Security Tools (SCST) - Store CA certificate and auth token to the namespace. This will allow SCST - Scan to find the credentials to send scan results to SCST - Store.

There are two ways to to do this,

1. Using the TAP values file
1. Using `SecretExport`

## Using the TAP values file

When deploy TAP Full or Build profile, edit the `tap-values.yaml` file you used to deploy TAP.

```yaml
metadata_store:
  ns_for_export_app_cert: "<DEV-NAMESPACE>"
```

The `ns_for_export_app_cert` currently supports only one namespace at a time. If you have multiple namespaces you can replace this value with a `"*"`, but this is discourage due to security reasons.

```yaml
metadata_store:
  ns_for_export_app_cert: "*"
```

Update TAP to apply the changes,

```bash
$ tanzu package installed update tap -f tap-values.yaml -n tap-install
```

## Using `SecretExport`

You can do this by creating `SecretExport` resources on the developer namespace. Run the following command to create the `SecretExport` resources.

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

* `toNamespaces: [DEV-NAMESPACE]` - Array of namespaces where the secrets are exported to

## Next steps

If you arrived in this guide from [Setting up the Out of the Box Supply Chain with testing and scanning](../scc/ootb-supply-chain-testing-scanning.hbs.md#storing-scan-results), return to that guide and continue with the instructions.
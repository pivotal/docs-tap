# Developer namespace setup

After you've finished the entire TAP installation process, you are ready to configure the developer namespace. When you configure a developer namespace, you need to export the Supply Chain Security Tools (SCST) - Store CA certificate and auth token to the namespace. This will allow SCST - Scan to find the credentials to send scan results to SCST - Store.

There are two ways to to do this, depending on whether you're deploying TAP in a single cluster or multicluster configuration.

1. Single cluster - Using the TAP values file
1. Multicluster - Using `SecretExport`

## Single cluster - Using the TAP values file

When deploy TAP Full or Build profile, edit the `tap-values.yaml` file you used to deploy TAP.

```yaml
metadata_store:
  ns_for_export_app_cert: "<DEV-NAMESPACE>"
```

The `ns_for_export_app_cert` currently supports only one namespace at a time. If you have multiple namespaces you can replace this value with a `"*"`, but this will export the CA to all namespaces so you should consider whether this increased visibility presents a risk.

```yaml
metadata_store:
  ns_for_export_app_cert: "*"
```

Update TAP to apply the changes,

```bash
$ tanzu package installed update tap -f tap-values.yaml -n tap-install
```

## Multicluster - Using `SecretExport`

In a multicluster deployment, you must follow the steps in [Multicluster setup](multicluster-setup.hbs.md). It will walk you through creating secrets and exporting secrets to developer namespaces.

## Next steps

If you arrived in this guide from [Setting up the Out of the Box Supply Chain with testing and scanning](../scc/ootb-supply-chain-testing-scanning.hbs.md#storing-scan-results), return to that guide and continue with the instructions.
# Developer namespace setup

After you finish the entire Tanzu Application Platform installation process, you are ready to configure the developer namespace. When you configure a developer namespace, you must export the Supply Chain Security Tools (SCST) - Store CA certificate and authentication token to the namespace. This allows SCST - Scan to find the credentials to send scan results to SCST - Store.

There are two ways to deploy Tanzu Application Platform: 

1. Single cluster - Using the anzu Application Platform values file
2. Multicluster - Using `SecretExport`

## Single cluster - Using the Tanzu Application Platform values file

When deploy Tanzu Application Platform Full or Build profile, edit the `tap-values.yaml` file you used to deploy Tanzu Application Platform.

```yaml
metadata_store:
  ns_for_export_app_cert: "DEV-NAMESPACE"
```

Where `DEV-NAMESPACE` is the name of the developer namespace.

The `ns_for_export_app_cert` supports one namespace at a time. If you have multiple namespaces you can replace this value with a `"*"`, but this exports the CA to all namespaces. Consider whether this increased visibility presents a risk.

```yaml
metadata_store:
  ns_for_export_app_cert: "*"
```

Update Tanzu Application Platform to apply the changes,

```bash
$ tanzu package installed update tap -f tap-values.yaml -n tap-install
```

## Multicluster - Using `SecretExport`

In a multicluster deployment, you must follow the steps in [Multicluster setup](multicluster-setup.hbs.md). It walks you through creating secrets and exporting secrets to developer namespaces.

## Next steps

If you arrived in this guide from [Setting up the Out of the Box Supply Chain with testing and scanning](../scc/ootb-supply-chain-testing-scanning.hbs.md#storing-scan-results), return to that guide and continue with the instructions.
# Developer namespace setup for Supply Chain Security Tools - Store

This topic describes how you can set up your developer namespace for Supply Chain Security Tools (SCST) - Store.

## Overview

After you finish the entire Tanzu Application Platform installation process, you are ready to
configure the developer namespace.
When you configure a developer namespace, you must export the
Supply Chain Security Tools (SCST) - Store
CA certificate and authentication token to the namespace.
This enables SCST - Scan to find the credentials to send scan results to SCST - Store.

There are two ways to deploy Tanzu Application Platform:

- Single cluster, which entails using the Tanzu Application Platform values file
- Multicluster, which entails using `SecretExport`

## Single cluster - Using the Tanzu Application Platform values file

When deploy the Tanzu Application Platform Full or Build profile, edit the `tap-values.yaml` file you
used to deploy Tanzu Application Platform.

```yaml
metadata_store:
  ns_for_export_app_cert: "DEV-NAMESPACE"
```

Where `DEV-NAMESPACE` is the name of the developer namespace.

The `ns_for_export_app_cert` supports one namespace at a time.
If you have multiple namespaces you can replace this value with a `"*"`, but this exports the CA to
all namespaces. Consider whether this increased visibility presents a risk.

```yaml
metadata_store:
  ns_for_export_app_cert: "*"
```

Update Tanzu Application Platform to apply the changes by running:

```console
$ tanzu package installed update tap -f tap-values.yaml -n tap-install
```

## Multicluster - Using `SecretExport`

In a multicluster deployment, follow the steps in
[Multicluster setup](multicluster-setup.hbs.md).
It describes how to create secrets and export secrets to developer namespaces.

## Next steps

If you arrived in this topic from
[Setting up the Out of the Box Supply Chain with testing and scanning](../scc/ootb-supply-chain-testing-scanning.hbs.md#storing-scan-results),
return to that topic and continue with the instructions.
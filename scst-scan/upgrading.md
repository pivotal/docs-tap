# Upgrade Supply Chain Security Tools - Scan

This document describes how to upgrade Supply Chain Security Tools - Scan from the Tanzu Application Platform package repository.

You can perform a fresh install of Supply Chain Security Tools - Scan by following the instructions in [Install Supply Chain Security Tools - Scan](install-scst-scan.md) 

Here you can find instructions for:

1. [Prerequisites](#)
2. [General Upgrades for Supply Chain Security Tools - Scan](#general-upgrades)
3. Upgrading to:
   1. [Version v1.2.0](#)


## <a id="prereqs"></a> Prerequisites

Before you upgrade Supply Chain Security Tools - Scan:

* Upgrade the Tanzu Application Platform following the instructions in [Upgrading Tanzu Application Platform](../upgrading.md) 

## <a id="general-upgrades"></a> General Upgrades for Supply Chain Security Tools - Scan

When you're upgrading to any version of Supply Chain Security Tools - Scan these are some of the factors you need to keep in top of mind for accomplish this task successfully: 

1. Check the [Release Notes](../release-notes.md) for the version you're upgrading to. There you can find if there is any breaking changes for the installation.
2. Get the values schema for the package version you're upgrading to using `tanzu package available get scanning.apps.tanzu.vmware.com/$VERSION --values-schema -n tap-install` where `$VERSION` is the new version. This will give you insights on the values you can configure in your `tap-values.yaml` for the new version.

## <a id="upgrade-to-1-2-0"></a> Upgrading to Version v1.2.0

If you're upgrading from a previous version of Supply Chain Security Tools - Scan to the version `v1.2.0` you have to follow these steps: 

1. Change the `SecretExports` from Supply Chain Security Tools - Store. 

Supply Chain Security Tools - Scan need information to connect to the Supply Chain Security Tools - Store deployment, we need to change where this secrets are exported to in order to enable the connection with the version `v1.2.0` of Supply Chain Security Tools - Scan.

**Single Cluster Deployment**

Modify the `tap-values.yaml` file you have used to deploy Supply Chain Security Tools - Store to export the ca secret to your developer namespace. 

```yaml
metadata_store:
    ns_for_export_app_cert: "<DEV-NAMESPACE>"
```

>**Note:** The `ns_for_export_app_cert` currently supports only one namespace at a time. If you have multiple namespaces you could replace this value with a `"*"`, but this is discourage due to security reasons.

Now update Tanzu Application Platform to apply the changes:

```console
tanzu package installed update tap -f tap-values.yaml -n tap-install
```

**Multi-Cluster Deployment**

We need to reapply the SecretExport by changing the toNamespace: scan-link-system to toNamespace: `DEV-NAMESPACE`

```yaml
---
apiVersion: secretgen.carvel.dev/v1alpha1
kind: SecretExport
metadata:
  name: store-ca-cert
  namespace: metadata-store-secrets
spec:
  toNamespace: my-apps
---
apiVersion: secretgen.carvel.dev/v1alpha1
kind: SecretExport
metadata:
  name: store-auth-token
  namespace: metadata-store-secrets
spec:
  toNamespace: my-apps
```
 
2. Build profile yaml should be updated as below before the upgrade to 1.2.0 is performed : 

```yaml
scanning:
  metadataStore:
    url: ""
 
grype:
  namespace: "my-apps"
  targetImagePullSecret: "registry-credentials"
  metadataStore:
    url: "https://metadata-store.view.sapna.cloudfocused.in"
    caSecret:
        name: store-ca-cert
        importFromNamespace: metadata-store-secrets
    authSecret:
        name: store-auth-token
        importFromNamespace: metadata-store-secrets
```
 
3. New ScanPolicy should be applied post tap is upgraded to 1.2.0 : 

```yaml
apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
kind: ScanPolicy
metadata:
  name: scan-policy
spec:
  regoFile: |
    package main
 
    # Accepted Values: "Critical", "High", "Medium", "Low", "Negligible", "UnknownSeverity"
    notAllowedSeverities := ["Critical","High","UnknownSeverity"]
    ignoreCves := []
 
    contains(array, elem) = true {
      array[_] = elem
    } else = false { true }
 
    isSafe(match) {
      fails := contains(notAllowedSeverities, match.ratings.rating[_])
      not fails
    }
 
    isSafe(match) {
      ignore := contains(ignoreCves, match.Id)
      ignore
    }
 
    deny[msg] {
      comp := input.bom.components.component[_]
      vuln := comp.vulnerabilities.vulnerability[_]
      ratings := vuln.ratings.rating[_]
      not isSafe(vuln)
      msg = sprintf("CVE %s %s %s", [comp.name, vuln.id, ratings])
    }
```
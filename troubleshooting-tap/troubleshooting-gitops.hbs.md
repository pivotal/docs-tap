# Troubleshoot Tanzu GitOps Reference Implementation (RI)

This topic tells you how to troubleshoot Tanzu GitOps Reference Implementation (commonly known as RI).

## <a id="tanzu-sync-app-error"></a>Tanzu Sync application error

After the Tanzu Sync application is installed in the cluster, the main
resource to check is the sync app in the `tanzu-sync` namespace:

```terminal
kubectl -n tanzu-sync get app/sync --template='\{{.status.usefulErrorMessage}}'
```

Example error:

```terminal
kapp: Error: waiting on reconcile packageinstall/tap (packaging.carvel.dev/v1alpha1) namespace: tap-install:
  Finished unsuccessfully (Reconcile failed:  (message: Error (see .status.usefulErrorMessage for details)))
```

This indicates that the resource `packageinstall/tap` in the namespace `tap-install` failed. 
See the following section for the solution details.

## <a id="tanzu-sync-app-error"></a>Tanzu Application Platform install error

After the Tanzu Sync application is installed in the cluster, the Tanzu Application Platform starts to install. 
The resource to check is the Tanzu Application Platform package install in the `tap-install` namespace:

```terminal
kubectl -n tap-install get packageinstall/tap --template='\{{.status.usefulErrorMessage}}'
```

## <a id="common-errors"></a>Common errors

You might encounter one of the following errors:

### <a id="data-value-not-declared"></a>Given data value is not declared in schema

**Error:** Reconciliation fails with `Given data value is not declared in schema`

```terminal
^ Reconcile failed:  (message: ytt: Error: Overlaying data values (in following order: tap-install/.tanzu-managed/version.yaml, additional data values):
One or more data values were invalid
====================================

Given data value is not declared in schema
tap-values.yaml:
    |
  1 | shared:
    |

    = found: shared
    = expected: a map item with the key named "tap_install" (from tap-install/.tanzu-managed/schema--tap-sensitive-values.yaml:3)
```

**Problem:** The values files were not generated according to the expected schema.

**Solution:** Ensure both non-sensitive and sensitive Tanzu Application Platform values files to adhere 
to the schema described in [configure values](#configure-values).

Incorrect values example:

```yaml
shared:
  ingress_domain: example.vmware.com
```

Correct values example:

```yaml
tap_install:
  values:
    ingress_domain: example.vmware.com
```

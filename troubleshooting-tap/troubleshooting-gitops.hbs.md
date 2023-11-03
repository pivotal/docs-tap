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

### <a id="external-secret-not-found"></a> `ExternalSecret` not found

**Error:** Reconciliation of `ExternalSecret` fails with `secret not found`

Example:

```console
kubectl describe ExternalSecret install-registry-dockerconfig -n tanzu-sync

Status:
  Conditions:
    Last Transition Time:  2023-07-20T08:14:04Z
    Message:               could not get secret data from provider
    Reason:                SecretSyncedError
    Status:                False
    Type:                  Ready
Events:
  Type     Reason        Age                   From              Message
  ----     ------        ----                  ----              -------
  Warning  UpdateFailed  12s (x15 over 6m14s)  external-secrets  secret not found
```

- **Problem 1:** Incorrect secret reference

    **Solution 1:** Ensure the references in `tanzu-sync/app/values/tanzu-sync-vault-values.yaml` and `cluster-config/values/tap-install-vault-values.yaml` are correct.

- **Problem 2:** Incorrect configuration of the secret engine for Vault

    **Solution 2:** Validate and update the version of the Vault secrets engine configuration to `v1` or `v2`. By default, `v2` is chosen.

    Update `tanzu-sync/app/values/tanzu-sync-vault-values.yaml`:

    ```yaml
    ---
    secrets:
      eso:
        vault:
          ...
          version: "v1" # v1 or v2
    ```

    Update `cluster-config/values/tap-install-vault-values.yaml`:

    ```yaml
    ---
    tap_install:
      secrets:
        eso:
          vault:
            ...
            version: "v1" # v1 or v2
    ```

## <a id="delete-k8s-auth-error"></a> Error occurs when deleting Kubernetes authentication

**Problem:** The following error occurs when deleting Kubernetes authentication:

```console
./tanzu-sync/vault/scripts/setup/delete-kubernetes-auth.sh
Error deleting auth/tap-gitops-vault/config: Error making API request.
Namespace: admin/URL: DELETE https://vault-cluster-public-vault-5593a539.8ae01486.z1.hashicorp.cloud:8200/v1/auth/tap-gitops-vault/configCode: 405. Errors:
* 1 error occurred:	* unsupported operation
```

**Solution:** Update the command `vault delete auth/$CLUSTER_NAME/config` to `vault auth disable $CLUSTER_NAME` in the file `./tanzu-sync/vault/scripts/setup/delete-kubernetes-auth.sh`

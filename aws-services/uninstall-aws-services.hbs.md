# Uninstall AWS Services

This topic tells you how to uninstall the AWS Services package from Tanzu Application Platform
(commonly known as TAP).

## <a id="prepare-infra"></a> Step 1: Prepare your infrastructure

Before uninstalling the package, you must decide whether to retain or delete the existing resources that
have been claimed.

Failing to follow one of the following procedures for all of your resources leaves your
Tanzu Application Platform in a state that might prevent you from reinstalling the AWS Services package
in the future.

### <a id="retain-resources"></a> Retain the resources

If you want to keep a resource:

1. Find the Composite Resource associated with your claim by running:

    ```console
    kubectl get classclaim CLASS-CLAIM-NAME -n CLASS-CLAIM-NAMESPACE -ojsonpath="{.status.provisionedResourceRef}"
    ```

    Where:

    - `CLASS-CLAIM-NAME` is the name of the claim.
    - `CLASS-CLAIM-NAMESPACE` is is the namespace the claim is in.

    Example output for a PostgreSQL claim:

    ```json
    {"apiVersion":"aws.database.tanzu.vmware.com/v1alpha1","kind":"XPostgreSQLInstance","name":"rds-2-r4mgc"}
    ```

1. Find the `Instance` associated with the Composite Resource by running:

    ```console
    kubectl get XR-API XR-NAME -ojsonpath="{.spec.resourceRefs}"
    ```

    Where:

    - `XR-API` is in the format `KIND.APIVERSION` using the `kind` and `apiVersion` from the output
       of the previous step. `APIVERSION` is the part of `apiVersion` before the `/`, for example,
       `aws.database.tanzu.vmware.com`.
    - `XR-NAME` is the value of `name` from the output of the previous step.

    For example:

    ```console
    $ kubectl get xpostgresqlinstance.aws.database.tanzu.vmware.com rds-2-r4mgc -ojsonpath="{.spec.resourceRefs}"

    [{"apiVersion":"rds.aws.upbound.io/v1beta1","kind":"Instance","name":"rds-2-r4mgc-zc69h"}]
    ```

1. Open the `Instance` resource for editing by running:

    ```console
    kubectl edit instance.rds.aws.upbound.io INSTANCE-NAME
    ```

    Where `INSTANCE-NAME` is the value of `name` from the output of the previous step.

    For example:

    ```console
    $ kubectl edit instance.rds.aws.upbound.io rds-2-r4mgc-zc69h
    ```

1. Change the `Instance` resource `spec.deletionPolicy` field from `Delete` to `Orphan`:

    ```yaml
    apiVersion: rds.aws.upbound.io/v1beta1
    kind: Instance
    metadata:
      # ...
    spec:
      deletionPolicy: Orphan
      # ...
    ```

1. Save and close your editor.

1. Delete the claim by running:

    ```console
    tanzu service class-claim delete CLAIM-NAME
    ```

### <a id="delete-resources"></a> Delete the resources

If you want to delete a resource:

1. Delete the corresponding claim by running:

    ```console
    tanzu service class-claim delete CLAIM-NAME
    ```

1. Wait for the resource to disappear in the AWS console.

## <a id="uninstall-package"></a> Step 2: Uninstall the AWS Services package

To uninstall the AWS Services package:

1. Confirm that you have the AWS Services package installed by running:

    ```console
    tanzu package installed list -A
    ```

1. Search the `PACKAGE-NAME` column of the output for `aws.services.tanzu.vmware.com`, and record the
   name and namespace.

1. Uninstall the package:

    ```console
    tanzu package installed delete PACKAGE-NAME -n PACKAGE-NAMESPACE
    ```

    Where `PACKAGE-NAME` and `PACKAGE-NAMESPACE` are the values you recorded in the previous step.

    For example:

    ```console
    $ tanzu package installed delete aws-services -n tap-install
    ```

## <a id="delete-providerconfig"></a> Step 3: Delete the `ProviderConfig`

You must delete the `ProviderConfig` you created after installing the AWS Services package to complete
the uninstall.

Crossplane installs a finalizer when the `ProviderConfig` is created. To delete the `ProviderConfig`
you must remove the finalizer.
If you don't do this step, the `ProviderConfig` and its related Custom Resource Definition (CRD)
remain in the cluster and prevent you from reinstalling the package in the future.

1. Open the `ProviderConfig` resource for editing by running:

    ```console
    kubectl edit providerconfig.aws.upbound.io PROVIDER-CONFIG-NAME
    ```

    Where `PROVIDER-CONFIG-NAME` is the name you chose for your `ProviderConfig`.

1. In the `ProviderConfig`:

    1. Record the name and namespace of the `Secret` referenced in `spec.credentials`.
    1. Delete the `metadata.finalizers` entry. This allows the `ProviderConfig` to be deleted.

1. Save and close your editor. The `ProviderConfig` is automatically deleted.

1. Verify the `ProviderConfig` has been removed by running:

    ```console
    kubectl get providerconfig.aws.upbound.io
    ```

    The expected output is an error message like this:

    ```console
    Error from server (NotFound): Unable to list "aws.upbound.io/v1beta1, Resource=providerconfigs": the server could not find the requested resource (get providerconfigs.aws.upbound.io)
    ```

1. Delete the `Secret` by running:

    ```console
    kubectl delete secret SECRET-NAME -n SECRET-NAMESPACE
    ```

    Where `SECRET-NAME` and `SECRET-NAMESPACE` are the values you recorded earlier.

# Uninstall AWS Services

This topic tells you how to uninstall the AWS Services package from the Tanzu Application Platform (commonly
known as TAP) package repository.

## <a id="prepare-infra"></a> Step 1: Prepare your infrastructure

Before uninstalling the package, you will have to decide what to do with the existing resources you have
claimed.

* In case you want to keep a resource:

  1. Find the Composite Resource associated to your claim:

    ```console
    kubectl get classclaim <CLASS-CLAIM-NAME> -n <CLASS-CLAIM-NAMESPACE> -ojsonpath="{.status.provisionedResourceRef}"
    ```

    For example, for a PostgreSQL claim the output will look like this:

    ```json
    {"apiVersion":"aws.database.tanzu.vmware.com/v1alpha1","kind":"XPostgreSQLInstance","name":"rds-1-r4mgc"}
    ```

  1. Find the `Instance` associated to the Composite Resource:

      ```console
      kubectl get <XR-API> <XR-NAME> -ojsonpath="{.spec.resourceRefs}"
      ```

      For the example above:

      ```console
      kubectl get xpostgresqlinstance.aws.database.tanzu.vmware.com rds-2-r4mgc -ojsonpath="{.spec.resourceRefs}"
      ```

      Which will output:

      ```json
      [{"apiVersion":"rds.aws.upbound.io/v1beta1","kind":"Instance","name":"rds-2-r4mgc-zc69h"}]
      ```

  1. Edit the `Instance`:

      ```console
      kubectl edit instance.rds.aws.upbound.io <INSTANCE-NAME>
      ```

      For the example above:

      ```console
      kubectl edit instance.rds.aws.upbound.io rds-2-r4mgc-zc69h
      ```

  1. Change the resource `deletionPolicy` from `Delete` to `Orphan`:

      ```yaml
      apiVersion: rds.aws.upbound.io/v1beta1
      kind: Instance
      metadata:
        # ...
      spec:
        deletionPolicy: Orphan
        # ...
      ```

  1. Delete the claim:

      ```console
      tanzu service class-claim delete <CLAIM-NAME>
      ```

* In case you want to get rid of a resource:

  1. Delete the corresponding claim:

      ```console
      tanzu service class-claim delete <CLAIM-NAME>
      ```

  1. Wait for the resource to disappear in the AWS console.

Failing to perform the steps above for all your resources will leave your TAP
in a dirty state which might prevent you from reinstalling the AWS Services
package in the future.

## <a id="uninstall-package"></a> Step 2: Uninstall the AWS Services package

To uninstall the AWS Services package:

1. Confirm that you have the AWS Services package installed by running:

    ```console
    tanzu package installed list -A
    ```

1. Take note of the name and namespace for the package with `aws.services.tanzu.vmware.com` as the
   `PACKAGE-NAME`.
1. Uninstall the package:

    ```console
    tanzu package installed delete <PACKAGE-NAME> -n <PACKAGE-NAMESPACE>
    ```

    Assuming you have followed our [install instructions](./install-aws-services.hbs.md#install-package), the
    command will be:

    ```console
    tanzu package installed delete aws-services -n tap-install
    ```

## <a id="delete-providerconfig"></a> Step 3: Delete the `ProviderConfig`

You will have to delete the `ProviderConfig` you created after installing the package to allow the
uninstallation to finalize.
Unfortunately, the `ProviderConfig` gets a finalizer installed by Crossplane as soon as it's created: in order
to delete it, we'll have to remove the finalizer first.
If you don't perform this step, the `ProviderConfig` and its related CRD will hang around in the cluster and
prevent you from reinstalling the package in the future.

1. Edit the `ProviderConfig`:
    
    ```console
    kubectl edit providerconfig.aws.upbound.io <PROVIDER-CONFIG-NAME>
    ```

1. Take note of the `Secret` referenced by `spec.credentials`.
1. Delete the `metadata.finalizers` entry.
1. Verify the `ProviderConfig` has disappeared.

    ```console
    kubectl get providerconfig.aws.upbound.io
    ```

    You should see an error like this:

    ```console
    Error from server (NotFound): Unable to list "aws.upbound.io/v1beta1, Resource=providerconfigs": the server could not find the requested resource (get providerconfigs.aws.upbound.io)
    ```

1. Delete the `Secret`:

    ```console
    kubectl delete secret <SECRET-NAME> -n <SECRET-NAMESPACE>

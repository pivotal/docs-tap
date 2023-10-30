# Upgrading to Tanzu Kubernetes releases v1.26 or later

This topic describes how to update your existing Bitnami Services instances if you upgraded to
Tanzu Kubernetes releases v1.26 and later.

Tanzu Kubernetes releases v1.26 and later enforces a [restricted Pod Security Standard (PSS)](https://kubernetes.io/docs/concepts/security/pod-security-standards/#restricted)
for all pods running on the cluster.
This change affects your running Bitnami services.

New services claimed on Tanzu Application Platform v1.7 run with no issues in a restricted PSS.
Existing services claimed on Tanzu Application Platform v1.6 will fail to start.

To resolve the issue for existing instances on Tanzu Application Platform 1.7,
you must update CompositionRevision references for any existing Bitnami Services instances.

## <a id="update"></a>Update existing services

To repair your existing services, upgrade their corresponding managed resources to the latest composition
revision:

1. Find the managed resource associated with your claim by running:

    ```console
    kubectl get classclaim CLASS-CLAIM-NAME -n CLASS-CLAIM-NAMESPACE -ojsonpath="{.status.provisionedResourceRef}"
    ```

    Where:

    - `CLASS-CLAIM-NAME` is the name of your claim.
    - `CLASS-CLAIM-NAMESPACE` is the namespace your claim is in.

    Example output for a MongoDB claim:

    ```json
    {"apiVersion":"bitnami.database.tanzu.vmware.com/v1alpha1","kind":"XMongoDBInstance","name":"mongodb-zfjr5"}
    ```

1. Find the newest composition revision for your resource type by running:

    ```console
    kubectl get compositionrevisions
    ```

    Example output:

    ```console
    NAME                                                             REVISION   XR-KIND               XR-APIVERSION                                 AGE
    ...
    xmongodbinstances.bitnami.database.tanzu.vmware.com-734d138      4          XMongoDBInstance      bitnami.database.tanzu.vmware.com/v1alpha1    3h4m
    xmongodbinstances.bitnami.database.tanzu.vmware.com-889eaeb      1          XMongoDBInstance      bitnami.database.tanzu.vmware.com/v1alpha1    3h29m
    xmongodbinstances.bitnami.database.tanzu.vmware.com-d869e8c      2          XMongoDBInstance      bitnami.database.tanzu.vmware.com/v1alpha1    3h29m
    xmongodbinstances.bitnami.database.tanzu.vmware.com-f1f3fe9      3          XMongoDBInstance      bitnami.database.tanzu.vmware.com/v1alpha1    3h5m
    ...
    ```

    Record the name of the highest revision. In the above output, this is
    revision 4 (`xmongodbinstances.bitnami.database.tanzu.vmware.com-734d138`).

1. Open your managed resource for editing by running:

    ```console
    kubectl edit RESOURCE-API RESOURCE-NAME
    ```

    Where:

    - `RESOURCE-API` is in the format `KIND.APIVERSION` using the `kind` and `apiVersion` from the output
       of the `kubectl get classclaim` command earlier. `APIVERSION` is the part of `apiVersion`
       before the `/`, for example, `bitnami.database.tanzu.vmware.com`.
    - `RESOURCE-NAME` is the value of `name` from the output of the `kubectl get classclaim` command earlier.

    For example:

    ```console
    $ kubectl edit xmongodbinstance.bitnami.database.tanzu.vmware.com mongodb-zfjr5
    ```

1. Change the resource `compositionRevisionRef` to point to the new composition revision. For example:

    ```yaml
    apiVersion: bitnami.database.tanzu.vmware.com/v1alpha1
    kind: XMongoDBInstance
    metadata:
      # ...
    spec:
      compositionRef:
        name: xmongodbinstances.bitnami.database.tanzu.vmware.com
      compositionRevisionRef:
        name: xmongodbinstances.bitnami.database.tanzu.vmware.com-734d138
    ```

1. Save and close your editor.

1. Verify that the resource is ready by running:

    ```console
    kubectl get RESOURCE-API RESOURCE-NAME
    ```

    For example:

    ```console
    $ kubectl get xmongodbinstance.bitnami.database.tanzu.vmware.com mongodb-zfjr5

    NAME            SYNCED   READY   COMPOSITION                                           AGE
    mongodb-zfjr5   True     True    xmongodbinstance.bitnami.database.tanzu.vmware.com   3h24m
    ```

# Upgrading to TKR 1.26 or newer

The newest version of TKR enforce a [`restricted` Pod Security
Standard](https://kubernetes.io/docs/concepts/security/pod-security-standards/#restricted) for all pods
running on the cluster. This will have an impact on your running Bitnami services. In this topic we explore
possible solutions to this problem.

## <a id="tap-17"></a>If upgrading to TAP 1.7

New Bitnami services claimed on TAP 1.7 will run with no issues in a `restricted` PSS.

Existing Bitnami services claimed on TAP 1.6 will instead fail to start.
In order to get your services back to running, you will need to upgrade their corresponding Managed Resources
to the latest composition revision available.

1. Find the Managed Resource associated to your claim:

    ```console
    kubectl get classclaim <CLASS-CLAIM-NAME> -n <CLASS-CLAIM-NAMESPACE> -ojsonpath="{.status.provisionedResourceRef}"
    ```

    For example, for a MongoDB claim the output will look like this:

    ```json
    {"apiVersion":"bitnami.database.tanzu.vmware.com/v1alpha1","kind":"XMongoDBInstance","name":"mongodb-zfjr5"}
    ```

1. Find the newest composition revision for your resource type:

    ```console
    kubectl get compositionrevisions
    ```

    In our example:

    ```
    NAME                                                             REVISION   XR-KIND               XR-APIVERSION                                 AGE
    ...
    xmongodbinstances.bitnami.database.tanzu.vmware.com-734d138      4          XMongoDBInstance      bitnami.database.tanzu.vmware.com/v1alpha1    3h4m
    xmongodbinstances.bitnami.database.tanzu.vmware.com-889eaeb      1          XMongoDBInstance      bitnami.database.tanzu.vmware.com/v1alpha1    3h29m
    xmongodbinstances.bitnami.database.tanzu.vmware.com-d869e8c      2          XMongoDBInstance      bitnami.database.tanzu.vmware.com/v1alpha1    3h29m
    xmongodbinstances.bitnami.database.tanzu.vmware.com-f1f3fe9      3          XMongoDBInstance      bitnami.database.tanzu.vmware.com/v1alpha1    3h5m
    ...
    ```

    Take note of the name of the *highest* revision. In our example, this is
    revision 4 (`xmongodbinstances.bitnami.database.tanzu.vmware.com-734d138`).

1. Edit your managed resource:

    ```console
    kubectl edit <RESOURCE-API> <RESOURCE-NAME>
    ```

    In our example: 

    ```console
    kubectl edit xmongodbinstances.bitnami.database.tanzu.vmware.com mongodb-zfjr5
    ```

1. Change the resource `compositionRevisionRef` to point to the new composition revision. In our example:

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

1. Check that the resource is ready again:

    ```console
    kubectl get <RESOURCE-API> <RESOURCE-NAME>
    ```

    In our example: 

    ```console
    kubectl get xmongodbinstances.bitnami.database.tanzu.vmware.com mongodb-zfjr5
    ```

    The output is:

    ```console
    NAME            SYNCED   READY   COMPOSITION                                           AGE
    mongodb-zfjr5   True     True    xmongodbinstances.bitnami.database.tanzu.vmware.com   3h24m
    ```

## <a id="tap-16"></a>If staying on TAP 1.6 or older

Services claimed in TAP 1.6 won't be able to start on TKR 1.26.
We recommend a workaround based on mutating pods via a mutating webhook. For example, using
[Kyverno](https://kyverno.io/), the following `ClusterPolicy` will apply the necessary modifications to every
pod created on the cluster:

```yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: set-security-context
spec:
  rules:
    - name: set-security-context
      match:
        any:
        - resources:
            kinds:
            - Pod
            selector:
              matchExpressions:
              - key: app.kubernetes.io/name
                operator: In
                values:
                - kafka
                - mongodb
                - mysql
                - postgresql
                - rabbitmq
                - redis
      mutate:
        patchStrategicMerge:
          spec:
            containers:
              - (name): "*"
                securityContext:
                  allowPrivilegeEscalation: false
                  runAsNonRoot: true
                  seccompProfile:
                    type: RuntimeDefault
                  capabilities:
                    drop: ['ALL']
            initContainers:
              - (name): "*"
                securityContext:
                  allowPrivilegeEscalation: false
                  runAsNonRoot: true
                  seccompProfile:
                    type: RuntimeDefault
                  capabilities:
                    drop: ['ALL']
            ephemeralContainers:
              - (name): "*"
                securityContext:
                  allowPrivilegeEscalation: false
                  runAsNonRoot: true
                  seccompProfile:
                    type: RuntimeDefault
                  capabilities:
                    drop: ['ALL']
```

It might be necessary to trigger the reconciliation of `ReplicaSet`s or `StatefulSet`s that have failed in the
past by modifying them, for example adding a label.

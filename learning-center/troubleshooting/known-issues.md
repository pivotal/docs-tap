# Learning Center known issues

This section includes a list of known issues with troubleshooting and recovery steps
for Learning Center.

## <a id="training-portal-pending"></a>Training portal stays in pending state

The training portal stays in a "pending" state.

### Explanation

The TLS secret `tls` is not available.

### Solution

1. Access the operator logs by running:

    ```
    kubectl logs deployment/learningcenter-operator -n learningcenter
    ```
    
1. Observe that the TLS secret `tls` is not available. The TLS secret should be on the Learning
    Center operator namespace. If the TLS secret is not on the Learning Center operator namespace,
    the operator logs contain the following error:

    ```
    ERROR:kopf.objects:Handler 'learningcenter' failed temporarily: TLS secret tls is not available
    ```

1. Follow the steps in
    [Enforcing Secure Connections](learning-center/getting-started/learning-center-operator.html#enforce-secure-connect)
    in _Learning Center Operator_ to create the TLS secret.

1. Redeploy the `trainingPortal` resource.

### <a id="image-policy-webhook-service-not-found"></a>image-policy-webhook-service not found

If you are installing a TAP profile, perhaps you are going to get this error.

```
Internal error occurred: failed calling webhook "image-policy-webhook.signing.run.tanzu.vmware.com": failed to call webhook: Post "https://image-policy-webhook-service.image-policy-system.svc:443/signing-policy-check?timeout=10s": service "image-policy-webhook-service" not found
```

#### Solution:
This is a race condition error among some packages, to recover from this error you only need to redeploy the trainingPortal resource.

## <a id="update-parameters"></a>Updating parameters don't work

Normally you will need to update some parameters provided to the Learning Center Operator (E.g. ingressDomain, TLS secret, ingressClass etc), depending the way you used to change the values, you can execute these commands to validate if the parameters were changed:

```
kubectl describe systemprofile
```
or
```
kubectl describe pod  -n learningcenter
```

However, the Training Portals doesn't work or get the updated values.

#### Solution:
By design, the Training Portal resources do not react to any changes on the parameters provided when the training portals were created, because any change on the `trainingportal` resource affects the online user who is running a workshop. To get the new values, you must redeploy the `trainingportal` in a maintenance window where learning center is unavailable while the `systemprofile` gets updated.

## <a id="increase-cluster-resources"></a>Increase your cluster's resources

If you don't have enough nodes or enough resources on nodes for deploying the workloads, node pressure might occur.
In this case, follow your cloud provider's instructions on how to scale out or scale up your cluster.

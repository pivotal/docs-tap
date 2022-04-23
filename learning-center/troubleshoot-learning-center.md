# Troubleshoot Learning Center

This section includes a list of known issues with troubleshooting and recovery steps
for Learning Center.

## <a id="training-portal-pending"></a>Training portal stays in pending state

The training portal stays in a "pending" state.

**Explanation**

The TLS secret `tls` is not available.

**Solution**

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
    [Enforcing Secure Connections](getting-started/learning-center-operator.html#enforce-secure-connect)
    in _Learning Center Operator_ to create the TLS secret.

1. Redeploy the `trainingPortal` resource.

## <a id="img-pol-wbhk-srvc-nt-fnd"></a>image-policy-webhook-service not found

You are installing a TAP profile and you get this error:

```
Internal error occurred: failed calling webhook "image-policy-webhook.signing.run.tanzu.vmware.com": failed to call webhook: Post "https://image-policy-webhook-service.image-policy-system.svc:443/signing-policy-check?timeout=10s": service "image-policy-webhook-service" not found
```

**Explanation**

This is a race condition error among some packages.

**Solution**

To recover from this error you only need to redeploy the trainingPortal resource.

## <a id='cannot-update-parameters'></a> Cannot update parameters

The training portals do not work or do not show updated parameters.

Run one of the following commands to validate changes made to parameters provided to the Learning
Center Operator. These parameters include ingressDomain, TLS secret, ingressClass, and others.

Command:

```
kubectl describe systemprofile
```

Command:

```
kubectl describe pod  -n learningcenter
```

**Explanation**

By design, the training portal resources do not react to any changes on the parameters provided
when the training portals were created. This prevents any change on the `trainingportal` resource
from affecting any online user running a workshop.

**Solution**

Redeploy `trainingportal` in a maintenance window where Learning Center is unavailable while the
`systemprofile` is updated.


## <a id="increase-cluster-rsrcs"></a>Increase your cluster's resources

If you don't have enough nodes or enough resources on nodes for deploying the workloads, node pressure might occur.
In this case, follow your cloud provider's instructions on how to scale out or scale up your cluster.

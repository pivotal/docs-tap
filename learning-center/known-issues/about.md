# Learning Center - Known Issues

This section is a list of known issues with troubleshooting and recovery steps
for Learning Center.

## Training Portal in pending state

Under certain circumstances, the training portal will be stuck in a pending state, the best way to know the issue
is viewing the operator logs. In order to get the logs, you can execute:

```
kubectl logs deployment/learningcenter-operator -n learningcenter
```

Depending on the log, the issue may be:

### TLS secret tls is not available

The TLS secret should be on the Learning Center operator namespace, otherwise you will get this error: 

```
ERROR:kopf.objects:Handler 'learningcenter' failed temporarily: TLS secret tls is not available
```

#### Solution:
To recover from this issue, you can follow [these steps](../getting-started/learningcenter-operator.md#enforcing-secure-connections) 
to create the TLS Secret, once the TLS is created **you need to redeploy the TrainingPortal resource.** 

### image-policy-webhook-service not found

If you are installing a TAP profile, perhaps you are going to get this error.

```
Internal error occurred: failed calling webhook "image-policy-webhook.signing.run.tanzu.vmware.com": failed to call webhook: Post "https://image-policy-webhook-service.image-policy-system.svc:443/signing-policy-check?timeout=10s": service "image-policy-webhook-service" not found
```

#### Solution:
This is a race condition error among some packages, to recover from this error you only need to redeploy the trainingPortal resource.

## Updating parameters don't work

Normally you will need to update some parameters provided to the Learning Center Operartor (E.g. ingressDomain, TLS secret, ingressClass etc), 
depending the way you used to change the values, you can execute these commands to validate if the parameters were changed:

```
kubectl describe systemprofile
```
or
```
kubectl describe pod  -n learningcenter
```

But the Training Portals doesn't work or get the updated values.

#### Solution:
By design, the Training Portal resources will not react to any changes on the parameters provided when the training portals were created. 
This is because any change on the trainingportal resource will affect to any online user who is running a workshop. 
To get the new values, you will need to redeploy the trainingportal in a maintenance window where learning center is unavailable while the systemprofile gets updated.

## Increase your cluster's resources

Node pressure may be caused by not enough nodes or not enough resources on nodes
for deploying the workloads you have. In this case, follow your cloud provider
instructions on how to scale out or scale up your cluster.

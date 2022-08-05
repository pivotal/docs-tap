# Troubleshoot Learning Center

This section includes a list of known issues with troubleshooting and recovery steps
for Learning Center.

## <a id="training-portal-pending"></a>Training portal stays in pending state

The training portal stays in a "pending" state.

The Training Portal custom resource (CR) has a status property. To see the status, run:

```console
kubectl get trainingportals.learningcenter.tanzu.vmware.com
```

**Explanation**

If the status stays in a pending state, the TLS secret `tls` might not be available. Other errors can also cause the status to stay in a pending state, so it is important to check the operator and portal logs to execute the right steps.

**Solution**

1. Access the operator logs by running:

    ```console
    kubectl logs deployment/learningcenter-operator -n learningcenter
    ```

    Access the portal logs by running:

    ```console
    kubectl logs deployment/learningcenter-portal -n {PORTAL_NAMESPACE}
    ```

1. Check whether the TLS secret `tls` is available. The TLS secret must be on the Learning Center operator namespace (by default `learningcenter`). If the TLS secret is not on the Learning Center operator namespace, the operator logs contain the following error:

    ```console
    ERROR:kopf.objects:Handler 'learningcenter' failed temporarily: TLS secret tls is not available
    ```

1. Follow the steps in
    [Enforcing Secure Connections](getting-started/learning-center-operator.html#enforce-secure-connect)
    in _Learning Center Operator_ to create the TLS secret.

1. Redeploy the `trainingPortal` resource.

## <a id="img-pol-wbhk-srvc-nt-fnd"></a>image-policy-webhook-service not found

You are installing a Tanzu Application Platform profile and you get this error:

```console
Internal error occurred: failed calling webhook "image-policy-webhook.signing.run.tanzu.vmware.com": failed to call webhook: Post "https://image-policy-webhook-service.image-policy-system.svc:443/signing-policy-check?timeout=10s": service "image-policy-webhook-service" not found
```

**Explanation**

This is a race condition error among some Tanzu Application Platform packages.

**Solution**

To recover from this error you only need to redeploy the trainingPortal resource.

## <a id='cannot-update-parameters'></a>Updates to Tanzu Application Platform values file not reflected in Learning Center Training Portal

If you installed Learning Center through Tanzu profiles, then your installation made use of a tap_values.yaml file where configurations were specified for Learning Center. If you make updates to these configurations using this command:

```
tanzu package installed update tap --package-name tap.tanzu.vmware.com --version {VERSION} -f tap-values.yml -n tap-install
```

then the changes are not reflected in the deployed Learning Center Training Portal resource. Tap package updates currently `DO NOT` update running Learning Center Training Portal resources.

Run one of these commands to validate changes made to parameters provided to the Learning
Center Operator. These parameters include ingressDomain, TLS secret, ingressClass, and others.

Command:

```console
kubectl describe systemprofile
```

Command:

```console
kubectl describe pod  -n learningcenter
```

**Explanation**

By design, the training portal resources do not react to any changes on the parameters provided
when the training portals were created. This prevents any change on the `trainingportal` resource
from affecting any online user running a workshop.

***Solution***

You must restart the operator resource by first deleting the operator pod:

```
kubectl delete pod -n learningcenter learningcenter-operator-$OPERATOR_POD_NAME
```

Then delete the training portal resource. Redeploy `trainingportal` in a maintenance window where Learning Center is unavailable while the`systemprofile` is updated.


## <a id="increase-cluster-rsrcs"></a>Increase your cluster's resources

If you don't have enough nodes or enough resources on nodes for deploying the workloads, node pressure might occur.
In this case, follow your cloud provider's instructions on how to scale out or scale up your cluster.

## <a id="kub-api-timeout"></a>Kubernetes Api Timeout error

The following operator error log means there is a connection error with the Kubernetes API server:

```
operator-log: unexpected error occurred. Read timed out.
```

This error has been found when running Learning Center with the Azure AkS cloud provider.

***Solution***

To fix this error:

1. Delete the operator pod on the learningcenter namespace.
2. Delete the training portal once the operator is running again by using:

```
kubectl delete trainingportals $PORTAL_NAME
```

3. Redeploy the `trainingPortal` resource.

## <a id="missing-training-portal-url"></a>No URL returned to your trainingportal

After deploying the Learning Center Operator and Trainingportal resources, the following command can yield the resource with no URL, even though your resources deployed correctly and are running:

```
kubectl get trainingportals
```

You also already specified learningcenter.mydomain.com in your tap values YAML file if installed through Tanzu Application Platform. See [specifying ingress domain](./getting-started/learning-center-operator.md#ingress-domain)

***Solution***

Learning center requires that you use a wildcard domain (Wildcard DNS entry) to access your training portal in the browser. This configuration must be done in your DNS provider with a rule that points your wildcard domain to your IP/Load balancer.

For example, if using the default workshop on an Elastic Kubernetes Service (EKS) cluster, your URL could look something like:

`learning-center-guided.learningcenter.yourdomain.com`

Where learningcenter.yourdomain.com needs a DNS configuration made to point to your default ingress controller. 

In this case, the wildcard domain configuration needed is `*.learningcenter.yourdomain.com`.

After this configuration is made, you might need to restart your operator resource by deleting and redeploying to see the URL update.

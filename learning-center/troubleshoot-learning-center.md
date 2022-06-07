# Troubleshoot Learning Center

This section includes a list of known issues with troubleshooting and recovery steps
for Learning Center.

## <a id="training-portal-pending"></a>Training portal stays in pending state

The training portal stays in a "pending" state.

**Explanation**

The TLS secret `tls` is not available.

**Solution**

1. Access the operator logs by running:

    ```console
    kubectl logs deployment/learningcenter-operator -n learningcenter
    ```

1. Observe that the TLS secret `tls` is not available. The TLS secret should be on the Learning
    Center operator namespace. If the TLS secret is not on the Learning Center operator namespace,
    the operator logs contain the following error:

    ```console
    ERROR:kopf.objects:Handler 'learningcenter' failed temporarily: TLS secret tls is not available
    ```

1. Follow the steps in
    [Enforcing Secure Connections](getting-started/learning-center-operator.html#enforce-secure-connect)
    in _Learning Center Operator_ to create the TLS secret.

1. Redeploy the `trainingPortal` resource.

## <a id="img-pol-wbhk-srvc-nt-fnd"></a>image-policy-webhook-service not found

You are installing a TAP profile and you get this error:

```console
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

**Solution**

Redeploy `trainingportal` in a maintenance window where Learning Center is unavailable while the
`systemprofile` is updated.


## <a id="increase-cluster-rsrcs"></a>Increase your cluster's resources

If you don't have enough nodes or enough resources on nodes for deploying the workloads, node pressure might occur.
In this case, follow your cloud provider's instructions on how to scale out or scale up your cluster.

## <a id="kub-api-timeout"></a>Kubernetes Api Timeout error

If you come across the following operator error log:

```
operator-log: unexpected error occurred. Read timed out.
```

there is a connection error with the Kubernetes API server. This error has been found when running Learning Center with the Azure AkS cloud provider.

***Solution***

To solve do the following:
1. delete the operator pod on the learningcenter namespace.
2. delete the training portal once the operator is running again using:
```
kubectl delete trainingportals $PORTAL_NAME
```
3. Redeploy the `trainingPortal` resource.

## <a id="missing-training-portal-url"></a>No URL returned to your trainingportal

After deploying the Learning Center Operator and Trainingportal resources you notice the following command:

```
kubectl get trainingportals
```
yields the resource with no url but your resources deployed correctly and are running.

You also already specified learningcenter.mydomain.com in your tap values yaml file if installed via tap.

See [specifying ingress domain](./getting-started/learning-center-operator.md#ingress-domain)

***Solution***

Learning center requires the usage of a wildcard domain(Wildcard DNS entry) to access your training portal in the browser. This configuration needs to be done in your DNS provider with a rule that points your wildcard domain to your IP/Load balancer.

For example if using the default workshop on an eks cluster your URL could look something like:

learning-center-guided.learningcenter.yourdomain.com

where learningcenter.yourdomain.com would need a DNS configuration made to point to your default ingress controller. 

In this case the wildcard domain configuration needed would be *.learningcenter.yourdomain.com

Once this configuration is made you may need to restart your operator resource by deleting and redeploying to see the url update.

## <a id="updating-tap-values"></a>Updates to tap values not reflected in Learning Center Operator

If you installed Learning Center via Tanzu profiles then your instalation made use of a tap_values.yaml file where configurations were specified for Learning Center. If you make updates to these configurations using 

```
tanzu package installed update tap --package-name tap.tanzu.vmware.com --version {VERSION} -f tap-values.yml -n tap-install
```
the changes would not be reflected in the deployed Learning Center Operator. Tap package updates currently `DO NOT` update running Learning Center resources.

***Solution***
You must restart the operator resource by first deleting the operator pod

```
kubectl delete pod -n learningcenter learningcenter-operator-$OPERATOR_POD_NAME
```
and then deleting the training portal resource. You must then redeploy the trainingportal resource.
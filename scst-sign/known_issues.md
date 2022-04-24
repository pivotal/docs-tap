# Supply Chain Security Tools - Sign Known Issues

This section is a list of known issues with troubleshooting and recovery steps
for Supply Chain Security Tools - Sign.

## <a id='sign-known-issues-pods-not-admitted'></a> MutatingWebhookConfiguration prevents pods from being admitted

Under certain circumstances, if the `image-policy-controller-manager` deployment
pods do not start up before the `MutatingWebhookConfiguration` is applied to the
cluster, it can prevent the admission of all pods.

For example, pods can be prevented from starting if nodes in a cluster are
scaled to zero and the webhook is forced to restart at the same time as
other system components. A deadlock can occur when some components expect the
webhook to verify their image signatures and the webhook is not running yet.

### Symptoms

You will see a message similar to the following in your `ReplicaSet` statuses:

```bash
Events:
  Type     Reason            Age                   From                   Message
  ----     ------            ----                  ----                   -------
  Warning  FailedCreate      4m28s (x18 over 14m)  replicaset-controller  Error creating: Internal error occurred: failed calling webhook "image-policy-webhook.signing.run.tanzu.vmware.com": Post "https://image-policy-webhook-service.image-policy-system.svc:443/signing-policy-check?timeout=10s": no endpoints available for service "image-policy-webhook-service"
```

### Solution

By deleting the `MutatingWebhookConfiguration` resource, you can resolve the
deadlock and enable the system to start up again. Once the system is stable,
you can restore the `MutatingWebhookConfiguration` resource to re-enable image
signing enforcement.

> **Important**: the steps below will temporarily disable signature verification
> in your cluster.

To do so:

1. Backup the `MutatingWebhookConfiguration` to a file by running the following
command:
    ```shell
    kubectl get MutatingWebhookConfiguration image-policy-mutating-webhook-configuration -o yaml > image-policy-mutating-webhook-configuration.yaml
    ```

1. Delete the `MutatingWebhookConfiguration`:
    ```shell
    kubectl delete MutatingWebhookConfiguration image-policy-mutating-webhook-configuration
    ```

1. Wait until all components are up and running in your cluster, including the
`image-policy-controller-manager` pods (namespace `image-policy-system`).

1. Re-apply the `MutatingWebhookConfiguration`:
    ```shell
    kubectl apply -f image-policy-mutating-webhook-configuration.yaml
    ```

## Priority class of webhook's pods may preempt less privileged pods

This component uses a privileged `PriorityClass` to start up its pods in order
to prevent node pressure from preempting its pods. However, this can cause other
less privileged components to have their pods preempted or evicted instead.

### Symptoms

You will see events similar to this in the output of `kubectl get events`:

```shell
$ kubectl get events
LAST SEEN   TYPE      REASON             OBJECT               MESSAGE
28s         Normal    Preempted          pod/testpod          Preempted by image-policy-system/image-policy-controller-manager-59dc669d99-frwcp on node test-node
```

### Solution

#### Reduce the amount of pods deployed by the Sign component

In case your deployment of the Sign component is running more pods than
necessary, you may scale the deployment down. To do so:

1. Create a values file called `scst-sign-values.yaml` with the following
contents:
    ```yaml
    ---
    replicas: N
    ```
    where N should be the smallest amount of pods you can have for your current
    cluster configuration.

1. Apply your new configuration by running:
    ```shell
    tanzu package installed update image-policy-webhook \
      --package-name image-policy-webhook.signing.run.tanzu.vmware.com \
      --version 1.0.0-beta.2 \
      --namespace tap-install \
      --values-file scst-sign-values.yaml
    ```

1. It may take a few minutes until your configuration takes effect in the cluster.

#### Increase your cluster's resources

Node pressure may be caused by not enough nodes or not enough resources on nodes
for deploying the workloads you have. In this case, follow your cloud provider
instructions on how to scale out or scale up your cluster.

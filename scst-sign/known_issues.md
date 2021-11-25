# Supply Chain Security Tools - Sign Known Issues

This section aims to be a comprehensive list of known issues, along with
troubleshooting and recovery steps for Supply Chain Security Tools - Sign.

## <a id='sign-known-issues-pods-not-admitted'></a> MutatingWebhookConfiguration prevents pods from being admitted

Under certain circumstances, if the `image-policy-controller-manager` deployment
pods do not start up before the `MutatingWebhookConfiguration` is applied to the
cluster, it can prevent the admission of all pods.

For example, pods can be prevented from starting if nodes in a cluster are
scaled to zero and the webhook is forced to restart at the same time as
other system components. A deadlock can occur when some components expect the
webhook to run in order to verify their image signatures and the webhook is not
running yet.

### Symptoms

You may see a message similar to the following in your `ReplicaSet` statuses:

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

You will see events similar to these in the output of `kubectl get events`:


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

1. Apply your new configuration by doing
    ```shell
    tanzu package installed update ... -f scst-sign-values.yaml
    ```

1. It may take a few minutes until your configuration takes effect in the cluster.

#### Increase your cluster's resources

Node pressure may be caused for not enough nodes for deploying the workloads you
have. In this case, follow your cloud provider instructions on how to scale out
your cluster.

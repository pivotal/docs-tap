# Troubleshoot using Tanzu Application Platform

This topic tells you how to troubleshoot using Tanzu Application Platform (commonly known as TAP).

## <a id='missing-build-logs'></a> Missing build logs after creating a workload

You create a workload, but no logs appear when you check for logs by running the following command:

  ```console
  tanzu apps workload tail workload-name --since 10m --timestamp
  ```

**Explanation**

Common causes include:

- Misconfigured repository
- Misconfigured service account
- Misconfigured registry credentials

**Solution**

To resolve this issue, run each of the following commands to receive the relevant error message:

```console
kubectl get clusterbuilder.kpack.io -o yaml
```

```console
kubectl get image.kpack.io <workload-name> -o yaml
```

```console
kubectl get build.kpack.io -o yaml
```

---

## <a id='error-update'></a> "Workload already exists" error after updating the workload

When you update the workload, you receive the following error:

```console
Error: workload "default/APP-NAME" already exists
Error: exit status 1
```
Where `APP-NAME` is the name of the app.

For example, when you run:

```console
$ tanzu apps workload create tanzu-java-web-app \
--git-repo https://github.com/dbuchko/tanzu-java-web-app \
--git-branch main \
--type web \
--label apps.tanzu.vmware.com/has-tests=true \
--yes
```

You receive the following error

```console
Error: workload "default/tanzu-java-web-app" already exists
Error: exit status 1
```

**Explanation**

The app is running before performing a live update using the same app name.

**Solution**

To resolve this issue, either delete the app or use a different name for the app.

---

## <a id='workload-fails-docker-auth'></a>Workload creation fails due to authentication failure in Docker Registry

You might encounter an error message similar to the following when creating or updating a workload by using IDE or `apps` CLI plug-in:

```console
Error: Writing 'index.docker.io/shaileshp2922/build-service/tanzu-java-web-app:latest': Error while preparing a transport to talk with the registry: Unable to create round tripper: GET https://auth.ipv6.docker.com/token?scope=repository%3Ashaileshp2922%2Fbuild-service%2Ftanzu-java-web-app%3Apush%2Cpull&service=registry.docker.io: unexpected status code 401 Unauthorized: {"details":"incorrect username or password"}
```

### Explanation

This type of error frequently occurs when the URL set for `source image` (IDE) or `--source-image` flag (`apps` CLI plug-in) is not Docker registry compliant.

### Solution

1. Verify that you can authenticate directly against the Docker registry and resolve any failures by running:

    ```console
    docker login -u USER-NAME
    ```

2. Verify your `--source-image` URL is compliant with Docker.

    The URL in this example `index.docker.io/shaileshp2922/build-service/tanzu-java-web-app` includes nesting. 
    Docker registry, unlike many other registry solutions, does not support nesting.

3. To resolve this issue, you must provide an unnested URL. For example, `index.docker.io/shaileshp2922/tanzu-java-web-app`

---

## <a id='telem-fails-fetch-secret'></a> Telemetry component logs show errors fetching the "reg-creds" secret

When you view the logs of the `tap-telemetry` controller by running `kubectl logs -n
tap-telemetry <tap-telemetry-controller-<hash> -f`, you see the following error:

  ```console
  "Error retrieving secret reg-creds on namespace tap-telemetry","error":"secrets \"reg-creds\" is forbidden: User \"system:serviceaccount:tap-telemetry:controller\" cannot get resource \"secrets\" in API group \"\" in the namespace \"tap-telemetry\""
  ```

**Explanation**

The `tap-telemetry` namespace misses a Role that allows the controller to list secrets in the
`tap-telemetry` namespace. For more information about Roles, see
[Role and ClusterRole](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-and-clusterrole)
in _Using RBAC Authorization_ in the Kubernetes documentation.

**Solution**

To resolve this issue, run:

```console
kubectl patch roles -n tap-telemetry tap-telemetry-controller --type='json' -p='[{"op": "add", "path": "/rules/-", "value": {"apiGroups": [""],"resources": ["secrets"],"verbs": ["get", "list", "watch"]} }]'
```

---

## <a id='debug-convention'></a> Debug convention may not apply

If you upgrade from Tanzu Application Platform v0.4, the debug convention may not apply to the app run image.

**Explanation**

The Tanzu Application Platform v0.4 lacks SBOM data.

**Solution**

Delete existing app images that were built using Tanzu Application Platform v0.4.

---

## <a id='build-scripts-lack-execute-bit'></a> Execute bit not set for App Accelerator build scripts

You cannot execute a build script provided as part of an accelerator.

**Explanation**

Build scripts provided as part of an accelerator do not have the execute bit set when a new
project is generated from the accelerator.

**Solution**

Explicitly set the execute bit by running the `chmod` command:

```console
chmod +x BUILD-SCRIPT-NAME
```

Where `BUILD-SCRIPT-NAME` is the name of the build script.

For example, for a project generated from the "Spring PetClinic" accelerator, run:

```console
chmod +x ./mvnw
```

---

## <a id='no-live-information'></a> "No live information for pod with ID" error

After deploying Tanzu Application Platform workloads, Tanzu Application Platform GUI shows a "No live information for pod with ID" error.

**Explanation**

The connector must discover the application instances and render the details in Tanzu Application Platform GUI.

**Solution**

Recreate the Application Live View Connector pod by running:

```console
kubectl -n app-live-view delete pods -l=name=application-live-view-connector
```

This allows the connector to discover the application instances and render the details in Tanzu Application Platform GUI.

---

## <a id='image-policy-webhook-service-not-found'></a> "image-policy-webhook-service not found" error

When installing a Tanzu Application Platform profile, you receive the following error:

```console
Internal error occurred: failed calling webhook "image-policy-webhook.signing.apps.tanzu.vmware.com": failed to call webhook: Post "https://image-policy-webhook-service.image-policy-system.svc:443/signing-policy-check?timeout=10s": service "image-policy-webhook-service" not found
```

**Explanation**

The "image-policy-webhook-service" service cannot be found.

**Solution**

Redeploy the `trainingPortal` resource.

---

## <a id='increase-cluster-resources'></a> "Increase your cluster resources" error

You receive an "Increase your cluster's resources" error.

**Explanation**

Node pressure may be caused by an insufficient number of nodes or a lack of resources on nodes
necessary to deploy the workloads that you have.

**Solution**

Follow instructions from your cloud provider to scale out or scale up your cluster.

---

## <a id='pod-admission-prevented'></a> MutatingWebhookConfiguration prevents pod admission

Admission of all pods is prevented when the `image-policy-controller-manager` deployment pods do not
start before the `MutatingWebhookConfiguration` is applied to the cluster.

**Explanation**

Pods can be prevented from starting if nodes in a cluster are scaled to zero and the webhook is
forced to restart at the same time as other system components. A deadlock can occur when some
components expect the webhook to verify their image signatures and the webhook is not yet running.

A known rare condition during Tanzu Application Platform profiles installation can cause this. If so,
you may see a message similar to one of the following in component statuses:

```console
Events:
  Type     Reason            Age                   From                   Message
  ----     ------            ----                  ----                   -------
  Warning  FailedCreate      4m28s                 replicaset-controller  Error creating: Internal error occurred: failed calling webhook "image-policy-webhook.signing.apps.tanzu.vmware.com": Post "https://image-policy-webhook-service.image-policy-system.svc:443/signing-policy-check?timeout=10s": no endpoints available for service "image-policy-webhook-service"
```

```console
Events:
  Type     Reason            Age                   From                   Message
  ----     ------            ----                  ----                   -------
  Warning FailedCreate 10m replicaset-controller Error creating: Internal error occurred: failed calling webhook "image-policy-webhook.signing.apps.tanzu.vmware.com": Post "https://image-policy-webhook-service.image-policy-system.svc:443/signing-policy-check?timeout=10s": service "image-policy-webhook-service" not found
```

**Solution**

Delete the MutatingWebhookConfiguration resource to resolve the deadlock and enable the system to
restart. After the system is stable, restore the MutatingWebhookConfiguration resource to re-enable
image signing enforcement.

>**Important:** These steps temporarily deactivate signature verification in your cluster.

1. Back up `MutatingWebhookConfiguration` to a file by running:

    ```console
    kubectl get MutatingWebhookConfiguration image-policy-mutating-webhook-configuration -o yaml > image-policy-mutating-webhook-configuration.yaml
    ```

1. Delete `MutatingWebhookConfiguration` by running:

    ```console
    kubectl delete MutatingWebhookConfiguration image-policy-mutating-webhook-configuration
    ```

1. Wait until all components are up and running in your cluster, including the
`image-policy-controller-manager pods` (namespace `image-policy-system`).

1. Re-apply `MutatingWebhookConfiguration` by running:

    ```console
    kubectl apply -f image-policy-mutating-webhook-configuration.yaml
    ```

---

## <a id='priority-class-preempts'></a> Priority class of webhook's pods preempts less privileged pods

When viewing the output of `kubectl get events`, you see events similar to the following:

```console
$ kubectl get events
LAST SEEN   TYPE      REASON             OBJECT               MESSAGE
28s         Normal    Preempted          pod/testpod          Preempted by image-policy-system/image-policy-controller-manager-59dc669d99-frwcp on node test-node
```

**Explanation**

The Supply Chain Security Tools - Sign component uses a privileged `PriorityClass` to start its pods
to prevent node pressure from preempting its pods. This can cause less privileged components to have
their pods preempted or evicted instead.

**Solution**

- **Solution 1: Reduce the number of pods deployed by the Sign component:**
    If your deployment of the Sign component runs more pods than necessary, scale down the deployment
    down as follows:

    1. Create a values file named `scst-sign-values.yaml` with the following contents:
        ```console
        ---
        replicas: N
        ```
        Where `N` is an integer indicating the lowest number of pods you necessary for your current
        cluster configuration.

    1. Apply the new configuration by running:
        ```console
        tanzu package installed update image-policy-webhook \
          --package-name image-policy-webhook.signing.apps.tanzu.vmware.com \
          --version 1.0.0-beta.3 \
          --namespace tap-install \
          --values-file scst-sign-values.yaml
        ```

    1. Wait a few minutes for your configuration to take effect in the cluster.

- **Solution 2: Increase your cluster's resources:**
    Node pressure may be caused by an insufficient number of nodes or a lack of resources on nodes
    necessary to deploy the workloads that you have. Follow instructions from your cloud provider
    to scale out or scale up your cluster.

---

## <a id='password-authentication-fails'></a> CrashLoopBackOff from password authentication fails

Supply Chain Security Tools - Store does not start. You see the following error in the
`metadata-store-app` Pod logs:

```console
$ kubectl logs pod/metadata-store-app-* -n metadata-store -c metadata-store-app
...
[error] failed to initialize database, got error failed to connect to `host=metadata-store-db user=metadata-store-user database=metadata-store`: server error (FATAL: password authentication failed for user "metadata-store-user" (SQLSTATE 28P01))
```

**Explanation**

The database password has been changed between deployments. This is not supported.

**Solution**

Redeploy the app either with the original database password or follow these steps below to erase the
data on the volume:

1. Deploy `metadata-store app` with kapp.

1. Verify that the `metadata-store-db-*` Pod fails.

1. Run:
    ```console
    kubectl exec -it metadata-store-db-KUBERNETES-ID -n metadata-store /bin/bash
    ```
    Where `KUBERNETES-ID` is the ID generated by Kubernetes and appended to the Pod name.

1. To delete all database data, run:
    ```console
    rm -rf /var/lib/postgresql/data/*
    ```
    This is the path found in `postgres-db-deployment.yaml`.

1. Delete the `metadata-store` app with kapp.

1. Deploy the `metadata-store` app with kapp.

---

## <a id='password-authentication-fails'></a> Password authentication fails

Supply Chain Security Tools - Store does not start. You see the following error in the
`metadata-store-app` Pod logs:

```console
$ kubectl logs pod/metadata-store-app-* -n metadata-store -c metadata-store-app
...
[error] failed to initialize database, got error failed to connect to `host=metadata-store-db user=metadata-store-user database=metadata-store`: server error (FATAL: password authentication failed for user "metadata-store-user" (SQLSTATE 28P01))
```

**Explanation**

The database password has been changed between deployments. This is not supported.

**Solution**

Redeploy the app either with the original database password or follow these steps below to erase the
data on the volume:

1. Deploy `metadata-store app` with kapp.

1. Verify that the `metadata-store-db-*` Pod fails.

1. Run:

    ```console
    kubectl exec -it metadata-store-db-KUBERNETES-ID -n metadata-store /bin/bash
    ```
    Where `KUBERNETES-ID` is the ID generated by Kubernetes and appended to the Pod name.

1. To delete all database data, run:
    ```console
    rm -rf /var/lib/postgresql/data/*
    ```
    This is the path found in `postgres-db-deployment.yaml`.

1. Delete the `metadata-store` app with kapp.

1. Deploy the `metadata-store` app with kapp.

---

## <a id='metadata-store-db-fails-to-start'></a> `metadata-store-db` pod fails to start

When Supply Chain Security Tools - Store is deployed, deleted, and then redeployed, the `metadata-store-db`
Pod fails to start if the database password changed during redeployment.

**Explanation**

The persistent volume used by postgres retains old data, even though the retention policy is set to `DELETE`.

**Solution**

Redeploy the app either with the original database password or follow these steps below to erase the
data on the volume:

1. Deploy `metadata-store app` with kapp.

1. Verify that the `metadata-store-db-*` Pod fails.

1. Run:
    ```console
    kubectl exec -it metadata-store-db-KUBERNETES-ID -n metadata-store /bin/bash
    ```
    Where `KUBERNETES-ID` is the ID generated by Kubernetes and appended to the Pod name.

1. To delete all database data, run:
    ```console
    rm -rf /var/lib/postgresql/data/*
    ```
    This is the path found in `postgres-db-deployment.yaml`.

1. Delete the `metadata-store` app with kapp.

1. Deploy the `metadata-store` app with kapp.

---

## <a id='missing-persistent-volume'></a> Missing persistent volume

After Supply Chain Security Tools - Store is deployed, `metadata-store-db` Pod fails for missing volume
while `postgres-db-pv-claim` pvc is in the `PENDING` state.

**Explanation**

The cluster where Supply Chain Security Tools - Store is deployed does not have `storageclass`
defined. The provisioner of `storageclass` is responsible for creating the persistent volume after
`metadata-store-db` attaches `postgres-db-pv-claim`.

**Solution**

1. Verify that your cluster has `storageclass` by running:
    ```console
    kubectl get storageclass
    ```

1. Create a `storageclass` in your cluster before deploying Supply Chain Security Tools - Store. For example:
    ```console
    # This is the storageclass that Kind uses
    kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml

    # set the storage class as default
    kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
     ```

---

## <a id='connect-aws-eks-clusters'></a> Failure to connect to AWS EKS clusters

When using the Tanzu CLI to connect to AWS EKS clusters, you might see one of the following errors:

- `Error: Unable to connect: connection refused. Confirm kubeconfig details and try again`
- `invalid apiVersion "client.authentication.k8s.io/v1alpha1"`

**Explanation**

The cause is [Kubernetes v1.24](https://kubernetes.io/blog/2022/05/03/kubernetes-1-24-release-announcement/)
dropping support for `client.authentication.k8s.io/v1alpha1`.
For more information, see [aws/aws-cli/issues/6920](https://github.com/aws/aws-cli/issues/6920) in
GitHub.

**Solution**

Follow these steps to update your `aws-cli` to a supported `v2.7.35` or greater and update the kubeconfig entry for your EKS cluster(s):

1. Update `aws-cli` to the latest version. See [AWS documentation](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) for more information.

1. Update the kubeconfig entry for your EKS cluster(s):

    ```console
    aws eks update-kubeconfig --name ${EKS_CLUSTER_NAME} --region ${REGION}
    ```

1. In a new terminal window, run a Tanzu CLI command to verify the connection issue is resolved. For example:

    ```console
    tanzu apps workload list
    ```

    Expect the command to execute without error.

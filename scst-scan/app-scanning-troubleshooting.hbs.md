# Troubleshooting Supply Chain Security Tools - Scan 2.0

This topic helps you troubleshoot Supply Chain Security Tools (SCST) - Scan 2.0.

## <a id="overview"></a> Overview

When Scan 2.0 creates an ImageVulnerabilityScan, the following resources are also created:

- Tekton `PipelineRun` with the following `Tasks`:
  - workspace-setup-task
  - scan-task
  - publish-task
- Tekton `TaskRun` corresponding to each `Task`
- `Pod` corresponding to each `TaskRun`

## <a id="viewing-resources"></a> Viewing resources

- To view all resources:

    ```console
    kubectl get imagevulnerabilityscans,pipelineruns,taskruns,pods -n DEV-NAMESPACE
    ```

    Where `DEV-NAMESPACE` is the name of your developer namespace.

- To verify which resources are failing, proceed to the following debugging sections:

    ```console
    NAME                                                                SUCCEEDED   REASON
    imagevulnerabilityscan.app-scanning.apps.tanzu.vmware.com/my-scan   False       Failed

    NAME                                   SUCCEEDED   REASON      STARTTIME   COMPLETIONTIME
    pipelinerun.tekton.dev/my-scan-5kllf   False       Failed      2m10s       85s

    NAME                                                    SUCCEEDED   REASON      STARTTIME   COMPLETIONTIME
    taskrun.tekton.dev/my-scan-5kllf-publish-task           False       Failed      94s         85s
    taskrun.tekton.dev/my-scan-5kllf-scan-task              True        Succeeded   2m1s        94s
    taskrun.tekton.dev/my-scan-5kllf-workspace-setup-task   True        Succeeded   2m9s        2m1s

    NAME                                         READY   STATUS      RESTARTS   AGE
    pod/my-scan-5kllf-publish-task-pod           0/4     Completed   1          94s
    pod/my-scan-5kllf-scan-task-pod              0/4     Completed   1          2m
    pod/my-scan-5kllf-workspace-setup-task-pod   0/2     Completed   1          2m10s
    ```

## <a id="debugging-commands"></a> Debugging commands

The following sections describe commands you run to get logs and details about scanning errors.

## <a id="debug-source-image-scan"></a> Debugging resources

If a resource fails or has errors, inspect the resource. If multiple resources are involved, inspecting them all can provide a broader understanding. For example, inspecting the corresponding `TaskRun` to a failed `Pod`.

To get status conditions on a resource:

```console
kubectl describe RESOURCE RESOURCE-NAME -n DEV-NAMESPACE
```

Where:

- `RESOURCE` is one of the following: `ImageVulnerabilityScan`, `PipelineRun`, `TaskRun`, or `Pod`.
- `RESOURCE-NAME` is the name of the `RESOURCE`.
- `DEV-NAMESPACE` is the name of your developer namespace.

## <a id="debugging-scan-pods"></a> Debugging scan pods

You can use the following methods to debug scan pods:

- To get error logs from a pod when scan pods fail:

    ```console
    kubectl logs SCAN-POD-NAME -n DEV-NAMESPACE
    ```

    Where `SCAN-POD-NAME` is the name of the scan pod.

    For information
    about debugging Kubernetes pods, see the [Kubernetes documentation](https://jamesdefabia.github.io/docs/user-guide/kubectl/kubectl_logs/).

    A scan run that has an error can indicate that one of the following step containers has a failure:

    - `step-workspace-setup`
    - `step-write-certs`
    - `step-cred-helper`
    - `step-SCANNER`
    - `step-publisher`
    - `sidecar-sleep`

    Where `step-SCANNER` is your [scanner step](./ivs-create-your-own.hbs.md).

- To verify which step container had a [failed exit code](https://tekton.dev/docs/pipelines/tasks/#specifying-onerror-for-a-step):

    ```console
    kubectl get taskrun TASKRUN-NAME -o json | jq .status
    ```

    Where `TASKRUN-NAME` is the name of the TaskRun.

- To inspect a specific step container in a pod:

    ```console
    kubectl logs scan-pod-name -n DEV-NAMESPACE -c step-container-name
    ```

    Where `DEV-NAMESPACE` is your developer namespace.

    For information about debugging a TaskRun, see the [Tekton documentation](https://tekton.dev/docs/pipelines/taskruns/#debugging-a-taskrun).

- To debug inside of the scan-task pod:
    Add an additional step with a `sleep` command after your scanner step in the ImageVulnerabilityScan. For example:

    ```yaml
    ...
    spec:
      ...
      steps:
      - name: SCANNER-STEP
        ...
      - name: view
        image: busybox:latest
        args:
        - -c
        - sleep 6000
    ```
    This keeps the pod in a running state so that you can exec into it. Re-run the scan and then exec into the pod:
    ```console
        kubectl exec SCAN-TASK-POD-NAME -n DEV-NAMESPACE -c step-view --stdin --tty -- sh
    ```
    Where `SCAN-TASK-POD-NAME` is the name of your scan-task pod.

### <a id="controller-mngr-logs"></a> Viewing the Scan-Controller manager logs

You can run these commands to view the Scan-Controller manager logs:

- Retrieve scan-controller manager logs:

    ```console
    kubectl logs deployment/app-scanning-controller-manager -n app-scanning-system
    ```

- Tail scan-controller manager logs:

    ```console
    kubectl logs -f deployment/app-scanning-controller-manager -n app-scanning-system
    ```

## <a id="troubleshoot-app-scan-issues"></a> Troubleshooting issues

### <a id="volume-permission-errors"></a> Volume permission error

If you encounter a permission error for accessing, opening, and writing to the files inside cluster volume, such as:

```Console
unsuccessful cred copy: ".git-credentials" from "/tekton/creds" to "/home/app-scanning": unable to open destination: open /home/app-scanning/.git-credentials: permission denied
```

Ensure that the problematic step runs with the
[proper user and group ids](./ivs-create-your-own.hbs.md#security-context-user-and-group-ids).

### <a id="upgrading-scan-0-2-0"></a> Incompatible Tekton version

Tanzu Application Platform `v1.7.0` includes `app-scanning.apps.tanzu.vmware.com` version `0.2.0` and Tekton Pipelines version `0.50.1`. The `app-scanning.apps.tanzu.vmware.com` package is incompatible with previous versions of Tekton Pipelines as v1 CRDs were not enabled. You must upgrade Tanzu Application Platform to `v1.7.0` or greater before upgrading `app-scanning.apps.tanzu.vmware.com`.

If you did not upgrade Tanzu Application Platform before upgrading `app-scanning.apps.tanzu.vmware.com`, you can encounter ImageVulnerabilityScans not progressing:

```console
NAME      SUCCEEDED   REASON
my-scan
```
 
To resolve this issue:

1. Confirm that the issue is due to installing an incompatible Tekton version by viewing the controller manager logs by running:

    ```console
    kubectl -n app-scanning-system logs -f deployment/app-scanning-controller-manager -c manager
    ```

    If you encounter the following error, proceed to the next step:

    ```console
    ERROR  controller-runtime.source.EventHandler  failed to get informer from cache  {"error": "failed to get API group resources: unable to retrieve the complete list of server APIs: tekton.dev/v1: the server could not find the requested resource"}
    ```

2. Upgrade Tanzu Application Platform to `v1.7.0` or later. See [Upgrade your Tanzu Application Platform](../upgrading.hbs.md). 

### <a id="scan-results-empty"></a> Scan results empty

The publish-task task fails if the `scan-results-path` (default value of `/workspace/scan-result`) is empty. To confirm, view the logs of the publish-task pod:

```console
kubectl logs PUBLISH-TASK-POD-NAME -c step-publisher -n DEV-NAMESPACE
```

Where `PUBLISH-TASK-POD-NAME` is the name of your publish-task pod.

```console
2023/08/22 17:09:49 results folder /workspace/scan-results is empty
```

To resolve this issue, you can debug within the scan-task pod by following the instructions under [Debugging scan pods](./app-scanning-troubleshooting.hbs.md#debugging-scan-pods). You must use an image with both a shell and your scanner CLI image to run the `sleep` command and troubleshoot your scanner commands from within the container.

### <a id="scanning-restricted-pss"></a> Scanning in a cluster with restricted Kubernetes Pod Security Standards

As part of compliance with the restricted profile for Kubernetes Pod Security Standards, you must set the `securityContext` of containers and initContainers. This applies to the `prepare` initContainers and affinity assistant pods created by Tekton. When a pod does not meet pod Security Standards, it is not created and vulnerability scanning cannot proceed. For more information, see the [Kubernetes documentation](https://kubernetes.io/docs/concepts/security/pod-security-standards/).

You might see an error message similar to the following when describing the TaskRun:

```console
pods "trivy-ivs-abcd-scan-task-pod" is forbidden: violates PodSecurity "restricted:latest": allowPrivilegeEscalation != false (container "prepare" must set securityContext.allowPrivilegeEscalation=false), unrestricted capabilities (container "prepare" must set securityContext.capabilities.drop=["ALL"]), seccompProfile (pod or container "prepare" must set securityContext.seccompProfile.type to "RuntimeDefault" or "Localhost"). Maybe invalid TaskSpec. ScanPodError PodNotFound: no pod found
```

To resolve this issue:

1. Update your Tekton Pipelines package configuration in your `tap-values.yaml` with the following changes:
    
    ```yaml
    tekton_pipelines:
        feature_flags:
            set_security_context: "true"
            disable_affinity_assistant: "true"
    ```

    Setting the `securityContext` resolves the `prepare` initContainer violation. Deactivating affinity assistant pods is a workaround for the affinity assistant violation as Tekton does not have a way to update the `securityContext` in those pods.

1. Update your Tanzu Application Platform installation by running:

   ```console
   tanzu package installed update tap -p tap.tanzu.vmware.com -v TAP-VERSION  --values-file tap-values.yaml -n tap-install
   ```

    Where `TAP-VERSION` is the version of Tanzu Application Platform installed.

  >**Note** Tekton [affinity assistant](https://tekton.dev/vault/pipelines-main/affinityassistants/) is a feature that can schedule all TaskRun pods within a PipelineRun that share a Workspace on the same node. If deactivated, VMware recommends using an affinity-aware CSI storage class. For more information, see the [Kubernetes documentation](https://kubernetes.io/docs/concepts/storage/volumes/#csi).

1. Re-run the scan.
# Troubleshooting Supply Chain Security Tools - Scan 2.0

This topic helps you troubleshoot Supply Chain Security Tools (SCST) - Scan 2.0.

When an ImageVulnerabilityScan is created, the following resources are created:
- Tekton `PipelineRun` with the following `Task`s:
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

- Determine which resources are failing and proceed to the debugging sections below:

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

If a resource fails or has errors, inspect the resource. If multiple resources are involved, inspecting them all may provide a broader understanding (e.g. inspecting the corresponding `TaskRun` to a failed `Pod`).

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

    A scan run that has an error may indicate that one of the following step containers has a failure:

    - `step-workspace-setup`
    - `step-write-certs`
    - `step-cred-helper`
    - `step-SCANNER`
    - `step-publisher`
    - `sidecar-sleep`

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
    Add an additional step with a `sleep` command below your scanner step in the ImageVulnerabilityScan. For example:

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

### <a id="volume-permission-errors"></a> Volume permission error

If you encounter a permission error for accessing, opening, and writing to the files inside cluster volume, such as:

```Console
unsuccessful cred copy: ".git-credentials" from "/tekton/creds" to "/home/app-scanning": unable to open destination: open /home/app-scanning/.git-credentials: permission denied
```

Ensure that the problematic step runs with the
[proper user and group ids](./ivs-create-your-own.hbs.md#security-context-user-and-group-ids).

### <a id="upgrading-scan-0.2.0"></a> Incompatible Tekton version

Tanzu Application Platform `v1.7.0` includes `app-scanning.apps.tanzu.vmware.com` version `0.2.0` and Tekton Pipelines version `0.50.1`. The `app-scanning.apps.tanzu.vmware.com` package is incompatible with previous versions of Tekton Pipelines as v1 CRDs were not enabled. You must first upgrade the Tanzu Application Platform package to `v1.7.0` or greater prior to upgrading `app-scanning.apps.tanzu.vmware.com`.

If you did not upgrade in the above order, you may encounter ImageVulnerabilityScans not progressing.

```console
NAME      SUCCEEDED   REASON
my-scan
```

1. Confirm that the issue is due to installation of an incompatible Tekton version by viewing the controller manager logs.
```console
kubectl -n app-scanning-system logs -f deployment/app-scanning-controller-manager -c manager
```

If you encounter the following error, proceed to the next step:
```console
ERROR	controller-runtime.source.EventHandler	failed to get informer from cache	{"error": "failed to get API group resources: unable to retrieve the complete list of server APIs: tekton.dev/v1: the server could not find the requested resource"}
```

1. Follow [Upgrade your Tanzu Application Platform](../upgrading.hbs.md) to upgrade TAP to version `v1.7.0` or greater.
## <a id="troubleshooting-app-scanning-issues"></a> Troubleshooting issues

### <a id="scan-results-empty"></a> Scan results empty

The publish-task task will fail if the `scan-results-path` (default value of `/workspace/scan-result`) is empty. To confirm, view the logs of the publish-task pod:
```console
kubectl logs PUBLISH-TASK-POD-NAME -c step-publisher -n DEV-NAMESPACE
```
Where `PUBLISH-TASK-POD-NAME` is the name of your publish-task pod.

```console
2023/08/22 17:09:49 results folder /workspace/scan-results is empty
```

To resolve this issue, you can debug within the scan-task pod by following the instructions under [Debugging scan pods](./app-scanning-troubleshooting.hbs.md#debugging-scan-pods). You many need use an image with both a shell and your scanner image to run the `sleep` command and troubleshoot running your scanner commands from within the container.

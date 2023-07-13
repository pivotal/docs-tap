# Troubleshooting Supply Chain Security Tools - Scan 2.0

This topic helps you troubleshoot Supply Chain Security Tools (SCST) - Scan 2.0.

## <a id="debugging-commands"></a> Debugging commands

The following sections describe commands you run to get logs and details about scanning errors.

## <a id="debug-source-image-scan"></a> Debugging resources

If a resource fails or has errors, inspect the resource.

To get status conditions on a resource:

```console
kubectl describe RESOURCE RESOURCE-NAME -n DEV-NAMESPACE
```

Where:

- `RESOURCE` is one of the following: `ImageVulnerabilityScan`, `PipelineRun`, or `TaskRun`.
- `RESOURCE-NAME` is the name of the `RESOURCE`.
- `DEV-NAMESPACE` is the name of the developer namespace you want to use.

## <a id="debugging-scan-pods"></a> Debugging scan pods

You can use the following methods to debug scan pods:

- To get error logs from a pod when scan pods fail:

    ```console
    kubectl logs SCAN-POD-NAME -n DEV-NAMESPACE
    ```

    Where `SCAN-POD-NAME` is the name of the scan pod.

    For information
    about debugging Kubernetes pods, see the [Kubernetes documentation](https://jamesdefabia.github.io/docs/user-guide/kubectl/kubectl_logs/).

    A scan run that has an error means that one of the following step containers has a failure:

    - `step-write-certs`
    - `step-cred-helper`
    - `step-publisher`
    - `sidecar-sleep`
    - `working-dir-initializer`

- To determine which step container had a [failed exit code](https://tekton.dev/docs/pipelines/tasks/#specifying-onerror-for-a-step):

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

### <a id="controller-mngr-logs"></a> Viewing the Scan-Controller manager logs

You can run the following commands to view the Scan-Controller manager logs:

- Retrieve scan-controller manager logs:

    ```console
    kubectl logs deployment/app-scanning-controller-manager -n app-scanning-system
    ```

- Tail scan-controller manager logs:

    ```console
    kubectl logs -f deployment/app-scanning-controller-manager -n app-scanning-system
    ```

### <a id="volume-permission-errors"></a> Volume permission error

If you encounter permission error for accessing, opening and writing to the files inside cluster volume such as:

```Console
unsuccessful cred copy: ".git-credentials" from "/tekton/creds" to "/home/app-scanning": unable to open destination: open /home/app-scanning/.git-credentials: permission denied
```

Then check that the problamatic step is running with [proper user and group ids](#pod-template-security-context).
# Troubleshoot Tanzu Developer Tools for Visual Studio

This topic tells you how to troubleshoot issues you encounter with
VMware Tanzu Developer Tools for Visual Studio.

## <a id='del-wrkld-not-running'></a> Erroneous `WorkloadNotRunningState` error message

### Symptom

In v0.1.0 and earlier, the `Tanzu: Delete Workload` command might give the following error message
even when a workload is running:

```console
Invalid transition DeleteWorkload from state WorkloadNotRunningState
```

### Solution

Re-apply your workload by running `Tanzu: Workload Apply` or `Tanzu: Start Live Update`.
This realigns the extension's internal state with the proper workload state.
The delete operation is enabled again after the extension detects that the workload is running.

## <a id='lv-update-app-not-updated'></a> Live Update fails to update remote app

### Symptom

In v0.1.0 and earlier, the `Tanzu: Start Live Update` command does not update the remote app.

### Cause

The Tiltfile might be specifying an incorrect local path.

### Solution

In your Tiltfile, change the lines

```text
  live_update=[
    sync('./bin', '/workspace')
  ]
```

to

```text
  live_update=[
    sync('./bin/Debug/net6.0', '/workspace')
  ]
```

This copies the correct portion of the local workspace to the remote app.
The actual path `bin/Debug/net6.0` might be different depending on your Visual Studio configuration
and target.

## <a id='delete-workload-fails'></a> Delete workload command fails to delete workload

### Symptom

In v0.1.0 and earlier, the `Tanzu: Delete Workload` command appears to run but does not delete the workload.

### Cause

The workload is running in a namespace other than `default`.

### Solution

Only deploy workloads to the `default` namespace.
Alternatively, set the default Kubernetes namespace to the one where your workload is running.
To do so, run:

```console
kubectl config set-context --current --namespace=NAMESPACE
```

## <a id="live-update-jammy-fail"></a> Live Update does not work with the Jammy `ClusterBuilder`

{{> 'partials/ide-extensions/ki-live-update-jammy' }}

## <a id="freq-app-restarts"></a> Frequent application restarts

### Symptom

When an application is applied from Visual Studio it restarts frequently.

### Cause

An application or environment behavior is triggering the application to restart.

Observed trigger behaviors include:

- The application itself writing logs to the file system in the application directory that Live Update
  is watching
- Autosave being set to a very high frequency in the IDE configuration

### Solution

Prevent the trigger behavior. Example solutions include:

- Prevent 12-factor applications from writing to the file system.
- Reduce the autosave frequency to once every few minutes.
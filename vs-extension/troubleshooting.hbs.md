# Troubleshoot Tanzu Developer Tools for Visual Studio

This topic describes what to do when encountering issues with Tanzu Developer Tools for Visual Studio.

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

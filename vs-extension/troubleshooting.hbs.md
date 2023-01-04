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

## <a id='null-error'></a> Erroneous `Live Update Error` error message

### Symptom

In v0.1.0 and earlier, the `Tanzu: Start Live Update` command might give the following error message
when first run:

```console
The system cannot find the path specified
```

### Solution

In your Tiltfile, change the line `OUTPUT_TO_NULL_COMMAND = os.getenv("OUTPUT_TO_NULL_COMMAND", default=' > /dev/null ')` to `OUTPUT_TO_NULL_COMMAND_WINDOWS = os.getenv("OUTPUT_TO_NULL_COMMAND_WINDOWS", default=' > NUL ')`. This should allow the path to be found and should execute Live Update successfully.

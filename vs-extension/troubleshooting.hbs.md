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

## <a id='lv-update-path-not-found'></a> Live Update failure because the system cannot find the path specified

### Symptom

In v0.1.0 and earlier, the `Tanzu: Start Live Update` command gives the following error message
when first run:

```console
The system cannot find the path specified
```

### Cause

`/dev/null` is used by Unix OSes and will not work for a Windows machine, which uses the `NUL` var.

### Solution

In your Tiltfile, change the line

```text
OUTPUT_TO_NULL_COMMAND = os.getenv("OUTPUT_TO_NULL_COMMAND", default=' > /dev/null ')
```

to

```text
OUTPUT_TO_NULL_COMMAND = os.getenv("OUTPUT_TO_NULL_COMMAND", default=' > NUL ')
```

This makes the path discoverable and enables Live Update to run.

# Troubleshoot Tanzu Developer Tools for Visual Studio

This topic tells you how to troubleshoot issues you encounter with
VMware Tanzu Developer Tools for Visual Studio.

## <a id="stop-button"></a> Stop button causes workload to fail

### Symptom

Clicking the red square Stop button in the Visual Studio top toolbar causes the
Tanzu Application Platform workload to fail or become unresponsive indefinitely.

### Solution

To end a debugging session, in the top menu click **Debug** > **Detach All**.

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
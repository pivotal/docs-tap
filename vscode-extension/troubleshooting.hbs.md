# Troubleshoot Tanzu Developer Tools for VS Code

This topic tells you what to do when you encounter issues with
VMware Tanzu Developer Tools for Visual Studio Code (VS Code).

## <a id='cannot-view-workloads'></a> Unable to view workloads on the panel when connected to GKE cluster

{{> 'partials/ide-extensions/ki-cannot-view-workloads' }}

## <a id='lu-not-working-classversion'></a> Live update fails with `UnsupportedClassVersionError`

### Symptom

After live-update has synchronized changes you made locally to the running workload, the workload pods
start failing with an error message similar to the following:

```console
Caused by: org.springframework.beans.factory.CannotLoadBeanClassException: Error loading class
[com.example.springboot.HelloController] for bean with name 'helloController' defined in file
[/workspace/BOOT-INF/classes/com/example/springboot/HelloController.class]: problem with class file
or dependent class; nested exception is
java.lang.UnsupportedClassVersionError: com/example/springboot/HelloController has been compiled by
a more recent version of the Java Runtime (class file version 61.0), this version of the
Java Runtime only recognizes class file versions up to 55.0
```

### Cause

The classes produced locally on your machine are compiled to target a newer Java virtual machine (JVM).
The error message mentions `class file version 61.0`, which corresponds to Java 17.
The buildpack, however, is set up to run the application with an older JVM.
The error message mentions `class file versions up to 55.0`, which corresponds to Java 11.

The root cause of this is a misconfiguration of the Java compiler that VS Code uses.
This issue seems to be caused by a suspected bug in the VS Code Java tooling, which sometimes fails
to properly configure the compiler source and target compatibility-level from information in the
Maven POM.

For example, in the `tanzu-java-web-app` sample application the POM contains the following:

```java
<properties>
        <java.version>11</java.version>
        ...
</properties>
```

This correctly specifies that the app must be compiled for Java 11 compatibility.
However, the VS Code Java tooling sometimes fails to take this information into account.

### Solution

Force the VS Code Java tooling to re-read and synchronize information from the POM:

1. Right-click on the `pom.xml` file.
2. Select **Reload Projects**.

This causes the internal compiler level to be set correctly based on the information from `pom.xml`.
For example, Java 11 in `tanzu-java-web-app`.

## <a id="live-update-timeout"></a> Timeout error when Live Updating

{{> 'partials/ide-extensions/ki-timeout-err-live-updating' }}

## <a id="deprecated-task"></a> Task-related error when running a Tanzu Debug launch configuration

### Symptom

When you attempt to run a Tanzu Debug launch configuration, you see a task-related error message
similar to the following:

`Could not find the task 'tanzuManagement: Kill Port Forward my-app`

### Cause

The task you're trying to run is no longer supported.

### Solution

Delete the launch configuration from your `launch.json` file in your `.vscode` directory.

## <a id="tnz-panel-actions-unavail"></a> Tanzu Workloads panel workloads only show delete command

{{> 'partials/ide-extensions/ki-tnz-panel-actions-unavail' }}

## <a id="projects-with-spaces"></a> Workload actions do not work when in a project with spaces in the name

{{> 'partials/ide-extensions/ki-projects-with-spaces' }}

## <a id="malformed-kubeconfig"></a> Cannot apply workload because of a malformed kubeconfig file

### Symptom

You cannot apply a workload. You see an error message when you attempt to do so.

### Cause

Your kubeconfig file (`~/.kube/config`) is malformed.

### Solution

Fix your kubeconfig file.

## <a id="windows-quotes-error"></a> Cannot Tanzu Debug on a new Workload in Windows

### Symptom

When a user tries to Tanzu Debug on a new untracked Workload, they will see this error: `Error: unable to check if filepath "'<SOME_PATH>'" is a valid url.`

### Cause
We added single quotes around the `--file` and `--local-path` arguments in an attempt to allow the app to work on path with spaces.
Apparently, the this behavior is broken on vscode.PsuedoTerminal, but not in PowerShell. Tanzu Debug uses the PsuedoTerminal whereas Tanzu Apply uses PowerShell.
### Solution

First do Tanzu Apply. When the workload is ready, then do Tanzu Debug. Since the workload exists, Tanzu Debug will not try to re-apply.
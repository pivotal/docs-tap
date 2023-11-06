# Troubleshoot Tanzu Developer Tools for VS Code

This topic tells you what to do when you encounter issues with
VMware Tanzu Developer Tools for Visual Studio Code (VS Code).

## <a id='cannot-view-workloads'></a> Unable to view workloads on the panel when connected to GKE cluster

{{> 'partials/ide-extensions/ki-cannot-view-workloads' }}

## <a id='lu-not-wrkng-classversion'></a> Live Update fails with `UnsupportedClassVersionError`

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

The classes produced locally on your machine are compiled to target a later Java virtual machine (JVM).
The error message mentions `class file version 61.0`, which corresponds to Java 17.
The buildpack, however, is set up to run the application with an earlier JVM.
The error message mentions `class file versions up to 55.0`, which corresponds to Java 11.

The root cause of this is a misconfiguration of the Java compiler that VS Code uses. The cause might
be a suspected issue with the VS Code Java tooling, which sometimes fails to properly configure the
compiler source and target compatibility-level from information in the Maven POM.

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

1. Right-click the `pom.xml` file.
2. Click **Reload Projects**.

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

## <a id="cnfg-writer-pull-request"></a> `config-writer-pull-requester` is categorized as Unknown

{{> 'partials/ide-extensions/ki-config-writer-pull-requester' }}

## <a id="freq-app-restarts"></a> Frequent application restarts

### Symptom

When an application is applied from VS Code it restarts frequently.

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
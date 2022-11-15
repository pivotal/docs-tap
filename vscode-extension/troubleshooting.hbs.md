# Troubleshooting Tanzu Developer Tools for VS Code

This topic describes what to do when encountering issues with Tanzu Developer Tools for VS Code.

## <a id='cannot-view-workloads'></a> Unable to view workloads on the panel when connected to GKE cluster

{{> 'partials/ext-tshoot/cannot-view-workloads' }}

## <a id='cancel-action-warning'></a> Warning notification when canceling an action

{{> 'partials/ext-tshoot/cancel-action-warning' }}

## <a id='lu-not-working-wl-types'></a> Live update might not work when using server or worker Workload types

{{> 'partials/ext-tshoot/lu-not-working-wl-types' }}

## <a id='lu-not-working-classversion'></a> Live update errors with `UnsupportedClassVersionError`

### Symptom

After live-update has synchronized changes you made locally to the running workload, the workload pods
start failing with an error message similar to the following:

```console
Caused by: org.springframework.beans.factory.CannotLoadBeanClassException: Error loading class [com.example.springboot.HelloController] for bean with name 'helloController' defined in file [/workspace/BOOT-INF/classes/com/example/springboot/HelloController.class]: problem with class file or dependent class; nested exception is java.lang.UnsupportedClassVersionError: com/example/springboot/HelloController has been compiled by a more recent version of the Java Runtime (class file version 61.0), this version of the Java Runtime only recognizes class file versions up to 55.0
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

This should trigger the internal compiler level to then be set correctly based
on the information from the `pom.xml` (e.g. Java 11 in the `tanzu-java-web-app` example).

## <a id='debug-not-working-corrupt-launch-conf'>Starting a Debug Session Errors with 'Unable to open debugger port'

### Symptom

You try to start a 'Tanzu Debug' session and it immediately fails an error like:

```
Error running 'Tanzu Debug - fortune-teller-fortune-service': Unable to open debugger port (localhost:5005): java.net.ConnectException "Connection refused"
```

### Cause

Old "Tanzu Debug" launch configurations sometimes appear to be corrupted after installing a newer version of the 
plugin. You can check whether this the problem you are experiencing by opening the launch configuration:

- Right-Click the `workload.yaml` file.
- Select "Modify Run Configuration..." from the menu.
- Scroll down and expand "Before Launch" section of the dialog.
- Notice that it contains two "Unknown Task" entries ('com.vmware.tanzu.tanzuBeforeRunPortForward` and 
  `com.vmware.tanzu.tanzuBeforeRunWorkloadApply`)

The result of these two tasks being 'unknown' causes those steps of the debug launch not to be executed.
This in turn means that the target application will not be deployed and accessible on the expected port;
this results in an error when the debugger tries to connect to it.

### Solution

Simplt closing and restarting IntelliJ typically fixes this problem. If that doesn't help you can try 
deleting the old (corrupted) launch configuration and recreating it.

Note: While the launch configuration appears corrupt when you look at it in the launch config editor... 
in actuality there doesn't seem to be a real problem with it. This problem seems to happen only when 
you install a new version of the plugin and start using it right away without first restarting IntelliJ. 
We suspect this to be a bug in IntelliJ platform where it doesn't completely or correctly initialize the 
plugin when it is being 'hot loaded' into an active session rather than loaded on startup.

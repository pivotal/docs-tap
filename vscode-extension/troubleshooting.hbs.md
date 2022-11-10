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
start failing with an error like the following:

```
Caused by: org.springframework.beans.factory.CannotLoadBeanClassException: Error loading class [com.example.springboot.HelloController] for bean with name 'helloController' defined in file [/workspace/BOOT-INF/classes/com/example/springboot/HelloController.class]: problem with class file or dependent class; nested exception is java.lang.UnsupportedClassVersionError: com/example/springboot/HelloController has been compiled by a more recent version of the Java Runtime (class file version 61.0), this version of the Java Runtime only recognizes class file versions up to 55.0
```

### Cause

The classes produced locally on your machine have been compiled to target a newer JVM (the above error indicates class version 61.0, this corresponds to Java 17). The buildpack however is setup to run the 
application with an older JVM (the above error indicates class version 55.0, which corresponds to Java 11).

The root cause of this is a misconfiguration of the Java compiler used by VScode. This problem seems to
be caused by a suspected bug in the VScode Java tooling which sometimes fails to properly configure 
the compiler source and target compatibility level from information in the maven Pom.

For example in the `tanzu-java-web-app` sample application the pom contains the following:

```
<properties>
		<java.version>11</java.version>
        ...
</properties>
```

This correctly specifies that the app should be compiled for Java 11 compatibility. However, the
VScode Java tooling sometimes fails to take this information into account.

### Solution

You can force the VScode Java tooling to re-read and synchronize information from the pom as follows:

- right-click on the pom.xml file and 
- select "Reload Projects". 

This should trigger the internal compiler level to then be set correctly based
on the information from the `pom.xml` (e.g. Java 11 in the `tanzu-java-web-app` example).
# Application Live View in Tanzu Application Platform GUI

This topic describes Application Live View in Tanzu Application Platform GUI.


## <a id="overview"></a> Overview

The Application Live View features of Tanzu Application Platform include sophisticated components
to give developers and operators a view into their running workloads on Kubernetes.

Application Live View shows an individual running process, for example, a Spring Boot application
deployed as a workload resulting in a JVM process running inside of a pod.
This is an important concept of Application Live View: only running processes are recognized by
Application Live View.
If there is not a running process inside of a running pod, Application Live View does not show anything.

Under the hood, Application Live View uses the concept of actuators to gather data from
those running processes.
It visualizes them in a semantically meaningful way and allows users to interact with the inner
workings of the running processes within limited boundaries.

The actuator data serves as the source of truth. Application Live View provides a live view of the data from inside of the running processes only.
It does not store any of that data for further analysis or historical views.

This easy-to-use interface provides ways to troubleshoot, learn, and maintain an overview of certain aspects of the running processes.
It gives a level of control to the users to change some parameters, such as environment properties,
without a restart (where the Spring Boot application, for example, supports that).


## <a id="plug-in-entry-point"></a> Entry point to Application Live View plug-in

The Application Live View UI plug-in is part of Tanzu Application Platform GUI.
To use the Application Live View plug-in:

1. Select the relevant component under the **Organization Catalog** in Tanzu Application Platform GUI.
1. Select the desired service under the **Runtime Resources** tab.
1. Select the desired pod from the **Pods** section under the **Runtime Resources** tab.
1. You can now see all the details, do some lightweight troubleshooting, and interact with the application within certain boundaries under the **Live View** section.

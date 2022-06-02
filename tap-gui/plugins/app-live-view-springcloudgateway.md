# Application Live View for Spring Cloud Gateway Applications in Tanzu Application Platform GUI

This topic describes Application Live View for Spring Cloud Gateway Applications in Tanzu Application Platform GUI.


## <a id="overview"></a> Overview

The Application Live View features of the Tanzu Application Platform include sophisticated components
to give developers and operators a view into their running workloads on Kubernetes.

Application Live View shows an individual running process, for example, a Spring Cloud Gateway application
deployed as a workload resulting in a JVM process running inside of a pod.
This is an important concept of Application Live View: only running processes are recognized by
Application Live View.
If there is not a running process inside of a running pod, Application Live View does not show anything.

Under the hood, Application Live View uses the concept of Spring Cloud Gateway Actuators to gather data from
those running processes.
It visualizes them in a semantically meaningful way and allows users to interact with the inner
workings of the running processes within limited boundaries.

The actuator data serves as the source of truth. Application Live View provides a live view of the
data from inside of the running processes only.
Application Live View does not store any of that data for further analysis or historical views.
This easy-to-use interface provides ways to troubleshoot, learn, and maintain an overview of certain
aspects of the running processes.
It gives a level of control to the users to change some parameters, such as environment properties,
without a restart (where the Spring Cloud Gateway application, for example, supports that).


## <a id="plug-in-entry-point"></a> Entry point to Application Live View plug-in

The Application Live View UI plug-in is part of Tanzu Application Platform GUI.
To use the Application Live View plug-in:

- Select the relevant component under the **Organization Catalog** in Tanzu Application Platform GUI
- Select the desired service under **Runtime Resources** tab
- Select the desired pod from the **Pods** section under **Runtime Resources** tab
- The user can see all the details, do some lightweight troubleshooting and interact with the application in certain boundaries under the **Live View** section


## <a id="app-live-view-pages"></a> Application Live View pages for Spring Cloud Gateway

The following sections describe Application Live View pages for Spring Cloud Gateway.


### <a id="api-success-rate-page"></a> API Success Rate page

To navigate to the **API Success Rate** page, the user can select the **API Success Rate** option from the
**Information Category** drop-down menu.
The API success rate page displays the total successes, average response time and max response time for the gateway routes. 
It also displays the details of each successful route path.


### <a id="api-overview-page"></a> API Overview page

To navigate to the **API Overview** page, the user can select the **API Overview** option from the
**Information Category** drop-down menu.
The API Overview page provides route count, number of successes, errors and the rate limited requests. It also provides a `auto refresh` feature to get the updated results.
These metrics are depicted in a line graph.


### <a id="api-authentications-by-path-page"></a> API Authentications By Path page

To navigate to the **API Authentications By Path** page, the user can select the **API Authentications By Path** option from the
**Information Category** drop-down menu.
The API Authentications By Path page displays the total requests, number of successes, forbidden and unsuccessful authentications grouped by the HTTP method and gateway route path. 
The page also displays the success rate for each of the routes.


**Note:**:
In addition to the above three pages, the Spring Boot actuator pages are also displayed. 


## <a id="troubleshooting"></a> Troubleshooting

You might run into cases where a workload running on your cluster does not show up in the
Application Live View overview, the detail pages do not load any information while running, or similar issues.
See [Troubleshooting](../../app-live-view/troubleshooting.md) in the Application Live View documentation.

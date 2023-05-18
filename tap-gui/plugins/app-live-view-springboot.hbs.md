# Application Live View for Spring Boot Applications in Tanzu Application Platform GUI

This topic tells you about the Application Live View pages for Spring Boot Applications in
Tanzu Application Platform GUI (commonly called TAP GUI).

## <a id="details-page"></a> Details page

This is the default page loaded in the **Live View** section.
This page gives a tabular overview containing the following information:

- application name
- instance ID
- location
- actuator location
- health endpoint
- direct actuator access
- framework
- version
- new patch version
- new major version
- build version

The user can navigate between **Information Categories** by selecting from the drop-down menu on the
top right corner of the page.

![Details Page in the UI for an example application named demo.](images/details.png)

## <a id="health-page"></a> Health page

To navigate to the health page, the user can select the **Health** option from the
**Information Category** drop-down menu.
The health page provides detailed information about the health of the application.
It lists all the components that make up the health of the application such as readiness, liveness,
and disk space.
It displays the status, details associated with each of the components.

![Health Page in the UI listing positive states for several components.](images/health.png)

## <a id="environment-page"></a> Environment page

To navigate to the **Environment** page, the user can select the **Environment** option from the
**Information Category** drop-down menu.
The Environment page contains details of the applications' environment.
It contains properties including, but not limited to, system properties, environment variables, and
configuration properties (such as application.properties) in a Spring Boot application.

The page includes the following capabilities for `viewing` configured environment properties:

- The UI has a search feature that enables the user to search for a property or values.
- Each property has a search icon at the right corner which helps the user quickly see all the
  occurrences of a specific property key without manually typing in the search box.
  Clicking the search button locates the property name.
- The **Refresh Scope** button on the top right corner of the page probes the application to refresh
  all the environment properties.

The page also includes the following capabilities for `editing` configured environment properties:

- The UI allows the user to edit environment properties and see the live changes in the application.
  These edits are temporary and go away if the underlying pod is restarted.
- For each of the configured environment properties, the user can edit its value by clicking on
  the **Override** button in the same row.
  After the value is saved, the user can view the message that the property was overridden from the
  initial value. The updated property is visible in the **Applied Overrides** section at the
  top of the page.
  The **Reset** button in the same row resets the environment property to the initial state.
- The user can also edit or remove the overridden environment variables in the **Applied Overrides**
  section.
- The **Applied Overrides** section also enables the user to add new environment properties to the
  application.

> **Note** `management.endpoint.env.post.enabled=true` must be set in the application config
> properties of the application and a corresponding, editable environment must be present in the
> application.

![Environment Page in the UI showing many properties.](images/environment-1.png)

![Environment Page in the UI showing text properties that can be edited.](images/environment-2.png)

## <a id="log-levels-page"></a> Log Levels page

To navigate to the **Log Levels** page, the user can select the **Log Levels** option from the
**Information Category** drop-down menu.
The log levels page provides access to the application’s loggers and the configuration of their levels.

The user can configure the log levels such as INFO, DEBUG, and TRACE in real time from the UI.
The user can search for a package and edit its respective log level.
The user can configure the log levels at a specific class and package.
They can deactivate all the log levels by modifying the log level of root logger to OFF.

The toggle **Changes Only** displays the changed log levels.
The search feature enables the user to search by logger name.
The **Reset** resets the log levels to the original state.
The **Reset All** on top right corner of the page resets all the loggers to default state.

> **Note** The UI allows the user to change the log levels and see the live changes on the application.
> These changes are temporary and will go away if the underlying pod gets restarted.

![Log Levels Page in the UI showing many loggers.](images/log-levels.png)

## <a id="threads-page"></a> Threads page

To navigate to the **Threads** page, the user can select the **Threads** option from the
**Information Category** drop-down menu.

This page displays all details related to JVM threads and running processes of the application.
This tracks live threads and daemon threads real-time. It is a snapshot of different thread states.
Navigating to a thread state displays all the information about a particular thread and its stack trace.

The search feature enables the user to search for threads by thread ID or state.
The refresh icon refreshes to the latest state of the threads.
The user can view more thread details by clicking on the Thread ID.
The page also has a feature to download thread dump for analysis purposes.

![Threads Page in the UI showing thread identities and statuses.](images/threads-1.png)

![Thread Details Page in the UI showing in-depth details for a thread.](images/threads-2.png)

## <a id="memory-page"></a> Memory page

To navigate to the **Memory** page, the user can select the **Memory** option from the
**Information Category** drop-down menu.

- The memory page highlights the memory use inside of the JVM. It displays a graphical representation
  of the different memory regions within heap and non-heap memory.
  This visualizes data from inside of the JVM (in case of Spring Boot apps running on a JVM) and
  therefore provides memory insights into the application in contrast to "outside" information about
  the Kubernetes pod level.
- The real-time graphs displays a stacked overview of the different spaces in memory with the total
  memory used and total memory size. The page contains graphs to display the GC pauses and GC events.
- The **Heap Dump** at the top-right corner enables the user to download heap dump data.

![Memory Page in the UI showing four graphs. The top-left graph is selected.](images/memory.png)

>**Note** This graphical visualization happens in real time and shows real-time data only.
As mentioned at the top, the Application Live View features do not store any information.
That means the graphs visualize the data over time only for as long as you stay on that page.

## <a id="request-mappings-page"></a> Request Mappings page

To navigate to the Request Mappings page, the user should select the **Request Mappings** option from
the **Information Category** drop-down menu.

This page provides information about the application’s request mappings.
For each of the mapping, it displays the request handler method.
The user can view more details of the request mapping such as header metadata of the application.

When a user clicks on the request mapping, a side panel appears.
This panel contains information about the mapping-media types `Produces` and `Consumes`.
The panel also displays the `Handler` class for the request.
The search feature enables the user to search on the request mapping or the method.
The toggle **/actuator/\*\* Request Mappings** displays the actuator related mappings of the
application.

> **Note** When application actuator endpoint is exposed on `management.server.port`, the application
> does not return any actuator request mappings data in the context.
> The application displays a message when the actuator toggle is enabled.

![Request Mappings Page in the UI. A search text box is at the top right.](images/request-mappings-1.png)

![Request Mappings Details Page in the UI showing a handler and what it produces.](images/request-mappings-2.png)

## <a id="http-requests-page"></a> HTTP Requests page

To navigate to the HTTP Requests page, the user should select the **HTTP Requests** option from the
**Information Category** drop-down menu.
The HTTP Requests page provides information about HTTP request-response exchanges to the application.

The graph visualizes the requests per second indicating the response status of all the requests.
The user can filter on the response statuses which include info, success, redirects, client-errors,
server-errors.
The trace data is captured in detail in a tabular format with metrics such as timestamp, method, path,
status, content-type, length, time.

The search feature on the table filters the traces based on the search field value.
The user can view more details of the request such as method, headers, response of the application
by clicking on the timestamp.
The refresh icon above the graph loads the latest traces of the application.
The toggle **/actuator/\*\*** on the top right corner of the page displays the actuator related
traces of the application.

>**Note** When application actuator endpoint is exposed on management.server.port, no actuator
HTTP Traces data is returned for the application.
In this case, a message is displayed when the actuator toggle is enabled.

![HTTP Requests Page in the UI showing a graph and, below it, a list of the latest requests.](images/http-requests-1.png)

![HTTP Request Details Page in the UI. The Close button for the Details page is at the bottom.](images/http-requests-2.png)

## <a id="caches-page"></a> Caches page

To navigate to the **Caches** page, the user can select the **Caches** option from the
**Information Category** drop-down menu.

The Caches page provides access to the application’s caches.
It gives the details of the cache managers associated with the application including the fully
qualified name of the native cache.

The search feature in the Caches Page enables the user to search for a specific cache/cache manager.
The user can clear individual caches by clicking **Evict**.
The user can clear all the caches completely by clicking **Evict All**.
If there are no cache managers for the application, the message
`No cache managers available for the application` is displayed.

![Caches Page in the UI that shows a table for cache names and targets.](images/caches.png)

## <a id="config-props-page"></a> Configuration Properties page

To navigate to the **Configuration Properties** page, the user can select the
**Configuration Properties** option from the **Information Category** drop-down menu.

The configuration properties page provides information about the configuration properties of the application.
In case of Spring Boot, it displays application's @ConfigurationProperties beans.
It gives a snapshot of all the beans and their associated configuration properties.
The search feature allows the user to look up for property's key/value or the bean name.

![Configuration Properties Page in the UI. The search text box is at the top right.](images/config-props.png)

## <a id="conditions-page"></a> Conditions page

To navigate to the **Conditions** page, the user can select the **Conditions** option from the
**Information Category** drop-down menu.
The conditions evaluation report provides information about the evaluation of conditions on
configuration and auto-configuration classes.

In case of Spring Boot, this gives the user a view of all the beans configured in the application.
When the user clicks on the bean name, the conditions and the reason for the conditional match is
displayed.

In case of not configured beans, it shows both the matched and unmatched conditions of the bean if any.
In addition to this, it also displays names of unconditional auto configuration classes if any.
The user can filter out on the beans and the conditions using the search feature.

![Conditions Page in the UI. The search text box is at the top right.](images/conditions.png)

## <a id="scheduled-tasks-page"></a> Scheduled Tasks page

To navigate to the **Scheduled Tasks** page, the user can select the **Scheduled Tasks** option from
the **Information Category** drop-down menu.

The scheduled tasks page provides information about the application's scheduled tasks.
It includes cron tasks, fixed delay tasks and fixed rate tasks, custom tasks and the properties
associated with them.

The user can search for a particular property or a task in the search bar to retrieve the task or
property details.

![Scheduled Tasks Page in the UI. The search text box is at the top right.](images/scheduled-tasks.png)

## <a id="beans-page"></a> Beans page

To navigate to the **Beans** page, the user can select the **Beans** option from the
**Information Category** drop-down menu.
The beans page provides information about a list of all application beans and its dependencies.
It displays the information about the bean type, dependencies, and its resource.
The user can search by the bean name or its corresponding fields.

![Beans Page in the UI. The search text box is at the top right.](images/beans.png)

## <a id="metrics-page"></a> Metrics page

To navigate to the **Metrics** page, the user can select the **Metrics** option from the
**Information Category** drop-down menu.

The metrics page provides access to application metrics information.
The user can choose from the list of various metrics available for the application such as
`jvm.memory.used`, `jvm.memory.max`, `http.server.request`, and so on.

After the metric is chosen, the user can view the associated tags.
The user can choose the value of each of the tags based on filtering criteria.
Clicking **Add Metric** adds the metric to the page which is refreshed every 5 seconds by default.

The user can pause the auto refresh feature by deactivating the **Auto Refresh** toggle.
The user can also refresh the metrics manually by clicking **Refresh All**.
The format of the metric value can be changed according to the user's needs.
They can delete a particular metric by clicking the minus symbol in the same row.

![Metrics Page in the UI. The ADD METRIC button is at the far right.](images/metrics.png)

## <a id="actuator-page"></a> Actuator page

To navigate to the **Actuator** page, the user can select the **Actuator** option from the
**Information Category** drop-down menu.
The actuator page provides a tree view of the actuator data.
The user can choose from a list of actuator endpoints and parse through the raw actuator data.

![Actuator Page in the UI. The ENDPOINT drop-down menu is at the top left, below the Information Category drop-down menu.](images/actuator.png)

## <a id="troubleshooting"></a> Troubleshooting

You might run into cases where a workload running on your cluster does not show up in the
Application Live View overview, the detail pages do not load any information while running, or similar
issues.
See [Troubleshooting](../../app-live-view/troubleshooting.md) in the Application Live View
documentation.

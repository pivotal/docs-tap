# Application Live View for Steeltoe Applications in Tanzu Application Platform GUI

This topic describes Application Live View pages for Steeltoe Applications in Tanzu Application Platform GUI.


### <a id="details-page"></a> Details page

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


### <a id="health-page"></a> Health page

To navigate to the health page, the user can select the **Health** option from the
**Information Category** drop-down menu.
The health page provides detailed information about the health of the application.
It lists all the components that make up the health of the application such as readiness, liveness,
and disk space.
It displays the status, details associated with each of the components.


### <a id="environment-page"></a> Environment page

To navigate to the **Environment** page, the user can select the **Environment** option from the
**Information Category** drop-down menu.
The Environment page contains details of the applications' environment.
It contains properties including, but not limited to, system properties, environment variables, and configuration properties (such as appsettings.json) in a Steeltoe application.

The page includes the following features:

- The UI has search feature that enables the user to search for a property or values.
- Each property has a search icon at the right corner which helps the user quickly see all the occurrences of a specific property key without manually typing in the search field. Clicking the search button trims down the page to that property name.
- The **Refresh Scope** on the top right corner of the page probes the application to refresh all the environment properties.
- The user can edit existing property by clicking the **Override** in the row and editing the value. After the value is saved, the user can see the updated property in the Applied overrides section at the top of the page.
- The **Reset** resets the environment property to the original state
- The user can edit or remove the overridden environment variables in the **Applied Overrides** section.
- The **Applied Overrides** section also enables the user to add new environment properties to the application.

> **Note:** The `management.endpoint.env.post.enabled=true` has to be set in the application config
> properties of the application and a corresponding, editable Environment has to be present in the
> application.


### <a id="log-levels-page"></a> Log Levels page

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


### <a id="threads-page"></a> Threads page

To navigate to the **Threads** page, the user can select the **Threads** option from the
**Information Category** drop-down menu.

This page displays all details related to CLR threads and running processes of the application.
This tracks worker threads and completion port threads real-time.
Navigating to a thread state displays all the information about a particular thread and its stack trace.

The refresh icon refreshes to the latest state of the threads.
The user can view more thread details by clicking on the Thread ID.
The page also has a feature to download thread dump for analysis purposes.


### <a id="memory-page"></a> Memory page

To navigate to the **Memory** page, the user can select the **Memory** option from the
**Information Category** drop-down menu.

This page displays all details related to used and committed memory of the application. This also displays the garbage collection count by generation(gen0/gen1).
The page also has a feature to download heap dump for analysis purposes.


### <a id="metrics-page"></a> Metrics page

To navigate to the **Metrics** page, the user can select the **Metrics** option from the
**Information Category** drop-down menu.


The metrics page provides access to application metrics information.
The user can choose from the list of various metrics available for the application such as
`clr.memory.used`, `System.Runtime.gc-committed`, `clr.threadpool.active`, and so on.

After the metric is chosen, the user can view the associated tags.
The user can choose the value of each of the tags based on filtering criteria.
Clicking **Add Metric** adds the metric to the page which is refreshed every 5 seconds by default.

The user can pause the auto refresh feature by disabling the **Auto Refresh** toggle.
The user can also refresh the metrics manually by clicking **Refresh All**.
The format of the metric value can be changed according to the user's needs.
They can delete a particular metric by clicking the minus symbol in the same row.


### <a id="actuator-page"></a> Actuator page

To navigate to the **Actuator** page, the user can select the **Actuator** option from the
**Information Category** drop-down menu.
The actuator page provides a tree view of the actuator data.
The user can choose from a list of actuator endpoints and parse through the raw actuator data.


## <a id="troubleshooting"></a> Troubleshooting

You might run into cases where a workload running on your cluster does not show up in the
Application Live View overview, the detail pages do not load any information while running, or similar issues.
See [Troubleshooting](../../app-live-view/troubleshooting.md) in the Application Live View documentation.
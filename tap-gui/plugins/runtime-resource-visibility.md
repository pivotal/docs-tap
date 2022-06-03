# Runtime resources visibility

This topic describes runtime resources visibility.


## <a id="Introduction"></a> Introduction

Runtime Resources Visibility plug-in part of Tanzu Application Platform GUI allows users to
visualize their Kubernetes resources associated with their Workloads.


## <a id="prerequisite"></a> Prerequisite

In order to access the Runtime Resources Visibility plug-in, you must first have successfully
[installed Tanzu Application Platform](../../install-intro.md), which includes
Tanzu Application Platform GUI.


## <a id="Visualize-app"></a> Visualize Workloads on Tanzu Application Platform GUI

In order to view your applications on Tanzu Application Platform GUI, use the following steps:

1. [Develop your application on the Tanzu Application Platform via Application Accelerators](../../getting-started.html#dev-first-app)
2. [Add your application to Tanzu Application Platform GUI Software Catalog](../../getting-started.html#add-app-to-gui-cat)


## <a id="nav-rr-vis-screen"></a> Navigate to the **Runtime Resources Visibility** screen

You can view the list of running resources and the details of their status, type, namespace, cluster,
and public URL if applicable for the resource type.

To view the list of your running resources:

1. Select your component from the Catalog index page.

   ![Screenshot of selecting component on runtime resources index table](images/runtime-resources-components.png)

2. Select the **Runtime Resources** tab.

   ![Screenshot of selecting Runtime resources tab](images/runtime-resources-index.png)

### <a id="resources-included"></a> Resources

These built-in Kubernetes resources are included in this view:

- Services
- Deployments
- ReplicaSets
- Pods

The Runtime Resource Visibility plug-in will also display CRDs created with the [Supply Chain](./scc-tap-gui.md), including:

- Cartographer Workloads
- Knative Services, Configurations, Revisions, and Routes

This example ilustrates how CRDs from Supply Chain (yellow) are associated with Knative Resources (orange) and built-in ones (red).

![Screenshot of OwnerShip card](images/runtime-resources-crd-hierarchy.png)

## <a id="knative-service-details"></a> Knative service details page

To view details about your Knative services, select any resource that has a Knative Service type.
In this page, additional information is available for Knative resources, including:

- status
- an ownership hierarchy
- incoming routes
- revisions
- pod details

![Screenshot of Java web app deployment page](images/runtime-resources-knative-service-details.png)


## <a id="detail-pages"></a> Detail pages

The Runtime Resources Visibility plug-in provides additional details of the Kubernetes resources in
the Detail pages.


### <a id="overview-card"></a> Overview card

All detail pages provide an overview card with information related to the selected resource.
Most of the information feeds from the `metadata` attribute in each object.
The following are some attributes that are displayed in the overview card:

- **View Pod Logs** button
- **View .YAML** button
- URL, which is for Knative and Kubernetes service detail pages
- Type
- System
- Namespace
- Cluster

![Screenshot of Tanzu web app default URL](images/runtime-resources-overview.png)

Note: View CPU, Memory, and Threads details are only available for Applications supporting Application Live View


### <a id="status-card"></a>Status card

The status section displays all of the conditions in the resource's attribute `status.conditions`.
Not all resources have conditions, and they can vary from one resource to the other.

For more information about object `spec` and `status`, see the
[Kubernetes documentation](https://kubernetes.io/docs/concepts/_print/#object-spec-and-status).

![Screenshot of condition types and status conditions](images/runtime-resources-status.png)


### <a id="ownership-card"></a>Ownership card

Depending on the resource that you are viewing, the ownership section displays all the resources
specified in `metadata.ownerReferences`. You can use this section to navigate between resources.

For more information about owners and dependents, see the
[Kubernetes documentation](https://kubernetes.io/docs/concepts/overview/working-with-objects/owners-dependents/).

![Screenshot of metadata owner references](images/runtime-resources-ownership.png)


### <a id="annotations"></a>Annotations and Labels

The Annotations and Labels card displays information about `metadata.annotations` and `metadata.labels`.

![Screenshot of Annotations and Labels sections](images/runtime-resources-annotations.png)


## <a id="selecting-supply-chain-pods"></a>Selecting Completed Supply Chain Pods

Completed Supply Chain Pods (Build Pods and ConfigWriter Pods) are hidden by default in the index table.
Users can choose to show them via the Show Additional Resources dropdown, above the Resources index table.
This dropdown is only visible if the resources include Build and/or ConfigWriter Pods.

![Screenshot of Completed Supply Chain Pods dropdown](images/runtime-resources-supply-chain-pods.png)


## <a id="navigating-to-pods"></a>Navigating to Pod Details Page

Users can see the pod table in each resource details page, as shown in the following screenshot.

![Screenshot of object detail table listing pod](images/runtime-resources-pods.png)

### <a id="pod-details-metrics"></a> Understanding Pod Metrics

The overview card displays the user-configured resource limits on the Pod, defined as per the Kubernetes documentation for [Configuring Pods Limits](https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/). These limits do not represent actual real-time resource usage. ([The Live View Plugin can help you with that!](app-live-view-springboot.md#a-id"threads-page"a-threads-page))

Each container displays its resource limits, if defined:

![Container limits](images/runtime-resources-container-metrics-pod-page.png)

Pods display the sum of the limits of all their containers. If any container fails to specify a limit, both it and its Pod will be presented as requiring "Unlimited" resources.

![Pod limits overview](images/runtime-resources-pod-limits-overview.png)

Namespace-level resource limits (e.g. [default memory limits](https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/memory-default-namespace/) and [default CPU limits](https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/cpu-default-namespace/)) are not considered as part of these calculations.

These limits apply only for Memory and CPU usage that a Pod or Container could use; Kubernetes manage these resource units using a binary base as is explained on their [Quantity](https://kubernetes.io/docs/reference/kubernetes-api/common-definitions/quantity/) docs.


## <a id="pod-details"></a>Navigating to Application Live View

To view additional information about your running applications, see the
[Application Live View](app-live-view-springboot.md) section in the Pod Details page.

![Screenshot of Tanzu Java web app runtime resource detail page](images/runtime-resources-pod-details.png)


## <a id="viewing-pod-logs"></a>Viewing pod logs

To view logs for a pod, click **View Pod Logs** from the Pod Details page.
By default, you see all the logs for the pod since its creation for all the pod's containers.

> **Note:** The logs displayed are not streamed in real time. To fetch new log entries, click
> **Refresh** in the upper right corner of the page.

![Screenshot of Pod Logs page, which displays information for Tanzu Java Web App](images/runtime-resources-pod-logs.png)


### <a id="filter-by-container"></a>Filtering by container

To display logs for a specific container only, select the desired container from the **Container**
drop-down menu. Clearing this drop-down menu causes logs for all containers within the pod to appear.


### <a id="filter-by-date-and-time"></a>Filtering by date and time

To see all logs since a specific date and time, select or type the UTC timestamp in the
**Since date** field.
If no logs are displayed, try adjusting the timestamp to an earlier time.
Clear this field to see all logs created since the pod was created.


### <a id="changing-log-levels"></a>Changing log levels

If the pod is associated with an application that supports [Application Live View](app-live-view.html),
you can change the application's log levels by clicking the **Change Log Levels** button.
You then see a panel that allows you to select levels for each logger associated with your application.

![Screenshot of the log levels panel. Info is selected for each logger.](images/runtime-resources-pod-log-levels.png)

To change the levels for your application, select the desired level for each logger presented and then
close the panel by clicking **X** in the upper right corner of the panel or by pressing
the Escape key on your keyboard.

Because adjusting log levels makes a real-time configuration change to your application, log-level
adjustments are only reflected in log entries that your application produces after the change.
Click **Refresh** in the upper right corner of the page to fetch new messages after changing log levels.

After refreshing, if no log entries for the expected levels appear, ensure that:

1. You adjusted the correct application loggers
1. You are viewing logs for the correct container and time frame
1. Your application is producing logs at the expected levels. Your application might be
idling or otherwise not running a code path that invokes the desired logger.

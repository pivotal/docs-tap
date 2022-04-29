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


## <a id="knative-service-details"></a> Knative service details page

To view details about your Knative services, select any resource that has a Knative Service type.
In this page, additional information is available for Knative resources, including:

- status
- an ownership hierarchy
- incoming routes
- revisions
- pod details

![Screenshot of Java web app deployment page](images/runtime-resources-details.png)


## <a id="view-resource-details"></a> View details for a specific resource

The Resources index table shows Knative Services, Deployments, pods, ReplicaSets and
Kubernetes Services that match the label indicated in the component's definition.

You can see a hierarchical structure showing the owner-dependent relationship between the objects.
Resources without an owner are listed in the table as independent elements.

For information about owners and dependents, see the
[Kubernetes documentation](https://kubernetes.io/docs/concepts/overview/working-with-objects/owners-dependents/).

See the following example of an expanded index table showing one of the owner resources and its dependents.

![Screenshot of Tanzu Java web app Runtime resources expanded](images/runtime-resources-expanded.png)


## <a id="detail-pages"></a> Detail pages

The Runtime Resources Visibility plug-in provides additional details of the Kubernetes resources in
the Detail pages.


### <a id="overview-card"></a> Overview card

All detail pages provide an overview card with information related to the selected resource.
Most of the information feeds from the `metadata` attribute in each object.
The following are some attributes that are displayed in the overview card:

- .YAML button
- URL (URL is available for Knative services and Kubernetes services)
- Type
- System
- Namespace
- Cluster

![Screenshot of Tanzu web app default url](images/runtime-resources-overview.png)


### <a id="status-card"></a>Status card

The status section displays all of the conditions in the resource's attribute `status.conditions`.
Not all resources have conditions, and they can vary from one resource to the other.

For more information, see
[Concepts - Object Spec and Status](https://kubernetes.io/docs/concepts/_print/#object-spec-and-status)
in the Kubernetes documentation.

![Screenshot of condition types and status conditions](images/runtime-resources-status.png)


### <a id="ownership-card"></a>Ownership card

Depending on the resource that you are viewing, the ownership section presents all the resources
specified in the `metadata.ownerReferences`. You can use this section to navigate between resources.

See [Owners and Dependents](https://kubernetes.io/docs/concepts/overview/working-with-objects/owners-dependents/) in the Kubernetes documentation.

![Screenshot of metadata owner references](images/runtime-resources-ownership.png)


### <a id="annotations"></a>Annotations and Labels

The Annotations and Labels card show information about `metadata.annotations` and `metadata.labels`.

![Screenshot of Annotations and Labels sections](images/runtime-resources-annotations.png)


## <a id="navigating-to-pods"></a>Navigating to Pod Details Page

You can navigate directly to the Pod Details page from the Resources index table.

![Screenshot of Tanzu java web app runtime resources accessing pod from index table](images/runtime-resources-index-pod.png)

Alternatively, you can see the pod table in each resource details page as shown in the following screenshot.

![Screenshot of object detail table listing pod](images/runtime-resources-pods.png)


## <a id="pod-details"></a>Navigating to Application Live View

To view additional information about your running applications, see the
[Application Live View](app-live-view.md) section in the Pod Details page.

![Screenshot of Tanzu Java web app runtime resource detail page](images/runtime-resources-pod-details.png)

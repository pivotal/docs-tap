# Workload Visibility User Guide

The Workload Visibility screen enables developers to view the details and status of their Kubernetes
workloads, to understand their structure, and debug any issues.

## Before You Begin

Developers need to perform the following actions to see their running workloads on the dashboard:

* Define a Backstage System. See [Systems](../catalog/catalog-operations.md#systems) in the Catalog Operations documentation.
* Define a Backstage Component. See [Components](../catalog/catalog-operations.md#components) in the Catalog Operations documentation. The Backstage Component must:
  * Refer to the System from the previous step (at `.spec.system`).
  * Specify a `backstage.io/kubernetes-label-selector` annotation (at `.metadata.annotations`).
* Commit and push the System and Component definitions to a Git repository that is registered
  as a Catalog Location. See [Adding Catalog Entities](../catalog/catalog-operations.md#adding-catalog-entities) in the Catalog Operations documentation..
* Create a Kubernetes Workload:
  * In a cluster available to the TAP GUI.
  * With labels that satisfy the new Component's label selector.


## Navigate to the Workload Visibility Screen

You can view the list of running workloads and details about their status, type, namespace, cluster, and public URL if applicable for the workload type.

To view the list of your running workloads:

1. Select the Component from the Catalog index page.
1. Select the Workloads tab.

![Workload index table](./images/workload-visibility-workloads.png)

## Resource Details

Each resource has a dedicated page showing its detailed status, metadata, ownership, and related resources.

![Resource detail page](./images/workload-visibility-resource-detail.png)
# Workload Visibility User Guide

The Workload Visibility screen enables developers to view the details and status of their Kubernetes
Workloads, to understand their structure, and debug any issues.

## Before You Begin

Developers need to perform the following actions to see their running Workloads on the dashboard:

* Define a Backstage Component with a `backstage.io/kubernetes-label-selector` annotation. See
  [Components](../catalog/catalog-operations.md#components) in the Catalog Operations documentation.
  ```yaml
  apiVersion: backstage.io/v1alpha1
  kind: Component
  metadata:
    name: petclinic
    description: Spring PetClinic
    annotations:
      'backstage.io/kubernetes-label-selector': 'app.kubernetes.io/part-of=petclinic-server'
  spec:
    type: service
    lifecycle: demo
    owner: default-team
    system:
  ```

* Commit and push the Component definition to a Git repository that is registered as a Catalog Location. See [Adding
  Catalog Entities](../catalog/catalog-operations.md#adding-catalog-entities) in the Catalog Operations documentation.
* Create a Kubernetes Workload, with a label matching the Component's selector, in a cluster available to the TAP
  GUI. A Workload is one of:
  * `v1/Service`
  * `apps/v1/Deployment`
  * `serving.knative.dev/v1/Service`

  ```shell
  $ cat <<EOF | kubectl apply -f -
  ---
  apiVersion: serving.knative.dev/v1
  kind: Service
  metadata:
    name: petclinic
    namespace: default
    labels:
      'app.kubernetes.io/part-of': petclinic-server
  spec:
    template:
      metadata:
        labels:
          'app.kubernetes.io/part-of': petclinic-server
      spec:
        containers:
          - image: springcommunity/spring-framework-petclinic
  EOF
  ```

## Navigate to the Workload Visibility Screen

You can view the list of running Workloads and details about their status, type, namespace, cluster, and public URL if applicable for the Workload type.

To view the list of your running Workloads:

1. Select the Component from the Catalog index page.
1. Select the Workloads tab.

![Workload index table](./images/workload-visibility-workloads.png)

## Resource Details

Each resource has a dedicated page showing its detailed status, metadata, ownership, and related resources.

![Resource detail page](./images/workload-visibility-resource-detail.png)
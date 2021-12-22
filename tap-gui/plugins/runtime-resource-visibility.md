# Runtime resources visibility

The Runtime Resources tab shows developers the details and status of their component's Kubernetes resources to understand their structure and debug issues.


## <a id="before-begin"></a>Before you begin

To ensure that your component and its resources are displayed, you need:

- A YAML file describing your component.
- All resources created for your application must specify a label `'app.kubernetes.io/part-of'` with your application's name.

###  <a id="automated-options"></a>Automated options

We offer two options to speed up the process of displaying your application's resources:

- You can use [Tanzu Developer Tools for Visual Studio Code](../../vscode-extension/about.md) to automate the creation of the component's YAML and its resources. For information about the YAML files, see [Get set up with snippets](../../vscode-extension/usage-getting-started.md).
- Use [Application Accelerator](application-accelerator.md). You can use **TAP Initializer** to generate the required files. You can access it through the Tanzu Application Platform GUI by using `<TAP-GUI-URL>/create/templates/tap-initialize`.

### <a id="manual-process"></a>Manual process

Developers must perform the following actions to see their resources on the dashboard:

1. Define a Backstage component with a `backstage.io/kubernetes-label-selector` annotation. See
  [Components](../catalog/catalog-operations.md#components) in the Catalog Operations documentation.

    ```
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

2. Commit and push the component definition, created in the previous steps, to a Git repository that is registered as a Catalog Location. See [Adding
  Catalog Entities](../catalog/catalog-operations.md#adding-catalog-entities) in the Catalog Operations documentation.
3. Create a Kubernetes resource with a label matching the component's selector in a cluster available to Tanzu Application Platform GUI. A resource is one of the following:

    - `v1/Service`
    - `apps/v1/Deployment`
    - `serving.knative.dev/v1/Service`

    For example:

      ```
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
   




## <a id="navigate-runtime-resources-visibility"></a>Navigate to the Runtime Resources visibility screen

You can view the list of running resources and details about their status, type, namespace, cluster, and public URL if
applicable for the resource type.

To view the list of your running resources:

1. Select your component from the Catalog index page.

   ![Screenshot of selecting component on runtime resources index table](images/runtime-resources-components.png)

2. Select the **Runtime Resources** tab.

   ![Screenshot of selecting Runtime resources tab](images/runtime-resources-index.png)

### <a id="view-resource-details"></a>View details for a specific resource

The Resources index table shows Deployments, Pods, ReplicaSets and Services that match the label indicated in the component's definition. You can see a hierarchical structure showing the owner-dependent relationship between the objects. Resources without an owner are listed in the table as independent elements.

For information about owners and dependents, see [Kubernetes documentation](https://kubernetes.io/docs/concepts/overview/working-with-objects/owners-dependents/).

Here is an example of the expanded index table showing one of the owner resources and its dependents.

![Runtime resources index table collapsed](images/runtime-resources-expanded.png)

## <a id="detail-pages"></a>Detail pages

The Runtime Runtime Resources visibility plug-in provides detail pages with the most relevant characteristics of many resources, including direct links to other ones.

These following sections explain the boxes included on all detail pages:

### <a id="overview-section"></a>Overview section

The overview section is the first card in every detail page. Most of the information in it comes from the `metadata` attribute in each object. 
Some attributes displayed here include:

  1. **.YAML** button: When you click on the **.YAML** button, a side panel opens showing the current object's definition in YAML. You can copy the full content of the **.YAML** file by using the icon in the top-right corner of the side panel..
  2. Name
  3. Namespace
  4. Age or Creation date
  5. Cluster: The value displayed corresponds to the name used in the cluster's configuration.
  6. URL: URL is available for Knative services and Kubernetes services.

![Overview section](images/runtime-resources-overview.png)

### <a id="status-section"></a>Status section

The status section displays all of the conditions included in the resource's attribute `status.conditions`. Not all resources have conditions, and they could be different for each resource.

See [Concepts - Object Spec and Status](https://kubernetes.io/docs/concepts/_print/#object-spec-and-status) in the Kubernetes documentation.

![Status section](images/runtime-resources-status.png)

### <a id="ownership-section"></a>Ownership section

Depending on the resource that you are viewing, the ownership section presents all the resources specified in the `metadata.ownerReferences`. You can use this section to navigate between resources.

See [Owners and Dependents](https://kubernetes.io/docs/concepts/overview/working-with-objects/owners-dependents/) in the Kubernetes documentation.

![Ownership section](images/runtime-resources-ownership.png)

### <a id="annotations"></a>Annotations and Labels

The Annotations and Labels sections show information on `metadata.annotations` and `metadata.labels`.

![Annotations and Labels sections](images/runtime-resources-annotations.png)

## <a id="navigating-to-pods"></a>Navigating to Pods

You can navigate directly to the Pod's detail page from the Resources index table.

![Accessing pod from index table](images/runtime-resources-index-pod.png)

You can use the table listing Pods in each owner object's detail page. Columns can be different on each detail page.

![Accessing pod from home](images/runtime-resources-pods.png)

## <a id="knative-service-details"></a>Knative service details page

To view details about your Knative services, select any resource that has the "Knative Service" type.
In this page, additional information is available for Knative resources including status, an ownership hierarchy, 
incoming routes, revisions, and pod details.

![Resource detail page](images/runtime-resources-details.png)

## <a id="pod-details"></a>Pod details page

This page shows you most relevant information for a specific Pod including its containers and the [Application Live View information](./app-live-view.md) information.

![Resource detail page](images/runtime-resources-pod-details.png)

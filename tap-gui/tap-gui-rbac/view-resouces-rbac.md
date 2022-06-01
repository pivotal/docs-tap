# View Runtime Resources on Authorization-Enabled Clusters in Tanzu Application Platform GUI

To visualize runtime resources on Authorization-enabled clusters in Tanzu Application Platform GUI, you will need to proceed to the Software Catalog `Component` of choice and click on the `Runtime Resources` tab on the top of ribbon.

![Screenshot of Runtime Resources](./../images/tap-gui-multiple-clusters.png)

Once you click on `Runtime Resources`, Tanzu Application Platform GUI will use your credentials to query the clusters for the respective Runtime Resources. The system will check if you are authenticated with the OIDC providers configured for the remote clusters. If you are not authenticated, the system shall prompt for your OIDC credentials.

Visibility of remote clusters that are not restricted by Authorization, is done through the general Service Account of Tanzu Application Platform GUI and is not restricted for users. For more information on how to set up unrestrictred remote cluster visibility, please refer to [Viewing resources on multiple clusters in Tanzu Application Platform GUI](./../cluster-view-setup.md).

The type of query to the remote cluster will depend on the definition of the Software Catalog `Component`. In Tanzu Application Platform GUI, there are two types of `Components`:
  
  - [Globally-scoped Components](#-globally-scoped-components)
  - [ Namespace-scoped Components](#-namespace-scoped-components)

This property of the Component is important to distinguish because it is going to affect runtime resource visibility depending on your permissions on a specific cluster.

If your permissions on the Authorization-enabled cluster are limited to specific namespaces, you will not have visibility into `Runtime Resources` of globally-scoped Components.

To have visibility into `Runtime Resources` of globally-scoped Components, you will need to have cluster-scoped access.

## <a id="globally-scoped-components"></a> Globally-scoped Components

For globally-scoped Components, when you access `Runtime Resources`, Tanzu Application Platform GUI will query all Kubernetes namespaces for runtime resources that with a matching `kubernetes-label-selector` (usually with a `part-Of` prefix).

For example, `demo-component-a` does not have a `kubernetes-namespace` in the metadata.annotations section, making is a globally-scoped component:

```yaml
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: demo-component-a
  description: Demo Component A
  tags:
    - java
  annotations:
    'backstage.io/kubernetes-label-selector': 'app.kubernetes.io/part-of=component-a'
spec:
  type: service
  lifecycle: experimental
  owner: team-a
```

## <a id="namespace-scoped-components"></a> Namespace-scoped Components

If a Component is namespace-scoped, when you access `Runtime Resources`, Tanzu Application Platform GUI will query only the associated Kubernetes namespace for each remote cluster that is visible to Tanzu Application Platform GUI.  

To make a Component namespace-scoped, you will need to pass the following annotation to the Component's definition YAML file:

```yaml
annotations:
  'backstage.io/kubernetes-namespace': NAMESPACE-NAME
```
Where:
   - `NAMESPACE-NAME` is the Kubernetes namespace you want to associate your Component with.


For example, `demo-component-b` has a `kubernetes-namespace` in the metadata.annotations section, associating it with the `component-b` namespaces on each of the visibile clusters, making is a namespace-scoped component:

```yaml
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: demo-component-b
  description: Demo Component B
  tags:
    - java
  annotations:
    'backstage.io/kubernetes-label-selector': 'app.kubernetes.io/part-of=component-b'
    'backstage.io/kubernetes-namespace': component-b
spec:
  type: service
  lifecycle: experimental
  owner: team-b
```

When the `kubernetes-namespace` annotation is absent, the Component is considered globally-scoped by default. For more information, please refer to [Adding Namespace Annotation](https://backstage.io/docs/features/kubernetes/configuration#adding-the-namespace-annotation).

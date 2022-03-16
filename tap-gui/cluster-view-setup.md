# Viewing resources on multiple clusters in Tanzu Application Platform GUI

Tanzu Application Platform GUI can be configured to retrieve Kubernetes object details from multiple clusters and to surface those details in the Runtime Resources Visibility plug-in.

## <a id="set-up-view-resources"></a>Set up a Service Account to view resources on a cluster

A service account must be created on the cluster that can `get`, `watch`, and `list` resources on that cluster. Create a `ClusterRole` with these rules and a `ServiceAccount` in its own `Namespace`, and then bind the `ClusterRole` to the `ServiceAccount`.

This YAML creates the `Namespace`, `ServiceAccount`, `ClusterRole`, and `ClusterRoleBinding`. Copy it into a file called `tap-gui-viewer-service-account-rbac.yaml`.

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: tap-gui
---
apiVersion: v1
kind: ServiceAccount
metadata:
  namespace: tap-gui
  name: tap-gui-viewer
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: tap-gui-read-k8s
subjects:
- kind: ServiceAccount
  namespace: tap-gui
  name: tap-gui-viewer
roleRef:
  kind: ClusterRole
  name: k8s-reader
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: k8s-reader
rules:
- apiGroups: ['']
  resources: ['pods', 'services', 'configmaps']
  verbs: ['get', 'watch', 'list']
- apiGroups: ['apps']
  resources: ['deployments', 'replicasets']
  verbs: ['get', 'watch', 'list']
- apiGroups: ['autoscaling']
  resources: ['horizontalpodautoscalers']
  verbs: ['get', 'watch', 'list']
- apiGroups: ['networking.k8s.io']
  resources: ['ingresses']
  verbs: ['get', 'watch', 'list']
- apiGroups: ['networking.internal.knative.dev']
  resources: ['serverlessservices']
  verbs: ['get', 'watch', 'list']
- apiGroups: [ 'autoscaling.internal.knative.dev' ]
  resources: [ 'podautoscalers' ]
  verbs: [ 'get', 'watch', 'list' ]
- apiGroups: ['serving.knative.dev']
  resources:
  - configurations
  - revisions
  - routes
  - services
  verbs: ['get', 'watch', 'list']
- apiGroups: ['carto.run']
  resources:
  - clusterconfigtemplates
  - clusterdeliveries
  - clusterdeploymenttemplates
  - clusterimagetemplates
  - clusterruntemplates
  - clustersourcetemplates
  - clustersupplychains
  - clustertemplates
  - deliverables
  - runnables
  - workloads
  verbs: ['get', 'watch', 'list']
- apiGroups: ['source.toolkit.fluxcd.io']
  resources:
  - gitrepositories
  verbs: ['get', 'watch', 'list']
- apiGroups: ['conventions.apps.tanzu.vmware.com']
  resources:
  - podintents
  verbs: ['get', 'watch', 'list']
- apiGroups: ['kpack.io']
  resources:
  - images
  - builds
  verbs: ['get', 'watch', 'list']
- apiGroups: ['scanning.apps.tanzu.vmware.com']
  resources:
  - sourcescans
  - imagescans
  verbs: ['get', 'watch', 'list']
- apiGroups: ['tekton.dev']
  resources:
  - taskruns
  - pipelineruns
  verbs: ['get', 'watch', 'list']
- apiGroups: ['kappctrl.k14s.io']
  resources:
  - apps
  verbs: ['get', 'watch', 'list']
```

Ensure the kubeconfig context is set to the cluster with resources to be viewed in Tanzu Application Platform GUI. Create the `Namespace`, `ServiceAccount`, `ClusterRole` and `ClusterRoleBinding` with the following command:

```
kubectl create -f tap-gui-viewer-service-account-rbac.yaml
```

This cluster must be identified to Tanzu Application Platform GUI with the `ServiceAccount` token and the cluster Kubernetes control plane URL. The `CLUSTER_URL` and `CLUSTER_TOKEN` can be found with these commands:

```bash
CLUSTER_URL=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')

CLUSTER_TOKEN=$(kubectl -n tap-gui get secret $(kubectl -n tap-gui get sa tap-gui-viewer -o=json \
| jq -r '.secrets[0].name') -o=json \
| jq -r '.data["token"]' \
| base64 --decode)

echo CLUSTER_URL: $CLUSTER_URL
echo CLUSTER_TOKEN: $CLUSTER_TOKEN
```

## <a id="view-resourcs-on-clusters"></a>Update Tanzu Application Platform GUI to view resources on multiple clusters

A `kubernetes` section must be added to the `app_config` used by Tanzu Application Platform GUI. Update the `tap-gui-values.yaml` used to install Tanzu Application Platform GUI with an entry to `clusters` for each cluster with resources to view. See the following YAML for the `kubernetes` section, substitute in the `CLUSTER_URL` and `CLUSTER_TOKEN` values found earlier and for `CLUSTER_NAME` give it a unique name to identify this cluster:

```yaml
app_config:
  kubernetes:
    serviceLocatorMethod:
      type: 'multiTenant'
    clusterLocatorMethods:
      - type: 'config'
        clusters:
          - url: <CLUSTER_URL>
            name: <CLUSTER_NAME>
            authProvider: serviceAccount
            serviceAccountToken: "<CLUSTER_TOKEN>"
            skipTLSVerify: true
```
>**Note:** If there are resources to view on the cluster that hosts Tanzu Application Platform GUI, add an entry to `clusters` for it as well.

Update the `tap-gui` package by running this command:

```
tanzu package installed update tap-gui --values-file tap-gui-values.yaml
```

Wait a moment for the `tap-gui` package to update and then verify that `STATUS` is `Reconcile succeeded` by running this command:

```
tanzu package installed get tap-gui -n tap-install
```

## <a id="view-resources-plug-in"></a>View resources on multiple clusters in the Runtime Resources Visibility plug-in

Navigate to the Runtime Resources Visibility plug-in for a component that is running on multiple clusters. Multiple resources and their status across the clusters are displayed.

![Tanzu Application Platform Runtime Resources](./images/tap-gui-multiple-clusters.png)

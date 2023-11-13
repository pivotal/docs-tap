# View resources on multiple clusters in Tanzu Developer Portal

You can configure Tanzu Developer Portal to retrieve Kubernetes object details from multiple
clusters and then surface those details in the various Tanzu Developer Portal plug-ins.

> **Important** In this topic the terms `Build`, `Run`, and `View` describe the cluster's roles and
> distinguish which steps to apply to which cluster.
>
> `Build` clusters are where the code is built and packaged, ready to be run.
>
> `Run` clusters are where the Tanzu Application Platform workloads themselves run.
>
> `View` clusters are where the Tanzu Developer Portal is run from.
>
> In multicluster configurations, these can be separate clusters. However, in many configurations
> these can also be the same cluster.

## <a id="set-up-service-account"></a> Set up a Service Account to view resources on a cluster

To view resources on the `Build` or `Run` clusters, create a service account on the `View` cluster
that can `get`, `watch`, and `list` resources on those clusters.

You first create a `ClusterRole` with these rules and a `ServiceAccount` in its own `Namespace`, and
then bind the `ClusterRole` to the `ServiceAccount`. Depending on your topology, not every cluster
has all of the following objects. For example, the `Build` cluster doesn't have any of the
`serving.knative.dev` objects, by design, because it doesn't run the workloads themselves.
You can edit the following object lists to reflect your topology.

To set up a Service Account to view resources on a cluster:

1. Copy this YAML content into a file called `tap-gui-viewer-service-account-rbac.yaml`.

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
      resources: ['pods', 'pods/log', 'services', 'configmaps', 'limitranges']
      verbs: ['get', 'watch', 'list']
    - apiGroups: ['metrics.k8s.io']
      resources: ['pods']
      verbs: ['get', 'watch', 'list']
    - apiGroups: ['apps']
      resources: ['deployments', 'replicasets', 'statefulsets', 'daemonsets']
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
    - apiGroups: ['source.apps.tanzu.vmware.com']
      resources:
      - imagerepositories
      - mavenartifacts
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
      - scanpolicies
      - scantemplates
      verbs: ['get', 'watch', 'list']
    - apiGroups: ['app-scanning.apps.tanzu.vmware.com']
      resources:
      - imagevulnerabilityscans
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
    - apiGroups: [ 'batch' ]
      resources: [ 'jobs', 'cronjobs' ]
      verbs: [ 'get', 'watch', 'list' ]
    - apiGroups: ['conventions.carto.run']
      resources:
      - podintents
      verbs: ['get', 'watch', 'list']
    - apiGroups: ['appliveview.apps.tanzu.vmware.com']
      resources:
      - resourceinspectiongrants
      verbs: ['get', 'watch', 'list', 'create']
    - apiGroups: ['apiextensions.k8s.io']
      resources: ['customresourcedefinitions']
      verbs: ['get', 'watch', 'list']
    ```

    This YAML content creates `Namespace`, `ServiceAccount`, `ClusterRole`, and `ClusterRoleBinding`.

2. On the `Build` and `Run` clusters, create `Namespace`, `ServiceAccount`, `ClusterRole`, and
   `ClusterRoleBinding` by running:

    ```console
    kubectl create -f tap-gui-viewer-service-account-rbac.yaml
    ```

3. Again, on the `Build` and `Run` clusters, discover the `CLUSTER_URL` and `CLUSTER_TOKEN` values.

    v1.23 or earlier Kubernetes cluster
    : If you're watching a v1.23 or earlier Kubernetes cluster, run:

      ```console
      CLUSTER_URL=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')

      CLUSTER_TOKEN=$(kubectl -n tap-gui get secret $(kubectl -n tap-gui get sa tap-gui-viewer -o=json \
      | jq -r '.secrets[0].name') -o=json \
      | jq -r '.data["token"]' \
      | base64 --decode)

      echo CLUSTER_URL: $CLUSTER_URL
      echo CLUSTER_TOKEN: $CLUSTER_TOKEN
      ```

    v1.24 or later Kubernetes cluster
    : If you're watching a v1.24 or later Kubernetes cluster, run:

      ```console
      CLUSTER_URL=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')

      kubectl apply -f - <<EOF
      apiVersion: v1
      kind: Secret
      metadata:
        name: tap-gui-viewer
        namespace: tap-gui
        annotations:
          kubernetes.io/service-account.name: tap-gui-viewer
      type: kubernetes.io/service-account-token
      EOF

      CLUSTER_TOKEN=$(kubectl -n tap-gui get secret tap-gui-viewer -o=json \
      | jq -r '.data["token"]' \
      | base64 --decode)

      echo CLUSTER_URL: $CLUSTER_URL
      echo CLUSTER_TOKEN: $CLUSTER_TOKEN
      ```

   > **Note** You can create a short-lived token with the `kubectl create token` command if that is
   > the preferred method. This method requires frequent token rotation.

4. (Optional) Configure the Kubernetes client to verify the TLS certificates presented by a cluster's
   API server. To do this, discover `CLUSTER_CA_CERTIFICATES` by running:

    ```console
    CLUSTER_CA_CERTIFICATES=$(kubectl config view --raw -o jsonpath='{.clusters[?(@.name=="CLUSTER-NAME")].cluster.certificate-authority-data}')

    echo CLUSTER_CA_CERTIFICATES: $CLUSTER_CA_CERTIFICATES
    ```

    Where `CLUSTER-NAME` is your cluster name.

5. Record the `Build` and `Run` clusters' `CLUSTER_URL` and `CLUSTER_TOKEN` values for when you
   [Update Tanzu Developer Portal to view resources on multiple clusters](#update-tap-gui)
   later.

## <a id="update-tap-gui"></a> Update Tanzu Developer Portal to view resources on multiple clusters

The clusters must be identified to Tanzu Developer Portal with the `ServiceAccount` token
and the cluster Kubernetes control plane URL.

You must add a `kubernetes` section to the `app_config` section in the `tap-values.yaml` file that
Tanzu Application Platform used when you installed it.
This section must have an entry for each `Build` and `Run` cluster that has resources to view.

To do so:

1. Copy this YAML content into `tap-values.yaml`:

     ```yaml
     tap_gui:
     ## Previous configuration above
       app_config:
         kubernetes:
           serviceLocatorMethod:
             type: 'multiTenant'
           clusterLocatorMethods:
             - type: 'config'
               clusters:
               ## Cluster 1
                 - url: CLUSTER-URL
                   name: CLUSTER-NAME
                   authProvider: serviceAccount
                   serviceAccountToken: "CLUSTER-TOKEN"
                   skipTLSVerify: true
                   skipMetricsLookup: true
               ## Cluster 2+
                 - url: CLUSTER-URL
                   name: CLUSTER-NAME
                   authProvider: serviceAccount
                   serviceAccountToken: "CLUSTER-TOKEN"
                   skipTLSVerify: true
                   skipMetricsLookup: true
     ```

     Where:

     - `CLUSTER-URL` is the value you discovered earlier.
     - `CLUSTER-TOKEN` is the value you discovered earlier.
     - `CLUSTER-NAME` is a unique name of your choice.

     If there are resources to view on the `View` cluster that hosts Tanzu Developer Portal, add an
     entry to `clusters` for it as well.

     If you would like the Kubernetes client to verify the TLS certificates presented by a cluster's
     API server, set the following properties for the cluster:

     ```yaml
     skipTLSVerify: false
     caData: CLUSTER-CA-CERTIFICATES
     ```

     Where `CLUSTER-CA-CERTIFICATES` is the value you discovered earlier.

1. Update the `tap` package by running this command:

    ```console
    tanzu package installed update tap -n tap-install --values-file tap-values.yaml
    ```

1. Wait a moment for the `tap` and `tap-gui` packages to update and then verify that `STATUS` is
   `Reconcile succeeded` by running:

    ```console
    tanzu package installed get all -n tap-install
    ```

## <a id="runtime-resrc-plug-in"></a> View resources on multiple clusters in the Runtime Resources Visibility plug-in

To view resources on multiple clusters in the Runtime Resources Visibility plug-in:

1. Go to the Runtime Resources Visibility plug-in for a component that is running on multiple
   clusters.

1. View the multiple resources and their statuses across the clusters.

    ![Screenshot of example Tanzu Application Platform runtime resources.](images/tap-gui-multiple-clusters.png)

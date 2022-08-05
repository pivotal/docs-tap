# Install FluxCD source-controller

## <a id='sc-prereqs'></a>Prerequisites

Before installing Source Controller:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).
- Install cert-manager on the cluster. For more information, see [Install cert-manager](../cert-mgr-contour-fcd/install-cert-mgr.md#install-cert-mgr).

## <a id="Configuration"></a> Configuration

Source controller package has no configurable properties.

##  <a id="installation"></a> Installation

To install FluxCD source-controller from the Tanzu Application Platform package repository:

1. List version information for the package by running:

    ```
    tanzu package available list fluxcd.source.controller.tanzu.vmware.com -n tap-install
    ```

    For example:

    ```
    $ tanzu package available list fluxcd.source.controller.tanzu.vmware.com -n tap-install
        \ Retrieving package versions for fluxcd.source.controller.tanzu.vmware.com...
          NAME                                       VERSION  RELEASED-AT
          fluxcd.source.controller.tanzu.vmware.com  0.16.0   2021-10-27 19:00:00 -0500 -05
    ```

2. Install the package by running:

    ```
    tanzu package install fluxcd-source-controller -p fluxcd.source.controller.tanzu.vmware.com -v VERSION-NUMBER -n tap-install
    ```

    Where:

    - `VERSION-NUMBER` is the version of the package listed in step 1.

    For example:

    ```
    tanzu package install fluxcd-source-controller -p fluxcd.source.controller.tanzu.vmware.com -v 0.16.0 -n tap-install
    \ Installing package 'fluxcd.source.controller.tanzu.vmware.com'
    | Getting package metadata for 'fluxcd.source.controller.tanzu.vmware.com'
    | Creating service account 'fluxcd-source-controller-tap-install-sa'
    | Creating cluster admin role 'fluxcd-source-controller-tap-install-cluster-role'
    | Creating cluster role binding 'fluxcd-source-controller-tap-install-cluster-rolebinding'
    | Creating package resource
    - Waiting for 'PackageInstall' reconciliation for 'fluxcd-source-controller'
    | 'PackageInstall' resource install status: Reconciling

      Added installed package 'fluxcd-source-controller'
    ```
    
    This package creates a new namespace called `flux-system`. This namespace hosts all the elements of fluxcd.

3. Verify the package install by running:

    ```
    tanzu package installed get fluxcd-source-controller -n tap-install
    ```

    For example:

    ```
    tanzu package installed get fluxcd-source-controller -n tap-install
    \ Retrieving installation details for fluxcd-source-controller...
    NAME:                    fluxcd-source-controller
    PACKAGE-NAME:            fluxcd.source.controller.tanzu.vmware.com
    PACKAGE-VERSION:         0.16.0
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`.

    ```
    kubectl get pods -n flux-system
    ```

    For example:

    ```
    $ kubectl get pods -n flux-system
    NAME                                 READY   STATUS    RESTARTS   AGE
    source-controller-69859f545d-ll8fj   1/1     Running   0          3m38s
    ```

    Verify that `STATUS` is `Running`.


##  <a id="try-fluxcd-source-controller"></a> Try fluxcd-source-controller

1. Verify the main components of `fluxcd-source-controller` were installed by running:

    ```
    kubectl get all -n flux-system
    ```

    Expect to see the following outputs or similar:
    
    ```
    NAME                                     READY   STATUS    RESTARTS   AGE
    pod/source-controller-7684c85659-2zfxb   1/1     Running   0          40m

    NAME                        TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
    service/source-controller   ClusterIP   10.108.138.74   <none>        80/TCP    40m

    NAME                                READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.apps/source-controller   1/1     1            1           40m

    NAME                                           DESIRED   CURRENT   READY   AGE
    replicaset.apps/source-controller-7684c85659   1         1         1       40m
    ```

2. Verify all the CRD were installedby running:

    ```
    kubectl get crds -n flux-system | grep ".fluxcd.io"
    buckets.source.toolkit.fluxcd.io                         2022-03-07T19:20:14Z
    gitrepositories.source.toolkit.fluxcd.io                 2022-03-07T19:20:14Z
    helmcharts.source.toolkit.fluxcd.io                      2022-03-07T19:20:14Z
    helmrepositories.source.toolkit.fluxcd.io                2022-03-07T19:20:14Z
    ```
    
    >**Note:** You will communicate with `fluxcd-source-controller` through its CRDs.

3. Follow these steps to consume a `GitRepository` object:

    1. Create the following `gitrepository-sample.yaml` file:

        ```
        apiVersion: source.toolkit.fluxcd.io/v1beta1
        kind: GitRepository
        metadata:
          name: gitrepository-sample
        spec:
          interval: 1m
          url: https://github.com/stefanprodan/podinfo
          ref:
            branch: master
        ```

    2. Apply the created conf:

        ```
        kubectl apply -f gitrepository-sample.yaml
        gitrepository.source.toolkit.fluxcd.io/gitrepository-sample created
        ```

    3. Verify the git-repository was fetched correctly:

        ```
        kubectl get GitRepository
        NAME                   URL                                       READY   STATUS                                                              AGE
        gitrepository-sample   https://github.com/stefanprodan/podinfo   True    Fetched revision: master/132f4e719209eb10b9485302f8593fc0e680f4fc   4s
        ```

    For more examples, see the samples directory on [fluxcd/source-controller/samples](https://github.com/fluxcd/source-controller/tree/main/config/samples) in GitHub.

##  <a id="documentation"></a> Documentation

For documentation specific to fluxcd-source-controller, see the main repository
[fluxcd/source-controller](https://github.com/fluxcd/source-controller) in GitHub.

# Overview of Convention Service for VMware Tanzu

The [Cartographer Conventions](../cartographer-conventions/about.md) component must be installed to add conventions to your pod.
The v0.7.x version of the convention controller is a passive system that translates the CRDs to the [new group](../cartographer-conventions/reference/pod-intent.md).

>**Caution** This component is deprecated in favor of [Cartographer Conventions](../cartographer-conventions/about.md).

#### <a id="ootb-conventions"></a> Sample conventions

There are several out-of-the-box conventions provided with a full profile installation of Tanzu Application Platform or individual component installation of the following packages.

  ```shell
    ❯ kubectl get pkgi -n tap-install | grep conventions
      appliveview-conventions    conventions.appliveview.tanzu.vmware.com       1.3.0-build.1       Reconcile succeeded   2m5s
      developer-conventions      developer-conventions.tanzu.vmware.com         0.7.0               Reconcile succeeded   2m5s
      spring-boot-conventions    spring-boot-conventions.tanzu.vmware.com       0.4.1               Reconcile succeeded   2m5s

    ❯ kubectl get clusterpodconventions
      Warning: conventions.apps.tanzu.vmware.com/v1alpha1 ClusterPodConvention is deprecated; use conventions.carto.run/v1alpha1 ClusterPodConvention instead
      NAME                     READY   REASON   AGE
      appliveview-sample       True    InSync   4m51s
      developer-conventions    True    InSync   4m50s
      spring-boot-convention   True    InSync   4m51s
  ```

The webhook configuration for each convention is as follows:

+ Conventions for [AppLiveView](../app-live-view/about-app-live-view.hbs.md)

  ```yaml
  ...
  # webhook configuration
  apiVersion: conventions.apps.tanzu.vmware.com/v1alpha1
  kind: ClusterPodConvention
  ...
  spec:
    priority: Late
    webhook:
      clientConfig:
        service:
          name: appliveview-webhook
          namespace: app-live-view-conventions
  ```

  ```shell
  ❯ kubectl get deployment.apps/appliveview-webhook -n app-live-view-conventions                                                     ⏎
    NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
    appliveview-webhook   1/1     1            1           8m45s
  ```

+ [Developer conventions](../developer-conventions/about.hbs.md)

  ```yaml
  ...
  # webhook configuration
  spec:
    webhook:
      clientConfig:
        service:
          name: webhook
          namespace: developer-conventions
  ```

  ```shell
  ❯ kubectl get deployment.apps/webhook -n developer-conventions                                                                     ⏎
    NAME      READY   UP-TO-DATE   AVAILABLE   AGE
    webhook   1/1     1            1           10m
  ```

+ [Spring boot conventions](../spring-boot-conventions/reference/CONVENTIONS.hbs.md)

  ``` yaml
    ...
   # webhook configuration
    spec:
      webhook:
        clientConfig:
          service:
            name: spring-boot-webhook
            namespace: spring-boot-convention
    ```

    ```shell
    ❯ kubectl get deployment.apps/spring-boot-webhook -n spring-boot-convention
      NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
      spring-boot-webhook   1/1     1            1           12m
    ```

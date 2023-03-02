# Convention Service for VMware Tanzu

>**Caution** This component is deprecated in favor of [Cartographer Conventions](../cartographer-conventions/about.md).

The [Cartographer Conventions](../cartographer-conventions/about.md) component must be installed to add conventions to your pod.

#### <a id="ootb-conventions"></a> Sample conventions

There are several out-of-the-box conventions provided with a full profile installation of Tanzu Application Platform or individual component installation of the following packages.

  ```console
    ❯ kubectl get pkgi -n tap-install | grep conventions
      appliveview-conventions              conventions.appliveview.tanzu.vmware.com              1.5.0-build.2     Reconcile succeeded   6m21s
      conventions-controller               controller.conventions.apps.tanzu.vmware.com          0.8.0             Reconcile succeeded   7m38s
      developer-conventions                developer-conventions.tanzu.vmware.com                0.10.0-build.1    Reconcile succeeded   6m21s
      spring-boot-conventions              spring-boot-conventions.tanzu.vmware.com              1.5.0-build.2     Reconcile succeeded   6m21s

    ❯ kubectl get clusterpodconventions.conventions.carto.run                                                                                                                                            ⏎
      NAME                     AGE
      appliveview-sample       8m25s
      developer-conventions    8m24s
      spring-boot-convention   8m25s
  ```

The webhook configuration for each convention is as follows:

+ Conventions for [AppLiveView](../app-live-view/about-app-live-view.hbs.md)


  ```console
  ❯ kubectl get deployment.apps/appliveview-webhook -n app-live-view-conventions                                                                                                                       ⏎
  NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
  appliveview-webhook   1/1     1            1           11m
  ```

+ [Developer conventions](../developer-conventions/about.hbs.md)

  ```console
  ❯ kubectl get deployment.apps/webhook -n developer-conventions                                                                     ⏎
    NAME      READY   UP-TO-DATE   AVAILABLE   AGE
    webhook   1/1     1            1           10m
  ```

+ [Spring boot conventions](../spring-boot-conventions/reference/CONVENTIONS.hbs.md)

    ```console
    ❯ kubectl get deployment.apps/spring-boot-webhook -n spring-boot-convention
      NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
      spring-boot-webhook   1/1     1            1           12m
    ```

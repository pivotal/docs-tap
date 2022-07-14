# Custom configuration for the connector

This topic describes how developers custom configure an app or workload for Application Live View.

The connector component is responsible for discovering the app and registering
it with Application Live View.
Labels from the app PodSpec are used to discover the app and configure the connector
to access the actuator data of the app.

Usually, the Application Live View convention applies the necessary configuration automatically.
To deactivate the convention and configure the app and the workload manually,
the list of labels in the following table gives you an overview of the options:

| Label Name | Mandatory |Type | Default | Significance |
| ---| --- | --- | --- | --- |
| `tanzu.app.live.view` | true | Boolean | None | Toggle to activate or deactivate pod discovery |
| `tanzu.app.live.view.application.name` | true | String | None | Application name |
| `tanzu.app.live.view.application.port` | false | Integer | `8080` |  Application port |
| `tanzu.app.live.view.application.path` | false | String | `/` | Application context path |
| `tanzu.app.live.view.application.actuator.port` | false | Integer | `8080` | Application actuator port |
| `tanzu.app.live.view.application.actuator.path` |false| String| `/actuator` | Actuator context path |
| `tanzu.app.live.view.application.protocol` | false| http / https | `http` | Protocol scheme |
| `tanzu.app.live.view.application.actuator.health.port` | false | Integer | `8080` | Health endpoint port |
| `tanzu.app.live.view.application.flavours` | false | Comma separated string | `spring-boot,spring-cloud-gateway` | Application flavors |


You can add connector labels in the app `Workload` or override labels that the convention applies,
such as `tanzu.app.live.view` and `tanzu.app.live.view.application.name`.
If you do not want Application Live View to observe your app, you can override
the existing label `tanzu.app.live.view: "false"`.

## <a id="config-dev-workloads"></a> Configure the developer workload in Tanzu Application Platform

The following YAML is an example of a Spring PetClinic workload that overrides the
connector label to `tanzu.app.live.view: "false"`:

```yaml
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  name: spring-petclinic
  namespace: default
  labels:
    tanzu.app.live.view: "false"
    app.kubernetes.io/part-of: tanzu-java-web-app
    apps.tanzu.vmware.com/workload-type: web
  annotations:
    autoscaling.knative.dev/minScale: "1"
spec:
  source:
    git:
      ref:
        branch: main
      url: https://github.com/kdvolder/spring-petclinic
```

## <a id="deploy-workloads"></a> Deploy the workload

To deploy the workload, run:

```console
kapp -y deploy -n default -a workloads -f workloads.yaml
```


## <a id="verify-propagation"></a> Verify the label has propagated through the Supply Chain

To verify the label:

1. Verify that the workload build is successful by ensuring that `SUCCEEDED` is set to `True`:

    ```console
    kubectl get builds
    NAME                         IMAGE                                                                                                                                                 SUCCEEDED
    spring-petclinic-build-1     dev.registry.tanzu.vmware.com/app-live-view/test/spring-petclinic-default@sha256:9db2a8a8e77e9215239431fd8afe3f2ecdf09cce8afac565dad7b5f0c5ac0cdf     True
    ```

1. Verify the PodIntent of your workload by ensuring `status.template.metadata.labels`
shows the newly added label has propagated through the Supply Chain:

    ```console
    kubectl get podintents.conventions.carto.run spring-petclinic -oyaml

    status:
      conditions:
      - lastTransitionTime: "2021-12-03T15:14:33Z"
        status: "True"
        type: ConventionsApplied
      - lastTransitionTime: "2021-12-03T15:14:33Z"
        status: "True"
        type: Ready
      observedGeneration: 3
      template:
        metadata:
          annotations:
            autoscaling.knative.dev/minScale: "1"
            boot.spring.io/actuator: http://:8080/actuator
            boot.spring.io/version: 2.5.6
            conventions.carto.run/applied-conventions: |-
              appliveview-sample/app-live-view-connector-boot
              appliveview-sample/app-live-view-appflavours-boot
              appliveview-sample/app-live-view-systemproperties
              spring-boot-convention/spring-boot
              spring-boot-convention/spring-boot-graceful-shutdown
              spring-boot-convention/spring-boot-web
              spring-boot-convention/spring-boot-actuator
              spring-boot-convention/service-intent-mysql
            developer.conventions/target-containers: workload
            kapp.k14s.io/identity: v1;default/carto.run/Workload/spring-petclinic;carto.run/v1alpha1
            kapp.k14s.io/original: '{"apiVersion":"carto.run/v1alpha1","kind":"Workload","metadata":{"annotations":{"autoscaling.knative.dev/minScale":"2"},"labels":{"app.kubernetes.io/part-of":"tanzu-java-web-app","apps.tanzu.vmware.com/workload-type":"web","kapp.k14s.io/app":"1638455805474051000","kapp.k14s.io/association":"v1.5a9384bd7b93ca74ef494c4dec2caa4b","tanzu.app.live.view":"false"},"name":"spring-petclinic","namespace":"default"},"spec":{"source":{"git":{"ref":{"branch":"main"},"url":"https://github.com/ksankaranara-vmw/spring-petclinic"}}}}'
            kapp.k14s.io/original-diff-md5: 58e0494c51d30eb3494f7c9198986bb9
            services.conventions.carto.run/mysql: mysql-connector-java/8.0.27
          labels:
            app.kubernetes.io/component: run
            app.kubernetes.io/part-of: tanzu-java-web-app
            apps.tanzu.vmware.com/workload-type: web
            carto.run/workload-name: spring-petclinic
            conventions.carto.run/framework: spring-boot
            kapp.k14s.io/app: "1638455805474051000"
            kapp.k14s.io/association: v1.5a9384bd7b93ca74ef494c4dec2caa4b
            services.conventions.carto.run/mysql: workload
            tanzu.app.live.view: "false"
            tanzu.app.live.view.application.flavours: spring-boot
            tanzu.app.live.view.application.name: petclinic
    ```

1. Verify the ConfigMap was created for the app by ensuring `metadata.labels`
shows the newly added label has propagated through the Supply Chain:

    ```console
    kubectl describe configmap spring-petclinic
    Name:         spring-petclinic
    Namespace:    default
    Labels:       carto.run/cluster-supply-chain-name=source-to-url
                  carto.run/cluster-template-name=config-template
                  carto.run/resource-name=app-config
                  carto.run/template-kind=ClusterConfigTemplate
                  carto.run/workload-name=spring-petclinic
                  carto.run/workload-namespace=default
    Annotations:  <none>

    Data
    ====
    delivery.yml:
    ----
    apiVersion: serving.knative.dev/v1
    kind: Service
    metadata:
      name: spring-petclinic
      labels:
        app.kubernetes.io/part-of: tanzu-java-web-app
        apps.tanzu.vmware.com/workload-type: web
        kapp.k14s.io/app: "1638455805474051000"
        kapp.k14s.io/association: v1.5a9384bd7b93ca74ef494c4dec2caa4b
        tanzu.app.live.view: "false"
        app.kubernetes.io/component: run
        carto.run/workload-name: spring-petclinic
    ```

1. Verify the running Knative application pod by ensuring `labels` shows the newly
added label on the Knative application pod:

    ```console
    kubectl get pods -o yaml spring-petclinic-00002-deployment-77dbb85c65-cf7rn | grep labels
        kapp.k14s.io/original: '{"apiVersion":"carto.run/v1alpha1","kind":"Workload","metadata":{"annotations":{"autoscaling.knative.dev/minScale":"1"},"labels":{"app.kubernetes.io/part-of":"tanzu-java-web-app","apps.tanzu.vmware.com/workload-type":"web","kapp.k14s.io/app":"1638455805474051000","kapp.k14s.io/association":"v1.5a9384bd7b93ca74ef494c4dec2caa4b","tanzu.app.live.view":"false"},"name":"spring-petclinic","namespace":"default"},"spec":{"source":{"git":{"ref":{"branch":"main"},"url":"https://github.com/ksankaranara-vmw/spring-petclinic"}}}}'
    ```

You can add or override the connector in the `Workload` of your Knative app.

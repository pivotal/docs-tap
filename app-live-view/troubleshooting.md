# Troubleshooting

This topic provides information to help you troubleshoot Application Live View.

## <a id="app-not-showing"></a> App is not visible in Application Live View UI

**Symptom**

Your app is not visible in the Application Live View UI.

**Solution**

The connector component is responsible for discovering the app and registering it with Application Live View.

To troubleshoot, confirm the following:

1. The app must be a Spring Boot Application.

1. Confirm that an instance of a connector is located in the same namespace as your app.

   ```console
   kubectl get pods -n NAMESPACE | grep connector
   ```

   Where `NAMESPACE` is the name of the namespace that your app is located in.

1. Confirm that the actuator endpoints are enabled for your app as follows:

    ```console
    management.endpoints.web.exposure.include: "*"
    ```

1. Confirm that you have included the following labels within your app deployment YAML file:

   ```yaml
   tanzu.app.live.view="true"
   tanzu.app.live.view.application.name="APP-NAME"
   ```

   Where `APP-NAME` is the name of your app.

1. Confirm that the convention service workload YAML file does not contain property `management.endpoints.web.exposure.include` overrides

See also:

- [App is not visible in Application Live View UI with actuator endpoints enabled](#acutator-endpoints)
- [The UI does not show any information for an app with actuator endpoints exposed at root](#endpoints-at-root)


## <a id="acutator-endpoints"></a> App is not visible in Application Live View UI with actuator endpoints enabled

**Symptom**

Your app is not visible in Application Live View UI, but the actuator endpoints are enabled.

**Solution**

To troubleshoot:

1. Check the port on which actuator endpoints are configured.
By default, they are enabled on the application port.
If they are configured on a port different from the application port, set the labels
in your app deployment YAML file as follows:

    ```yaml
    tanzu.app.live.view.application.port: "APPLICATION-PORT"
    tanzu.app.live.view.application.actuator.port: "ACTUATOR-PORT"
    ```

    Where:

    - `APPLICATION-PORT` is the application port.
    - `ACTUATOR-PORT` is the actuator port.

1. Check the path on which the app and actuator endpoints are configured.
If they are configured on a different paths, set the labels in your app deployment YAML file as follows:

    ```yaml
    tanzu.app.live.view.application.path: "APPLICATION-PATH"
    tanzu.app.live.view.application.actuator.path: "ACTUATOR-PATH"
    ```

    Where:

    - `APPLICATION-PATH` is the application port.
    - `ACTUATOR-PATH` is the actuator port.


## <a id="endpoints-at-root"></a> The UI does not show any information for an app with actuator endpoints exposed at root

**Symptom**

Your app has actuator endpoints exposed at root and the UI does not show any information.

**Cause**

Application Live View cannot display the app details when the app
is exposing the actuator endpoint on root (`/`) .
This is due to conflict in the actuator context path and app default context path.


## <a id="no-health-info"></a> No information shown on the Health page

**Symptom**

The app shows up in Application Live View UI, but the **Health** page does not show details of health.

**Solution**

The information exposed by the health endpoint depends on the `management.endpoint.health.show-details` property.
This must be set to `always` as as follows:

```console
management.endpoint.health.show-details: "always"
```

## <a id="stale-info"></a> Stale information in App Live View

**Symptom**

You can find your app in the UI, but it is an old instance that no longer exists
while the new instance doesn't show up yet.

**Solution**

To troubleshoot:

1. View the App Live View connector pod logs to see if the connector is sending updates to the back end.

1. Try deleting the connector pod so it is re-created by running:

    ```bash
    kubectl -n app-live-view-connector delete pods -l=name=application-live-view-connector
    ```

## <a id="no-live-info"></a> No live information for pod with ID

**Symptom**

In Tanzu Application Platform GUI, you receive the error `No live information for pod with id`.

**Cause**

This might happen because of stale information in App Live View because it is an
old instance that no longer exists while the new instance doesn't show up yet.

**Solution**

The workaround is to delete the connector pod so it is re-created by running:

```bash
kubectl -n app-live-view-connector delete pods -l=name=application-live-view-connector
```

## <a id="cannot-override-act-path"></a> Cannot override the actuator path in the labels

**Symptom**

You are unable to override the actuator path in the labels as part of the workload deployment.

**Cause**

The changes to add or override the labels or annotations in the `Workload` are in progress.
The changes from the `Workload` must be propagated up through the supply chain for the PodIntent to see the new changes.


## <a id="cannot-config-ssl"></a> Cannot configure SSL in appliveview-connector

**Symptom**

This might be because `sslDisabled` flag in the values YAML file does not accept values without quotes.

**Cause**

The `sslDisabled` Boolean flag is treated as a string in the Kubernetes YAML file.

**Solution**

You must specify the value within double quotation marks for the configuration to be picked up.


## <a id="verify-labels"></a> Verify the labels in your workload YAML file

To verify that the labels in your workload YAML file are working:

1. Verify the app live view convention webhook is running properly by running:

    ```bash
    kubectl get pods -n app-live-view | grep webhook
    ```

1. Verify the conventions controller is running properly by running:

    ```bash
    kubectl get pods -n conventions-system
    ```

1. Verify that the conventions are applied properly to the PodSpec by running:

    ```bash
    kubectl get podintents.conventions.carto.run WORKLOAD-NAME -oyaml
    ```

    Where `WORKLOAD-NAME` is the name of your workload.

    If everything works correctly, the status will contain a transformed template
    that includes the labels added as part of your workload YAML file. For example:

    ```yaml
    status:
    conditions:
    - lastTransitionTime: "2021-10-26T11:26:35Z"
      status: "True"
      type: ConventionsApplied
    - lastTransitionTime: "2021-10-26T11:26:35Z"
      status: "True"
      type: Ready
    observedGeneration: 1
    template:
      metadata:
        annotations:
          conventions.carto.run/applied-conventions: |-
            appliveview-sample/app-live-view-connector
            appliveview-sample/app-live-view-appflavours
            appliveview-sample/app-live-view-systemproperties
        labels:
          tanzu.app.live.view: "true"
          tanzu.app.live.view.application.flavours: spring-boot
          tanzu.app.live.view.application.name: petclinic
      spec:
        containers:
        - env:
          - name: JAVA_TOOL_OPTIONS
            value: -Dmanagement.endpoint.health.show-details=always -Dmanagement.endpoints.web.exposure.include=*
        image: index.docker.io/kdvolder/alv-spring-petclinic:latest@sha256:1aa7bd228137471ea38ce36cbf5ffcd629eabeb8ce047f5533b7b9176ff51f98
        name: workload
        resources: {}
    ```

## <a id="override-labels"></a> Override labels set by the Application Live View Convention Service

It is not possible to override the labels set by the Application Live View Convention Service
for the workload deployment in Tanzu Application Platform.
The labels `tanzu.app.live.view`, `tanzu.app.live.view.application.flavours`
and `tanzu.app.live.view.application.name` cannot be overridden.
The default values set by the Application Live View Convention Server are used.

However, if you want to override `management.endpoints.web.exposure.include`
or `management.endpoint.health.show-details`, you can override these environment
properties in `application.properties` or `application.yml` in the Spring Boot Application
before deploying the workload in Tanzu Application Platform.
Environment properties updated in your app take precedence over the default values
set by Application Live View Convention Server.


## <a id="config-labels"></a> Configure labels when management.endpoints.web.base-path and management.server.port are set

If the custom actuator context path is configured as follows:

```yaml
management.endpoints.web.base-path=/manage
management.server.port=8085
```

Configure the connector as follows:

```yaml
tanzu.app.live.view.application.actuator.path=/manage   (manage is the custom actuator path set on the application)
tanzu.app.live.view.application.actuator.port=8085   (8085 is the custom management server port set on the application)
```

Configure the sidecar as follows:

```yaml
app.live.view.sidecar.application-actuator-path=/manage  (manage is the custom actuator path set on the application)
app.live.view.sidecar.application-actuator-port=8085  (8085 is the custom management server port set on the application)
```

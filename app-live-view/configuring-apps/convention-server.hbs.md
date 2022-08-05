# Convention server

The Application Live View Convention provides a Webhook handler for
[Convention Service for VMware Tanzu](https://docs.vmware.com/en/Tanzu-Application-Platform/1.1/tap/GUID-convention-service-about.html).

## <a id="role"></a> Role of Application Live View Convention

The Application Live View Convention works in conjunction with core Convention Service.
It enhances Tanzu PodIntents with metadata such as labels, annotations, or app properties.
This metadata allows Application Live View, specifically the connector, to discover
app instances so that Application Live View can access the actuator data from those workloads.

For running Spring Boot apps, the convention recognizes PodIntents and adds the following metadata labels:

- `tanzu.app.live.view: "true"`: Enables the connector to observe application pod.
- `tanzu.app.live.view.application.name: APPLICATION-NAME`: Identifies the app name to be used internally by Application Live View.
- `tanzu.app.live.view.application.actuator.port: "8081"`: Identifies the port on the pod at which the actuators are available for Application Live View.
- `tanzu.app.live.view.application.flavours: spring-boot`: Exposes the framework flavor of the app.

For running Spring Cloud Gateway apps, the convention recognizes PodIntents and adds the following metadata labels:

- `tanzu.app.live.view: "true"`: Enables the connector to observe application pod.
- `tanzu.app.live.view.application.name: APPLICATION-NAME`: Identifies the app name to be used internally by Application Live View.
- `tanzu.app.live.view.application.actuator.port: "8081"`: Identifies the port on the pod at which the actuators are available for Application Live View.
- `tanzu.app.live.view.application.flavours: spring-boot,spring-cloud-gateway`: Exposes the framework flavors of the app.

These metadata labels allow Application Live View to identify pods that are enabled
for Application Live View. The metadata labels also tell the Application Live View
connector what kind of app it is, and on which port the actuators are accessible
for Application Live View, the connector.
The port is read from the `JAVA_TOOLS_OPTIONS` settings, especially from the
`-Dmanagement.server.port=<..>` key-value pair.

The management port is either set automatically by the Spring Boot convention
or you can set it as a key-value pair in the `JAVA_TOOLS_OPTIONS` environment
variable from the `workload.yml` directly.

If there is no port specified, the connector uses the standard port `8080`.

In addition to that, the convention automatically adds the following app
properties to the `JAVA_TOOLS_OPTIONS` environment variable:

- `-Dmanagement.endpoints.web.exposure.include="*"`: Exposes actuator endpoints of the app.
- `-Dmanagement.endpoint.health.show-details=true`: Shows the health details.

## <a id="security"></a> Important security advice

The Application Live View Convention automatically exposes all the actuators of an app
so that Application Live View can access all those actuator endpoints and visualize all the details on the UI.
This overrides configuration settings that your app itself might contain, for example,
if you configured your app to expose only specific actuators.
To prevent the Application Live View convention from exposing all actuators, there are multiple options.

### <a id="uninstall-convention"></a> Uninstall the convention

One option is to uninstall the Application Live View convention.
This results in no convention being applied automatically.
You can still use Application Live View, but you must add the labels and environment settings yourself.

### <a id="disable-convention"></a> Disable the convention for specific workloads

Another option is to deactivate Application Live View for specific workloads.
You can add the label `tanzu.app.live.view: "false"` manually, for example, by adding the label to the `workload.yml`.
If the convention recognizes this label exists and is set to `false`,
the convention does not apply any additional Application Live View configurations.

### <a id="manual-config"></a> Manually configure the Application Live View settings for a workload

Another option is to keep Application Live View enabled for workloads, but
set the corresponding labels and environment properties explicitly yourself.
For example, using the `workload.yml`:

```yaml
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  name: hello-boot
  namespace: default
  labels:
    tanzu.app.live.view: "true"
    tanzu.app.live.view.application.actuator.port: "7777"
    tanzu.app.live.view.application.flavours: spring-boot
    tanzu.app.live.view.application.name: hello-boot
    app.kubernetes.io/part-of: tanzu-java-demo-apps
    apps.tanzu.vmware.com/workload-type: web
spec:
  env:
  - name: JAVA_TOOL_OPTIONS
    value: >-
      -Dmanagement.server.port=7777
      -Dmanagement.endpoints.web.exposure.include=health,mappings,info
      -Dmanagement.endpoint.health.show-details=always
  source:
    git:
      ref:
        branch: master
      url: https://github.com/kdvolder/hello-boot
```

## <a id="desc-metadata"></a> Description of metadata labels

If a workload resource explicitly defines a label under `metadata.labels` in the
`workload.yaml`, then the convention service detects the presence of that label and respects its value.
When deploying a workload using Tanzu Application Platform,
you can override the labels listed in the following table using the `Workload` YAML.


| Metadata | Default | Type | Description |
| --- | --- | --- | --- |
| `tanzu.app.live.view` | `true` | Label | When deploying a workload in Tanzu Application Platform, this label is set to `true` as default across the supply chain. |
| `tanzu.app.live.view.application.name` | `spring-boot-app` | Label | When deploying a workload in Tanzu Application Platform, this label is set to `spring-boot-app` if the container image metadata does not contain the app name. Otherwise, the label is set to the app name from container image metadata. |
| `tanzu.app.live.view.application.flavours` | `spring-boot,spring-cloud-gateway` | Label | When deploying a Spring Boot workload in Tanzu Application Platform, this label is set to `spring-boot` as default across the supply chain. For Spring Cloud Gateway app, it is set to `spring-boot,spring-cloud-gateway` as default. |
| `management.endpoints.web.exposure.include` | `*` | Environment Property | The user provided environment property takes precedence over the default value set by Application Live View Convention Server. |
| `management.endpoint.health.show-details` | always | Environment Property |The user provided environment property takes precedence over the default value set by Application Live View Convention Server. |

Similarly, to override the default value for `management.endpoints.web.exposure.include` or `management.endpoint.health.show-details`, add it to the workload as follows:

```yaml
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  ...
spec:
  env:
  - name: JAVA_TOOL_OPTIONS
    value: >-
      -Dmanagement.endpoints.web.exposure.include=health,mappings,info
      -Dmanagement.endpoint.health.show-details=always
```

Application Live View Convention Server detects properties defined in the workload
`env` section and respects those values.

>**Warning!** You can also define properties such as `management.endpoints.web.exposure.include`
and `management.endpoint.health.show-details` in `application.properties` or `application.yml`
in the Spring Boot or Spring Cloud Gateway Application. Properties defined in this way have lower priority and will be overridden
by the Application Live View Convention default values.

# <a id="verify"></a> Verify the applied labels and annotations

You can verify the applied labels and annotations by running:

```console
kubectl get podintents.conventions.carto.run WORKLOAD-NAME -o yaml
```

Where `WORKLOAD-NAME` the name of the deployed workload, for example `tanzu-java-web-app`.

Expected output for Spring Boot Workload:

```console
apiVersion: conventions.carto.run/v1alpha1
kind: PodIntent
metadata:
  creationTimestamp: "2021-11-10T10:19:38Z"
  generation: 1
  labels:
    app.kubernetes.io/component: intent
    app.kubernetes.io/part-of: tanzu-java-web-appweb
    carto.run/cluster-supply-chain-name: source-to-url
    carto.run/cluster-template-name: convention-template
    carto.run/resource-name: config-provider
    carto.run/template-kind: ClusterConfigTemplate
    carto.run/workload-name: tanzu-java-web-app
    carto.run/workload-namespace: default
  name: tanzu-java-web-app
  namespace: default
  ownerReferences:
  - apiVersion: carto.run/v1alpha1
    blockOwnerDeletion: true
    controller: true
    kind: Workload
    name: tanzu-java-web-app
    uid: 998ab107-c232-4dcf-a4b2-1d499b7709c6
  resourceVersion: "4502417"
  uid: 92c65a88-5beb-4405-b659-3b78834df125
spec:
  serviceAccountName: service-account
  template:
    metadata:
      annotations:
        developer.conventions/target-containers: workload
      labels:
        app.kubernetes.io/component: run
        app.kubernetes.io/part-of: tanzu-java-web-appweb
        carto.run/workload-name: tanzu-java-web-app
    spec:
      containers:
      - image: dev.registry.tanzu.vmware.com/app-live-view/test/tanzu-java-web-app@sha256:db323d46a03e54948e844e7a7fced7d42b737c90b1c3a3a9bb775de9bce92c30
        name: workload
        resources: {}
        securityContext:
          runAsUser: 1000
      serviceAccountName: service-account
status:
  conditions:
  - lastTransitionTime: "2021-11-10T10:19:46Z"
    status: "True"
    type: ConventionsApplied
  - lastTransitionTime: "2021-11-10T10:19:46Z"
    status: "True"
    type: Ready
  observedGeneration: 1
  template:
    metadata:
      annotations:
        boot.spring.io/actuator: http://:8080/actuator
        boot.spring.io/version: 2.5.4
        conventions.carto.run/applied-conventions: |-
          appliveview-sample/app-live-view-connector-boot
          appliveview-sample/app-live-view-appflavours-boot
          appliveview-sample/app-live-view-systemproperties
          spring-boot-convention/spring-boot
          spring-boot-convention/spring-boot-graceful-shutdown
          spring-boot-convention/spring-boot-web
          spring-boot-convention/spring-boot-actuator
        developer.conventions/target-containers: workload
      labels:
        app.kubernetes.io/component: run
        app.kubernetes.io/part-of: tanzu-java-web-appweb
        carto.run/workload-name: tanzu-java-web-app
        conventions.carto.run/framework: spring-boot
        tanzu.app.live.view: "true"
        tanzu.app.live.view.application.flavours: spring-boot
        tanzu.app.live.view.application.name: demo
    spec:
      containers:
      - env:
        - name: JAVA_TOOL_OPTIONS
          value: -Dmanagement.endpoint.health.show-details="always" -Dmanagement.endpoints.web.base-path="/actuator"
            -Dmanagement.endpoints.web.exposure.include="*" -Dmanagement.server.port="8080"
            -Dserver.port="8080" -Dserver.shutdown.grace-period="24s"
        image: dev.registry.tanzu.vmware.com/app-live-view/test/tanzu-java-web-app@sha256:db323d46a03e54948e844e7a7fced7d42b737c90b1c3a3a9bb775de9bce92c30
        name: workload
        ports:
        - containerPort: 8080
          protocol: TCP
        resources: {}
        securityContext:
          runAsUser: 1000
      serviceAccountName: service-account
```

Expected output for Spring Cloud Gateway workload:

```console
apiVersion: conventions.carto.run/v1alpha1
kind: PodIntent
metadata:
  creationTimestamp: "2021-11-10T10:19:38Z"
  generation: 1
  labels:
    app.kubernetes.io/component: intent
    app.kubernetes.io/part-of: tanzu-java-web-appweb
    carto.run/cluster-supply-chain-name: source-to-url
    carto.run/cluster-template-name: convention-template
    carto.run/resource-name: config-provider
    carto.run/template-kind: ClusterConfigTemplate
    carto.run/workload-name: tanzu-java-web-app
    carto.run/workload-namespace: default
  name: tanzu-java-web-app
  namespace: default
  ownerReferences:
  - apiVersion: carto.run/v1alpha1
    blockOwnerDeletion: true
    controller: true
    kind: Workload
    name: tanzu-java-web-app
    uid: 998ab107-c232-4dcf-a4b2-1d499b7709c6
  resourceVersion: "4502417"
  uid: 92c65a88-5beb-4405-b659-3b78834df125
spec:
  serviceAccountName: service-account
  template:
    metadata:
      annotations:
        developer.conventions/target-containers: workload
      labels:
        app.kubernetes.io/component: run
        app.kubernetes.io/part-of: tanzu-java-web-appweb
        carto.run/workload-name: tanzu-java-web-app
    spec:
      containers:
      - image: dev.registry.tanzu.vmware.com/app-live-view/test/tanzu-java-web-app@sha256:db323d46a03e54948e844e7a7fced7d42b737c90b1c3a3a9bb775de9bce92c30
        name: workload
        resources: {}
        securityContext:
          runAsUser: 1000
      serviceAccountName: service-account
status:
  conditions:
  - lastTransitionTime: "2021-11-10T10:19:46Z"
    status: "True"
    type: ConventionsApplied
  - lastTransitionTime: "2021-11-10T10:19:46Z"
    status: "True"
    type: Ready
  observedGeneration: 1
  template:
    metadata:
      annotations:
        boot.spring.io/actuator: http://:8080/actuator
        boot.spring.io/version: 2.5.4
        conventions.carto.run/applied-conventions: |-
          appliveview-sample/app-live-view-connector-boot
          appliveview-sample/app-live-view-connector-scg
          appliveview-sample/app-live-view-appflavours-boot
          appliveview-sample/app-live-view-appflavours-scg
          appliveview-sample/app-live-view-systemproperties
          spring-boot-convention/spring-boot
          spring-boot-convention/spring-boot-graceful-shutdown
          spring-boot-convention/spring-boot-web
          spring-boot-convention/spring-boot-actuator
        developer.conventions/target-containers: workload
      labels:
        app.kubernetes.io/component: run
        app.kubernetes.io/part-of: tanzu-java-web-appweb
        carto.run/workload-name: tanzu-java-web-app
        conventions.carto.run/framework: spring-boot
        tanzu.app.live.view: "true"
        tanzu.app.live.view.application.flavours: spring-boot,spring-cloud-gateway
        tanzu.app.live.view.application.name: demo
    spec:
      containers:
      - env:
        - name: JAVA_TOOL_OPTIONS
          value: -Dmanagement.endpoint.health.show-details="always" -Dmanagement.endpoints.web.base-path="/actuator"
            -Dmanagement.endpoints.web.exposure.include="*" -Dmanagement.server.port="8080"
            -Dserver.port="8080" -Dserver.shutdown.grace-period="24s"
        image: dev.registry.tanzu.vmware.com/app-live-view/test/tanzu-java-web-app@sha256:db323d46a03e54948e844e7a7fced7d42b737c90b1c3a3a9bb775de9bce92c30
        name: workload
        ports:
        - containerPort: 8080
          protocol: TCP
        resources: {}
        securityContext:
          runAsUser: 1000
      serviceAccountName: service-account
```


In your output:

- `status.metadata.template.spec.containers.env.value` shows the list of applied environment properties by Application Live View Convention Server.
- `status.metadata.template.labels` shows the list of applied labels by Application Live View Convention Server.
- `status.metadata.template.annotations` shows the list of applied annotations by Application Live View Convention Server.

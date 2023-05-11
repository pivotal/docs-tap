# Application Live View Convention server

This topic provides information about Application Live View Convention, which provides a
Webhook handler for
[Convention Service for VMware Tanzu](https://docs.vmware.com/en/Tanzu-Application-Platform/1.1/tap/GUID-convention-service-about.html).

## <a id="role"></a> Role of Application Live View Convention

The Application Live View Convention works in conjunction with core Convention Service.
It enhances Tanzu PodIntents with metadata such as labels, annotations, or app properties.
This metadata allows Application Live View, specifically the connector, to discover
app instances so that Application Live View can access the actuator data from those workloads.

>**Note** Application Live View Conventions now supports only Steeltoe applications. Spring Boot conventions supports both Spring Boot and Spring Cloud Gateway applications. For more information about Spring Boot conventions, see [Enable Application Live View with Spring Boot apps](../../spring-boot-conventions/enabling-app-live-view.hbs.md)

To run Application Live View with Steeltoe apps, the Spring Boot convention recognizes PodIntents and adds the following metadata labels:

- `tanzu.app.live.view: "true"`: Enables the connector to observe application pod.
- `tanzu.app.live.view.application.name: APPLICATION-NAME`: Identifies the app name to be used internally by Application Live View.
- `tanzu.app.live.view.application.actuator.port: ACTUATOR-PORT`: Identifies the port on the pod at which the actuators are available for Application Live View.
- `tanzu.app.live.view.application.flavours: steeltoe`: Exposes the framework flavor of the app.

These metadata labels allow Application Live View to identify pods that are enabled for Application Live View. The metadata labels also tell the Application Live View connector what kind of app it is, and on which port the actuators are accessible
for Application Live View.

## <a id="desc-metadata"></a> Description of metadata labels

If a workload resource explicitly defines a label under `metadata.labels` in the
`workload.yaml`, then Convention Service detects the presence of that label and respects its value.
When deploying a workload using Tanzu Application Platform,
you can override the labels listed in the following table using the `Workload` YAML.


| Metadata | Default | Type | Description |
| --- | --- | --- | --- |
| `tanzu.app.live.view` | `true` | Label | When deploying a workload in Tanzu Application Platform, this label is set to `true` as default across the supply chain. |
| `tanzu.app.live.view.application.name` | `steeltoe-app` | Label | When deploying a workload in Tanzu Application Platform, this label is set to `steeltoe-app` if the container image metadata does not contain the app name. Otherwise, the label is set to the app name from container image metadata. |
| `tanzu.app.live.view.application.flavours` | `steeltoe` | Label | When deploying a Spring Boot workload in Tanzu Application Platform, this label is set to `steeltoe` as default across the supply chain.

## <a id="verify"></a> Verify the applied labels and annotations

You can verify the applied labels and annotations by running:

```console
kubectl get podintents.conventions.carto.run WORKLOAD-NAME -o yaml
```

Where `WORKLOAD-NAME` is the name of the deployed workload, for example `steetoe-app`.

Expected output for Steeltoe workload:

```console
apiVersion: conventions.carto.run/v1alpha1
kind: PodIntent
metadata:
  creationTimestamp: "2022-11-14T09:56:53Z"
  generation: 1
  labels:
    app.kubernetes.io/component: intent
    app.kubernetes.io/part-of: sample-app
    apps.tanzu.vmware.com/workload-type: web
    carto.run/cluster-template-name: convention-template
    carto.run/resource-name: config-provider
    carto.run/supply-chain-name: source-to-url
    carto.run/template-kind: ClusterConfigTemplate
    carto.run/workload-name: steeltoe-app
    carto.run/workload-namespace: default
  name: steeltoe-app
  namespace: default
  ownerReferences:
  - apiVersion: carto.run/v1alpha1
    blockOwnerDeletion: true
    controller: true
    kind: Workload
    name: steeltoe-app
    uid: 97897399-807a-4815-9693-fb06bb4bc1ed
  resourceVersion: "428904"
  uid: 0c74e045-075c-4af3-beef-b092b951be7f
spec:
  serviceAccountName: default
  template:
    metadata:
      annotations:
        autoscaling.knative.dev/min-scale: "1"
        developer.conventions/target-containers: workload
      labels:
        app.kubernetes.io/component: run
        app.kubernetes.io/part-of: sample-app
        apps.tanzu.vmware.com/workload-type: web
        carto.run/workload-name: steeltoe-app
    spec:
      containers:
      - image: dev.registry.tanzu.vmware.com/app-live-view/test/steeltoe-app-default@sha256:c8ea14d8714ec31ad978085ebff43d15679613a0c12df37812adf22cb47b5232
        name: workload
        resources: {}
        securityContext:
          runAsUser: 1000
      serviceAccountName: default
status:
  conditions:
  - lastTransitionTime: "2022-11-14T09:56:57Z"
    message: ""
    reason: Applied
    status: "True"
    type: ConventionsApplied
  - lastTransitionTime: "2022-11-14T09:56:57Z"
    message: ""
    reason: ConventionsApplied
    status: "True"
    type: Ready
  observedGeneration: 1
  template:
    metadata:
      annotations:
        autoscaling.knative.dev/min-scale: "1"
        conventions.carto.run/applied-conventions: |-
          spring-boot-convention/auto-configure-actuators-check
          spring-boot-convention/app-live-view-appflavour-check
          appliveview-sample/app-live-view-appflavour-check
          appliveview-sample/app-live-view-connector-steeltoe
          appliveview-sample/app-live-view-appflavours-steeltoe
        developer.conventions/target-containers: workload
      labels:
        app.kubernetes.io/component: run
        app.kubernetes.io/part-of: sample-app
        apps.tanzu.vmware.com/workload-type: web
        carto.run/workload-name: steeltoe-app
        tanzu.app.live.view: "true"
        tanzu.app.live.view.application.flavours: steeltoe
        tanzu.app.live.view.application.name: steeltoe-app
    spec:
      containers:
      - image: dev.registry.tanzu.vmware.com/app-live-view/test/steeltoe-app-default@sha256:c8ea14d8714ec31ad978085ebff43d15679613a0c12df37812adf22cb47b5232
        name: workload
        resources: {}
        securityContext:
          runAsUser: 1000
      serviceAccountName: default
```

In your output:

- `status.template.metadata.labels` shows the list of applied labels by Application Live View convention server.
- `status.template.metadata.annotations` shows the list of applied annotations by Application Live View convention server.

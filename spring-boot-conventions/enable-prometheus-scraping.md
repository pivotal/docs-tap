# Enable Prometheus scraping for Spring Boot applications on workloads

This topic tells you how to enable Prometheus to get metrics for your Spring Boot applications on
Tanzu Application Platform (commonly known as TAP) workloads.

## <a id="about"></a> About Prometheus scraping for Spring Boot applications

Spring Boot conventions recognizes PodIntents and automatically adds Prometheus annotations on the
Tanzu Application Platform workload PodSpec.
This means that you do not need to manually add the annotations in your workload YAML.
The pods with these Prometheus annotations are considered for scraping of metrics.

The following annotations are added:

- `prometheus.io/scrape: "true"`: Enables the Prometheus scrape feature. This identifies which pods
  to scrape for metrics.
- `prometheus.io/path: "/actuator/prometheus"`: Sets the Prometheus scrape path to the endpoint where
  Prometheus exposes metrics.
- `prometheus.io/port: "8080"`: Sets the Prometheus port to the default server port of a Spring Boot
  application. This ensures that the right port is used for the scrape job for each pod.

> **Note** If any of these annotations are added manually, the manual annotation setting takes precedence
> over the automatic setting.

Spring Boot conventions allows you to activate or deactivate the automatic configuration of
actuators on Tanzu Application Platform and on individual workloads.
If the label `apps.tanzu.vmware.com/auto-configure-actuators` on the workload is set to `true`,
<!-- Spring Boot conventions? --> activates automatic configuration of actuators.
The default label setting on the workload is `apps.tanzu.vmware.com/auto-configure-actuators: "false"`.

If `apps.tanzu.vmware.com/auto-configure-actuators` label is set to `true` on the workload YAML,
then the management server port is also switched to 8081 and <!-- Spring Boot conventions? --> uses
that port to access the actuators instead of the default app port.
Therefore, the Prometheus port is also set to 8081 automatically on the PodSpec so that the metrics
can be scraped using that port.
All the other native Prometheus annotations remain the same as the `false` case.

For more information, see [Configuring and accessing Spring Boot actuators in Tanzu Application Platform](../spring-boot-conventions/configuring-spring-boot-actuators.hbs.md).

## <a id="enable"></a> Enable Prometheus to scrape metrics

To enable Prometheus to scrape metrics from HTTP endpoints of a Spring Boot application, add the
Micrometer registry dependency for Prometheus support in the POM dependencies section:

```xml
<dependency>
   <groupId>io.micrometer</groupId>
   <artifactId>micrometer-registry-prometheus</artifactId>
</dependency>
```

## <a id="verify"></a> Verify the applied annotations

To verify the applied labels and annotations, run:

```console
kubectl get podintents.conventions.carto.run WORKLOAD-NAME -o yaml
```

Where `WORKLOAD-NAME` is the name of the deployed workload. For example: `tanzu-java-web-app`.

Example output of a Spring Boot workload PodIntent:

```console
apiVersion: conventions.carto.run/v1alpha1
kind: PodIntent
metadata:
  creationTimestamp: "2024-03-01T11:32:31Z"
  generation: 1
  labels:
    app.kubernetes.io/component: intent
    app.kubernetes.io/part-of: tanzu-java-web-app-prometheus-without-annotations
    apps.tanzu.vmware.com/workload-type: web
    carto.run/cluster-template-name: convention-template
    carto.run/resource-name: config-provider
    carto.run/supply-chain-name: source-to-url
    carto.run/template-kind: ClusterConfigTemplate
    carto.run/template-lifecycle: mutable
    carto.run/workload-name: tanzu-java-web-app-prometheus-without-annotations
    carto.run/workload-namespace: default
  name: tanzu-java-web-app-prometheus-without-annotations
  namespace: default
  ownerReferences:
  - apiVersion: carto.run/v1alpha1
    blockOwnerDeletion: true
    controller: true
    kind: Workload
    name: tanzu-java-web-app-prometheus-without-annotations
    uid: 8531983d-338d-45e9-8398-53bf0f53b3a4
  resourceVersion: "4410028"
  uid: 1fe59b2b-72ac-4756-9123-3cc1db007c0d
spec:
  serviceAccountName: default
  template:
    metadata:
      annotations:
        apps.tanzu.vmware.com/correlationid: https://github.com/ksankaranara-vmw/tanzu-java-web-app-prometheus?sub_path=/
        autoscaling.knative.dev/min-scale: "1"
        developer.conventions/target-containers: workload
      labels:
        app.kubernetes.io/component: run
        app.kubernetes.io/part-of: tanzu-java-web-app-prometheus-without-annotations
        apps.tanzu.vmware.com/workload-type: web
        carto.run/workload-name: tanzu-java-web-app-prometheus-without-annotations
    spec:
      containers:
      - image: dev.registry.tanzu.vmware.com/app-live-view/test/tanzu-java-web-app-prometheus-without-annotations-default@sha256:552c7f86b410b700716c709742434e0ea9e022934bc4fe66a5bb12a5241ea644
        name: workload
        resources: {}
        securityContext:
          allowPrivilegeEscalation: false
          capabilities:
            drop:
            - ALL
          runAsNonRoot: true
          runAsUser: 1000
          seccompProfile:
            type: RuntimeDefault
      serviceAccountName: default
status:
  conditions:
  - lastTransitionTime: "2024-03-01T11:32:31Z"
    message: ""
    reason: Applied
    status: "True"
    type: ConventionsApplied
  - lastTransitionTime: "2024-03-01T11:32:31Z"
    message: ""
    reason: ConventionsApplied
    status: "True"
    type: Ready
  observedGeneration: 1
  template:
    metadata:
      annotations:
        apps.tanzu.vmware.com/correlationid: https://github.com/ksankaranara-vmw/tanzu-java-web-app-prometheus?sub_path=/
        autoscaling.knative.dev/min-scale: "1"
        boot.spring.io/version: 3.1.3
        conventions.carto.run/applied-conventions: |-
          spring-boot-convention/auto-configure-actuators-check
          spring-boot-convention/is-native-app-check
          spring-boot-convention/is-prometheus-enabled-check
          spring-boot-convention/spring-boot
          spring-boot-convention/spring-boot-graceful-shutdown
          spring-boot-convention/spring-boot-web
          spring-boot-convention/spring-boot-actuator
          spring-boot-convention/spring-boot-prometheus-enabled
          spring-boot-convention/spring-boot-actuator-probes
          spring-boot-convention/app-live-view-appflavour-check
          spring-boot-convention/app-live-view-connector-boot
          spring-boot-convention/app-live-view-appflavours-boot
        developer.conventions/target-containers: workload
        prometheus.io/path: /actuator/prometheus
        prometheus.io/port: "8080"
        prometheus.io/scrape: "true"
      labels:
        app.kubernetes.io/component: run
        app.kubernetes.io/part-of: tanzu-java-web-app-prometheus-without-annotations
        apps.tanzu.vmware.com/auto-configure-actuators: "false"
        apps.tanzu.vmware.com/workload-type: web
        carto.run/workload-name: tanzu-java-web-app-prometheus-without-annotations
        conventions.carto.run/framework: spring-boot
        tanzu.app.live.view: "true"
        tanzu.app.live.view.application.actuator.path: actuator
        tanzu.app.live.view.application.actuator.port: "8080"
        tanzu.app.live.view.application.flavours: spring-boot
        tanzu.app.live.view.application.name: tanzu-java-web-app-prometheus-without-annotations
    spec:
      containers:
      - env:
        - name: JAVA_TOOL_OPTIONS
          value: -Dmanagement.endpoint.health.probes.add-additional-paths="true" -Dmanagement.health.probes.enabled="true"
            -Dserver.port="8080" -Dserver.shutdown.grace-period="24s"
        image: dev.registry.tanzu.vmware.com/app-live-view/test/tanzu-java-web-app-prometheus-without-annotations-default@sha256:552c7f86b410b700716c709742434e0ea9e022934bc4fe66a5bb12a5241ea644
        livenessProbe:
          httpGet:
            path: /livez
            port: 8080
            scheme: HTTP
        name: workload
        ports:
        - containerPort: 8080
          protocol: TCP
        readinessProbe:
          httpGet:
            path: /readyz
            port: 8080
            scheme: HTTP
        resources: {}
        securityContext:
          allowPrivilegeEscalation: false
          capabilities:
            drop:
            - ALL
          runAsNonRoot: true
          runAsUser: 1000
          seccompProfile:
            type: RuntimeDefault
        startupProbe:
          httpGet:
            path: /readyz
            port: 8080
            scheme: HTTP
      serviceAccountName: default
```

Example output of a Spring Boot workload PodIntent if the `apps.tanzu.vmware.com/auto-configure-actuators`
label is set to `true` on the workload YAML:

```console
apiVersion: conventions.carto.run/v1alpha1
kind: PodIntent
metadata:
  creationTimestamp: "2024-03-01T16:33:48Z"
  generation: 1
  labels:
    app.kubernetes.io/component: intent
    app.kubernetes.io/part-of: tanzu-java-web-app-prometheus-without-annotations
    apps.tanzu.vmware.com/auto-configure-actuators: "true"
    apps.tanzu.vmware.com/workload-type: web
    carto.run/cluster-template-name: convention-template
    carto.run/resource-name: config-provider
    carto.run/supply-chain-name: source-to-url
    carto.run/template-kind: ClusterConfigTemplate
    carto.run/template-lifecycle: mutable
    carto.run/workload-name: tanzu-java-web-app-prometheus-without-annotations-auto-configure-actuators
    carto.run/workload-namespace: default
  name: tanzu-java-web-app-prometheus-without-annotations-auto-configure-actuators
  namespace: default
  ownerReferences:
  - apiVersion: carto.run/v1alpha1
    blockOwnerDeletion: true
    controller: true
    kind: Workload
    name: tanzu-java-web-app-prometheus-without-annotations-auto-configure-actuators
    uid: 2a52e88e-a819-4f96-a49b-ca976225bb9c
  resourceVersion: "42809"
  uid: 2eb9b397-b423-45f2-b618-45bf6503e81a
spec:
  serviceAccountName: default
  template:
    metadata:
      annotations:
        apps.tanzu.vmware.com/correlationid: https://github.com/ksankaranara-vmw/tanzu-java-web-app-prometheus?sub_path=/
        autoscaling.knative.dev/min-scale: "1"
        developer.conventions/target-containers: workload
      labels:
        app.kubernetes.io/component: run
        app.kubernetes.io/part-of: tanzu-java-web-app-prometheus-without-annotations
        apps.tanzu.vmware.com/auto-configure-actuators: "true"
        apps.tanzu.vmware.com/workload-type: web
        carto.run/workload-name: tanzu-java-web-app-prometheus-without-annotations-auto-configure-actuators
    spec:
      containers:
      - image: dev.registry.tanzu.vmware.com/app-live-view/test/tanzu-java-web-app-prometheus-without-annotations-auto-configure-actuators-default@sha256:25bac27dd331267a48eda30dfb7d9f96294ec88ce225a4294c7d2377f6765ee0
        name: workload
        resources: {}
        securityContext:
          allowPrivilegeEscalation: false
          capabilities:
            drop:
            - ALL
          runAsNonRoot: true
          runAsUser: 1000
          seccompProfile:
            type: RuntimeDefault
      serviceAccountName: default
status:
  conditions:
  - lastTransitionTime: "2024-03-01T16:33:48Z"
    message: ""
    reason: Applied
    status: "True"
    type: ConventionsApplied
  - lastTransitionTime: "2024-03-01T16:33:48Z"
    message: ""
    reason: ConventionsApplied
    status: "True"
    type: Ready
  observedGeneration: 1
  template:
    metadata:
      annotations:
        apps.tanzu.vmware.com/correlationid: https://github.com/ksankaranara-vmw/tanzu-java-web-app-prometheus?sub_path=/
        autoscaling.knative.dev/min-scale: "1"
        boot.spring.io/actuator: http://:8081/actuator
        boot.spring.io/version: 3.1.3
        conventions.carto.run/applied-conventions: |-
          spring-boot-convention/auto-configure-actuators-check
          spring-boot-convention/is-native-app-check
          spring-boot-convention/is-prometheus-enabled-check
          spring-boot-convention/spring-boot
          spring-boot-convention/spring-boot-graceful-shutdown
          spring-boot-convention/spring-boot-web
          spring-boot-convention/spring-boot-actuator
          spring-boot-convention/spring-boot-prometheus-enabled
          spring-boot-convention/spring-boot-actuator-probes
          spring-boot-convention/app-live-view-appflavour-check
          spring-boot-convention/app-live-view-connector-boot
          spring-boot-convention/app-live-view-appflavours-boot
        developer.conventions/target-containers: workload
        prometheus.io/path: /actuator/prometheus
        prometheus.io/port: "8081"
        prometheus.io/scrape: "true"
      labels:
        app.kubernetes.io/component: run
        app.kubernetes.io/part-of: tanzu-java-web-app-prometheus-without-annotations
        apps.tanzu.vmware.com/auto-configure-actuators: "true"
        apps.tanzu.vmware.com/workload-type: web
        carto.run/workload-name: tanzu-java-web-app-prometheus-without-annotations-auto-configure-actuators
        conventions.carto.run/framework: spring-boot
        tanzu.app.live.view: "true"
        tanzu.app.live.view.application.actuator.path: actuator
        tanzu.app.live.view.application.actuator.port: "8081"
        tanzu.app.live.view.application.flavours: spring-boot
        tanzu.app.live.view.application.name: tanzu-java-web-app-prometheus-without-annotations-auto-configure-actuators
    spec:
      containers:
      - env:
        - name: JAVA_TOOL_OPTIONS
          value: -Dmanagement.endpoint.health.probes.add-additional-paths="true" -Dmanagement.endpoint.health.show-details="always"
            -Dmanagement.endpoints.web.base-path="/actuator" -Dmanagement.endpoints.web.exposure.include="*"
            -Dmanagement.health.probes.enabled="true" -Dmanagement.server.port="8081"
            -Dserver.port="8080" -Dserver.shutdown.grace-period="24s"
        image: dev.registry.tanzu.vmware.com/app-live-view/test/tanzu-java-web-app-prometheus-without-annotations-auto-configure-actuators-default@sha256:25bac27dd331267a48eda30dfb7d9f96294ec88ce225a4294c7d2377f6765ee0
        livenessProbe:
          httpGet:
            path: /livez
            port: 8080
            scheme: HTTP
        name: workload
        ports:
        - containerPort: 8080
          protocol: TCP
        readinessProbe:
          httpGet:
            path: /readyz
            port: 8080
            scheme: HTTP
        resources: {}
        securityContext:
          allowPrivilegeEscalation: false
          capabilities:
            drop:
            - ALL
          runAsNonRoot: true
          runAsUser: 1000
          seccompProfile:
            type: RuntimeDefault
        startupProbe:
          httpGet:
            path: /readyz
            port: 8080
            scheme: HTTP
      serviceAccountName: default
```

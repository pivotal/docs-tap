# Conventions

When submitting the following pod `Pod Intent` on each convention, 
the output may change depending on the applied convention.

Before any spring boot conventions are applied, the pod intent will 
look something like the following:

  ```yaml
  apiVersion: conventions.apps.tanzu.vmware.com/v1alpha1
  kind: PodIntent
  metadata:
    name: spring-sample
  spec:
    template:
      spec:
        containers:
        - name: workload
          image: springio/petclinic
  ```

Most of the Spring Boot conventions will either modify or add properties to the environment variable `JAVA_TOOL_OPTIONS`.

If a `JAVA_TOOL_OPTIONS` property already exists for a workload, the convention will use the existing value rather than the value the convention has been designed to apply by default (The provided property value will be used for the pod spec mutation.)

<a id="set-java-tool-options-property"></a>**Instructions to set a `JAVA_TOOL_OPTIONS` property for a workload:**

There are two approaches:
1. Set property using the `--env` flag:<br/>
When creating/updating a workload, a `JAVA_TOOL_OPTIONS` property can be set using the Tanzu CLI `apps` plugin as follows: 
    ```
    tanzu apps workload create APP-NAME --env JAVA_TOOL_OPTIONS="-D[property]=[value]"
    ```
    For example, setting the management port to 8080 rather than the [spring-boot-actuator-convention](#spring-boot-actuator-convention) default (port 8081) can be achieved via the following Tanzu CLI command:
    ```
    tanzu apps workload create APP-NAME --env JAVA_TOOL_OPTIONS="-Dmanagement.server.port=8080"
    ```
1. Set property using `workload.yaml`:<br/>
If desired, the JAVA_TOOL_OPTIONS value(s) can be provided in the workload.yaml as follows:
    ```
    apiVersion: carto.run/v1alpha1
    kind: Workload
    ...
    spec:
     env:
     - name: JAVA_TOOL_OPTIONS
       value: -Dmanagement.server.port=8082
     source:
    ...
    ```


## <a id="spring-boot-convention"></a>Spring Boot convention

  In the `bom` file's metadata, under `dependencies`, there is a `dependency` named `spring-boot`. The convention `spring-boot` adds a __label__ to the `PodTemplateSpec` setting the framework used by running `conventions.apps.tanzu.vmware.com/framework: spring-boot`. The convention `spring-boot` also adds an __annotation__ with the version of the _dependency_.

Example of PodIntent after applying the convention:

  ```yaml
  apiVersion: conventions.apps.tanzu.vmware.com/v1alpha1
  kind: PodIntent
  metadata:
    annotations:
      kubectl.kubernetes.io/last-applied-configuration: |
        {"apiVersion":"conventions.apps.tanzu.vmware.com/v1alpha1","kind":"PodIntent","metadata":{"annotations":{},"name":"spring-sample","namespace":"default"},"spec":{"template":{"spec":{"containers":[{"image":"springio/petclinic","name":"workload"}]}}}}
    creationTimestamp: "..."
    generation: 1
    name: spring-sample
    namespace: default
    resourceVersion: "..."
    uid: ...
  spec:
    serviceAccountName: default
    template:
      metadata: {}
      spec:
        containers:
        - image: springio/petclinic
          name: workload
          resources: {}
  status:
    conditions:
    - lastTransitionTime: "..." # This status indicates that all worked as expected
      status: "True"
      type: ConventionsApplied
    - lastTransitionTime: "..."
      status: "True"
      type: Ready
    observedGeneration: 1
    template:
      metadata:
        annotations:
          boot.spring.io/version: 2.3.3.RELEASE
          conventions.apps.tanzu.vmware.com/applied-conventions: |-
            spring-boot-convention/spring-boot
        labels:
          conventions.apps.tanzu.vmware.com/framework: spring-boot
      spec:
        containers:
        - image: index.docker.io/springio/petclinic@sha256:...
          name: workload
          resources: {}
  ```

## <a id="spring-boot-graceful-shutdown-convention"></a>Spring Boot graceful shutdown convention

  In the `bom` file's metadata, under `dependencies`, if there are any of the following `dependencies`, the convention is applied to the `PodTemplateSpec` object:

  - spring-boot-starter-tomcat
  - spring-boot-starter-jetty
  - spring-boot-starter-reactor-netty
  - spring-boot-starter-undertow
  - tomcat-embed-core

  The convention `spring-boot-graceful-shutdown` adds a _property_ in the environment variable `JAVA_TOOL_OPTIONS`. It adds _key_ `server.shutdown.grace-period` and _value_, which is 80% of the set value in `target.Spec.TerminationGracePeriodSeconds` (or 30 seconds).

Example of PodIntent after applying the convention:

  ```yaml
  apiVersion: conventions.apps.tanzu.vmware.com/v1alpha1
  kind: PodIntent
  metadata:
    annotations:
      kubectl.kubernetes.io/last-applied-configuration: |
        {"apiVersion":"conventions.apps.tanzu.vmware.com/v1alpha1","kind":"PodIntent","metadata":{"annotations":{},"name":"spring-sample","namespace":"default"},"spec":{"template":{"spec":{"containers":[{"image":"springio/petclinic","name":"workload"}]}}}}
    creationTimestamp: "..."
    generation: 1
    name: spring-sample
    namespace: default
    resourceVersion: "..."
    uid: ...
  spec:
    serviceAccountName: default
    template:
      metadata: {}
      spec:
        containers:
        - image: springio/petclinic
          name: workload
          resources: {}
  status:
    conditions:
    - lastTransitionTime: "..." # This status indicates that all worked as expected
      status: "True"
      type: ConventionsApplied
    - lastTransitionTime: "..."
      status: "True"
      type: Ready
    observedGeneration: 1
    template:
      metadata:
        annotations:
          boot.spring.io/version: 2.3.3.RELEASE
          conventions.apps.tanzu.vmware.com/applied-conventions: |-
            spring-boot-convention/spring-boot
            spring-boot-convention/spring-boot-graceful-shutdown
        labels:
          conventions.apps.tanzu.vmware.com/framework: spring-boot
      spec:
        containers:
        - env:
          - name: JAVA_TOOL_OPTIONS
            value: -Dserver.shutdown.grace-period="24s"
          image: index.docker.io/springio/petclinic@sha256:...
          name: workload
          resources: {}
  ```

## <a id="spring-boot-web-convention"></a>Spring Boot web convention

In the `bom` file's metadata, under `dependencies`, if there are any of the following `dependencies`, the convention is applied to the `PodTemplateSpec` object:

  - spring-boot
  - spring-boot-web

The convention `spring-boot-web` adds the default 8080 `port` to the `PodTemplateSpec`.

Example of PodIntent after applying the convention:

  ```yaml
  apiVersion: conventions.apps.tanzu.vmware.com/v1alpha1
  kind: PodIntent
  metadata:
    annotations:
      kubectl.kubernetes.io/last-applied-configuration: |
        {"apiVersion":"conventions.apps.tanzu.vmware.com/v1alpha1","kind":"PodIntent","metadata":{"annotations":{},"name":"spring-sample","namespace":"default"},"spec":{"template":{"spec":{"containers":[{"image":"springio/petclinic","name":"workload"}]}}}}
    creationTimestamp: "..."
    generation: 1
    name: spring-sample
    namespace: default
    resourceVersion: "..."
    uid: ...
  spec:
    serviceAccountName: default
    template:
      metadata: {}
      spec:
        containers:
        - image: springio/petclinic
          name: workload
          resources: {}
  status:
    conditions:
    - lastTransitionTime: "..." # This status indicates that all worked as expected
      status: "True"
      type: ConventionsApplied
    - lastTransitionTime: "..."
      status: "True"
      type: Ready
    observedGeneration: 1
    template:
      metadata:
        annotations:
          boot.spring.io/version: 2.3.3.RELEASE
          conventions.apps.tanzu.vmware.com/applied-conventions: |-
            spring-boot-convention/spring-boot
            spring-boot-convention/spring-boot-web
        labels:
          conventions.apps.tanzu.vmware.com/framework: spring-boot
      spec:
        containers:
        - env:
          - name: JAVA_TOOL_OPTIONS
            value: -Dserver.port="8080"
          image: index.docker.io/springio/petclinic@sha256:...
          name: workload
          ports:
          - containerPort: 8080
            protocol: TCP
          resources: {}
  ```

## <a id="spring-boot-actuator-convention"></a>Spring Boot actuator convention

In the `SBOM` file's metadata, under `dependencies`, there is a `dependency` with the name `spring-boot-actuator`. The `spring-boot-actuator` convention does the following:
1. add the management port (set to port 8081) to the `JAVA_TOOL_OPTIONS` environment variable **\***
1. add the base path (set to `/actuator`) to the `JAVA_TOOL_OPTIONS` environment variable
1. add an annotation (`boot.spring.io/actuator`) where the actuator is accessed

***NOTE:** The management port is set to port 8081 for security reasons.
  * Although there are approaches to locking down public access to the actuator endpoints exposed on the management port when set to the default (8080), the threat of exposure through internal access remains, and setting the management port to something other than 8080 is our recommended security best practice
  * However, if the management port number is provided via the `-Dmanagement.server.port` property in `JAVA_TOOL_OPTIONS`, the value provided for that property is respected by the spring boot actuator convention (the management port will be set to the provided port number rather than 8081)
    * Alternative methods for setting the management port will be disregarded/overwritten (for example: For example, if an application is configured with a specific management port via `application.properties/yml`, `config server`, or any other "usual" Spring Boot config mechanism, the convention will override that management port configuration.).
    * Instructions for providing the management port number for an application are available [here](#set-java-tool-options-property)
  * The management context of a Spring Boot application can be accessed by creating a service pointing to port `8081` and base path `/actuator`.


Example of PodIntent after applying the convention:

  ```yaml
  apiVersion: conventions.apps.tanzu.vmware.com/v1alpha1
  kind: PodIntent
  metadata:
    annotations:
      kubectl.kubernetes.io/last-applied-configuration: |
        {"apiVersion":"conventions.apps.tanzu.vmware.com/v1alpha1","kind":"PodIntent","metadata":{"annotations":{},"name":"spring-sample","namespace":"default"},"spec":{"template":{"spec":{"containers":[{"image":"springio/petclinic","name":"workload"}]}}}}
    creationTimestamp: "..."
    generation: 1
    name: spring-sample
    namespace: default
    resourceVersion: "..."
    uid: ...
  spec:
    serviceAccountName: default
    template:
      metadata: {}
      spec:
        containers:
        - image: springio/petclinic
          name: workload
          resources: {}
  status:
    conditions:
    - lastTransitionTime: "..." # This status indicates that all worked as expected
      status: "True"
      type: ConventionsApplied
    - lastTransitionTime: "..."
      status: "True"
      type: Ready
    observedGeneration: 1
    template:
      metadata:
        annotations:
          boot.spring.io/actuator: http://:8080/actuator
          boot.spring.io/version: 2.3.3.RELEASE
          conventions.apps.tanzu.vmware.com/applied-conventions: |-
            spring-boot-convention/spring-boot
            spring-boot-convention/spring-boot-web
            spring-boot-convention/spring-boot-actuator
        labels:
          conventions.apps.tanzu.vmware.com/framework: spring-boot
      spec:
        containers:
        - env:
          - name: JAVA_TOOL_OPTIONS
            value: Dmanagement.endpoints.web.base-path="/actuator" -Dmanagement.server.port="8081" -Dserver.port="8080"
          image: index.docker.io/springio/petclinic@sha256:...
          name: workload
          ports:
          - containerPort: 8080
            protocol: TCP
          resources: {}
  ```

## <a id="spring-boot-actuator-probes-convention"></a>Spring Boot Actuator Probes convention

  In the `bom` file's metadata, under `dependencies`, there is a `dependency` with the name `spring-boot-actuator-probes` with version equal to or greater than **2.6**. The convention `spring-boot-actuator-probes` adds the *liveness* and *readiness* [probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) whenever the property `management.health.probes.enabled` is not set to true.

Example of PodIntent after applying the convention:

  ```yaml
  apiVersion: conventions.apps.tanzu.vmware.com/v1alpha1
  kind: PodIntent
  metadata:
    annotations:
      kubectl.kubernetes.io/last-applied-configuration: |
        {"apiVersion":"conventions.apps.tanzu.vmware.com/v1alpha1","kind":"PodIntent","metadata":{"annotations":{},"name":"spring-sample","namespace":"default"},"spec":{"template":{"spec":{"containers":[{"image":"springio/petclinic","name":"workload"}]}}}}
    creationTimestamp: "..."
    generation: 1
    name: spring-sample
    namespace: default
    resourceVersion: "..."
    uid: ...
  spec:
    serviceAccountName: default
    template:
      metadata: {}
      spec:
        containers:
        - image: springio/petclinic
          name: workload
          resources: {}
  status:
    conditions:
    - lastTransitionTime: "..." # This status indicates that all worked as expected
      status: "True"
      type: ConventionsApplied
    - lastTransitionTime: "..."
      status: "True"
      type: Ready
    observedGeneration: 1
    template:
      metadata:
        annotations:
          boot.spring.io/actuator: http://:8080/actuator
          boot.spring.io/version: 2.6.0
          conventions.apps.tanzu.vmware.com/applied-conventions: |-
            spring-boot-convention/spring-boot
            spring-boot-convention/spring-boot-web
            spring-boot-convention/spring-boot-actuator
        labels:
          conventions.apps.tanzu.vmware.com/framework: spring-boot
      spec:
        containers:
        - env:
          - name: JAVA_TOOL_OPTIONS
            value: -Dmanagement.endpoint.health.probes.add-additional-paths="true" -Dmanagement.endpoint.health.show-details="always" -Dmanagement.endpoints.web.base-path="/actuator" -Dmanagement.endpoints.web.exposure.include="*" -Dmanagement.health.probes.enabled="true" -Dmanagement.server.port="8081" -Dserver.port="8080"
          image: index.docker.io/springio/petclinic@sha256:...
          name: workload
          livenessProbe:
            httpGet:
              path: /livez
              port: 8080
              scheme: HTTP
          ports:
          - containerPort: 8080
            protocol: TCP
          readinessProbe:
            httpGet:
              path: /readyz
              port: 8080
              scheme: HTTP
          resources: {}
  ```

## <a id="service-intent-conventions"></a>Service intent conventions

The _Service intent_ conventions do not change the behavior of the final deployment but can be used as added information to process in the supply chain. For example, when an application requires the binding of a database service. This convention adds an __annotation__ and a label to the `PodTemplateSpec` for each detected dependency. It adds an __annotation__ and a label to the `conventions.apps.tanzu.vmware.com/applied-conventions` as well.

The list of the supported intents are:

  - MySQL
    - __Name__: `service-intent-mysql` 
    - __Label__: `services.conventions.apps.tanzu.vmware.com/mysql`
    - __Dependencies__: `mysql-connector-java`, `r2dbc-mysql`
  - PostreSql
    - __Name__: `service-intent-postgres`
    - __Label__: `services.conventions.apps.tanzu.vmware.com/postgres`
    - __Dependencies__: `postgresql`, `r2dbc-postgresql`
  - MongoDB
    - __Name__: `service-intent-mongodb`
    - __Label__: `services.conventions.apps.tanzu.vmware.com/mongodb`
    - __Dependencies__: `mongodb-driver-core`
  - RabbitMQ
    - __Name__: `service-intent-rabbitmq`
    - __Label__: `services.conventions.apps.tanzu.vmware.com/rabbitmq`
    - __Dependencies__: `amqp-client`
  - Redis
    - __Name__: `service-intent-redis`
    - __Label__: `services.conventions.apps.tanzu.vmware.com/redis`
    - __Dependencies__: `jedis`
  - Kafka
    - __Name__: `service-intent-kafka`
    - __Label__: `services.conventions.apps.tanzu.vmware.com/kafka`
    - __Dependencies__: `kafka-clients`
  - Kafka-streams
    - __Name__: `service-intent-kafka-streams`
    - __Label__: `services.conventions.apps.tanzu.vmware.com/kafka-streams`
    - __Dependencies__: `kafka-streams`

### <a id="example"></a>Example

When you apply the `Pod Intent` and the image contains a dependency, for example, of _MySQL_, then the output of the convention will be:

```yaml
  apiVersion: conventions.apps.tanzu.vmware.com/v1alpha1
  kind: PodIntent
  metadata:
    annotations:
      kubectl.kubernetes.io/last-applied-configuration: |
        {"apiVersion":"conventions.apps.tanzu.vmware.com/v1alpha1","kind":"PodIntent","metadata":{"annotations":{},"name":"spring-sample","namespace":"default"},"spec":{"template":{"spec":{"containers":[{"image":"springio/petclinic","name":"workload"}]}}}}
    creationTimestamp: "..."
    generation: 1
    name: spring-sample
    namespace: default
    resourceVersion: "..."
    uid: ...
  spec:
    serviceAccountName: default
    template:
      metadata: {}
      spec:
        containers:
        - image: springio/petclinic
          name: workload
          resources: {}
  status:
    conditions:
    - lastTransitionTime: "..." # This status indicates that all worked as expected
      status: "True"
      type: ConventionsApplied
    - lastTransitionTime: "..."
      status: "True"
      type: Ready
    observedGeneration: 1
    template:
      metadata:
        annotations:
          boot.spring.io/actuator: http://:8080/actuator
          boot.spring.io/version: 2.3.3.RELEASE
          conventions.apps.tanzu.vmware.com/applied-conventions: |-
            spring-boot-convention/spring-boot
            spring-boot-convention/spring-boot-web
            spring-boot-convention/spring-boot-actuator
            spring-boot-convention/service-intent-mysql
          services.conventions.apps.tanzu.vmware.com/mysql: mysql-connector-java/8.0.21
        labels:
          conventions.apps.tanzu.vmware.com/framework: spring-boot
          services.conventions.apps.tanzu.vmware.com/mysql: workload
      spec:
        containers:
        - env:
          - name: JAVA_TOOL_OPTIONS
            value: Dmanagement.endpoints.web.base-path="/actuator" -Dmanagement.server.port="8081" -Dserver.port="8080"
          image: index.docker.io/springio/petclinic@sha256:...
          name: workload
          ports:
          - containerPort: 8080
            protocol: TCP
          resources: {}
  ```

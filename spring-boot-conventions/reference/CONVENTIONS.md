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

Most of the Spring Boot conventions will either modify or add 
properties to the environment variable `JAVA_TOOL_OPTIONS`.
It's possible to override those conventions by providing the 
desired `JAVA_TOOL_OPTIONS` property/value via the Tanzu 
CLI/workload.yaml.

When a `JAVA_TOOL_OPTIONS` property already exists for a 
workload, the convention will use the existing value rather 
than the value the convention has been designed to apply by 
default (The provided property value will be used for the 
pod spec mutation.)

## How to set a `JAVA_TOOL_OPTIONS` property for a workload <a id="set-java-tool-options"></a>

To set `JAVA_TOOL_OPTIONS` property/values, do one of the following:

- **Use the Tanzu CLI `apps` plug-in:** When creating or updating a workload,
set a `JAVA_TOOL_OPTIONS` property using the `--env` flag by running:

    ```
    tanzu apps workload create APP-NAME --env JAVA_TOOL_OPTIONS="-DPROPERTY-NAME=VALUE"
    ```
    For example, to set the management port to `8080` rather than the
    [spring-boot-actuator-convention](#spring-boot-actuator-convention) default port `8081`, run:
    ```
    tanzu apps workload create APP-NAME --env JAVA_TOOL_OPTIONS="-Dmanagement.server.port=8080"
    ```
- **Use the `workload.yaml`:** Provide one or more values for the `JAVA_TOOL_OPTIONS`
property in the `workload.yaml` as follows:

    ```
    apiVersion: carto.run/v1alpha1
    kind: Workload
    
    ...
    
    spec<!-- |specifications| is preferred. -->:
     env<!-- |environment| is preferred -->:
     - name: JAVA_TOOL_OPTIONS
       value: -Dmanagement.server.port=8082
     source:
     
    ...
    
    ```

## Spring Boot Convention<a id="spring-boot-convention"></a>

In the metadata within the `SBOM` file, under `dependencies`, if the `dependency` 
below is found, the Spring Boot convention will be applied to 
the `PodTemplateSpec` object:

- `spring-boot`

The Spring Boot convention adds a _label_ (`conventions.apps.tanzu.vmware.com/framework: spring-boot`) to the 
`PodTemplateSpec` which describes the framework associated with the workload and it adds an _annotation_ (`boot.spring.io/version: VERSION-NO`) which describes the Spring Boot version of the _dependency_.

The label and annotation are added informational/visibility purposes only.

Example of PodIntent after applying the convention:

  ```yaml
  apiVersion: conventions.apps.tanzu.vmware.com/v1alpha1
  kind: PodIntent
  metadata:
    annotations:
      kubectl.kubernetes.io/last-applied-configuration: |
        {"apiVersion":"conventions.apps.tanzu.vmware.com/v1alpha1","kind":"PodIntent","metadata":{"annotations":{},"name":"spring-sample","namespace":"default"},"spec":{"template":{"spec":{"containers":[{"image":"springio/petclinic","name":"workload"}]}}}}
  
  ...

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

## Spring Boot Graceful Shutdown Convention<a id="spring-boot-graceful-shutdown-convention"></a>

In the metadata within the `SBOM` file, under `dependencies`, if any of the `dependencies` 
below are found, the Spring Boot graceful shutdown convention will be applied to 
the `PodTemplateSpec` object:

  - spring-boot-starter-tomcat
  - spring-boot-starter-jetty
  - spring-boot-starter-reactor-netty
  - spring-boot-starter-undertow
  - tomcat-embed-core

The Graceful Shutdown convention `spring-boot-graceful-shutdown` adds 
a _property_ in the environment variable `JAVA_TOOL_OPTIONS` with _key_ 
`server.shutdown.grace-period`. The key value is calculated to be 80% 
of the value set in `.target.Spec.TerminationGracePeriodSeconds`. The 
default value for `.target.Spec.TerminationGracePeriodSeconds` is 30 seconds.

Example of PodIntent after applying the convention:

  ```yaml
  apiVersion: conventions.apps.tanzu.vmware.com/v1alpha1
  kind: PodIntent
  metadata:
    annotations:
      kubectl.kubernetes.io/last-applied-configuration: |
        {"apiVersion":"conventions.apps.tanzu.vmware.com/v1alpha1","kind":"PodIntent","metadata":{"annotations":{},"name":"spring-sample","namespace":"default"},"spec":{"template":{"spec":{"containers":[{"image":"springio/petclinic","name":"workload"}]}}}}
  
  ...
  
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

## Spring Boot Web Convention<a id="spring-boot-web-convention"></a>

In the metadata within the `SBOM` file, under `dependencies`, if any of the `dependencies` 
below are found, the Spring Boot web convention will be applied to 
the `PodTemplateSpec` object:

  - spring-boot
  - spring-boot-web

The Web Convention `spring-boot-web` gets the `server.port` property from 
the `JAVA_TOOL_OPTIONS` environment variable and sets it as a port in the 
`PodTemplateSpec`. If `JAVA_TOOL_OPTIONS` environment variable doesn't 
contain a `server.port` property/value, the convention adds the property and
sets the value to `8080` (the Spring Boot default).

Example of PodIntent after applying the convention:

  ```yaml
  apiVersion: conventions.apps.tanzu.vmware.com/v1alpha1
  kind: PodIntent
  metadata:
    annotations:
      kubectl.kubernetes.io/last-applied-configuration: |
        {"apiVersion":"conventions.apps.tanzu.vmware.com/v1alpha1","kind":"PodIntent","metadata":{"annotations":{},"name":"spring-sample","namespace":"default"},"spec":{"template":{"spec":{"containers":[{"image":"springio/petclinic","name":"workload"}]}}}}
  
  ... 
  
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

## Spring Boot Actuator Convention<a id="spring-boot-actuator-convention"></a>

In the metadata within the `SBOM` file, under `dependencies`, if the following `dependency` 
below is found, the Spring Boot actuator convention will be applied to 
the `PodTemplateSpec` object:

  - `spring-boot-actuator`

The Spring Boot Actuator convention does the following:

1. Sets the management port in the `JAVA_TOOL_OPTIONS` environment variable to `8081`.
1. Sets the base path in the `JAVA_TOOL_OPTIONS` environment variable to `/actuator`.
1. Adds an annotation, `boot.spring.io/actuator`, to where the actuator is accessed.

The management port is set to port `8081` for security reasons.
Although you can prevent public access to the actuator endpoints that are exposed
on the management port when it is set to the default `8080`, the threat of
exposure through internal access remains.
The best practice for security is to set the management port to something other than `8080`.

However, if a management port number value is provided via the `-Dmanagement.server.port`
property in `JAVA_TOOL_OPTIONS`, the Spring Boot actuator convention will respect 
that value and use it, rather than its default `8081` as the management port. 

The management context of a Spring Boot application can be accessed by creating
a service pointing to port `8081` and base path `/actuator`.

**IMPORTANT NOTES:** 
* To override the management port setting applied by this convention, see
[How to set a `JAVA_TOOL_OPTIONS` property for a workload](#set-java-tool-options).
* Any alternative methods for setting the management port will be overwritten.
For example, if the management port has been configured via `application.properties/yml` 
or `config server`, the Spring Boot Actuator convention will overrite that config.

Example of PodIntent after applying the convention:

  ```yaml
  apiVersion: conventions.apps.tanzu.vmware.com/v1alpha1
  kind: PodIntent
  metadata:
    annotations:
      kubectl.kubernetes.io/last-applied-configuration: |
        {"apiVersion":"conventions.apps.tanzu.vmware.com/v1alpha1","kind":"PodIntent","metadata":{"annotations":{},"name":"spring-sample","namespace":"default"},"spec":{"template":{"spec":{"containers":[{"image":"springio/petclinic","name":"workload"}]}}}}
   
  ...
  
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

## Spring Boot Actuator Probes Convention<a id="spring-boot-actuator-probes-convention"></a>

The Spring Boot Actuator Probes convention will applied only if **all** 
of the following conditions are met:

  - The `spring-boot-actuator` dependency exists and is **>= 2.6**
  - The `JAVA_TOOL_OPTIONS` environment variable does not include the following 
properties _or_, if either of the properties _is_ included, it is set to a value of `true`:
    - `-Dmanagement.health.probes.enabled`
    - `-Dmanagement.endpoint.health.probes.add-additional-paths`


The Spring Boot Actuator Probes convention does the following:

1. Uses the main server port (the `server.port` property/value on `JAVA_TOOL_OPTIONS`) to set the _liveness_ and _readiness_ [probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)
2. Adds the following properies/values to the `JAVA_TOOL_OPTIONS` environment variable
  - `-Dmanagement.health.probes.enabled="true"`
  - `-Dmanagement.endpoint.health.probes.add-additional-paths="true"`

When this convention has been applied, the probes will be exposed as follows:
- Liveness probe: `/livez`
- Readiness probe: `/readyz`


Example of PodIntent after applying the convention:

  ```yaml
  apiVersion: conventions.apps.tanzu.vmware.com/v1alpha1
  kind: PodIntent
  metadata:
    annotations:
      kubectl.kubernetes.io/last-applied-configuration: |
        {"apiVersion":"conventions.apps.tanzu.vmware.com/v1alpha1","kind":"PodIntent","metadata":{"annotations":{},"name":"spring-sample","namespace":"default"},"spec":{"template":{"spec":{"containers":[{"image":"springio/petclinic","name":"workload"}]}}}}
  
  ...
  
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
            value: -Dmanagement.endpoint.health.probes.add-additional-paths="true" -Dmanagement.endpoints.web.base-path="/actuator" -Dmanagement.health.probes.enabled="true" -Dmanagement.server.port="8081" -Dserver.port="8080"
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

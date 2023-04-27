# List of Spring Boot conventions

This topic tells you about what the conventions do and how to apply them.

When submitting the following pod `Pod Intent` on each convention, the output can change depending on
the applied convention.

Before any spring boot conventions are applied, the pod intent looks similar to this YAML:

```yaml
apiVersion: conventions.carto.run/v1alpha1
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

Most of the Spring Boot conventions either edit or add properties to the environment variable
`JAVA_TOOL_OPTIONS`.
You can override those conventions by providing the `JAVA_TOOL_OPTIONS` value you want through the
Tanzu CLI or `workload.yaml`.

When a `JAVA_TOOL_OPTIONS` property already exists for a workload, the convention uses the existing
value rather than the value that the convention applies by default.
The property value that you provide is used for the pod specification mutation.

## <a id="set-java-tool-options"></a> Set a `JAVA_TOOL_OPTIONS` property for a workload

Do one of the following actions to set `JAVA_TOOL_OPTIONS` property and values:

Use the Tanzu CLI apps plug-in
: When creating or updating a workload, set a `JAVA_TOOL_OPTIONS` property using the `--env` flag by
running:

  ```console
  tanzu apps workload create APP-NAME --env JAVA_TOOL_OPTIONS="-DPROPERTY-NAME=VALUE"
  ```

  For example, to set the management port to `8080` rather than the
  [spring-boot-actuator-convention](#spring-boot-actuator-convention) default port `8081`, run:

  ```console
  tanzu apps workload create APP-NAME --env JAVA_TOOL_OPTIONS="-Dmanagement.server.port=8080"
  ```

Use workload.yaml
: Follow these steps:

  1. Provide one or more values for the `JAVA_TOOL_OPTIONS` property in the `workload.yaml`. For example:

     ```yaml
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

  2. Apply the `workload.yaml` file by running the command:

     ```console
     tanzu apps workload create -f workload.yaml
     ```

## <a id="spring-boot-convention"></a> Spring Boot convention

If the `spring-boot` dependency is in the metadata within the `SBOM` file under `dependencies`,
the Spring Boot convention is applied to the `PodTemplateSpec` object.

The Spring Boot convention adds a label (`conventions.carto.run/framework: spring-boot`) to the
`PodTemplateSpec` that describes the framework associated with the workload, and adds an annotation
(`boot.spring.io/version: VERSION-NO`) that describes the Spring Boot version of the dependency.

The label and annotation are added for informational purposes only.

Example of PodIntent after applying the convention:

```yaml
apiVersion: conventions.carto.run/v1alpha1
kind: PodIntent
metadata:
 annotations:
   kubectl.kubernetes.io/last-applied-configuration: |
     {"apiVersion":"conventions.carto.run/v1alpha1","kind":"PodIntent","metadata":{"annotations":{},"name":"spring-sample","namespace":"default"},"spec":{"template":{"spec":{"containers":[{"image":"springio/petclinic","name":"workload"}]}}}}

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
       conventions.carto.run/applied-conventions: |-
         spring-boot-convention/spring-boot
     labels:
       conventions.carto.run/framework: spring-boot
   spec:
     containers:
     - image: index.docker.io/springio/petclinic@sha256:...
       name: workload
       resources: {}
```

## <a id="grcfl-shtdwn-convention"></a> Spring boot graceful shut down convention

If any of the following dependencies are in the metadata within the `SBOM` file under `dependencies`,
the Spring Boot graceful shut down convention is applied to the `PodTemplateSpec` object:

- `spring-boot-starter-tomcat`
- `spring-boot-starter-jetty`
- `spring-boot-starter-reactor-netty`
- `spring-boot-starter-undertow`
- `tomcat-embed-core`

The Graceful Shutdown convention `spring-boot-graceful-shutdown` adds a property in the environment
variable `JAVA_TOOL_OPTIONS` with the key `server.shutdown.grace-period`.
The key value is calculated to be 80% of the value set in `.target.Spec.TerminationGracePeriodSeconds`.
The default value for `.target.Spec.TerminationGracePeriodSeconds` is 30 seconds.

Example of PodIntent after applying the convention:

```yaml
apiVersion: conventions.carto.run/v1alpha1
kind: PodIntent
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"conventions.carto.run/v1alpha1","kind":"PodIntent","metadata":{"annotations":{},"name":"spring-sample","namespace":"default"},"spec":{"template":{"spec":{"containers":[{"image":"springio/petclinic","name":"workload"}]}}}}

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
        conventions.carto.run/applied-conventions: |-
          spring-boot-convention/spring-boot
          spring-boot-convention/spring-boot-graceful-shutdown
      labels:
        conventions.carto.run/framework: spring-boot
    spec:
      containers:
      - env:
        - name: JAVA_TOOL_OPTIONS
          value: -Dserver.shutdown.grace-period="24s"
        image: index.docker.io/springio/petclinic@sha256:...
        name: workload
        resources: {}
```

## <a id="sb-web-convention"></a> Spring Boot web convention

If any of the following dependencies are in the metadata within the `SBOM` file under `dependencies`,
the Spring Boot web convention is applied to the `PodTemplateSpec` object:

- spring-boot
- spring-boot-web

The web convention `spring-boot-web` obtains the `server.port` property from the `JAVA_TOOL_OPTIONS`
environment variable and sets it as a port in the `PodTemplateSpec`.
If `JAVA_TOOL_OPTIONS` environment variable does not contain a `server.port` property or value, the
convention adds the property and sets the value to `8080`, which is the Spring Boot default.

Example of PodIntent after applying the convention:

```yaml
apiVersion: conventions.carto.run/v1alpha1
kind: PodIntent
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"conventions.carto.run/v1alpha1","kind":"PodIntent","metadata":{"annotations":{},"name":"spring-sample","namespace":"default"},"spec":{"template":{"spec":{"containers":[{"image":"springio/petclinic","name":"workload"}]}}}}

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
        conventions.carto.run/applied-conventions: |-
          spring-boot-convention/spring-boot
          spring-boot-convention/spring-boot-web
      labels:
        conventions.carto.run/framework: spring-boot
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

## <a id="sb-actuator-convention"></a> Spring Boot Actuator convention

If the `spring-boot-actuator` dependency is in the metadata within the `SBOM` file
under `dependencies`, the Spring Boot actuator convention is applied to the `PodTemplateSpec` object.

The Spring Boot Actuator convention does the following actions:

If the workload-level or platform-level automatic configuration of actuators is enabled:

1. Sets the management port in the `JAVA_TOOL_OPTIONS` environment variable to `8081`.
2. Sets the base path in the `JAVA_TOOL_OPTIONS` environment variable to `/actuator`.
3. Adds an annotation, `boot.spring.io/actuator`, to where the actuator is accessed.

The management port is set to port `8081` for security reasons.
Although you can prevent public access to the actuator endpoints that are exposed on the management
port when it is set to the default `8080`, the threat of exposure through internal access remains.
The best practice for security is to set the management port to something other than `8080`.

However, if a management port number value is provided using the `-Dmanagement.server.port`
property in `JAVA_TOOL_OPTIONS`, the Spring Boot actuator convention uses that value rather than its
default `8081` as the management port.

You can access the management context of a Spring Boot application by creating a service pointing to
port `8081` and base path `/actuator`.

> **Important** To override the management port setting applied by this convention, see
> [How to set a JAVA_TOOL_OPTIONS property for a workload](#set-java-tool-options) earlier in this
> topic.
> Any alternative methods for setting the management port are overwritten.
> For example, if you configure the management port using `application.properties/yml`
> or `config server`, the Spring Boot Actuator convention overrides your configuration.

If the workload-level or platform-level automatic configuration of actuators is deactivated, the
Spring Boot actuator convention does not set any `JAVA_TOOLS_OPTIONS` and does not set the annotation
`boot.spring.io/actuator`.

Example of PodIntent after applying the convention:

```yaml
apiVersion: conventions.carto.run/v1alpha1
kind: PodIntent
metadata:
 annotations:
   kubectl.kubernetes.io/last-applied-configuration: |
     {"apiVersion":"conventions.carto.run/v1alpha1","kind":"PodIntent","metadata":{"annotations":{},"name":"spring-sample","namespace":"default"},"spec":{"template":{"spec":{"containers":[{"image":"springio/petclinic","name":"workload"}]}}}}

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
       boot.spring.io/actuator: http://:8081/actuator
       boot.spring.io/version: 2.3.3.RELEASE
       conventions.carto.run/applied-conventions: |-
         spring-boot-convention/spring-boot
         spring-boot-convention/spring-boot-web
         spring-boot-convention/spring-boot-actuator
     labels:
       conventions.carto.run/framework: spring-boot
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

## <a id="sb-actuator-probes-conv"></a> Spring Boot Actuator Probes convention

The Spring Boot Actuator Probes convention is applied only if all of the following conditions are met:

- The `spring-boot-actuator` dependency exists and is **>= 2.6**
- The `JAVA_TOOL_OPTIONS` environment variable does not include the following properties or, if
  either of the properties is included, it is set to a value of `true`:
  - `-Dmanagement.health.probes.enabled`
  - `-Dmanagement.endpoint.health.probes.add-additional-paths`

The Spring Boot Actuator Probes convention does the following actions:

1. Uses the main server port, which is the `server.port` value on `JAVA_TOOL_OPTIONS`,
   to set the liveness and readiness probes. For more information see the
   [Kubernetes documentation](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)
1. Adds the following properties and values to the `JAVA_TOOL_OPTIONS` environment variable:

   - `-Dmanagement.health.probes.enabled="true"`
   - `-Dmanagement.endpoint.health.probes.add-additional-paths="true"`

   When this convention is applied, the probes are exposed as follows:

   - Liveness probe: `/livez`
   - Readiness probe: `/readyz`

Example of PodIntent after applying the convention:

```yaml
apiVersion: conventions.carto.run/v1alpha1
kind: PodIntent
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"conventions.carto.run/v1alpha1","kind":"PodIntent","metadata":{"annotations":{},"name":"spring-sample","namespace":"default"},"spec":{"template":{"spec":{"containers":[{"image":"springio/petclinic","name":"workload"}]}}}}

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
        conventions.carto.run/applied-conventions: |-
          spring-boot-convention/spring-boot
          spring-boot-convention/spring-boot-web
          spring-boot-convention/spring-boot-actuator
      labels:
        conventions.carto.run/framework: spring-boot
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

## <a id="service-intent-conv"></a> Service intent conventions

The Service intent conventions do not change the behavior of the final deployment, but you can use
them as added information to process in the supply chain.
For example, when an app requires to be bound to database service.
This convention adds an annotation and a label to the `PodTemplateSpec` for each detected dependency.
It also adds an annotation and a label to the `conventions.carto.run/applied-conventions`.

The list of the supported intents are:

**MySQL**

- **Name**: `service-intent-mysql`
- **Label**: `services.conventions.apps.tanzu.vmware.com/mysql`
- **Dependencies**: `mysql-connector-java`, `r2dbc-mysql`

**PostgreSQL**

- **Name**: `service-intent-postgres`
- **Label**: `services.conventions.apps.tanzu.vmware.com/postgres`
- **Dependencies**: `postgresql`, `r2dbc-postgresql`

**MongoDB**

- **Name**: `service-intent-mongodb`
- **Label**: `services.conventions.apps.tanzu.vmware.com/mongodb`
- **Dependencies**: `mongodb-driver-core`

**RabbitMQ**

- **Name**: `service-intent-rabbitmq`
- **Label**: `services.conventions.apps.tanzu.vmware.com/rabbitmq`
- **Dependencies**: `amqp-client`

**Redis**

- **Name**: `service-intent-redis`
- **Label**: `services.conventions.apps.tanzu.vmware.com/redis`
- **Dependencies**: `jedis`

**Kafka**

- **Name**: `service-intent-kafka`
- **Label**: `services.conventions.apps.tanzu.vmware.com/kafka`
- **Dependencies**: `kafka-clients`

**Kafka-streams**

- **Name**: `service-intent-kafka-streams`
- **Label**: `services.conventions.apps.tanzu.vmware.com/kafka-streams`
- **Dependencies**: `kafka-streams`

### <a id="example"></a>Example

When you apply the `Pod Intent` and the image contains a dependency, for example, of MySQL, then the
output of the convention is:

```yaml
  apiVersion: conventions.carto.run/v1alpha1
  kind: PodIntent
  metadata:
    annotations:
      kubectl.kubernetes.io/last-applied-configuration: |
        {"apiVersion":"conventions.carto.run/v1alpha1","kind":"PodIntent","metadata":{"annotations":{},"name":"spring-sample","namespace":"default"},"spec":{"template":{"spec":{"containers":[{"image":"springio/petclinic","name":"workload"}]}}}}
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
          conventions.carto.run/applied-conventions: |-
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
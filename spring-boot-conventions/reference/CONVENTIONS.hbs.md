# Conventions

When submitting the following pod `Pod Intent` on each convention, the output can change depending on
the applied convention.
The submitted pod intent looks similar to this YAML:

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

## <a id="spring-boot-convention"></a>Spring boot convention

In the `bom` file's metadata, under `dependencies`, there is a `dependency` named `spring-boot`.
The convention `spring-boot` adds a label to the `PodTemplateSpec` setting the framework used by
running `conventions.apps.tanzu.vmware.com/framework`, `spring-boot`.
The convention `spring-boot` also adds an annotation with the version of the dependency.

The `docker inspect` can look like:

```yaml
[
{
  "Id": "sha256:...",
  "Config": {
    "Hostname": "",
    "Domainname": "",
    "User": "1000:1000",
    "Labels": {
      "io.buildpacks.build.metadata": "{\"bom\":[{\"name\":\"helper\",\"metadata\":{\"layer\":\"helper\",\"names\":[\"ca-certificates-helper\"],\"version\":\"2.2.0\"},\"buildpack\":{\"id\":\"paketo-buildpacks/ca-certificates\",\"version\":\"2.2.0\"}},{\"name\":\"dependencies\",\"metadata\":{\"dependencies\":[{\"name\":\"spring-beans\",\"sha256\":\"33331abcdd8acccea43666782a5807127a0d43ffc6abf1c3252fbb27fc3367b2\",\"version\":\"5.3.6\"},{\"name\":\"spring-boot\",\"sha256\":\"2e46ae8796df9ca1b4ad74eab608b19f771255321e7d9fafb64561e7e030869e\",\"version\":\"2.4.5\"}
```

Convention output:

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

## <a id="spring-boot-graceful-shutdown-convention"></a>Spring boot graceful shutdown convention

In the `bom` file's metadata, under `dependencies`, if there are any of the following `dependencies`,
the convention is applied to the `PodTemplateSpec` object:

- spring-boot-starter-tomcat
- spring-boot-starter-jetty
- spring-boot-starter-reactor-netty
- spring-boot-starter-undertow
- tomcat-embed-core

The convention `spring-boot-graceful-shutdown` adds a property in the environment variable
`JAVA_TOOL_OPTIONS`. It adds key `server.shutdown.grace-period` and value, which is 80% of the set
value in `target.Spec.TerminationGracePeriodSeconds` (or 30 seconds).

`docker inspect` example:

```yaml
[
{
  "Id": "sha256:...",
  "Config": {
    "Hostname": "",
    "Domainname": "",
    "User": "1000:1000",
    "Labels": {
      "io.buildpacks.build.metadata": "{\"bom\":[{\"name\":\"helper\",\"metadata\":{\"layer\":\"helper\",\"names\":[\"ca-certificates-helper\"],\"version\":\"2.2.0\"},\"buildpack\":{\"id\":\"paketo-buildpacks/ca-certificates\",\"version\":\"2.2.0\"}},{\"name\":\"dependencies\",\"metadata\":{\"dependencies\":[{\"name\":\"spring-beans\",\"sha256\":\"33331abcdd8acccea43666782a5807127a0d43ffc6abf1c3252fbb27fc3367b2\",\"version\":\"5.3.6\"},{\"name\":\"spring-boot\",\"sha256\":\"2e46ae8796df9ca1b4ad74eab608b19f771255321e7d9fafb64561e7e030869e\",\"version\":\"2.4.5\"},{\"name\":\"tomcat-embed-core\",\"sha256\":\"b65ee353868ffb331adbf338e55de3adc6a7907c0c5265f8ee2d7e5f7a2da92b\",\"version\":\"9.0.45\"}
```

Convention output:

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

## <a id="spring-boot-web-convention"></a>Spring boot web convention

In the `bom` file's metadata, under `dependencies`, if there are any of the following `dependencies`,
the convention is applied to the `PodTemplateSpec` object:

- spring-boot
- spring-boot-web

The convention `spring-boot-web` adds the default 8080 `port` to the `PodTemplateSpec`.

`docker inspect` example:

```yaml
[
{
  "Id": "sha256:...",
  "Config": {
    "Hostname": "",
    "Domainname": "",
    "User": "1000:1000",
    "Labels": {
      "io.buildpacks.build.metadata": "{\"bom\":[{\"name\":\"helper\",\"metadata\":{\"layer\":\"helper\",\"names\":[\"ca-certificates-helper\"],\"version\":\"2.2.0\"},\"buildpack\":{\"id\":\"paketo-buildpacks/ca-certificates\",\"version\":\"2.2.0\"}},{\"name\":\"dependencies\",\"metadata\":{\"dependencies\":[{\"name\":\"spring-beans\",\"sha256\":\"33331abcdd8acccea43666782a5807127a0d43ffc6abf1c3252fbb27fc3367b2\",\"version\":\"5.3.6\"},{\"name\":\"spring-web\",\"sha256\":\"dd40db91f0ae291c451cb83b18787823249814fe9499d8333972718e9e6edbf7\",\"version\":\"5.3.6\"},{\"name\":\"spring-boot\",\"sha256\":\"2e46ae8796df9ca1b4ad74eab608b19f771255321e7d9fafb64561e7e030869e\",\"version\":\"2.4.5\"}
```

Convention output:

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

## <a id="spring-boot-actuator-convention"></a>Spring boot actuator convention

In the `bom` file's metadata, under `dependencies`, there is a `dependency` with the name
`spring-boot-actuator`.
The convention `spring-boot-actuator` adds the management port and the base path to the environment
variable `JAVA_TOOL_OPTIONS`.
It also adds an annotation (`boot.spring.io/actuator`) where the actuator is accessed.

`docker inspect` example:

```yaml
[
{
  "Id": "sha256:...",
  "Config": {
    "Hostname": "",
    "Domainname": "",
    "User": "1000:1000",
    "Labels": {
      "io.buildpacks.build.metadata": "{\"bom\":[{\"name\":\"helper\",\"metadata\":{\"layer\":\"helper\",\"names\":[\"ca-certificates-helper\"],\"version\":\"2.2.0\"},\"buildpack\":{\"id\":\"paketo-buildpacks/ca-certificates\",\"version\":\"2.2.0\"}},{\"name\":\"dependencies\",\"metadata\":{\"dependencies\":[{\"name\":\"spring-beans\",\"sha256\":\"33331abcdd8acccea43666782a5807127a0d43ffc6abf1c3252fbb27fc3367b2\",\"version\":\"5.3.6\"},{\"name\":\"spring-web\",\"sha256\":\"dd40db91f0ae291c451cb83b18787823249814fe9499d8333972718e9e6edbf7\",\"version\":\"5.3.6\"},{\"name\":\"spring-boot\",\"sha256\":\"2e46ae8796df9ca1b4ad74eab608b19f771255321e7d9fafb64561e7e030869e\",\"version\":\"2.4.5\"},{\"name\":\"spring-boot-actuator\",\"sha256\":\"6bae019e7a8f400a1b98af65596bc742c825e2ba3851cbedde38031e9699ebc0\",\"version\":\"2.4.5\"}
```

Convention output:

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
          value: Dmanagement.endpoints.web.base-path="/actuator" -Dmanagement.server.port="8080" -Dserver.port="8080"
        image: index.docker.io/springio/petclinic@sha256:...
        name: workload
        ports:
        - containerPort: 8080
          protocol: TCP
        resources: {}
```

## <a id="service-intent-conventions"></a>Service intent conventions

The Service intent conventions do not change the behavior of the final deployment but can be used as
added information to process in the supply chain.
For example, when an application requires the binding of a database service.
This convention adds an annotation and a label to the `PodTemplateSpec` for each detected dependency.
It adds an annotation and a label to the `conventions.apps.tanzu.vmware.com/applied-conventions` as
well.

The list of the supported intents are:

- MySQL
  - **Name:** `service-intent-mysql`
  - **Label:** `services.conventions.apps.tanzu.vmware.com/mysql`
  - **Dependencies:** `mysql-connector-java`, `r2dbc-mysql`
- PostgreSQL
  - **Name:** `service-intent-postgres`
  - **Label:** `services.conventions.apps.tanzu.vmware.com/postgres`
  - **Dependencies:** `postgresql`, `r2dbc-postgresql`
- MongoDB
  - **Name:** `service-intent-mongodb`
  - **Label:** `services.conventions.apps.tanzu.vmware.com/mongodb`
  - **Dependencies:** `mongodb-driver-core`
- RabbitMQ
  - **Name:** `service-intent-rabbitmq`
  - **Label:** `services.conventions.apps.tanzu.vmware.com/rabbitmq`
  - **Dependencies:** `amqp-client`
- Redis
  - **Name:** `service-intent-redis`
  - **Label:** `services.conventions.apps.tanzu.vmware.com/redis`
  - **Dependencies:** `jedis`
- Kafka
  - **Name:** `service-intent-kafka`
  - **Label:** `services.conventions.apps.tanzu.vmware.com/kafka`
  - **Dependencies:** `kafka-clients`
- Kafka-streams
  - **Name:** `service-intent-kafka-streams`
  - **Label:** `services.conventions.apps.tanzu.vmware.com/kafka-streams`
  - **Dependencies:** `kafka-streams`

### <a id="example"></a>Example

When you apply the `Pod Intent` and the image contains a dependency, for example, of MySQL, then the
output of the convention is the following:

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
            value: Dmanagement.endpoints.web.base-path="/actuator" -Dmanagement.server.port="8080" -Dserver.port="8080"
          image: index.docker.io/springio/petclinic@sha256:...
          name: workload
          ports:
          - containerPort: 8080
            protocol: TCP
          resources: {}
```

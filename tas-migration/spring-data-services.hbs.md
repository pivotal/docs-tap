# Migrate Spring Data Services apps to Tanzu Application Platform

This topic tells you how to migrate apps bound to Spring Data Services from Tanzu Application Service
(commonly known as TAS) to Tanzu Application Platform (commonly known as TAP).

Both Tanzu Application Service and Tanzu Application Platform support applications with an implementation
of the Service Discovery pattern.
You can migrate an application using Spring Data Services from Tanzu Application Service to
Tanzu Application Platform without changing the application code.

## <a id="deploy-app-to-tas"></a> Deploy the `fortune-teller` app to Tanzu Application Service

This section describes, at a high level, the steps for deploying the example `fortune-teller` app
on Tanzu Application Service.
For more detailed instructions, see the [fortune-teller README](https://github.com/akrishna90/fortune-teller/blob/main/README.adoc) in GitHub.

To deploy the app:

1. Create an instance of MySQL database from the Marketplace by running:

    ```console
    cf create-service  p.mysql db-small fortunes-db
    ```

1. Create an instance of Spring Config Server that points to the config JSON by running:

    ```console
    cf create-service -c '{ "git": { "uri": "https://github.com/spring-cloud-services-samples/fortune-teller", "searchPaths": "configuration"  } }'p.config-server standard config-server
    ```

1. Create an instance of the Service Registry product from the Marketplace by running:

    ```console
    cf create-service s p.service-registry standard service-registry
    ```

1. Push the applications to Tanzu Application Service using `cf push` with an application manifest
   that binds the service instance:

    ```yaml
    ---
    applications:
    - name: fortune-service
      memory: 1024M
      host: fortunes
      path: fortune-teller-fortune-service/target/fortune-teller-fortune-service-0.0.1-SNAPSHOT.jar
      services:
      - fortunes-db
      - config-server
      - service-registry
      env:
        # JBP adds deprecated connectors when using mysql service
        JBP_CONFIG_SPRING_AUTO_RECONFIGURATION: '{"enabled":false}'
        # Replace with API URI of target PCF environment
        #CF_TARGET: https://api.yourpcfenvironment.local
    - name: fortune-ui
      memory: 1024M
      host: fortunes-ui
      path: fortune-teller-ui/target/fortune-teller-ui-0.0.1-SNAPSHOT.jar
      services:
      - config-server
      - service-registry
      env:
        # Replace with API URI of target PCF environment
        #CF_TARGET: https://api.yourpcfenvironment.local
    ```

## <a id="migrate-tas-to-tap"></a> Migrate from Tanzu Application Service to Tanzu Application Platform

This section describes the areas to translate when creating a Tanzu Application Platform workload
that deploys the same app.

### <a id="create-db"></a>Create a database instance

Tanzu Application Service
: Create a service instance using `cf create-service`.

Tanzu Application Platform
: There are multiple options to create an instance. For more information, see
  [Services Toolkit](../services-toolkit/about.hbs.md).

  The easiest way to get started is to create a service instance using Bitnami Services.
  For more information, see
  [Working with Bitnami Services](../bitnami-services/tutorials/working-with-bitnami-services.hbs.md).

### <a id="bind-db"></a>Bind the database instance to the app

Tanzu Application Service
:
  - Include the name of the service instance in the `services` key in the application manifest.
  - Alternatively, use `cf bind-service` to bind the service to the application.

Tanzu Application Platform
: If you are using Bitnami Services, Specify the `ClassClaim` resource in the `spec.serviceClaims`
  section of the `Workload`.

## <a id="deploy-app-to-tap"></a> Deploy the `fortune-teller` application to Tanzu Application Platform

This section describes, at a high level, the steps for deploying an example `fortune-teller` app
on Tanzu Application Platform.

For information about installing and configuring data services on Tanzu Application Platform, see the
[Services Toolkit documentation](../services-toolkit/about.hbs.md).

**Prerequisites:**

To follow this example, you must first deploy Service Registry and Spring Config Server instances.
To do so, apply the following YAML files in the [fortune-teller repo](https://github.com/akrishna90/fortune-teller/tree/main/tap):

- Install Service Registry: Apply the file [eureka-server.yaml)](https://github.com/akrishna90/fortune-teller/blob/main/tap/eureka-server.yaml).
- Install Spring Config Server: Apply the file [configuration-source.yaml](https://github.com/akrishna90/fortune-teller/blob/main/tap/configuration-source.yaml).
- ConfigureSpring Config Server: Apply the file [configuration-slice.yaml](https://github.com/akrishna90/fortune-teller/blob/main/tap/configuration-slice.yaml).
- Setup the `forture-teller` app to use Service Registry and Spring Config Server: Apply the file [resource-claim.yaml](https://github.com/akrishna90/fortune-teller/blob/main/tap/resource-claim.yaml).

> **Note** This prerequisite is not required for all Spring Data Services apps.

To deploy the app:

1. Claim MySQL service from Bitnami services by running:

    ```console
    tanzu service class-claim create fortune-database --class mysql-unmanaged -n my-apps
    tanzu services class-claims get fortune-database --namespace my-apps
    ```

1. Bind the service to your workload. Bind the MySQL service by adding `ClassClaim` under the
   `spec.serviceClaims` section as follows:

    ```yaml
    ---
    apiVersion: carto.run/v1alpha1
    kind: Workload
    metadata:
    name: fortune-teller-fortune-service
    namespace: my-apps
    labels:
      apps.tanzu.vmware.com/workload-type: web
      apps.tanzu.vmware.com/has-tests: "true"
      app.kubernetes.io/part-of: fortune
    spec:
    params:
      - name: annotations
        value:
          autoscaling.knative.dev/minScale: "1"
    build:
      env:
      - name: BP_JVM_VERSION
        value: "8"
      - name: BP_MAVEN_BUILT_MODULE
        value: "fortune-teller-fortune-service"
    env:
      - name: SPRING_CONFIG_IMPORT
        value: "optional:configtree:${SERVICE_BINDING_ROOT}/spring-properties/"
    serviceClaims:
      - name: eureka
        ref:
        apiVersion: services.apps.tanzu.vmware.com/v1alpha1
        kind: ResourceClaim
        name: eurekaserver-sample
      - name: db
        ref:
        apiVersion: services.apps.tanzu.vmware.com/v1alpha1
        kind: ClassClaim
        name: fortune-database
      - name: spring-properties
        ref:
        apiVersion: services.apps.tanzu.vmware.com/v1alpha1
        kind: ResourceClaim
        name: fortune-config
    source:
      git:
      url: https://github.com/akrishna90/fortune-teller
      ref:
        branch: main
    ```

For more information about claiming an instance of MySQL using Bitnami services, see the tutorial
[Working with Bitnami Services](../bitnami-services/tutorials/working-with-bitnami-services.hbs.md).

## <a id="gradle"></a> Using Gradle for building Spring applications

By default, when the `bootJar` task is configured, the `jar` task is also configured and uses
`plain` as the convention for its archive classifier.
This ensures that `bootJar` and `jar` are executed and causes the executable archive and the plain
archive to be built at the same time. For more information, see the
[Spring documentation](https://docs.spring.io/spring-boot/docs/2.5.1/gradle-plugin/reference/htmlsingle/#packaging-executable.and-plain-archives).

### <a id="spring-boot-buildpack"></a> Spring Boot buildpack behavior

The [gradle buildpack](https://github.com/paketo-buildpacks/gradle) produces both `<ARTIFACT_NAME>.jar`
and `<ARTIFACT_NAME>-plain.jar`.
The presence of a second JAR file in the build output means that the Gradle buildpack leaves both
JAR files in compressed form instead of unpacking the `<ARTIFACT_NAME>.jar` file into the application directory.
As a result, the [spring-boot buildpack](https://github.com/paketo-buildpacks/spring-boot) will fail
to find a `<APPLICATION_ROOT>/META-INF/MANIFEST.MF` file and will fail to contribute the
`spring-cloud-bindings` JAR file to the application.
You will be able to run the application, but service bindings will not be processed.

To avoid this, deactivate the `jar` task in your `build.gradle` file to prevent the plain JAR from
being created.

```java
jar {
  enabled = false
}
```

Alternatively you can set `BP_GRADLE_ADDITIONAL_BUILD_ARGUMENTS="-x jar"` to prevent generating the
plain JAR without modifying the `build.gradle` file.

## <a id="maven"></a> Using Maven for building Spring applications

- No changes are required.
- When both Maven and Gradle builds are available, for example, in the case of the [greeting repo](https://github.com/spring-cloud-services-samples/greeting),
  the Paketo Java buildpack checks Maven first and uses Maven to build the application.

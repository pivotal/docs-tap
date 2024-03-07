# Migrate applications bound to Spring Data Services from TAS to TAP

Tanzu Application Service (TAS) and Tanzu Application Platform (TAP) both provide the ability
to provide applications with an implementation of the Service Discovery pattern.
It is possible to migrate an application using Spring Data Services on TAS to TAP without changes to
the application code.

## Deploying the fortune-teller application to TAS

https://github.com/akrishna90/fortune-teller
<!-- did you link to a fork on purpose or should this be the main repo? -->

The steps to deploy on TAS are:

1. Create an instance of mysql database from the marketplace

    ```console
    cf create-service  p.mysql db-small fortunes-db
    ```

1. Create an instance of spring config server pointing to config json

    ```console
    cf create-service -c '{ "git": { "uri": "https://github.com/spring-cloud-services-samples/fortune-teller", "searchPaths": "configuration"  } }'p.config-server standard config-server
    ```

1. Create an instance of the service registry product from the marketplace:

    ```console
    cf create-service s p.service-registry standard service-registry
    ```

1. Cf push the applications to TAS with an application manifest that binds the service instance:

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

Detailed instructions are provided in the [README](https://github.com/akrishna90/fortune-teller/blob/main/README.adoc) file.

## Migrating from TAS to TAP

### Creating a database instance

TAS
: Create a service instance using `cf create-service`.

TAP
: Multiple options, see [Services Toolkit](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.7/tap/services-toolkit-install-services-toolkit.html) for more information
  Easiest way to get started would be to create a service instance using Bitnami Services. See documentation h[here](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.7/tap/bitnami-services-tutorials-working-with-bitnami-services.html).

### Binding the database instance to the App

TAS
:
  - Include the name of the service instance in the `services` key in the application manifest.
  - Alternatively, use `cf bind-service` to bind the service to the application.

TAP
: If you are using Bitnami Services, Specify the `ClassClaim` resource in the `spec.serviceClaims`
  section of the `Workload`.

## Deploying the fortune-teller application to TAP

Documentation for deploying a service registry and spring config server instances for workloads
[here](https://docs.google.com/document/u/1/d/1nr8Cur9KNm3lRWbUhdOA7WQUYWg2zer9WpNBpyBtEYs/edit) and
[here](https://docs.google.com/document/u/1/d/1toVnWHMRf8BfF_CeYkiJl-hvNZI8bvAfVWeDd-0uYLY/edit).
Alternatively, you can use [tap yamls](https://github.com/akrishna90/fortune-teller/tree/main/tap)
in the fortune-teller repo.
For installation and configuration of various data services on TAP, see documentation
[here](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.7/tap/services-toolkit-about.html).

Following instructions [here](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.7/tap/bitnami-services-tutorials-working-with-bitnami-services.html)
for claiming an instance of MySQL using Bitnami services for deploying fortune-teller application,

1. Claim MySQL service from Bitnami services

    ```console
    tanzu service class-claim create fortune-database --class mysql-unmanaged -n my-apps
    tanzu services class-claims get fortune-database --namespace my-apps
    ```

1. Bind the service to the workload

    Bind the MySQL service by adding `ClassClaim` under `spec.serviceClaims` section.

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

## Using Gradle for building spring applications

By default, when the `bootJar` task is configured, the `jar` task is also configured and it uses
“plain” as the convention for its archive classifier.
This ensures that `bootJar` and `jar` are executed and causes the executable archive and the plain
archive to be built at the same time. More info, see Gradle docs
[here](https://docs.spring.io/spring-boot/docs/2.5.1/gradle-plugin/reference/htmlsingle/#packaging-executable.and-plain-archives)

### Spring-boot buildpack behavior

The [gradle buildpack](https://github.com/paketo-buildpacks/gradle) will produce both `<ARTIFACT_NAME>.jar`
and `<ARTIFACT_NAME>-plain.jar`.
The presence of a second JAR file in the build output means that the gradle buildpack will leave both
JAR files in compressed form instead of unpacking the `<ARTIFACT_NAME>.jar` file into the application directory.
As a result, the [spring-boot buildpack](https://github.com/paketo-buildpacks/spring-boot) will fail
to find a `<APPLICATION_ROOT>/META-INF/MANIFEST.MF` file and will therefore fail to contribute the
spring-cloud-bindings JAR to the application.
The application will be runnable, but service bindings will not be processed.

To avoid this, disabling the ‘jar’ task in your `build.gradle` file should prevent the plain JAR from
being created.

```java
jar {
  enabled = false
}
```

Alternatively you could set `BP_GRADLE_ADDITIONAL_BUILD_ARGUMENTS="-x jar"` to not generate the
plain JAR without modifying the `build.gradle` file.

## Using Maven for building spring applications

- No changes are required, should work AS-IS
- When both Maven and Gradle builds are available (in the case of [greeting repo](https://github.com/spring-cloud-services-samples/greeting)),
  Paketo Java buildpack checks Maven first and it uses it to build the application.

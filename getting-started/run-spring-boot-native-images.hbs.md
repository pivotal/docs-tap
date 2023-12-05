# Run Spring Boot apps on Tanzu Application Platform as GraalVM native images

This topic guides you through how to run Spring Boot applications on Tanzu Application Platform
as native images using GraalVM, including the available options.

## <a id="you-will"></a>What you will do

- Configure your Spring Boot application and `workload.yaml` file to run on Tanzu Application Plaform
  as a native image.
- Configure your app and `workload.yaml` file to enable Application Live View for Spring Boot native
  applications.

## <a id="introduction"></a>Introduction

Running a native image has several advantages:

- **Lower memory footprint:** This translates into lower resource use or increased scalability,
  such as deploying more replicas for the same memory cost.

- **Faster start times:** Component initialization is reduced to milliseconds, which makes pod recovery
  time and horizontal scalability faster.

## <a id="spring-boot-3"></a>Requirements for your Spring Boot application

To compile your Spring Boot applications into native images using GraalVM on Tanzu Application Platform,
they must use Spring Boot 3 and Java 17 as a minimum.
VMware recommends that you use the latest version of Spring Boot 3. To learn more about turning your
Spring Boot applications into GraalVM native images in general, see the
[Spring Boot documentation](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#native-image).

Running Spring Boot applications as native images using GraalVM independent of Tanzu Application Platform
might require some manual work to make your application work correctly when compiled to a native image.
Changes to your application include avoiding the use of patterns such as reflection and implementing
compiler hints.
Therefore, VMware recommends that you make your application ready to run as a native image
from the beginning and run extensive tests before trying to run them as native images on the platform.
To confirm Spring Boot support for native testing, see the
[Spring Boot Documentation](https://docs.spring.io/spring-boot/docs/3.1.2/reference/htmlsingle/#native-image.testing.with-native-build-tools).

If your application can run as native images in general, Tanzu Application Platform allows you
to run your applications as native executable files on the platform as well and tries to make it as
easy as possible to manage your applications over time.

## <a id="how-to"></a> Run your Spring Boot workload as a native image

This section explains how to configure Tanzu Application Platform to compile your Spring Boot
application into a native executable file and how to run that native executable file on the platform.

### <a id="config-appside"></a> Configure the application side

For your application, use the usual process for developing and testing workloads that support
native images.
For general information about native image support, see the [Spring documentation](https://docs.spring.io/spring-boot/docs/current/reference/html/native-image.html).

You must include the GraalVM native plug-in in your Maven POM file or Gradle build file.

- Example for Maven:

    ```starlark
    <build>
      <plugins>
        <plugin>
          <groupId>org.graalvm.buildtools</groupId>
          <artifactId>native-maven-plugin</artifactId>
        </plugin>
        <plugin>
        .
        .
        .
    </build>
    ```

- Example for Gradle:

    ```starlark
    plugins {
      id("org.graalvm.buildtools.native") version "0.9.20"
      .
      .
      .
    }
    ```

### <a id="config-workload"></a> Configure the workload

To enable a native build, configure the buildpack to perform the native compilation step.
You might also need to enable the native profile, mainly for Maven/Spring Boot 3.x projects.
<!-- would you have to do this for anything other than Maven/Spring Boot 3.x projects -- will follow up-->

You configure these settings using the `spec.build` environment parameters in the workload.

The following example works for all use cases. If you are using Gradle, remove the additional Maven
build arguments. This example has the full `spec.build` configuration:

```yaml
spec:
  build:
  env:
  - name: BP_JVM_VERSION
    value: "17"
  - name: BP_NATIVE_IMAGE
    value: "true"
  - name: BP_MAVEN_BUILD_ARGUMENTS
    value: '-Pnative -Dmaven.test.skip=true --no-transfer-progress package -Dspring-boot.aot.jvmArguments=''-Dmanagement.endpoint.health.probes.add-additional-paths=''true''
      -Dmanagement.endpoint.health.show-details=''always'' -Dmanagement.endpoints.web.base-path=''/actuator''
      -Dmanagement.endpoints.web.exposure.include=''*'' -Dmanagement.health.probes.enabled=''true''
      -Dmanagement.server.port=8081 -Dserver.port=8080'' '
```

Because native images implement a closed world philosophy, you cannot set configuration at runtime
deterministically. As a consequence, the Spring Boot Convention cannot automatically set options for
native images to optimize running the application on the platform.
However, the `tanzu-java-web-app` Tanzu Application Platform accelerator provides an example that you
can refer to.

The most important elements from the configuration are `BP_JVM_VERSION`, `BP_NATIVE_IMAGE` and `BP_MAVEN_BUILD_ARGUMENTS`.
They provide the instructions for buildpacks to `init` the native compilation.
Without these, a normal Java virtual machine (JVM) compilation to generate a regular JAR file occurs.

The `BP_JVM_VERSION` configures buildpacks to use a JDK 17, because Spring Boot 3.x requires
a JDK 17 as a minimum.

> **Note** Values used at build time do not specify the values that will be used at runtime.
> If you provide build time instrumentation, it only enables configuration to be set at runtime.
> You must provide runtime values separately.

Depending on the app type, such as web, server, or worker, different methods for monitoring the
health of the application are employed that might require configuring certain runtime parameters.
For applications that do not need automatically configured actuators, you can generically achieve
this using the following `build.spec` environment parameters:

```yaml
 - name: MANAGEMENT_ENDPOINT_HEALTH_PROBES_ADD_ADDITIONAL_PATHS
         value: "true"
       - name: MANAGEMENT_HEALTH_PROBES_ENABLED
         value: "true"
       - name: SERVER_PORT
         value: "8080"
```

To set the actual runtime values, you can use the preceding settings in the `spec.env` parameters
in the workload.

#### <a id="example-workload-ni"></a> Example workload enabling native images

The following is an example of a full `workload.yaml` file that enables native image support:

```yaml
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
 name: myworkload
 labels:
   apps.tanzu.vmware.com/workload-type: web
   apps.tanzu.vmware.com/has-tests: "true"
   app.kubernetes.io/part-of: myworkload
spec:
 build:
   env:
   - name: BP_JVM_VERSION
     value: "17"
   - name: BP_NATIVE_IMAGE
     value: "true"
   - name: BP_MAVEN_ADDITIONAL_BUILD_ARGUMENTS
     value: -Pnative
   - name: MANAGEMENT_HEALTH_PROBES_ENABLED
     value: "true"
   - name: MANAGEMENT_ENDPOINT_HEALTH_PROBES_ADD_ADDITIONAL_PATHS
     value: "true"
   - name: SERVER_PORT
     value: "8080"
 env:
 - name: MANAGEMENT_HEALTH_PROBES_ENABLED
   value: "true"
 - name: MANAGEMENT_ENDPOINT_HEALTH_PROBES_ADD_ADDITIONAL_PATHS
   value: "true"
 - name: MANAGEMENT_ENDPOINT_HEALTH_SHOW_DETAILS
   value: always
 - name: SERVER_PORT
   value: "8080"
 source:
   git:
     url: https://github.com/myorg/myworkload
     ref:
       branch: main
```

### <a id="spring-boot-convention"></a> What about the Spring Boot Convention?

When Spring Boot Convention detects a Spring Boot application, it automatically configures the
workload for the platform, such as configuring the server port.
The Spring Boot Convention does this by setting the `JAVA_TOOL_OPTIONS` environment variable and
including various system property settings.

Because the setting `JAVA_TOOL_OPTIONS` doesn't work for native compiled Spring Boot applications,
many of the configurations that the Spring Boot Convention applies don’t have any effect.
This is why you must configure this manually using separate environment variables as described earlier.
<!-- where earlier? get link -- to follow up -->

The goal for future versions of the Spring Boot Convention is to have it automatically do much of
the current manual work.

## <a id="using-alv"></a> Using Application Live View with Spring Boot native images

The Application Live View component of Tanzu Application Platform is designed around the
Spring Boot Actuator extension for Spring Boot and therefore also works for Spring Boot apps that are
compiled to native executable files.

However, due to current limits to automation, to enable Application Live View for your application
you must configure specific options when building and running your Spring Boot apps as native images
on Tanzu Application Platform.

### <a id="app-side-alv"></a> Configure the application side

Application Live View relies on information obtained from the actuator endpoints of an application
and therefore requires the actuator library to be present.

Configure your application to include the actuator library:

- Example for Maven:

    ```starlark
    <dependencies>
      <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-actuator</artifactId>
      </dependency>
      .
      .
      .
    <dependencies>
    ```

- Example for Gradle:

    ```starlark
    dependencies {
      implementation("org.springframework.boot:spring-boot-starter-actuator")
      .
      .
      .
    }
    ```

### <a id="workload-alv"></a> Configure the workload

For an application to integrate with Application Live View:

1. The application must declare the integration by either:

    - In the `workload.yaml` file, set the `apps.tanzu.vmware.com/auto-configure-actuators` label.
      For more information, see [Workload-level configuration](../spring-boot-conventions/configuring-spring-boot-actuators.hbs.md#workload-config).

    - In the `tap-values.yaml` file, enable platform level configuration for actuator automatic
      configuration in the Spring Boot convention. For more information, see
      [Platform-level configuration](../spring-boot-conventions/configuring-spring-boot-actuators.hbs.md#platform-config).

1. Configure additional runtime properties for Application Live View, which requires additional
   AOT (ahead-of-time) instrumentation at build time.

   Similar to general native image workloads, supply additional AOT configuration in the
   `workload.yaml` using `spec.build` environment parameters.
   Application Live View requires the following build environment parameters:

    ```yaml
      - name: MANAGEMENT_HEALTH_PROBES_ENABLED
        value: "true"
      - name: MANAGEMENT_ENDPOINT_HEALTH_PROBES_ADD_ADDITIONAL_PATHS
        value: "true"
      - name: MANAGEMENT_ENDPOINT_HEALTH_SHOW_DETAILS
        value: always
      - name: MANAGEMENT_ENDPOINTS_WEB_BASE_PATH
        value: /actuator
      - name: MANAGEMENT_ENDPOINTS_WEB_EXPOSURE_INCLUDE
        value: '*'
      - name: MANAGEMENT_SERVER_PORT
        value: "8081"
      - name: SERVER_PORT
        value: "8080"
    ```

    Also similar to general native image workloads, runtime configuration is also provided through the
    use of environment variables.

#### <a id="example-workload-alv"></a> Example workload enabling Application Live View

The following is an example of a full `workload.yaml` file that enables both native image compilation
and integration with Application Live View:

```yaml
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
 name: myworkload
 labels:
   apps.tanzu.vmware.com/workload-type: web
   apps.tanzu.vmware.com/has-tests: "true"
   app.kubernetes.io/part-of: myworkload
   apps.tanzu.vmware.com/auto-configure-actuators: "true"
spec:
 build:
   env:
   - name: BP_JVM_VERSION
     value: "17"
   - name: BP_NATIVE_IMAGE
     value: "true"
   - name: BP_MAVEN_ADDITIONAL_BUILD_ARGUMENTS
     value: -Pnative
   - name: MANAGEMENT_HEALTH_PROBES_ENABLED
     value: "true"
   - name: MANAGEMENT_ENDPOINT_HEALTH_PROBES_ADD_ADDITIONAL_PATHS
     value: "true"
   - name: MANAGEMENT_ENDPOINT_HEALTH_SHOW_DETAILS
     value: always
   - name: MANAGEMENT_ENDPOINTS_WEB_BASE_PATH
     value: /actuator
   - name: MANAGEMENT_ENDPOINTS_WEB_EXPOSURE_INCLUDE
     value: '*'
   - name: MANAGEMENT_SERVER_PORT
     value: "8081"
   - name: SERVER_PORT
     value: "8080"
 env:
 - name: MANAGEMENT_HEALTH_PROBES_ENABLED
   value: "true"
 - name: MANAGEMENT_ENDPOINT_HEALTH_PROBES_ADD_ADDITIONAL_PATHS
   value: "true"
 - name: MANAGEMENT_ENDPOINT_HEALTH_SHOW_DETAILS
   value: always
 - name: MANAGEMENT_ENDPOINTS_WEB_BASE_PATH
   value: /actuator
 - name: MANAGEMENT_ENDPOINTS_WEB_EXPOSURE_INCLUDE
   value: '*'
 - name: MANAGEMENT_SERVER_PORT
   value: "8081"
 - name: SERVER_PORT
   value: "8080"
 source:
   git:
     url: https://github.com/myorg/myworkload
     ref:
       branch: main
```

Usually, this configuration is automatically applied by the Spring Boot Convention when it detects a
Spring Boot application. In the case of a natively compiled Spring Boot application, this configuration
has to be done manually.

The Application Live View specific part of the Spring Boot Convention automatically flags the workload
with a specific label to enable the Application Live View feature for the workload.

### <a id="register-in-ui"></a> Register the app in the UI

The previous steps help Application Live View to detect your app, but it still won’t show in the UI
until you register the app.

To register the app in the UI, you must:

1. Navigate to **Tanzu Developer Portal**.

1. Click **REGISTER ENTITY**.

1. Follow the instructions onscreen.

For further instructions, see [Deploy an app on Tanzu Application Platform](deploy-first-app.hbs.md).

> **Important** Not all the usual information will be available. For example, JVM memory information
> won’t be available because native images have a slightly different mode, and there are other elements
> that won't be available in the actuator endpoints.

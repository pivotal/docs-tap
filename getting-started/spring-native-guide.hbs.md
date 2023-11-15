# Run Spring Boot apps on Tanzu Application Platform as GraalVM native images

This topic guides you through configuring Tanzu Application Platform to compile your Spring Boot
application into a native executable, running that native executable on the platform, and
enabling Application Live View for your application.
<!-- get reviewed -->

## <a id="you-will"></a>What you will do

- Configure your Spring Boot application and `workload.yaml` file to run on Tanzu Application Plaform
  as a native image.
- Configure your app and `workload.yaml` file to enable Application Live View.
<!-- get reviewed -->

## <a id="introduction"></a>Introduction

You are running Spring Boot applications on Tanzu Application Platform and you want to run them as
native images using GraalVM? This documentation guides you through how to do this, including the
available options.

Running a native image has several advantages:

- **Lower memory footprint:** This translates into lower resource use or increased scalability,
  such as deploying more replicas for the same memory cost.

- **Faster start times:** Component initialization is reduced to milliseconds, which makes pod recovery
  time and horizontal scalability faster.

## <a id="spring-boot-3"></a>Spring Boot 3

To compile your Spring Boot applications into native images using GraalVM on Tanzu Application Platform,
they have to use Spring Boot 3 and Java 17 as a minimum.
VMware recommends that you use the latest version of Spring Boot 3. To learn more about turning your
Spring Boot applications into GraalVM native images in general, see the
[Spring Boot documentation](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#native-image).

Running Spring Boot applications as native images using GraalVM independent of Tanzu Application Platform
might require some manual work to make your application work correctly when compiled to a native image.
Changes go from avoiding use of patterns like Reflection to implementing compiler Hints.
Therefore, VMware recommends that you make your application ready to run as a native image
from the beginning and run extensive tests before trying to run them as native images on the platform.
To confirm Spring Boot support for native testing, see the
[Spring Boot Documentation](https://docs.spring.io/spring-boot/docs/3.1.2/reference/htmlsingle/#native-image.testing.with-native-build-tools).

If your application can run as native images in general, Tanzu Application Platform allows you
to run your applications as native executables on the platform as well and will try to make it as
easy as possible over time. <!-- make what as easy as possible? -->
But the platform is not a migration tool that enables your Spring Boot application itself to be ready
for the GraalVM native image technology.

## <a id="how-to"></a> Run your Spring Boot workload as a native image

This section explains how to configure Tanzu Application Platform to compile your Spring Boot
application into a native executable and how to run that native executable on the platform.

### <a id="config-appside"></a> Configure the application side

You can use the usual process for developing and testing workloads that support native images for
your application.

For general information about native image support, see the [Spring documentation](https://docs.spring.io/spring-boot/docs/current/reference/html/native-image.html).

Take note of the inclusion of the GraalVM native plug-in in your Maven POM or Gradle build file.
<!-- are you supposed to include this in your build file or do you just need to record something
that's already there -->

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
Additionally, the native profile might also need to be enabled (mainly for Maven/Spring Boot 3.x projects).
<!-- would you have to do this for anything other than Maven/Spring Boot 3.x projects -->

These settings are configured using the workload’s `spec.build` environment parameters.
The following example works for all use cases.
Remove the additional Maven build arguments if you are using Gradle.

The following is the full `spec.build` configuration:

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
deterministically. As a consequence, options for running the application in an optimal way on the
platform cannot be set automatically by the Spring Boot Convention anymore for native images.
However, the `tanzu-java-web-app` Tanzu Application Platform accelerator provides a good updated reference.

The most important elements from the configuration are BP_JVM_VERSION, BP_NATIVE_IMAGE and BP_MAVEN_BUILD_ARGUMENTS.
They provide the instructions for buildpacks to init the native compilation.
Without these, a normal JVM compilation to generate a regular JAR will occur.

The BP_JVM_VERSION is used to configure buildpacks to use a JDK 17, because Spring Boot 3.x requires
a JDK 17 as a minimum.

>**Note** Values used at build time do not specify the values that will be used at runtime.
>If you provide build time instrumentation, it only **enables** configuration to be set at runtime.
>Runtime values still need to be provided separately.

Depending on the app type (web, server, worker, etc), different methods for monitoring the health of
the application are employed which might require configuring certain runtime parameters.
For applications that do not need auto configured actuators, this can be
generically achieved using the following build.spec environment parameters:

```yaml
 - name: MANAGEMENT_ENDPOINT_HEALTH_PROBES_ADD_ADDITIONAL_PATHS
         value: "true"
       - name: MANAGEMENT_HEALTH_PROBES_ENABLED
         value: "true"
       - name: SERVER_PORT
         value: "8080"
```

To set the actual runtime values, the same setting above can be used in the workload’s `spec.env` parameters.

The following is an example of a full `workload.yaml` file enabling native image support.

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

Because this setting `JAVA_TOOL_OPTIONS` no longer works for native compiled Spring Boot applications,
many of the configurations that the Spring Boot Convention applies don’t have any effect.
This is why you must configure this manually using separate environment variables as described earlier.

The goal for future versions of the Spring Boot Convention is to improve this and turn many of the manual<!--฿ In preface information, if the document is delivered as a PDF file, replace with |book| or |guide|. ฿--> work that you have to do at the moment<!--฿ 1st preference: delete. 2nd preference: replace these words with |currently|. ฿--> into something the Spring Boot Convention will<!--฿ Avoid |will|: present tense is preferred. ฿--> do automatically for you.

## <a id="using-alv"></a> Using Application Live View with Spring Boot native images

The Application Live View component of Tanzu Application Platform is designed around the
Spring Boot Actuator extension for Spring Boot and therefore also works for Spring Boot apps that are
compiled to native executables.

However, due to current limits to automation, when building and running native images on
Tanzu Application Platform, you must configure specific options when building and running your
Spring Boot apps as native images to enable Application Live View.

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

    - the `apps.tanzu.vmware.com/auto-configure-actuators` [label](../spring-boot-conventions/configuring-spring-boot-actuators.hbs.md)
    in the `workload.yaml` file.

    - enable the [platform level configuration](../spring-boot-conventions/configuring-spring-boot-actuators.hbs.md)
    for actuator automatic configuration in the Spring Boot convention.
     <!-- clarify -- is this set the actuator auto config to true? -->

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

The following is an example of a full `workload.yaml` file that enabled both native image compilation
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

The previous steps help App Live View to detect your app, but it still won’t show in the UI.

To register the app in the UI, you must:

1. Navigate to **Tanzu Developer Portal**.

1. Click **REGISTER ENTITY**.

1. Follow the instructions onscreen.

For further instructions, see [Deploy an app on Tanzu Application Platform](deploy-first-app.hbs.md).

An important note is that not all the usual information will<!--฿ Avoid |will|: present tense is preferred. ฿--> be available. For example, JVM memory information won’t be since<!--฿ Do not use |since| where you can use |because|. ฿--> native images have a slightly different mode, so are other elements that are not available in the actuator endpoints yet.

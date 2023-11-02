# How to run Spring Boot applications on TAP as GraalVM native images

## <a id="introduction"></a>Introduction

You are running Spring Boot applications on TAP and you would like to run them as native images using GraalVM? This documentation walks you through everything you need to know for this, including options that you have and choices you can make along the way.
Running a native image have several advantages:
-  Lower memory footprint: this translates into lower resource utilization or simple higher scalability (deploy more replicas for the same memory cost)
-  Faster start times: component initialization is reduced to milliseconds making pods recovery time as well as horizontal scalability faster.

## <a id="spring-boot-3"></a>Spring Boot 3

In order to compile your Spring Boot applications into native images using GraalVM on TAP, they have to use Spring Boot 3 and Java 17 as a minimum. We recommend using the latest version of Spring Boot 3. In order to learn more about turning your Spring Boot applications into GraalVM native images in general, please take a look at the [Spring Boot documentation](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#native-image)

Running Spring Boot applications as native images using GraalVM - independent of TAP might require some manual work in order to make your application work correctly when compiled to a native image. Changes go from avoiding use of patterns like Reflection to implementing compiler Hints.
Therefore, we strongly recommend that you make your application ready to run as a native image from the beginning and run extensive tests before trying to run them as native images on the platform. Check the Spring Boot support for [native testing](https://docs.spring.io/spring-boot/docs/3.1.2/reference/htmlsingle/#native-image.testing.with-native-build-tools)

In case your application runs fine as native images in general, the Tanzu Application Platform will allow you to run your applications as native executables on the platform as well - and will try to make it as easy as possible over time. But the platform is not a migration tool that enables your Spring Boot application itself to be ready for the GraalVM native image technology.

## <a id="how-to"></a> How to run your Spring Boot workload as a native image

This section will guide you through all the various steps that you need to do in order to configure the Tanzu Application Platform to compile your Spring Boot application into a native executable and how to run that native executable on the platform.

### <a id="what-to-do-on-appside"></a>What you need to do on the application side

Applications should not need to deviate from the normal process of developing and testing workloads that support native images. General information for native image support can be found in the [Spring docs](https://docs.spring.io/spring-boot/docs/current/reference/html/native-image.html). Take note of the inclusion of the GrallVM native plugin in your Maven pom or Gradle build file. 

Example for Maven:

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
Example for Gradle:

```starlark
plugins {
   id("org.graalvm.buildtools.native") version "0.9.20"
   .
   .
   .
}
```
### <a id="how-to-configure-workload.yaml"></a> How to configure the workload.yml
To enable a native build, the build pack must be configured to perform the native compilation step. Additionally, the native profile may also need to be enabled (mainly for maven/Spring Boot 3.x projects).

These settings are configured using the workload’s spec.build environment parameters. The following example will generically work for all use cases; the additional maven build arguments can be removed if you are using Gradle.
Here is the full ‘spec.build’ configuration, we’ll discuss the details below:
```starlark
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
Because native images implement a “closed world” philosophy, setting configuration at runtime can not be done deterministically. As a consequence, options for running the application in an optimal way on the platform cannot be set automatically by the Spring Boot Convention anymore for native images. However, the ‘tanzu-java-web-app’ TAP accelerator provides a good updated reference.

The most important elements from the configuration are BP_JVM_VERSION, BP_NATIVE_IMAGE and BP_MAVEN_BUILD_ARGUMENTS: they provide the instructions for Buildpacks to init the native compilation. Without these a normal JVM compilation to generate a regular jar will occur.

The BP_JVM_VERSION is used here to let the Buildpacks use a JDK 17, since Spring Boot 3.x requires a JDK 17 as a minimum. Once Buildpacks use JDK 17 as the default JDK level, this setting will not be necessary anymore.

<b>NOTE:</b> Values used at build time do not specify the values that will be used at runtime; providing build time instrumentation only <b>enables</b> configuration to be set at runtime. Runtime values still need to be provided separately.

Depending on the app type (web, server, worker, etc), different methods for monitoring the application’s health are employed which may require configuring certain runtime parameters.  For applications that do not need auto configured actuators, this can be generically achieved using the following build.spec env parameters:

```starlark
 - name: MANAGEMENT_ENDPOINT_HEALTH_PROBES_ADD_ADDITIONAL_PATHS
         value: "true"
       - name: MANAGEMENT_HEALTH_PROBES_ENABLED
         value: "true"
       - name: SERVER_PORT
         value: "8080" 
```
To set the actual runtime values, the same setting above can be used in the workload’s spec.env parameters.

The following is an example of a full workload.yaml enabling native image support.
```starlark
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
### <a id="what-about-spring-convention"></a> What about the Spring Boot Convention?

Usually the Spring Boot Convention takes care of automatically configuring a workload for the platform when it detects a Spring Boot application, like configuring the server port, etc. The Spring Boot Convention does this by setting the JAVA_TOOL_OPTIONS environment variable and including various system property settings.

Since this mechanism (setting JAVA_TOOL_OPTIONS) doesn’t work anymore for native compiled Spring Boot applications, many of the configurations that the Spring Boot Convention applies don’t have any effect anymore. This is also a reason why you have to configure this manually via separate environment variables, as described above.

The goal for future versions of the Spring Boot Convention is to improve this and turn many of the manual work that you have to do at the moment into something the Spring Boot Convention will do automatically for you.

## <a id="using-alv"></a> Using Application Live View with Spring Boot native images

The Application Live View functionality inside of TAP is designed around the Spring Boot Actuator extension for Spring Boot and therefore also works for Spring Boot apps that are compiled to native executables.

However, due to the limited automation that is in place at the moment when building and running native images on TAP, you have to configure specific options when building and running your Spring Boot apps as native images in case you would like to enable the Application Live View feature for it.

### <a id="app-side-alv"></a> What you need to do on the application side

Application Live View relies heavily on information obtained from an application’s actuator endpoints and therefore requires the actuator library to be present. You will need to ensure that your application is configured to include the actuator library.  

Examples:

<b>Maven</b>
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
<b>Gradle</b>
```starlark
dependencies {
   implementation("org.springframework.boot:spring-boot-starter-actuator")
   .
   .
   .
}
```
### <a id="workload.yaml-alv"></a> How to configure the workload.yml

If an application wishes to integrate with Application Live View, it needs to express its intention either through the apps.tanzu.vmware.com/auto-configure-actuators [label](../spring-boot-conventions/configuring-spring-boot-actuators.hbs.md) in the workload.yaml or enable the [platform level configuration](../spring-boot-conventions/configuring-spring-boot-actuators.hbs.md) for actuator auto configuration in the Spring Boot convention.

Application Live View needs additional runtime properties to be configured which requires additional AOT instrumentation at build time. Similar to general native image workloads, additional AOT configuration is supplied in the workload.yaml using spec.build environment parameters.  Application Live View requires the following build environment parameters:
```starlark
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
Also similar to general native image workloads, runtime configuration is also provided through the use of environment variables.

The following is an example of a full workload.yaml that enabled both native image compilation and integration with Application Live View:
```starlark
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
Usually, this configuration is automatically applied by the Spring Boot Convention when it detects a Spring Boot application. In the case of a natively compiled Spring Boot application, this configuration has to be done manually.

The part that the Application Live View specific part of the Spring Boot Convention is doing here automatically is to flag the workload with a specific label, so that the Application Live View feature is enabled for it.

### <a id="register-in-ui"></a> How to register the app in the UI

The previous steps help making App Live View be aware of your app, but it still won’t show in the UI. In short:
- Navigate to <b>Tanzu Developer Portal</b>.
- Select <b>REGISTER ENTITY</b>.
- Follow the instructions on screen.

If you need further instructions, see the full details in the [documentation](deploy-first-app.hbs.md).

An important note is that not all the usual information will be available. For example, JVM memory information won’t be since native images have a slightly different mode, so are other elements that are not available in the actuator endpoints yet.

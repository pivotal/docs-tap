# Run Spring Boot apps on Tanzu Application Platform as GraalVM native images

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
to run your applications as native executable<!--฿ Do not use as a noun. Use |executable file| instead. ฿-->s on the platform as well - and will<!--฿ Avoid |will|: present tense is preferred. ฿--> try to make it as easy<!--฿ Avoid when describing an instruction. ฿--> as possible over time. But the platform is not a migration tool that enables your Spring Boot application itself to be ready for the GraalVM native image technology.

## <a id="how-to"></a> How to run your Spring Boot workload as a native image

This section will<!--฿ Avoid |will|: present tense is preferred. ฿--> guide you through all the various steps that you need to<!--฿ |must| is preferred or, better, rephrase as an imperative. ฿--> do in order to<!--฿ |to| is preferred. ฿--> configure the Tanzu Application Platform to compile your Spring Boot application into a native executable<!--฿ Do not use as a noun. Use |executable file| instead. ฿--> and how to run that native executable<!--฿ Do not use as a noun. Use |executable file| instead. ฿--> on the platform.

### <a id="config-appside"></a> Configure the application side

Applications should<!--฿ Favour certainty, agency, and imperatives: |the app now works| over |the app should now work|. |VMware recommends| over |you should|. If an imperative, |do this| over |you should do this|. If |should| is unavoidable, it must be paired with information on the exceptions that |should| implies exist. ฿--> not need to<!--฿ |must| is preferred or, better, rephrase as an imperative. ฿--> deviate from the normal process<!--฿ Avoid nominalization: |while deleting| is better than |during the deletion process|. ฿--> of developing and testing workloads that support native images. General information for native image support can be<!--฿ Consider switching to active voice. ฿--> found in the [Spring docs](https://docs.spring.io/spring-boot/docs/current/reference/html/native-image.html). Take note of the inclusion of the GrallVM native plugin<!--฿ |plug-in| is the noun or adjective. |plug in| is the verb. ฿--> in your Maven pom<!--฿ |POM| is all caps if it is the initialism for Project Object Model. ฿--> or Gradle build file.

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

To enable a native build, the build pack must be configured to perform the native compilation step. Additionally, the native profile may<!--฿ |can| usually works better. Use |might| to convey possibility. ฿--> also need to<!--฿ |must| is preferred or, better, rephrase as an imperative. ฿--> be enabled (mainly for maven/Spring Boot 3.x projects).

These settings are configured using the workload’s spec<!--฿ |specifications| is preferred. ฿-->.build environment parameters. The following example will<!--฿ Avoid |will|: present tense is preferred. ฿--> generically work for all use cases;<!--฿ Two sentences are preferred over a compound sentence that uses a semi-colon. ฿--> the additional maven<!--฿ |Maven| is capitalized if referring to Apache Maven. ฿--> build arguments can be<!--฿ Consider switching to active voice. ฿--> removed if you are using Gradle.
Here is the full ‘spec<!--฿ |specifications| is preferred. ฿-->.build’ configuration, we<!--฿ |VMware|, the product name, or another term is preferred. Define who |we| is for the reader is preferred. ฿-->’ll discuss the details below<!--฿ If referring to a page location, use |following| or |later| or, better, just use an anchor. If referring to product versions, use |earlier|. ฿-->:

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
<!--฿ Verify that no placeholders above require explanation in the style of |Where PLACEHOLDER is...| ฿-->
Because native<!--฿ If this is a compound adjective then it is missing a hyphen. ฿--> images implement a “closed world” philosophy, setting configuration at runtime can not be done deterministically. As a consequence, options for running the application in an optimal way on the platform cannot be set automatically by the Spring Boot Convention anymore for native images. However, the ‘tanzu<!--฿ The brand is |Tanzu|. ฿-->-java<!--฿ |Java| is preferred. ฿-->-web-app’ Tanzu Application Platform accelerator provides a good updated reference.

The most important elements from the configuration are BP_JVM_VERSION, BP_NATIVE_IMAGE and BP_MAVEN_BUILD_ARGUMENTS: they provide the instructions for Buildpacks to init the native compilation. Without these a normal JVM compilation to generate a regular jar<!--฿ |JAR| is preferred. ฿--> will<!--฿ Avoid |will|: present tense is preferred. ฿--> occur.

The BP_JVM_VERSION is used here to let<!--฿ Do not use to describe features that a product makes possible. Use |you can| instead. ฿--> the Buildpacks use a JDK 17, since<!--฿ Do not use |since| where you can use |because|. ฿--> Spring Boot 3.x requires a JDK 17 as a minimum. Once<!--฿ Only use |once| when you mean |one time|, not when you mean |after|. ฿--> Buildpacks use JDK 17 as the default JDK level, this setting will<!--฿ Avoid |will|: present tense is preferred. ฿--> not be necessary anymore.

<b>NOTE:</b> Values used at build time do not specify the values that will<!--฿ Avoid |will|: present tense is preferred. ฿--> be used at runtime;<!--฿ Two sentences are preferred over a compound sentence that uses a semi-colon. ฿--> providing build time instrumentation only <b>enables</b> configuration to be set at runtime. Runtime values still need to<!--฿ |must| is preferred or, better, rephrase as an imperative. ฿--> be provided separately.

Depending on the app type (web, server, worker, etc), different methods for monitoring the application’s health are employed which may<!--฿ |can| usually works better. Use |might| to convey possibility. ฿--> require configuring certain runtime parameters.  For applications that do not need auto configured actuators, this can be<!--฿ Consider switching to active voice. ฿--> generically achieved using the following build.spec<!--฿ |specifications| is preferred. ฿--> env<!--฿ |environment| is preferred ฿--> parameters:

```starlark
 - name: MANAGEMENT_ENDPOINT_HEALTH_PROBES_ADD_ADDITIONAL_PATHS
         value: "true"
       - name: MANAGEMENT_HEALTH_PROBES_ENABLED
         value: "true"
       - name: SERVER_PORT
         value: "8080"
```
<!--฿ Verify that no placeholders above require explanation in the style of |Where PLACEHOLDER is...| ฿-->
To set the actual runtime values, the same setting above<!--฿ If referring to a page location, use |earlier| or, better, just use an anchor. If referring to product versions, use |later|. ฿--> can be<!--฿ Consider switching to active voice. ฿--> used in the workload’s spec<!--฿ |specifications| is preferred. ฿-->.env<!--฿ |environment| is preferred ฿--> parameters.

The following is an example of a full `workload.yaml` file enabling native image support.

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
<!--฿ Verify that no placeholders above require explanation in the style of |Where PLACEHOLDER is...| ฿-->
### <a id="spring-boot-convention"></a> What about the Spring Boot Convention?

Usually the Spring Boot Convention takes care of automatically configuring a workload for the platform when it detects a Spring Boot application, like configuring the server port, etc.<!--฿ |and so on| is preferred. ฿--> The Spring Boot Convention does this by setting the JAVA_TOOL_OPTIONS environment variable and including various system property settings.

Since<!--฿ Do not use |Since| where you can use |Because|. ฿--> this mechanism (setting JAVA_TOOL_OPTIONS) doesn’t work anymore for native compiled Spring Boot applications, many of the configurations that the Spring Boot Convention applies don’t have any effect anymore. This is also a reason why you have to configure this manually via<!--฿ |through|, |using| and |by means of| are preferred. ฿--> separate environment variables, as described above<!--฿ If referring to a page location, use |earlier| or, better, just use an anchor. If referring to product versions, use |later|. ฿-->.

The goal for future versions of the Spring Boot Convention is to improve this and turn many of the manual<!--฿ In preface information, if the document is delivered as a PDF file, replace with |book| or |guide|. ฿--> work that you have to do at the moment<!--฿ 1st preference: delete. 2nd preference: replace these words with |currently|. ฿--> into something the Spring Boot Convention will<!--฿ Avoid |will|: present tense is preferred. ฿--> do automatically for you.

## <a id="using-alv"></a> Using Application Live View with Spring Boot native<!--฿ If this is a compound adjective then it is missing a hyphen. ฿--> images

The Application Live View functionality<!--฿ |function|, |features|, or |capability| is preferred. ฿--> inside of Tanzu Application Platform is designed around the Spring Boot Actuator extension for Spring Boot and therefore also works for Spring Boot apps that are compiled to native executable<!--฿ Do not use as a noun. Use |executable file| instead. ฿-->s.

However, due to the limited automation that is in place at the moment<!--฿ 1st preference: delete. 2nd preference: replace these words with |currently|. ฿--> when building and running native images on Tanzu Application Platform, you have to configure specific options when building and running your Spring Boot apps as native images in case you would<!--฿ Re-phrase for present tense if possible. ฿--> like to enable the Application Live View feature for it.

### <a id="app-side-alv"></a> Configure the application side

Application Live View relies heavily on information obtained from an application’s actuator endpoints and therefore requires the actuator library to be present. You will<!--฿ Avoid |will|: present tense is preferred. ฿--> need to<!--฿ |must| is preferred or, better, rephrase as an imperative. ฿--> ensure that your application is configured to include the actuator library.

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

If an application needs to<!--฿ |must| is preferred or, better, rephrase as an imperative. ฿--> integrate with Application Live View, it must declare this either through
the `apps.tanzu.vmware.com/auto-configure-actuators` [label](../spring-boot-conventions/configuring-spring-boot-actuators.hbs.md) in the workload.yaml or enable the [platform level configuration](../spring-boot-conventions/configuring-spring-boot-actuators.hbs.md) for actuator auto configuration in the Spring Boot convention.

Application Live View needs additional runtime properties to be configured which requires additional AOT instrumentation at build time. Similar to general native image workloads, additional AOT configuration is supplied in the workload.yaml using spec<!--฿ |specifications| is preferred. ฿-->.build environment parameters.  Application Live View requires the following build environment parameters:

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
<!--฿ Verify that no placeholders above require explanation in the style of |Where PLACEHOLDER is...| ฿-->
Also similar to general native image workloads, runtime configuration is also provided through the use of environment variables.

The following is an example of a full `workload.yaml` file that enabled both native image compilation
and integration with Application Live View:

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
<!--฿ Verify that no placeholders above require explanation in the style of |Where PLACEHOLDER is...| ฿-->
Usually, this configuration is automatically applied by the Spring Boot Convention when it detects a Spring Boot application. In the case of a natively compiled Spring Boot application, this configuration has to be done manually.

The part that the Application Live View specific part of the Spring Boot Convention is doing here automatically is to flag the workload with a specific label, so that the Application Live View feature is enabled for it.

### <a id="register-in-ui"></a> Register the app in the UI

The previous steps help App Live View to detect your app, but it still won’t show in the UI.

To register the app in the UI, you must:

1. Navigate to **Tanzu Developer Portal**.

1. Click **REGISTER ENTITY**.

1. Follow the instructions onscreen.

For further instructions, see [Deploy an app on Tanzu Application Platform](deploy-first-app.hbs.md).

An important note is that not all the usual information will<!--฿ Avoid |will|: present tense is preferred. ฿--> be available. For example, JVM memory information won’t be since<!--฿ Do not use |since| where you can use |because|. ฿--> native images have a slightly different mode, so are other elements that are not available in the actuator endpoints yet.

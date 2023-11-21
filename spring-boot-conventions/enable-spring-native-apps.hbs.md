# Enable Spring Native apps for Application Live View

This topic describes how you can run Spring Native workloads within Tanzu Application Platform
(commonly known as TAP).

This topic tells you about how the Spring Boot convention server enhances Tanzu `PodIntents` with
metadata, such as labels, annotations, or properties required to run native workloads in
Tanzu Application Platform.

This metadata allows Application Live View to discover and register the app instances so that
Application Live View can access the actuator data from those workloads.

## <a id="native-app-config"></a> Configure a Spring Native application

To make Application Live View interact with a Spring Native app within Tanzu Application Platform:

1. Add the `spring-boot-starter-actuator` module dependency for Maven in `pom.xml` as follows:

   ```xml
   <dependency>
     <groupId>org.springframework.boot</groupId>
     <artifactId>spring-boot-starter-actuator</artifactId>
   </dependency>
   ```

1. Add a native profile that includes the `native-maven-plugin` for the build phase in `pom.xml`, as
   follows:

   ```xml
   <profiles>
     <profile>
         <id>native</id>
         <build>
           <plugins>
               <plugin>
                 <groupId>org.graalvm.buildtools</groupId>
                   <artifactId>native-maven-plugin</artifactId>
                 </plugin>
             </plugins>
         </build>
     </profile>
   </profiles>
   ```

   > **Important** For Maven-based projects, you must add the `org.graalvm.buildtools` build plug-in
   > and configure it to run when the native profile is active.

1. Add the following configuration in `pom.xml` to generate `build-info.properties` in your
   Spring Boot application. Application Live View uses this information to display the Spring Boot
   version that the app uses.

   ```xml
   <plugin>
   <groupId>org.springframework.boot</groupId>
   <artifactId>spring-boot-maven-plugin</artifactId>
   <executions>
     <execution>
       <goals>
         <goal>build-info</goal>
       </goals>
       <configuration>
         <additionalProperties>
           <spring.boot.version>${project.parent.version}</spring.boot.version>
         </additionalProperties>
       </configuration>
     </execution>
   </executions>
   </plugin>
   ```

## <a id="run-native-workload"></a> Run a native workload

To run a native workload:

1. Create a workload for the Spring Native application. For example:

   ```console
   tanzu apps workload create spring-cloud-serverless \
   --git-repo https://github.com/vudayani-vmw/spring-cloud-serverless --git-branch main \
   --type web --label apps.tanzu.vmware.com/auto-configure-actuators=true \
   --label app.kubernetes.io/part-of=spring-cloud-serverless --yes \
   --annotation autoscaling.knative.dev/min-scale=1 \
   --build-env "BP_JVM_VERSION=17" --build-env "BP_NATIVE_IMAGE=true" \
   --build-env "BP_MAVEN_BUILD_ARGUMENTS= -Pnative -Dmaven.test.skip=true \
   --no-transfer-progress package \
   -Dspring-boot.aot.jvmArguments='-Dmanagement.endpoint.health.probes.add-additional-paths='true' \
   -Dmanagement.endpoint.health.show-details='always' \
   -Dmanagement.endpoints.web.base-path='/actuator' \
   -Dmanagement.endpoints.web.exposure.include='*' \
   -Dmanagement.health.probes.enabled='true' \
   -Dmanagement.server.port=8081 -Dserver.port=8080' "
   ```

   Where:

   - The required build arguments, such as `BP_JVM_VERSION`, `BP_NATIVE_IMAGE`, and
     `BP_MAVEN_BUILD_ARGUMENTS`, are configured to build a native executable file as shown in the
     example. The build environment variables are required to enable a native build profile and
     native image-building.

   - The override configuration options at runtime provide AOT (Ahead-Of-Time) configuration to the
     build process by using the `spring-boot.aot.jvmArguments` option. For Gradle builds, the
     `spring-boot.aot.jvmArguments` is set as part of the `BP_GRADLE_ADDITIONAL_BUILD_ARGUMENTS`
     build environment variable.

   These build environment parameters do not directly set the runtime values. The build environment
   parameters, provided as part of `spring-boot.aot.jvmArguments`, are only used as build-time
   signals. These signals indicate to generate code that allows configuration options to be set at
   runtime.

   There are two primary ways to override the configuration at runtime:

   - **(Default) automatic configuration by Spring Boot Conventions:**

     The Spring Boot Conventions add the necessary and appropriate environment variables and labels
     to the workload’s `PodSpec` based on `apps.tanzu.vmware.com/auto-configure-actuators` flag.
     When the `apps.tanzu.vmware.com/auto-configure-actuators` is set to `true`, Spring Boot
     conventions adds the following environment variables to the native workload `PodSpec`:

      ```console
      Spec:
        Containers:
          Env:
            Name:   MANAGEMENT_SERVER_PORT
            Value:  8081
            Name:   MANAGEMENT_ENDPOINT_HEALTH_PROBES_ADD_ADDITIONAL_PATHS
            Value:  true
            Name:   MANAGEMENT_ENDPOINT_HEALTH_SHOW_DETAILS
            Value:  always
            Name:   MANAGEMENT_ENDPOINTS_WEB_BASE_PATH
            Value:  /actuator
            Name:   MANAGEMENT_ENDPOINTS_WEB_EXPOSURE_INCLUDE
            Value:  *
            Name:   MANAGEMENT_HEALTH_PROBES_ENABLED
            Value:  true
            Name:   SERVER_PORT
            Value:  8080
            Name:   SERVER_SHUTDOWN_GRACE_PERIOD
            Value:  24s
      ```

   - **Manual override by using environment variables:**

     The users have the option to manually override runtime configuration settings by providing
     environment variables. To customize the configuration, set the relevant environment variables
     according to your requirements.

     The following example overrides `MANAGEMENT_SERVER_PORT` as `8088`, and it overrides
     `SERVER_PORT` as `8082`.

      ```console
      tanzu apps workload create spring-cloud-serverless \
      --git-repo https://github.com/vudayani-vmw/spring-cloud-serverless --git-branch main --type web \
      --label tanzu.app.live.view.application.flavours=spring-boot_spring-native \
      --label apps.tanzu.vmware.com/auto-configure-actuators=true --label \
      app.kubernetes.io/part-of=spring-cloud-serverless --label apps.tanzu.vmware.com/has-tests=true \
      --yes --annotation autoscaling.knative.dev/min-scale=1 --build-env "BP_JVM_VERSION=17" \
      --build-env "BP_NATIVE_IMAGE=true" --build-env "BP_MAVEN_BUILD_ARGUMENTS= -Pnative \
      -Dmaven.test.skip=true --no-transfer-progress package \
      -Dspring-boot.aot.jvmArguments='-Dmanagement.endpoint.health.probes.add-additional-paths='true' \
      -Dmanagement.endpoint.health.show-details='always' -Dmanagement.endpoints.web.base-path='/actuator' \
      -Dmanagement.endpoints.web.exposure.include='*' -Dmanagement.health.probes.enabled='true' \
      -Dmanagement.server.port=8081 -Dserver.port=8080' " --env MANAGEMENT_SERVER_PORT=8088 \
      --env SERVER_PORT=8082
      ```

     The resulting `PodSpec` is:

      ```console
      Spec:
        Containers:
          Env:
            Name:   MANAGEMENT_SERVER_PORT
            Value:  8088
            Name:   SERVER_PORT
            Value:  8082
            Name:   MANAGEMENT_ENDPOINT_HEALTH_PROBES_ADD_ADDITIONAL_PATHS
            Value:  true
            Name:   MANAGEMENT_ENDPOINT_HEALTH_SHOW_DETAILS
            Value:  always
            Name:   MANAGEMENT_ENDPOINTS_WEB_BASE_PATH
            Value:  /actuator
            Name:   MANAGEMENT_ENDPOINTS_WEB_EXPOSURE_INCLUDE
            Value:  *
            Name:   MANAGEMENT_HEALTH_PROBES_ENABLED
            Value:  true
            Name:   SERVER_SHUTDOWN_GRACE_PERIOD
            Value:  24s
      ```

     The Spring Boot conventions also set the Application Live View labels on the `PodSpec` to enable
     Application Live View.

1. Verify the applied labels and annotations by running:

   ```console
   kubectl get podintents.conventions.carto.run WORKLOAD-NAME -o yaml
   ```

   Where `WORKLOAD-NAME` is the name of the deployed workload. For example, `spring-cloud-serverless`.

   Expected output of Spring Boot workload:

   ```console
   ...
   Labels:       app.kubernetes.io/component=intent
                 app.kubernetes.io/part-of=spring-cloud-serverless
                 apps.tanzu.vmware.com/auto-configure-actuators=true
                 apps.tanzu.vmware.com/has-tests=true
                 apps.tanzu.vmware.com/workload-type=web
                 carto.run/cluster-template-name=convention-template
                 carto.run/resource-name=config-provider
                 carto.run/supply-chain-name=source-to-url
                 carto.run/template-kind=ClusterConfigTemplate
                 carto.run/template-lifecycle=mutable
                 carto.run/workload-name=spring-cloud-serverless
                 carto.run/workload-namespace=default
                 tanzu.app.live.view.application.flavours=spring-boot_spring-native
   ...
   ```
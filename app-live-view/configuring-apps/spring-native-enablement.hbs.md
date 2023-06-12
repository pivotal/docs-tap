# Enable Spring Native apps for Application Live View

This topic for developers tells you how to configure a Spring Native app to be observed by
Application Live View within Tanzu Application Platform (commonly known as TAP).

## <a id="procedure"></a>Procedure

For Application Live View to interact with a Spring Native app within Tanzu Application Platform:

1. Add the `spring-boot-starter-actuator` module dependency for Maven in `pom.xml` as follows:

    ```xml
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-actuator</artifactId>
    </dependency>
    ```

1. Add a native profile that includes the `native-maven-plugin` for the build phase in `pom.xml`:

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

    >**Note** For Maven based projects, you must add the `org.graalvm.buildtools` build plug-in
    and configure it to execute when the native profile is active.

1. Add the following configuration in `pom.xml` to generate `build-info.properties` into your
Spring Boot application.
Application Live View uses this information to display the Spring Boot version that the app uses.

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
    -Dspring-boot.aot.jvmArguments='-Dmanagement.endpoint.health.probes.add-additional-paths='true'\
    -Dmanagement.endpoint.health.show-details='always' \
    -Dmanagement.endpoints.web.base-path='/actuator' \
    -Dmanagement.endpoints.web.exposure.include='*' \
    -Dmanagement.health.probes.enabled='true' \
    -Dmanagement.server.port=8081 -Dserver.port=8080' " \
    --env MANAGEMENT_SERVER_PORT=8081 \
    --env MANAGEMENT_ENDPOINT_HEALTH_PROBES_ADD_ADDITIONAL_PATHS=true  \
    --env MANAGEMENT_ENDPOINT_HEALTH_SHOW_DETAILS=always \
    --env MANAGEMENT_ENDPOINTS_WEB_BASE_PATH="/actuator" \
    --env MANAGEMENT_ENDPOINTS_WEB_EXPOSURE_INCLUDE="*"  \
    --env MANAGEMENT_HEALTH_PROBES_ENABLED=true \
    --env SERVER_PORT=8080
    ```

    When you run `tanzu apps workload create`:

    - Configure all the required build arguments and environment variables to build a native
    executable as shown in the code snippet.
    The build environment variables are required to enable native build profile and native image building.
    - To override configuration options at runtime, provide AOT (Ahead-Of-Time) configuration
    to the build process using the `spring-boot.aot.jvmArguments` option.

    >**Note** For Gradle builds, the `spring-boot.aot.jvmArguments` is set as part of
    `BP_GRADLE_ADDITIONAL_BUILD_ARGUMENTS` build environment variable.

To enable Application Live view, the Spring Boot conventions set the Application Live View labels
onto the PodSpec.

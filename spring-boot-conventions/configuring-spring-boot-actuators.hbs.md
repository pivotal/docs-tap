# Configure and access Spring Boot actuators in Tanzu Application Platform

This topic tells you how the Spring Boot conventions in Tanzu Application Platform configure
Spring Boot actuators automatically. With this feature, users can activate or deactivate the
automatic configuration of actuators on Tanzu Application Platform and on individual workloads.

## <a id='workload-config'></a>Workload-level configuration

Developers can add a label to their workloads to activate or deactivate the automatic configuration
of actuators. By default, all existing and future accelerator projects are configured to activate
automatic configuration on the workload level.

To activate or deactivate the automatic configuration of actuators at the workload level, follow these
steps:

1. To activate automatic configuration of actuators, set the following label to `true` in your
   workload YAML:

    `apps.tanzu.vmware.com/auto-configure-actuators: "true"`

    If the preceding label is set to `true`, the Spring Boot actuator convention sets the following
    actuator configuration:

    - The `JAVA_TOOL_OPTIONS` property is set as `-Dmanagement.server.port="8081"`.
    - The `JAVA_TOOL_OPTIONS` property is set as `-Dmanagement.endpoints.web.base-path="/actuator"`.
    - Annotation on the PodIntent is set as `boot.spring.io/actuator: http://:8081/actuator`.

    In addition to these settings, Application Live View is activated with the following actuator
    configuration:

    - Label on the PodIntent is set as `tanzu.app.live.view.application.actuator: actuator`.
    - Label on the PodIntent is set as `tanzu.app.live.view.application.actuator.port: 8081`.

1. To deactivate automatic configuration of actuators, set the following label to `false` in your
   workload YAML:

    `apps.tanzu.vmware.com/auto-configure-actuators: "false"`

    If the preceding label is set to `false`, the Spring Boot actuator convention does not set any
    `JAVA_TOOL_OPTIONS` and does not set the annotation `boot.spring.io/actuator`.

    Application Live View is activated and configured with default values for Spring Boot web
    applications, assuming that some actuators are activated on the default port.
    On activating Application Live View, the following actuator settings are set:

    - The `JAVA_TOOL_OPTIONS` property is set as `-Dserver.port="8080"`.
    - Label on the PodIntent is set as `tanzu.app.live.view.application.actuator: actuator`.
    - Label on the PodIntent is set as `tanzu.app.live.view.application.actuator.port: 8080`.

The Application Live View GUI renders the pages with accessible information based on whether the
actuator endpoints are accessible for an application.

By default, as an additional security measure, Spring Boot conventions does not expose all the actuator
data over HTTP by exposing all the actuator endpoints.
In addition, the information exposed by the health endpoint is not set to `always` by default.

If the automatic configuration of actuators is set to `true` either at the workload level or platform
level, the Spring Boot convention then sets the runtime environment properties
`management.endpoints.web.exposure.include="*"` and `management.endpoint.health.show-details=true`
on to the PodSpec to expose all the actuator endpoints and detailed health information.
You do not need to add these properties manually in `application.properties` or `application.yml`.

## <a id='platform-config'></a>Platform-level configuration

In contrast to activating or deactivating the automatic configuration of actuators on the level of
individual workloads, you can set a global setting for the platform instead.
This setting is taken into account ONLY when there is no specific `auto-configure-actuators` setting
on the individual workload.

To activate or deactivate the automatic configuration of actuators at a global level, follow these
steps:

1. When you install Spring Boot conventions, you can provide an entry in the `values.yaml` file to
   activate automatic configuration. For example:

    ```yaml
    springboot_conventions:
      autoConfigureActuators: true
    ```

1. To deactivate the automatic configuration, you can provide the following entry:

    ```yaml
    springboot_conventions:
      autoConfigureActuators: false
    ```

> **Note** The default values for both platform level and workload level configuration is false.

To run Application Live View with Spring Boot apps, the Spring Boot convention recognizes PodIntents
and adds the following metadata labels:

- `tanzu.app.live.view: "true"`: Activates the connector to observe application pod
- `tanzu.app.live.view.application.name: APPLICATION-NAME`: Identifies the app name to be used
  internally by Application Live View
- `tanzu.app.live.view.application.actuator.port: ACTUATOR-PORT`: Identifies the port on the pod at
  which the actuators are available for Application Live View
- `tanzu.app.live.view.application.flavours: spring-boot`: Exposes the framework flavor of the app

To run Application Live View with Spring Cloud Gateway apps, Spring Boot conventions recognizes
PodIntents and adds the following metadata labels:

- `tanzu.app.live.view: "true"`: Activates the connector to observe application pod
- `tanzu.app.live.view.application.name: APPLICATION-NAME`: Identifies the app name to be used
  internally by Application Live View
- `tanzu.app.live.view.application.actuator.port: ACTUATOR-PORT`: Identifies the port on the pod at
  which the actuators are available for Application Live View
- `tanzu.app.live.view.application.flavours: spring-boot,spring-cloud-gateway`: Exposes the framework
  flavors of the app

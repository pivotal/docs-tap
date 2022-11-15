# Configuring and Accessing Spring Boot Actuators in TAP

This topic describes how Spring Boot Actuators are automatically configured by the Spring Boot Conventions in TAP. With this feature, users will be able to enable/disable the automatic configuration of actuators on the TAP platform and on individual workloads. 

## Workload-level configuration

The developers can add a label to their workloads to enable/disable the automatic configuration of actuators. By default, all the existing and future accelerator projects are configured to enable the automatic configuration on the workload level.

1.  To enable the automatic configuration of actuators, set the below label to `true` in your workload yaml:

    `apps.tanzu.vmware.com/auto-configure-actuators: "true"`

    If the above label is set to `true`, then the Spring Boot actuator convention will set the below actuator configuration

    - JAVA_TOOL_OPTIONS property is set as -Dmanagement.server.port="8081"
    - JAVA_TOOL_OPTIONS property is set as -Dmanagement.endpoints.web.base-path="/actuator" 
    - Annotation on the PodIntent is set as boot.spring.io/actuator: http://:8081/actuator

    In addition to the above settings, Application Live View is enabled with the below actuator configuration

    - Label on the PodIntent is set as tanzu.app.live.view.application.actuator: actuator
    - Label on the PodIntent is set as tanzu.app.live.view.application.actuator.port: 8081


1.  To disable the automatic configuration of actuators, set the below label to `false` in your workload yaml:

    `apps.tanzu.vmware.com/auto-configure-actuators: "false"`

    If the above label is set to `false`, then the Spring Boot actuator convention will not set any JAVA_TOOL_OPTIONS and will not set the annotation `boot.spring.io/actuator` as well

    Application Live View is enabled and configured with default values for Spring Boot Web Applications, assuming that some actuators are enabled on the default port. On enabling Application Live View, the below acutator settings are set

    - JAVA_TOOL_OPTIONS property is set as -Dserver.port="8080"
    - Label on the PodIntent is set as tanzu.app.live.view.application.actuator: actuator
    - Label on the PodIntent is set as tanzu.app.live.view.application.actuator.port: 8080

The Application Live View GUI will render the pages with the information that is accessible based on whether the actuator endpoints are accessible for a given application. 

>**Note** By default, as an additional security measure, Spring Boot Conventions does not expose all the actuator data over HTTP by exposing all the actuator endpoints. In addition, the information exposed by the health endpoint is not set to `always` by default. If the automatic configuration of actuators is set to `true` either at the workload level or platform level, the Spring Boot Convention then sets the runtime environment properties `management.endpoints.web.exposure.include="*"` and `management.endpoint.health.show-details=true` onto the PodSpec to expose all the actuator endpoints and detailed health information. You do not need to add these properties manually in `application.properties` or `application.yml`.


## Platform-level configuration

In contrast to enabling/disabling the automatic configuration of actuators on the level of individual workloads, a global setting for the platform can be set instead.

>**Note** This setting is taken into account ONLY when there is no specific `auto-configure-actuators` setting on the individual workload.

1.  When installing Spring Boot Conventions, the users can provide an entry in values.yaml file to enable automatic configuration as below

    ```yaml
    springboot_conventions:
      autoConfigureActuators: true
    ```

1.  To disable the automatic configuration, the users can provide the below entry

    ```yaml
    springboot_conventions:
      autoConfigureActuators: false
    ```

>**Note** The default values for both platform level and workload level configuration is false.

To run Application Live View with Spring Boot apps, the Spring Boot convention recognizes PodIntents and adds the following metadata labels

- `tanzu.app.live.view: "true"`: Enables the connector to observe application pod.
- `tanzu.app.live.view.application.name: APPLICATION-NAME`: Identifies the app name to be used internally by Application Live View.
- `tanzu.app.live.view.application.actuator.port: ACTUATOR-PORT`: Identifies the port on the pod at which the actuators are available for Application Live View.
- `tanzu.app.live.view.application.flavours: spring-boot`: Exposes the framework flavor of the app.

To run Application Live View with Spring Cloud Gateway apps, the Spring Boot convention recognizes PodIntents and adds the following metadata labels:

- `tanzu.app.live.view: "true"`: Enables the connector to observe application pod.
- `tanzu.app.live.view.application.name: APPLICATION-NAME`: Identifies the app name to be used internally by Application Live View.
- `tanzu.app.live.view.application.actuator.port: ACTUATOR-PORT`: Identifies the port on the pod at which the actuators are available for Application Live View.
- `tanzu.app.live.view.application.flavours: spring-boot,spring-cloud-gateway`: Exposes the framework flavors of the app.
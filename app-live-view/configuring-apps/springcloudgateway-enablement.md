# Enabling Spring Cloud Gateway apps for Application Live View

This topic describes how to configure a Spring Cloud Gateway app to be observed by
Application Live View within Tanzu Application Platform.


## Enable Spring Cloud Gateway apps

For Application Live View to interact with a Spring Cloud Gateway app within Tanzu Application Platform,
add the `spring-boot-starter-actuator` and `spring-cloud-starter-gateway` module dependency.

Add the maven dependencies in `pom.xml` as follows:

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
<dependency>
  <groupId>org.springframework.cloud</groupId>
  <artifactId>spring-cloud-starter-gateway</artifactId>
</dependency>
```

The Application Live View Convention then sets the runtime environment properties `management.endpoints.web.exposure.include="*"` and `management.endpoint.health.show-details=true` onto the PodSpec to expose all the actuator endpoints and detailed health information.
You do not need to add these properties manually in `application.properties` or `application.yml`.

For more information on the labels automatically set by Application Live View Convention, see [Convention server](convention-server.md).

## <a id="security"></a> Important security advice

The Application Live View Convention automatically exposes all the actuators of an app
so that Application Live View can access all those actuator endpoints and visualize all the details about the UI.
This overrides configuration settings that your app itself might contain, for example,
if you configured your app to expose only specific actuators.

Read about the [Application Live View Convention](convention-server.md) and the [Spring Boot Convention](https://docs-staging.vmware.com/en/draft/Tanzu-Application-Platform/1.2/tap/GUID-spring-boot-conventions-about.html) to understand the potential impact of this, and manually configure this to suit your security needs.

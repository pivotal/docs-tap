# Enabling Spring Boot apps for Application Live View

This topic describes how to configure a Spring Boot app to be observed by
Application Live View within Tanzu Application Platform.


## Enable Spring Boot apps

For Application Live View to interact with a Spring Boot app within Tanzu Application Platform,
add the `spring-boot-starter-actuator` module dependency.

Add the maven dependency in `pom.xml` as follows:

```
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

The Application Live View Convention then sets the runtime environment properties `management.endpoints.web.exposure.include="*"` and `management.endpoint.health.show-details=true` onto the PodSpec to expose all the actuator endpoints and detailed health information.
You do not need to add these properties manually in `application.properties` or `application.yml`.

For more information, see [Convention server](convention-server.md).

## <a id="security"></a> Important security advice

The Application Live View Convention automatically exposes all the actuators of an app
so that Application Live View can access all those actuator endpoints and visualize all the details about the UI.
This overrides configuration settings that your app itself might contain, for example,
if you configured your app to expose only specific actuators.

Read about the [Application Live View Convention](convention-server.md) and the [Spring Boot Convention](https://docs.vmware.com/en/Tanzu-Application-Platform/1.1/tap/GUID-spring-boot-conventions-about.html) to understand the potential impact of this, and manually configure this to suit your security needs.

# Enabling Spring Boot apps for Application Live View

This topic tells you how developers can configure a Spring Boot app for observation by
Application Live View within Tanzu Application Platform (commonly known as TAP).

## Enable Spring Boot apps

For Application Live View to interact with a Spring Boot app within Tanzu Application Platform,
add the `spring-boot-starter-actuator` module dependency.

Add the maven dependency in `pom.xml` as follows:

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-actuator</artifactId>
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

Read about the [Application Live View Convention](convention-server.md) and the [Spring Boot Convention](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.3/tap/GUID-spring-boot-conventions-about.html) to understand the potential impact of this, and manually configure this to suit your security needs.


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

To enable Application Live View on the Spring Cloud Gateway TAP workload, the Application Live View convention service automatically applies labels on the workload, such as `tanzu.app.live.view.application.flavours: spring-boot_spring-cloud-gateway` and `tanzu.app.live.view: true`, based on the Spring Cloud Gateway image metadata.

Here is an example of creating a workload for a Spring Cloud Gateway Application:

```console
tanzu apps workload create tanzu-scg-web-app --git-repo https://github.com/ksankaranara-vmw/gs-gateway.git --git-branch main --type web --label app.kubernetes.io/part-of=tanzu-scg-web-app --yes --annotation autoscaling.knative.dev/min-scale=1
```

If your application image is NOT built with Tanzu Build Service, to enable Application Live View on `Spring Boot` Tanzu Application Platform workload, use the following command. For example:

```
tanzu apps workload create boot-app --type web --app boot-app --image <IMAGE NAME> --annotation autoscaling.knative.dev/min-scale=1 --yes --label tanzu.app.live.view=true --label tanzu.app.live.view.application.name=boot-app --label tanzu.app.live.view.application.flavours=spring-boot
```

If your application image is NOT built with Tanzu Build Service, to enable Application Live View on `Spring Cloud Gateway` Tanzu Application Platform workload, use the following command. For example:

```
tanzu apps workload create scg-app --type web --app scg-app --image <IMAGE NAME> --annotation autoscaling.knative.dev/min-scale=1 --yes --label tanzu.app.live.view=true --label tanzu.app.live.view.application.name=scg-app --label tanzu.app.live.view.application.flavours=spring-boot_spring-cloud-gateway
```

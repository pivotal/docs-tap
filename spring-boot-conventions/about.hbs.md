# Overview of Spring Boot conventions

This topic tells you about the Spring Boot conventions component.

Spring Boot conventions enriches Spring Boot application deployments in a Tanzu Application Platform
supply chain by mutating the `PodSpec` and adding or editing some security checks, probes, and other
features to provide a production-ready application.

Spring Boot conventions also sets the relevant Application Live View labels automatically on the
`PodSpec` so that Application Live View is enabled by default for a Spring Boot application.

Spring Boot conventions comprises many conventions applied to any Spring Boot application that is
submitted to the supply chain in which the convention controller is configured. The conventions
include:

- Setting liveness/readiness actuator probes
- Enabling the automatic configuration of actuators on the platform and workload levels
- Setting `JAVA_TOOL_OPTIONS` and Application Live View labels for a Spring Boot application

> **Important** Spring Boot conventions supports Spring Boot and Spring Cloud Gateway applications.
> Application Live View conventions supports only Steeltoe applications. For more information about
> Application Live View conventions, see
> [Application Live View convention server](../app-live-view/configuring-apps/convention-server.hbs.md).
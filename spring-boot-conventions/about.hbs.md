# Overview of Spring Boot conventions

This topic tells you about the Spring Boot conventions.

The Spring Boot conventions is a component which will enrich Spring Boot application deployments in a TAP supply chain by mutating the PodSpec and adding or editing some security checks, probes and other features to provide a production ready application. The Spring Boot Conventions also includes setting the relevant Application Live View labels automatically on the PodSpec so that Application Live View is enabled by default for a Spring Boot Application. 

The Spring Boot conventions comprises of many conventions applied to any Spring Boot application that is submitted to the supply chain in which the convention controller is configured. The conventions include setting liveness/readiness actuator probes, enabling the automatic configuration of actuators on the platform and workload level, setting JAVA_TOOL_OPTIONS and Application Live View labels for a Spring Boot application.

>**Note** Spring Boot conventions supports Spring Boot and Spring Cloud Gateway applications. Application Live View conventions supports only Steeltoe Applications. For more information about Application Live View conventions, see [Application Live View convention server](../app-live-view/configuring-apps/convention-server.hbs.md)

For the list of Spring Boot conventions, see [Conventions](reference/conventions.hbs.md).
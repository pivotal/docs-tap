# Migrate Spring Service Registry applications from Tanzu Application Service to Tanzu Application Platform

Tanzu Application Service (TAS) and Tanzu Application Platform (TAP) can both provide applications with an implementation of the Service Discovery pattern. You might migrate an application running on Tanzu Application Service with Spring Service Registry (SSR) to Tanzu Application Platform without changes to the application code.

At a high level, Spring Service Registry on Tanzu Application Service and Tanzu Application Platform operate as follows:

- Creating a service-registry instance in a Tanzu Application Service space creates a `cf` application running a Eureka server. Tanzu Application Service applications bound to this service instance are autowired with a Spring Cloud Netflix Eureka client configuration bean. The presence of the `VCAP_APPLICATION` environment variable triggers the bean to examine the `VCAP_SERVICES` environment variable to inject `eureka.client.*` properties into the application based on connection information in the `VCAP_SERVICES`.

- Tanzu Application Platform `EurekaServer` instances are Kubernetes custom resources. Under the covers, each `EurekaServer` instance is reconciled into a Kubernetes Deployment running a Eureka server, with a bindable `Secret` object containing connection information for that Eureka server. When a `EurekaServer` is wired into Tanzu Application Platform Workloads using a `ResourceClaim` object, it mounts the bindable `Secret` object into the application container’s file system at a standard location. The [spring-cloud-bindings](https://github.com/spring-cloud/spring-cloud-bindings) library in GitHub finds any service bindings in this standard location and verifies that the binding is a Eureka server based on a binding `type` key in the binding secret, and injects `eureka.client.*` properties into the application based on connection information in the mounted secret.

## <a id="deploy-tas"></a> Deploy the Greeter application to Tanzu Application Service

Follow these steps to deploy the Greeter application to Tanzu Application Service:

1. Create an instance of the service registry product from the marketplace.

    ```console
    cf create-service p.service-registry standard greeter-service-registry
    ```

1. `cf push` the applications to Tanzu Application Service with an application manifest that binds the service instance.

    ```yaml
    ---
    applications:
    - name: greeter-cs
      instances: 1
      memory: 1G
      services:
      - greeter-service-registry
      env:
        SPRING_PROFILES_ACTIVE: development
        JBP_CONFIG_OPEN_JDK_JRE: '{ jre: { version: 17.+ }}'

    - name: greeter-messages-cs
      instances: 1
      memory: 1G
      services:
      - greeter-service-registry
      env:
        SPRING_PROFILES_ACTIVE: development
        JBP_CONFIG_OPEN_JDK_JRE: '{ jre: { version: 17.+ }}'
    ```

For more information about the Greeter application, see its [README](https://github.com/spring-cloud-services-samples/greeting/blob/main/README.adoc#building-and-deploying-on-tanzu-application-service-tas) file in GitHub. 

For more information about Service Registry, see the [Tanzu Application Service documentation](https://docs.vmware.com/en/Spring-Cloud-Services-for-VMware-Tanzu/3.2/spring-cloud-services/GUID-service-registry-index.html).

## <a id="eureka"></a> Create and bind the Eureka server instance

Follow these steps to create and bind the Eureka server instance:

1. Create a Eureka server instance.

    Tanzu Application Service
    : Create a service instance:

        ```console
        cf create-service
        ```

    Tanzu Application Platform
    : Create a `EurekaServer` resource.

1. Bind the Eureka server instance to the app.

    Tanzu Application Service
    : Include the name of the service instance in the `services` key in the application manifest. 
    
        Alternatively, use `cf bind-service` to bind the service to the application.

    Tanzu Application Platform
    : 1. Create a `ResourceClaim` resource, specifying the details of the `EurekaServer` resource in the `spec.ref` section of the configuration.
    
        1. Specify the `ResourceClaim` resource in the `spec.serviceClaims` section of the `Workload`.

## <a id="deploy-tap"></a> Deploy the Greeter application to Tanzu Application Platform

For more information about how to deploy a service registry instance and configure workloads, see [Overview of Service Registry](../service-registry/overview.hbs.md).

Follow these steps to deploy the Greeter application to Tanzu Application Platform:

1. Install the Eureka Service Registry package.

    ```console
    tanzu package available list service-registry.spring.apps.tanzu.vmware.com --namespace tap-install

    tanzu package install service-registry \
    --package service-registry.spring.apps.tanzu.vmware.com \
    --version VERSION -n tap-install

    tanzu package installed get service-registry -n tap-install
    ```

1. Create a `EurekaServer` resource by applying the following YAML to your Kubernetes cluster.

    ```yaml
    ---
    apiVersion: service-registry.spring.apps.tanzu.vmware.com/v1alpha1
    kind: EurekaServer
    metadata:
      name: eurekaserver-sample
      namespace: my-apps
    spec:
      replicas: 2
    ```

    A successful `EurekaServer` resource has a `Ready` condition set to `true` and a `status.binding.name` field pointing to a secret containing connection information.

1. Claim credentials by using `ResourceClaim`.

    ```yaml
    ---
    apiVersion: services.apps.tanzu.vmware.com/v1alpha1
    kind: ResourceClaim
    metadata:
      name: eurekaserver-sample
      namespace: my-apps
    spec:
      ref:
        apiVersion: service-registry.spring.apps.tanzu.vmware.com/v1alpha1
        kind: EurekaServer
        name: eurekaserver-sample
        namespace: my-apps
    ```

1. Configure workloads.

    The [greeting application](https://github.com/spring-cloud-services-samples/greeting) is a sample workload in GitHub. Deploy both `greeter` and `greeter-messages` by using the following YAML. The YAML claims `EurekaServer` credentials by adding a `spec.serviceClaims` section to each of the workloads.

    ```yaml
    ---
    apiVersion: carto.run/v1alpha1
    kind: Workload
    metadata:
      name: greeter-messages
      namespace: my-apps
      labels:
        apps.tanzu.vmware.com/workload-type: server
        apps.tanzu.vmware.com/has-tests: "true"
        app.kubernetes.io/part-of: greeter
    spec:
      build:
        env:
          - name: BP_JVM_VERSION
            value: "17"
          - name: BP_GRADLE_BUILT_MODULE
            value: "greeter-messages"
          - name: BP_GRADLE_BUILD_ARGUMENTS
            value: "--no-daemon clean bootJar"
      env:
        - name: SPRING_PROFILES_ACTIVE
          value: "development"
      serviceClaims:
        - name: eureka
          ref:
            apiVersion: services.apps.tanzu.vmware.com/v1alpha1
            kind: ResourceClaim
            name: eurekaserver-sample
      source:
        git:
          url: https://github.com/spring-cloud-services-samples/greeting
          ref:
            branch: main
    ---
    apiVersion: carto.run/v1alpha1
    kind: Workload
    metadata:
      name: greeter
      namespace: my-apps
      labels:
        apps.tanzu.vmware.com/workload-type: web
        apps.tanzu.vmware.com/has-tests: "true"
        app.kubernetes.io/part-of: greeter
    spec:
      build:
        env:
          - name: BP_JVM_VERSION
            value: "17"
          - name: BP_GRADLE_BUILT_MODULE
            value: "greeter"
          - name: BP_GRADLE_BUILD_ARGUMENTS
            value: "--no-daemon clean bootJar"
      env:
        - name: SPRING_PROFILES_ACTIVE
          value: "development"
      serviceClaims:
        - name: eureka
          ref:
            apiVersion: services.apps.tanzu.vmware.com/v1alpha1
            kind: ResourceClaim
            name: eurekaserver-sample
      source:
        git:
          url: https://github.com/spring-cloud-services-samples/greeting
          ref:
            branch: main
    ```

## <a id="service-registry"></a> Use Service Registry with an executable JAR file application

In the greeting application example, `BP_GRADLE_BUILD_ARGUMENTS` is set to include the `bootJar` task in addition to the default Gradle build arguments. This setting is necessary for this example base because the `build.gradle` file contains a `jar` section, and the Spring Boot buildpack does not inject the `spring-cloud-bindings` library into the application if it is an executable JAR file.

`spring-cloud-bindings` is required to process the `serviceClaim` into properties that tell the discovery client how to find the Eureka server.

To use Service Registry with an executable JAR file application, you must explicitly include [spring-cloud-bindings v1.13.0](https://mvnrepository.com/artifact/org.springframework.cloud/spring-cloud-bindings/1.13.0) or later and set the `org.springframework.cloud.bindings.boot.enable=true` system property as described in the [library README file](https://github.com/spring-cloud/spring-cloud-bindings#spring-boot-configuration) in GitHub.

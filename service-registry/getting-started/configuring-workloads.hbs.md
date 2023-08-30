# Configuring Workloads in Tanzu Application Platform using Service Registry

This topic describes how to configure Tanzu Application Platform workloads
running Spring Boot applications to connect to Service Registry EurekaServers.

Before following these steps, you should have created a `EurekaServer` as
described in [the previous topic](configuring-eureka-servers.hbs.md).

## <a id="claim-creds"></a>Claim credentials

To claim credentials you can either use the `tanzu service resource-claim create` command
or create a `ResourceClaim` directly.

- **If using the Tanzu CLI,** claim credentials by running:

    ```console
    tanzu service resource-claim create CLAIM-NAME \
        --resource-kind EurekaServer \
        --resource-api-version service-registry.spring.apps.tanzu.vmware.com/v1alpha1 \
        --resource-name RESOURCE-NAME \
        --resource-namespace RESOURCE-NAMESPACE \
        --namespace NAMESPACE \
    ```

    Where:

    - `CLAIM-NAME` is a name you choose for your claim.
    - `RESOURCE-NAME` is the name of the EurekaServer resource you want to claim.
    - `RESOURCE-NAMESPACE` is the namespace that your EurekaServer resource is in.
    - `NAMESPACE` is the namespace that your workload is in.

    For example:

    ```console
    $ tanzu service resource-claim create my-eurekaserver-claim \
        --resource-kind EurekaServer \
        --resource-api-version service-registry.spring.apps.tanzu.vmware.com/v1alpha1 \
        --resource-name my-eurekaserver \
        --resource-namespace my-namespace \
        --namespace my-namespace \
    ```

- **If using a `ResourceClaim`,** create a YAML file similar to the following example:

    ```yaml
    ---
    apiVersion: services.apps.tanzu.vmware.com/v1alpha1
    kind: ResourceClaim
    metadata:
      name: my-eurekaserver-claim
      namespace: my-namespace
    spec:
      ref:
        apiVersion: service-registry.spring.apps.tanzu.vmware.com/v1alpha1
        kind: EurekaServer
        name: my-eurekaserver
        namespace: my-namespace
    ```

## <a id="inspect"></a>Inspect the progress of your claim

You can inspect the progress of you claim creation by running:

```console
tanzu service resource-claim get MY-CLAIM-NAME --namespace MY-NAMESPACE
```

or

```console
kubectl get resourceclaim MY-CLAIM-NAME --namespace MY-NAMESPACE --output yaml
```

## <a id="inspect"></a>Use Eureka for Service Discovery in Workloads

Given an existing application already configured to use 
[Spring Cloud Service Discovery](https://cloud.spring.io/spring-cloud-netflix/reference/html/#service-discovery-eureka-clients),
claim `EurekaServer` credentials to access the running Eureka Server(s). Add the following to 
`spec.serviceClaims` of a workload:

```YAML
  serviceClaims:
    - name: eureka
      ref:
        apiVersion: services.apps.tanzu.vmware.com/v1alpha1
        kind: ResourceClaim
        name: my-eurekaserver-claim
```

By claiming the credentials, a workload will have its eureka client configured to interact with 
the referenced Eureka Server.

The following workloads can be used to deploy the [greeting application](https://github.com/spring-cloud-services-samples/greeting):

```YAML
# greeter-messages.yaml
---
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  name: greeter-messages
  namespace: my-namespace
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
        name: my-eurekaserver-claim
  source:
    git:
      url: https://github.com/spring-cloud-services-samples/greeting
      ref:
        branch: main
```

```YAML
# greeter.yaml
---
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  name: greeter
  namespace: my-namespace
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
        name: my-eurekaserver-claim
  source:
    git:
      url: https://github.com/spring-cloud-services-samples/greeting
      ref:
        branch: main
```

And created with:

```console
tanzu apps workload create -f greeter-messages.yaml --yes
tanzu apps workload create -f greeter.yaml --yes
```

> **Note:** In the example above, we set `BP_GRADLE_BUILD_ARGUMENTS` to include the
> `bootJar` task in addition to the default gradle build arguments. This setting is
> necessary for this example base because the `build.gradle` file contains a
> `jar` section, and the Spring Boot buildpack will not inject the
> spring-cloud-bindings library into the application if it is an executable jar
> file. We require spring-cloud-bindings in order to process our serviceClaim
> into properties that tell the discovery client how to find the Eureka server.
> If you wish to use Service Registry with an executable jar file application,
> you can do so, but you must include [spring-cloud-bindings
> v1.13.0](https://mvnrepository.com/artifact/org.springframework.cloud/spring-cloud-bindings/1.13.0)
> or later explicitly, as well as setting the
> `org.springframework.cloud.bindings.boot.enable=true` system property as
> described in the [library
> README](https://github.com/spring-cloud/spring-cloud-bindings#spring-boot-configuration)
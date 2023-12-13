# Configure workloads in Tanzu Application Platform by using Service Registry

This topic tells you how to configure Tanzu Application Platform (commonly known as TAP) workloads
running Spring Boot applications to connect to Service Registry `EurekaServer` resources.

## <a id='prereq'></a> Prerequisite

Create a `EurekaServer` resource. For instructions, see
[Create Eureka Servers](./configure-eureka-servers.hbs.md).

## <a id="claim-creds"></a> Claim credentials

Claim credentials from Tanzu CLI or by creating a `ResourceClaim` directly:

Using Tanzu CLI
: Claim credentials by running:

   ```console
   tanzu service resource-claim create CLAIM-NAME \
       --resource-kind EurekaServer \
       --resource-api-version service-registry.spring.apps.tanzu.vmware.com/v1alpha1 \
       --resource-name RESOURCE-NAME \
       --resource-namespace RESOURCE-NAMESPACE \
       --namespace WORKLOAD-NAMESPACE
   ```

   Where:

   - `CLAIM-NAME` is a name you choose for your claim.
   - `RESOURCE-NAME` is the name of the `EurekaServer` resource you want to claim.
   - `RESOURCE-NAMESPACE` is the namespace that your `EurekaServer` resource is in.
   - `WORKLOAD-NAMESPACE` is the namespace that your workload is in.

   For example:

   ```console
   $ tanzu service resource-claim create eurekaserver-sample \
       --resource-kind EurekaServer \
       --resource-api-version service-registry.spring.apps.tanzu.vmware.com/v1alpha1 \
       --resource-name eurekaserver-sample \
       --resource-namespace my-apps \
       --namespace my-apps
   ```

Using a ResourceClaim
: Create a YAML file, similar to the following example, and name it `resource-claim.yaml`:

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

    In kubectl, create the `ResourceClaim` by running:

    ```console
    kubectl apply -f resource-claim.yaml
    ```

## <a id="inspect"></a> Inspect the progress of your claim

Inspect the progress of your claim creation by running:

```console
tanzu service resource-claim get MY-CLAIM-NAME --namespace MY-NAMESPACE
```

or by running:

```console
kubectl get resourceclaim MY-CLAIM-NAME --namespace MY-NAMESPACE --output yaml
```

## <a id="inspect"></a> Use Eureka for service discovery in workloads

To use Eureka for service discovery in workloads:

1. If you have an existing application already configured to use
   [Spring Cloud Service Discovery](https://cloud.spring.io/spring-cloud-netflix/reference/html/#service-discovery-eureka-clients),
   claim `EurekaServer` credentials to access the running Eureka servers by adding the following to
   the `spec.serviceClaims` section of a workload:

    ```yaml
      serviceClaims:
        - name: eureka
          ref:
            apiVersion: services.apps.tanzu.vmware.com/v1alpha1
            kind: ResourceClaim
            name: eurekaserver-sample
    ```

   By claiming the credentials, a workload has its Eureka client configured to interact with the
   referenced Eureka server.

   For example, you can use the following workloads to deploy the
   [greeting application](https://github.com/spring-cloud-services-samples/greeting).

   `greeter-messages.yaml` example:

    ```yaml
    # greeter-messages.yaml
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
    ```

   `greeter.yaml` example:

    ```yaml
    # greeter.yaml
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

2. Create the workloads. For example, for the greeter application you run:

   ```console
   tanzu apps workload create -f greeter-messages.yaml --yes
   tanzu apps workload create -f greeter.yaml --yes
   ```

3. From the Tanzu CLI, retrieve the ingress route associated with the greeter application by running:

   ```console
   tanzu apps workload get greeter
   ```

   For example:

   ```console
   $ tanzu apps workload get greeter

   # other output...

   🚢 Knative Services
      NAME      READY   URL
      greeter   Ready   https://greeter.my-apps.tap

   To see logs: "tanzu apps workload tail greeter --timestamp --since 1h"
   ```

   Where `https://greeter.my-apps.tap` is the accessible ingress route to the greeter application

4. Visit `ROUTE/hello`, where `ROUTE` is the ingress route you just retrieved. The greeter
   application uses Service Registry to look up the Message Generation application and get a
   greeting message. This message initially is `Hello, Bob!`.

5. See what the Message Generation application is sending back from viewing its logs by running:

   ```console
   tanzu apps workload tail greeter-messages
   ```

   Example:

   ```console
   $ tanzu apps workload tail greeter-messages

   greeter-messages-579d67c498-bf6zl[workload] 2023-10-20T17:52:17.001Z  INFO 1 --- [nio-8080-exec-3] messages.MessagesController              : Now saying "Hi" to John
   ```

6. Create a different greeting message by providing the `salutation` and `name` parameters.
   Example:

   ```console
   ROUTE/hello?salutation=Hi&name=John
   ```

   The greeter application sends those parameters to the Message Generation application, and the
   resulting greeting is customized to match.

## <a id="exec-jar-file-app"></a> (Optional) Use Service Registry with an executable JAR file application

In the greeting application example, `BP_GRADLE_BUILD_ARGUMENTS` is set to include the `bootJar`
task in addition to the default Gradle build arguments. This setting is necessary for this example
base because the `build.gradle` file contains a `jar` section, and the Spring Boot buildpack will
not inject the `spring-cloud-bindings` library into the application if it is an executable JAR file.

`spring-cloud-bindings` is required to process the `serviceClaim` into properties that tell the
discovery client how to find the Eureka server.

To use Service Registry with an executable JAR file application, you must explicitly include [spring-cloud-bindings v1.13.0](https://mvnrepository.com/artifact/org.springframework.cloud/spring-cloud-bindings/1.13.0)
or later and set the `org.springframework.cloud.bindings.boot.enable=true` system property as
described in the
[library README file](https://github.com/spring-cloud/spring-cloud-bindings#spring-boot-configuration)
in GitHub.

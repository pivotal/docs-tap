# Configure Liveness, Readiness, and Startup Probes for Spring Boot Applications (alpha)

This topic tells you how to override the liveness, readiness, and startup probes' settings for
Spring Boot apps in Tanzu Application Platform. You can override the Kubernetes default
probe settings in `spring-boot-conventions` for containers on Tanzu Application Platform.

> **Caution** This feature is in alpha testing. It is intended for evaluation and test purposes only.

## <a id='probes-overview'></a> Overview of the probes

Kubernetes provides built-in mechanisms for checking the health and readiness of your Spring Boot
apps. By default, Kubernetes uses specific endpoints provided by Spring Boot Actuator for
liveness and readiness checks. However, you might need to customize these probes to align them with
your app's specific requirements.

| Probe     | Function                                                                                                                                                |
|-----------|---------------------------------------------------------------------------------------------------------------------------------------------------------|
| Liveness  | Indicates whether the app is running and responsive. If the probe fails, Kubernetes might restart the container.                                        |
| Readiness | Indicates whether the app is ready to serve requests. If the probe fails, Kubernetes won't route traffic to the container.                              |
| Startup   | Indicates when the app has completed its initialization and is ready to handle traffic. This is especially useful for apps with a slow startup process. |

For more information about the probes, see the
[Kubernetes documentation](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/).

## <a id='probes-config'></a> Override the default configurations of the probes

To override the default settings and customize the probes at a cluster level:

1. List the schema for the `spring-boot-conventions` package by running:

   ```console
   tanzu package available get spring-boot-conventions.tanzu.vmware.com/VERSION-NUMBER \
   --values-schema --namespace tap-install
   ```

   Where `VERSION-NUMBER` is the version of the package listed. For example: `1.7.0`.

   For example:

   ```console
   $ tanzu package available get spring-boot-conventions.tanzu.vmware.com/1.7.0 --values-schema --namespace tap-install
        KEY                                          DEFAULT             TYPE     DESCRIPTION
        autoConfigureActuators                       false               boolean  Enable or disable the automatic configuration of actuators on the TAP platform level
        kubernetes_distribution                                          string   Kubernetes distribution that this package is being installed on. Accepted
                                                                                   values: ['''',''openshift'']
        kubernetes_version                                               string   Optional: The Kubernetes Version. Valid values are '1.24.*', or ''
        livelinessProbe.terminationGracePeriodSeconds                    number   configure a grace period for the kubelet to wait  between triggering a shut down
                                                                                   of the failed container, and then forcing the container runtime to stop that
                                                                                   container
        livelinessProbe.timeoutSeconds                 1                 number   Number of seconds after which the probe times out
        livelinessProbe.failureThreshold                                 number   After a probe fails failureThreshold times in a row, Kubernetes considers that
                                                                                   the overall check has failed
        livelinessProbe.initialDelaySeconds            0                 number   Number of seconds after the container has started before liveness probes are
                                                                                   initiated
        livelinessProbe.periodSeconds                  10                number   How often (in seconds) to perform the probe
        livelinessProbe.successThreshold               1                 number   Minimum consecutive successes for the probe to be considered successful after
                                                                                   having failed
        readinessProbe.initialDelaySeconds             0                 number   Number of seconds after the container has started before readiness probes are
                                                                                   initiated
        readinessProbe.periodSeconds                   10                number   How often (in seconds) to perform the probe
        readinessProbe.successThreshold                1                 number   Minimum consecutive successes for the probe to be considered successful after
                                                                                   having failed
        readinessProbe.terminationGracePeriodSeconds                     number   configure a grace period for the kubelet to wait between triggering a shut down
                                                                                   of the failed container, and then forcing the container runtime to stop that
                                                                                   container
        readinessProbe.timeoutSeconds                  1                 number   Number of seconds after which the probe times out
        readinessProbe.failureThreshold                                  number   After a probe fails failureThreshold times in a row, Kubernetes considers that
                                                                                   the overall check has failed
        startupProbe.periodSeconds                     10                number   How often (in seconds) to perform the probe
        startupProbe.successThreshold                  1                 number   Minimum consecutive successes for the probe to be considered successful after
                                                                                   having failed
        startupProbe.terminationGracePeriodSeconds                       number   configure a grace period for the kubelet to wait between triggering a shut down
                                                                                   of the failed container, and then forcing the container runtime to stop that
                                                                                   container
        startupProbe.timeoutSeconds                    1                 number   Number of seconds after which the probe times out
        startupProbe.failureThreshold                                    number   After a probe fails failureThreshold times in a row, Kubernetes considers that
                                                                                   the overall check has failed
        startupProbe.initialDelaySeconds               0                 number   Number of seconds after the container has started before probes are initiated
   ```

   For more information about the values schema options, see the properties listed earlier.

2. When you install Spring Boot conventions, provide an entry in the `values.yaml` file to override
   the configuration.

   For example:

    ```yaml
    springboot_conventions:
      autoConfigureActuators: true
      livelinessProbe:
        initialDelaySeconds: 11
        periodSeconds: 12
        timeoutSeconds: 13
        terminationGracePeriodSeconds: 14
      readinessProbe:
        initialDelaySeconds: 15
        periodSeconds: 12
        successThreshold: 3
        failureThreshold: 4
    ```

3. Install the package by running:

   ```console
   tanzu package install spring-boot-conventions \
   --package-name spring-boot-conventions.tanzu.vmware.com \
   --version 1.7.0 \
   --namespace tap-install -f values.yaml
   ```

4. Verify that you installed the package by running:

   ```console
   tanzu package installed get spring-boot-conventions --namespace tap-install
   ```

   For example:

   ```console
   tanzu package installed get spring-boot-conventions -n tap-install
   | Retrieving installation details for spring-boot-conventions...
   NAME:                    spring-boot-conventions
   PACKAGE-NAME:            spring-boot-conventions.tanzu.vmware.com
   PACKAGE-VERSION:         1.7.0
   STATUS:                  Reconcile succeeded
   CONDITIONS:              [{ReconcileSucceeded True  }]
   USEFUL-ERROR-MESSAGE:
   ```

   Verify that `STATUS` is `Reconcile succeeded`

   The Spring Boot convention applies the probe and timeout settings at the cluster level to all
   Spring Boot and Spring Native workloads.

5. Verify the `PodIntent` of your workload by ensuring that `spec.containers.livenessProbe` shows the
   overridden configuration values propagated through the Spring Boot conventions

   ```console
   kubectl get podintents.conventions.carto.run tanzu-java-web-app -o yaml

   spec:
     containers:
     - env:
       - name: JAVA_TOOL_OPTIONS
         value: -Dmanagement.endpoint.health.probes.add-additional-paths="true" -Dmanagement.endpoint.health.show-details="always"
           -Dmanagement.endpoints.web.base-path="/actuator" -Dmanagement.endpoints.web.exposure.include="*"
           -Dmanagement.health.probes.enabled="true" -Dmanagement.server.port="8081"
           -Dserver.port="8080" -Dserver.shutdown.grace-period="24s"
       image: dev.registry.pivotal.io/app-live-view/test/tanzu-java-web-app-default@sha256:fa822a6585eb1287a817a956f16d77dd391624462a626bf37bbf0f9e89ff7562
       livenessProbe:
         httpGet:
           path: /livez
           port: 8080
           scheme: HTTP
         initialDelaySeconds: 11
         periodSeconds: 12
         terminationGracePeriodSeconds: 14
         timeoutSeconds: 13
       name: workload
       ports:
       - containerPort: 8080
         protocol: TCP
       readinessProbe:
         failureThreshold: 4
         httpGet:
           path: /readyz
           port: 8080
           scheme: HTTP
         initialDelaySeconds: 15
         periodSeconds: 12
         successThreshold: 3
       resources: {}
       securityContext:
         runAsUser: 1000
       startupProbe:
         httpGet:
           path: /startupz
           port: 8080
           scheme: HTTP
   ```
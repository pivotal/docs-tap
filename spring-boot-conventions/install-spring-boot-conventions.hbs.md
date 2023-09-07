# Install Spring Boot conventions

This topic tells you how to install Spring Boot conventions from the Tanzu Application Platform
package repository.

> **Note** Follow the steps in this topic if you do not want to use a profile to install
> Spring Boot conventions.
> For more information about profiles, see
> [Components and installation profiles](../about-package-profiles.hbs.md).

## <a id='prereqs'></a>Prerequisites

Before installing Spring Boot conventions:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see
  [Prerequisites](../prerequisites.hbs.md).
- Install [Supply Chain Choreographer](../scc/install-scc.hbs.md).

## <a id='install-spring-boot-conv'></a> Install Spring Boot conventions

To install Spring Boot conventions:

1. Get the exact name and version information for the Spring Boot conventions package to install
   by running:

   ```console
   tanzu package available list spring-boot-conventions.tanzu.vmware.com --namespace tap-install
   ```

   For example:

   ```console
   $ tanzu package available list spring-boot-conventions.tanzu.vmware.com --namespace tap-install
   / Retrieving package versions for spring-boot-conventions.tanzu.vmware.com...
   NAME                                       VERSION           RELEASED-AT
   ...
   spring-boot-conventions.tanzu.vmware.com   1.7.0             2023-09-04T00:00:00Z
   ...
   ```

1. (Optional) Change the default installation settings by running:

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

   For more information about configuring probes in spring-boot-conventions, see
   [Configure Liveliness Readiness Startup Probes for Spring Boot Applications in Tanzu Application Platform](config-probes.hbs.md)

1. Install the package by running:

   ```console
   tanzu package install spring-boot-conventions \
   --package-name spring-boot-conventions.tanzu.vmware.com \
   --version 1.7.0 \
   --namespace tap-install
   ```

1. Verify you installed the package by running:

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

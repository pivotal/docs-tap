# Install Spring Boot conventions

This topic tells you how to install Spring Boot conventions from the Tanzu Application Platform
package repository.

> **Note** Follow the steps in this topic if you do not want to use a profile to install
> Spring Boot conventions.
> For more information about profiles, see
> [About Tanzu Application Platform components and profiles](../about-package-profiles.hbs.md).

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
   spring-boot-conventions.tanzu.vmware.com   1.4.0             2022-12-08T00:00:00Z
   ...
   ```

1. (Optional) Change the default installation settings by running:

    ```console
    tanzu package available get spring-boot-conventions.tanzu.vmware.com/VERSION-NUMBER \
    --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed. For example: `1.4.0`.

    For example:

    ```console
    $ tanzu package available get spring-boot-conventions.tanzu.vmware.com/1.4.0 --values-schema --namespace tap-install
      KEY                               DEFAULT             TYPE     DESCRIPTION
        autoConfigureActuators          false               boolean  Enable or disable the automatic configuration of actuators on the TAP platform level
        kubernetes_distribution                             string   Kubernetes distribution that this package is being installed on. Accepted
                                                                     values: ['''',''openshift'']
        kubernetes_version                                  string   Optional: The Kubernetes Version. Valid values are '1.24.*', or ''
    ```

1. Install the package by running:

   ```console
   tanzu package install spring-boot-conventions \
   --package-name spring-boot-conventions.tanzu.vmware.com \
   --version 1.4.0 \
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
   PACKAGE-VERSION:         1.4.0
   STATUS:                  Reconcile succeeded
   CONDITIONS:              [{ReconcileSucceeded True  }]
   USEFUL-ERROR-MESSAGE:
   ```

   Verify that `STATUS` is `Reconcile succeeded`

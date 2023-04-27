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
   NAME                                       VERSION   RELEASED-AT
   ...
   spring-boot-conventions.tanzu.vmware.com   0.1.2     2021-10-28T00:00:00Z
   ...
   ```

2. Install the package by running:

   ```console
   tanzu package install spring-boot-conventions \
   --package-name spring-boot-conventions.tanzu.vmware.com \
   --version 0.1.2 \
   --namespace tap-install
   ```

3. Verify that you installed the package by running:

   ```console
   tanzu package installed get spring-boot-conventions --namespace tap-install
   ```

   For example:

   ```console
   tanzu package installed get spring-boot-conventions -n tap-install
   | Retrieving installation details for spring-boot-conventions...
   NAME:                    spring-boot-conventions
   PACKAGE-NAME:            spring-boot-conventions.tanzu.vmware.com
   PACKAGE-VERSION:         0.1.2
   STATUS:                  Reconcile succeeded
   CONDITIONS:              [{ReconcileSucceeded True  }]
   USEFUL-ERROR-MESSAGE:
   ```

   Verify that `STATUS` is `Reconcile succeeded`

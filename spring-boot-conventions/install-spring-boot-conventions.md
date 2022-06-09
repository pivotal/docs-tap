# Install Spring Boot conventions

This document describes how to install Spring Boot conventions
from the Tanzu Application Platform package repository.

>**Note:** Use the instructions on this page if you do not want to use a profile to install packages.
Both the full and light profiles include Spring Boot conventions.
For more information about profiles, see [About Tanzu Application Platform package and profiles](../about-package-profiles.md).

## <a id='prereqs'></a>Prerequisites

Before installing Spring Boot conventions:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).
- Ensure Convention Service is installed on the cluster. For more information, see
[Install Convention Service](../convention-service/install-conv-service.md#prereqs) section.

## <a id='install-spring-boot-conv'></a> Install Spring Boot conventions

To install Spring Boot conventions:

1. Get the exact name and version information for the Spring Boot conventions package to be installed by running:

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

1. Install the package by running:

    ```console
    tanzu package install spring-boot-conventions \
      --package-name spring-boot-conventions.tanzu.vmware.com \
      --version 0.1.2 \
      --namespace tap-install
    ```

1. Verify the package install by running:

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

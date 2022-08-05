# Install Services Toolkit

This document describes how to install Services Toolkit
from the Tanzu Application Platform package repository.

>**Note:** Use the instructions on this page if you do not want to use a profile to install packages.
Both the full and light profiles include Services Toolkit.
For more information about profiles, see [About Tanzu Application Platform components and profiles](../about-package-profiles.md).

## <a id='prereqs'></a>Prerequisites

Before installing Services Toolkit:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).

## <a id='install-services-toolkit'></a> Install Services Toolkit

To install Services Toolkit:

1. See what versions of Services Toolkit are available to install by running:

    ```console
    tanzu package available list -n tap-install services-toolkit.tanzu.vmware.com
    ```

    For example:

    ```console
    $ tanzu package available list -n tap-install services-toolkit.tanzu.vmware.com
    - Retrieving package versions for services-toolkit.tanzu.vmware.com...
      NAME                               VERSION           RELEASED-AT
      services-toolkit.tanzu.vmware.com  0.7.1             2022-07-12T00:00:00Z
    ```

1. Install Services Toolkit by running:

    ```console
    tanzu package install services-toolkit -n tap-install -p services-toolkit.tanzu.vmware.com -v VERSION-NUMBER
    ```

    Where `VERSION-NUMBER` is the Services Toolkit version you want to install. For example, `0.7.1`.

1. Verify that the package installed by running:

    ```console
    tanzu package installed get services-toolkit -n tap-install
    ```

    and checking that the `STATUS` value is `Reconcile succeeded`

    For example:

    ```console
    $ tanzu package installed get services-toolkit -n tap-install
    | Retrieving installation details for services-toolkit...
    NAME:                    services-toolkit
    PACKAGE-NAME:            services-toolkit.tanzu.vmware.com
    PACKAGE-VERSION:         0.7.1
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

# Install Crossplane

This document describes how to install Crossplane from the Tanzu Application Platform package
repository.

> **Note** Follow the steps in this topic if you do not want to use a profile to install
> Crossplane.
> For more information about profiles, see
> [About Tanzu Application Platform components and profiles](../about-package-profiles.hbs.md).

## <a id='prereqs'></a>Prerequisites

Before installing Crossplane:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).

## <a id='install-crossplane'></a> Install Crossplane

To install Crossplane:

1. See what versions of Crossplane are available to install by running:

    ```console
    tanzu package available list -n tap-install crossplane.tanzu.vmware.com
    ```

    For example:

    ```console
    $ tanzu package available list -n tap-install crossplane.tanzu.vmware.com
      NAME                               VERSION           RELEASED-AT
      crossplane.tanzu.vmware.com        0.1.1             2023-03-10 14:24:35 +0000 UTC
    ```

1. Install Crossplane by running:

    ```console
    tanzu package install crossplane -n tap-install -p crossplane.tanzu.vmware.com -v VERSION-NUMBER
    ```

    Where `VERSION-NUMBER` is the Crossplane version you want to install. For example, `0.1.1`.

1. Verify that the package installed by running:

    ```console
    tanzu package installed get crossplane -n tap-install
    ```

    and checking that the `STATUS` value is `Reconcile succeeded`

    For example:

    ```console
    $ tanzu package installed get crossplane -n tap-install
    NAMESPACE:          tap-install
    NAME:               crossplane
    PACKAGE-NAME:       crossplane.tanzu.vmware.com
    PACKAGE-VERSION:    0.1.1
    STATUS:             Reconcile succeeded
    CONDITIONS:         - type: ReconcileSucceeded
      status: "True"
      reason: ""
      message: ""
    ```

# Install Eventing

This document describes how to install the Eventing package from the Tanzu Application Platform package repository.

>**Note** Follow the steps in this topic if you do not want to use a profile to install Eventing.
For more information about profiles, see [Components and installation profiles](../about-package-profiles.hbs.md).

## <a id='eventing-prereqs'></a>Prerequisites

Before installing Eventing:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.hbs.md).

## <a id='eventing-install'></a> Install

To install Eventing:

1. List version information for the package by running:

    ```console
    tanzu package available list eventing.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list eventing.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for eventing.tanzu.vmware.com...
      NAME                   VERSION  RELEASED-AT
      eventing.tanzu.vmware.com  2.0.2    2022-10-11T00:00:00Z
    ```

1. (Optional) Make changes to the default installation settings:

    1. Gather values schema.

        ```console
        tanzu package available get eventing.tanzu.vmware.com/2.0.2 --values-schema -n tap-install
        ```

        For example:

        ```console
        $ tanzu package available get eventing.tanzu.vmware.com/2.0.2 --values-schema -n tap-install
        | Retrieving package details for eventing.tanzu.vmware.com/2.0.2...
          KEY           DEFAULT  TYPE     DESCRIPTION
          lite.enable   false    boolean  Optional: Not recommended for production. Set to "true" to reduce CPU and Memory resource requests for all Eventing Deployments, Daemonsets, and Statefulsets by half. On by default when "provider" is set to "local".
          pdb.enable    true     boolean  Optional: Set to true to enable Pod Disruption Budget. If provider local is set to "local", the PDB will be disabled automatically.
          provider      <nil>    string   Optional: Kubernetes cluster provider. To be specified if deploying Eventing on a local Kubernetes cluster provider.
        ```

    1. Create a `eventing-values.yaml` by using the following sample `eventing-values.yaml` as a guide:

        ```console
        ---
        lite:
          enable: true
        ```

        >**Note** For most installations, you can leave the `eventing-values.yaml` empty, and use the default values.

        If you run on a single-node cluster, such as kind or minikube, set the `lite.enable:` property to `true`.
        This option reduces resources requests for Eventing deployments.

1. Install the package by running:

    ```console
    tanzu package install eventing -p eventing.tanzu.vmware.com -v 2.0.2 -n tap-install -f eventing-values.yaml --poll-timeout 30m
    ```

    For example:

    ```console
    $ tanzu package install eventing -p eventing.tanzu.vmware.com -v 2.0.2 -n tap-install -f eventing-values.yaml --poll-timeout 30m
    - Installing package 'eventing.tanzu.vmware.com'
    | Getting package metadata for 'eventing.tanzu.vmware.com'
    | Creating service account 'eventing-tap-install-sa'
    | Creating cluster admin role 'eventing-tap-install-cluster-role'
    | Creating cluster role binding 'eventing-tap-install-cluster-rolebinding'
    | Creating secret 'eventing-tap-install-values'
    | Creating package resource
    | Waiting for 'PackageInstall' reconciliation for 'eventing'
    | 'PackageInstall' resource install status: Reconciling


    Added installed package 'eventing'
    ```

    Use an empty file for `eventing-values.yaml` to enable default installation configuration. Otherwise, see the previous step to set installation configuration values.

1. Verify the package install by running:

    ```console
    tanzu package installed get eventing -n tap-install
    ```

    For example:

    ```console
    tanzu package installed get eventing -n tap-install
    | Retrieving installation details for eventing...
    NAME:                    eventing
    PACKAGE-NAME:            eventing.tanzu.vmware.com
    PACKAGE-VERSION:         2.0.2
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`.

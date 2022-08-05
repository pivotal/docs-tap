# Install Out of the Box Delivery Basic

This document describes how to install Out of the Box Delivery Basic
from the Tanzu Application Platform package repository.

>**Note:** Use the instructions on this page if you do not want to use a profile to install packages.
Both the full and light profiles include Out of the Box Delivery Basic.
For more information about profiles, see [Installing the Tanzu Application Platform Package and Profiles](../install.md).

The Out of the Box Delivery Basic package is used by all the Out of the Box Supply Chains
to deliver the objects that have been produced by them to a Kubernetes environment.

## <a id='ootbdb-prereqs'></a>Prerequisites

Before installing Out of the Box Delivery Basic:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).
- Install cartographer. For more information, see [Install Supply Chain Choreographer](install-scc.md).

## <a id='oobtdb-install'></a> Install

To install Out of the Box Delivery Basic:

1. Familiarize yourself with the set of values of the package that can be
   configured by running:

    ```
    tanzu package available get ootb-delivery-basic.tanzu.vmware.com/0.5.1 \
      --values-schema \
      -n tap-install
    ```

    For example:

    ```
    KEY                  DEFAULT  TYPE    DESCRIPTION
    service_account      default  string  Name of the service account in the
                                          namespace where the Deliverable is
                                          submitted to.
    ```

1. Create a file named `ootb-delivery-basic-values.yaml` that specifies the
   corresponding values to the properties you want to change.

   For example, the contents of the file might look like this:

    ```
    service_account: default
    ```

1. With the configuration ready, install the package by running:


    ```
    tanzu package install ootb-delivery-basic \
      --package-name ootb-delivery-basic.tanzu.vmware.com \
      --version 0.5.1 \
      --namespace tap-install \
      --values-file ootb-delivery-basic-values.yaml
    ```

    Example output:

    ```
    \ Installing package 'ootb-delivery-basic.tanzu.vmware.com'
    | Getting package metadata for 'ootb-delivery-basic.tanzu.vmware.com'
    | Creating service account 'ootb-delivery-basic-tap-install-sa'
    | Creating cluster admin role 'ootb-delivery-basic-tap-install-cluster-role'
    | Creating cluster role binding 'ootb-delivery-basic-tap-install-cluster-rolebinding'
    | Creating secret 'ootb-delivery-basic-tap-install-values'
    | Creating package resource
    - Waiting for 'PackageInstall' reconciliation for 'ootb-delivery-basic'
    / 'PackageInstall' resource install status: Reconciling

     Added installed package 'ootb-delivery-basic' in namespace 'tap-install'
    ```

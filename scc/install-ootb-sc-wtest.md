# Install Out of the Box Supply Chain with Testing

This document describes how to install Out of the Box Supply Chain with Testing
from the Tanzu Application Platform package repository.

>**Note:** Use the instructions on this page if you do not want to use a profile to install packages.
Both the full and light profiles include Out of the Box Supply Chain with Testing.
For more information about profiles, see [Installing the Tanzu Application Platform Package and Profiles](../install.md).

The Out of the Box Supply Chain with Testing package provides a
ClusterSupplyChain that brings an application from source code to a deployed
instance that:

- Runs in a Kubernetes environment.
- Runs developer-provided tests in the form of Tekton/Pipeline objects to validate the source code before building container images.

## <a id='ootb-sc-test-prereqs'></a> Prerequisites

Before installing Out of the Box Supply Chain with Testing:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).
- Install cartographer. For more information, see [Install Supply Chain Choreographer](install-scc.md).
- Install [Out of the Box Delivery Basic](install-ootb-sc-basic.md)
- Install [Out of the Box Templates](install-ootb-templates.md)

## <a id='inst-ootb-sc-test'></a> Install

Install by following these steps:

1. Ensure you do not have Out of the Box Supply Chain With Testing and Scanning
(`ootb-supply-chain-testing-scanning.tanzu.vmware.com`) installed:

    1. Run the following command:

        ```
        tanzu package installed list --namespace tap-install
        ```

    1. Verify `ootb-supply-chain-testing-scanning` is in the output:

        ```
        NAME                                PACKAGE-NAME
        ootb-delivery-basic                 ootb-delivery-basic.tanzu.vmware.com
        ootb-supply-chain-basic             ootb-supply-chain-basic.tanzu.vmware.com
        ootb-templates                      ootb-templates.tanzu.vmware.com
        ```

    1. If you see `ootb-supply-chain-testing-scanning` in the list, uninstall it by running:

        ```
        tanzu package installed delete ootb-supply-chain-testing-scanning --namespace tap-install
        ```

        Example output:

        ```
        Deleting installed package 'ootb-supply-chain-testing-scanning' in namespace 'tap-install'.
        Are you sure? [y/N]: y

        | Uninstalling package 'ootb-supply-chain-testing-scanning' from namespace 'tap-install'
        \ Getting package install for 'ootb-supply-chain-testing-scanning'
        - Deleting package install 'ootb-supply-chain-testing-scanning' from namespace 'tap-install'
        | Deleting admin role 'ootb-supply-chain-testing-scanning-tap-install-cluster-role'
        | Deleting role binding 'ootb-supply-chain-testing-scanning-tap-install-cluster-rolebinding'
        | Deleting secret 'ootb-supply-chain-testing-scanning-tap-install-values'
        | Deleting service account 'ootb-supply-chain-testing-scanning-tap-install-sa'

         Uninstalled package 'ootb-supply-chain-testing-scanning' from namespace 'tap-install'
        ```

1. Check the values of the package that can be configured by running:

    ```
    KEY                       DESCRIPTION

    registry.repository       Name of the repository in the image registry server where
                              the application images from the workload should be pushed (required).

    registry.server           Name of the registry server where application images should
                              be pushed to (required).



    gitops.username           Default user name to be used for the commits produced by the
                              supply chain.

    gitops.branch             Default branch to use for pushing Kubernetes configuration files
                              produced by the supply chain.

    gitops.commit_message     Default git commit message to write when publishing Kubernetes
                              configuration files produces by the supply chain to git.

    gitops.email              Default user email to be used for the commits produced by the
                              supply chain.

    gitops.repository_prefix  Default prefix to be used for forming Git SSH URLs for pushing
                              Kubernetes configuration produced by the supply chain.

    gitops.ssh_secret         Name of the default Secret containing SSH credentials to lookup
                              in the developer namespace for the supply chain to fetch source
                              code from and push configuration to.



    cluster_builder           Name of the Tanzu Build Service (TBS) ClusterBuilder to
                              use by default on image objects managed by the supply chain.

    service_account           Name of the service account in the namespace where the Workload
                              is submitted to utilize for providing registry credentials to
                              Tanzu Build Service (TBS) Image objects as well as deploying the
                              application.
    ```

1. Create a file named `ootb-supply-chain-testing-values.yaml` that specifies the
   corresponding values to the properties you want to change. For example:

    ```
    registry:
      server: REGISTRY-SERVER
      repository: REGISTRY-REPOSITORY

    gitops:
      repository_prefix: git@github.com:vmware-tanzu/
      branch: main
      user_name: supplychain
      user_email: supplychain
      commit_message: supplychain@cluster.local
      ssh_secret: git-ssh

    cluster_builder: default
    service_account: default
    ```

    >**Note:** it's **required** that the `gitops.repository_prefix` field ends
    > with a `/`.


1. With the configuration ready, install the package by running:

    ```
    tanzu package install ootb-supply-chain-testing \
      --package-name ootb-supply-chain-testing.tanzu.vmware.com \
      --version 0.5.1 \
      --namespace tap-install \
      --values-file ootb-supply-chain-testing-values.yaml
    ```

    Example output:

    ```
    \ Installing package 'ootb-supply-chain-testing.tanzu.vmware.com'
    | Getting package metadata for 'ootb-supply-chain-testing.tanzu.vmware.com'
    | Creating service account 'ootb-supply-chain-testing-tap-install-sa'
    | Creating cluster admin role 'ootb-supply-chain-testing-tap-install-cluster-role'
    | Creating cluster role binding 'ootb-supply-chain-testing-tap-install-cluster-rolebinding'
    | Creating secret 'ootb-supply-chain-testing-tap-install-values'
    | Creating package resource
    - Waiting for 'PackageInstall' reconciliation for 'ootb-supply-chain-testing'
    \ 'PackageInstall' resource install status: Reconciling

    Added installed package 'ootb-supply-chain-testing' in namespace 'tap-install'
    ```

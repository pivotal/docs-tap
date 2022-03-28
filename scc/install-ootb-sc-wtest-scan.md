# Install Out of the Box Supply Chain with Testing and Scanning

This document describes how to install Out of the Box Supply Chain with Testing and Scanning
from the Tanzu Application Platform package repository.

>**Note:** Use the instructions on this page if you do not want to use a profile to install packages.
The full profile includes Out of the Box Supply Chain with Testing and Scanning.
For more information about profiles, see [Installing the Tanzu Application Platform Package and Profiles](../install.md).

The Out of the Box Supply Chain with Testing and Scanning package provides a
ClusterSupplyChain that brings an application from source code to a deployed
instance that:

- Runs in a Kubernetes environment.
- Performs validations in terms of running application tests.
- Scans the source code and image for vulnerabilities.


## <a id='ootb-sc-test-scan-prereqs'></a> Prerequisites

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).
- Install cartographer. For more information, see [Install Supply Chain Choreographer](install-scc.md).
- Install [Out of the Box Delivery Basic](install-ootb-sc-basic.md)
- Install [Out of the Box Templates](install-ootb-templates.md)

## <a id='ins-ootb-sc-test-scan'></a> Install

To install Out of the Box Supply Chain with Testing and Scanning:

1. Ensure you do not have Out of The Box Supply Chain With Testing
(`ootb-supply-chain-testing.tanzu.vmware.com`) installed:

    1. Run the following command:

        ```
        tanzu package installed list --namespace tap-install
        ```

    1. Verify `ootb-supply-chain-testing` is in the output:

        ```
        NAME                                PACKAGE-NAME
        ootb-delivery-basic                 ootb-delivery-basic.tanzu.vmware.com
        ootb-supply-chain-basic             ootb-supply-chain-basic.tanzu.vmware.com
        ootb-templates                      ootb-templates.tanzu.vmware.com
        ```

    1. If you see `ootb-supply-chain-testing` in the list, uninstall it by running:

        ```
        tanzu package installed delete ootb-supply-chain-testing --namespace tap-install
        ```

        Example output:

        ```
        Deleting installed package 'ootb-supply-chain-testing' in namespace 'tap-install'.
        Are you sure? [y/N]: y

        | Uninstalling package 'ootb-supply-chain-testing' from namespace 'tap-install'
        \ Getting package install for 'ootb-supply-chain-testing'
        - Deleting package install 'ootb-supply-chain-testing' from namespace 'tap-install'
        | Deleting admin role 'ootb-supply-chain-testing-tap-install-cluster-role'
        | Deleting role binding 'ootb-supply-chain-testing-tap-install-cluster-rolebinding'
        | Deleting secret 'ootb-supply-chain-testing-tap-install-values'
        | Deleting service account 'ootb-supply-chain-testing-tap-install-sa'

         Uninstalled package 'ootb-supply-chain-testing' from namespace 'tap-install'
        ```

1. Check the values of the package that can be configured by running:

    ```
    tanzu package available get ootb-supply-chain-testing-scanning.tanzu.vmware.com/0.7.0-build.2 \
      --values-schema \
      -n tap-install
    ```

    For example:

    ```
    KEY                       DESCRIPTION

    registry.repository       Name of the repository in the image registry server where
                              the application images from the workload should be pushed (required).

    registry.server           Name of the registry server where application images should
                              be pushed to (required).


    git_implementation        Determines which git client library to use.
                              Valid options are go-git or libgit2.


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
                              for the supply chain to push configuration to.


    cluster_builder           Name of the Tanzu Build Service (TBS) ClusterBuilder to
                              use by default on image objects managed by the supply chain.

    service_account           Name of the service account in the namespace where the Workload
                              is submitted to utilize for providing registry credentials to
                              Tanzu Build Service (TBS) Image objects as well as deploying the
                              application.

    cluster_builder           Name of the Tanzu Build Service (TBS) ClusterBuilder to use by
                              default on image objects managed by the supply chain.
    ```

1. Create a file named `ootb-supply-chain-testing-scanning-values.yaml` that specifies
   the corresponding values to the properties you want to change. For example:

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

    >**Note:** The `gitops.repository_prefix` field must end with `/`.

1. With the configuration ready, install the package by running:


    ```
    tanzu package install ootb-supply-chain-testing-scanning \
      --package-name ootb-supply-chain-testing-scanning.tanzu.vmware.com \
      --version 0.7.0-build.2 \
      --namespace tap-install \
      --values-file ootb-supply-chain-testing-scanning-values.yaml
    ```

    Example output:

    ```
    \ Installing package 'ootb-supply-chain-testing-scanning.tanzu.vmware.com'
    | Getting package metadata for 'ootb-supply-chain-testing-scanning.tanzu.vmware.com'
    | Creating service account 'ootb-supply-chain-testing-scanning-tap-install-sa'
    | Creating cluster admin role 'ootb-supply-chain-testing-scanning-tap-install-cluster-role'
    | Creating cluster role binding 'ootb-supply-chain-testing-scanning-tap-install-cluster-rolebinding'
    | Creating secret 'ootb-supply-chain-testing-scanning-tap-install-values'
    | Creating package resource
    - Waiting for 'PackageInstall' reconciliation for 'ootb-supply-chain-testing-scanning'
    \ 'PackageInstall' resource install status: Reconciling

    Added installed package 'ootb-supply-chain-testing-scanning' in namespace 'tap-install'
    ```

# Install Out of the Box Supply Chain with Testing and Scanning for Supply Chain Choreographer

This topic describes how you can install Out of the Box Supply Chain with
Testing and Scanning for Supply Chain Choreographer from the Tanzu Application
Platform package repository.

> **Note** Follow the steps in this topic if you do not want to use a profile to install Out of the Box Supply Chain with Testing and Scanning. For more information about profiles, see [Components and installation profiles](../about-package-profiles.hbs.md).

The Out of the Box Supply Chain with Testing and Scanning package provides a
ClusterSupplyChain that brings an application from source code to a deployed
instance that:

- Runs in a Kubernetes environment.
- Performs validations in terms of running application tests.
- Scans the source code and image for vulnerabilities.

## <a id='ins-ootb-sc-test-scan'></a> Install

To install Out of the Box Supply Chain with Testing and Scanning:

1. Complete all [prerequisites](../prerequisites.md) to install Tanzu Application Platform.

1. [Install Supply Chain Choreographer](install-scc.md).

1. [Install Out of the Box Delivery Basic](install-ootb-delivery-basic.hbs.md).

1. [Install Tekton Pipelines](../tekton/install-tekton.md).

1. [Install Out of the Box Templates](install-ootb-templates.md).

1. Ensure you do not have Out of The Box Supply Chain With Testing
(`ootb-supply-chain-testing.tanzu.vmware.com`) installed:

    1. Run the following command:

        ```console
        tanzu package installed list --namespace tap-install
        ```

    1. Verify `ootb-supply-chain-testing` is in the output:

        ```console
        NAME                                PACKAGE-NAME
        ootb-delivery-basic                 ootb-delivery-basic.tanzu.vmware.com
        ootb-supply-chain-basic             ootb-supply-chain-basic.tanzu.vmware.com
        ootb-templates                      ootb-templates.tanzu.vmware.com
        ```

    1. If you see `ootb-supply-chain-testing` in the list, uninstall it by running:

        ```console
        tanzu package installed delete ootb-supply-chain-testing --namespace tap-install
        ```

        Example output:

        ```console
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

    ```console
    tanzu package available get ootb-supply-chain-testing-scanning.tanzu.vmware.com/0.7.0 \
      --values-schema \
      -n tap-install
    ```

    For example:

    ```console
    KEY                                   DESCRIPTION

    registry.repository                    Name of the repository in the image registry server where the application
                                           images from the workload should be pushed (required).

    registry.server                        Name of the registry server where application images should be pushed to
                                           (required).

    gitops.server_address                  Default server address to be used for forming Git URLs for pushing
                                           Kubernetes configuration produced by the supply chain. This must
                                           include the scheme/protocol (e.g. https:// or ssh://)

    gitops.repository_owner                Default project or user of the repository. Used to create URLs for pushing
                                           Kubernetes configuration produced by the supply chain.

    gitops.repository_name                 Default repository name used for forming Git URLs for pushing Kubernetes
                                           configuration produced by the supply chain.

    gitops.username                        Default user name to be used for the commits produced by the supply chain.

    gitops.branch                          Default branch to use for pushing Kubernetes configuration files produced
                                           by the supply chain.

    gitops.commit_message                  Default git commit message to write when publishing Kubernetes
                                           configuration files produces by the supply chain to git.

    gitops.email                           Default user email to be used for the commits produced by the supply chain.

    gitops.ssh_secret                      Name of the default Secret containing SSH credentials to lookup in the
                                           developer namespace for the supply chain to fetch source code from and
                                           push configuration to.

    gitops.commit_strategy                 Specification of how commits are made to the branch; directly or through a
                                           pull request.

    gitops.repository_prefix               DEPRECATED: Use server_address and repository_owner instead.
                                           Default prefix to be used for forming Git SSH URLs for pushing Kubernetes
                                           configuration produced by the supply chain.

   gitops.pull_request.server_kind         The git source control platform used

   gitops.pull_request.commit_branch       The branch to which commits will be made, before opening a pull request
                                           to the branch specified in .gitops.branch If the string "" is specified,
                                           an essentially random string will be used for the branch name, in order
                                           to prevent collisions.

   gitops.pull_request.pull_request_title  The title for the pull request

   gitops.pull_request.pull_request_body   Any further information to add to the pull request

    cluster_builder           Name of the Tanzu Build Service ClusterBuilder to
                              use by default on image objects managed by the supply chain.

    service_account           Name of the service account in the namespace where the Workload
                              is submitted to utilize for providing registry credentials to
                              Tanzu Build Service Image objects as well as deploying the
                              application.
    ```

1. Create a file named `ootb-supply-chain-testing-scanning-values.yaml` that specifies
   the corresponding values to the properties you want to change. For example:

    ```yaml
    registry:
      server: REGISTRY-SERVER
      repository: REGISTRY-REPOSITORY

    gitops:
      server_address: https://github.com/
      repository_owner: vmware-tanzu
      branch: main
      username: supplychain
      email: supplychain
      commit_message: supplychain@cluster.local
      ssh_secret: git-ssh
      commit_strategy: direct

    cluster_builder: default
    service_account: default
    ```

    >**Important** The `gitops.repository_prefix` field must end with `/`.

1. With the configuration ready, install the package by running:


    ```console
    tanzu package install ootb-supply-chain-testing-scanning \
      --package ootb-supply-chain-testing-scanning.tanzu.vmware.com \
      --version 0.7.0 \
      --namespace tap-install \
      --values-file ootb-supply-chain-testing-scanning-values.yaml
    ```

    Example output:

    ```console
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

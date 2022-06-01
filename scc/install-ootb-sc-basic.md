# Install Out of the Box Supply Chain Basic

This document describes how to install Out of the Box Supply Chain Basic
from the Tanzu Application Platform package repository.

>**Note:** Use the instructions on this page if you do not want to use a profile to install packages.
Both the full and light profiles include Out of the Box Supply Chain Basic.
For more information about profiles, see [About Tanzu Application Platform package and profiles](../about-package-profiles.md).

The Out of the Box Supply Chain Basic package provides the most basic
ClusterSupplyChain that brings an application from source code to a deployed
instance of it running in a Kubernetes environment.

## <a id='ootb-sc-basic-prereqs'></a> Prerequisites

Fulfill the following prerequisites:

- Fulfill the [prerequisites](../prerequisites.md) for installing Tanzu Application Platform.
- [Install Supply Chain Choreographer](install-scc.md).

## <a id='inst-ootb-sc-basic'></a> Install

To install Out of the Box Supply Chain Basic:

1. Familiarize yourself with the set of values of the package that can be
   configured by running:

    ```console
    tanzu package available get ootb-supply-chain-basic.tanzu.vmware.com/0.7.0 \
      --values-schema \
      -n tap-install
    ```

    For example:

    ```console
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
                              in the developer namespace for the supply chain to fetch source
                              code from and push configuration to.



    cluster_builder           Name of the Tanzu Build Service (TBS) ClusterBuilder to
                              use by default on image objects managed by the supply chain.

    service_account           Name of the service account in the namespace where the Workload
                              is submitted to utilize for providing registry credentials to
                              Tanzu Build Service (TBS) Image objects as well as deploying the
                              application.
    ```

1. Create a file named `ootb-supply-chain-basic-values.yaml` that specifies the
   corresponding values to the properties you want to change. For example:

    ```yaml
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

1. With the configuration ready, install the package by running:

    ```console
    tanzu package install ootb-supply-chain-basic \
      --package-name ootb-supply-chain-basic.tanzu.vmware.com \
      --version 0.7.0 \
      --namespace tap-install \
      --values-file ootb-supply-chain-basic-values.yaml
    ```

    Example output:

    ```console
    \ Installing package 'ootb-supply-chain-basic.tanzu.vmware.com'
    | Getting package metadata for 'ootb-supply-chain-basic.tanzu.vmware.com'
    | Creating service account 'ootb-supply-chain-basic-tap-install-sa'
    | Creating cluster admin role 'ootb-supply-chain-basic-tap-install-cluster-role'
    | Creating cluster role binding 'ootb-supply-chain-basic-tap-install-cluster-rolebinding'
    | Creating secret 'ootb-supply-chain-basic-tap-install-values'
    | Creating package resource
    - Waiting for 'PackageInstall' reconciliation for 'ootb-supply-chain-basic'
    / 'PackageInstall' resource install status: Reconciling


     Added installed package 'ootb-supply-chain-basic' in namespace 'tap-install'
    ```

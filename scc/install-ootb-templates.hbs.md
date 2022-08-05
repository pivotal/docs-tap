# Install Out of the Box Templates

This document describes how to install Out of the Box Templates
from the Tanzu Application Platform package repository.

>**Note:** Use the instructions on this page if you do not want to use a profile to install packages.
Both the full and light profiles include Out of the Box Templates.
For more information about profiles, see [About Tanzu Application Platform components and profiles](../about-package-profiles.md).

The Out of the Box Templates package is used by all the Out of the Box Supply
Chains to provide the templates that are used by the Supply Chains to create
the objects that drive source code all the way to a deployed application in a
cluster.

## <a id='ootb-templ-prereqs'></a>Prerequisites

Before installing Out of the Box Templates:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).
- Install cartographer. For more information, see [Install Supply Chain Choreographer](install-scc.md).
- Install [Tekton Pipelines](../tekton/install-tekton.md).

## <a id='inst-ootb-templ-proc'></a> Install

To install Out of the Box Templates:

1. View the configurable values of the package by running:

    ```console
    tanzu package available get ootb-templates.tanzu.vmware.com/0.7.0 \
      --values-schema \
      -n tap-install
    ```

    For example:

    ```console
    KEY                  DEFAULT  TYPE    DESCRIPTION
    excluded_templates   []       array   List of templates to exclude from the
                                          installation (e.g. ['git-writer'])
    ```

1. Create a file named `ootb-templates.yaml` that specifies the corresponding
   values to the properties you want to change.

   For example, the contents of the file might look like this:

    ```yaml
    excluded_templates: []
    ```


1. After the configuration is ready, install the package by running:

    ```console
    tanzu package install ootb-templates \
      --package-name ootb-templates.tanzu.vmware.com \
      --version 0.7.0 \
      --namespace tap-install \
      --values-file ootb-templates-values.yaml
    ```

    Example output:

    ```console
    \ Installing package 'ootb-templates.tanzu.vmware.com'
    | Getting package metadata for 'ootb-templates.tanzu.vmware.com'
    | Creating service account 'ootb-templates-tap-install-sa'
    | Creating cluster admin role 'ootb-templates-tap-install-cluster-role'
    | Creating cluster role binding 'ootb-templates-tap-install-cluster-rolebinding'
    | Creating secret 'ootb-templates-tap-install-values'
    | Creating package resource
    - Waiting for 'PackageInstall' reconciliation for 'ootb-templates'
    / 'PackageInstall' resource install status: Reconciling

     Added installed package 'ootb-templates' in namespace 'tap-install'
    ```

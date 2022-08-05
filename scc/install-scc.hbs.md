# Install Supply Chain Choreographer

This document describes how to install Supply Chain Choreographer
from the Tanzu Application Platform package repository.

>**Note:** Use the instructions on this page if you do not want to use a profile to install packages.
Both the full and light profiles include Supply Chain Choreographer.
For more information about profiles, see [About Tanzu Application Platform components and profiles](../about-package-profiles.md).

>**Note:** The Supply Chain Choreographer is now bundled with the Cartographer Conventions.
For information on configuring and using Cartographer Conventions, see [Creating conventions](../cartographer-conventions/creating-conventions.md).

Supply Chain Choreographer provides the custom resource definitions the supply chain uses.
Each pre-approved supply chain creates a clear road to production and orchestrates supply chain resources. You can test, build, scan, and deploy. Developers can focus on delivering value to
users. Application operators can rest assured that all code in production has passed
through an approved workflow.

For example, Supply Chain Choreographer passes the results of fetching source code to the component
that builds a container image of it, and then passes the container image
to a component that deploys the image.

## <a id='scc-prereqs'></a>Prerequisites

Before installing Supply Chain Choreographer:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).

## <a id='scc-install'></a> Install

To install Supply Chain Choreographer:

1. Get the values schema to see what properties can be configured during installation. Run:

    ```console
    tanzu package available get cartographer.tanzu.vmware.com/0.4.0 --values-schema --namespace tap-install
    
    KEY                  DEFAULT  TYPE    DESCRIPTION
    aws_iam_role_arn              string  Optional: Arn role that has access to pull images from ECR container registry
    ca_cert_data                  string  Optional: PEM Encoded certificate data for image registries with private CA.
    excluded_components  []       array   Optional: List of components to exclude from installation (e.g. [conventions])
    ```

1. Install v0.4.0 of the `cartographer.tanzu.vmware.com` package, naming the installation `cartographer`. Run:

    ```console
    tanzu package install cartographer \
      --namespace tap-install \
      --package-name cartographer.tanzu.vmware.com \
      --version 0.4.0
    ```

    Example output:

    ```console
    | Installing package 'cartographer.tanzu.vmware.com'
    | Getting namespace 'tap-install'
    | Getting package metadata for 'cartographer.tanzu.vmware.com'
    | Creating service account 'cartographer-tap-install-sa'
    | Creating cluster admin role 'cartographer-tap-install-cluster-role'
    | Creating cluster role binding 'cartographer-tap-install-cluster-rolebinding'
    - Creating package resource
    \ Package install status: Reconciling

    Added installed package 'cartographer' in namespace 'tap-install'
    ```

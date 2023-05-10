# Install Spring Cloud Gateway for Kubernetes

This topic describes how to install Spring Cloud Gateway for Kubernetes from the
Tanzu Application Platform package repository.

## <a id='prereqs'></a>Prerequisites

Before installing Spring Cloud Gateway, complete all prerequisites for installing
Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.hbs.md).

## <a id='install'></a> Install

To install Spring Cloud Gateway:

1. See which versions of Spring Cloud Gateway are available to install from the
   Tanzu Application Platform repository by running:

    ```console
    tanzu package available list spring-cloud-gateway.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list spring-cloud-gateway.tanzu.vmware.com --namespace tap-install

    NAME                                   VERSION  RELEASED-AT
    spring-cloud-gateway.tanzu.vmware.com  2.0.0    2022-02-01T00:00:00Z
    ```

2. (Optional) View the changes you can make to the default installation settings by running:

    ```console
    tanzu package available get spring-cloud-gateway.tanzu.vmware.com/VERSION-NUMBER \
      --namespace tap-install --values-schema
    ```

    Where `VERSION-NUMBER` is the version of the package listed earlier.

    For example:

    ```console
    tanzu package available get spring-cloud-gateway.tanzu.vmware.com/2.0.0 \
      --namespace tap-install --values-schema
    ```

    You can use the information to generate a values override file for use in the following
    installation step.

    For more information about values schema options, see the
    [Spring Cloud Gateway for Kubernetes documentation](https://docs.vmware.com/en/VMware-Spring-Cloud-Gateway-for-Kubernetes/index.html).

    > **Important** The value of `deployment.namespace` must always be set to the same value as the
    > `--namespace` flag.

3. Install Spring Cloud Gateway by running:

Default values
: Run this command to install Spring Cloud Gateway with the default values

    ```console
    tanzu package install spring-cloud-gateway \
      --package-name spring-cloud-gateway.tanzu.vmware.com \
      --version VERSION-NUMBER \
      --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package install spring-cloud-gateway \
        --package-name spring-cloud-gateway.tanzu.vmware.com \
        --version 2.0.0 \
        --namespace tap-install

    Installing package 'spring-cloud-gateway.tanzu.vmware.com'
    Getting package metadata for 'spring-cloud-gateway.tanzu.vmware.com'
    Creating service account 'spring-cloud-gateway-tap-install-sa'
    Creating cluster admin role 'spring-cloud-gateway-tap-install-cluster-role'
    Creating cluster role binding 'spring-cloud-gateway-tap-install-cluster-rolebinding'
    Creating package resource
    Waiting for 'PackageInstall' reconciliation for 'spring-cloud-gateway'
    'PackageInstall' resource install status: Reconciling
    'PackageInstall' resource install status: ReconcileSucceeded

    Added installed package 'spring-cloud-gateway'
    ```

Overriding values
: Run this command to install Spring Cloud Gateway while overriding the default values

    ```console
    tanzu package install spring-cloud-gateway \
      --package-name spring-cloud-gateway.tanzu.vmware.com \
      --version VERSION-NUMBER \
      --namespace tap-install \
      --values-file values.yml
    ```

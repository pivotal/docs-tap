# Install API scoring and validation

This topic describes how to install API scoring and validation package.

> **Note** The Installation of API scoring and validation package must be done on a new cluster without any existing Tanzu Application Platform installations.

## Prerequisites

Before installing API scoring and validation, complete the following prerequisites:

- [Tanzu Network](https://network.tanzu.vmware.com/) account to download Tanzu Application Platform packages.
- Kubernetes cluster v1.22, v1.23 or v1.24 on Amazon Elastic Kubernetes Service.
- [Install Tanzu CLI](../install-tanzu-cli.hbs.md#cli-and-plugin).
- [Install kapp](https://carvel.dev/kapp/docs/v0.54.0/install/).
- [Install Kubernetes CLI](https://kubernetes.io/docs/tasks/tools/).

## Install

To install API scoring and validation:

1. Set up environment variables for installation use by running:

    ```console
    export INSTALL_REGISTRY_HOSTNAME=registry.tanzu.vmware.com
    export INSTALL_REGISTRY_USERNAME=your_tanzu_username
    export INSTALL_REGISTRY_PASSWORD=your_tanzu_password
    ```

1. Create namespace in `tap-install` by running:

    ```console
    kubectl create ns tap-install
    ```

1. Add the Tanzu package repository by running:

    ```console
    tanzu package repository add apix-repo --url dev.registry.tanzu.vmware.com/apix/apix-release:0.2.3 --namespace apix-install
    ```

1. Verify the status of the package by running:

    ```console
    kubectl get packagerepository -n apix-install
    kubectl get packagemetadatas -n apix-install
    kubectl get packages -n apix-install
    ```

1. Create a `apix-values.yaml` file by using the following sample:

    ```yaml
    apix:
      host: ""      # (Optional) What you point at the nexus-proxy service's external IP address from apix-admin namespace. Default to the external IP if left empty.
      backstage:
        host: https://tap-gui.tap.CLUSTER-NAME.tapdemo.vmware.com # Tanzu Application Platform catalog endpoint.
        port: 443 # Tanzu Application Platform catalog endpoint port.
    ```

1. Install the package by using the Tanzu CLI by running:

    ```console
    tanzu package install DISPLAY-NAME -n INSTALL-NAMESPACE -p TANZU-PACKAGE-NAME -v PACKAGE-VERSION -f CONFIG-VALUE-FILE
    ```

    For example: 

    ```console
    tanzu package install apix -n apix-install -p apix.apps.tanzu.vmware.com -v 0.2.3 -f apix-values.yaml
    ```

1. Verify the package installation by running:

    ```console
    Tanzu package available list -n tanzu-install
    ```

    Expect to see the following output:

    ```console
    NAME                         DISPLAY-NAME         SHORT_DESCRIPTION                  LATEST-VERSION
    apix.apps.tanxu.vmware.com   apix                 apix.apps.tanxu.vmware.com         0.2.3
    ```

6. Verify that `STATUS` is `Reconcile succeeded` by running:

    ```console
    kubectl get pkgi -n apix-install
    ```

    Expect to see the following output:

    ```console
    NAME        PACKAGE NAME                  PACKAGE VERSION           DESCRIPTION             AGE
    apix        apix.apps.tanxu.vmware.com    0.2.3                     Reconcile succeeded     28m
    ```

## Uninstall

To uninstall API scoring and validation, run:

```console
kubectl delete pkgi apix -n apix-install
```

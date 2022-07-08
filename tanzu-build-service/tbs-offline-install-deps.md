# Install the Tanzu Build Service dependencies

By default, Tanzu Build Service is installed with `lite` dependencies.

When installing Tanzu Build Service to an air-gapped environment, the `lite` dependencies
cannot be used as they require Internet access.
You must install the `full` dependencies.

To install `full` dependencies:

1. Relocate the Tanzu Build Service `full` dependencies package repository by running:

    ```console
    imgpkg copy -b registry.tanzu.vmware.com/tanzu-application-platform/full-tbs-deps-package-repo:VERSION \
      --to-tar=tbs-full-deps.tar
    # move tbs-full-deps.tar to environment with registry access
    imgpkg copy --tar tbs-full-deps.tar \
      --to-repo=INSTALL-REGISTRY-HOSTNAME/TARGET-REPOSITORY/tbs-full-deps:VERSION
    ```

    Where:

    - `VERSION` is the version of the Tanzu Build Service package you retrieved earlier.
    - `INSTALL-REGISTRY-HOSTNAME` is your container registry.
    - `TARGET-REPOSITORY` is your air-gapped container registry.

1. Add the Tanzu Build Service `full` dependencies package repository by running:

    ```console
    tanzu package repository add tbs-full-deps-repository \
      --url INSTALL-REGISTRY-HOSTNAME/TARGET-REPOSITORY/tbs-full-deps:VERSION \
      --namespace tap-install
    ```

    Where:

    - `INSTALL-REGISTRY-HOSTNAME` is your container registry.
    - `TARGET-REPOSITORY` is your air-gapped container registry.
    - `VERSION` is the version of the Tanzu Build Service package you retrieved earlier.

1. Install the `full` dependencies package by running:

    ```console
    tanzu package install full-tbs-deps -p full-tbs-deps.tanzu.vmware.com -v VERSION -n tap-install
    ```

    Where `VERSION` is the version of the Tanzu Build Service package you retrieved earlier.
    
## <a id='next-steps'></a>Next steps

- [Configuring custom CAs for Tanzu Application Platform GUI](tap-gui/non-standard-certs.md)

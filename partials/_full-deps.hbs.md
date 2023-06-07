By default, Tanzu Build Service is installed with `lite` dependencies.

When installing Tanzu Build Service on an air-gapped environment, the `lite` dependencies
cannot be used as they require Internet access.
You must install the `full` dependencies.

To install `full` dependencies:

{{ find_tap_version }}

1. Relocate the Tanzu Build Service `full` dependencies package repository by running:

    ```console
    imgpkg copy -b registry.tanzu.vmware.com/tanzu-application-platform/full-deps-package-repo:VERSION \
      --to-tar=tbs-full-deps.tar
    # move tbs-full-deps.tar to environment with registry access
    imgpkg copy --tar tbs-full-deps.tar \
      --to-repo=INSTALL-REGISTRY-HOSTNAME/TARGET-REPOSITORY/tbs-full-deps
    ```

    Where:

    - `VERSION` is the version of the TAP package you retrieved earlier.
    - `INSTALL-REGISTRY-HOSTNAME` is your container registry.
    - `TARGET-REPOSITORY` is your target repository.

1. Add the Tanzu Build Service `full` dependencies package repository by running:

    ```console
    tanzu package repository add tbs-full-deps-repository \
      --url INSTALL-REGISTRY-HOSTNAME/TARGET-REPOSITORY/tbs-full-deps:VERSION \
      --namespace tap-install
    ```

    Where:

    - `INSTALL-REGISTRY-HOSTNAME` is your container registry.
    - `TARGET-REPOSITORY` is your target repository.
    - `VERSION` is the version of the TAP package you retrieved earlier.

1. Install the `full` dependencies package by running:

    ```console
    tanzu package install full-tbs-deps -p full-deps.buildservice.tanzu.vmware.com -v "> 0.0.0" -n tap-install --values-file <PATH-TO-TAP-VALUES-FILE>
    ```
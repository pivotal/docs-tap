1. Get the latest version of the Tanzu Application Platform package by running:

    ```console
    tanzu package available list tap.tanzu.vmware.com --namespace tap-install
    ```

1. If you have not done so already, you must exclude the default dependencies 
by adding the key-value pair `exclude_dependencies: true` to your `tap-values.yaml` 
file under the `buildservice` section. For example:

    ```yaml
    buildservice:
      exclude_dependencies: true
    ```

1. If you have not updated your Tanzu Application Platform package installation 
after adding the key-value pair `exclude_dependencies: true` to your values file, 
you must perform the update by running:

    ```console
    tanzu package installed update tap --namespace tap-install --values-file VALUES-FILE
    ```

    Where `VALUES-FILE` is the path to the `tap-values.yaml` file you edited earlier.

1. Relocate the Tanzu Build Service `full` dependencies package repository by either:

     1. Relocating the images directly for online installation:

         ```console
         imgpkg copy -b registry.tanzu.vmware.com/tanzu-application-platform/full-deps:VERSION \
            --to-repo ${INSTALL_REGISTRY_HOSTNAME}/full-deps
         ```

         Where `VERSION` is the version of the Tanzu Application Platform package you retrieved earlier.

     1. Relocating to an external storage device and then to the registry in the air-gapped environments:

         ```console
         imgpkg copy -b registry.tanzu.vmware.com/tanzu-application-platform/full-deps-package-repo:VERSION \
           --to-tar=full-deps-package-repo.tar
         # move full-deps-package-repo.tar to environment with registry access
         imgpkg copy --tar full-deps-package-repo.tar \
           --to-repo=INSTALL-REGISTRY-HOSTNAME/TARGET-REPOSITORY/full-deps-package-repo
         ```

         Where:

         - `VERSION` is the version of the Tanzu Application Platform package you retrieved earlier.
         - `INSTALL-REGISTRY-HOSTNAME` is your container registry.
         - `TARGET-REPOSITORY` is your target repository.


1. Add the Tanzu Build Service `full` dependencies package repository by running:

    ```console
    tanzu package repository add full-deps-package-repo \
      --url INSTALL-REGISTRY-HOSTNAME/TARGET-REPOSITORY/full-deps-package-repo:VERSION \
      --namespace tap-install
    ```

    Where:

    - `INSTALL-REGISTRY-HOSTNAME` is your container registry.
    - `TARGET-REPOSITORY` is your target repository.
    - `VERSION` is the version of the TAP package you retrieved earlier.

1. Create a new `tbs-full-deps-values.yaml` and copy the `kp_default_repository`
   key-value pair from your `tap-values.yaml` or `tbs-values.yaml`:

    ```yaml
    ---
     kp_default_repository: "REPO-NAME"
     kp_default_repository_secret:
       name: kp-default-repository-creds
       namespace: tap-install
    ```

    Where `REPO-NAME` is copied from the `buildservice.kp_default_repository` field in your
    `tap-values.yaml` or `tbs-values.yaml`.

    1. (Optional) Install the UBI builder.

        The UBI builder is uses Red Hat Universal Base Image (UBI) v8
        for both build and run images.
        This builder only supports Java and Node.js.
        To install the UBI builder, add the key-value pair `enable_ubi_builder: true`
        to your `tbs-full-deps-values.yaml`.

        ```yaml
        ---
        enable_ubi_builder: true
        ```

    1. (Optional) Install the Static builder.

        The Static builder uses Ubuntu Jammy for both build images and a minimal static run image.
        This builder only supports Golang. To install the Static builder,
        add the key-value pair `enable_static_builder: true` to your `tbs-full-deps-values.yaml`.

        ```yaml
        ---
        enable_static_builder: true
        ```

1. Install the `full` dependencies package by running:

    ```console
    tanzu package install full-deps -p full-deps.buildservice.tanzu.vmware.com -v "> 0.0.0" -n tap-install --values-file VALUES-FILE
    ```

    Where `VALUES-FILE` is the path to the `tbs-full-deps-values.yaml` you created earlier.

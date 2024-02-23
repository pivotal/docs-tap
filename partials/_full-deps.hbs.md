1. Get the latest version of the Tanzu Application Platform package by running:

    ```console
    tanzu package available list tap.tanzu.vmware.com --namespace tap-install
    ```

1. If you have not done so already, you must exclude the default dependencies by adding the
   key-value pair `exclude_dependencies: true` to your `tap-values.yaml` file under the
   `buildservice` section. For example:

    ```yaml
    buildservice:
      exclude_dependencies: true
    ```

1. If you have not updated your Tanzu Application Platform package install after adding the `exclude_dependencies: true` to your values file, you must perform the update by running:

    ```console
    tanzu package installed update tap --namespace tap-install --values-file VALUES-FILE
    ```

    Where `VALUES-FILE` is the path to the `tap-values.yaml` file edited earlier.

1. Relocate the Tanzu Build Service `full` dependencies package repository by either:

   a. Relocate the images directly for online installs:

      ```console
      imgpkg copy -b registry.tanzu.vmware.com/tanzu-application-platform/full-deps:VERSION \
         --to-repo ${INSTALL_REGISTRY_HOSTNAME}/full-deps
      ```

      Where `VERSION` is the version of TAP package you retrieved earlier.

   a. Relocate to an external storage device and back to the registry for air-gapped environments:

      ```console
      imgpkg copy -b registry.tanzu.vmware.com/tanzu-application-platform/full-deps-package-repo:VERSION \
        --to-tar=full-deps-package-repo.tar
      # move full-deps-package-repo.tar to environment with registry access
      imgpkg copy --tar full-deps-package-repo.tar \
        --to-repo=INSTALL-REGISTRY-HOSTNAME/TARGET-REPOSITORY/full-deps-package-repo
      ```

      Where:

      - `VERSION` is the version of the TAP package you retrieved earlier.
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

   a. (Optional) Install the UBI builder. The UBI builder is a builder based on Red
      Hat UBI 8 for the build and run image. The only languages supported by this
      builder is Java and Node.js. If you would like to install the UBI builder,
      add the key-value pair `enable_ubi_builder: true` to your `tbs-full-deps-values.yaml`.

       ```yaml
       ---
       enable_ubi_builder: true
       ```

   a. (Optional) Install the Static builder. The Static builder is based on Ubuntu
      Jammy for the build image and a minimal static run image, the only languages
      supported is Golang. If you would like to install the Static builder,
      add the key-value pair `enable_static_builder: true` to your `tbs-full-deps-values.yaml`.

       ```yaml
       ---
       enable_static_builder: true
       ```
1. Install the `full` dependencies package by running:

    ```console
    tanzu package install full-deps -p full-deps.buildservice.tanzu.vmware.com -v "> 0.0.0" -n tap-install --values-file VALUES-FILE
    ```

    Where `VALUES-FILE` is the path to the `tbs-full-deps-values.yaml` created earlier.

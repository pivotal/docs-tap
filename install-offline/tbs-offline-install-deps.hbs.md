# Install the Tanzu Build Service dependencies

This topic tells you how to install the Tanzu Build Service (TBS) full dependencies
on Tanzu Application Platform (commonly known as TAP).

By default, Tanzu Build Service is installed with `lite` dependencies.

When installing Tanzu Build Service in an air-gapped environment, the `lite` dependencies
are not available because they require Internet access. 
You must install the `full` dependencies.

To install `full` dependencies:

<!-- The below partial is in the docs-tap/partials directory -->

{{> 'partials/full-deps' }}

### <a id='auto-deps-update'></a> (Optional) Update TBS depdencies out of band of TAP releases

{{> 'partials/auto-deps' initial_steps="1. Relocate the dependency updater package repository to the air-gapped container image registry:

    If a machine with access to both the air-gapped registry and the internet is availabe, you can
    copy the images directly by running:

    ```console
    imgpkg copy -b registry.tanzu.vmware.com/build-service-dependency-updater/package-repo:VERSION_CONSTRAINT --to-repo $INTERNAL-REPO
    ```

    If the data can only be moved through a physical external storage device, you can copy the
    images into a `.tar` file from the VMware Tanzu Network by running:

    ```console
    imgpkg copy \
      -b registry.tanzu.vmware.com/build-service-dependency-updater/package-repo:VERSION_CONSTRAINT \
      --to-tar dependency-updater-$VERSION_CONSTRAINT.tar \
      --include-non-distributable-layers
    ```

    The `.tar` files can be imported into the air-gapped contaimer image registry by running:

    ```console
    imgpkg copy \
      --tar dependency-updater-$VERSION-CONSTRAINT.tar \
      --to-repo $INTERNAL-REPO \
      --include-non-distributable-layers \
      --registry-ca-cert-path $REGISTRY_CA_PATH
    ```

    Where:
    - `VERSION-CONSTRAINT` is the TAP version in the form of `MAJOR.MINOR.x`. For example, `1.8.x`.
    - `INTERNAL-REPO` is your repository in the air-gapped container image registry. Examples:
        - Harbor has the form `MY-REGISTRY/REPO-NAME/tbs-dep-updater`.
        - Docker Hub has the form `MY-REGISTRY/tbs-dep-updater`.
        - Google Cloud Registry has the form `MY-REGISTRY/MY-PROJECT/REPO-NAME/tbs-dep-updater`.
    " }}

## <a id='next-steps'></a>Next steps

- [Configure custom CAs for Tanzu Developer Portal](tap-gui-non-standard-certs-offline.hbs.md)

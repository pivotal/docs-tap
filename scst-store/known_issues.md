# Troubleshooting and known issues

This topic contains troubleshooting and known issues for Supply Chain Security Tools - Store.

## <a id='deploy-intcust'></a>Deploying for internal/external customers

Using `imgpkg copy` command copies the image bundle along with all images it references to a target
repository.

This is useful as it ensures the images used in the bundle are always available, even if the
images in the original location are no longer available: there is now a copy in the target
repository.

* Deploy the bundle by running:

    ```
    imgpkg copy -b <bundle-image-registry>:<bundle-version-tag> --to-repo <target-image-registry-repo>/
    ```
    Where:

    - `<bundle-image-registry>` is the registry where you copy the image bundle.
    - `<bundle-version-tag>` is the image bundle version tag to copy.
    - `<target-image-registry-repo>` is where you paste the image bundle and all associated images.

## <a id='review-logs'></a>Reviewing logs

The API server generates logs that are useful for troubleshooting. For information about interpreting logs, see [Configuring and Understanding Store Logs](logs.md).

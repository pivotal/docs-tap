Tanzu Build Service dependencies might be upgraded between Tanzu Application Platform
releases, for example, if a CVE is discovered in the OS (stack update) or language (buildpack update).

Automatic dependency updates enable your cluster to consume the stack and buildpack updates immediately
instead of waiting for the next Tanzu Application Platform patch release to pull in the updated
dependencies.

- Updates are provided through a separate package repository with available version lines for
all supported Tanzu Application Platform minor versions.
- Within a version line, only patch versions are incremented to avoid breaking changes.
- You can customize the packages that you want the automatic dependency updater to update through your
`tap-values.yaml` file or your full dependencies values.

**Prerequisites:** These steps assume a registry secret already exists in the cluster for accessing
`registry.tanzu.vmware.com` and your registry.

To enable automatic dependency updates:

{{ initial_steps }}

1. Add the following to your `tap-values.yaml` file:

    ```yaml
    buildservice:
      dependency_updates:
        allow: true
        scope: SCOPE
        include_packages: [""]
        exclude_packages: [""]
    ```

    Where:

    - `SCOPE` is the list of dependencies you want updated. The options are:
      - `stacks-only` (default): Only stacks and builders are updated. This addresses CVEs
        in the base image or operating system.
      - `all`: Stacks, builders, and buildpacks are updated. This addresses CVEs in the base
        image or operating system and CVEs in the language toolchain such as compilers,
        interpreters, and standard libraries.
      - `custom`: This list is empty by default. Use the `include_packages` key to add packages to
        be updated.

    > **Note** You must update the Tanzu Application Platform package install and the Full Dependencies
    > package install after changing the `tap-values.yaml`.

1. Add the Tanzu Build Service Dependency Updates package repository by running:

    ```console
    kubectl apply -f - <<EOF
      apiVersion: packaging.carvel.dev/v1alpha1
      kind: PackageRepository
      metadata:
        name: tbs-dependencies-package-repository
        namespace: tap-install
      spec:
        fetch:
          imgpkgBundle:
            image: DEPENDENCY-UPDATER-PACKAGE-REPO
            tagSelection:
              semver:
                constraints: VERSION-CONSTRAINT
    EOF
    ```

    Where:

    - `DEPENDENCY-UPDATER-PACKAGE-REPO` is the location of the package repository. This is
      `registry.tanzu.vmware.com/build-service-dependency-updater/package-repo` for online installs
      and the internal container image registry for air-gapped installs.
    - `VERSION-CONSTRAINT` is the Tanzu Application Platform version in the form of `MAJOR.MINOR.x`.
      For example, `1.8.x`.

After completing this configuration, the repository you set with `DEPENDENCY-UPDATER-PACKAGE-REPO` will be
polled for updates and any new releases will automatically be made available to the cluster.

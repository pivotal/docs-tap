The dependencies that Tanzu Build Service utilizes may be upgraded out of band of Tanzu Application
Platform releases. For example, if a CVE is discovered in the OS (stack update), or language
(buildpack update), instead of waiting for the next TAP patch release to pull in the updated
dependencies, automatic dependencies updates ensures your cluster consumes the stack and buildpack
updates immediately.

These updates are provided through a separate package repository with available version lines for
all supported TAP minor versions. Within a version line, only patch versions are incremented to
avoid any possible breaking changes. Users can customize the packages that can be updated through
tap-values or their full deps values.

These steps assume a registry secret has already exists in the cluster for accessing
registry.tanzu.vmware.com and the user's registry.

{{ initial_steps }}

1. Add the following to tap-values.yaml:

   ```yaml
   buildservice:
     dependency_updates:
       allow: true
       scope: <SCOPE>
       include_packages: [""]
       exclude_packages: [""]
   ```

   Where:
   - `SCOPE` is the list of dependencies you would like to be updated.
       The options are:
       - `stacks-only` (default value): only stacks and builders are updated. This addresses CVEs
         in the base image/operating system.
       - `all`: stacks, builders, and buildpacks are updated. This addresses CVEs in the base
         image/operating system, as well as CVEs in the language toolchain (e.g. compilers,
         intepreters, and standard libraries).
       - `custom`: this list is empty by default, use the `include_packages` key to add packages to
         be updated

<p class="note"><strong>Note:</strong> The TAP package install and/or the Full Deps Package install will need to be updated after changing tap-values</p>


1. Add the Tanzu Build Service Dependency Updates package repository by running:

   ```
   kubectl apply -f - <<EOF
     apiVersion: packaging.carvel.dev/v1alpha1
     kind: PackageRepository
     metadata:
       name: tbs-dependencies-package-repository
       namespace: tap-install
     spec:
       fetch:
         imgpkgBundle:
           image: registry.tanzu.vmware.com/build-service-dependency-updater/package-repo
           tagSelection:
             semver:
               constraints: VERSION-CONSTRAINT
   EOF
   ```

   Where:
   - `VERSION-CONSTRAINT` is the TAP version in the form of `MAJOR.MINOR.x`. For example, `1.8.x`.
   - `DEPENDENCY-UPDATER-PACKAGE-REPO` is the location of the package repo. This will be
     `registry.tanzu.vmware.com/build-service-dependency-updater/package-repo` for online installs
     and the internal container image registry for air-gapped installs.

1. `DEPENDENCY-UPDATER-PACKAGE-REPO` will now be polled for updates and any new releases will
   automatically be made available to the cluster.

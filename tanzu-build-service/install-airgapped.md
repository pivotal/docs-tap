# Install Tanzu Build Service air-gapped

<!-- consider putting air-gapped install on new page -->

## <a id='tbs-offline-install-package'></a> Install Tanzu Build Service package

You can install Tanzu Build Service to a Kubernetes Cluster and registry that are
air-gapped from external traffic.

These steps assume that you have installed the Tanzu Application Platform packages
in your air-gapped environment.

To install the Tanzu Build Service package in an air-gapped environment:

1. Get the latest version of the buildservice package by running:

    ```console
    tanzu package available list buildservice.tanzu.vmware.com --namespace tap-install
    ```

1. Gather the values schema by running:

    ```console
    tanzu package available get buildservice.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the version of <!-- where should they get the version from? -- build service version from step above -->

1. Create a `tbs-values.yaml` file. The required fields for an air-gapped installation are as follows:

    ```yaml
    ---
    kp_default_repository: REPOSITORY
    kp_default_repository_username: REGISTRY-USERNAME
    kp_default_repository_password: REGISTRY-PASSWORD
    ca_cert_data: CA-CERT-CONTENTS
    exclude_dependencies: true
    ```

    Where:

    - `REPOSITORY` is the fully qualified path to the Tanzu Build Service repository.
    This path must be writable. For example:
        * For Harbor: `harbor.io/my-project/build-service`
        * For Artifactory: `artifactory.com/my-project/build-service`
    - `REGISTRY-USERNAME` and `REGISTRY-PASSWORD` are the user name and password for the internal registry.
    <!-- can users use secret refs or IAM instead? No IAM yes secrets -->
    - `CA-CERT-CONTENTS` are the contents of the PEM-encoded CA certificate for the internal registry

1. Install the package by running:

    ```console
    tanzu package install tbs -p buildservice.tanzu.vmware.com -v VERSION-NUMBER -n tap-install -f tbs-values.yaml
    ```

    For example:

    ```console
    $ tanzu package install tbs -p buildservice.tanzu.vmware.com -v VERSION-NUMBER -n tap-install -f tbs-values.yaml

    | Installing package 'buildservice.tanzu.vmware.com'
    | Getting namespace 'tap-install'
    | Getting package metadata for 'buildservice.tanzu.vmware.com'
    | Creating service account 'tbs-tap-install-sa'
    | Creating cluster admin role 'tbs-tap-install-cluster-role'
    | Creating cluster role binding 'tbs-tap-install-cluster-rolebinding'
    | Creating secret 'tbs-tap-install-values'
    - Creating package resource
    - Package install status: Reconciling
     Added installed package 'tbs' in namespace 'tap-install'
    ```

## <a id='tbs-offline-install-deps'></a> Install Tanzu Build Service dependencies air-gapped

By default, TBS is installed with `lite` dependencies.

When installing Tanzu Build Service to an air-gapped environment, the lite dependencies
cannot be used as they require Internet access.
The full dependencies must be installed with the following steps:

1. Relocate the Tanzu Build Service full dependencies package repository using the version from
the Tanzu Build Service installation and the same `REGISTRY/REPOSITORY` variables
from the Tanzu Application Platform install.

    ```console
    imgpkg copy -b registry.tanzu.vmware.com/tanzu-application-platform/full-tbs-deps-package-repo:${VERSION} --to-tar=tbs-full-deps.tar
    # move tbs-full-deps.tar to environment with registry access
    imgpkg copy --tar tbs-full-deps.tar \
      --to-repo=${INSTALL_REGISTRY_HOSTNAME}/TARGET-REPOSITORY/tbs-full-deps:${VERSION}
    ```

    Where:

    - `TARGET-REPOSITORY` is
    <!-- are these variables INSTALL_REGISTRY_HOSTNAME and VERSION set somewhere?
    should they be placeholders that users add manually? -->

1. Add the Tanzu Build Service full dependencies package repository using the same version used in the previous step<!-- Write |earlier in this procedure| or, if referring to a separate procedure, link to it. -->:

    ```console
    tanzu package repository add tbs-full-deps-repository \
      --url ${INSTALL_REGISTRY_HOSTNAME}/TARGET-REPOSITORY/tbs-full-deps:${VERSION} \
      --namespace tap-install
    ```

    Where:

    - `TARGET-REPOSITORY` is
    <!-- are these variables INSTALL_REGISTRY_HOSTNAME and VERSION set somewhere?
    should they be placeholders that users add manually? -->

1. Install the full dependencies package by running:

    ```console
    tanzu package install full-tbs-deps -p full-tbs-deps.tanzu.vmware.com -v $VERSION -n tap-install
    ```

    <!-- is the variable VERSION set somewhere?
    should they be placeholders that users add manually? -->
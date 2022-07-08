# Install Tanzu Build Service on an air-gapped environment

This topic describes how to install Tanzu Build Service on an air-gapped environment.

Use this topic if you do not want to use a Tanzu Application Platform profile that includes
Tanzu Build Service.
The Full, Iterate, and Build profiles include Tanzu Build Service.
For more information about profiles, see [About Tanzu Application Platform components and profiles](../about-package-profiles.md).

To install Tanzu Build Service on an air-gapped environment, you must:

1. [Install the Tanzu Build Service package](#tbs-offline-install-package)
1. [Install the Tanzu Build Service dependencies](#tbs-offline-install-deps)

## <a id='tbs-prereqs'></a> Prerequisites

Before installing Tanzu Build Service:

- Complete all prerequisites to install Tanzu Application Platform.
For more information, see [Prerequisites](../prerequisites.md).

- You must have access to a Docker registry that Tanzu Build Service can use to create builder images.
Approximately 10&nbsp;GB of registry space is required when using the `full` dependencies.

- Your Docker registry must be accessible with user name and password credentials.

## <a id='tbs-offline-install-package'></a> Install the Tanzu Build Service package

You can install Tanzu Build Service to a Kubernetes Cluster and registry that are
air-gapped from external traffic.

These steps assume that you have installed the Tanzu Application Platform packages
in your air-gapped environment.

To install the Tanzu Build Service package in an air-gapped environment:

1. Get the latest version of the Tanzu Build Service package by running:

    ```console
    tanzu package available list buildservice.tanzu.vmware.com --namespace tap-install
    ```

1. Gather the values schema by running:

    ```console
    tanzu package available get buildservice.tanzu.vmware.com/VERSION --values-schema --namespace tap-install
    ```

    Where `VERSION` is the version of the Tanzu Build Service package you retrieved in the previous step.

1. Create a `tbs-values.yaml` file. The required fields for an air-gapped installation are as follows:

    ```yaml
    ---
    kp_default_repository: REPO-NAME
    kp_default_repository_username: REGISTRY-USERNAME
    kp_default_repository_password: REGISTRY-PASSWORD
    ca_cert_data: CA-CERT-CONTENTS
    exclude_dependencies: true
    ```

    Where:

    - `REPO-NAME` is the fully qualified path to the Tanzu Build Service repository.
    <!-- does this mean the repo you want to install TBS in? "is a writable repository in your
    registry." -->
    This path must be writable. For example:
      - For Harbor: `harbor.io/my-project/build-service`
      - For Artifactory: `artifactory.com/my-project/build-service`

    - `REGISTRY-USERNAME` and `REGISTRY-PASSWORD` are the user name and password for the internal registry.
    You can write to this location with this credential. <!--  are the user name and password for the user that can write to `KP-DEFAULT-REPO` -->

        >**Note:** If you do not want to use plaintext for these credentials, you can
        >instead configure these credentials by using a Secret reference.
        >For more information, see [Use Secret references for registry credentials](#install-secret-refs).

    - `CA-CERT-CONTENTS` are the contents of the PEM-encoded CA certificate for the internal registry.

1. Install the package by running:

    ```console
    tanzu package install tbs -p buildservice.tanzu.vmware.com -v VERSION -n tap-install -f tbs-values.yaml
    ```

    Where `VERSION` is the version of the Tanzu Build Service package you retrieved earlier.

    For example:

    ```console
    $ tanzu package install tbs -p buildservice.tanzu.vmware.com -v VERSION -n tap-install -f tbs-values.yaml

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

## <a id='tbs-offline-install-deps'></a> Install the Tanzu Build Service dependencies

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
    - `TARGET-REPOSITORY` is ... <!-- is this the same as the repository you used for kp_default_repository? -->

1. Add the Tanzu Build Service `full` dependencies package repository by running:

    ```console
    tanzu package repository add tbs-full-deps-repository \
      --url INSTALL-REGISTRY-HOSTNAME/TARGET-REPOSITORY/tbs-full-deps:VERSION \
      --namespace tap-install
    ```

    Where:

    - `INSTALL-REGISTRY-HOSTNAME` is your container registry.
    - `TARGET-REPOSITORY` is ...
    - `VERSION` is the version of the Tanzu Build Service package you retrieved earlier.

1. Install the `full` dependencies package by running:

    ```console
    tanzu package install full-tbs-deps -p full-tbs-deps.tanzu.vmware.com -v VERSION -n tap-install
    ```

    Where `VERSION` is the version of the Tanzu Build Service package you retrieved earlier.

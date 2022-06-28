# Install Tanzu Build Service

This document describes how to install Tanzu Build Service
from the Tanzu Application Platform package repository by using the Tanzu CLI.

>**Note:** Use the instructions on this page if you do not want to use a profile to install packages.
Both the full and light profiles include Tanzu Build Service.
For more information about profiles, see [About Tanzu Application Platform package and profiles](../about-package-profiles.md).

>**Note:** The following procedure might not include some configurations required for your specific environment.
>For more advanced details on installing Tanzu Build Service, see
>[Installing Tanzu Build Service](https://docs.vmware.com/en/VMware-Tanzu-Build-Service/index.html).

## <a id='tbs-prereqs'></a> Prerequisites

Before installing Tanzu Build Service:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).
- You must have access to a Docker registry that Tanzu Build Service can use to create builder images.
Approximately 10&nbsp;GB of registry space is required when using the full descriptor.
- Your Docker registry must be accessible with username and password credentials.

## <a id='tbs-tcli-install'></a> Install Tanzu Build Service by using the Tanzu CLI

To install Tanzu Build Service by using the Tanzu CLI:

1. List version information for the package by running:

    ```console
    tanzu package available list buildservice.tanzu.vmware.com --namespace tap-install
    ```

1. (Optional) To make changes to the default installation settings, run:

    ```console
    tanzu package available get buildservice.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed in step 1 above.

1. Gather the values schema by running:

    ```console
    tanzu package available get buildservice.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

2. Create a `tbs-values.yaml` file.

    ```yaml
    ---
    kp_default_repository: "KP-DEFAULT-REPO"
    kp_default_repository_username: "KP-DEFAULT-REPO-USERNAME"
    kp_default_repository_password: "KP-DEFAULT-REPO-PASSWORD"
    ```
    Where:

   - `KP-DEFAULT-REPO` is a writable repository in your registry. Tanzu Build Service dependencies are written to this location. Examples:
     * Harbor has the form `kp_default_repository: "my-harbor.io/my-project/build-service"`
     * Dockerhub has the form `kp_default_repository: "my-dockerhub-user/build-service"` or `kp_default_repository: "index.docker.io/my-user/build-service"`
     * Google Cloud Registry has the form `kp_default_repository: "gcr.io/my-project/build-service"`
   - `KP-DEFAULT-REPO-USERNAME` is the name of the user who can write to `KP-DEFAULT-REPO`. You can write to this location with this credential.
     * For Google Cloud Registry, use `kp_default_repository_username: _json_key`
   - `KP-DEFAULT-REPO-PASSWORD` is the password for the user that can write to `KP-DEFAULT-REPO`. You can write to this location with this credential. This credential can also be configured by using a Secret reference. For more information, see [Installation using Secret References for registry credentials](#install-secret-refs) for details.
     * For Google Cloud Registry, use the contents of the service account json file.

     >**Note:** TBS is bootstrapped with a set of dependencies.

3. Install the package by running:

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

4. (Optional) Verify the clusterbuilders that the Tanzu Build Service installation created by running:

    ```console
    tanzu package installed get tbs -n tap-install
    ```

## <a id='tbs-tcli-install-ecr'></a> Install TBS or TAP using AWS IAM Authentication

TAP and TBS support using AWS IAM roles to authenticate with ECR on EKS clusters.

1. Configure an AWS IAM role that has read and write access to the `INSTALL_REGISTRY_HOSTNAME/TARGET-REPOSITORY` registry location that will be used for installation.
2. Follow the standard TAP installation docs until the configuration of `tap-values.yaml` and use the following `buildservice` config:

```yaml
buildservice:
  kp_default_repository: "KP-DEFAULT-REPO"
  kp_default_repository_aws_iam_role_arn: "IAM-ROLE-ARN"
```

Where:

- `IAM-ROLE-ARN` is the AWS IAM role ARN for the role configured in step 1 ex. `arn:aws:iam::xyz:role/my-install-role`

### <a id='tbs-tcli-install-ecr-dev-ns'></a> Configuring the Developer Namespace for AWS IAM Authentication

The developer namespace requires configuration for TAP to use AWS IAM authentication for ECR.

1. Configure an AWS IAM role that has read and write access to the registry location where workload images will be stored.
2. Using the supply chain service account (`default` if unset), add an annotation including the role ARN configured in step 1.

```console
kubectl annotate serviceaccount -n <developer-namespace> <service-account-name> \
  eks.amazonaws.com/role-arn=${IAM-ROLE-ARN}
```

Where:

- `IAM-ROLE-ARN` is the AWS IAM role ARN for the role configured in step 1 ex. `arn:aws:iam::xyz:role/my-developer-role`

## <a id='tbs-tcli-install-offline'></a> Install Tanzu Build Service using the Tanzu CLI air-gapped

### <a id='tbs-offline-install-package'></a> Install Tanzu Build Service package

Tanzu Build Service can be installed to a Kubernetes Cluster and registry that are air-gapped from external traffic.

These steps assume that you have installed the TAP packages in your air-gapped environment.

To install the Tanzu Build Service package air-gapped:

1. Gather the values schema by running:

    ```console
    tanzu package available get buildservice.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

1. Create a `tbs-values.yaml` file. The required fields for an air-gapped installation are:

    ```yaml
    ---
    kp_default_repository: REPOSITORY
    kp_default_repository_username: REGISTRY-USERNAME
    kp_default_repository_password: REGISTRY-PASSWORD
    ca_cert_data: CA-CERT-CONTENTS
    exclude_dependencies: true
    ```

    Where:

    - `REPOSITORY` is the fully qualified path to the Tanzu Build Service repository. This path must be writable. For example:
        * Harbor: `harbor.io/my-project/build-service`
        * Artifactory: `artifactory.com/my-project/build-service`
    - `REGISTRY-USERNAME` and `REGISTRY-PASSWORD` are the user name and password for the internal registry.
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

### <a id='tbs-offline-install-dependencies'></a> Install Tanzu Build Service dependencies (air-gapped)

By default, TBS is installed with `lite` dependencies

When installing Tanzu Build Service to an air-gapped environment, the lite dependencies cannot be used as they require internet access.
The full dependencies must be installed with the following steps:


1. Relocate the TBS full dependencies package repository using the version from the TBS installation and the same values install registry/repository variables from the TAP install.

```console
imgpkg copy -b registry.tanzu.vmware.com/tanzu-application-platform/full-tbs-deps-package-repo:${VERSION} --to-tar=tbs-full-deps.tar
# move tbs-full-deps.tar to environment with registry access
imgpkg copy --tar tbs-full-deps.tar \
  --to-repo=${INSTALL_REGISTRY_HOSTNAME}/TARGET-REPOSITORY/tbs-full-deps:${VERSION}
```

2. Add the TBS full dependencies package repository using the same version used in the previous step:

```console
tanzu package repository add tbs-full-deps-repository \
  --url ${INSTALL_REGISTRY_HOSTNAME}/TARGET-REPOSITORY/tbs-full-deps:${VERSION} \
  --namespace tap-install
```

5. Install the Full Dependencies package (no `values.yaml` needed):

```console
tanzu package install full-tbs-deps -p full-tbs-deps.tanzu.vmware.com -v $VERSION -n tap-install
```

#### <a id='install-secret-refs'></a> Installation using Secret references for registry credentials

Tanzu Build Service requires credentials for the `kp_default_repository` and the Tanzu Network registry.

You can apply them in the `values.yaml` configuration directly in-line by using `_username` and
`_password` fields such as `kp_default_repository_username/kp_default_repository_password` and
`tanzunet_username/tanzunet_password`.

If you do not want credentials saved in ConfigMaps in plaintext, you can use Secret references in the
`values.yaml` configuration to use existing Secrets.

To use Secret references you must create Secrets of type `kubernetes.io/dockerconfigjson` containing
credentials for `kp_default_repository` and the VMware Tanzu Network registry.

Use the following alternative configuration for `values.yaml`:

```yaml
---
kp_default_repository: "KP-DEFAULT-REPO"
kp_default_repository_secret:
  name: "KP-DEFAULT-REPO-SECRET-NAME"
  namespace: "KP-DEFAULT-REPO-SECRET-NAMESPACE"
tanzunet_secret:
  name: "TANZUNET-SECRET-NAME"
  namespace: "TANZUNET-SECRET-NAMESPACE"
enable_automatic_dependency_updates: TRUE-OR-FALSE-VALUE
```

Where:

- `KP-DEFAULT-REPO` is a writable repository in your registry. Tanzu Build Service dependencies are written to this location. Examples:
    * Harbor has the form `kp_default_repository: "my-harbor.io/my-project/build-service"`
    * Dockerhub has the form `kp_default_repository: "my-dockerhub-user/build-service"` or `kp_default_repository: "index.docker.io/my-user/build-service"`
    * Google Cloud Registry has the form `kp_default_repository: "gcr.io/my-project/build-service"`
- `KP-DEFAULT-REPO-SECRET-NAME` is the name of the `kubernetes.io/dockerconfigjson` Secret containing credentials for `KP-DEFAULT-REPO`. You can write to this location with this credential.
- `KP-DEFAULT-REPO-SECRET-NAMESPACE` is the namespace of the `kubernetes.io/dockerconfigjson` Secret containing credentials for `KP-DEFAULT-REPO`. You can write to this location with this credential.
- `TANZUNET-SECRET-NAME` is the name of the `kubernetes.io/dockerconfigjson` Secret containing credentials for VMware Tanzu Network registry.
- `TANZUNET-SECRET-NAMESPACE` is the namespace of the `kubernetes.io/dockerconfigjson` Secret containing credentials for the VMware Tanzu Network registry.
- `DESCRIPTOR-NAME` is the name of the descriptor to import. For more information, see [Descriptors](tbs-about.html#descriptors). Available options are:
    * `lite` is the default if not set. It has a smaller footprint, which enables faster installations.
    * `full` is optimized to speed up builds and includes dependencies for all supported workload types.

## <a id="tap-install-full-deps"></a> Installing TBS or TAP with Full Dependencies

By default, TAP and TBS are installed with `lite` dependencies. See [here](dependencies.html#lite-vs-full-table) for a comparison of lite vs full dependencies.

Full dependencies must be installed separately from TAP. Follow these steps:

1. Follow the standard TAP profile instructions and when configuring the `tap-values.yaml`, use the following `buildservice` settings:

```yaml
buildservice:
  kp_default_repository: "KP-DEFAULT-REPO"
  kp_default_repository_username: "KP-DEFAULT-REPO-USERNAME"
  kp_default_repository_password: "KP-DEFAULT-REPO-PASSWORD"
  exclude_dependencies: true
```

2. Get the latest version of the buildservice package:

```console
tanzu package available list buildservice.tanzu.vmware.com --namespace tap-install
```

3. Relocate the TBS full dependencies package repository using the version from the previous step. This should be a similar command to the one used during TAP install:

```console
imgpkg copy -b registry.tanzu.vmware.com/tanzu-application-platform/full-tbs-deps-package-repo:${VERSION} --to-repo ${INSTALL_REGISTRY_HOSTNAME}/TARGET-REPOSITORY/tbs-full-deps
```

4. Add the TBS full dependencies package repository using the same version used in the previous step:

```console
tanzu package repository add tbs-full-deps-repository \
  --url ${INSTALL_REGISTRY_HOSTNAME}/TARGET-REPOSITORY/tbs-full-deps:${VERSION} \
  --namespace tap-install
```

5. Install the Full Dependencies package (no `values.yaml` needed):

```console
tanzu package install full-tbs-deps -p full-tbs-deps.tanzu.vmware.com -v $VERSION -n tap-install
```

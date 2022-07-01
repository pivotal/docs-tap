# Installing Tanzu Build Service

This topic describes how to install Tanzu Build Service from the Tanzu Application Platform
package repository by using the Tanzu CLI.

Use the instructions on this page if you do not want to use a Tanzu Application Platform
profile that includes Tanzu Build Service.
The Full, Iterate, and Build profiles include Tanzu Build Service.
For more information about profiles, see [About Tanzu Application Platform package and profiles](../about-package-profiles.md).

>**Note:** The following procedure might not include some configurations required for your environment.
>For advanced information about installing Tanzu Build Service, see the
>[Tanzu Build Service documentation](https://docs.vmware.com/en/VMware-Tanzu-Build-Service/index.html).
<!-- is it wise to send TAP users to the TBS docs without providing a specific location?
Are there parts of the standalone docs that won't apply to TAP users? Will they know what applies to
them or not? -->

## <a id='tbs-prereqs'></a> Prerequisites

Before installing Tanzu Build Service:

- Complete all prerequisites to install Tanzu Application Platform.
For more information, see [Prerequisites](../prerequisites.md).

- You must have access to a Docker registry that Tanzu Build Service can use to create builder images.
Approximately 10&nbsp;GB of registry space is required when using the full descriptor.

- Your Docker registry must be accessible with user name and password credentials.

<!-- my mind map for the install process: https://miro.com/app/board/uXjVOpbz808=/?share_link_id=338307648632 -->
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

    Where `VERSION-NUMBER` is the version of the package listed in the previous step.

1. Gather the values schema by running:

    <!-- this command seems to be the same as the one in the previous step. -->

    ```console
    tanzu package available get buildservice.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

1. Create a `tbs-values.yaml` file using the following template:

    ```yaml
    ---
    kp_default_repository: "KP-DEFAULT-REPO"
    kp_default_repository_username: "KP-DEFAULT-REPO-USERNAME"
    kp_default_repository_password: "KP-DEFAULT-REPO-PASSWORD"
    ```

    Where:

    - `KP-DEFAULT-REPO` is a writable repository in your registry.
    Tanzu Build Service dependencies are written to this location. Examples:
      - Harbor has the form `"my-harbor.io/my-project/build-service"`.
      - Dockerhub has the form `"my-dockerhub-user/build-service"` or `"index.docker.io/my-user/build-service"`.
      - Google Cloud Registry has the form `"gcr.io/my-project/build-service"`.
    - `KP-DEFAULT-REPO-USERNAME` is the name of the user who can write to `KP-DEFAULT-REPO`.
    You can write to this location with this credential.
      - For Google Cloud Registry, use `_json_key`.
    - `KP-DEFAULT-REPO-PASSWORD` is the password for the user that can write to `KP-DEFAULT-REPO`.
    You can write to this location with this credential.
    You can also configure this credential by using a Secret reference.
    For more information, see [Installation using Secret References for registry credentials](#install-secret-refs). <!-- can you also use AWS IAM Auth? >
      - For Google Cloud Registry, use the contents of the service account JSON file.

     >**Note:** TBS is bootstrapped with a set of dependencies.

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

1. (Optional) Verify the cluster builders that the Tanzu Build Service installation created by running:

    ```console
    tanzu package installed get tbs -n tap-install
    ```

### <a id='tbs-tcli-install-ecr'></a> Install Tanzu Build Service using AWS IAM Authentication

<!-- is this an alternative authentication method similar to secret refs? -->

Tanzu Build Service supports using AWS IAM roles to authenticate with
Amazon Elastic Container Registry (ECR) on Amazon Elastic Kubernetes Service (EKS) clusters.

1. Configure an AWS IAM role that has read and write access to the
`INSTALL_REGISTRY_HOSTNAME/TARGET-REPOSITORY` registry location to be used for installation.

1. Follow the standard Tanzu Application Platform installation documentation
<!-- can this be done after following the TBS install procedure above? -->
until the configuration of `tap-values.yaml` and use the following `buildservice` config: <!-- why is this in the tap-values.yaml not the tbs-values.yaml? -->

    ```yaml
    buildservice:
      kp_default_repository: "KP-DEFAULT-REPO"
      kp_default_repository_aws_iam_role_arn: "IAM-ROLE-ARN"
    ```

    Where:

    - `KP-DEFAULT-REPO` is a writable repository in your registry.
    Tanzu Build Service dependencies are written to this location.
    - `IAM-ROLE-ARN` is the AWS IAM role ARN for the role configured in the previous step.
    For example, `arn:aws:iam::xyz:role/my-install-role`.

### <a id='tbs-tcli-ecr-dev-ns'></a> Configuring the Developer Namespace for AWS IAM Authentication

<!-- does this need to be its own section? would you ever have to do this without having to do  Install Tanzu Build Service using AWS IAM Authentication? Would you ever have to do  Install Tanzu Build Service using AWS IAM Authentication without doing this? -->

The developer namespace requires configuration for Tanzu Application Service
to use AWS IAM authentication for ECR.

1. Configure an AWS IAM role that has read and write access to the registry location
where workload images will be stored.

1. Using the supply chain service account, `default` if unset, add an annotation
including the role ARN configured in step 1<!-- |earlier| or |later| is preferred instead of referring to the step number: numbers can change with edits. -->.

    ```console
    kubectl annotate serviceaccount -n <developer-namespace> <service-account-name> \
      eks.amazonaws.com/role-arn=${IAM-ROLE-ARN}
    ```

Where:

<!-- are <developer-namespace> <service-account-name>  also placeholders? -->
- `IAM-ROLE-ARN` is the AWS IAM role ARN for the role configured in step.
For example, `arn:aws:iam::xyz:role/my-developer-role`.

## <a id="tap-install-full-deps"></a> (Optional) Install Tanzu Build Service with full dependencies

<!-- consider location for installing full deps - maybe move to dependencies page.
Think about the order we want users to follow. -->

By default, Tanzu Build Service is installed with `lite` dependencies.
Full dependencies must be installed separately.
For a comparison of lite and full dependencies, see [Dependency comparison](dependencies.html#lite-vs-full-table).

To install full Tanzu Build Service dependencies:

1. Follow the standard Tanzu Application Platform profile instructions
<!-- link? At what point can users follow this procedure? can they update this after installing TAP?
Could this also be done after following the TBS install procedure above? -->
and when configuring the `tap-values.yaml`,
use the following `buildservice` settings: <!-- why is this in the tap-values.yaml not the tbs-values.yaml? -->

    ```yaml
    buildservice:
      kp_default_repository: "KP-DEFAULT-REPO"
      kp_default_repository_username: "KP-DEFAULT-REPO-USERNAME"
      kp_default_repository_password: "KP-DEFAULT-REPO-PASSWORD"
      exclude_dependencies: true
    ```

1. Get the latest version of the buildservice package by running:

    ```console
    tanzu package available list buildservice.tanzu.vmware.com --namespace tap-install
    ```

1. Relocate the Tanzu Build Service full dependencies package repository using the
version from the previous step.
This should<!-- Favour certainty, agency, and imperatives: |the app now works| over |the app should now work|. |VMware recommends| over |you should|. If an imperative, |do this| over |you should do this|.   --> be a similar command to the one used during Tanzu Application Platform install:

    ```console
    imgpkg copy -b registry.tanzu.vmware.com/tanzu-application-platform/full-tbs-deps-package-repo:${VERSION} --to-repo ${INSTALL_REGISTRY_HOSTNAME}/TARGET-REPOSITORY/tbs-full-deps
    ```

    Where:

    <!-- are these variables INSTALL_REGISTRY_HOSTNAME and VERSION set somewhere?
    should they be placeholders that users add manually? -->
    - `TARGET-REPOSITORY` is

4. Add the TBS full dependencies package repository using the same version used in the previous step<!-- Write |earlier in this procedure| or, if referring to a separate procedure, link to it. -->:

    ```console
    tanzu package repository add tbs-full-deps-repository \
      --url ${INSTALL_REGISTRY_HOSTNAME}/TARGET-REPOSITORY/tbs-full-deps:${VERSION} \
      --namespace tap-install
    ```

    Where:

    <!-- are these variables INSTALL_REGISTRY_HOSTNAME and VERSION set somewhere?
    should they be placeholders that users add manually? -->
    - `TARGET-REPOSITORY` is

5. Install the Full Dependencies package (no `values.yaml` needed):

    ```console
    tanzu package install full-tbs-deps -p full-tbs-deps.tanzu.vmware.com -v $VERSION -n tap-install
    ```

    <!-- is the variable VERSION set somewhere?
    should it be a placeholder that users add manually? -->

## <a id='tbs-tcli-install-offline'></a> Install Tanzu Build Service using the Tanzu CLI air-gapped

<!-- consider putting air-gapped install on new page -->

### <a id='tbs-offline-install-package'></a> Install Tanzu Build Service package

You can install Tanzu Build Service to a Kubernetes Cluster and registry that are
air-gapped from external traffic.

These steps assume that you have installed the Tanzu Application Platform packages
in your air-gapped environment.

To install the Tanzu Build Service package in an air-gapped environment:

1. Gather the values schema by running:

    ```console
    tanzu package available get buildservice.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the version of <!-- where should they get the version from? -->

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
    <!-- can users use secret refs or IAM instead? -->
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

### <a id='tbs-offline-install-dependencies<!-- Shorten the anchor ID to 25 characters or fewer. Use dashes instead of spaces or periods. -->'></a> Install Tanzu Build Service dependencies air-gapped

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

## <a id='install-secret-refs'></a> Installation using Secret references for registry credentials

<!-- can this be used with airgapped install -->

Tanzu Build Service requires credentials for the `kp_default_repository` and the Tanzu Network registry.

You can apply them in the `values.yaml` configuration directly in-line by using the
`kp_default_repository_username` `kp_default_repository_password` and
`tanzunet_username` `tanzunet_password` fields.

If you do not want credentials saved in ConfigMaps in plaintext, you can use Secret references in the
`values.yaml` configuration to use existing Secrets.

To use Secret references you must create Secrets of type `kubernetes.io/dockerconfigjson` containing
credentials for `kp_default_repository` and the VMware Tanzu Network registry.

Use the following alternative configuration for `values.yaml`: <!-- tbs-values.yaml? tap-values.yaml? -->

```yaml
---
kp_default_repository: "KP-DEFAULT-REPO"
kp_default_repository_secret:
  name: "KP-DEFAULT-REPO-SECRET-NAME"
  namespace: "KP-DEFAULT-REPO-SECRET-NAMESPACE"
tanzunet_secret:
  name: "TANZUNET-SECRET-NAME"
  namespace: "TANZUNET-SECRET-NAMESPACE"
enable_automatic_dependency_updates: AUTOMATIC-UPDATES
```

Where:

- `KP-DEFAULT-REPO` is a writable repository in your registry.
Tanzu Build Service dependencies are written to this location. Examples:
  - Harbor has the form `"my-harbor.io/my-project/build-service"`
  - Dockerhub has the form `"my-dockerhub-user/build-service"` or `"index.docker.io/my-user/build-service"`
  - Google Cloud Registry has the form `"gcr.io/my-project/build-service"`
- `KP-DEFAULT-REPO-SECRET-NAME` is the name of the `kubernetes.io/dockerconfigjson`
Secret containing credentials for `KP-DEFAULT-REPO`. You can write to this location with this credential.
- `KP-DEFAULT-REPO-SECRET-NAMESPACE` is the namespace of the `kubernetes.io/dockerconfigjson`
Secret containing credentials for `KP-DEFAULT-REPO`. You can write to this location with this credential.
- `TANZUNET-SECRET-NAME` is the name of the `kubernetes.io/dockerconfigjson`
Secret containing credentials for VMware Tanzu Network registry.
- `TANZUNET-SECRET-NAMESPACE` is the namespace of the `kubernetes.io/dockerconfigjson`
Secret containing credentials for the VMware Tanzu Network registry.
- `AUTOMATIC-UPDATES` is whether to enable automatic dependency updates.
The options for this value are `true` or `false`.

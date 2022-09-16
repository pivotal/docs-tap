# Installing Tanzu Build Service

This topic describes how to install Tanzu Build Service from the Tanzu Application Platform
package repository by using the Tanzu CLI.

Use this topic if you do not want to use a Tanzu Application Platform profile that includes
Tanzu Build Service.
The Full, Iterate, and Build profiles include Tanzu Build Service.
For more information about profiles, see [About Tanzu Application Platform components and profiles](../about-package-profiles.md).

>**Note:** The following procedure might not include some configurations required for your environment.
>For advanced information about installing Tanzu Build Service, see the
>[Tanzu Build Service documentation](https://docs.vmware.com/en/VMware-Tanzu-Build-Service/index.html).

## <a id='tbs-prereqs'></a> Prerequisites

Before installing Tanzu Build Service:

- Complete all prerequisites to install Tanzu Application Platform.
For more information, see [Prerequisites](../prerequisites.md).

- You must have access to a Docker registry that Tanzu Build Service can use to create builder images.
Approximately 10&nbsp;GB of registry space is required when using the `full` dependencies.

- Your Docker registry must be accessible with user name and password credentials.

## <a id='tbs-tcli-install'></a> Install the Tanzu Build Service package

To install Tanzu Build Service by using the Tanzu CLI:

1. Get the latest version of the Tanzu Build Service package by running:

    ```console
    tanzu package available list buildservice.tanzu.vmware.com --namespace tap-install
    ```

1. Gather the values schema by running:

    ```console
    tanzu package available get buildservice.tanzu.vmware.com/VERSION --values-schema --namespace tap-install
    ```

    Where `VERSION` is the version of the Tanzu Build Service package you retrieved in the previous step.

1. Create a `tbs-values.yaml` file using the following template:

    ```yaml
    ---
    kp_default_repository: "REPO-NAME"
    kp_default_repository_username: "REPO-USERNAME"
    kp_default_repository_password: "REPO-PASSWORD"
    ```

    Where:

    - `REPO-NAME` is a writable repository in your registry.
    Tanzu Build Service dependencies are written to this location. Examples:
      - Harbor has the form `"my-harbor.io/my-project/build-service"`.
      - Docker Hub has the form `"my-dockerhub-user/build-service"` or `"index.docker.io/my-user/build-service"`.
      - Google Cloud Registry has the form `"gcr.io/my-project/build-service"`.
    - `REPO-USERNAME` and `REPO-PASSWORD` are the user name
    and password for the user that can write to `REPO-NAME`.
    For Google Cloud Registry, use `_json_key` as the user name and the contents
    of the service account JSON file for the password.

        >**Note:** If you do not want to use plaintext for these credentials, you can configure them
        by using a Secret reference or by using AWS IAM authentication.
        >For more information, see [Use Secret References for registry credentials](#install-secret-refs)
        >or [Use AWS IAM authentication for registry credentials](#tbs-tcli-install-ecr).

1. (Optional) Tanzu Build Service is bootstrapped with the `lite` set of dependencies.
To configure `full` dependencies, add the key-value pair `exclude_dependencies: true`
to your `tbs-values.yaml` file. For example:

    ```yaml
    ---
    kp_default_repository: "REPO-NAME"
    kp_default_repository_username: "REPO-USERNAME"
    kp_default_repository_password: "REPO-PASSWORD"
    exclude_dependencies: true
    ```

    For more information about the differences between `full` and `lite` dependencies, see
    [About lite and full dependencies](dependencies.md#lite-vs-full).

1. Install the Tanzu Build Service package by running:

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

1. (Optional) Verify the cluster builders that the Tanzu Build Service installation created by running:

    ```console
    tanzu package installed get tbs -n tap-install
    ```

1. If you configured `full` dependencies in your `tbs-values.yaml` file, install the `full` dependencies
by following the procedure in [Install full dependencies](#tap-install-full-deps).

## <a id='alternative-creds'></a> (Optional) Alternatives to plaintext registry credentials

Tanzu Build Service requires credentials for the `kp_default_repository` and the Tanzu Network registry.

You can apply them directly in-line in plaintext in the `tbs-values.yaml` or `tap-values.yaml`
configuration by using the `kp_default_repository_username`, `kp_default_repository_password`, `tanzunet_username`,
and `tanzunet_password` fields.

If you do not want credentials saved in plaintext, you can use existing Secrets or IAM roles by using
[Secret references](#install-secret-refs) or [AWS IAM authentication](#tbs-tcli-install-ecr)
in your `tbs-values.yaml` or `tap-values.yaml`.

### <a id='install-secret-refs'></a> Use Secret references for registry credentials

To use Secret references:

1. Create a Secret of type `kubernetes.io/dockerconfigjson` containing
credentials for the writable repository in your registry (`kp_default_repository`)
and the VMware Tanzu Network registry.

1. Use the following alternative configuration for `tbs-values.yaml`:

    >**Note:** if you installed Tanzu Build Service as part of a Tanzu Application Platform
    >profile, you configure this in your `tap-values.yaml` file under the `buildservice` section.

    ```yaml
    ---
    kp_default_repository: "REPO-NAME"
    kp_default_repository_secret:
      name: "REPO-SECRET-NAME"
      namespace: "REPO-SECRET-NAMESPACE"
    tanzunet_secret:
      name: "TANZU-NET-SECRET-NAME"
      namespace: "TANZU-NET-SECRET-NAMESPACE"
    ```

    Where:

    - `REPO-NAME` is a writable repository in your registry.
    Tanzu Build Service dependencies are written to this location. Examples:
      - Harbor has the form `"my-harbor.io/my-project/build-service"`
      - Docker Hub has the form `"my-dockerhub-user/build-service"` or `"index.docker.io/my-user/build-service"`
      - Google Cloud Registry has the form `"gcr.io/my-project/build-service"`
    - `REPO-SECRET-NAME` is the name of the `kubernetes.io/dockerconfigjson`
    Secret containing credentials for `REPO-NAME`. You can write to this location with this credential.
    - `REPO-SECRET-NAMESPACE` is the namespace of the `kubernetes.io/dockerconfigjson`
    Secret containing credentials for `REPO-NAME`. You can write to this location with this credential.
    - `TANZU-NET-SECRET-NAME` is the name of the `kubernetes.io/dockerconfigjson`
    Secret containing credentials for VMware Tanzu Network registry.
    - `TANZU-NET-SECRET-NAMESPACE` is the namespace of the `kubernetes.io/dockerconfigjson`
    Secret containing credentials for the VMware Tanzu Network registry.

1. Apply this configuration by continuing the steps in [Install the Tanzu Build Service package](#tbs-tcli-install).

### <a id='tbs-tcli-install-ecr'></a> Use AWS IAM authentication for registry credentials

Tanzu Build Service supports using AWS IAM roles to authenticate with
Amazon Elastic Container Registry (ECR) on Amazon Elastic Kubernetes Service (EKS) clusters.

To use AWS IAM authentication:

1. Configure an AWS IAM role that has read and write access to the repository in the container
registry used when installing Tanzu Application Platform.

1. Use the following alternative configuration for `tbs-values.yaml`:

    >**Note:** if you installed Tanzu Build Service as part of a Tanzu Application Platform
    >profile, you configure this in your `tap-values.yaml` file under the `buildservice` section.

    ```yaml
    ---
      kp_default_repository: "REPO-NAME"
      kp_default_repository_aws_iam_role_arn: "IAM-ROLE-ARN"
    ```

    Where:

    - `REPO-NAME` is a writable repository in your registry.
    Tanzu Build Service dependencies are written to this location.
    - `IAM-ROLE-ARN` is the AWS IAM role Amazon Resource Name (ARN) for the role configured in the previous step.
    For example, `arn:aws:iam::xyz:role/my-install-role`.

1. The developer namespace requires configuration for Tanzu Application Platform
to use AWS IAM authentication for ECR.
Configure an AWS IAM role that has read and write access to the registry location
where workload images will be stored.

1. Using the supply chain service account, add an annotation including the role
ARN configured earlier by running:

    ```console
    kubectl annotate serviceaccount -n DEVELOPER-NAMESPACE SERVICE-ACCOUNT-NAME \
      eks.amazonaws.com/role-arn=IAM-ROLE-ARN
    ```

    Where:

    - `DEVELOPER-NAMESPACE` is the namespace where workloads are created.
    - `SERVICE-ACCOUNT-NAME` is the supply chain service account. This is `default` if unset.
    - `IAM-ROLE-ARN` is the AWS IAM role ARN for the role configured earlier.
    For example, `arn:aws:iam::xyz:role/my-developer-role`.

1. Apply this configuration by continuing the steps in [Install the Tanzu Build Service package](#tbs-tcli-install).

## <a id="tap-install-full-deps"></a> Install full dependencies

If you configured `full` dependencies in your `tbs-values.yaml` file, you must
install the `full` dependencies package.

For a more information about `lite` and `full` dependencies, see [About lite and full dependencies](dependencies.md#lite-vs-full).

To install `full` Tanzu Build Service dependencies:

1. If you have not done so already, add the key-value pair `exclude_dependencies: true`
 to your `tbs-values.yaml` file. For example:

    >**Note:** if you installed Tanzu Build Service as part of a Tanzu Application Platform
    >profile, you configure this in your `tap-values.yaml` file under the `buildservice` section.

    ```yaml
    ---
      kp_default_repository: "REPO-NAME"
      kp_default_repository_username: "REPO-USERNAME"
      kp_default_repository_password: "REPO-PASSWORD"
      exclude_dependencies: true
    ```

1. Get the latest version of the Tanzu Build Service package by running:

    ```console
    tanzu package available list buildservice.tanzu.vmware.com --namespace tap-install
    ```

1. Relocate the Tanzu Build Service `full` dependencies package repository by running:

    ```console
    imgpkg copy -b registry.tanzu.vmware.com/tanzu-application-platform/full-tbs-deps-package-repo:VERSION \
    --to-repo INSTALL-REGISTRY-HOSTNAME/TARGET-REPOSITORY/tbs-full-deps
    ```

    Where:

    - `VERSION` is the version of the Tanzu Build Service package you retrieved in the previous step.
    - `INSTALL-REGISTRY-HOSTNAME` is your container registry.
    - `TARGET-REPOSITORY` is your target repository.

1. Add the TBS `full` dependencies package repository by running:

    ```console
    tanzu package repository add tbs-full-deps-repository \
      --url INSTALL-REGISTRY-HOSTNAME/TARGET-REPOSITORY/tbs-full-deps:VERSION \
      --namespace tap-install
    ```

    Where:

    - `VERSION` is the version of the Tanzu Build Service package you retrieved earlier.
    - `INSTALL-REGISTRY-HOSTNAME` is your container registry.
    - `TARGET-REPOSITORY` is your target repository.

1. Install the `full` dependencies package by running:

    ```console
    tanzu package install full-tbs-deps -p full-tbs-deps.tanzu.vmware.com -v VERSION -n tap-install
    ```

    Where `VERSION` is the version of the Tanzu Build Service package you retrieved earlier.

## <a id="auto-updates-config"></a> (Optional) Configure automatic dependency updates

>**Important:** The automatic updates feature is being deprecated.
>The recommended way to patch dependencies is by upgrading Tanzu Application Platform
>to the latest patch version. For upgrade instructions, see [Upgrading Tanzu Application Platform](../upgrading.md).

You can configure Tanzu Build Service to update dependencies in the background as they are released.
This enables workloads to keep up to date automatically.
For more information about automatic dependency updates, see [About automatic dependency updates (deprecated)](dependencies.md#deprecated-auto-updates).

To configure automatic dependency updates, add the following to the contents of your `tbs-values.yaml`:

>**Note:** if you installed Tanzu Build Service as part of a Tanzu Application Platform
>profile, you configure this in your `tap-values.yaml` file under the `buildservice` section.

```yaml
  tanzunet_username: TANZU-NET-USERNAME
  tanzunet_password: TANZU-NET-PASSWORD
  descriptor_name: DESCRIPTOR-NAME
  enable_automatic_dependency_updates: true
```

Where:

- `TANZU-NET-USERNAME` and `TANZU-NET-PASSWORD` are the email address and password
to log in to VMware Tanzu Network.
You can also configure these credentials by using a secret reference.
For more information, see [Use Secret references for registry credentials](#install-secret-refs).
- `DESCRIPTOR-NAME` is the name of the descriptor to import.
For more information, see [Descriptors](#descriptors).
Available options are:
  - `lite` is the default if not set. It has a smaller footprint, which enables faster installations.
  - `full` is optimized to speed up builds and includes dependencies for all supported workload types.

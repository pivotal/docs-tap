# Install Tanzu Build Service

This topic describes how to install Tanzu Build Service from the Tanzu Application Platform
package repository by using the Tanzu CLI.

## Before you begin

Use this topic if you do not want to use a Tanzu Application Platform profile that includes
Tanzu Build Service. The Full, Iterate, and Build profiles include Tanzu Build Service.
For more information about profiles, see [Components and installation profiles](../about-package-profiles.md).

The following procedure might not include some configurations required for your environment.
For advanced information about installing Tanzu Build Service, see the
[Tanzu Build Service documentation](https://docs.vmware.com/en/VMware-Tanzu-Build-Service/index.html).

## <a id='tbs-prereqs'></a> Prerequisites

Before installing Tanzu Build Service:

- Complete all prerequisites to install Tanzu Application Platform.
For more information, see [Prerequisites](../prerequisites.md).

- You must have access to a Docker registry that Tanzu Build Service can use to create builder images.
Approximately 10&nbsp;GB of registry space is required when using the `full` dependencies.

- Your Docker registry must be accessible with user name and password credentials.

## <a id='deprecated-features'></a> Deprecated Features

- **Automatic dependency updates:** For more information, see [Configure automatic dependency updates](#auto-updates-config).
- **The Cloud Native Buildpack Bill of Materials (CNB BOM) format:** For more information, see [Deactivate the CNB BOM format](#deactivate-cnb-bom).

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

    Where `VERSION` is the version of the Tanzu Build Service package you retrieved earlier in this procedure.

2. Create the secret for the `kp-default-repository` credentials using the `tanzu` cli:

    ```
    tanzu secret registry add kp-default-repository-creds \
      --server "${REGISTRY-HOSTNAME}" \
      --username "${REGISTRY-USERNAME}" \
      --password "${REGISTRY-PASSWORD}" \
      --namespace tap-install
    ```
   
    Where:
    - `REGISTRY-HOST` is the host name for the registry that contains your `kp_default_repository`. 
       For example:
        - Harbor has the form `server: "my-harbor.io"`.
        - Docker Hub has the form `server: "index.docker.io"`.
        - Google Cloud Registry has the form `server: "gcr.io"`.
    - `REGISTRY-USERNAME` and `REGISTRY-PASSWORD` are the user name
      and password for the user that can write to the repository used in the following step.
      For Google Cloud Registry, use `_json_key` as the user name and the contents
      of the service account JSON file for the password.

1. Create a `tbs-values.yaml` file using the following template.
   If `shared.image_registry.project_path` and `shared.image_registry.secret` are configured in the
   `tap-values.yaml` file, Tanzu Build Service inherits all three values in that section.
   This can be disabled by setting any of the following three values.

    ```yaml
    ---
    kp_default_repository: "REPO-NAME"
    kp_default_repository_secret:
      name: kp-default-repository-creds
      namespace: tap-install
    ```

    Where:
    - `REPO-NAME` is a writable repository in your registry.
    Tanzu Build Service dependencies are written to this location. Examples:
      - Harbor has the form `"my-harbor.io/my-project/build-service"`.
      - Docker Hub has the form `"my-dockerhub-user/build-service"` or `"index.docker.io/my-user/build-service"`.
      - Google Cloud Registry has the form `"gcr.io/my-project/build-service"`.

4. If you are running on OpenShift, add `kubernetes_distribution: openshift` to your `tbs-values.yaml` file.

5. (Optional) Under the `ca_cert_data` key in the `tbs-values.yaml` file,
provide a PEM-encoded CA certificate for Tanzu Build Service.
This certificate is used for accessing the container image registry and is also provided to the build process.

    > **Note** If `shared.ca_cert_data` is configured in the `tap-values.yaml` file,
    > Tanzu Build Service inherits that value.
    >
    > Configuring `ca_cert_data` key in the `tbs-values.yaml` file adds the CA certificates at build time.
    > To add CA certificates to the built image, see
    > [Configure custom CA certificates for a single workload using service bindings](tbs-workload-config.md#custom-cert-single-workload).

    For example:

    ```yaml
    ---
    kp_default_repository: "REPO-NAME"
    kp_default_repository_secret:
      name: kp-default-repository-creds
      namespace: tap-install
    ca_cert_data: |
      -----BEGIN CERTIFICATE-----
      ...
      -----END CERTIFICATE-----
    ```

1. (Optional) Tanzu Build Service is bootstrapped with the `lite` set of dependencies.
To configure `full` dependencies, add the key-value pair `exclude_dependencies: true`
to your `tbs-values.yaml` file. This is to exclude the default `lite` dependencies from the installation. For example:

    ```yaml
    ---
    kp_default_repository: "REPO-NAME"
    kp_default_repository_secret:
      name: kp-default-repository-creds
      namespace: tap-install
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

2. (Optional) Verify the cluster builders that the Tanzu Build Service installation created by running:

    ```console
    tanzu package installed get tbs -n tap-install
    ```

3. If you configured `full` dependencies in your `tbs-values.yaml` file, install the `full` dependencies
by following the procedure in [Install full dependencies](#tap-install-full-deps).

### <a id='tbs-tcli-install-ecr'></a> Use AWS IAM authentication for registry credentials

Tanzu Build Service supports using AWS IAM roles to authenticate with
Amazon Elastic Container Registry (ECR) on Amazon Elastic Kubernetes Service (EKS) clusters.

To use AWS IAM authentication:

1. Configure an AWS IAM role that has read and write access to the repository in the container image
registry used when installing Tanzu Application Platform.

1. Use the following alternative configuration for `tbs-values.yaml`:

    >**Note** if you are installing Tanzu Build Service as part of a Tanzu Application Platform
    >profile, you configure this in your `tap-values.yaml` file under the `buildservice` section.

    ```yaml
    ---
      kp_default_repository: "REPO-NAME"
      kp_default_repository_aws_iam_role_arn: "IAM-ROLE-ARN"
    ```

    Where:

    - `REPO-NAME` is a writable repository in your registry.
    Tanzu Build Service dependencies are written to this location.
    - `IAM-ROLE-ARN` is the AWS IAM role Amazon Resource Name (ARN) for the role configured earlier in this procedure.
    For example, `arn:aws:iam::xyz:role/my-install-role`.

1. The developer namespace requires configuration for Tanzu Application Platform
to use AWS IAM authentication for ECR.
Configure an AWS IAM role that has read and write access to the registry for storing workload images.

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

    >**Note** if you are installing Tanzu Build Service as part of a Tanzu Application Platform
    >profile, you configure this in your `tap-values.yaml` file under the `buildservice` section.

    ```yaml
    ---
      kp_default_repository: "REPO-NAME"
      kp_default_repository_secret:
        name: kp-default-repository-creds
        namespace: tap-install
      exclude_dependencies: true
    ```
 
1. If you have not updated your package install after adding the `exclude_dependencies: true` to your values file, you must perform the update by running:

    ```console
    tanzu package installed update  APP-NAME --namespace tap-install --values-file PATH-TO-UPDATED-VALUES
    ```

1. Get the latest version of the Tanzu Application Platform package by running:

    ```console
    tanzu package available list tap.tanzu.vmware.com --namespace tap-install
    ```

1. Relocate the Tanzu Build Service `full` dependencies package repository by running:

    ```console
    imgpkg copy -b registry.tanzu.vmware.com/tanzu-application-platform/full-deps-package-repo:VERSION \
    --to-repo INSTALL-REGISTRY-HOSTNAME/TARGET-REPOSITORY/tbs-full-deps
    ```

    Where:

    - `VERSION` is the version of the Tanzu Build Service package you retrieved earlier in this procedure.
    - `INSTALL-REGISTRY-HOSTNAME` is your container image registry.
    - `TARGET-REPOSITORY` is your target repository.

2. Add the Tanzu Build Service  `full` dependencies package repository by running:

    ```console
    tanzu package repository add tbs-full-deps-repository \
      --url INSTALL-REGISTRY-HOSTNAME/TARGET-REPOSITORY/full-deps:VERSION \
      --namespace tap-install
    ```

    Where:

    - `VERSION` is the version of the Tanzu Build Service package you retrieved earlier.
    - `INSTALL-REGISTRY-HOSTNAME` is your container image registry.
    - `TARGET-REPOSITORY` is your target repository.

3. Install the `full` dependencies package by running:

    ```console
    tanzu package install full-tbs-deps -p full-deps.buildservice.tanzu.vmware.com -v "> 0.0.0" -n tap-install --values-file PATH-TO-TBS-OR-TAP-VALUES-FILE
    ```

## <a id='deactivate-cnb-bom'></a> (Optional) Deactivate the CNB BOM format

The legacy CNB BOM format is deprecated, but is enabled by default in Tanzu Application Platform.

To manually deactivate the format, add `include_legacy_bom=false` to either the `tbs-values.yaml` file,
or to the `tap-values.yaml` file under the `buildservice` section.

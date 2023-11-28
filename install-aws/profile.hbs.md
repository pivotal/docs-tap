# Install Tanzu Application Platform package and profiles on AWS

This topic tells you how to install Tanzu Application Platform (commonly known as TAP)
packages from your Tanzu Application Platform package repository on to AWS.

Before installing the packages, ensure you have:

- Completed the [Prerequisites](../prerequisites.hbs.md).
- Created [AWS Resources](resources.hbs.md).
- [Accepted Tanzu Application Platform EULA and installed Tanzu CLI](../install-tanzu-cli.hbs.md) with any required plug-ins.
- Installed [Cluster Essentials for Tanzu](https://{{ vars.staging_toggle }}.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/deploy.html).

## <a id='relocate-images'></a> Relocate images to a registry

VMware recommends relocating the images from VMware Tanzu Network registry to your own container image registry before
attempting installation. If you don't relocate the images, Tanzu Application Platform will depend on
VMware Tanzu Network for continued operation, and VMware Tanzu Network offers no uptime guarantees.
The option to skip relocation is documented for evaluation and proof-of-concept only.

This section describes how to relocate images to the `tap-images` repository created in [Amazon ECR](https://aws.amazon.com/ecr/).
See [Creating AWS Resources](resources.hbs.md) for more information.

To relocate images from the VMware Tanzu Network registry to the ECR registry:

1. Set up environment variables for installation use by running:

    ```console
    export AWS_ACCOUNT_ID=MY-AWS-ACCOUNT-ID
    export AWS_REGION=TARGET-AWS-REGION

    # Set tanzunet as the source registry to copy the Tanzu Application Platform packages from.
    export IMGPKG_REGISTRY_HOSTNAME_0=registry.tanzu.vmware.com
    export IMGPKG_REGISTRY_USERNAME_0=MY-TANZUNET-USERNAME
    export IMGPKG_REGISTRY_PASSWORD_0=MY-TANZUNET-PASSWORD

    # The user’s registry for copying the Tanzu Application Platform package to.
    export IMGPKG_REGISTRY_HOSTNAME_1=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
    export IMGPKG_REGISTRY_USERNAME_1=AWS
    export IMGPKG_REGISTRY_PASSWORD_1=`aws ecr get-login-password --region $AWS_REGION`
    # These environment variables starting with IMGPKG_* are used by the imgpkg command only.

    # The registry from which the Tanzu Application Platform package is retrieved.
    export INSTALL_REGISTRY_HOSTNAME=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
    export TAP_VERSION=VERSION-NUMBER
    export INSTALL_REPO=tap-images
    ```

    Where:

    - `MY-AWS-ACCOUNT-ID` is the account ID you deploy Tanzu Application Platform in. No dashes and must be in the format `012345678901`.
    - `MY-TANZUNET-USERNAME` is the user with access to the images in the VMware Tanzu Network registry `registry.tanzu.vmware.com`
    - `MY-TANZUNET-PASSWORD` is the password for `MY-TANZUNET-USERNAME`.
    - `TARGET-AWS-REGION` is the region you deploy the Tanzu Application Platform to.
    - `VERSION-NUMBER` is your Tanzu Application Platform version. For example, `{{ vars.tap_version }}`

1. [Install the Carvel tool imgpkg CLI](https://{{ vars.staging_toggle }}.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/deploy.html#optionally-install-clis-onto-your-path).

1. Relocate the images with the `imgpkg` CLI by running:

    ```console
    imgpkg copy --concurrency 1 -b registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:${TAP_VERSION} --to-repo ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REPO}
    ```

## <a id='add-tap-repo'></a> Add the Tanzu Application Platform package repository

Tanzu CLI packages are available on repositories. Adding the Tanzu Application Platform package repository makes Tanzu Application Platform and its packages available for installation.

[Relocate images to a registry](#relocate-images) is strongly recommended but not required for installation. If you skip this step, you can use the following values to replace the corresponding variables:

- `INSTALL_REGISTRY_HOSTNAME` is `registry.tanzu.vmware.com`
- `INSTALL_REPO` is `tanzu-application-platform`
- `INSTALL_REGISTRY_USERNAME` and `INSTALL_REGISTRY_PASSWORD` are the credentials to the VMware Tanzu Network registry `registry.tanzu.vmware.com`
- `TAP_VERSION` is your Tanzu Application Platform version. For example, `{{ vars.tap_version }}`

To add the Tanzu Application Platform package repository to your cluster:

1. Create a namespace called `tap-install` for deploying any component packages by running:

    ```console
    kubectl create ns tap-install
    ```

    This namespace keeps the objects grouped together logically.

1. Create a registry secret by running:

    ```console
    tanzu secret registry add tap-registry \
      --username ${INSTALL_REGISTRY_USERNAME} --password ${INSTALL_REGISTRY_PASSWORD} \
      --server ${INSTALL_REGISTRY_HOSTNAME} \
      --export-to-all-namespaces --yes --namespace tap-install
    ```

1. Add the Tanzu Application Platform package repository to the cluster by running:

    ```console
    tanzu package repository add tanzu-tap-repository \
      --url ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REPO}:${TAP_VERSION} \
      --namespace tap-install
    ```

1. Get the status of the Tanzu Application Platform package repository, and ensure the status updates to `Reconcile succeeded` by running:

    ```console
    tanzu package repository get tanzu-tap-repository --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package repository get tanzu-tap-repository --namespace tap-install
    - Retrieving repository tap...
    NAME:          tanzu-tap-repository
    VERSION:       16253001
    REPOSITORY:    123456789012.dkr.ecr.us-west-2.amazonaws.com/tap-images
    TAG:           {{ vars.tap_version }}
    STATUS:        Reconcile succeeded
    REASON:
    ```

1. List the available packages by running:

    ```console
    tanzu package available list --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list --namespace tap-install
      NAME                                                 DISPLAY-NAME
      accelerator.apps.tanzu.vmware.com                    Application Accelerator for VMware Tanzu
      amr-observer.apps.tanzu.vmware.com                   Supply Chain Security Tools - AMR Observer
      api-portal.tanzu.vmware.com                          API portal
      apis.apps.tanzu.vmware.com                           API Auto Registration for VMware Tanzu
      apiserver.appliveview.tanzu.vmware.com               Application Live View ApiServer for VMware Tanzu
      app-scanning.apps.tanzu.vmware.com                   Supply Chain Security Tools - App Scanning (Alpha)
      application-configuration-service.tanzu.vmware.com   Application Configuration Service
      backend.appliveview.tanzu.vmware.com                 Application Live View for VMware Tanzu
      base-jammy-builder-lite.buildpacks.tanzu.vmware.com  base-jammy-builder-lite
      base-jammy-stack-lite.buildpacks.tanzu.vmware.com    base-jammy-stack
      bitnami.services.tanzu.vmware.com                    bitnami-services
      buildservice.tanzu.vmware.com                        Tanzu Build Service
      carbonblack.scanning.apps.tanzu.vmware.com           VMware Carbon Black for Supply Chain Security Tools - Scan
      cartographer.tanzu.vmware.com                        Cartographer
      cnrs.tanzu.vmware.com                                Cloud Native Runtimes
      connector.appliveview.tanzu.vmware.com               Application Live View Connector for VMware Tanzu
      controller.source.apps.tanzu.vmware.com              Tanzu Source Controller
      conventions.appliveview.tanzu.vmware.com             Application Live View Conventions for VMware Tanzu
      crossplane.tanzu.vmware.com                          crossplane
      developer-conventions.tanzu.vmware.com               Tanzu App Platform Developer Conventions
      dotnet-core-lite.buildpacks.tanzu.vmware.com         dotnet-core-lite
      external-secrets.apps.tanzu.vmware.com               External Secrets Operator
      fluxcd.source.controller.tanzu.vmware.com            Flux Source Controller
      go-lite.buildpacks.tanzu.vmware.com                  go-lite
      grype.scanning.apps.tanzu.vmware.com                 Grype for Supply Chain Security Tools - Scan
      java-lite.buildpacks.tanzu.vmware.com                java-lite
      java-native-image-lite.buildpacks.tanzu.vmware.com   java-native-image-lite
      local-source-proxy.apps.tanzu.vmware.com             Local Source Proxy
      metadata-store.apps.tanzu.vmware.com                 Supply Chain Security Tools - Store
      namespace-provisioner.apps.tanzu.vmware.com          Namespace Provisioner
      nodejs-lite.buildpacks.tanzu.vmware.com              nodejs-lite
      ootb-delivery-basic.tanzu.vmware.com                 Tanzu App Platform Out of The Box Delivery Basic
      ootb-supply-chain-basic.tanzu.vmware.com             Tanzu App Platform Out of The Box Supply Chain Basic
      ootb-supply-chain-testing-scanning.tanzu.vmware.com  Tanzu App Platform Out of The Box Supply Chain with Testing and Scanning
      ootb-supply-chain-testing.tanzu.vmware.com           Tanzu App Platform Out of The Box Supply Chain with Testing
      ootb-templates.tanzu.vmware.com                      Tanzu App Platform Out of The Box Templates
      policy.apps.tanzu.vmware.com                         Supply Chain Security Tools - Policy Controller
      python-lite.buildpacks.tanzu.vmware.com              python-lite
      ruby-lite.buildpacks.tanzu.vmware.com                ruby-lite
      scanning.apps.tanzu.vmware.com                       Supply Chain Security Tools - Scan
      service-bindings.labs.vmware.com                     Service Bindings for Kubernetes
      services-toolkit.tanzu.vmware.com                    Services Toolkit
      snyk.scanning.apps.tanzu.vmware.com                  Snyk for Supply Chain Security Tools - Scan
      spring-boot-conventions.tanzu.vmware.com             Tanzu Spring Boot Conventions Server
      spring-cloud-gateway.tanzu.vmware.com                Spring Cloud Gateway
      sso.apps.tanzu.vmware.com                            AppSSO
      tap-auth.tanzu.vmware.com                            Default roles for Tanzu Application Platform
      tap-gui.tanzu.vmware.com                             Tanzu Developer Portal
      tap-telemetry.tanzu.vmware.com                       Telemetry Collector for Tanzu Application Platform
      tap.tanzu.vmware.com                                 Tanzu Application Platform
      tekton.tanzu.vmware.com                              Tekton Pipelines
      tpb.tanzu.vmware.com                                 Tanzu Portal Builder
      web-servers-lite.buildpacks.tanzu.vmware.com         web-servers-lite
    ```

## <a id='install-profile'></a> Install your Tanzu Application Platform profile

The `tap.tanzu.vmware.com` package installs predefined sets of packages based on your profile settings.
This is done by using the package manager installed by Tanzu Cluster Essentials.

For more information about profiles, see [Components and installation profiles](../about-package-profiles.md).

To prepare to install a profile:

1. List version information for the package by running:

    ```console
    tanzu package available list tap.tanzu.vmware.com --namespace tap-install
    ```

1. Create a `tap-values.yaml` file by using the [Full Profile (AWS)](#full-profile),
which contains the minimum configurations required to deploy Tanzu Application Platform on AWS.
The sample values file contains the necessary defaults for:

    - The meta-package, or parent Tanzu Application Platform package.
    - Subordinate packages, or individual child packages.

    Keep the values file for future configuration use.

    >**Note** `tap-values.yaml` is set as a Kubernetes secret, which provides secure means to read credentials for Tanzu Application Platform components.

1. [View possible configuration settings for your package](view-package-config.hbs.md)

### <a id='full-profile'></a> Full profile (AWS)

The following command generates the YAML file sample for the full-profile on AWS by using the ECR repositories you created earlier.
The `profile:` field takes `full` as the default value, but you can also set it to `iterate`, `build`, `run`, or `view`.
Refer to [Install multicluster Tanzu Application Platform profiles](../multicluster/installing-multicluster.html) for more information.

```console
cat << EOF > tap-values.yaml
shared:
  ingress_domain: "INGRESS-DOMAIN"

ceip_policy_disclosed: true

# The above keys are minimum numbers of entries needed in tap-values.yaml to get a functioning TAP Full profile installation.

# Below are the keys which may have default values set, but can be overridden.

profile: full # Can take iterate, build, run, view.

excluded_packages:
- policy.apps.tanzu.vmware.com

supply_chain: basic # Can take testing, testing_scanning.

ootb_supply_chain_basic: # Based on supply_chain set above, can be changed to ootb_supply_chain_testing, ootb_supply_chain_testing_scanning.
  registry:
    server: ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
    # The prefix of the ECR repository.  Workloads will need
    # two repositories created:
    #
    # tanzu-application-platform/<workloadname>-<namespace>
    # tanzu-application-platform/<workloadname>-<namespace>-bundle
    repository: tanzu-application-platform

contour:
  envoy:
    service:
      type: LoadBalancer # This is set by default, but can be overridden by setting a different value.

buildservice:
  kp_default_repository: ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/tap-build-service
  # Enable the build service k8s service account to bind to the AWS IAM Role
  kp_default_repository_aws_iam_role_arn: "arn:aws:iam::${AWS_ACCOUNT_ID}:role/tap-build-service"

local_source_proxy:
  # Takes the value from the project_path under the image_registry section of shared by default, but can be overridden by setting a different value.
  repository: "EXTERNAL-REGISTRY-FOR-LOCAL-SOURCE"
  push_secret:
    # When set to true, the secret mentioned in this section is automatically exported to Local Source Proxy's namespace.
    name: "EXTERNAL-REGISTRY-FOR-LOCAL-SOURCE-SECRET"
    namespace: "EXTERNAL-REGISTRY-FOR-LOCAL-SOURCE-SECRET-NAMESPACE"
    # When set to true, the secret mentioned in this section is automatically exported to Local Source Proxy's namespace.
    create_export: true

ootb_templates:
  # Enable the config writer service to use cloud based iaas authentication
  # which are retrieved from the developer namespace service account by
  # default
  iaas_auth: true

tap_gui:
  app_config:
    auth:
      allowGuestAccess: true  # This allows unauthenticated users to log in to your portal. If you want to deactivate it, make sure you configure an alternative auth provider.
    catalog:
      locations:
        - type: url
          target: https://GIT-CATALOG-URL/catalog-info.yaml

metadata_store:
  ns_for_export_app_cert: "MY-DEV-NAMESPACE" # Verify this namespace is available within your cluster before initiating the Tanzu Application Platform installation.
  app_service_type: ClusterIP # Defaults to LoadBalancer. If shared.ingress_domain is set earlier, this must be set to ClusterIP.

namespace_provisioner:
  aws_iam_role_arn: "arn:aws:iam::${AWS_ACCOUNT_ID}:role/tap-workload"

tap_telemetry:
  customer_entitlement_account_number: "CUSTOMER-ENTITLEMENT-ACCOUNT-NUMBER" # (Optional) Identify data for creating Tanzu Application Platform usage reports.
EOF
```

Where:

- `INGRESS-DOMAIN` is the subdomain for the host name that you point at the `tanzu-shared-ingress`
service's External IP address.
- `kp_default_repository_aws_iam_role_arn` is the ARN that was created to write to the ECR repository for the build service. This value is generated by the script, but you can modify it manually.
- `namspace_provisioner.aws_iam_role_arn` is the ARN that was created to write to the ECR repository for workloads. This value is generated by the script, but you can modify it manually.
- `EXTERNAL-REGISTRY-FOR-LOCAL-SOURCE` is where the developer's local source is uploaded when using
  Tanzu CLI to use Local Source Proxy for workload creation.

  If an AWS ECR registry is being used, ensure that the repository already exists.
  AWS ECR expects the repository path to already exist. This destination is represented as
  `REGISTRY-SERVER/REPOSITORY-PATH`. For more information, see
  [Install Local Source Proxy](../local-source-proxy/install.hbs.md).

- `EXTERNAL-REGISTRY-FOR-LOCAL-SOURCE-SECRET` is the name of the secret with credentials that allow
  pushing to the `EXTERNAL-REGISTRY-FOR-LOCAL-SOURCE` repository.
- `EXTERNAL-REGISTRY-FOR-LOCAL-SOURCE-SECRET-NAMESPACE` is the namespace in which
  `EXTERNAL-REGISTRY-FOR-LOCAL-SOURCE-SECRET` is available.
- `GIT-CATALOG-URL` is the path to the `catalog-info.yaml` catalog definition file. You can download either a blank or populated catalog file from the [Tanzu Application Platform product page](https://network.pivotal.io/products/tanzu-application-platform/#/releases/1239018). Otherwise, you can use a Backstage-compliant catalog you've already built and posted on the Git infrastructure.
- `MY-DEV-NAMESPACE` is the name of the developer namespace. SCST - Store exports secrets to the namespace, and SCST - Scan deploys the `ScanTemplates` there. This allows the scanning feature to run in this namespace. If there are multiple developer namespaces, use `ns_for_export_app_cert: "*"` to export the SCST - Store CA certificate to all namespaces.
- `CUSTOMER-ENTITLEMENT-ACCOUNT-NUMBER` (optional) refers to the Entitlement Account Number (EAN), which is a unique identifier VMware assigns to its customers. Tanzu Application Platform telemetry uses this number to identify data that belongs to a particular customers and prepare usage reports. See [Kubernetes Grid documentation](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/1.5/vmware-tanzu-kubernetes-grid-15/GUID-cluster-lifecycle-ceip.html#identify-the-entitlement-account-number-2) for more information about identifying the Entitlement Account Number.

For AWS, the default settings creates a classic LoadBalancer.
To use the Network LoadBalancer instead of the classic LoadBalancer for ingress, add the
following to your `tap-values.yaml`:

```yaml
contour:
  infrastructure_provider: aws
  envoy:
    service:
      aws:
        LBType: nlb
```

### <a id='additional-build-service-config'></a> (Optional) Additional Build Service configurations

The following tasks are optional during the Tanzu Application Platform installation process:

- [(Optional) Configure your profile with full dependencies](#full-dependencies)
- [(Optional) Configure your profile with the Jammy stack only](#jammy-only)

#### <a id='full-dependencies'></a> (Optional) Configure your profile with full dependencies

When you install a profile that includes Tanzu Build Service,
Tanzu Application Platform is installed with the `lite` set of dependencies.
These dependencies consist of [buildpacks](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-index.html)
and [stacks](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-stacks.html)
required for application builds.

The `lite` set of dependencies do not contain all buildpacks and stacks.
To use all buildpacks and stacks, you must install the `full` dependencies.
For more information about the differences between `lite` and `full` dependencies, see
[About lite and full dependencies](../tanzu-build-service/dependencies.html#lite-vs-full).

To configure `full` dependencies, add the key-value pair
`exclude_dependencies: true` to your `tap-values.yaml` file under the `buildservice` section.
For example:

```yaml
buildservice:
  kp_default_repository: ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/tap-build-service
  exclude_dependencies: true
```

After configuring `full` dependencies, you must install the dependencies after
you have finished installing your Tanzu Application Platform package.
See [Install the full dependencies package](#tap-install-full-deps) for more information.

Tanzu Application Platform v{{ vars.tap_version }} supports building applications with Ubuntu v22.04 (Jammy).

## <a id="install-package"></a>Install your Tanzu Application Platform package

Follow these steps to install the Tanzu Application Platform package:

1. Install the package by running:

    ```console
    tanzu package install tap -p tap.tanzu.vmware.com -v ${TAP_VERSION} --values-file tap-values.yaml -n tap-install
    ```

1. Verify the package install by running:

    ```console
    tanzu package installed get tap -n tap-install
    ```

    This can take 5-10 minutes because it installs several packages on your cluster.

2. Verify that the necessary packages in the profile are installed by running:

    ```console
    tanzu package installed list -A
    ```

3. If you configured `full` dependencies in your `tbs-values.yaml` file, install the `full` dependencies
by following the procedure in [Install full dependencies](#tap-install-full-deps).

After installing the Full profile on your cluster, you can install the
Tanzu Developer Tools for VS Code Extension to help you develop against it.
For instructions, see [Install Tanzu Developer Tools for your VS Code](../vscode-extension/install.md).

>**Note** You can run the following command after reconfiguring the profile to reinstall the Tanzu Application Platform:

```
tanzu package installed update tap -p tap.tanzu.vmware.com -v ${TAP_VERSION}  --values-file tap-values.yaml -n tap-install
```

## <a id="tap-install-full-deps"></a> Install the full dependencies package

If you configured `full` dependencies in your `tap-values.yaml` file in
[Configure your profile with full dependencies](#full-dependencies) earlier,
you must install the `full` dependencies package.

1. Create an ECR repository for Tanzu Build Service full dependencies by running:

    ```console
    aws ecr create-repository --repository-name full-deps-package-repo --region ${AWS_REGION}
    ```

1. (Optional) If you have an existing installation of the full dependencies package from a version
earlier than Tanzu Application Platform v{{ vars.tap_version }}, you must uninstall the full dependencies package and remove the package repository:

    1. Uninstall the package:

        ```console
        tanzu package installed delete full-tbs-deps -n tap-install
        ```

    1. Remove the package repository:

        ```console
        tanzu package repository delete tbs-full-deps-repository -n tap-install
        ```

    >**Important** The package and repository names might differ depending on your installation configurations.

1. If you have not done so already, add the key-value pair `exclude_dependencies: true`
 to your `tap-values.yaml` file under the `buildservice` section. For example:

    ```yaml
    buildservice:
    ...
      exclude_dependencies: true
    ...
    ```

1. If you have not updated your Tanzu Application Platform package install after adding the `exclude_dependencies: true` to your values file, you must perform the update by running:

    ```console
    tanzu package installed update tap --namespace tap-install --values-file PATH-TO-UPDATED-VALUES
    ```

1. Get the latest version of the `tap` package by running:

    ```console
    tanzu package available list tap.tanzu.vmware.com --namespace tap-install
    ```

1. Relocate the Tanzu Build Service full dependencies package repository by running:

    ```console
    imgpkg copy -b registry.tanzu.vmware.com/tanzu-application-platform/full-deps-package-repo:VERSION \
      --to-repo ${INSTALL_REGISTRY_HOSTNAME}/full-deps-package-repo
    ```

    Where `VERSION` is the version of the `tap` package you retrieved in the previous step.

1. Add the Tanzu Build Service full dependencies package repository by running:

    ```console
    tanzu package repository add full-deps-package-repo \
      --url ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REPO}/full-deps-package-repo:VERSION \
      --namespace tap-install
    ```

    Where `VERSION` is the version of the `tap` package you retrieved earlier.

1. Install the full dependencies package by running:

    ```console
    tanzu package install full-deps -p full-deps.buildservice.tanzu.vmware.com -v "> 0.0.0" -n tap-install --values-file PATH-TO-TAP-VALUES-FILE
    ```

For more information about the differences between `lite` and `full` dependencies, see
[About lite and full dependencies](../tanzu-build-service/dependencies.html#lite-vs-full).

## <a id='access-tap-gui'></a> Access Tanzu Developer Portal

To access Tanzu Developer Portal, you can use the host name that you configured earlier. This host
name is pointed at the shared ingress. To configure LoadBalancer for Tanzu Developer Portal, see [Access Tanzu Developer Portal](../tap-gui/accessing-tap-gui.md).

You're now ready to start using Tanzu Developer Portal.
Proceed to the [Getting Started](../getting-started.md) topic or the
[Tanzu Developer Portal - Catalog Operations](../tap-gui/catalog/catalog-operations.md) topic.

## <a id='exclude-packages'></a> Exclude packages from a Tanzu Application Platform profile

To exclude packages from a Tanzu Application Platform profile:

1. Find the full subordinate (child) package name:

    ```console
    tanzu package available list --namespace tap-install
    ```

2. Update your `tap-values` file with a section listing the exclusions:

    ```console
    profile: PROFILE-VALUE
    excluded_packages:
      - tap-gui.tanzu.vmware.com
      - service-bindings.lab.vmware.com
    ```

>**Important** If you exclude a package after performing a profile installation including that package, you cannot see the accurate package states immediately after running `tap package installed list -n tap-install`. Also, you can break package dependencies by removing a package. Allow 20 minutes to verify that all packages have reconciled correctly while troubleshooting.

## <a id='next-steps'></a>Next steps

- (Optional) [Install Individual Packages](../install-online/components.hbs.md)
- [Set up developer namespaces to use your installed packages](../install-aws/set-up-namespaces.hbs.md)

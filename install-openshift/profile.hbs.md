# Install Tanzu Application Platform on your OpenShift clusters

This topic tells you how to install Tanzu Application Platform (commonly known as TAP)
packages on your OpenShift clusters.

Before installing the packages, ensure you have:

- Completed the [Prerequisites](../prerequisites.html).
- Configured and verified the cluster.
- [Accepted Tanzu Application Platform EULA and installed Tanzu CLI](../install-tanzu-cli.html) with any required plug-ins.

## <a id='relocate-images'></a> Relocate images to a registry

VMware recommends relocating the images from VMware Tanzu Network registry to your own container image registry before
attempting installation. If you don't relocate the images, Tanzu Application Platform will depend on
VMware Tanzu Network for continued operation, and VMware Tanzu Network offers no uptime guarantees.
The option to skip relocation is documented for evaluation and proof-of-concept only.

The supported registries are Harbor, Azure Container Registry, Google Container Registry,
and Quay.io.
See the following documentation for a registry to learn how to set it up:

- [Harbor documentation](https://goharbor.io/docs/2.5.0/)
- [Google Container Registry documentation](https://cloud.google.com/container-registry/docs)
- [Quay.io documentation](https://docs.projectquay.io/welcome.html)

To relocate images from the VMware Tanzu Network registry to your registry:

1. Set up environment variables for installation use by running:

    ```console
    # Set tanzunet as the source registry to copy Tanzu Application Platform packages from.
    export IMGPKG_REGISTRY_HOSTNAME_0=registry.tanzu.vmware.com
    export IMGPKG_REGISTRY_USERNAME_0=MY-TANZUNET-USERNAME
    export IMGPKG_REGISTRY_PASSWORD_0=MY-TANZUNET-PASSWORD

    # The user’s registry for copying the Tanzu Application Platform package to.
    export IMGPKG_REGISTRY_HOSTNAME_1=MY-REGISTRY
    export IMGPKG_REGISTRY_USERNAME_1=MY-REGISTRY-USER
    export IMGPKG_REGISTRY_PASSWORD_1=MY-REGISTRY-PASSWORD
    # These environment variables starting with IMGPKG_* are used by the imgpkg command only.

    # The registry from which the Tanzu Application Platform package is retrieved.
    export INSTALL_REGISTRY_USERNAME="${IMGPKG_REGISTRY_USERNAME_1}"
    export INSTALL_REGISTRY_PASSWORD="${IMGPKG_REGISTRY_PASSWORD_1}"
    export INSTALL_REGISTRY_HOSTNAME=MY-REGISTRY
    export TAP_VERSION=VERSION-NUMBER
    export INSTALL_REPO=TARGET-REPOSITORY
    ```

    Where:

    - `MY-REGISTRY-USER` is the user with write access to `MY-REGISTRY`.
    - `MY-REGISTRY-PASSWORD` is the password for `MY-REGISTRY-USER`.
    - `MY-REGISTRY` is your own container registry.
    - `MY-TANZUNET-USERNAME` is the user with access to the images in the VMware Tanzu Network registry `registry.tanzu.vmware.com`
    - `MY-TANZUNET-PASSWORD` is the password for `MY-TANZUNET-USERNAME`.
    - `VERSION-NUMBER` is your Tanzu Application Platform version. For example, `{{ vars.tap_version }}`.
    - `TARGET-REPOSITORY` is your target repository, a folder/repository on `MY-REGISTRY` that serves as the location
    for the installation files for Tanzu Application Platform.

1. [Install the Carvel tool imgpkg CLI](https://{{ vars.staging_toggle }}.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/deploy.html#optionally-install-clis-onto-your-path).

1. Relocate the images with the `imgpkg` CLI by running:

    ```console
    imgpkg copy -b registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:${TAP_VERSION} --to-repo ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REPO}/tap-packages
    ```

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

1. (Optional) Create a registry secret for your writable image repository used for:

    - Tanzu Build Service Dependencies
    - Workloads when using the `shared.image_registry` key

    ```console
    tanzu secret registry add image-registry-creds \
      --server "${REGISTRY_HOSTNAME}" \
      --username "${REGISTRY_USERNAME}" \
      --password "${REGISTRY_PASSWORD}" \
      --namespace tap-install
    ```

    Where:

    - `REGISTRY_HOSTNAME` is the host name for the registry that contains your writable repository.
        Examples:
        - Harbor has the form `--server "my-harbor.io"`.
        - Docker Hub has the form `--server "index.docker.io"`.
        - Google Cloud Registry has the form `--server "gcr.io"`.
    - `REGISTRY_USERNAME` and `REGISTRY_PASSWORD` are the user name
      and password for the user that can write to the repository used in the following step.
      For Google Cloud Registry, use `_json_key` as the user name and the contents
      of the service account JSON file for the password.

    > **Note** If using the same repository as `tap-registry`, you can skip this step and use the `tap-registry` secret
    > in your `tap-values.yaml` instead of `image-registry-creds`.



1. Add the Tanzu Application Platform package repository to the cluster by running:

    ```console
    tanzu package repository add tanzu-tap-repository \
      --url ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REPO}/tap-packages:$TAP_VERSION \
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
    REPOSITORY:    tapmdc.azurecr.io/mdc/1.4.0/tap-packages
    TAG:           {{ vars.tap_version }}
    STATUS:        Reconcile succeeded
    REASON:
    ```

    > **Note** The `VERSION` and `TAG` numbers differ from the earlier example if you are on
    > Tanzu Application Platform v1.0.2 or earlier.

1. List the available packages by running:

    ```console
    tanzu package available list --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list --namespace tap-install
    / Retrieving available packages...
      NAME                                                 DISPLAY-NAME                                                              SHORT-DESCRIPTION
      accelerator.apps.tanzu.vmware.com                    Application Accelerator for VMware Tanzu                                  Used to create new projects and configurations.
      api-portal.tanzu.vmware.com                          API portal                                                                A unified user interface for API discovery and exploration at scale.
      apis.apps.tanzu.vmware.com                           API Auto Registration for VMware Tanzu                                    A TAP component to automatically register API exposing workloads as API entities
                                                                                                                                     in TAP GUI.
      backend.appliveview.tanzu.vmware.com                 Application Live View for VMware Tanzu                                    App for monitoring and troubleshooting running apps
      buildservice.tanzu.vmware.com                        Tanzu Build Service                                                       Tanzu Build Service enables the building and automation of containerized
                                                                                                                                     software workflows securely and at scale.
      carbonblack.scanning.apps.tanzu.vmware.com           VMware Carbon Black for Supply Chain Security Tools - Scan                Default scan templates using VMware Carbon Black
      cartographer.tanzu.vmware.com                        Cartographer                                                              Kubernetes native Supply Chain Choreographer.
      cnrs.tanzu.vmware.com                                Cloud Native Runtimes                                                     Cloud Native Runtimes is a serverless runtime based on Knative
      connector.appliveview.tanzu.vmware.com               Application Live View Connector for VMware Tanzu                          App for discovering and registering running apps
      controller.source.apps.tanzu.vmware.com              Tanzu Source Controller                                                   Tanzu Source Controller enables workload create/update from source code.
      conventions.appliveview.tanzu.vmware.com             Application Live View Conventions for VMware Tanzu                        Application Live View convention server
      developer-conventions.tanzu.vmware.com               Tanzu App Platform Developer Conventions                                  Developer Conventions
      external-secrets.apps.tanzu.vmware.com               External Secrets Operator                                                 External Secrets Operator is a Kubernetes operator that integrates external
                                                                                                                                     secret management systems.
      fluxcd.source.controller.tanzu.vmware.com            Flux Source Controller                                                    The source-controller is a Kubernetes operator, specialised in artifacts
                                                                                                                                     acquisition from external sources such as Git, Helm repositories and S3 buckets.
      grype.scanning.apps.tanzu.vmware.com                 Grype for Supply Chain Security Tools - Scan                              Default scan templates using Anchore Grype
      metadata-store.apps.tanzu.vmware.com                 Supply Chain Security Tools - Store                                       Post SBoMs and query for image, package, and vulnerability metadata.
      namespace-provisioner.apps.tanzu.vmware.com          Namespace Provisioner                                                     Automatic Provisioning of Developer Namespaces.
      ootb-delivery-basic.tanzu.vmware.com                 Tanzu App Platform Out of The Box Delivery Basic                          Out of The Box Delivery Basic.
      ootb-supply-chain-basic.tanzu.vmware.com             Tanzu App Platform Out of The Box Supply Chain Basic                      Out of The Box Supply Chain Basic.
      ootb-supply-chain-testing-scanning.tanzu.vmware.com  Tanzu App Platform Out of The Box Supply Chain with Testing and Scanning  Out of The Box Supply Chain with Testing and Scanning.
      ootb-supply-chain-testing.tanzu.vmware.com           Tanzu App Platform Out of The Box Supply Chain with Testing               Out of The Box Supply Chain with Testing.
      ootb-templates.tanzu.vmware.com                      Tanzu App Platform Out of The Box Templates                               Out of The Box Templates.
      policy.apps.tanzu.vmware.com                         Supply Chain Security Tools - Policy Controller                           Policy Controller enables defining of a policy to restrict unsigned container
                                                                                                                                     images.
      scanning.apps.tanzu.vmware.com                       Supply Chain Security Tools - Scan                                        Scan for vulnerabilities and enforce policies directly within Kubernetes native
                                                                                                                                     Supply Chains.
      service-bindings.labs.vmware.com                     Service Bindings for Kubernetes                                           Service Bindings for Kubernetes implements the Service Binding Specification.
      services-toolkit.tanzu.vmware.com                    Services Toolkit                                                          The Services Toolkit enables the management, lifecycle, discoverability and
                                                                                                                                     connectivity of Service Resources (databases, message queues, DNS records,
                                                                                                                                     etc.).
      snyk.scanning.apps.tanzu.vmware.com                  Snyk for Supply Chain Security Tools - Scan                               Default scan templates using Snyk
      spring-boot-conventions.tanzu.vmware.com             Tanzu Spring Boot Conventions Server                                      Default Spring Boot convention server.
      sso.apps.tanzu.vmware.com                            AppSSO                                                                    Application Single Sign-On for Tanzu
      tap-auth.tanzu.vmware.com                            Default roles for Tanzu Application Platform                              Default roles for Tanzu Application Platform
      tap-gui.tanzu.vmware.com                             Tanzu Developer Portal                                            web app graphical user interface for Tanzu Application Platform
      tap-telemetry.tanzu.vmware.com                       Telemetry Collector for Tanzu Application Platform                        Tanzu Application Platform Telemetry
      tap.tanzu.vmware.com                                 Tanzu Application Platform                                                Package to install a set of TAP components to get you started based on your use
                                                                                                                                     case.
      tekton.tanzu.vmware.com                              Tekton Pipelines                                                          Tekton Pipelines is a framework for creating CI/CD systems.
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

1. Create a `tap-values.yaml` file by using the
[Full Profile sample](#full-profile) in the following section as a guide.
These samples have the minimum configuration required to deploy Tanzu Application Platform.
The sample values file contains the necessary defaults for:

    - The meta-package, or parent Tanzu Application Platform package.
    - Subordinate packages, or individual child packages.

    Keep the values file for future configuration use.

    >**Note** `tap-values.yaml` is set as a Kubernetes secret, which provides secure means to read credentials for Tanzu Application Platform components.

1. [View possible configuration settings for your package](view-package-config.hbs.md)

### <a id='full-profile'></a> Full profile

The following is the YAML file sample for the full-profile. The `profile:` field takes `full` as the default value, but you can also set it to `iterate`, `build`, `run` or `view`.
Refer to [Install multicluster Tanzu Application Platform profiles](../multicluster/installing-multicluster.html) for more information.


```yaml
shared:
  ingress_domain: "INGRESS-DOMAIN"
  image_registry:
    project_path: "SERVER-NAME/REPO-NAME"
    secret:
      name: image-registry-creds
      namespace: tap-install
  kubernetes_distribution: "openshift" # To be passed only for OpenShift. Defaults to "".
  kubernetes_version: "K8S-VERSION"
  ca_cert_data: | # To be passed if using custom certificates.
      -----BEGIN CERTIFICATE-----
      MIIFXzCCA0egAwIBAgIJAJYm37SFocjlMA0GCSqGSIb3DQEBDQUAMEY...
      -----END CERTIFICATE-----

ceip_policy_disclosed: FALSE-OR-TRUE-VALUE # Installation fails if this is not set to true. Not a string.

#The above keys are minimum numbers of entries needed in tap-values.yaml to get a functioning TAP Full profile installation.

#Below are the keys which may have default values set, but can be overridden.

profile: full # Can take iterate, build, run, view.

supply_chain: basic # Can take testing, testing_scanning.

ootb_supply_chain_basic: # Based on supply_chain set above, can be changed to ootb_supply_chain_testing, ootb_supply_chain_testing_scanning.
  registry:
    server: "SERVER-NAME" # Takes the value from shared section above by default, but can be overridden by setting a different value.
    repository: "REPO-NAME" # Takes the value from shared section above by default, but can be overridden by setting a different value.
  gitops:
    ssh_secret: "SSH-SECRET-KEY" # Takes "" as value by default; but can be overridden by setting a different value.

contour:
  envoy:
    service:
      type: LoadBalancer # This is set by default, but can be overridden by setting a different value.

buildservice:
  kp_default_repository: "KP-DEFAULT-REPO"
  kp_default_repository_secret: # Takes the value from the shared section by default, but can be overridden by setting a different value.
    name: image-registry-creds
    namespace: tap-install

local_source_proxy:
  # Takes the value from the project_path under the image_registry section of shared by default, but can be overridden by setting a different value.
  repository: "EXTERNAL-REGISTRY-FOR-LOCAL-SOURCE"
  push_secret:
    # When set to true, the secret mentioned in this section is automatically exported to Local Source Proxy's namespace.
    name: "EXTERNAL-REGISTRY-FOR-LOCAL-SOURCE-SECRET"
    namespace: "EXTERNAL-REGISTRY-FOR-LOCAL-SOURCE-SECRET-NAMESPACE"
    # When set to true, the secret mentioned in this section is automatically exported to Local Source Proxy's namespace.
    create_export: true

tap_gui:
  app_config:
    auth:
      allowGuestAccess: true  # This allows unauthenticated users to log in to your portal. If you want to deactivate it, make sure you configure an alternative auth provider.
    catalog:
      locations:
        - type: url
          target: https://GIT-CATALOG-URL/catalog-info.yaml

metadata_store:
  ns_for_export_app_cert: "MY-DEV-NAMESPACE"
  app_service_type: ClusterIP # Defaults to LoadBalancer. If shared.ingress_domain is set earlier, this must be set to ClusterIP.
```

> **Important** Installing Grype by using `tap-values.yaml` as follows is
> deprecated in v1.6 and will be removed in v1.8:
>
> ```yaml
> grype:
>   targetImagePullSecret: "TARGET-REGISTRY-CREDENTIALS-SECRET"
>```
>
> You can install Grype by using Namespace Provisioner instead.

Where:

- `INGRESS-DOMAIN` is the subdomain for the host name that you point at the `tanzu-shared-ingress`
service's External IP address.
- `KP-DEFAULT-REPO` is a writable repository in your registry. Tanzu Build Service dependencies are written to this location. Examples:
    * Harbor has the form `kp_default_repository: "my-harbor.io/my-project/build-service"`.
    * Docker Hub has the form `kp_default_repository: "my-dockerhub-user/build-service"` or `kp_default_repository: "index.docker.io/my-user/build-service"`.
    * Google Cloud Registry has the form `kp_default_repository: "gcr.io/my-project/build-service"`.
- `K8S-VERSION` is the Kubernetes version used by your OpenShift cluster. It must be in the form of `1.26.x`, where `x` stands for the patch version. Examples:
    - Red Hat OpenShift Container Platform v4.13 uses the Kubernetes version `1.26.3`.
    - Red Hat OpenShift Container Platform v4.14 uses the Kubernetes version `1.27.6`.
- `SERVER-NAME` is the host name of the registry server. Examples:
    * Harbor has the form `server: "my-harbor.io"`.
    * Docker Hub has the form `server: "index.docker.io"`.
    * Google Cloud Registry has the form `server: "gcr.io"`.
- `REPO-NAME` is where workload images are stored in the registry. If this key is passed through the shared section earlier and AWS ECR registry is used, you must ensure that the `SERVER-NAME/REPO-NAME/buildservice` and `SERVER-NAME/REPO-NAME/workloads` exist. AWS ECR expects the paths to be pre-created.
Images are written to `SERVER-NAME/REPO-NAME/workload-name`. Examples:
    * Harbor has the form `repository: "my-project/supply-chain"`.
    * Docker Hub has the form `repository: "my-dockerhub-user"`.
    * Google Cloud Registry has the form `repository: "my-project/supply-chain"`.
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
- `SSH-SECRET-KEY` is the SSH secret key in the developer namespace for the supply chain to fetch source code from and push configuration to.
This field is only required if you use a private repository, otherwise, leave it empty. See [Git authentication](../scc/git-auth.hbs.md) for more information.
- `GIT-CATALOG-URL` is the path to the `catalog-info.yaml` catalog definition file. You can download either a blank or populated catalog file from the [Tanzu Application Platform product page](https://network.pivotal.io/products/tanzu-application-platform/#/releases/1239018). Otherwise, you can use a Backstage-compliant catalog you've already built and posted on the Git infrastructure.
- `MY-DEV-NAMESPACE` is the name of the developer namespace. SCST - Store exports secrets to the namespace, and SCST - Scan deploys the `ScanTemplates` there. This allows the scanning feature to run in this namespace. If there are multiple developer namespaces, use `ns_for_export_app_cert: "*"` to export the SCST - Store CA certificate to all namespaces.
- `TARGET-REGISTRY-CREDENTIALS-SECRET` is the name of the secret that contains the
credentials to pull an image from the registry for scanning.

Tanzu Application Platform is part of [VMware's CEIP program](https://www.vmware.com/solutions/trustvmware/ceip-products.html) where data is collected to help improve the customer experience. By setting `ceip_policy_disclosed` to `true` (not a string), you acknowledge the program is disclosed to you and you are aware data collection is happening. This field must be set for the installation to be completed. See [Opt out of telemetry collection](../opting-out-telemetry.hbs.md) for more information.

If you use custom CA certificates, you must provide one or more PEM-encoded CA certificates under the `ca_cert_data` key. If you configured `shared.ca_cert_data`, Tanzu Application Platform component packages inherit that value by default.

If you use AWS, the default settings creates a classic LoadBalancer.
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
  ...
  exclude_dependencies: true
  ...
```

After configuring `full` dependencies, you must install the dependencies after
you have finished installing your Tanzu Application Platform package.
See [Install the full dependencies package](#tap-install-full-deps) for more information.

#### <a id='jammy-only'></a> (Optional) Configure your profile with the Jammy stack only

Tanzu Application Platform v1.5.0 supports building applications with both the
Ubuntu v22.04 (Jammy) and v18.04 (Bionic) stack. For more information, see
[Bionic and Jammy stacks](../tanzu-build-service/dependencies.html#bionic-vs-jammy).

To install Tanzu Application Platform with Jammy as the only available stack,
include the `stack_configuration: jammy-only` field under the `buildservice:`
section in `tap-values.yaml`.

### <a id='custom-scc'></a> Security Context Constraints

Security Context Constraints (SCC) define a set of rules that a pod must satisfy to be created. Tanzu
Application Platform components use the built-in [nonroot-v2](https://github.com/openshift/cluster-kube-apiserver-operator/blob/d373b65cf454fd594b6affd202e5cedb48d88964/bindata/bootkube/scc-manifests/0000_20_kube-apiserver-operator_00_scc-nonroot-v2.yaml) or [restricted-v2](https://github.com/openshift/cluster-kube-apiserver-operator/blob/d373b65cf454fd594b6affd202e5cedb48d88964/bindata/bootkube/scc-manifests/0000_20_kube-apiserver-operator_00_scc-restricted-v2.yaml)
SCC.

In Red Hat OpenShift, SCC are used to restrict privileges for pods. In Tanzu
Application Platform v1.4 there is no custom SCC.

Tanzu Application Platform packages reconcile without any issues when using
OpenShift v4.11 with restricted-v2 or nonroot-v2.

## <a id="install-package"></a>Install your Tanzu Application Platform package

Follow these steps to install the Tanzu Application Platform package:

1. Install the package by running:

    ```console
    tanzu package install tap -p tap.tanzu.vmware.com -v $TAP_VERSION --values-file tap-values.yaml -n tap-install
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
tanzu package installed update tap -p tap.tanzu.vmware.com -v $TAP_VERSION  --values-file tap-values.yaml -n tap-install
```

## <a id="tap-install-full-deps"></a> Install the full dependencies package

If you configured `full` dependencies in your `tap-values.yaml` file in
[Configure your profile with full dependencies](#full-dependencies) earlier,
you must install the `full` dependencies package.

For more information about the differences between `lite` and `full` dependencies, see
[About lite and full dependencies](../tanzu-build-service/dependencies.html#lite-vs-full).

To install the `full` dependencies package:

1. If you have not done so already, add the key-value pair `exclude_dependencies: true`
 to your `tap-values.yaml` file under the `buildservice` section. For example:

    ```yaml
    buildservice:
      ...
      exclude_dependencies: true
      ...
    ```

1. Get the latest version of the `tap` package by running:

    ```console
    tanzu package available list tap.tanzu.vmware.com --namespace tap-install
    ```

1. Relocate the Tanzu Build Service full dependencies package repository by running:

    ```console
    imgpkg copy -b registry.tanzu.vmware.com/tanzu-application-platform/full-deps-package-repo:VERSION \
      --to-repo ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REPO}/full-deps-package-repo
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

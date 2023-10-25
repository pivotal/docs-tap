# Install Tanzu Application Platform package and profiles on Azure

This topic tells you how to install Tanzu Application Platform (commonly known as TAP)
packages from your Tanzu Application Platform package repository on to Azure.

Before installing the packages, ensure you have:

- Completed the [Prerequisites](../prerequisites.hbs.md).
- Created [Azure Resources](resources.hbs.md).
- [Accepted Tanzu Application Platform EULA and installed Tanzu CLI](../install-tanzu-cli.hbs.md) with any required plug-ins.
- Installed [Cluster Essentials for Tanzu](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/deploy.html).

## <a id='add-tap-package-repo'></a> Relocate images to a registry

VMware recommends relocating the images from VMware Tanzu Network registry to your own container image registry before
attempting installation. If you don't relocate the images, Tanzu Application Platform depends on
VMware Tanzu Network for continued operation, and VMware Tanzu Network offers no uptime guarantees.
The option to skip relocation is documented for evaluation and proof-of-concept only.

To relocate images from the VMware Tanzu Network registry to the ACR registry:

1. Set up environment variables for installation use by running:

    ```console
    export AZURE_SP_APP_ID=MY-AZURE-APP-ID
    export AZURE_SP_TENANT=AZURE-TENANT
    export AZURE_SP_PASSWORD=AZURE-PASSWORD
    export AZURE_SUBSCRIPTION_ID=MY-AZURE-SUBSCRIPTION-ID
    export AZURE_ACCOUNT_ID=MY-AZURE-ACCOUNT-ID
    export AZURE_REGION=TARGET-AZURE-REGION
    export AKS_CLUSTER_NAME=tap-on-azure
    export IMGPKG_REGISTRY_HOSTNAME_0=registry.tanzu.vmware.com
    export IMGPKG_REGISTRY_USERNAME_0=MY-TANZUNET-USERNAME
    export IMGPKG_REGISTRY_PASSWORD_0=MY-TANZUNET-PASSWORD
    export IMGPKG_REGISTRY_HOSTNAME_1=$INSTALL_REGISTRY_HOSTNAME
    export IMGPKG_REGISTRY_USERNAME_1=$REGISTRY_NAME
    export IMGPKG_REGISTRY_PASSWORD_1=REGISTRY-PASSWORD
    export TAP_VERSION=VERSION-NUMBER
    export INSTALL_REGISTRY_HOSTNAME=$REGISTRY_NAME.azurecr.io
    export INSTALL_REPO=tapimages    
    ```

    Where:

    - `MY-AZURE-APP-ID` is the application ID you deploy Tanzu Application Platform in. Must be in UUID format.
    - `AZURE-TENANT` is the tenant you deploy Tanzu Application Platform in. Must be in UUID format.    
    - `MY-AZURE-SUBSCRIPTION-ID` is the Azure subscription ID you deploy Tanzu Application Platform in. Must be in UUID format.    
    - `MY-TANZUNET-USERNAME` is the user with access to the images in the VMware Tanzu Network registry `registry.tanzu.vmware.com`
    - `MY-TANZUNET-PASSWORD` is the password for `MY-TANZUNET-USERNAME`.
    - `TARGET-AZURE-REGION` is the region you deploy the Tanzu Application Platform to.      
    - `VERSION-NUMBER` is your Tanzu Application Platform version. For example, `{{ vars.tap_version }}`

1. [Install the Carvel tool imgpkg CLI](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/deploy.html#optionally-install-clis-onto-your-path).  

1. Relocate the images with the `imgpkg` CLI by running:

    ```console
    imgpkg copy --concurrency 1 -b ${IMGPKG_REGISTRY_HOSTNAME_0}/tanzu-application-platform/tap-packages:${TAP_VERSION} --to-repo ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REPO}
    ```

1. Create a namespace called `tap-install` for deploying any component packages by running:

    ```console
    kubectl create ns tap-install
    ```

    This namespace keeps the objects grouped together logically.

1. Export the VMware Tanzu Network registry by running:

    ```console
    export INSTALL_REPO=tanzu-application-platform/tap-packages
    ```

1. Create registry secret for the VMware Tanzu Network registry by running:

    ```console
    tanzu secret registry add tap-registry \
    --username ${INSTALL_REGISTRY_USERNAME} --password ${INSTALL_REGISTRY_PASSWORD} \
    --server ${INSTALL_REGISTRY_HOSTNAME} \
    --export-to-all-namespaces --yes --namespace tap-install
    tanzu secret registry list --namespace tap-install
    ```

1. Add the Tanzu Application Platform package repository to the cluster by running:

    ```console
    tanzu package repository add tanzu-tap-repository \
      --url ${INSTALL_REGISTRY_HOSTNAME}/full-deps-package-repo
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
    REPOSITORY:    123456789012.dkr.acr.us-east.azure.com/tap-images
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
      eventing.tanzu.vmware.com                            Eventing                                                                  Eventing is an event-driven architecture platform based on Knative Eventing
      external-secrets.apps.tanzu.vmware.com               External Secrets Operator                                                 External Secrets Operator is a Kubernetes operator that integrates external
                                                                                                                                     secret management systems.
      fluxcd.source.controller.tanzu.vmware.com            Flux Source Controller                                                    The source-controller is a Kubernetes operator, specialised in artifacts
                                                                                                                                     acquisition from external sources such as Git, Helm repositories and S3 buckets.
      grype.scanning.apps.tanzu.vmware.com                 Grype for Supply Chain Security Tools - Scan                              Default scan templates using Anchore Grype
      learningcenter.tanzu.vmware.com                      Learning Center for Tanzu Application Platform                            Guided technical workshops
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
      tap-gui.tanzu.vmware.com                             Tanzu Application Platform GUI                                            web app graphical user interface for Tanzu Application Platform
      tap-telemetry.tanzu.vmware.com                       Telemetry Collector for Tanzu Application Platform                        Tanzu Application Platform Telemetry
      tap.tanzu.vmware.com                                 Tanzu Application Platform                                                Package to install a set of TAP components to get you started based on your use
                                                                                                                                     case.
      tekton.tanzu.vmware.com                              Tekton Pipelines                                                          Tekton Pipelines is a framework for creating CI/CD systems.
      workshops.learningcenter.tanzu.vmware.com            Workshop Building Tutorial                                                Workshop Building Tutorial
    ```

## <a id='install-profile'></a> Install your Tanzu Application Platform profile

The `tap.tanzu.vmware.com` package installs predefined sets of packages based on your profile settings
by using the package manager installed by Tanzu Cluster Essentials.
For more information about profiles, see [Components and installation profiles](../about-package-profiles.md).

To create a registry secret and add it to a developer namespace:

```console
export KP_REGISTRY_USERNAME=YOUR-USERNAME
export KP_REGISTRY_PASSWORD=YOUR-PASSWORD
export KP_REGISTRY_HOSTNAME=YOUR-HOSTNAME

echo $KP_REGISTRY_USERNAME
echo $KP_REGISTRY_PASSWORD
echo $KP_REGISTRY_HOSTNAME

docker login $KP_REGISTRY_HOSTNAME -u $KP_REGISTRY_USERNAME -p $KP_REGISTRY_PASSWORD

export YOUR_NAMESPACE=mydev-ns

echo $YOUR_NAMESPACE

kubectl create ns $YOUR_NAMESPACE

tanzu secret registry add registry-credentials --server $KP_REGISTRY_HOSTNAME --username $KP_REGISTRY_USERNAME --password $KP_REGISTRY_PASSWORD --namespace $YOUR_NAMESPACE

kubectl get secret registry-credentials  -o jsonpath='{.data.\.dockerconfigjson}'  -n $YOUR_NAMESPACE| base64 --decode
```

To prepare to install a profile:

1. List version information for the package by running:

    ```console
    tanzu package available list tap.tanzu.vmware.com --namespace tap-install
    ```

1. Create a `tap-values.yaml` file by using the [Full Profile (Azure)](#full-profile),
which contains the minimum configurations required to deploy Tanzu Application Platform on Azure.
The sample values file contains the necessary defaults for:

    - The meta-package, or parent Tanzu Application Platform package.
    - Subordinate packages, or individual child packages.

    Keep the values file for future configuration use.

    >**Note** `tap-values.yaml` is set as a Kubernetes secret, which provides secure means to read credentials for Tanzu Application Platform components.

1. [View possible configuration settings for your package](view-package-config.hbs.md)

### <a id='full-profile'></a> Full profile (Azure)

The following is the YAML file sample for the full-profile on Azure by using the ACR repositories you created earlier.
The `profile:` field takes `full` as the default value, but you can also set it to `iterate`, `build`, `run`, or `view`.
See [Install multicluster Tanzu Application Platform profiles](../multicluster/installing-multicluster.hbs.md) for more information.

```console
cat << EOF > tap-values.yaml 
ceip_policy_disclosed: true 
profile: full # Can take iterate, build, run, view.

supply_chain: basic # Can take testing, testing_scanning.

ootb_templates:
  iaas_auth: true

ootb_supply_chain_basic:
  registry:
    server: ${KP_REGISTRY_HOSTNAME}
    repository: ${INSTALL_REPO}
  gitops:
    ssh_secret: "" 

contour:
  envoy:
    service:
      type: LoadBalancer 

buildservice:
  kp_default_repository: ${KP_REGISTRY_HOSTNAME}
  kp_default_repository_secret:
    name: registry-credentials
    namespace: "MY-DEV-NAMESPACE"
  enable_automatic_dependency_updates: false          

learningcenter:
  ingressDomain: learning-center.tap.com

ootb_delivery_basic:
  service_account: default

tap_gui:
  ingressEnabled: true
  ingressDomain: tap.com
  app_config:
    supplyChain:
      enablePlugin: true
    auth:
      allowGuestAccess: true
    backend:
      baseUrl: http://tap-gui.tap.com
      cors:
        origin: http://tap-gui.tap.com
    app:
      baseUrl: http://tap-gui.tap.com

metadata_store:
  ingressEnabled: true
  ingressDomain: "INGRESS-DOMAIN"
  app_service_type: ClusterIP
  ns_for_export_app_cert: "MY-DEV-NAMESPACE"

scanning:
  metadataStore:
    url: "" # Configuration is moved, so set this string to empty.

accelerator:
  server:
    service_type: "ClusterIP"

cnrs:
  domain_name: tap.com
EOF 
```

Where:

- `INGRESS-DOMAIN` is the subdomain for the host name that you point at the `tanzu-shared-ingress`
service's External IP address.
- `GIT-CATALOG-URL` is the path to the `catalog-info.yaml` catalog definition file.
  You can download either a blank or populated catalog file from the
  [Tanzu Application Platform product page](https://network.pivotal.io/products/tanzu-application-platform/#/releases/1239018).
  Otherwise, you can use a Backstage-compliant catalog that was built and posted on the Git infrastructure.
- `MY-DEV-NAMESPACE` is the name of the developer namespace.
  SCST - Store exports secrets to the namespace, and SCST - Scan deploys the `ScanTemplates` there.
  This allows the scanning feature to run in this namespace.
  If there are multiple developer namespaces, use `ns_for_export_app_cert: "*"`
  to export the SCST - Store CA certificate to all namespaces.
- `TARGET-REGISTRY-CREDENTIALS-SECRET` is the name of the secret that contains
  the credentials to pull an image from the registry for scanning.

For Azure, the default settings create a classic LoadBalancer.
To use the Network LoadBalancer instead of the classic LoadBalancer for ingress, add the
following to your `tap-values.yaml`:

```yaml
contour:
  infrastructure_provider: azure
  envoy:
    service:
      azure:
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
  kp_default_repository: "KP-DEFAULT-REPO"
  kp_default_repository_secret: # Takes the value from the shared section by default, but can be overridden by setting a different value.
    name: "KP-DEFAULT-REPO-SECRET"
    namespace: "KP-DEFAULT-REPO-SECRET-NAMESPACE"
  exclude_dependencies: true
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

1. Verify that the necessary packages in the profile are installed by running:

    ```console
    tanzu package installed list -A
    ```

1. If you configured `full` dependencies in your `tbs-values.yaml` file, install the `full` dependencies
by following the procedure in [Install full dependencies](#tap-install-full-deps).

After installing the Full profile on your cluster, you can install the
Tanzu Developer Tools for VS Code Extension to help you develop against it.
For more information, see [Install Tanzu Developer Tools for your VS Code](vscode-install.hbs.md).

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
      kp_default_repository: ${KP_REGISTRY_HOSTNAME}.azurecr.io/{$REPOSITORY_NAME}
      exclude_dependencies: true
    ...
    ```

1. Get the latest version of the `buildservice` package by running:

    ```console
    tanzu package available list buildservice.tanzu.vmware.com --namespace tap-install
    ```

1. Relocate the Tanzu Build Service full dependencies package repository by running:

    ```console
    imgpkg copy -b registry.tanzu.vmware.com/tanzu-application-platform/full-tbs-deps-package-repo:VERSION \
      --to-repo ${INSTALL_REGISTRY_HOSTNAME}/tbs-full-deps
    ```

    Where `VERSION` is the version of the `buildservice` package you retrieved in the previous step.

1. Add the Tanzu Build Service full dependencies package repository by running:

    ```console
    tanzu package repository add tbs-full-deps-repository \
      --url ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REPO}/tbs-full-deps:VERSION \
      --namespace tap-install
    ```

    Where `VERSION` is the version of the `tap` package you retrieved earlier.

1. Install the full dependencies package by running:

    ```console
    tanzu package install full-tbs-deps -p full-tbs-deps.tanzu.vmware.com -v VERSION -n tap-install
    ```

    Where `VERSION` is the version of the `buildservice` package you retrieved earlier.

## <a id='access-tap-gui'></a> Access Tanzu Application Platform GUI

To access Tanzu Application Platform GUI, you can use the host name that you configured earlier.
This host name is pointed at the shared ingress.
To configure LoadBalancer for Tanzu Application Platform GUI,
see [Access Tanzu Application Platform GUI](../tap-gui/accessing-tap-gui.hbs.md).

You're now ready to start using Tanzu Application Platform GUI.
Proceed to the [Getting Started](../getting-started.md) topic or the
[Tanzu Application Platform GUI - Catalog Operations](../tap-gui/catalog/catalog-operations.hbs.md) topic.

## <a id='next-steps'></a>Next steps

- (Optional) [Install Individual Packages](components.hbs.md)
- [Set up developer namespaces to use your installed packages](set-up-namespaces.hbs.md)

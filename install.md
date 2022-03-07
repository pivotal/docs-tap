# Installing the Tanzu Application Platform Package and Profiles

This document describes how to install Tanzu Application Platform packages
from the Tanzu Application Platform package repository.

Before you install the packages, ensure that you have completed the prerequisites, configured
and verified the cluster, accepted the EULA, and installed the Tanzu CLI with any required plug-ins.
See [Installing the Tanzu CLI](install-tanzu-cli.md).


## <a id='add-tap-package-repo'></a> Add the Tanzu Application Platform package repository

To add the Tanzu Application Platform package repository:

1. If you haven’t completed the
[Install Cluster Essentials for VMware Tanzu for non-TKG clusters](install-tanzu-cli.md#tanzu-cluster-essentials)
procedure, set up environment variables for use during the installation by running:

    ```
    export INSTALL_REGISTRY_USERNAME=TANZU-NET-USER
    export INSTALL_REGISTRY_PASSWORD=TANZU-NET-PASSWORD
    export INSTALL_REGISTRY_HOSTNAME=registry.tanzu.vmware.com
    export TAP_VERSION=VERSION-NUMBER
    ```

    Where `VERSION-NUMBER` is your Tanzu Application Platform version. For example, `1.0.2`.

1. Create a namespace called `tap-install` for deploying any component packages by running:

    ```
    kubectl create ns tap-install
    ```

    This namespace keeps the objects grouped together logically.

1. Create a registry secret by running:

    ```
    tanzu secret registry add tap-registry \
      --username ${INSTALL_REGISTRY_USERNAME} --password ${INSTALL_REGISTRY_PASSWORD} \
      --server ${INSTALL_REGISTRY_HOSTNAME} \
      --export-to-all-namespaces --yes --namespace tap-install
    ```

1. Add Tanzu Application Platform package repository to the cluster by running:

    ```
    tanzu package repository add tanzu-tap-repository \
      --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:$TAP_VERSION \
      --namespace tap-install
    ```

    Where `$TAP_VERSION` is the Tanzu Application Platform version environment variable
    you defined earlier.

1. Get the status of the Tanzu Application Platform package repository, and ensure the status updates to `Reconcile succeeded` by running:

    ```
    tanzu package repository get tanzu-tap-repository --namespace tap-install
    ```

    For example:

    ```
    $ tanzu package repository get tanzu-tap-repository --namespace tap-install
    | Retrieving repository tap...
    NAME:          tanzu-tap-repository
    VERSION:       121657971
    REPOSITORY:    registry.tanzu.vmware.com/tanzu-application-platform/tap-packages
    TAG:           1.0.2
    STATUS:        Reconcile succeeded
    REASON:
    ```

    >**Note:** the `VERSION` and `TAG` numbers differ from the example above if you are on
    >Tanzu Application Platform v1.0.2 or earlier.

1. List the available packages by running:

    ```
    tanzu package available list --namespace tap-install
    ```

    For example:

    ```
    $ tanzu package available list --namespace tap-install
    / Retrieving available packages...
      NAME                                                 DISPLAY-NAME                                                              SHORT-DESCRIPTION
      accelerator.apps.tanzu.vmware.com                    Application Accelerator for VMware Tanzu                                  Used to create new projects and configurations.
      api-portal.tanzu.vmware.com                          API portal                                                                A unified user interface to enable search, discovery and try-out of API endpoints at ease.
      run.appliveview.tanzu.vmware.com                     Application Live View for VMware Tanzu                                    App for monitoring and troubleshooting running apps
      build.appliveview.tanzu.vmware.com                   Application Live View Conventions for VMware Tanzu                        Application Live View convention server
      buildservice.tanzu.vmware.com                        Tanzu Build Service                                                       Tanzu Build Service enables the building and automation of containerized software workflows securely and at scale.
      cartographer.tanzu.vmware.com                        Cartographer                                                              Kubernetes native Supply Chain Choreographer.
      cnrs.tanzu.vmware.com                                Cloud Native Runtimes                                                     Cloud Native Runtimes is a serverless runtime based on Knative
      controller.conventions.apps.tanzu.vmware.com         Convention Service for VMware Tanzu                                       Convention Service enables app operators to consistently apply desired runtime configurations to fleets of workloads.
      controller.source.apps.tanzu.vmware.com              Tanzu Source Controller                                                   Tanzu Source Controller enables workload create/update from source code.
      developer-conventions.tanzu.vmware.com               Tanzu App Platform Developer Conventions                                  Developer Conventions
      grype.scanning.apps.tanzu.vmware.com                 Grype Scanner for Supply Chain Security Tools - Scan                      Default scan templates using Anchore Grype
      image-policy-webhook.signing.apps.tanzu.vmware.com    Image Policy Webhook                                                     The Image Policy Webhook allows platform operators to define a policy that will use cosign to verify signatures of container images
      learningcenter.tanzu.vmware.com                      Learning Center for Tanzu Application Platform                            Guided technical workshops
      ootb-supply-chain-basic.tanzu.vmware.com             Tanzu App Platform Out of The Box Supply Chain Basic                      Out of The Box Supply Chain Basic.
      ootb-supply-chain-testing-scanning.tanzu.vmware.com  Tanzu App Platform Out of The Box Supply Chain with Testing and Scanning  Out of The Box Supply Chain with Testing and Scanning.
      ootb-supply-chain-testing.tanzu.vmware.com           Tanzu App Platform Out of The Box Supply Chain with Testing               Out of The Box Supply Chain with Testing.
      ootb-templates.tanzu.vmware.com                      Tanzu App Platform Out of The Box Templates                               Out of The Box Templates.
      scanning.apps.tanzu.vmware.com                       Supply Chain Security Tools - Scan                                        Scan for vulnerabilities and enforce policies directly within Kubernetes native Supply Chains.
      metadata-store.apps.tanzu.vmware.com                          Tanzu Supply Chain Security Tools - Store                                 The Metadata Store enables saving and querying image, package, and vulnerability data.
      service-bindings.labs.vmware.com                     Service Bindings for Kubernetes                                           Service Bindings for Kubernetes implements the Service Binding Specification.
      services-toolkit.tanzu.vmware.com                    Services Toolkit                                                          The Services Toolkit enables the management, lifecycle, discoverability and connectivity of Service Resources (databases, message queues, DNS records, etc.).
      spring-boot-conventions.tanzu.vmware.com             Tanzu Spring Boot Conventions Server                                      Default Spring Boot convention server.
      tap-gui.tanzu.vmware.com                             Tanzu Application Platform GUI                                            web app graphical user interface for Tanzu Application Platform
      tap.tanzu.vmware.com                                 Tanzu Application Platform                                                Package to install a set of TAP components to get you started based on your use case.
      workshops.learningcenter.tanzu.vmware.com            Workshop Building Tutorial                                                Workshop Building Tutorial
    ```

## <a id='install-profile'></a> Install your Tanzu Application Platform profile

The `tap.tanzu.vmware.com` package installs predefined sets of packages based on your profile settings. This is done by using the package manager you installed using Tanzu Cluster Essentials. For more information about profiles, see [Installation profiles in Tanzu Application Platform](overview.md#profiles-and-packages).

To install a profile:

1. List version information for the package by running:

    ```
    tanzu package available list tap.tanzu.vmware.com --namespace tap-install
    ```

1. Create a `tap-values.yml` file by using the
[Full Profile sample](#full-profile) or [Light Profile sample](#light-profile) as a guide.
These samples contain the minimum configuration required to deploy Tanzu Application Platform.
The sample values file contains the necessary defaults for both the meta-package
(parent Tanzu Application Platform package) and subordinate packages
(individual child packages).
The values file you provide during installation is used for further configuration
of Tanzu Application Platform.

    >**Important:** Keep this file for future use.

1. Proceed to the [View possible configuration settings for your package](#view-pkge-config-settings)
section.

### <a id='full-profile'></a> Full Profile

The following is the YAML file sample for the full-profile:

```
profile: full
ceip_policy_disclosed: true # The value must be true for installation to succeed
buildservice:
  kp_default_repository: "KP-DEFAULT-REPO"
  kp_default_repository_username: "KP-DEFAULT-REPO-USERNAME"
  kp_default_repository_password: "KP-DEFAULT-REPO-PASSWORD"
  tanzunet_username: "TANZUNET-USERNAME"
  tanzunet_password: "TANZUNET-PASSWORD"
  descriptor_name: "DESCRIPTOR-NAME"
  enable_automatic_dependency_updates: TRUE-OR-FALSE-VALUE # Optional, set as true or false. Not a string.
supply_chain: basic

cnrs:
  domain_name: INGRESS-DOMAIN

ootb_supply_chain_basic:
  registry:
    server: "SERVER-NAME"
    repository: "REPO-NAME"
  gitops:
    ssh_secret: ""

learningcenter:
  ingressDomain: "DOMAIN-NAME"

tap_gui:
  service_type: ClusterIP
  ingressEnabled: "true"
  ingressDomain: "INGRESS-DOMAIN"
  app_config:
    app:
      baseUrl: http://tap-gui.INGRESS-DOMAIN
    catalog:
      locations:
        - type: url
          target: https://GIT-CATALOG-URL/catalog-info.yaml
    backend:
      baseUrl: http://tap-gui.INGRESS-DOMAIN
      cors:
        origin: http://tap-gui.INGRESS-DOMAIN

metadata_store:
  app_service_type: LoadBalancer # (optional) Defaults to LoadBalancer. Change to NodePort for distributions that don't support LoadBalancer

grype:
  namespace: "MY-DEV-NAMESPACE" # (optional) Defaults to default namespace.
  targetImagePullSecret: "TARGET-REGISTRY-CREDENTIALS-SECRET"
```

Where:

- `KP-DEFAULT-REPO` is a writable repository in your registry. Tanzu Build Service dependencies are written to this location. Examples:
    * Harbor has the form `kp_default_repository: "my-harbor.io/my-project/build-service"`
    * Dockerhub has the form `kp_default_repository: "my-dockerhub-user/build-service"` or `kp_default_repository: "index.docker.io/my-user/build-service"`
    * Google Cloud Registry has the form `kp_default_repository: "gcr.io/my-project/build-service"`
- `KP-DEFAULT-REPO-USERNAME` is the username that can write to `KP-DEFAULT-REPO`. You should be able to `docker push` to this location with this credential.
    * For Google Cloud Registry, use `kp_default_repository_username: _json_key`
- `KP-DEFAULT-REPO-PASSWORD` is the password for the user that can write to `KP-DEFAULT-REPO`. You can `docker push` to this location with this credential.
    * For Google Cloud Registry, use the contents of the service account JSON key.
- `DESCRIPTOR-NAME` is the name of the descriptor to import automatically. Current available options at time of release:
    * `tap-1.0.0-full` contains all dependencies, and is for production use.
    * `tap-1.0.0-lite` smaller footprint used for speeding up installs. Requires Internet access on the cluster.
- `SERVER-NAME` is the hostname of the registry server. Examples:
    * Harbor has the form `server: "my-harbor.io"`
    * Dockerhub has the form `server: "index.docker.io"`
    * Google Cloud Registry has the form `server: "gcr.io"`
- `REPO-NAME` is where workload images are stored in the registry.
Images are written to `SERVER-NAME/REPO-NAME/workload-name`. Examples:
    * Harbor has the form `repository: "my-project/supply-chain"`
    * Dockerhub has the form `repository: "my-dockerhub-user"`
    * Google Cloud Registry has the form `repository: "my-project/supply-chain"`
- `DOMAIN-NAME` has a value such as `learningcenter.example.com`.
- `INGRESS-DOMAIN` is the subdomain for the host name that you point at the `tanzu-shared-ingress`
service's External IP address.
- `GIT-CATALOG-URL` is the path to the `catalog-info.yaml` catalog definition file. You can download either a blank or populated catalog file from the [Tanzu Application Platform product page](https://network.pivotal.io/products/tanzu-application-platform/#/releases/1043418/file_groups/6091). Otherwise, you can use a Backstage-compliant catalog you've already built and posted on the Git infrastructure you specified in the Integration section.
- `MY-DEV-NAMESPACE` is the namespace where you want the `ScanTemplates` to be deployed to.
This is the namespace where the scanning feature is going to run.
- `TARGET-REGISTRY-CREDENTIALS-SECRET` is the name of the secret that contains the
credentials to pull an image from the registry for scanning.
If built images are pushed to the same registry as the Tanzu Application Platform images,
this can reuse the `tap-registry` secret created in
[Add the Tanzu Application Platform package repository](#add-tap-package-repo).

>**Note:** When using the `tbs-values.yaml` configuration,
>`enable_automatic_dependency_updates: true` causes the dependency updater to update
>Tanzu Build Service dependencies (buildpacks and stacks) when they are released on
>VMware Tanzu Network. Use `false` to pause the automatic update of Build Service dependencies.
>When automatic updates are paused, the pinned version of the descriptor for TAP 1.0.2 is [100.0.267](https://network.pivotal.io/products/tbs-dependencies#/releases/1053790)
>If left undefined, this value is `false`.

### <a id='light-profile'></a> Light Profile

The following is the YAML file sample for the light-profile:

```
profile: light
ceip_policy_disclosed: true # The value must be true for installation to succeed

buildservice:
  kp_default_repository: "KP-DEFAULT-REPO"
  kp_default_repository_username: "KP-DEFAULT-REPO-USERNAME"
  kp_default_repository_password: "KP-DEFAULT-REPO-PASSWORD"
  tanzunet_username: "TANZUNET-USERNAME"
  tanzunet_password: "TANZUNET-PASSWORD"
  enable_automatic_dependency_updates: TRUE-OR-FALSE-VALUE # Optional, set as true or false. Not a string.

supply_chain: basic

cnrs:
  domain_name: INGRESS-DOMAIN

ootb_supply_chain_basic:
  registry:
    server: "SERVER-NAME"
    repository: "REPO-NAME"
  gitops:
    ssh_secret: ""

tap_gui:
  service_type: ClusterIP
  ingressEnabled: "true"
  ingressDomain: "INGRESS-DOMAIN"
  app_config:
    app:
      baseUrl: http://tap-gui.INGRESS-DOMAIN
    catalog:
      locations:
        - type: url
          target: https://GIT-CATALOG-URL/catalog-info.yaml
    backend:
      baseUrl: http://tap-gui.INGRESS-DOMAIN
      cors:
        origin: http://tap-gui.INGRESS-DOMAIN

metadata_store:
  app_service_type: LoadBalancer # (optional) Defaults to LoadBalancer. Change to NodePort for distributions that don't support LoadBalancer
```

Where:

- `KP-DEFAULT-REPO` is a writable repository in your registry. Tanzu Build Service dependencies are written to this location. Examples:
    - Harbor has the form `kp_default_repository: "my-harbor.io/my-project/build-service"`
    - Dockerhub has the form `kp_default_repository: "my-dockerhub-user/build-service"` or `kp_default_repository: "index.docker.io/my-user/build-service"`
    - Google Cloud Registry has the form `kp_default_repository: "gcr.io/my-project/build-service"`
- `KP-DEFAULT-REPO-USERNAME` is the username that can write to `KP-DEFAULT-REPO`. You should be able to `docker push` to this location with this credential.
    - For Google Cloud Registry, use `kp_default_repository_username: _json_key`
- `KP-DEFAULT-REPO-PASSWORD` is the password for the user that can write to `KP-DEFAULT-REPO`.
You can `docker push` to this location with these credentials.
    - For Google Cloud Registry, use the contents of the service account JSON key.
- `SERVER-NAME` is the hostname of the registry server. Examples:
    - Harbor has the form `server: "my-harbor.io"`
    - Dockerhub has the form `server: "index.docker.io"`
    - Google Cloud Registry has the form `server: "gcr.io"`
- `REPO-NAME` is where workload images are stored in the registry.
Images are written to `SERVER-NAME/REPO-NAME/workload-name`. Examples:
    - Harbor has the form `repository: "my-project/supply-chain"`
    - Dockerhub has the form `repository: "my-dockerhub-user"`
    - Google Cloud Registry has the form `repository: "my-project/supply-chain"`
- `INGRESS-DOMAIN` is the subdomain for the host name that you will point at the `tanzu-shared-ingress` service's External IP address.
- `GIT-CATALOG-URL` is the path to the `catalog-info.yaml` catalog definition file. You can download either a blank or populated catalog file from the [Tanzu Application Platform product page](https://network.pivotal.io/products/tanzu-application-platform/#/releases/1043418/file_groups/6091). Otherwise, you can use a Backstage-compliant catalog you've already built and posted on the Git infrastructure you specified in the Integration section.

>**Note:** When using the `tbs-values.yaml` configuration,
>`enable_automatic_dependency_updates: true` causes the dependency updater to update
>Tanzu Build Service dependencies (buildpacks and stacks) when they are released on
>VMware Tanzu Network. Use `false` to pause the automatic update of Build Service dependencies.
>When automatic updates are paused, the pinned version of the descriptor for TAP 1.0.2 is [100.0.267](https://network.pivotal.io/products/tbs-dependencies#/releases/1053790)
>If left undefined, this value is `false`.

### <a id="view-pkge-config-settings"></a>View possible configuration settings for your package

To view possible configuration settings for a package, run:

```
tanzu package available get tap.tanzu.vmware.com/$TAP_VERSION --values-schema --namespace tap-install
```

Where `$TAP_VERSION` is the Tanzu Application Platform version environment variable you
defined earlier.

>**Note:** The `tap.tanzu.vmware.com` package does not show all configuration settings for packages
>it plans to install. The package only shows top-level keys.
>View individual package configuration settings with the same `tanzu package available get` command.
>For example, use `tanzu package available get -n tap-install cnrs.tanzu.vmware.com/1.0.3 --values-schema` for Cloud Native Runtimes.

```
profile: full

# ...

# e.g. CNRs specific values go under its name
cnrs:
  provider: local

# e.g. App Accelerator specific values go under its name
accelerator:
  server:
    service_type: "ClusterIP"
```

The following table summarizes the top-level keys used for package-specific configuration within
your `tap-values.yml`.

|Package|Top-level Key|
|----|----|
|API portal|`api_portal`|
|Application Accelerator|`accelerator`|
|Application Live View|`appliveview`|
|Application Live View Conventions|`appliveview-conventions`|
|Cartographer|`cartographer`|
|Cloud Native Runtimes|`cnrs`|
|Supply Chain|`supply_chain`|
|Supply Chain Basic|`ootb_supply_chain_basic`|
|Supply Chain Testing|`ootb_supply_chain_testing`|
|Supply Chain Testing Scanning|`ootb_supply_chain_testing_scanning`|
|Supply Chain Security Tools - Scan|`scanning`|
|Supply Chain Security Tools - Scan (Grype Scanner)|`grype`|
|Supply Chain Security Tools - Store|`metadata_store`|
|Image Policy Webhook|`image_policy_webhook`|
|Build Service|`buildservice`|
|Tanzu Application Platform GUI|`tap_gui`|
|Learning Center|`learningcenter`|

For information about package-specific configuration, see [Install components](install-components.md).

For example, to identify the SSH secret keys for Supply Chain Basic, you can run:

```
tanzu package available get ootb-supply-chain-basic.tanzu.vmware.com/0.5.1 --values-schema -n tap-install
```

Expect to see the following outputs that list the all the SSH secret keys and the descriptions applicable to the package:

```
KEY                       DEFAULT                    TYPE    DESCRIPTION
cluster_builder           default                    string  Name of the Tanzu Build Service (TBS) ClusterBuilder to use by default on image objects managed by the supply chain.

gitops.branch             main                       string  Default branch to use for pushing Kubernetes configuration files produced by the supply chain.

gitops.commit_message     bump configuration         string  Default git commit message to write when publishing Kubernetes configuration files produces by the supply chain to git.

gitops.email              supplychain@cluster.local  string  Default user email to be used for the commits produced by the supply chain.

gitops.repository_prefix  <nil>                      string  Default prefix to be used for forming Git SSH URLs for pushing Kubernetes configuration produced by the supply chain.

gitops.ssh_secret         git-ssh                    string  Name of the default Secret containing SSH credentials to lookup in the developer namespace for the supply chain to fetch source code from and push configuration to.

gitops.username           supplychain                string  Default user name to be used for the commits produced by the supply chain.

registry.repository       <nil>                      string  Name of the repository in the image registry server where the application images from the workloads should be pushed to (required).

registry.server           index.docker.io            string  Name of the registry server where application images should be pushed to (required).

service_account           default                    string  Name of the service account in the namespace where the Workload is submitted to utilize for providing registry credentials to Tanzu Build Service (TBS) Image objects as well as deploying the application.
```  

## <a id="install-package"></a>Install your Tanzu Application Platform package

To install the Install the Tanzu Application Platform package:

1. Install the package by running:

    ```
    tanzu package install tap -p tap.tanzu.vmware.com -v $TAP_VERSION --values-file tap-values.yml -n tap-install
    ```

    Where `$TAP_VERSION` is the Tanzu Application Platform version environment variable
    you defined earlier.

1. Verify the package install by running:

    ```
    tanzu package installed get tap -n tap-install
    ```

    This may take 5-10 minutes because it installs several packages on your cluster.

1. Verify that all the necessary packages in the profile are installed by running:

    ```
    tanzu package installed list -A
    ```

1. Ensure you have
[set up developer namespaces to use installed packages](install-components.md#setup).

1. (Optional) [Install any additional packages](install-components.md) that were not included in
your profile.

After you install Full Profile or Light Profile on to your cluster, you can install the
Tanzu Developer Tools for VSCode extension to help you develop against it.
For instructions, see [Installing Tanzu Dev Tools for VSCode](vscode-extension/install.md).

## <a id='configure-envoy-lb'></a> Configure LoadBalancer for Contour Ingress

This section only applies when you use Tanzu Application Platform to deploy its own shared Contour ingress controller in `tanzu-system-ingress`. It is not applicable when you use an existing ingress with the components. You can share this ingress across `cnrs`, `tap_gui`, and `learningcenter`.

By default, Contour uses `NodePort` as the service type. To set the service type to `LoadBalancer`, add the following to your `tap-values.yml`:

```
contour:
  envoy:
    service:
      type: LoadBalancer
```

If you are using AWS, the section above creates a classic LoadBalancer.
If you want to use the Network LoadBalancer instead of the classic LoadBalancer for ingress, add the
following to your `tap-values.yml`:

```
contour:
  infrastructure_provider: aws
  envoy:
    service:
      aws:
        LBType: nlb
```

## <a id='access-tap-gui'></a> Access the Tanzu Application Platform GUI

To access Tanzu Application Platform GUI, you'll be able to use the hostname that is pointed at the
shared ingress you configured earlier.
You can configure a LoadBalancer for Tanzu Application Platform GUI if you prefer. For how to
configure one, see [Accessing Tanzu Application Platform GUI](tap-gui/accessing-tap-gui.md).

You're now ready to start using Tanzu Application Platform GUI.
Proceed to the [Getting Started](getting-started.md) topic or the
[Tanzu Application Platform GUI - Catalog Operations](tap-gui/catalog/catalog-operations.md) topic.


## <a id='exclude-packages'></a> Exclude Packages from a Tanzu Application Platform Profile

To exclude packages from a Tanzu Application Platform profile:

1. Find the full subordinate (child) package name:

    ```
    tanzu package available list --namespace tap-install
    ```

2. Update your `tap-values` file with a section listing the exclusions:

    ```
    profile: PROFILE-VALUE
    excluded_packages:
      - tap-gui.tanzu.vmware.com
      - service-bindings.lab.vmware.com
    ```

>**Note:** If you decide to exclude a package after performing a profile installation which included that package, you cannot see the the accurate package states immediately after running `tap package installed list -n tap-install`.

>**Note:** You can break package dependencies by removing a package. Allow 20 minutes to verify that all packages have reconciled correctly while troubleshooting.

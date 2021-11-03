# Installing Part II: Profiles

This document describes how to install Tanzu Application Platform packages
from the Tanzu Application Platform package repository.

Before you install the packages, ensure that you have completed the prerequisites, configured
and verified the cluster, accepted the EULA, and installed the Tanzu CLI with any required plugins.
See [Installing Part I: Prerequisites, EULA, and CLI](install-general.md).


## <a id='add-package-repositories'></a> Add the Tanzu Application Platform Package Repository

To add the Tanzu Application Platform package repository:

1. Create a namespace called `tap-install` for deploying the any component packages by running:

    ```bash
    kubectl create ns tap-install
    ```

    This namespace keeps the objects grouped together logically.

2. Create a registry secret. Run:

    ```bash
    tanzu secret registry add tap-registry \
      --username "TANZU-NET-USER" --password "TANZU-NET-PASSWORD" \
      --server registry.tanzu.vmware.com \
      --export-to-all-namespaces --yes --namespace tap-install
    ```

    Where `TANZU-NET-USER` and `TANZU-NET-PASSWORD` are your credentials for Tanzu Network.

3. Add Tanzu Application Platform package repository to the cluster by running:

    ```bash
    tanzu package repository add tanzu-tap-repository \
      --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:0.3.0-build.6 \
      --namespace tap-install
    ```
    For example:

    ```bash
    $ tanzu package repository add tanzu-tap-repository \
        --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:0.3.0-build.6 \
        --namespace tap-install
    \ Adding package repository 'tanzu-tap-repository'...

    Added package repository 'tanzu-tap-repository'
    ```

4. Get the status of the Tanzu Application Platform package repository, and ensure the status updates to `Reconcile succeeded` by running:

    ```bash
    tanzu package repository get tanzu-tap-repository --namespace tap-install
    ```
    For example:

    ```bash
    $ tanzu package repository get tanzu-tap-repository --namespace tap-install
    - Retrieving repository tap...
    NAME:          tanzu-tap-repository
    VERSION:       48756
    REPOSITORY:    registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:0.3.0-build.6
    STATUS:        Reconcile succeeded
    REASON:
    ```

5. List the available packages by running:

    ```bash
    tanzu package available list --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list --namespace tap-install
    / Retrieving available packages...
    accelerator.apps.tanzu.vmware.com                    Application Accelerator for VMware Tanzu                                  Used to create new projects and configurations.
    api-portal.tanzu.vmware.com                          API portal                                                                A unified user interface to enable search, discovery and try-out of API endpoints at ease.
    appliveview.tanzu.vmware.com                         Application Live View for VMware Tanzu                                    App for monitoring and troubleshooting running apps
    buildservice.tanzu.vmware.com                        Tanzu Build Service                                                       Tanzu Build Service enables the building and automation of containerized software workflows securely and at scale.
    cartographer.tanzu.vmware.com                        Cartographer                                                              Kubernetes native Supply Chain Choreographer.
    cnrs.tanzu.vmware.com                                Cloud Native Runtimes                                                     Cloud Native Runtimes is a serverless runtime based on Knative
    controller.conventions.apps.tanzu.vmware.com         Convention Service for VMware Tanzu                                       Convention Service enables app operators to consistently apply desired runtime configurations to fleets of workloads.
    controller.source.apps.tanzu.vmware.com              Tanzu Source Controller                                                   Tanzu Source Controller enables workload create/update from source code.
    developer-conventions.tanzu.vmware.com               Tanzu App Platform Developer Conventions                                  Developer Conventions
    grype.scanning.apps.tanzu.vmware.com                 Grype Scanner for Supply Chain Security Tools for VMware Tanzu - Scan     Default scan templates using Anchore Grype
    image-policy-webhook.signing.run.tanzu.vmware.com    Image Policy Webhook                                                      The Image Policy Webhook allows platform operators to define a policy that will use cosign to verify signatures of container images
    ootb-supply-chain-basic.tanzu.vmware.com             Tanzu App Platform Out of the Box Supply Chain Basic                      Out of the Box Supply Chain Basic
    ootb-supply-chain-testing.tanzu.vmware.com           Tanzu App Platform Out of the Box Supply Chain with Testing               Out of the Box Supply Chain with Testing
    ootb-supply-chain-testing-scanning.tanzu.vmware.com  Tanzu App Platform Out of the Box Supply Chain with Testing and Scanning  Out of the Box Supply Chain with Testing and Scanning
    ootb-templates.tanzu.vmware.com                      Tanzu App Platform Out of the Box Templates                               Out of the Box Templates  
    scanning.apps.tanzu.vmware.com                       Supply Chain Security Tools for VMware Tanzu - Scan                       Scan for vulnerabilities and enforce policies directly within Kubernetes native Supply Chains.
    scst-store.tanzu.vmware.com                          Tanzu Supply Chain Security Tools - Store                                 The Metadata Store enables saving and querying image, package, and vulnerability data.
    service-bindings.labs.vmware.com                     Service Bindings for Kubernetes                                           Service Bindings for Kubernetes implements the Service Binding Specification.
    services-toolkit.tanzu.vmware.com                    Services Toolkit                                                          The Services Toolkit enables the management, lifecycle, discoverability and connectivity of Service Resources (databases, message queues, DNS records, etc.).
    tap-gui.tanzu.vmware.com                             Tanzu Application Platform GUI                                            web app graphical user interface for Tanzu Application Platform
    tap.tanzu.vmware.com                                 Tanzu Application Platform                                                Package to install a set of Tanzu Application Platform components to get you started based on your use case.
    ```
## <a id='add-package-repositories'></a> About Tanzu Application Platform Package Profiles
Tanzu Application Platform can be installed through pre-defined profiles or through individual packages. This section explains how to install a profile.

Tanzu Application Platform contains the following four profiles:
- Full (`full`)
- Developer Light (`dev-light`)
- Shared Tools (`shared-tools`)
- Operator Light (`operator-light`)

The following table lists the packages that are contained in each profile:

<table>
  <tr>
   <td><strong>Product Name</strong>
   </td>
   <td><strong>Full</strong>
   </td>
   <td><strong>Developer Light</strong>
   </td>
   <td><strong>Shared Tools</strong>
   </td>
   <td><strong>Operator Light</strong>
   </td>
  </tr>
  <tr>
   <td>API Portal
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>&check;
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>Application Accelerator
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>&check;
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>App Live View
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>Cartographer
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>Cloud Native Runtimes
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>Convention Controller
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>Out of the Box Supply Chain - Basic
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>Out of the Box Supply Chain - Testing
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>Out of the Box Supply Chain - Testing and Scanning
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>Out of the Box Templates
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>Developer Conventions
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>Flux Source Controller
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>Image Policy Webhook
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>Learning Center
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>&check;
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>Services Toolkit
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>Service Bindings
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>Source Controller
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>Spring Boot Convention
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>Tanzu Build Service
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>Tanzu Application Platform GUI
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>Tanzu Supply Chain Security Tools - Scan
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>Tekton
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
  </tr>
</table>

## <a id='install-profile'></a> Install a Tanzu Application Platform Profile
Install a profile by using the `tap.tanzu.vmware.com` package. The `tap.tanzu.vmware.com` package installs predefined sets of packages based on your profile setting.

To install a profile:

1. List version information for the package by running:

    ```bash
    tanzu package available list tap.tanzu.vmware.com --namespace tap-install
    ```

1. Create a `tap-values.yml` using the following sample as a guide. Select a profile to install by changing the `profile` value. Run:
    ```yaml
    # e.g. full, dev-light, shared-tools, operator-light
    profile: full

    buildservice:
      # e.g. us-east4-docker.pkg.dev/some-project-id/test-private-repo/apps
      kp_default_repository: "..."
      kp_default_repository_username: "..."
      kp_default_repository_password: "..."
      tanzunet_username: "TANZUNET-USERNAME"
      tanzunet_password: "TANZUNET-PASSWORD"

    ootb_supply_chain_basic:
      registry:
        # e.g. us-east4-docker.pkg.dev
        server: "..."
        # e.g. some-project-id/test-private-repo/apps
        repository: "..."

    learningcenter:
      ingressDomain: "<DOMAIN-NAME>" # e.g. educates.example.com

    tap_gui:
      service_type: LoadBalancer
    ```

    To view possible configuration settings, run:

    ```bash
    tanzu package available get tap.tanzu.vmware.com/0.3.0-build.6 --values-schema --namespace tap-install
    ```

    >**Note:** The `tap.tanzu.vmware.com` package does not show all configuration settings for packages it plans to install. The package only shows top level keys. 
    View individual package configuration settings with the same `tanzu package available get` command. For example, use `tanzu package available get -n tap-install cnrs.tanzu.vmware.com/1.0.3 --values-schema` for Cloud Native Runtimes. Replace dashes with underscores. For example, if the package name is `tap-gui`, use `tap_gui` in the `tap-values.yml` file.

    ```yaml
    profile: full

    # ...

    # e.g. CNRs specific values would go under its name
    cnrs:
      provider: local

    # e.g. App Accelerator specific values would go under its name
    accelerator:
      service_type: "ClusterIP"
    ```

    For information about package specific configuration, see [Install components](install-components.md).

1. Install the package by running:

    ```bash
    tanzu package install tap -p tap.tanzu.vmware.com -v 0.3.0-build.6 --values-file tap-values.yml -n tap-install
    ```

1. Verify the package install by running:

    ```bash
    tanzu package installed get tap -n tap-install
    ```

    This may take 5-10 minutes as it installs several packages on your cluster.

1. Verify all the necessary packages in the profile are installed by running:
    ```bash
    tanzu package installed list -A
    ```

1. (Optional) [Install any additional packages](install-components.md) that were not included in your profile.

## <a id='configure-tap-gui'></a> Configure the Tanzu Application Platform GUI
To install Tanzu Application Platform GUI, see the following sections.

#### Prerequisites

- Git repository for the software catalogs and a token allowing read access.
Supported Git infrastructure includes:
    - GitHub
    - GitLab
    - Azure DevOps
- Blank Software Catalog from the Tanzu Application section of Tanzu Network

#### Procedure

To install Tanzu Application Platform GUI:

1. Extract the Blank Software Catalog from the Tanzu Application Network on your Git repository of choice. You'll link to that `catalog-info.yaml` file when you configure your catalog below.

1. Obtain you the `External IP` of your LoadBalancer via `kubectl get svc -n tap-gui`.

2. Add the following section to your `tap-values.yml` using the below template. Replace all `<PLACEHOLDERS>`
with your relevant values. Run:

    ```yaml
    tap_gui:
      service_type: LoadBalancer
      # Existing tap-values.yml above  
      app-config:
        app:
          baseUrl: http://EXTERNAL-IP:7000
        integrations:
          github: # Other integrations available see NOTE below
            - host: github.com
              token: GITHUB-TOKEN
        catalog:
          locations:
            - type: url
              target: https://GIT-CATALOG-URL/catalog-info.yaml
        backend:
            baseUrl: http://EXTERNAL-IP:7000
            cors:
                origin: http://EXTERNAL-IP:7000
   ```
    Where:

    - `EXTERNAL-IP` is your LoadBalancer's address.
    - `GITHUB-TOKEN` is a valid token generated from your Git infrastructure of choice with the necessary read permissions for the catalog definition files you extracted from the Blank Software Catalog.
    - `GIT-CATALOG-URL` is the path to the `catalog-info.yaml` catalog definition file from either the included Blank catalog (provided as an additional download named "Blank Tanzu Application Platform GUI Catalog") or a Backstage compliant catalog that you've already built and posted on the Git infrastucture that you specified in the Integration section.

    > **Note:** The `integrations` section uses Github. If you want additional integrations, see the
    format in this [Backstage integration documentation](https://backstage.io/docs/integrations/).

1. Update the package profile by running:

    ```console
    tanzu package installed update tap \
     --package-name tap.tanzu.vmware.com \
     --version 0.3.0 -n tap-install \
     -f tap-values.yml
    ```

    For example:

    ```console

    $ tanzu package installed update  tap -p tap.tanzu.vmware.com -v 0.3.0 --values-file tap-values-file.yml -n tap-install
    | Updating package 'tap'
    | Getting package install for 'tap'
    | Getting package metadata for 'tap.tanzu.vmware.com'
    | Updating secret 'tap-tap-install-values'
    | Updating package install for 'tap'
    / Waiting for 'PackageInstall' reconciliation for 'tap'


    Updated package install 'tap' in namespace 'tap-install'
    ```

1. To access Tanzu Application Platform GUI, use the `EXTERNAL-IP` you exposed in the
`service_type` above.
If you have any issues, try re-creating the Tanzu Application Platform Pod by running:

    ```console
    kubectl delete pod -l app=backstage -n tap-gui
    ```

You're now ready to start using Tanzu Application Platform GUI.
Proceed to the [Getting Started](getting-started.md) topic or the
[Tanzu Application Platform GUI - Catalog Operations](tap-gui/catalog/catalog-operations.md) topic.

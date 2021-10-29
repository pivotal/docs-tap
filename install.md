# Installing Part II: Profiles

This document describes how to install Tanzu Application Platform packages
from the Tanzu Application Platform package repository.

Before you install the packages, ensure that you have completed the prerequisites, configured
and verified the cluster, accepted the EULA, and installed the Tanzu CLI with any required plugins.
For information, see [Installing Part I: Prerequisites, EULA, and CLI](install-general.md).


## <a id='add-package-repositories'></a> Add the Tanzu Application Platform Package Repository

To add the Tanzu Application Platform package repository:

1. Create a namespace called `tap-install` for deploying the packages of the components by running:

    ```bash
    kubectl create ns tap-install
    ```

    This namespace is to keep the objects grouped together logically.

2. Create a registry secret:

    ```bash
    tanzu secret registry add tap-registry \
      --username TANZU-NET-USER --password TANZU-NET-PASSWORD \
      --server registry.tanzu.vmware.com \
      --export-to-all-namespaces --namespace tap-install
    ```

    Where `TANZU-NET-USER` and `TANZU-NET-PASSWORD` are your credentials for Tanzu Network.

3. Add Tanzu Application Platform package repository to the cluster by running:

    ```bash
    $ tanzu package repository add tanzu-tap-repository \
        --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:0.3.0-build.4 \
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
    REPOSITORY:    registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:0.3.0-build.4
    STATUS:        Reconcile succeeded
    REASON:
    ```

    This currently may take around 1min (TanzuNet team is actively working on supporting imgpkg caching mechanism that should cut this down back to 10s).

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
    tap.tanzu.vmware.com                                 Tanzu Application Platform                                                Package to install a set of TAP components to get you started based on your use case.
    ```
## <a id='add-package-repositories'></a> About Tanzu Application Platform Package Profiles
Tanzu Application Platform can be installed through pre-defined profiles or through individual packages. This section explains how you can install a profile.

There are four profiles:
- Full (`full`)
- Developer Light (`dev-light`)
- Shared Tools (`shared-tools`)
- Operator Light (`operator-light`)

This table lists the packages that are contained in each profile:

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
   <td>Cloud Native Runtime
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
   <td>Default Supply Chain
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
   <td>Default Supply Chain - Testing
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
   <td>Services Control Plane Toolkit
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
   <td>TAP GUI
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
Installation of a profile happens via `tap.tanzu.vmware.com` package. `tap.tanzu.vmware.com` package installs predefined sets of packages based on chosen profile setting.

To install a profile:

1. List version information for the package by running:

    ```bash
    tanzu package available list tap.tanzu.vmware.com --namespace tap-install
    ```

1. Create a `tap-values.yml` using the following sample as a guide. 
    ```yaml
    # e.g. full, dev-light, shared-tools, operator-light
    profile: full
    buildservice:
      tanzunet_username: "TANZUNET-USERNAME"
      tanzunet_password: "TANZUNET-PASSWORD"
    rw_app_registry:
      # e.g. index.docker.io/some-user/apps
      # e.g. us-east4-docker.pkg.dev/some-project-id/test-private-repo/apps
      server_repo: "SERVER-REPO"
      username: "USERNAME"
      password: "PASSWORD"
    ingressDomain: "DOMAIN-NAME" # e.g. educates.example.com
    ```

    To view possible configuration settings, run:

    ```bash
    tanzu package available get tap.tanzu.vmware.com/0.3.0-build.4 --values-schema --namespace tap-install
    ```

    Note that currently `tap.tanzu.vmware.com` package does not show all configuration settings for packages it plans to install. To find them out, look at individual package configuration settings via same `tanzu package available get` command (e.g. for CNRs use `tanzu package available get -n tap-install cnrs.tanzu.vmware.com/1.0.3 --values-schema`).

    ```yaml
    profile: full
    buildservice:
      # ...
    rw_app_registry:
      # ...

    # e.g. CNRs specific values would go under its name
    cnrs:
      provider: local
    # e.g. App Accelerator specific values would go under its name
    app_accelerator:
      service_type: "ClusterIP"
    ```

    (Refer to [Install components](install-components.md) document for package specific configuration.)

1. Install the package by running:

    ```bash
    tanzu package install tap -p tap.tanzu.vmware.com -v 0.3.0-build.4 --values tap-values.yml -n tap-install
    ```

1. Verify the package install by running:

    ```bash
    tanzu package installed get tap -n tap-install
    ```

    This may take 5-10mins as it will install number of packages on your cluster.

1. Verify all the necessary packages in the profile are installed by running:
    ```bash
    tanzu package installed list -A
    ```

1. (Optional) [Install any additional packages](install-components.md) that were not included in your profile.

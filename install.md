# <a id='installing'></a> Installing Part II: Packages

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
    tanzu package repository add tanzu-tap-repository \
        --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:TAP-VERSION \
        --namespace tap-install
    ```

    Where `TAP-VERSION` is the version of Tanzu Application Platform you want to install.
    For example:

    ```bash
    $ tanzu package repository add tanzu-tap-repository \
        --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:0.3.0-build.1 \
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
    REPOSITORY:    registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:0.3.0-build.1
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
    ```
## <a id='add-package-repositories'></a> About Tanzu Application Platform Package Profiles
Tanzu Application Platform can be installed through pre-defined profiles or through individual packages. This section explains how you can install a profile.
There are four profiles to choose from - Full, Developer Light, Shared Tools, and Operator Light. The following table lists the packages that are contained in each profile:
[ToDo: Add table for profiles]

## <a id='install-profile'></a> Install a Tanzu Application Platform Profile
To install a profile:

1. List version information for the package by running:

    ```bash
    $ tanzu package available list tap.tanzu.vmware.com --namespace tap-install
    ```

1. To view possible configuration settings, run:

    ```bash
    tanzu package available get PACKAGE-NAME/VERSION-NUMBER --values-schema --namespace tap-install
    ```
    Where:

    - `PACKAGE-NAME` is same as step 5 above.
    - `VERSION-NUMBER` is the version of the package listed in step 5 above.

    For example:

    ```bash
    $ tanzu package available get tap.tanzu.vmware.com/0.3.0 --values-schema --namespace tap-install
    ```

1. Create a `tap-values.yml` using the following sample as a guide. 
    ```yaml
    profile: full
    buildservice:
      tanzunet_username: "TANZUNET-USERNAME"
      tanzunet_password: "TANZUNET-PASSWORD"
    rw_app_registry:
      server_repo: "SERVER-REPO"
      username: "USERNAME"
      password: "PASSWORD"
    ```

1. Install the package by running:

    ```bash
    tanzu package install tap -p tap.tanzu.vmware.com -v 0.3.0 --values tap-values.yml -n tap-install
    ```

1. Verify the package install by running:

    ```bash
    tanzu package installed get tap -n tap-install
    ```

1. Verify all the necessary packages in the profile are installed by running:
    ```bash
    tanzu package installed list -A
    ```

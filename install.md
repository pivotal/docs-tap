# Installing part II: profiles

This document describes how to install Tanzu Application Platform packages
from the Tanzu Application Platform package repository.

Before you install the packages, ensure you have completed the prerequisites, configured
and verified the cluster, accepted the EULA, and installed the Tanzu CLI with any required plugins.
See [Installing Part I: Prerequisites, EULA, and CLI](install-general.md).


## <a id='add-package-repositories'></a> Add the Tanzu Application Platform package repository

To add the Tanzu Application Platform package repository:

1. Setup environment variables that will be used during install

    ```
    export INSTALL_REGISTRY_USERNAME=TANZU-NET-USER
    export INSTALL_REGISTRY_PASSWORD=TANZU-NET-PASSWORD
    export INSTALL_REGISTRY_HOSTNAME=registry.tanzu.vmware.com
    ```

2. Create a namespace called `tap-install` for deploying any component packages by running:

    ```
    kubectl create ns tap-install
    ```

    This namespace keeps the objects grouped together logically.

3. Create a registry secret. Run:

    ```
    tanzu secret registry add tap-registry \
      --username ${INSTALL_REGISTRY_USERNAME} --password ${INSTALL_REGISTRY_PASSWORD} \
      --server ${INSTALL_REGISTRY_HOSTNAME} \
      --export-to-all-namespaces --yes --namespace tap-install
    ```

4. Add Tanzu Application Platform package repository to the cluster by running:

    ```
    tanzu package repository add tanzu-tap-repository \
      --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:0.4.0 \
      --namespace tap-install
    ```
    For example:

    ```
    $ tanzu package repository add tanzu-tap-repository \
        --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:0.4.0 \
        --namespace tap-install
    \ Adding package repository 'tanzu-tap-repository'...

    Added package repository 'tanzu-tap-repository'
    ```

5. Get the status of the Tanzu Application Platform package repository, and ensure the status updates to `Reconcile succeeded` by running:

    ```
    tanzu package repository get tanzu-tap-repository --namespace tap-install
    ```
    For example:

    ```
    $ tanzu package repository get tanzu-tap-repository --namespace tap-install
    - Retrieving repository tap...
    NAME:          tanzu-tap-repository
    VERSION:       3769
    REPOSITORY:    registry.tanzu.vmware.com/tanzu-application-platform/tap-packages
    TAG:           0.4.0
    STATUS:        Reconcile succeeded
    REASON:
    ```

6. List the available packages by running:

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
      scst-grype.apps.tanzu.vmware.com                     Grype Scanner for Supply Chain Security Tools - Scan                      Default scan templates using Anchore Grype
      image-policy-webhook.signing.run.tanzu.vmware.com    Image Policy Webhook                                                      The Image Policy Webhook allows platform operators to define a policy that will use cosign to verify signatures of container images
      learningcenter.tanzu.vmware.com                      Learning Center for Tanzu Application Platform                            Guided technical workshops
      ootb-supply-chain-basic.tanzu.vmware.com             Tanzu App Platform Out of The Box Supply Chain Basic                      Out of The Box Supply Chain Basic.
      ootb-supply-chain-testing-scanning.tanzu.vmware.com  Tanzu App Platform Out of The Box Supply Chain with Testing and Scanning  Out of The Box Supply Chain with Testing and Scanning.
      ootb-supply-chain-testing.tanzu.vmware.com           Tanzu App Platform Out of The Box Supply Chain with Testing               Out of The Box Supply Chain with Testing.
      ootb-templates.tanzu.vmware.com                      Tanzu App Platform Out of The Box Templates                               Out of The Box Templates.
      scst-scan.apps.tanzu.vmware.com                      Supply Chain Security Tools - Scan                                        Scan for vulnerabilities and enforce policies directly within Kubernetes native Supply Chains.
      scst-store.tanzu.vmware.com                          Tanzu Supply Chain Security Tools - Store                                 The Metadata Store enables saving and querying image, package, and vulnerability data.
      service-bindings.labs.vmware.com                     Service Bindings for Kubernetes                                           Service Bindings for Kubernetes implements the Service Binding Specification.
      services-toolkit.tanzu.vmware.com                    Services Toolkit                                                          The Services Toolkit enables the management, lifecycle, discoverability and connectivity of Service Resources (databases, message queues, DNS records, etc.).
      spring-boot-conventions.tanzu.vmware.com             Tanzu Spring Boot Conventions Server                                      Default Spring Boot convention server.
      tap-gui.tanzu.vmware.com                             Tanzu Application Platform GUI                                            web app graphical user interface for Tanzu Application Platform
      tap.tanzu.vmware.com                                 Tanzu Application Platform                                                Package to install a set of TAP components to get you started based on your use case.
      workshops.learningcenter.tanzu.vmware.com            Workshop Building Tutorial                                                Workshop Building Tutorial
    ```

## <a id='about-package-profiles'></a> About Tanzu Application Platform package profiles

Tanzu Application Platform can be installed through pre-defined profiles or through individual
packages. This section explains how to install a profile.

Tanzu Application Platform contains the following two profiles:

- Full (`full`)
- Dev (`dev`)

The following table lists the packages contained in each profile:

<table>
  <tr>
   <td><strong>Capability Name</strong>
   </td>
   <td><strong>Full</strong>
   </td>
   <td><strong>Dev</strong>
   </td>
  </tr>
  <tr>
   <td>API Portal
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
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>Application Live View
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>Application Live View Conventions
   </td>
   <td>&check;
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
  </tr>
  <tr>
   <td>Convention Controller
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>Out of the Box Delivery - Basic
   </td>
   <td>&check;
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
  </tr>
  <tr>
   <td>Out of the Box Supply Chain - Testing
   </td>
   <td>&check;<sup>&ast;</sup>
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>Out of the Box Supply Chain - Testing and Scanning
   </td>
   <td>&check;<sup>&ast;</sup>
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>Out of the Box Templates
   </td>
   <td>&check;
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
  </tr>
  <tr>
   <td>Flux Source Controller
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>Grype
   </td>
   <td>&check;
   </td>
   <td>
   </td>
  </tr>  
  <tr>
   <td>Image Policy Webhook
   </td>
   <td>&check;
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>Learning Center
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
  </tr>
  <tr>
   <td>Service Bindings
   </td>
   <td>&check;
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
  </tr>
  <tr>
   <td>Spring Boot Convention
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>Supply Chain Choreographer
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>Supply Chain Security Tools - Scan</td>
   <td>&check;</td><td></td>
  </tr>
  <tr>
   <td>Supply Chain Security Tools - Store</td>
   <td>&check;</td><td></td>
  </tr>
  <tr>
   <td>Tanzu Build Service
   </td>
   <td>&check;
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
  </tr>
  <tr>
   <td>Tekton
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
  </tr>
</table>

<sup>\*</sup> Only one supply chain should be installed at any given time.
For information on switching from one supply chain to another, see [Getting Started with Tanzu Application Platform](getting-started.md).

## <a id='install-profile'></a> Install a Tanzu Application Platform profile

Install a profile by using the `tap.tanzu.vmware.com` package.
The `tap.tanzu.vmware.com` package installs predefined sets of packages based on your profile
setting.

To install a profile:

1. List version information for the package by running:

    ```
    tanzu package available list tap.tanzu.vmware.com --namespace tap-install
    ```

1. Create a `tap-values.yml` file by using the applicable profile sample as a guide.
These samples have the minimum configuration required to deploy Tanzu Application Platform.
The sample values file contains the necessary defaults for both the meta-package
('parent' Tanzu Application Platform package) and subordinate packages
(individual 'child' packages).
The values file you provide during installation is used for further configuration
of Tanzu Application Platform.

>**Important:** Keep this file for future use.

### Full Profile

```
profile: full
ceip_policy_disclosed: true # Expects a true or false boolean value
buildservice:
  kp_default_repository: "<KP-DEFAULT-REPO>"
  kp_default_repository_username: "<KP-DEFAULT-REPO-USERNAME>"
  kp_default_repository_password: "<KP-DEFAULT-REPO-PASSWORD>"
  tanzunet_username: "<TANZUNET-USERNAME>"
  tanzunet_password: "<TANZUNET-PASSWORD>"

supply_chain: basic

ootb_supply_chain_basic:
  registry:
    server: "<SERVER-NAME>"
    repository: "<REPO-NAME>"

learningcenter:
  ingressDomain: "<DOMAIN-NAME>"

tap_gui:
  service_type: LoadBalancer # NodePort for distributions that don't support LoadBalancer

metadata_store:
  app_service_type: LoadBalancer # (optional) Defaults to LoadBalancer. Change to NodePort for distributions that don't support LoadBalancer
```

### Dev Profile

```
profile: dev
ceip_policy_disclosed: true # Expects a true or false boolean value

buildservice:
  kp_default_repository: "<KP-DEFAULT-REPO>"
  kp_default_repository_username: "<KP-DEFAULT-REPO-USERNAME>"
  kp_default_repository_password: "<KP-DEFAULT-REPO-PASSWORD>"
  tanzunet_username: "<TANZUNET-USERNAME>"
  tanzunet_password: "<TANZUNET-PASSWORD>"

supply_chain: basic

ootb_supply_chain_basic:
  registry:
    server: "<SERVER-NAME>"
    repository: "<REPO-NAME>"

tap_gui:
  service_type: LoadBalancer # NodePort for distributions that don't support LoadBalancer

metadata_store:
  app_service_type: LoadBalancer # (optional) Defaults to LoadBalancer. Change to NodePort for distributions that don't support LoadBalancer
```
Where:

   - `<PROFILE-VALUE>` is a value such as `full` or `dev`.
    - `<ceip-policy-disclosed>` must have the value `true`.
    **Note:** If the value is not set to `true`, installation fails.

    - `<KP-DEFAULT-REPO>` is a writable repository in your registry. Tanzu Build Service dependencies are written to this location.
      * Examples:
        * Harbor `kp_default_repository: "my-harbor.io/my-project/build-service"`
        * Dockerhub `kp_default_repository: "my-dockerhub-user/build-service"` or `kp_default_repository: "index.docker.io/my-user/build-service"`
        * Google Cloud Registry `kp_default_repository: "gcr.io/my-project/build-service"`
    - `<KP-DEFAULT-REPO-USERNAME>` is the username that can write to the `<KP-DEFAULT-REPO>`. You should be able to `docker push` to this location with this credential.
      * For Google Cloud Registry, use `kp_default_repository_username: _json_key`
    - `<KP-DEFAULT-REPO-PASSWORD>` is the password for the user that can write to the `<KP-DEFAULT-REPO>`. You can `docker push` to this location with these credentials.
      * For Google Cloud Registry, use the contents of the service account json key.
    - `<SERVER-NAME>` is the hostname of the registry server.
      * Examples:
         * Harbor `server: "my-harbor.io"`
         * Dockerhub `server: "index.docker.io"`
         * Google Cloud Registry `server: "gcr.io"`
    - `<REPO-NAME>` is the location workload images will be stored in the registry. Images will be written to `<SERVER-NAME>/<REPO-NAME>/<workload-name>`.
       * Examples:
          * Harbor `repository: "my-project/supply-chain"`
          * Dockerhub `repository: "my-dockerhub-user"`
          * Google Cloud Registry `repository: "my-project/supply-chain"`
    - `<DOMAIN-NAME>` has a value such as `educates.example.com`.

  To view possible configuration settings for a package, run:

  ```
    tanzu package available get tap.tanzu.vmware.com/0.4.0 --values-schema --namespace tap-install
   ```

   >**Note:** The `tap.tanzu.vmware.com` package does not show all configuration settings for packages it plans to install. The package only shows top level keys.
    View individual package configuration settings with the same `tanzu package available get` command. For example, use `tanzu package available get -n tap-install cnrs.tanzu.vmware.com/1.0.3 --values-schema` for Cloud Native Runtimes.

   ```
    profile: full

    # ...

    # e.g. CNRs specific values would go under its name
    cnrs:
      provider: local

    # e.g. App Accelerator specific values would go under its name
    accelerator:
      service_type: "ClusterIP"
   ```

   The following table summarizes the top level keys used for package-specific configuration within
    your `tap-values.yml`

   |Package|Top Level Key|
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
  |Supply Chain Security Tools - Store|`metadata_store`|
  |Image Policy Webhook|`image_policy_webhook`|
  |Build Service|`buildservice`|
  |Tanzu Application Platform GUI|`tap_gui`|
  |Learning Center|`learningcenter`|

  For information about package-specific configuration, see [Install components](install-components.md).

1. Install the package by running:

    ```
    tanzu package install tap -p tap.tanzu.vmware.com -v 0.4.0 --values-file tap-values.yml -n tap-install
    ```

2. Verify the package install by running:

    ```
    tanzu package installed get tap -n tap-install
    ```

    This may take 5-10 minutes as it installs several packages on your cluster.

3. Verify all the necessary packages in the profile are installed by running:
    ```
    tanzu package installed list -A
    ```

4. (Optional) [Install any additional packages](install-components.md) that were not included in your profile.

## <a id='configure-envoy-lb'></a> Configure LoadBalancer for Contour ingress

By default, Contour uses `NodePort` as the service type. To set the service type to `LoadBalancer`, add the following to your `tap-values.yml`:

```
contour:
  envoy:
    service:
      type: LoadBalancer
```

If you are using AWS, the section above creates a classic LoadBalancer. If you want to use the Network LoadBalancer instead of the classic LoadBalancer for ingress, Add the following to your `tap-values.yml`:

```
contour:
  infrastructure_provider: aws
  envoy:
    service:
      aws:
        LBType: nlb
```

## <a id='configure-tap-gui'></a> Configure the Tanzu Application Platform GUI
To install Tanzu Application Platform GUI, see the following sections.

#### Procedure

To install Tanzu Application Platform GUI:

1. Extract the Blank Software Catalog from the Tanzu Application Network on your Git repository of choice. You'll link to that `catalog-info.yaml` file when you configure your catalog below.

1. Obtain the `External IP` of your LoadBalancer by running:
   ```
   kubectl get svc -n tap-gui
   ```

2. Add the following section to your `tap-values.yml` by using the following template. Replace all `<PLACEHOLDERS>`
with your relevant values. Run:

    ```
    tap_gui:
      service_type: LoadBalancer
      # Existing tap-values.yml above  
      app_config:
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
    - `GIT-CATALOG-URL` is the path to the `catalog-info.yaml` catalog definition file from either the included Blank catalog (provided as an additional download named "Blank Tanzu Application Platform GUI Catalog") or a Backstage compliant catalog you've already built and posted on the Git infrastucture you specified in the Integration section.

    > **Note:** The `integrations` section uses Github. If you want additional integrations, see the
    format in this [Backstage integration documentation](https://backstage.io/docs/integrations/).

**Optional Tanzu Application Platform GUI Database Configuration**
The default database mechanism for TAP-GUI is an in-memory database that is recommended for test/dev only and you can delete/comment-out this section of the configuration. However, when the TAP GUI server pod gets re-created, you'll lose all user preferences and any manually registered entities. For production or general-purpose use-cases, we recommend using a PostgreSQL database.

```
    backend:
      baseUrl: http://tap-gui.<DOMAIN_NAME>-IP:7000
      cors:
          origin: http://tap-gui.<DOMAIN_NAME>-IP:7000
    # Existing tap-values.yml above
      database: #External database strongly recommended for production use
        client: pg
          connection:
            host: <PG_SQL_HOSTNAME>
            port: 5432
            user: <PG_SQL_USERNAME>
            password: <PG_SQL_PASSWORD>
            ssl: {rejectUnauthorized: false} #Set to true if using SSL
```

Where:

  - `PG_SQL_HOSTNAME` is the hostname of your PostgreSQL database.
  - `PG_SQL_USERNAME` is the username of your PostgreSQL database.
  - `PG_SQL_PASSWORD` is the password of your PostgreSQL database.

4. Update the package profile by running:

    ```
    tanzu package installed update tap \
     --package-name tap.tanzu.vmware.com \
     --version 0.4.0 -n tap-install \
     -f tap-values.yml
    ```

    For example:

    ```
    $ tanzu package installed update  tap --package-name tap.tanzu.vmware.com --version 0.4.0 --values-file tap-values-file.yml -n tap-install
    | Updating package 'tap'
    | Getting package install for 'tap'
    | Getting package metadata for 'tap.tanzu.vmware.com'
    | Updating secret 'tap-tap-install-values'
    | Updating package install for 'tap'
    / Waiting for 'PackageInstall' reconciliation for 'tap'


    Updated package install 'tap' in namespace 'tap-install'
    ```

5. To access the Tanzu Application Platform GUI, use the `baseURL` location you specified above. This consists of the `EXTERNAL-IP` with the default port of 7000. Run:
    ```
    http://EXTERNAL-IP:7000
    ```

6. If you have any issues, try re-creating the Tanzu Application Platform Pod by running:

    ```
    kubectl delete pod -l app=backstage -n tap-gui
    ```

You're now ready to start using Tanzu Application Platform GUI.
Proceed to the [Getting Started](getting-started.md) topic or the
[Tanzu Application Platform GUI - Catalog Operations](tap-gui/catalog/catalog-operations.md) topic.

## <a id='exclude-packages'></a> Exclude packages from a Tanzu Application Platform profile

1. If you desire to exlude packages from a given profile, first you'll need to find the full subordinate (child) package name:


    ```
    tanzu package available list --namespace tap-install
    ```

2. Update your tap-values file with a section listing the exclusions:

    ```
    profile: <PROFILE-VALUE>
    excluded_packages:
      - tap-gui.tanzu.vmware.com
      - service-bindings.lab.vmware.com
    ```

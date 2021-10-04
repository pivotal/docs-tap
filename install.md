# <a id='installing'></a> Installing Part II: Packages

This document describes how to install Tanzu Application Platform packages
from the Tanzu Application Platform package repository.

Before you install the packages, ensure that you have completed the prerequisites, configured
and verified the cluster, accepted the EULA, and installed the Tanzu CLI and the package plugin.
For information, see [Installing Part I: Prerequisites, Cluster Configurations, EULA, and CLI](install-general.md).


## <a id='install-packages'></a> About Installing Packages

The parameters that are required for the installation need to be defined in a YAML file.

The required parameters for the individual packages can be identified by the values schema
that are defined in the package.
You can get these parameters by running the command
as described in the procedure below.

## <a id='add-package-repositories'></a> Add the Tanzu Application Platform Package Repository

To add the Tanzu Application Platform package repository:

1. Create a namespace called `tap-install` for deploying the packages of the components by running:

    ```bash
    kubectl create ns tap-install
    ```

    This namespace is to keep the objects grouped together logically.

2. Create a imagepullsecret:

    ```bash
    tanzu imagepullsecret add tap-registry \
      --username TANZU-NET-USER --password TANZU-NET-PASSWORD \
      --registry registry.tanzu.vmware.com \
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
        --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:0.2.0 \
        --namespace tap-install
    \ Adding package repository 'tanzu-tap-repository'...

    Added package repository 'tanzu-tap-repository'
    ```

4. Get status of the Tanzu Application Platform package repository, and ensure the status updates to `Reconcile succeeded` by running:

    ```bash
    tanzu package repository get tanzu-tap-repository --namespace tap-install
    ```
    For example:

    ```bash
    $ tanzu package repository get tanzu-tap-repository --namespace tap-install
    - Retrieving repository tap...
    NAME:          tanzu-tap-repository
    VERSION:       5712276
    REPOSITORY:    registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:0.2.0
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
      NAME                                               DISPLAY-NAME                                                           SHORT-DESCRIPTION
      accelerator.apps.tanzu.vmware.com                  Application Accelerator for VMware Tanzu                               Used to create new projects and configurations.
      api-portal.tanzu.vmware.com                        API portal                                                             A unified user interface to enable search, discovery and try-out of API endpoints at ease.
      appliveview.tanzu.vmware.com                       Application Live View for VMware Tanzu                                 App for monitoring and troubleshooting running apps
      buildservice.tanzu.vmware.com                      Tanzu Build Service                                                    Tanzu Build Service enables the building and automation of containerized software workflows securely and at scale.
      cartographer.tanzu.vmware.com                      Cartographer                                                           Kubernetes native Supply Chain Choreographer.
      cnrs.tanzu.vmware.com                              Cloud Native Runtimes                                                  Cloud Native Runtimes is a serverless runtime based on Knative
      controller.conventions.apps.tanzu.vmware.com       Convention Service for VMware Tanzu                                    Convention Service enables app operators to consistently apply desired runtime configurations to fleets of workloads.
      controller.source.apps.tanzu.vmware.com            Tanzu Source Controller                                                Tanzu Source Controller enables workload create/update from source code.
      default-supply-chain-testing.tanzu.vmware.com      Tanzu App Platform Default Supply Chain with Testing                   Default Software Supply Chain with testing.
      default-supply-chain.tanzu.vmware.com              Tanzu App Platform Default Supply Chain                                Default Supply Chain
      developer-conventions.tanzu.vmware.com             Tanzu App Platform Develooper Conventions                              Developer Conventions
      grype.scanning.apps.tanzu.vmware.com               Grype Scanner for Supply Chain Security Tools for VMware Tanzu - Scan  Default scan templates using Anchore Grype
      image-policy-webhook.signing.run.tanzu.vmware.com  Image Policy Webhook                                                   The Image Policy Webhook allows platform operators to define a policy that will use cosign to verify signatures of container images
      scanning.apps.tanzu.vmware.com                     Supply Chain Security Tools for VMware Tanzu - Scan                    Scan for vulnerabilities and enforce policies directly within Kubernetes native Supply Chains.
      scp-toolkit.tanzu.vmware.com                       SCP Toolkit                                                            The SCP Toolkit
      scst-store.tanzu.vmware.com                        Tanzu Supply Chain Security Tools - Store                              The Metadata Store enables saving and querying image, package, and vulnerability data.
      service-bindings.labs.vmware.com                   Service Bindings for Kubernetes                                        Service Bindings for Kubernetes implements the Service Binding Specification.
    ```

## <a id='general-procedure-to-install-a-package'></a> General Procedure to Install a Package

To install any package from the Tanzu Application Platform package repository:


1. List version information for the package by running:

    ```bash
    tanzu package available list PACKAGE-NAME --namespace tap-install
    ```
    Where:

     + `PACKAGE-NAME` is the name of the package listed in step 5 of
     [Add the Tanzu Application Platform Package Repository](#add-package-repositories) above.
    For example:

    ```bash
    $ tanzu package available list cnrs.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for cnrs.tanzu.vmware.com...
      NAME                   VERSION  RELEASED-AT
      cnrs.tanzu.vmware.com  1.0.2    2021-08-30T00:00:00Z
    ```

2. (Optional) To make changes to the default installation settings, run:

    ```bash
    tanzu package available get PACKAGE-NAME/VERSION-NUMBER --values-schema --namespace tap-install
    ```

     Where:
     + `PACKAGE-NAME` is same as step 1 above.
     + `VERSION-NUMBER` is the version of the package listed in step 1 above.

    For example:

    ```bash
    $ tanzu package available get cnrs.tanzu.vmware.com/1.0.2 --values-schema --namespace tap-install
    ```

    For more information about values schema options, see the individual product documentation.

3. Follow the specific installation instructions for each package:

    + [Install Cloud Native Runtimes](#install-cnr)
    + [Install Application Accelerator](#install-app-accelerator)
    + [Install Convention Service](#install-convention-service)
    + [Install Source Controller](#install-source-controller)
    + [Install Default Supply Chain](#install-default-supply-chain)
    + [Install Developer Conventions](#install-developer-conventions)
    + [Install Application Live View](#install-app-live-view)
    + [Install Service Bindings](#install-service-bindings)
    + [Install Tanzu Build Service](#install-tbs)
    + [Install Supply Chain Choreographer](#-install-supply-chain-choreographer)
    + [Install Default Supply Chains](#-install-default-supply-chains)
    + [Install Supply Chain Security Tools - Store](#install-scst-store)
    + [Install Supply Chain Security Tools - Sign](#install-scst-sign)
    + [Install Supply Chain Security Tools - Scan](#install-scst-scan)
    + [Install API portal](#install-api-portal)
    + [Install Services Control Plane (SCP) Toolkit](#install-scp-toolkit)


## <a id='install-cnr'></a> Install Cloud Native Runtimes

To install Cloud Native Runtimes:

1. Follow the instructions in [Install Packages](#install-packages) above.
If you are running on a multi-node cluster, the defaults should work fine.
If you are running on a single-node cluster like kind or minikube, we recommend the
`provider: local` option, which reduces resource requirements by using a HostPort service instead
of a LoadBalancer and reducing the number of replicas.

    ```bash
    tanzu package available get cnrs.tanzu.vmware.com/1.0.2 --values-schema -n tap-install
    ```

    For example:

    ```console
    $ tanzu package available get cnrs.tanzu.vmware.com/1.0.2 --values-schema -n tap-install
    | Retrieving package details for cnrs.tanzu.vmware.com/1.0.2...
      KEY                         DEFAULT  TYPE             DESCRIPTION
      pdb.enable                  true     boolean  Optional: Set to true to enable Pod Disruption Budget. If provider local is set to "local", the PDB will be disabled automatically.
      provider                    <nil>    string   Optional: Kubernetes cluster provider. To be specified if deploying CNR on TKGs or on a local Kubernetes cluster provider.
      ingress.external.namespace  <nil>    string   Optional: Only valid if a Contour instance already present in the cluster. Specify a namespace where an existing Contour is installed on your cluster (for external services) if you want CNR to use your Contour instance.
      ingress.internal.namespace  <nil>    string   Optional: Only valid if a Contour instance already present in the cluster. Specify a namespace where an existing Contour is installed on your cluster (for internal services) if you want CNR to use your Contour instance.
      ingress.reuse_crds          false    boolean  Optional: Only valid if a Contour instance already present in the cluster. Set to "true" if you want CNR to re-use the cluster\'s existing Contour CRDs.
      local_dns.enable            false    boolean  Optional: Only for when "provider" is set to "local" and running on Kind. Set to true to enable local DNS.
      local_dns.domain            <nil>    string   Optional: Set a custom domain for the Knative services.
    ```

1. Create a `cnr-values.yaml` using the following sample as a guide:

    Sample `cnr-values.yaml` for Cloud Native Runtimes:

    ```yaml
    ---
    # if deploying on a local cluster such as Kind. Otherwise, you can use the defaults values to install CNR.
    provider: local
    ```

    In Tanzu Kubernetes Grid environments, Contour packages that are already been present might
    conflict with the Cloud Native Runtimes installation.
    For how to prevent conflicts, see [Installing Cloud Native Runtimes for Tanzu with an Existing Contour Installation](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/1.0/tanzu-cloud-native-runtimes-1-0/GUID-contour.html) in the Cloud Native Runtimes documentation.
    Then, in the `values.yaml` file, specify values for `ingress.reuse_crds`,
    `ingress.external.namespace`, and `ingress.internal.namespace` as appropriate.

    For a local Kubernetes cluster, set `provider: "local"`. You may also want to follow the [local kind configuration guide for Cloud Native Runtimes](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/1.0/tanzu-cloud-native-runtimes-1-0/GUID-local-dns.html#configure-your-local-kind-cluster-1).
    For other infrastructures, do not set `provider`.

1. Install the package by running:

    ```console
    tanzu package install cloud-native-runtimes -p cnrs.tanzu.vmware.com -v 1.0.2 -n tap-install -f cnr-values.yaml
    ```

    For example:

    ```console
    $ tanzu package install cloud-native-runtimes -p cnrs.tanzu.vmware.com -v 1.0.2 -n tap-install -f cnr-values.yaml
    - Installing package 'cnrs.tanzu.vmware.com'
    | Getting package metadata for 'cnrs.tanzu.vmware.com'
    | Creating service account 'cloud-native-runtimes-tap-install-sa'
    | Creating cluster admin role 'cloud-native-runtimes-tap-install-cluster-role'
    | Creating cluster role binding 'cloud-native-runtimes-tap-install-cluster-rolebinding'
    - Creating package resource
    - Package install status: Reconciling

     Added installed package 'cloud-native-runtimes' in namespace 'tap-install'
    ```

1. Verify the package install by running:

    ```console
    tanzu package installed get cloud-native-runtimes -n tap-install
    ```

    For example:

    ```console
    tanzu package installed get cloud-native-runtimes -n tap-install
    | Retrieving installation details for cc...
    NAME:                    cloud-native-runtimes
    PACKAGE-NAME:            cnrs.tanzu.vmware.com
    PACKAGE-VERSION:         1.0.2
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:    
    ```
    STATUS should be `Reconcile succeeded`.


## <a id='install-app-accelerator'></a> Install Application Accelerator

To install Application Accelerator:

**Prerequisite**: Flux SourceController installed on the cluster.
See [Install Prerequisites](install-general.md#prereqs).

The following optional properties are configurable:

| Property | Default | Description |
| --- | --- | --- |
| registry.secret_ref | registry.tanzu.vmware.com | The secret used for accessing the registry where the App-Accelerator images are located |
| server.service_type | LoadBalancer | The service type for the acc-ui-server service (LoadBalancer, NodePort or ClusterIP) |
| server.watched_namespace | default | The namespace that the server watches for accelerator resources |
| server.engine_invocation_url | http://acc-engine.accelerator-system.svc.cluster.local/invocations | The URL to use for invoking the accelerator engine |
| engine.service_type | ClusterIP | The service type for the acc-engine service (LoadBalancer, NodePort or ClusterIP) |

> **Note:** For clusters that do not support the `LoadBalancer` service type you should override the default value for `server.service_type`.

In general you should not override the defaults for `registry.secret_ref`,
`server.engine_invocation_url` or `engine.service_type`.
They are only used for configuration of non-standard installs.

1. Follow the instructions in [Install Packages](#install-packages) above.

1. Create an `app-accelerator-values.yaml` using the following sample as a guide:

    ```yaml
    server:
      # Set the engine.service_type to "NodePort" for local clusters like minikube or kind.
      service_type: "LoadBalancer"
      watched_namespace: "default"
    ```

    Modify the values if needed or leave the default values.

1. Install the package by running:

    ```console
    tanzu package install app-accelerator -p accelerator.apps.tanzu.vmware.com -v 0.3.0 -n tap-install -f app-accelerator-values.yaml
    ```

    For example:

    ```console
    $ tanzu package install app-accelerator -p accelerator.apps.tanzu.vmware.com -v 0.3.0 -n tap-install -f app-accelerator-values.yaml
    - Installing package 'accelerator.apps.tanzu.vmware.com'
    | Getting package metadata for 'accelerator.apps.tanzu.vmware.com'
    | Creating service account 'app-accelerator-tap-install-sa'
    | Creating cluster admin role 'app-accelerator-tap-install-cluster-role'
    | Creating cluster role binding 'app-accelerator-tap-install-cluster-rolebinding'
    | Creating secret 'app-accelerator-tap-install-values'
    - Creating package resource
    - Package install status: Reconciling

     Added installed package 'app-accelerator' in namespace 'tap-install'
    ```

1. Verify the package install by running:

    ```console
    tanzu package installed get app-accelerator -n tap-install
    ```

    For example:

    ```console
    tanzu package installed get app-accelerator -n tap-install
    | Retrieving installation details for cc...
    NAME:                    app-accelerator
    PACKAGE-NAME:            accelerator.apps.tanzu.vmware.com
    PACKAGE-VERSION:         0.3.0
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:    
    ```
    STATUS should be `Reconcile succeeded`.

1. To access the Application Accelerator UI, please refer to the [Application Accelerator for VMware Tanzu documentation](https://docs.vmware.com/en/Application-Accelerator-for-VMware-Tanzu/0.3/acc-docs/GUID-installation-install.html#using-application-accelerator-for-vmware-tanzu-0).

## <a id='install-convention-service'></a> Install Convention Service

Convention Service allows app operators to enrich Pod Template Specs with operational knowledge
based on specific conventions they define.

Convention Service includes the following components:

+ Convention Controller: Provides metadata to the Convention Server.
Implements the update requests from Convention Server.
+ Convention Server: Receives and evaluates metadata associated with a workload from Convention
Controller. Requests updates to the Pod Template Spec associated with that workload.
There can be one or more Convention Servers for a single Convention Controller instance.

In the following procedure, you install Convention Controller.

You install Convention Servers as part of separate installation procedures.
For example, you install an `app-live-view` Convention Server as part of the `app-live-view`
installation.

 **Prerequisite**: Cert-manager installed on the cluster. See [Install Prerequisites](install-general.md#prereqs).

To install Convention Controller:

1. Follow the instructions in [Install Packages](#install-packages) above.

1. Install the package by running:

    ```bash
    tanzu package install convention-controller -p controller.conventions.apps.tanzu.vmware.com -v 0.4.2 -n tap-install
    ```

    ```bash
    / Installing package 'controller.conventions.apps.tanzu.vmware.com'
    | Getting namespace 'tap-install'
    - Getting package metadata for 'controller.conventions.apps.tanzu.vmware.com'
    | Creating service account 'convention-controller-tap-install-sa'
    | Creating cluster admin role 'convention-controller-tap-install-cluster-role'
    | Creating cluster role binding 'convention-controller-tap-install-cluster-rolebinding'
    \ Creating package resource
    | Package install status: Reconciling
    Added installed package 'convention-controller' in namespace 'tap-install'
    ```

1. Verify the package install by running:

    ```bash
    tanzu package installed get convention-controller -n tap-install
    ```

    ```bash
    Retrieving installation details for convention-controller...
    NAME:                    convention-controller
    PACKAGE-NAME:            controller.conventions.apps.tanzu.vmware.com
    PACKAGE-VERSION:         0.4.2
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    ```bash
    kubectl get pods -n conventions-system
    ```

    For example:

    ```bash
    $ kubectl get pods -n conventions-system
    NAME                                             READY   STATUS    RESTARTS   AGE
    conventions-controller-manager-596c65f75-j9dmn   1/1     Running   0          72s
    ```

    STATUS should be `Running`.


## <a id='install-source-controller'></a> Install Source Controller

Use the following procedure to install Source Controller.

**Prerequisite**: Fluxcd Source Controller installed on the cluster.
See [Install Prerequisites](install-general.md#prereqs).

To install Source Controller:

1. Follow the instructions in [Install Packages](#install-packages) above.

1. Install the package. Run:

    ```bash
    tanzu package install source-controller -p controller.source.apps.tanzu.vmware.com -v 0.1.2 -n tap-install
    ```

    ```bash
    / Installing package 'controller.source.apps.tanzu.vmware.com'
    | Getting namespace 'tap-install'
    - Getting package metadata for 'controller.source.apps.tanzu.vmware.com'
    | Creating service account 'source-controller-tap-install-sa'
    | Creating cluster admin role 'source-controller-tap-install-cluster-role'
    | Creating cluster role binding 'source-controller-tap-install-cluster-rolebinding'
    \ Creating package resource
    | Package install status: Reconciling

     Added installed package 'source-controller' in namespace 'tap-install'
    ```

1. Verify the package install by running:

    ```bash
    tanzu package installed get source-controller -n tap-install
    ```

    ```bash
    Retrieving installation details for sourcer-controller...
    NAME:                    sourcer-controller
    PACKAGE-NAME:            controller.source.apps.tanzu.vmware.com
    PACKAGE-VERSION:         0.1.2
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    ```bash
    kubectl get pods -n source-system
    ```

    For example:

    ```bash
    $ kubectl get pods -n source-system
    NAME                                        READY   STATUS    RESTARTS   AGE
    source-controller-manager-f68dc7bb6-4lrn6   1/1     Running   0          45h
    ```

    STATUS should be `Running`.

## <a id='install-tbs'></a> Install Tanzu Build Service

This section provides a quick-start guide for installing Tanzu Build Service as part of Tanzu Application Platform using the Tanzu CLI.

**Note**: This procedure might not include some configurations required for your specific environment. For more advanced details on installing Tanzu Build Service, see [Installing Tanzu Build Service](https://docs.pivotal.io/build-service/installing.html).


### Prerequisites

* You have access to a Docker registry that Tanzu Build Service can use to create Builder images. Approximately 5GB of registry space is required.
* Your Docker registry is accesible with username and password credentials.


### Install Tanzu Build Service Using the Tanzu CLI

To install Tanzu Build Service using the Tanzu CLI:

1. Follow the instructions in [Install Packages](#install-packages) above.

1. Gather values schema.

    ```bash
    tanzu package available get buildservice.tanzu.vmware.com/1.3.0 --values-schema --namespace tap-install
    ```

    For example:

    ```bash
    $ tanzu package available get buildservice.tanzu.vmware.com/1.3.0 --values-schema --namespace tap-install
    | Retrieving package details for buildservice.tanzu.vmware.com/1.3.0...
      KEY                             DEFAULT  TYPE    DESCRIPTION
      kp_default_repository           <nil>    string  docker repository
      kp_default_repository_password  <nil>    string  registry password
      kp_default_repository_username  <nil>    string  registry username
      tanzunet_username               <nil>    string  tanzunet registry username required for dependency updater feature
      tanzunet_password               <nil>    string  tanzunet registry password required for dependency updater feature
      ca_cert_data                    <nil>    string  tbs registry ca certificate
    ```

1. Create a `tbs-values.yaml` file.

    ```yaml
    ---
    kp_default_repository: EXAMPLE-REGISTRY/PATH-TO-INSTALL
    kp_default_repository_username: REGISTRY-USERNAME
    kp_default_repository_password: REGISTRY-PASSWORD
    tanzunet_username: TANZUNET-USERNAME
    tanzunet_password: TANZUNET-PASSWORD
    ```
    Where:
        * `EXAMPLE-REGISTRY` is the URL of the Docker registry.
        * `PATH-TO-INSTALL` is the path to the registry install location. `kp_default_repository` is the registry location where all Tanzu Build Services dependencies and builder images are written.
        * `REGISTRY-USERNAME` and `REGISTRY-PASSWORD` are the username and password for the registry. The install requires a `kp_default_repository_username` and `kp_default_repository_password` in order to write to the repository location.
        * `TANZUNET-USERNAME` and `TANZUNET-PASSWORD` are the email address and password that you use to log in to Tanzu Network. The Tanzu Network credentials allow for configuration of the Dependencies Updater.  This resource accesses and installs the build dependencies (buildpacks and stacks) Tanzu Build Service needs on your Cluster.  It also keeps these dependencies up-to-date as new versions are released on Tanzu Network.
        * **Optional values**: There are optional values not included in this sample file that provide additional configuration for production use cases. For more information, see [Installing Tanzu Build Service](https://docs.pivotal.io/build-service/installing.html).

1. Install the package by running:

    ```bash
    tanzu package install tbs -p buildservice.tanzu.vmware.com -v 1.3.0 -n tap-install -f tbs-values.yaml --poll-timeout 30m
    ```

    **Note**: Installing the `buildservice.tanzu.vmware.com` package with Tanzu Net credentials automatically relocates buildpack dependencies to your cluster. This install process can take some time.  The command provided above increases the timeout duration to account for this.  If the command still times out, periodically run the installation verification step provided below because image relocation will continue in the background.   

    For example:

    ```bash
    $ tanzu package install tbs -p buildservice.tanzu.vmware.com -v 1.3.0 -n tap-install -f tbs-values.yaml
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

1. (Optional) Run the following command to verify the clusterbuilders created by the Tanzu Build Service install:

    ```bash
    kubectl get clusterbuilders
    ```

    For example:

    ```bash
    $ kubectl get clusterbuilders

    NAME      LATESTIMAGE                                                                                      READY
    base      my-registry.com/tbs@sha256:8732fadb92d8afa40bcef2d885e9730b372484a39b4a7f718291f574645f4bf2      True
    default   my-registry.com/tbs@sha256:8732fadb92d8afa40bcef2d885e9730b372484a39b4a7f718291f574645f4bf2      True
    full      my-registry.com/tbs@sha256:f7cdac8b2d97790276821ee3f54c497fba4ec71752eec9a87d22905344471ed8      True
    tiny      my-registry.com/tbs@sha256:b9c5348da4c1527c356d2d8b9d48462ea9bf97a98eb379e925bec69c6dd918a5      True
    ```

## <a id='install-scc'></a> Install Supply Chain Choreographer

[cartographer]: https://github.com/vmware-tanzu/cartographer
[cert-manager]: https://github.com/jetstack/cert-manager
[convention-controller]: https://github.com/vmware-tanzu/convention-controller
[kapp-controller]: https://github.com/vmware-tanzu/carvel-kapp-controller
[knative-serving]: https://knative.dev/docs/serving/
[kpack]: https://github.com/pivotal/kpack
[secretgen-controller]: https://github.com/vmware-tanzu/carvel-secretgen-controller
[source-controller]: https://github.com/fluxcd/source-controller
[tanzu cli]: https://github.com/vmware-tanzu/tanzu-framework/tree/main/cmd/cli#installation
[tekton]: https://github.com/tektoncd/pipeline

### Prerequisites

#### Base Kubernetes Prerequisites

- **[cert-manager]**, for provisioning certificates for the webhook servers that some controllers
register with Kubernetes' API server to validate and modify objects when update

    ```bash
    CERT_MANAGER_VERSION=1.5.3

    kapp deploy --yes -a cert-manager \
      -f https://github.com/jetstack/cert-manager/releases/download/v$CERT_MANAGER_VERSION/cert-manager.yaml
    ```

- **[kapp-controller]**, for providing to Kubernetes both packaging and application primitives.
These are used for installing some of the dependencies here as well as deploying the applications
that go through this supplychain.

    ```bash
    KAPP_CONTROLLER_VERSION=0.25.0

    kapp deploy --yes -a kapp-controller \
        -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/download/v$KAPP_CONTROLLER_VERSION/release.yml
    ```

- **[secretgen-controller]**, for filling placeholder secrets with the contents of shared credentials
that we can define once and keep in sync everywhere we want.

    ```bash
    SECRETGEN_CONTROLLER_VERSION=0.5.0

    kapp deploy --yes -a secretgen-controller \
      -f https://github.com/vmware-tanzu/carvel-secretgen-controller/releases/download/v$SECRETGEN_CONTROLLER_VERSION/release.yml
    ```

- **flux2 source-controller**, for bringing the capability of making source code changes available to
the components in the supply chain. As ApplicationAccelerator already depends on it too, see
[Install Application Accelerator](#install-app-accelerator).


#### TAP Prerequisites

- [Cloud Native Runtimes](#-install-cloud-native-runtimes)
- [Convention Service](#install-convention-service)
- [Tanzu Build Service](#install-tbs)


#### Tekton

[tekton] is used by the supply chain to run tests defined by the developers before we get to the point
of producing a container image for the source code, effectively preventing code that fails tests to
being promoted all the way to a deployment.

```bash
TEKTON_VERSION=0.28.0

kapp deploy --yes -a tekton \
  -f https://storage.googleapis.com/tekton-releases/pipeline/previous/v$TEKTON_VERSION/release.yaml
```

### Cartographer Installation

Cartographer is what provides the custom resource definitions that this supply chain makes use of.
It enables choreography of components that form the software supply chain, such as
passing the results of fetching source code to the component that knows how to build a
container image out of it, and then passing to a component that knows how to deploy it, and so on
and so forth.

```bash
CARTOGRAPHER_VERSION=0.0.6

# Install the version 0.0.6 of the `cartographer.tanzu.vmware.com`
# package naming the installation as `cartographer`.
#
tanzu package install cartographer \
  --namespace tap-install \
  --package-name cartographer.tanzu.vmware.com \
  --version $CARTOGRAPHER_VERSION
```

```console
| Installing package 'cartographer.tanzu.vmware.com'
| Getting namespace 'default'
| Getting package metadata for 'cartographer.tanzu.vmware.com'
| Creating service account 'cartographer-default-sa'
| Creating cluster admin role 'cartographer-default-cluster-role'
| Creating cluster role binding 'cartographer-default-cluster-rolebinding'
- Creating package resource
\ Package install status: Reconciling

Added installed package 'cartographer' in namespace 'default'
```

### <a id='install-default-supply-chains'></a> Install Default Supply Chains

Cartographer and all of its dependencies must be installed in order to install
either default supply chain.

**Note: Only one supply chain can be installed at a time. In order to install a
different supply chain, the currently installed one must be first uninstalled**

As the supply chains  produce container images using Tanzu Build Service, thus,
having to push them to a container image registry, we must tell the supply
chain what the default registry location is.


```bash
tanzu package available get \
  default-supply-chain.tanzu.vmware.com/$SUPPLY_CHAIN_VERSION \
  --values-schema
```

```console
KEY                  DEFAULT          TYPE    DESCRIPTION
registry.repository  <nil>            string  Name of the repository in the image registry server
                                              where the application images from the workloads should
                                              be pushed to. (required)

registry.server      index.docker.io  string  Name of the registry server where application
                                              images should be pushed to. (required)

cluster_builder      default          string  Name of the Tanzu Build Service (TBS) ClusterBuilder to
                                              use by default on image objects managed by the supply chain.

service_account      default          string  Name of the service account in the namespace where the
                                              Workload is submitted to utilize for providing registry
                                              credentials to Tanzu Build Service (TBS) Image objects
                                              as well as deploying the application.
```

As only `registry.server` and `registry.repository` are required, for any of
the supply chains that we install we can we move on with configuring just those
two to point at the registry and repository in the registry where we want the
app images to be pushed to.


#### Source to URL

**Reminder: Only one supply chain can be installed at a time. In order to install a
different supply chain, the currently installed one must be first uninstalled**

```console
SUPPLY_CHAIN_VERSION=0.2.0

tanzu package install default-supply-chain \
  --package-name default-supply-chain.tanzu.vmware.com \
  --namespace tap-install \
  --version $SUPPLY_CHAIN_VERSION \
  --values-file <(echo "---
registry:
  server: 10.188.0.3:5000
  repository: myorg")
```

```console
| Installing package 'default-supply-chain.tanzu.vmware.com'
..
 Added installed package 'default-supply-chain' in namespace 'default'
```


#### Source & Test to URL

**Reminder: Only one supply chain can be installed at a time. In order to install a
different supply chain, the currently installed one must be first uninstalled**

```console
SUPPLY_CHAIN_VERSION=0.2.0

tanzu package install default-supply-chain-testing \
  --package-name default-supply-chain-testing.tanzu.vmware.com \
  --namespace tap-install \
  --version $SUPPLY_CHAIN_VERSION \
  --values-file <(echo "---
registry:
  server: 10.188.0.3:5000
  repository: myorg")
```

```console
| Installing package 'default-supply-chain-testing.tanzu.vmware.com'
..
 Added installed package 'default-supply-chain-testing' in namespace 'default'
```


## <a id='install-default-supply-chain'></a> Install Default Supply Chain

1. Follow the instructions in [Install Packages](#install-packages) above.

    ```bash
    tanzu package available get default-supply-chain.tanzu.vmware.com/0.2.0 --values-schema -n tap-install
    ```

    For example:

    ```console
    $ tanzu package available get default-supply-chain.tanzu.vmware.com/0.2.0 --values-schema -n tap-install
    | Retrieving package details for default-supply-chain.tanzu.vmware.com/0.2.0...
      KEY                  DEFAULT                  TYPE    DESCRIPTION          
      registry.repository  sample-repo              string  Registry repository  
      registry.server      https://yourregistry.io  string  registry hostname
    ```

1. Gather the values schema.
1. Create a `default-supply-chain-values.yaml` using the following sample as a guide:

    Sample `default-supply-chain-values.yaml` for Default Supply Chain:

    ```yaml
    ---
    registry:
      server: REGISTRY_SERVER
      repository: REGISTRY_REPOSITORY
    ```

1. Create a secret called `registry-credentials` with the credentials for the registry that you want the supply chain to use.
1. Create an `imagepullsecret`:

    ```console
    tanzu imagepullsecret add registry-credentials --registry <REGISTRY_SERVER> --username <REGISTRY_USERNAME> --password <REGISTRY_PASSWORD> --export-to-all-namespaces || true
    ```
    Where:
    * `REGISTRY_SERVER` is the server of the registry.
    * `REGISTRY_USERNAME` is the username for the registry.
    * `REGISTRY_PASSWORD` is the password for the registry.

1. Install the package by running:

     ```bash
    tanzu package install default-supply-chain \
      --package-name default-supply-chain.tanzu.vmware.com \
      --version 0.2.0 \
      --namespace tap-install \
      --values-file default-supply-chain-values.yaml
    ```


## <a id='install-developer-conventions'></a> Install Developer Conventions

To install developer conventions:

1. Follow the instructions in [Install Packages](#install-packages) above.

    ```bash
    tanzu package available get developer-conventions.tanzu.vmware.com/0.2.0 -n tap-install
    ```

    For example:

    ```console
    $ tanzu package available get developer-conventions.tanzu.vmware.com/0.2.0 -n tap-install
    \ Retrieving package details for developer-conventions.tanzu.vmware.com/0.2.0...
    NAME:                             developer-conventions.tanzu.vmware.com
    VERSION:                          0.2.0
    RELEASED-AT:                      
    DISPLAY-NAME:                     Tanzu App Platform Develooper Conventions
    SHORT-DESCRIPTION:                Developer Conventions
    PACKAGE-PROVIDER:                 VMware
    MINIMUM-CAPACITY-REQUIREMENTS:    
    LONG-DESCRIPTION:                 Tanzu App Platform Developer Conventions
    MAINTAINERS:                      [{Lisa Burns} {Paul Warren} {Harsha Nandiwada} {Kiwi Bui} {Ming Xiao} {Anthony Pensiero}]
    RELEASE-NOTES:                    Developer Conventions contents package

    LICENSE:                          []
    SUPPORT:                          https://tanzu.vmware.com/support
    CATEGORY:                         []
    ```

1. Install the package by running:

    ```bash
    tanzu package install developer-conventions \
      --package-name developer-conventions.tanzu.vmware.com \
      --version 0.2.0 \
      --namespace tap-install
    ```


## <a id="install-app-live-view"></a>Install Application Live View

To install Application Live View:

1. Follow the instructions in [Install Packages](#install-packages) above.
1. Follow the instructions in [Install Convention Service](#install-convention-service).
1. Gather the values schema.
1. Create a `app-live-view-values.yaml` using the following sample as a guide:
    Sample `app-live-view-values.yaml` for Application Live View:

    ```yaml
    ---
    connector_namespaces: [default]
    server_namespace: tap-install
    ```
    The server_namespace is the namespace to which the Application Live View server is deployed.
    Typically you should pick the namespace you created earlier, tap-install.
    The connector_namespaces should be a list of existing namespaces in which you want
    Application Live View to monitor your apps. To each of those namespace an instance of the
    Application Live View Connector will be deployed.

1. Install the package by running:

    ```console
    tanzu package install app-live-view -p appliveview.tanzu.vmware.com -v 0.2.0 -n tap-install -f app-live-view-values.yaml
    ```

    For example:

    ```console
    $ tanzu package install app-live-view -p appliveview.tanzu.vmware.com -v 0.2.0 -n tap-install -f app-live-view-values.yaml
    - Installing package 'appliveview.tanzu.vmware.com'
    | Getting package metadata for 'appliveview.tanzu.vmware.com'
    | Creating service account 'app-live-view-tap-install-sa'
    | Creating cluster admin role 'app-live-view-tap-install-cluster-role'
    | Creating cluster role binding 'app-live-view-tap-install-cluster-role binding'
    | Creating secret 'app-live-view-tap-install-values'
    - Creating package resource
    - Package install status: Reconciling

     Added installed package 'app-live-view' in namespace 'tap-install'
    ```

    For more information about Application Live View,
    see the [Application Live View documentation](https://docs.vmware.com/en/Application-Live-View-for-VMware-Tanzu/0.1/docs/GUID-index.html).

1. Verify the package install by running:

    ```console
    tanzu package installed get app-live-view -n tap-install
    ```

    For example:

    ```console
    tanzu package installed get app-live-view -n tap-install
    | Retrieving installation details for cc...
    NAME:                    app-live-view
    PACKAGE-NAME:            appliveview.tanzu.vmware.com
    PACKAGE-VERSION:         0.2.0
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:    
    ```
    STATUS should be `Reconcile succeeded`.


## <a id='install-service-bindings'></a> Install Service Bindings

 Use the following procedure to install Service Bindings:

1. Follow the instructions in [Install Packages](#install-packages) above.

1. Install the package. Run:

    ```bash
    tanzu package install service-bindings -p service-bindings.labs.vmware.com -v 0.5.0 -n tap-install
    ```

    ```bash
    / Installing package 'service-bindings.labs.vmware.com'
    | Getting namespace 'tap-install'
    - Getting package metadata for 'service-bindings.labs.vmware.com'
    | Creating service account 'service-bindings-tap-install-sa'
    | Creating cluster admin role 'service-bindings-tap-install-cluster-role'
    | Creating cluster role binding 'service-bindings-tap-install-cluster-rolebinding'
    \ Creating package resource
    | Package install status: Reconciling

     Added installed package 'service-bindings' in namespace 'tap-install'
    ```

1. Verify the package install by running:

    ```bash
    tanzu package installed get service-bindings -n tap-install
    ```

    ```console
    - Retrieving installation details for service-bindings...
    NAME:                    service-bindings
    PACKAGE-NAME:            service-bindings.labs.vmware.com
    PACKAGE-VERSION:         0.5.0
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    ```bash
    kubectl get pods -n service-bindings
    ```

    For example:

    ```bash
    $ kubectl get pods -n service-bindings
    NAME                       READY   STATUS    RESTARTS   AGE
    manager-6d85fffbcd-j4gvs   1/1     Running   0          22s
    ```
    STATUS should be `Running`.

## <a id='install-scst-store'></a> Install Supply Chain Security Tools - Store

To install Supply Chain Security Tools - Store:

1. Follow the instructions in [Install Packages](#install-packages) above.

    ```sh
    tanzu package available get scst-store.tanzu.vmware.com/1.0.0-beta.0 --values-schema -n tap-install
    ```

    For example:

    ```sh
    $ tanzu package available get scst-store.tanzu.vmware.com/1.0.0-beta.0 --values-schema -n tap-install
    | Retrieving package details for scst-store.tanzu.vmware.com/1.0.0-beta.0...
      KEY               DEFAULT              TYPE     DESCRIPTION
      auth_proxy_host   0.0.0.0              string   The binding ip address of the kube-rbac-proxy sidecar
      db_name           metadata-store       string   The name of the database to use.
      db_password                            string   The database user password.
      db_port           5432                 string   The database port to use. This is the port to use when connecting to the database pod.
      db_sslmode        verify-full          string   Determines the security connection between API server and Postgres database. This can be set to 'verify-ca' or 'verify-full'
      db_user           metadata-store-user  string   The database user to create and use for updating and querying. The metadata postgres section create this user. The metadata api server uses this username to connect to the database.
      api_host          localhost            string   The internal hostname for the metadata api endpoint. This will be used by the kube-rbac-proxy sidecar.
      api_port          9443                 integer  The internal port for the metadata app api endpoint. This will be used by the kube-rbac-proxy sidecar.
      app_service_type  NodePort             string   The type of service to use for the metadata app service. This can be set to 'Nodeport' or 'LoadBalancer'.
      auth_proxy_port   8443                 integer  The external port address of the of the kube-rbac-proxy sidecar
      db_host           metadata-postgres    string   The database hostname
      storageClassName  manual               string   The storage class name of the persistent volume used by Postgres database for storing data. The default value will use the default class name defined on the cluster.
      use_cert_manager  true                 string   Cert manager is required to be installed to use this flag. When true, this creates certificates object to be signed by cert manager for the API server and Postgres database. If false, the certificate object have to be provided by the user.
    ```

1. Gather the values schema.
1. Create a `scst-store-values.yaml` using the following sample as a guide:

    Sample `scst-store-values.yaml` for Supply Chain Security Tools - Store:

    ```yaml
    db_password: "password0123456"
    app_service_type: "LoadBalancer"
    ```

    * `db_password` should be significantly complex. Furthermore, you should use the same password between deployments. This is a known limitation (see [Known Issues - Persistent Volume Retains Data](scst-store/known_issues.md#persistent-volume-retains-data)).
    * `app_service_type` has been set to `LoadBalancer`.
    If your environment does not support `LoadBalancer`, omit this line and it will use the default value `NodePort`.

1. Install the package by running:

    ```sh
    tanzu package install metadata-store \
      --package-name scst-store.tanzu.vmware.com \
      --version 1.0.0-beta.0 \
      --namespace tap-install \
      --values-file scst-store-values.yaml
    ```

    For example:

    ```sh
    $ tanzu package install metadata-store \
      --package-name scst-store.tanzu.vmware.com \
      --version 1.0.0-beta.0 \
      --namespace tap-install \
      --values-file scst-store-values.yaml

    - Installing package 'scst-store.tanzu.vmware.com'
    / Getting namespace 'tap-install'
    - Getting package metadata for 'scst-store.tanzu.vmware.com'
    / Creating service account 'metadata-store-tap-install-sa'
    / Creating cluster admin role 'metadata-store-tap-install-cluster-role'
    / Creating cluster role binding 'metadata-store-tap-install-cluster-rolebinding'
    / Creating secret 'metadata-store-tap-install-values'
    | Creating package resource
    - Package install status: Reconciling

    Added installed package 'metadata-store' in namespace 'tap-install'
    ```


## <a id='install-scst-sign'></a> Install Supply Chain Security Tools - Sign

To install Supply Chain Security Tools - Sign:

1. Follow the instructions in [Install Packages](#install-packages) above.
1. Gather the values schema

    ```bash
    tanzu package available get image-policy-webhook.signing.run.tanzu.vmware.com/1.0.0-beta.0 --values-schema
    ```

    Output:

    ```bash
    | Retrieving package details for image-policy-webhook.signing.run.tanzu.vmware.com/1.0.0-beta.0...
      KEY                DEFAULT  TYPE     DESCRIPTION
      warn_on_unmatched  false    boolean  Feature flag for enabling admission of images that do not match
                                           any patterns in the image policy configuration.
                                           Set to true to allow images that do not match any patterns into
                                           the cluster with a warning.

    ```

1. Create a file named `scst-sign-values.yaml` with a `warn_on_unmatched` property.
    * **For non-production environments**: To warn the user when images do not match any pattern in the policy, but still allow them into the cluster, set `warn_on_unmatched` to `true`.

        ```yaml
        ---
        warn_on_unmatched: true
        ```
    * **For production environments**: To deny images that do not match any pattern in the policy, set `warn_on_unmatched` to `false`.

        ```yaml
        ---
        warn_on_unmatched: false
        ```
        **Note**: For a quicker installation process, VMware recommends that you set
        `warn_on_unmatched` to `true`.
        This means that the webhook does not prevent unsigned images from running.
        To promote to a production environment, VMware recommends that you re-install the webhook
        with `warn_on_unmatched` set to `false`.

1. Install the package:

    ```bash
    tanzu package install image-policy-webhook \
     --package-name image-policy-webhook.signing.run.tanzu.vmware.com \
     --version 1.0.0-beta.0 \
     --namespace tap-install \
     --values-file scst-sign-values.yaml
    ```

    Output:

    ```bash
    | Installing package 'image-policy-webhook.signing.run.tanzu.vmware.com'
    | Getting namespace 'default'
    | Getting package metadata for 'image-policy-webhook.signing.run.tanzu.vmware.com'
    | Creating service account 'image-policy-webhook-default-sa'
    | Creating cluster admin role 'image-policy-webhook-default-cluster-role'
    | Creating cluster role binding 'image-policy-webhook-default-cluster-rolebinding'
    | Creating secret 'image-policy-webhook-default-values'
    / Creating package resource
    - Package install status: Reconciling

    Added installed package 'image-policy-webhook' in namespace 'tap-install'
    ```

   The webhook should be up and running

1. Create a service account named `registry-credentials` in the `image-policy-system` namespace

    * **If the images and signatures are in public registries:** No extra configuration is needed. Apply the following:

        ```console
        cat <<EOF | kubectl apply -f -
        apiVersion: v1
        kind: ServiceAccount
        metadata:
          name: registry-credentials
          namespace: image-policy-system
        EOF
        ```

    * **If the images and signatures are in private registries:** Add secrets to the `imagePullSecrets` property of the service account.

        ```console
        cat <<EOF | kubectl apply -f -
        apiVersion: v1
        kind: ServiceAccount
        metadata:
          name: registry-credentials
          namespace: image-policy-system
        imagePullSecrets:
        - name: secret-1
        EOF
        ```
        Where `secret-1` is a secret that allows the webhook to access the private registry.
        This secret can be created using the following command:

        ```bash
        kubectl create secret docker-registry secret-1 --docker-server=<server> --docker-username=<username> --docker-password=<password> --namespace image-policy-system
        ```
        Add additional secrets to `imagePullSecrets` as required.

1. Create a `ClusterImagePolicy` to specify the images that the webhook validates.
The cluster image policy is a custom resource definition containing the following information:
    - A list of namespaces to which the policy should not be enforced.
    - A list of public keys complementary to the private keys that were used to sign the images.
    - A list of image name patterns against which the policy is enforced. Each image name pattern is mapped to the required public keys.

    The following is an example `ClusterImagePolicy`:

    ```yaml
    ---
    apiVersion: signing.run.tanzu.vmware.com/v1alpha1
    kind: ClusterImagePolicy
    metadata:
     name: image-policy
    spec:
     verification:
       exclude:
         resources:
           namespaces:
           - kube-system
       keys:
       - name: first-key
         publicKey: |
           -----BEGIN PUBLIC KEY-----
           ...
           -----END PUBLIC KEY-----
       images:
       - namePattern: registry.example.org/myproject/*
         keys:
         - name: first-key
    ```
    Notes:
        * The `name` for the `ClusterImagePolicy` must be `image-policy`.
        * In the `verification.exclude.resources.namespaces` section, add any namespaces that run container images that are unsigned, such as `kube-system`.
        * For a quicker installation process in a non-production environment, VMware recommends you use the following YAML to create the `ClusterImagePolicy`. This YAML includes a cosign public key, which signed the cosign image at v1.2.1. The cosign public key validates the specified cosign image. You can also add additional namespaces to exclude in the `verification.exclude.resources.namespaces` section, such as any system namespaces.

    ```console
    cat <<EOF | kubectl apply -f -
    apiVersion: signing.run.tanzu.vmware.com/v1alpha1
    kind: ClusterImagePolicy
    metadata:
     name: image-policy
    spec:
     verification:
       exclude:
         resources:
           namespaces:
           - kube-system
       keys:
       - name: cosign-key
         publicKey: |
           -----BEGIN PUBLIC KEY-----
           MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEhyQCx0E9wQWSFI9ULGwy3BuRklnt
           IqozONbbdbqz11hlRJy9c7SG+hdcFl9jE9uE/dwtuwU2MqU9T/cN0YkWww==
           -----END PUBLIC KEY-----
       images:
       - namePattern: gcr.io/projectsigstore/cosign*
         keys:
         - name: cosign-key
    EOF
    ```

    (Optional) Run the following commands to test the webhook if you are using the `cosign-key`:

        ```bash
        kubectl run cosign --image=gcr.io/projectsigstore/cosign:v1.2.1 --restart=Never --command -- sleep 900
        ```

        Output:

        ```bash
        pod/cosign created
        ```

        ```bash
        kubectl run bb --image=busybox --restart=Never
        ```

        Output:

        ```console
        Warning: busybox didn\'t match any pattern in policy. Pod will be created as WarnOnUnmatched flag is true
        pod/bb created
        ```

        ```bash
        kubectl run cosign-fail --image=gcr.io/projectsigstore/cosign:v0.3.0 --command -- sleep 900
        ```

        Output:

        ```bash
        Error from server (The image: gcr.io/projectsigstore/cosign:v0.3.0 is not signed): admission webhook "image-policy-webhook.signing.run.tanzu.vmware.com" denied the request: The image: gcr.io/projectsigstore/cosign:v0.3.0 is not signed
        ```


## <a id='install-scst-scan'></a> Install Supply Chain Security Tools - Scan

The installation for Supply Chain Security Tools – Scan involves installing two packages:
Scan Controller and Grype Scanner.
Ensure both are installed.

To install Supply Chain Security Tools - Scan (Scan Controller):

1. Follow the instructions in [Install Packages](#install-packages) above.

    ```bash
    tanzu package available get scanning.apps.tanzu.vmware.com/1.0.0-beta --values-schema -n tap-install
    ```

    For example:

    ```console
    $ tanzu package available get scanning.apps.tanzu.vmware.com/1.0.0-beta --values-schema -n tap-install
    | Retrieving package details for scanning.apps.tanzu.vmware.com/1.0.0-beta...
      KEY                        DEFAULT                                                           TYPE    DESCRIPTION
      metadataStoreTokenSecret                                                                     string  Token Secret of the Insight Metadata Store deployed in the cluster
      metadataStoreUrl           https://metadata-store-app.metadata-store.svc.cluster.local:8443  string  Url of the Insight Metadata Store deployed in the cluster
      namespace                  scan-link-system                                                  string  Deployment namespace for the Scan Controller
      resources.limits.cpu       250m                                                              <nil>   Limits describes the maximum amount of cpu resources allowed.
      resources.limits.memory    256Mi                                                             <nil>   Limits describes the maximum amount of memory resources allowed.
      resources.requests.cpu     100m                                                              <nil>   Requests describes the minimum amount of cpu resources required.
      resources.requests.memory  128Mi                                                             <nil>   Requests describes the minimum amount of memory resources required.
      metadataStoreCa                                                                              string  CA Cert of the Insight Metadata Store deployed in the cluster
    ```

1. Gather the values schema.
1. Create a `scst-scan-controller-values.yaml` using the following sample as a guide:

    Sample `scst-scan-controller-values.yaml` for Scan Controller:

    ```yaml
    ---
    metadataStoreUrl: https://metadata-store-app.metadata-store.svc.cluster.local:8443
    metadataStoreCa: |-
      -----BEGIN CERTIFICATE-----
      MIIC8TCCAdmgAwIBAgIRAIGDgx7Dk/2unVKuT9KXetUwDQYJKoZIhvcNAQELBQAw
      ...
      hOSbQ50VLo+YPF9NtTPRaS7QaIcFWot0EPwBMOCZR6Dd1HU6Qg==
      -----END CERTIFICATE-----
    metadataStoreTokenSecret: metadata-store-secret
    ```

    These values require the [Supply Chain Security Tools - Store](#install-scst-store) to have already been installed.
    The following code snippets show how to determine what these values are:

    The `metadataStoreUrl` value can be determined by:

    ```bash
    kubectl -n metadata-store get service -o name |
      grep app |
      xargs kubectl -n metadata-store get -o jsonpath='{.spec.ports[].name}{"://"}{.metadata.name}{"."}{.metadata.namespace}{".svc.cluster.local:"}{.spec.ports[].port}'
    ```

    The `metadataStoreCa` value can be determined by:

    ```bash
    kubectl get secret app-tls-cert -n metadata-store -o json | jq -r '.data."ca.crt"' | base64 -d
    ```

    The `metadataStoreTokenSecret` is a reference to a secret that you will create and contains the
    Metadata Store token.
    The name of the secret is arbitrary, and for example, we will set it as "metadata-store-secret".

    The secret to be created and applied into the cluster is (ensure the namespace is created in the cluster before applying):

    ```yaml
    ---
    apiVersion: v1
    kind: Secret
    metadata:
      name: <metadataStoreTokenSecret>
      namespace: scan-link-system
    type: kubernetes.io/opaque
    stringData:
      token: <METADATA_STORE_TOKEN>
    ```

    The `METADATA_STORE_TOKEN` value can be determined by:

    ```bash
    kubectl get secrets -n tap-install -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='metadata-store-tap-install-sa')].data.token}" | base64 -d
    ```

4. Install the package by running:

    ```bash
    tanzu package install scan-controller \
      --package-name scanning.apps.tanzu.vmware.com \
      --version 1.0.0-beta \
      --namespace tap-install \
      --values-file scst-scan-controller-values.yaml
    ```

    For example:

    ```console
    $ tanzu package install scan-controller \
      --package-name scanning.apps.tanzu.vmware.com \
      --version 1.0.0-beta \
      --namespace tap-install \
      --values-file scst-scan-controller-values.yaml
    | Installing package 'scanning.apps.tanzu.vmware.com'
    | Getting namespace 'tap-install'
    | Getting package metadata for 'scanning.apps.tanzu.vmware.com'
    | Creating service account 'scan-controller-tap-install-sa'
    | Creating cluster admin role 'scan-controller-tap-install-cluster-role'
    | Creating cluster role binding 'scan-controller-tap-install-cluster-rolebinding'
    | Creating secret 'scan-controller-tap-install-values'
    / Creating package resource
    / Package install status: Reconciling

     Added installed package 'scan-controller' in namespace 'tap-install'
    ```

To install Supply Chain Security Tools - Scan (Grype Scanner):

1. Follow the instructions in [Install Packages](#install-packages) above.

    ```bash
    tanzu package available get grype.scanning.apps.tanzu.vmware.com/1.0.0-beta --values-schema -n tap-install
    ```

    For example:
    ```console
    $ tanzu package available get grype.scanning.apps.tanzu.vmware.com/1.0.0-beta --values-schema -n tap-install
    | Retrieving package details for grype.scanning.apps.tanzu.vmware.com/1.0.0-beta...
      KEY                        DEFAULT  TYPE    DESCRIPTION
      namespace                  default  string  Deployment namespace for the Scan Templates
      resources.limits.cpu       1000m    <nil>   Limits describes the maximum amount of cpu resources allowed.
      resources.requests.cpu     250m     <nil>   Requests describes the minimum amount of cpu resources required.
      resources.requests.memory  128Mi    <nil>   Requests describes the minimum amount of memory resources required.
    ```

2. The default values are appropriate for this package.
If you want to change from the default values, use the Scan Controller instructions as a guide.

3. Install the package by running:

    ```bash
    tanzu package install grype-scanner \
      --package-name grype.scanning.apps.tanzu.vmware.com \
      --version 1.0.0-beta \
      --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package install grype-scanner \
      --package-name grype.scanning.apps.tanzu.vmware.com \
      --version 1.0.0-beta \
      --namespace tap-install
    / Installing package 'grype.scanning.apps.tanzu.vmware.com'
    | Getting namespace 'tap-install'
    | Getting package metadata for 'grype.scanning.apps.tanzu.vmware.com'
    | Creating service account 'grype-scanner-tap-install-sa'
    | Creating cluster admin role 'grype-scanner-tap-install-cluster-role'
    | Creating cluster role binding 'grype-scanner-tap-install-cluster-rolebinding'
    / Creating package resource
    - Package install status: Reconciling

     Added installed package 'grype-scanner' in namespace 'tap-install'
    ```


## <a id='install-api-portal'></a> Install API portal

To install the API portal:

1. Follow the instructions in [Install Packages](#install-packages) above.
1. Check what versions of API portal are available to install by running:

    ```bash
    tanzu package available list -n tap-install api-portal.tanzu.vmware.com
    ```

    For example:

    ```console
    $ tanzu package available list -n tap-install api-portal.tanzu.vmware.com
    - Retrieving package versions for api-portal.tanzu.vmware.com...
      NAME                         VERSION           RELEASED-AT
      api-portal.tanzu.vmware.com  1.0.2             2021-09-27T00:00:00Z
    ```

3. Create a container registry secret named `api-portal-image-pull-secret` by running:

    ```console
    kubectl create secret docker-registry api-portal-image-pull-secret -n tap-install \
     --docker-server=registry.tanzu.vmware.com \
     --docker-username=TANZU-NET-USER \
     --docker-password=TANZU-NET-PASSWORD
    ```
    Where `TANZU-NET-USER` and `TANZU-NET-PASSWORD` are your credentials for Tanzu Network.

    For example:

    ```console
    $ kubectl create secret docker-registry api-portal-image-pull-secret -n tap-install \
    --docker-server=registry.tanzu.vmware.com \
    --docker-username=TANZU-NET-USER \
    --docker-password=TANZU-NET-PASSWORD
    secret/api-portal-image-pull-secret created
    ```


4. Install API portal by running:

    ```console
    tanzu package install api-portal -n tap-install -p api-portal.tanzu.vmware.com -v 1.0.2
    ```

    For example:

    ```console
    $ tanzu package install api-portal -n tap-install -p api-portal.tanzu.vmware.com -v 1.0.2

    / Installing package 'api-portal.tanzu.vmware.com'
    | Getting namespace 'api-portal'
    | Getting package metadata for 'api-portal.tanzu.vmware.com'
    | Creating service account 'api-portal-api-portal-sa'
    | Creating cluster admin role 'api-portal-api-portal-cluster-role'
    | Creating cluster role binding 'api-portal-api-portal-cluster-rolebinding'
    / Creating package resource
    - Package install status: Reconciling


    Added installed package 'api-portal' in namespace 'tap-install'
    ```

5. For more information about API portal, see [API portal for VMware Tanzu](https://docs.pivotal.io/api-portal).


## Install Services Control Plane (SCP) Toolkit

To install SCP Toolkit:

1. See what versions of SCP Toolkit are available to install by running:

    ```console
    tanzu package available list -n tap-install scp-toolkit.tanzu.vmware.com
    ```

    For example:

    ```console
    $ tanzu package available list -n tap-install scp-toolkit.tanzu.vmware.com
    - Retrieving package versions for scp-toolkit.tanzu.vmware.com...
      NAME                          VERSION           RELEASED-AT
      scp-toolkit.tanzu.vmware.com  0.3.0             2021-09-17T13:53:29Z
    ```

1. Install SCP Toolkit by running:

    ```console
    tanzu package install scp-toolkit -n tap-install -p scp-toolkit.tanzu.vmware.com -v 0.3.0
    ```

1. Verify that the package installed by running:

    ```console
    tanzu package installed get scp-toolkit -n tap-install
    ```

    and checking that the `STATUS` value is `Reconcile succeeded`.

    For example:

    ```console
    $ tanzu package installed get scp-toolkit -n tap-install
    | Retrieving installation details for scp-toolkit...
    NAME:                    scp-toolkit
    PACKAGE-NAME:            scp-toolkit.tanzu.vmware.com
    PACKAGE-VERSION:         0.3.0
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    STATUS should be `Reconcile succeeded`.


## <a id='verify'></a> Verify the Installed Packages

Use the following procedure to verify that the packages are installed.

1. List the installed packages by running:

    ```bash
    tanzu package installed list --namespace tap-install
    ```

    For example:

    ```bash
    $ tanzu package installed list --namespace tap-install
    \ Retrieving installed packages...
    NAME                   PACKAGE-NAME                                       PACKAGE-VERSION  STATUS
    api-portal             api-portal.tanzu.vmware.com                        1.0.2            Reconcile succeeded
    app-accelerator        accelerator.apps.tanzu.vmware.com                  0.3.0            Reconcile succeeded
    app-live-view          appliveview.tanzu.vmware.com                       0.2.0            Reconcile succeeded
    cloud-native-runtimes  cnrs.tanzu.vmware.com                              1.0.2            Reconcile succeeded
    convention-controller  controller.conventions.apps.tanzu.vmware.com       0.4.2            Reconcile succeeded
    grype-scanner          grype.scanning.apps.tanzu.vmware.com               1.0.0-beta       Reconcile succeeded
    image-policy-webhook   image-policy-webhook.signing.run.tanzu.vmware.com  1.0.0-beta.0     Reconcile succeeded
    metadata-store         scst-store.tanzu.vmware.com                        1.0.0-beta.0     Reconcile succeeded
    scan-controller        scanning.apps.tanzu.vmware.com                     1.0.0-beta       Reconcile succeeded
    scp-toolkit            scp-toolkit.tanzu.vmware.com                       0.3.0            Reconcile succeeded
    service-bindings       service-bindings.labs.vmware.com                   0.5.0            Reconcile succeeded
    source-controller      controller.source.apps.tanzu.vmware.com            0.1.2            Reconcile succeeded
    tbs                    buildservice.tanzu.vmware.com                      1.3.0            Reconcile succeeded
    ```

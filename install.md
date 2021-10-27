# <a id='installing'></a> Installing Part II: Packages

This document describes how to install Tanzu Application Platform packages
from the Tanzu Application Platform package repository.

Before you install the packages, ensure that you have completed the prerequisites, configured
and verified the cluster, accepted the EULA, and installed the Tanzu CLI with any required plugins.
For information, see [Installing Part I: Prerequisites, EULA, and CLI](install-general.md).


## <a id='install-packages'></a> About Installing Packages

The parameters required for the installation need to be defined in a YAML file.

The available parameters for the individual packages can be identified by the values schema
defined in the package.
You can get these parameters by running the `--values-schema` command included in the following
installation procedures.

Follow the specific installation instructions for each package:

+ [Install Cloud Native Runtimes](#install-cnr)
+ [Install Application Accelerator](#install-app-accelerator)
+ [Install Convention Service](#install-convention-service)
+ [Install Source Controller](#install-source-controller)
+ [Install Developer Conventions](#install-developer-conventions)
+ [Install Application Live View](#install-app-live-view)
+ [Install Tanzu Application Platform GUI](#install-tap-gui)
+ [Install Learning Center](#install-learning-center)
+ [Install Service Bindings](#install-service-bindings)
+ [Install Tanzu Build Service](#install-tbs)
+ [Install Supply Chain Choreographer](#install-scc)
+ [Install Default Supply Chain](#install-default-supply-chain)
+ [Install Supply Chain Security Tools - Store](#install-scst-store)
+ [Install Supply Chain Security Tools - Sign](#install-scst-sign)
+ [Install Supply Chain Security Tools - Scan](#install-scst-scan)
+ [Install API portal](#install-api-portal)
+ [Install Services Toolkit](#install-services-toolkit)

## <a id='add-package-repositories'></a> Add the Tanzu Application Platform Package Repository

To add the Tanzu Application Platform package repository:

1. Create a namespace called `tap-install` for deploying the packages of the components by running:

    ```bash
    kubectl create ns tap-install
    ```

    This namespace is to keep the objects grouped together logically.

2. Create an imagepullsecret:

    ```bash
    tanzu secret registry add tap-registry \
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
    developer-conventions.tanzu.vmware.com             Tanzu App Platform Developer Conventions                               Developer Conventions
    grype.scanning.apps.tanzu.vmware.com               Grype Scanner for Supply Chain Security Tools for VMware Tanzu - Scan  Default scan templates using Anchore Grype
    image-policy-webhook.signing.run.tanzu.vmware.com  Image Policy Webhook                                                   The Image Policy Webhook allows platform operators to define a policy that will use cosign to verify signatures of container images
    scanning.apps.tanzu.vmware.com                     Supply Chain Security Tools for VMware Tanzu - Scan                    Scan for vulnerabilities and enforce policies directly within Kubernetes native Supply Chains.
    scst-store.tanzu.vmware.com                        Tanzu Supply Chain Security Tools - Store                              The Metadata Store enables saving and querying image, package, and vulnerability data.
    service-bindings.labs.vmware.com                   Service Bindings for Kubernetes                                        Service Bindings for Kubernetes implements the Service Binding Specification.
    services-toolkit.tanzu.vmware.com                  Services Toolkit                                                       The Services Toolkit enables the management, lifecycle, discoverability and connectivity of Service Resources (databases, message queues, DNS records, etc.).
    tap-gui.tanzu.vmware.com                           Tanzu Application Platform GUI                                         web app graphical user interface for Tanzu Application Platform
    ```

## <a id='install-cnr'></a> Install Cloud Native Runtimes

To install Cloud Native Runtimes:

1. List version information for the package by running:

    ```bash
    tanzu package available list PACKAGE-NAME --namespace tap-install
    ```
    Where `PACKAGE-NAME` is the name of the package listed in step 5 of
     [Add the Tanzu Application Platform Package Repository](#add-package-repositories) above.
     For example:

    ```bash
    $ tanzu package available list cnrs.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for cnrs.tanzu.vmware.com...
      NAME                   VERSION  RELEASED-AT
      cnrs.tanzu.vmware.com  1.0.3    2021-10-20T00:00:00Z
    ```

1. (Optional) To make changes to the default installation settings, run:

    ```bash
    tanzu package available get PACKAGE-NAME/VERSION-NUMBER --values-schema --namespace tap-install
    ```
    Where:

    - `PACKAGE-NAME` is same as step 1 above.
    - `VERSION-NUMBER` is the version of the package listed in step 1 above.

    For example:

    ```bash
    $ tanzu package available get cnrs.tanzu.vmware.com/1.0.3 --values-schema --namespace tap-install
    ```

    For more information about values schema options, see the individual product documentation.


1. Gather values schema.

    ```bash
    tanzu package available get cnrs.tanzu.vmware.com/1.0.3 --values-schema -n tap-install
    ```

    For example:

    ```console
    $ tanzu package available get cnrs.tanzu.vmware.com/1.0.3 --values-schema -n tap-install
    | Retrieving package details for cnrs.tanzu.vmware.com/1.0.3...
      KEY                         DEFAULT  TYPE             DESCRIPTION
      ingress.external.namespace  <nil>    string   Optional: Only valid if a Contour instance already present in the cluster. Specify a namespace where an existing Contour is installed on your cluster (for external services) if you want CNR to use your Contour instance.
      ingress.internal.namespace  <nil>    string   Optional: Only valid if a Contour instance already present in the cluster. Specify a namespace where an existing Contour is installed on your cluster (for internal services) if you want CNR to use your Contour instance.
      ingress.reuse_crds          false    boolean  Optional: Only valid if a Contour instance already present in the cluster. Set to "true" if you want CNR to re-use the cluster's existing Contour CRDs.
      local_dns.domain            <nil>    string   Optional: Set a custom domain for the Knative services.
      local_dns.enable            false    boolean  Optional: Only for when "provider" is set to "local" and running on Kind. Set to true to enable local DNS.
      pdb.enable                  true     boolean  Optional: Set to true to enable Pod Disruption Budget. If provider local is set to "local", the PDB will be disabled automatically.
      provider                    <nil>    string   Optional: Kubernetes cluster provider. To be specified if deploying CNR on a local Kubernetes cluster provider.
    ```

1. Create a `cnr-values.yaml` using the following sample as a guide:

    Sample `cnr-values.yaml` for Cloud Native Runtimes:

    ```yaml
    ---
    # if deploying on a local cluster such as Kind. Otherwise, you can use the defaults values to install CNR.
    provider: local
    ```

    **Note**: For most installations, you can leave the `cnr-values.yaml` empty, and use the default values.

    If you are running on a single-node cluster, like kind or minikube, set the `provider: local`
    option. This option reduces resource requirements by using a HostPort service instead of a
    LoadBalancer, and reduces the number of replicas.

    For more information about using Cloud Native Runtimes with kin, see
    [local kind configuration guide for Cloud Native Runtimes](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/1.0/tanzu-cloud-native-runtimes-1-0/GUID-local-dns.html#configure-your-local-kind-cluster-1).
    If you are running on a multi-node cluster, do not set `provider`.

    If your environment has Contour packages, Contour might conflict with the Cloud Native Runtimes installation.

    For information on how to prevent conflicts, see [Installing Cloud Native Runtimes for Tanzu with an Existing Contour Installation](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/1.0/tanzu-cloud-native-runtimes-1-0/GUID-contour.html) in the Cloud Native Runtimes documentation.
    Specify values for `ingress.reuse_crds`,
    `ingress.external.namespace`, and `ingress.internal.namespace` in the `cnr-values.yaml` file.

1. Install the package by running:

    ```console
    tanzu package install cloud-native-runtimes -p cnrs.tanzu.vmware.com -v 1.0.3 -n tap-install -f cnr-values.yaml --poll-timeout 30m
    ```

    For example:

    ```console
    $ tanzu package install cloud-native-runtimes -p cnrs.tanzu.vmware.com -v 1.0.3 -n tap-install -f cnr-values.yaml --poll-timeout 30m
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
    PACKAGE-VERSION:         1.0.3
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    STATUS should be `Reconcile succeeded`.

1. Configuring a namespace to use Cloud Native Runtimes:

   **Note:** This step covers configuring a namespace to run Knative services.
   If you rely on a SupplyChain to deploy Knative services into your cluster,
   then skip this step because namespace configuration is covered in
   [Set Up Developer Namespaces to Use Installed Packages](#setup). Otherwise, you must complete the following steps for each namespace where you create Knative services.

   Service accounts that run workloads using Cloud Native Runtimes need access to the image pull secrets for the Tanzu package.
   This includes the `default` service account in a namespace, which is created automatically, but not associated with any image pull secrets.
   Without these credentials, attempts to launch a service fail with a timeout and the Pods report that they are unable to pull the `queue-proxy` image.

   Create an image pull secret in the current namespace and fill it from [the `tap-registry` secret](#add-package-repositories).
   Run the following commands to create an empty secret and annotate it as a target of the secretgen controller:

   ```console
   kubectl create secret generic pull-secret --from-literal=.dockerconfigjson={} --type=kubernetes.io/dockerconfigjson
   kubectl annotate secret pull-secret secretgen.carvel.dev/image-pull-secret=""
   ```

   After you create a `pull-secret` secret in the same namespace as the service account,
   run the following command to add the secret to the service account:

   ```console
   kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "pull-secret"}]}'
   ```

  Verify that a service account is correctly configured by running:

   ```console
   kubectl describe serviceaccount default
   ```

   For example:

   ```console
   kubectl describe sa default
   Name:                default
   Namespace:           default
   Labels:              <none>
   Annotations:         <none>
   Image pull secrets:  pull-secret
   Mountable secrets:   default-token-xh6p4
   Tokens:              default-token-xh6p4
   Events:              <none>
   ```

   > **Note:** The service account has access to the `pull-secret` image pull secret.

To learn more about using Cloud Native Runtimes,
see [Verify your Installation](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/1.0/tanzu-cloud-native-runtimes-1-0/GUID-verify-installation.html)
in the Cloud Native Runtimes documentation.

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

1. List version information for the package by running:

    ```bash
    tanzu package available list PACKAGE-NAME --namespace tap-install
    ```
    Where `PACKAGE-NAME` is the name of the package listed in step 5 of
     [Add the Tanzu Application Platform Package Repository](#add-package-repositories) above.
     For example:

    ```bash
    $ tanzu package available list controller.conventions.apps.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for controller.conventions.apps.tanzu.vmware.com...
      NAME                                          VERSION  RELEASED-AT
      controller.conventions.apps.tanzu.vmware.com  0.4.2    2021-09-16T00:00:00Z
    ```

2. (Optional) To make changes to the default installation settings, run:

    ```bash
    tanzu package available get PACKAGE-NAME/VERSION-NUMBER --values-schema --namespace tap-install
    ```
    Where:

    - `PACKAGE-NAME` is same as step 1 above.
    - `VERSION-NUMBER` is the version of the package listed in step 1 above.

    For example:

    ```bash
    $ tanzu package available get controller.conventions.apps.tanzu.vmware.com/0.4.2 --values-schema --namespace tap-install
    ```

    For more information about values schema options, see the individual product documentation.


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

1. List version information for the package by running:

    ```bash
    tanzu package available list PACKAGE-NAME --namespace tap-install
    ```
    Where `PACKAGE-NAME` is the name of the package listed in step 5 of
     [Add the Tanzu Application Platform Package Repository](#add-package-repositories) above.
     For example:

    ```bash
    $ tanzu package available list controller.source.apps.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for controller.source.apps.tanzu.vmware.com...
      NAME                                     VERSION  RELEASED-AT
      controller.source.apps.tanzu.vmware.com  0.1.2    2021-09-16T00:00:00Z
    ```

1. (Optional) To make changes to the default installation settings, run:

    ```bash
    tanzu package available get PACKAGE-NAME/VERSION-NUMBER --values-schema --namespace tap-install
    ```
    Where:

    - `PACKAGE-NAME` is same as step 1 above.
    - `VERSION-NUMBER` is the version of the package listed in step 1 above.

    For example:

    ```bash
    $ tanzu package available get controller.source.apps.tanzu.vmware.com/0.1.2 --values-schema --namespace tap-install
    ```

    For more information about values schema options, see the individual product documentation.


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

## <a id='install-app-accelerator'></a> Install Application Accelerator

When you install the Application Accelerator,
you can configure the following optional properties:

| Property | Default | Description |
| --- | --- | --- |
| registry.secret_ref | registry.tanzu.vmware.com | The secret used for accessing the registry where the App-Accelerator images are located. |
| server.service_type | LoadBalancer | The service type for the acc-ui-server service including, LoadBalancer, NodePort, or ClusterIP. |
| server.watched_namespace | default | The namespace the server watches for accelerator resources. |
| server.engine_invocation_url | http://acc-engine.accelerator-system.svc.cluster.local/invocations | The URL to use for invoking the accelerator engine. |
| engine.service_type | ClusterIP | The service type for the acc-engine service including, LoadBalancer, NodePort, or ClusterIP. |
| engine.max_direct_memory_size | 32M | The max size for the Java -XX:MaxDirectMemorySize setting |
| samples.include | True | Whether to include the bundled sample Accelerators in the install |

> **Note:** For clusters that do not support the `LoadBalancer` service type,
            override the default value for `server.service_type`.

VMware recommends that you do not override the defaults for `registry.secret_ref`,
`server.engine_invocation_url`, or `engine.service_type`.
These properties are only used to configure non-standard installations.

### Prerequisites

Before you install Application Accelerator,
you must have:

- Flux SourceController installed on the cluster.
See [Install Prerequisites](install-general.md#prereqs).

-  Source Controller installed on the cluster.
See [Install Source Controller](#install-source-controller).

### Procedure

To install Application Accelerator:

1. List version information for the package by running:

    ```bash
    tanzu package available list PACKAGE-NAME --namespace tap-install
    ```
    Where `PACKAGE-NAME` is the name of the package listed in step 5 of
     [Add the Tanzu Application Platform Package Repository](#add-package-repositories) above.
     For example:

    ```bash
    $ tanzu package available list accelerator.apps.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for accelerator.apps.tanzu.vmware.com...
      NAME                               VERSION  RELEASED-AT
      accelerator.apps.tanzu.vmware.com  0.4.0    2021-10-25T00:00:00Z
    ```

1. (Optional) To make changes to the default installation settings, run:

    ```bash
    tanzu package available get PACKAGE-NAME/VERSION-NUMBER --values-schema --namespace tap-install
    ```
    Where:

    - `PACKAGE-NAME` is same as step 1 above.
    - `VERSION-NUMBER` is the version of the package listed in step 1 above.

    For example:

    ```bash
    $ tanzu package available get accelerator.apps.tanzu.vmware.com/0.4.0 --values-schema --namespace tap-install
    ```

    For more information about values schema options, see the individual product documentation.


1. Create an `app-accelerator-values.yaml` using the following example code:

    ```yaml
    server:
      # Set the engine.service_type to "NodePort" for local clusters like minikube or kind.
      service_type: "LoadBalancer"
      watched_namespace: "default"
    samples:
      include: true
    ```

    Modify the values if needed or leave the default values.

1. Install the package by running:

    ```console
    tanzu package install app-accelerator -p accelerator.apps.tanzu.vmware.com -v 0.4.0 -n tap-install -f app-accelerator-values.yaml
    ```

    For example:

    ```console
    $ tanzu package install app-accelerator -p accelerator.apps.tanzu.vmware.com -v 0.4.0 -n tap-install -f app-accelerator-values.yaml
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
    $ tanzu package installed get app-accelerator -n tap-install
    | Retrieving installation details for cc...
    NAME:                    app-accelerator
    PACKAGE-NAME:            accelerator.apps.tanzu.vmware.com
    PACKAGE-VERSION:         0.4.0
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```
    STATUS should be `Reconcile succeeded`.

1. To access the Application Accelerator UI,
   see the [Application Accelerator for VMware Tanzu documentation](https://docs.vmware.com/en/Application-Accelerator-for-VMware-Tanzu/0.4/acc-docs/GUID-installation-install.html#using-application-accelerator-for-vmware-tanzu-0).

## <a id='install-tbs'></a> Install Tanzu Build Service

This section provides a quick-start guide for installing Tanzu Build Service as part of Tanzu Application Platform using the Tanzu CLI.

**Note**: This procedure might not include some configurations required for your specific environment. For more advanced details on installing Tanzu Build Service, see [Installing Tanzu Build Service](https://docs.pivotal.io/build-service/installing.html).


### Prerequisites

* You have access to a Docker registry that Tanzu Build Service can use to create Builder images. Approximately 5GB of registry space is required.
* Your Docker registry is accessible with username and password credentials.


### Install Tanzu Build Service Using the Tanzu CLI

To install Tanzu Build Service using the Tanzu CLI:

1. List version information for the package by running:

    ```bash
    tanzu package available list PACKAGE-NAME --namespace tap-install
    ```
    Where `PACKAGE-NAME` is the name of the package listed in step 5 of
     [Add the Tanzu Application Platform Package Repository](#add-package-repositories) above.
     For example:

    ```bash
    $ tanzu package available list buildservice.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for buildservice.tanzu.vmware.com...
      NAME                           VERSION  RELEASED-AT
      buildservice.tanzu.vmware.com  1.3.0    2021-09-28T00:00:00Z
    ```

1. (Optional) To make changes to the default installation settings, run:

    ```bash
    tanzu package available get PACKAGE-NAME/VERSION-NUMBER --values-schema --namespace tap-install
    ```
    Where:

    - `PACKAGE-NAME` is same as step 1 above.
    - `VERSION-NUMBER` is the version of the package listed in step 1 above.

    For example:

    ```bash
    $ tanzu package available get buildservice.tanzu.vmware.com/1.3.0 --values-schema --namespace tap-install
    ```

    For more information about values schema options, see the individual product documentation.


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
    kp_default_repository: REPOSITORY
    kp_default_repository_username: REGISTRY-USERNAME
    kp_default_repository_password: REGISTRY-PASSWORD
    tanzunet_username: TANZUNET-USERNAME
    tanzunet_password: TANZUNET-PASSWORD
    ```
    Where:

    - `REPOSITORY` is the fully qualified path to the repository that TBS will be written to. This path must be writable.

       Examples:
       * Docker Hub `my-dockerhub-account/build-service`
       * Google Container Registry `gcr.io/my-project/build-service`
       * Artifactory `artifactory.com/my-project/build-service`
       * Harbor `harbor.io/my-project/build-service`
    - `REGISTRY-USERNAME` and `REGISTRY-PASSWORD` are the username and password for the registry. The install requires a `kp_default_repository_username` and `kp_default_repository_password` in order to write to the repository location.
    - `TANZUNET-USERNAME` and `TANZUNET-PASSWORD` are the email address and password that you use to log in to Tanzu Network. The Tanzu Network credentials allow for configuration of the Dependencies Updater. This resource accesses and installs the build dependencies (buildpacks and stacks) Tanzu Build Service needs on your Cluster.  It also keeps these dependencies up-to-date as new versions are released on Tanzu Network.
    - **Optional values**: There are optional values not included in this sample file that provide additional configuration for production use cases. For more information, see [Installing Tanzu Build Service](https://docs.pivotal.io/build-service/installing.html).

1. Install the package by running:

    ```bash
    tanzu package install tbs -p buildservice.tanzu.vmware.com -v 1.3.0 -n tap-install -f tbs-values.yaml --poll-timeout 30m
    ```

    For example:

    ```bash
    $ tanzu package install tbs -p buildservice.tanzu.vmware.com -v 1.3.0 -n tap-install -f tbs-values.yaml --poll-timeout 30m
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

    **Note**: Installing the `buildservice.tanzu.vmware.com` package with Tanzu Network credentials automatically relocates buildpack dependencies to your cluster. This install process can take some time.  The command provided above increases the timeout duration.  If the command times out, periodically run the installation verification step provided in the following optional step. Image relocation will continue in the background.

1. (Optional) Run the following command to verify the clusterbuilders created by the Tanzu Build Service install:

    ```bash
    tanzu package installed get tbs -n tap-install
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

Supply Chain Choreographer provides the custom resource definitions that the supply chain uses.
It enables choreography of the components that form the software supply chain.
For example, Supply Chain Choreographer passes the results of fetching source code to the component
that knows how to build a container image from of it and then passes the container image
to a component that knows how to deploy the image.

```bash
# Install the version 0.0.6 of the `cartographer.tanzu.vmware.com`
# package naming the installation as `cartographer`.
#
tanzu package install cartographer \
  --namespace tap-install \
  --package-name cartographer.tanzu.vmware.com \
  --version 0.0.6
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

## <a id='install-default-supply-chain'></a> Install Default Supply Chain

To install Default Supply Chain:

1. Gather the values schema:

    ```bash
    tanzu package available get default-supply-chain.tanzu.vmware.com/0.2.0 --values-schema -n tap-install
    ```

    For example:

   ```console
   $ tanzu package available get default-supply-chain.tanzu.vmware.com/0.2.0 --values-schema -n tap-install
   | Retrieving package details for default-supply-chain.tanzu.vmware.com/0.2.0...

    KEY                  DEFAULT          TYPE    DESCRIPTION
    registry.repository  <nil>            string  Name of the repository in the image registry server where the application images from the workloads should be pushed to (required).
    registry.server      index.docker.io  string  Name of the registry server where application images should be pushed to.
    service_account      default          string  Name of the service account in the namespace where the Workload is submitted to utilize for providing registry credentials to Tanzu Build Service (TBS) Image objects as well as deploying the application.
    templates_namespace  tap-install      string  Name of the namespace where shared templates are installed to. This variable should point to the namespace where this package is being installed into.
    cluster_builder      default          string  Name of the Tanzu Build Service (TBS) ClusterBuilder to use by default on image objects managed by the supply chain.
   ```


1. Create a `default-supply-chain-values.yaml` using the following sample as a guide:

    Sample `default-supply-chain-values.yaml` for Default Supply Chain:

    ```yaml
    ---
    registry:
      server: REGISTRY-SERVER
      repository: REGISTRY-REPOSITORY
    service_account: service-account
    ```

1. Install the package by running:

     ```bash
    tanzu package install default-supply-chain \
      --package-name default-supply-chain.tanzu.vmware.com \
      --version 0.2.0 \
      --namespace tap-install \
      --values-file default-supply-chain-values.yaml
    ```

> **Note:** The `service-account` service account and required secrets are created in
[Set Up Developer Namespaces to Use Installed Packages](#setup).

## <a id='install-developer-conventions'></a> Install Developer Conventions

To install developer conventions:

**Prerequisite**: Convention Service installed on the cluster, see [Install Convention Service](#install-convention-service).

1. List version information for the package by running:

    ```bash
    tanzu package available list PACKAGE-NAME --namespace tap-install
    ```
    Where `PACKAGE-NAME` is the name of the package listed in step 5 of
     [Add the Tanzu Application Platform Package Repository](#add-package-repositories) above.
     For example:

    ```bash
    $ tanzu packageavailable list developer-conventions.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for developer-conventions.tanzu.vmware.com
      NAME                                    VERSION        RELEASED-AT
      developer-conventions.tanzu.vmware.com  0.3.0-build.1  2021-10-19T00:00:00Z
    ```

1. To make changes to the default installation settings, run:


    ```bash
    tanzu package available get developer-conventions.tanzu.vmware.com/0.3.0-build.1 -n tap-install
    ```

    For example:

    ```console
    $ tanzu package available get developer-conventions.tanzu.vmware.com/0.3.0-build.1 -n tap-install
    \ Retrieving package details for developer-conventions.tanzu.vmware.com/0.3.0-build.1...
    NAME:                             developer-conventions.tanzu.vmware.com
    VERSION:                          0.3.0-build.1
    RELEASED-AT:                      2021-10-19T00:00:00Z
    DISPLAY-NAME:                     Tanzu App Platform Developer Conventions
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
      --version 0.3.0-build.1 \
      --namespace tap-install
    ```


## <a id="install-app-live-view"></a>Install Application Live View

To install Application Live View:

**Prerequisite**: Convention Service installed on the cluster, see [Install Convention Service](#install-convention-service).

1. List version information for the package by running:

    ```bash
    tanzu package available list appliveview.tanzu.vmware.com --namespace tap-install
    ```

     For example:

    ```bash
    $ tanzu package available list appliveview.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for appliveview.tanzu.vmware.com...
      NAME                          VERSION  RELEASED-AT
      appliveview.tanzu.vmware.com  0.3.0    2021-10-25T00:00:00Z
    ```

1. (Optional) To make changes to the default installation settings, run:

    ```bash
    tanzu package available get appliveview.tanzu.vmware.com/0.3.0 --values-schema --namespace tap-install
    ```

    For example:

    ```bash
    $ tanzu package available get appliveview.tanzu.vmware.com/0.3.0 --values-schema --namespace tap-install
    - Retrieving package details for appliveview.tanzu.vmware.com/0.3.0...
      KEY                   DEFAULT        TYPE    DESCRIPTION
      connector_namespaces  [default]      array   The namespaces in which ALV monitors the users apps
      service_type          ClusterIP      string  The service type for the Application Live View server can be LoadBalancer, NodePort, or ClusterIP
    ```

    For more information about values schema options, see the individual product documentation.

1. Gather the values schema.

1. Create a `app-live-view-values.yaml` using the following sample as a guide:

   ```yaml
   ---
   connector_namespaces: [default]
   service_type: ClusterIP
   ```

   Where:

   - `connector_namespaces` is a list of namespaces where you want
   Application Live View to monitor your apps. An instance of the
   Application Live View Connector will be deployed to each of those namespaces.
   - `service_type` is the Kubernetes service type for the Application Live View server.
   This can be LoadBalancer, NodePort, or ClusterIP.

   The application live view server and its components are deployed in `app-live-view` namespace by default.

1. Install the package by running:

    ```console
    tanzu package install app-live-view -p appliveview.tanzu.vmware.com -v 0.3.0 -n tap-install -f app-live-view-values.yaml
    ```

    For example:

    ```console
    $ tanzu package install app-live-view -p appliveview.tanzu.vmware.com -v 0.3.0 -n tap-install -f app-live-view-values.yaml
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
    see the [Application Live View documentation](https://docs.vmware.com/en/Application-Live-View-for-VMware-Tanzu/0.3/docs/GUID-index.html).

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
    PACKAGE-VERSION:         0.3.0
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```
    STATUS should be `Reconcile succeeded`.


To access the Application Live View UI:

1. List the resources deployed in the `app-live-view` namespace by running:

    ```bash
    kubectl get -n app-live-view service,deploy,pod
    ```

    The output will be similar to the following:

    ```
    NAME                                 TYPE           CLUSTER-IP       EXTERNAL-IP                                                              PORT(S)        AGE
    service/application-live-view-5112   LoadBalancer   10.103.108.215   a031c3c2d27334cf1857546e59a5b42c-305213456.us-east-2.elb.amazonaws.com   80:31999/TCP   28h
    service/application-live-view-7000   ClusterIP      10.104.55.249    <none>                                                                   7000/TCP       28h
    service/appliveview-webhook          ClusterIP      10.98.15.167     <none>                                                                   443/TCP        28h

    NAME                                                   READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.apps/application-live-view-crd-controller   1/1     1            1           28h
    deployment.apps/application-live-view-server           1/1     1            1           28h
    deployment.apps/appliveview-webhook                    1/1     1            1           28h

    NAME                                                        READY   STATUS    RESTARTS   AGE
    pod/application-live-view-crd-controller-69bcb99d7f-dkqlf   1/1     Running   0          28h
    pod/application-live-view-server-866dc675d9-2mkh4           1/1     Running   0          27h
    pod/appliveview-webhook-6479f7986-pvjfp                     1/1     Running   0          28h
    ```

1. If the service type of application-live-view-5112 is `LoadBalancer`, you can access the Application Live View UI using the listed EXTERNAL-IP address for the service application-live-view-5112. Access the server at: http://ae27a3a69e8e34e35835619eb13ed59f-1054315375.ap-south-1.elb.amazonaws.com

1. If your cluster does not support LoadBalancer and you use `NodePort`, you can port-forward with kubectl. To port-forward the UI server, run the following command in a separate terminal:

    ```bash
    kubectl -n app-live-view port-forward service/application-live-view-5112 5112:80
    ```
    You can access the server at http://localhost:5112.

1. If the service type of application-live-view-5112 is `ClusterIP`, you can access the Application Live View UI using an ingress controller.

## <a id='install-tap-gui'></a> Install Tanzu Application Platform GUI

To install Tanzu Application Platform GUI, see the following sections.

### Prerequisites in Addition to Tanzu Application Platform Requirements

**Required**

- Git repository for the software catalogs and a token allowing read access.
Supported Git infrastructure includes:
    - GitHub
    - GitLab
    - Azure DevOps
- Blank Software Catalog from the Tanzu Application section of Tanzu Network

**Optional**

- **Tanzu Application Platform tools:** Tanzu Application Platform GUI has plugins for the
following Tanzu Application Platform tools.
If you plan on running workloads with these capabilities, you need these tools installed alongside
Tanzu Application Platform GUI.
If you choose not to deploy workloads with these tools, the GUI shows menu options that you cannot
click on.
    - Tanzu Cloud Native Runtimes
    - Tanzu App Live View
- **Data cache:** Your software catalog is stored on Git infrastructure, as mentioned in the
required prerequisites. However, you also have the option to use a PostgreSQL database to
cache this information. If you do not specify any values here, a SQLite in-memory database is used
instead.
    - PostgreSQL database and connection information
- **Authentication:**
    - OIDC Identity Provider connection information
- **Customer-developed documentation:**
    - Techdocs object storage location (S3)

### Procedure

To install Tanzu Application Platform GUI:

1. List version information for the package by running:

    ```bash
    tanzu package available list tap-gui.tanzu.vmware.com --namespace tap-install
    ```
    For example:

    ```bash
    $ tanzu package available list tap-gui.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for tap-gui.tanzu.vmware.com...
      NAME                      VERSION     RELEASED-AT
      tap-gui.tanzu.vmware.com  0.3.0      2021-10-20T14:46:26Z
    ```

2. (Optional) To make changes to the default installation settings, run:

    ```bash
    tanzu package available get tap-gui.tanzu.vmware.com/0.3.0 --values-schema --namespace tap-install
    ```

    For more information about values schema options, see the individual product documentation.


1. Create `tap-gui-values.yaml` using the following example code, replacing all `<PLACEHOLDERS>`
with your relevant values. The meanings of some placeholders are explained in this example:

    ```yaml
    namespace: tap-gui
    service_type: <SERVICE-TYPE>
    app-config:
      app:
        baseUrl: <EXTERNAL-IP>:<PORT>
      integrations:
        gitlab:
          - host: <GITLAB-HOST>
            apiBaseUrl: https://<GITLAB-URL>/api/v4
            token: <GITLAB-TOKEN>
      # techdocs: # Only needed if you want to enable TechDocs capability. Requires running the TechDoc CLI to generate TechDocs from catalog Markdown to S3 compatible bucket called out in Additional Resources documentation.
      #  builder: 'external'
      #  generator:
      #    runIn: 'docker'
      #  publisher:
      #    type: 'awsS3'
      #    awsS3:
      #      bucketName: '<S3-BUCKET-NAME>'
      #      credentials:
      #        accessKeyId: '<S3-ACCESS-KEY>'
      #        secretAccessKey: '<S3-SECRET-KEY>'
      #      region: '<S3-REGION>'
      #      s3ForcePathStyle: false # Set value to true if using local S3 solution (Minio)  

      # auth: # Only needed if you want to enable OIDC login integration, otherwise only Guest mode is enabled
      #  environment: development
      #  session:
      #    secret: custom session secret # Unique string required by auth-backend to save browser session state
      #  providers:
      #    oidc: # Detailed configuration of the OIDC auth capabilities are documented here: https://backstage.io/docs/auth/oauth
      #      development:
      #        metadataUrl: <AUTH-OIDC-METADATA-URL> # metadataUrl is a json file with generic oidc provider config. It contains the authorizationUrl and tokenUrl. These values are read from the metadataUrl file by Backstage and so they do not need to be specified explicitly here.
      #        clientId: <AUTH-OIDC-CLIENT-ID>
      #        clientSecret: <AUTH-OIDC-CLIENT-SECRET>
      #        tokenSignedResponseAlg: <AUTH-OIDC-TOKEN-SIGNED-RESPONSE-ALG> # default='RS256'
      #        scope: <AUTH-OIDC-SCOPE> # default='openid profile email'
      #        prompt: <TYPE> # default=none (allowed values: auto, none, consent, login)
      catalog:
        locations:
          - type: url
            target: https://<GIT-CATALOG-URL>/catalog-info.yaml
      backend:
          baseUrl: <EXTERNAL-IP>:<PORT>
          cors:
              origin: <EXTERNAL-IP>:<PORT>
      # database: # Only needed if you intend to support with an existing PostgreSQL database. The catalog is still refreshed from Git.
      #     client: pg
      #      connection:
      #        host: <PGSQL-HOST>
      #        port: <PGSQL-PORT>
      #        user: <PGSQL-USER>
      #        password: <PGSQL-PWD>
      #        ssl: {rejectUnauthorized: false} # May be needed if using self-signed certs
    ```
    Where:

    - `<SERVICE-TYPE>` is your inbound traffic mechanism: LoadBalancer or Ingress.
    - `<EXTERNAL-IP>:<PORT>` is your Ingress hostname or LoadBalancer information.
       If you are using a load balancer that is dynamically provisioned by the cloud provider,
       leave this value blank initially and, after the install is complete,
       run a subsequent `tanzu package installed update`.
    - `<GIT-CATALOG-URL>` is the path to the `catalog-info.yaml` catalog definition file from either the included Blank catalog (provided as an additional download named "Blank Tanzu Application Platform GUI Catalog") or a Backstage compliant catalog that you've already built and posted on the Git infrastucture that you specified in the Integration section.

    > **Note:** The `app-config` section follows the same configuration model that Backstage uses.
    For more information, see the [Backstage documentation](https://backstage.io/docs/conf/).
    Detailed configuration of the OIDC auth capabilities are in this [Backstage OAuth documentation](https://backstage.io/docs/auth/oauth).

    > **Note:** The `integrations` section uses GitLab. If you want additional integrations, see the
    format in this [Backstage integration documentation](https://backstage.io/docs/integrations/).

1. Install the package by running:

    ```console
    tanzu package install tap-gui \
     --package-name tap-gui.tanzu.vmware.com \
     --version 0.3.0 -n tap-install \
     -f tap-gui-values.yaml
    ```

    For example:

    ```console
    $ tanzu package install tap-gui -package-name tap-gui.tanzu.vmware.com --version 0.3.0 -n tap-install -f tap-gui-values.yaml
    - Installing package 'tap-gui.tanzu.vmware.com'
    | Getting package metadata for 'tap-gui.tanzu.vmware.com'
    | Creating service account 'tap-gui-default-sa'
    | Creating cluster admin role 'tap-gui-default-cluster-role'
    | Creating cluster role binding 'tap-gui-default-cluster-rolebinding'
    | Creating secret 'tap-gui-default-values'
    - Creating package resource
    - Package install status: Reconciling

     Added installed package 'tap-gui' in namespace 'tap-install'
    ```

1. Verify that the package installed by running:

    ```console
    tanzu package installed get tap-gui -n tap-install
    ```

    For example:

    ```console
    $ tanzu package installed get tap-gui -n tap-install
    | Retrieving installation details for cc...
    NAME:                    tap-gui
    PACKAGE-NAME:            tap-gui.tanzu.vmware.com
    PACKAGE-VERSION:         0.3.0
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```
    `STATUS` should be `Reconcile succeeded`.

1. To access Tanzu Application Platform GUI, use the service you exposed in the `service_type`
field in the values file.


## Install Learning Center

To install Tanzu Learning Center:

* Create a configuration YAML file called `educates-config.yaml`:

    ```yaml
    ingressDomain: <educates.my-domain.com>
    ```
    Where `<educates.my-domain.com>` is the domain name for your Kubernetes cluster.

The only field required is the `ingressDomain` property: all other properties are optional.

When deploying workshop environment instances, the operator must be able to expose the instances
through an external URL. This access is needed to discover the domain name that can be used as a
suffix to hostnames for instances.

> **Note:** For the custom domain you are using, DNS must have been configured with a wildcard
domain. This is necessary to forward all requests for subdomains of the custom domain to the
ingress router of the Kubernetes cluster.

`.dev` domain names are discouraged because they can only use HTTPS, not HTTP.
Although you can provide a certificate for secure connections under the domain name that
Learning Center uses, a workshop might function differently.
For example, workshop instructions might tell you to create ingresses in Kubernetes using HTTP
only, and these will not work if the domain name is `.dev`.

> **Note:** If you are running Kubernetes on your local machine using a system such as `minikube`,  
and you do not have a custom domain name that maps to the IP for the cluster, you can use a
`nip.io` address.
For example, if `minikube ip` returns `192.168.64.1`, you can use the `192.168.64.1.nip.io`
domain. You cannot use an address of the forms `127.0.0.1.nip.io` or `subdomain.localhost`.
Doing so causes a failure because internal services, when trying to connect to each other, would
connect to themselves instead -- the address would resolve to the host loopback address of
`127.0.0.1`.


### Optional Configuration Settings

The following procedures configure optional settings.


#### Enforce Secure Connections

By default, the workshop portal and workshop sessions are accessible over HTTP connections.
To use HTTPS connections, you need access to a wildcard SSL certificate for the domain that hosts
the workshops. You cannot use a self-signed certificate.

* **If you have a TLS secret:**

    * Copy the TLS secret to the `educates` namespace or the one you defined, and use
    the `secretName` property in `educates-config.yaml`:

    ```yaml
    ingressSecret:
     secretName: <SECRET-NAME>
    ```

    Where `<SECRET-NAME>` is your secret name, such as `workshops.example.com-tls`.

* **If you do not already have a TLS secret:**

1. Create a wildcard certificate. [Let's Encrypt](https://letsencrypt.org/) is one option for doing so.

1. After you have your certificate, add the following to `educates-config.yaml`:

    ```yaml
    ingressSecret:
     certificate: <CERTIFICATE-VALUE>
     privateKey: <PRIVATE-KEY>
    ```


#### Specify the Ingress Class

Any ingress routes created use the default ingress class.
If you have multiple ingress class types available, and you need to override the one used, add the
following to `educates-config.yaml`:

    ```yaml
    ingressClass: <TYPE>
    ```

    Where `<TYPE>` is your chosen type, such as `contour`.


#### Select the Primary Image Registry

`educates` container images are stored in the primary image registry.
It is only necessary to define the host and credentials when that image registry requires
authentication to access images.
This principally exists to enable relocation of images through Carvel image bundles.

* Select the primary image registry by adding the following to `educates-config.yaml`:

    ```yaml
    imageRegistry: <IMAGE-REGISTRY>
     host: <HOST>
     username: <USERNAME>
     password: <PASSWORD>
    ```

1. Install the Learning Center operator by running:

    ```shell
    tanzu package install educates --package-name learningcenter.tanzu.vmware.com --version 1.0.8-build.1 -f educates-config.yaml
    ```

    This command creates a default namespace in your Kubernetes cluster called `educates`
    and includes the operator along with any required namespaced resources within it.
    It also creates a set of custom resource definitions and a global cluster role binding.

1. Verify that you see this list of created resources:

    ```shell
    customresourcedefinition.apiextensions.k8s.io/workshops.training.eduk8s.io created
    customresourcedefinition.apiextensions.k8s.io/workshopsessions.training.eduk8s.io created
    customresourcedefinition.apiextensions.k8s.io/workshopenvironments.training.eduk8s.io created
    customresourcedefinition.apiextensions.k8s.io/workshoprequests.training.eduk8s.io created
    customresourcedefinition.apiextensions.k8s.io/trainingportals.training.eduk8s.io created
    serviceaccount/eduk8s created
    customresourcedefinition.apiextensions.k8s.io/systemprofiles.training.eduk8s.io created
    clusterrolebinding.rbac.authorization.k8s.io/eduk8s-cluster-admin created
    deployment.apps/eduk8s-operator created
    ```

1. Verify that the operator deployed successfully by running:

    ```shell
    kubectl get all -n educates
    ```

    and check that the Pod for the operator is marked as running.


## <a id='install-service-bindings'></a> Install Service Bindings

 Use the following procedure to install Service Bindings:

1. List version information for the package by running:

    ```bash
    tanzu package available list PACKAGE-NAME --namespace tap-install
    ```
    Where `PACKAGE-NAME` is the name of the package listed earlier in
     [Add the Tanzu Application Platform Package Repository](#add-package-repositories).
     For example:

    ```bash
    $ tanzu package available list service-bindings.labs.vmware.com --namespace tap-install
    - Retrieving package versions for service-bindings.labs.vmware.com...
      NAME                              VERSION  RELEASED-AT
      service-bindings.labs.vmware.com  0.5.0    2021-09-15T00:00:00Z
    ```

2. (Optional) To make changes to the default installation settings, run:

    ```bash
    tanzu package available get PACKAGE-NAME/VERSION-NUMBER --values-schema --namespace tap-install
    ```
    Where:

    - `PACKAGE-NAME` is same as step 1 above.
    - `VERSION-NUMBER` is the version of the package listed in step 1 above.

    For example:

    ```bash
    $ tanzu package available get service-bindings.labs.vmware.com/0.5.0 --values-schema --namespace tap-install
    ```

    For more information about values schema options, see the individual product documentation.

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

1. List version information for the package by running:

    ```bash
    tanzu package available list PACKAGE-NAME --namespace tap-install
    ```
    Where `PACKAGE-NAME` is the name of the package listed in step 5 of
     [Add the Tanzu Application Platform Package Repository](#add-package-repositories) above.
     For example:

    ```bash
    $ tanzu package available list scst-store.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for scst-store.tanzu.vmware.com...
      NAME                         VERSION       RELEASED-AT
      scst-store.tanzu.vmware.com  1.0.0-beta.1
    ```

1. (Optional) To make changes to the default installation settings, run:

    ```sh
    tanzu package available get scst-store.tanzu.vmware.com/1.0.0-beta.1 --values-schema -n tap-install
    ```

    For example:

    ```sh
    $ tanzu package available get scst-store.tanzu.vmware.com/1.0.0-beta.1 --values-schema -n tap-install
    | Retrieving package details for scst-store.tanzu.vmware.com/1.0.0-beta.1...
      KEY                     DEFAULT              TYPE     DESCRIPTION
      app_service_type        NodePort             string   The type of service to use for the metadata app service. This can be set to 'Nodeport' or 'LoadBalancer'.
      auth_proxy_host         0.0.0.0              string   The binding ip address of the kube-rbac-proxy sidecar
      db_host                 metadata-store-db    string   The address to the postgres database host that the metdata-store app uses to connect. The default is set to metadata-store-db which is the postgres service name. Changing this does not change the postgres service name
      db_replicas             1                    integer  The number of replicas for the metadata-store-db
      db_sslmode              verify-full          string   Determines the security connection between API server and Postgres database. This can be set to 'verify-ca' or 'verify-full'
      pg_limit_memory         4Gi                  string   Memory limit for postgres container in metadata-store-db deployment
      app_req_cpu             100m                 string   CPU request for metadata-store-app container
      app_limit_memory        512Mi                string   Memory limit for metadata-store-app container
      app_req_memory          128Mi                string   Memory request for metadata-store-app container
      auth_proxy_port         8443                 integer  The external port address of the of the kube-rbac-proxy sidecar
      db_name                 metadata-store       string   The name of the database to use.
      db_port                 5432                 string   The database port to use. This is the port to use when connecting to the database pod.
      api_port                9443                 integer  The internal port for the metadata app api endpoint. This will be used by the kube-rbac-proxy sidecar.
      app_limit_cpu           250m                 string   CPU limit for metadata-store-app container
      app_replicas            1                    integer  The number of replicas for the metadata-store-app
      db_user                 metadata-store-user  string   The database user to create and use for updating and querying. The metadata postgres section create this user. The metadata api server uses this username to connect to the database.
      pg_req_memory           1Gi                  string   Memory request for postgres container in metadata-store-db deployment
      priority_class_name                          string   If specified, this value is the name of the desired PriorityClass for the metadata-store-db deployment
      use_cert_manager        true                 string   Cert manager is required to be installed to use this flag. When true, this creates certificates object to be signed by cert manager for the API server and Postgres database. If false, the certificate object have to be provided by the user.
      api_host                localhost            string   The internal hostname for the metadata api endpoint. This will be used by the kube-rbac-proxy sidecar.
      db_password                                  string   The database user password.
      storageClassName                             string   The storage class name of the persistent volume used by Postgres database for storing data. The default value will use the default class name defined on the cluster.
      databaseRequestStorage  10Gi                 string   The storage requested of the persistent volume used by Postgres database for storing data.
    ```

1. Gather the values schema.
1. Create a `scst-store-values.yaml` using the following sample as a guide:

    Sample `scst-store-values.yaml` for Supply Chain Security Tools - Store:

    ```yaml
    db_password: "PASSWORD-0123"
    app_service_type: "LoadBalancer"
    ```
    Where `PASSWORD-0123` is the same password used between deployments. For more information, see [Known Issues - Persistent Volume Retains Data](scst-store/known_issues.md#persistent-volume-retains-data).

    If your environment does not support `LoadBalancer`, omit the `app_service_type` line so that
    the default value `NodePort` is used instead.

1. Install the package by running:

    ```sh
    tanzu package install metadata-store \
      --package-name scst-store.tanzu.vmware.com \
      --version 1.0.0-beta.1 \
      --namespace tap-install \
      --values-file scst-store-values.yaml
    ```

    For example:

    ```sh
    $ tanzu package install metadata-store \
      --package-name scst-store.tanzu.vmware.com \
      --version 1.0.0-beta.1 \
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

Install Supply Chain Security Tools - Sign rejects pods from starting if the webhook fails or is misconfigured.
If the webhook is preventing the cluster from functioning, you can delete the configuration by running:

```bash
kubectl delete MutatingWebhookConfiguration image-policy-mutating-webhook-configuration
```
For example, pods can be rejected from starting if all nodes running the
webhook are scaled down and the webhook is forced to restart at the same time as
other system components. A deadlock can occur when some components expect the
webhook to run in order to verify their image signatures and the webhook is not
running yet. By deleting the `MutatingWebhookConfiguration` resource, you can
resolve the deadlock and enable the system to start up again. Once the system
is stable, you can restore the `MutatingWebhookConfiguration` resource to
re-enable image signing enforcement.

**Prerequisites**: As part of the install instructions, we will ask you to provide a cosign public key to use to validate signed images. We will provide an example cosign public key that will be able to validate an image from the public cosign registry. If you wish to provide your own key and images, you can follow the [cosign quick start guide](https://github.com/sigstore/cosign#quick-start) to generate your own keys and sign an image.

To install Supply Chain Security Tools - Sign:

1. List version information for the package by running:

    ```bash
    tanzu package available list image-policy-webhook.signing.run.tanzu.vmware.com --namespace tap-install
    ```
    For example:

    ```bash
    $ tanzu package available list image-policy-webhook.signing.run.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for image-policy-webhook.signing.run.tanzu.vmware.com...
      NAME                                               VERSION         RELEASED-AT
      image-policy-webhook.signing.run.tanzu.vmware.com  1.0.0-beta.1    2021-10-25T00:00:00Z
    ```

2. (Optional) To make changes to the default installation settings, run:

    ```bash
    tanzu package available get image-policy-webhook.signing.run.tanzu.vmware.com/1.0.0-beta.1 --values-schema --namespace tap-install
    ```
    For example:

    ```bash
    $ tanzu package available get image-policy-webhook.signing.run.tanzu.vmware.com/1.0.0-beta.1 --values-schema --namespace tap-install
    | Retrieving package details for image-policy-webhook.signing.run.tanzu.vmware.com/1.0.0-beta.1...
      KEY                     DEFAULT  TYPE     DESCRIPTION
      allow_unmatched_images  false    boolean  Feature flag for enabling admission of images that do not match
                                                any patterns in the image policy configuration.
                                                Set to true to allow images that do not match any patterns into
                                                the cluster with a warning.
    ```

1. Create a file named `scst-sign-values.yaml` with a `allow_unmatched_images` property.
    * **For non-production environments**: To warn the user when images do not match any pattern in the policy, but still allow them into the cluster, set `allow_unmatched_images` to `true`.
        ```yaml
        ---
        allow_unmatched_images: true
        ```
    * **For production environments**: To deny images that do not match any pattern in the policy, set `allow_unmatched_images` to `false`.
        ```yaml
        ---
        allow_unmatched_images: false
        ```
        **Note**: For a quicker installation process, VMware recommends that you set `allow_unmatched_images` to `true` initially.
        This means that the webhook does not prevent unsigned images from running if the image does not match any pattern in the policy.
        To promote to a production environment, VMware recommends that you re-install the webhook with `allow_unmatched_images` set to `false`.

1. Install the package:

    ```bash
    tanzu package install image-policy-webhook \
      --package-name image-policy-webhook.signing.run.tanzu.vmware.com \
      --version 1.0.0-beta.1 \
      --namespace tap-install \
      --values-file scst-sign-values.yaml
    ```

    For example:
    ```bash
    $ tanzu package install image-policy-webhook \
        --package-name image-policy-webhook.signing.run.tanzu.vmware.com \
        --version 1.0.0-beta.1 \
        --namespace tap-install \
        --values-file scst-sign-values.yaml

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

   After you run the code above, the webhook is running.

1. Create a service account named `image-policy-registry-credentials` in the `image-policy-system` namespace. When cosign `signs` an image, it generates a signature in an OCI-compliant format and pushes it to the registry alongside the image with the tag `sha256-<image-digest>.sig`. To access this signature, the webhook needs the credentials of the registry where the signature and image reside.

    * **If the images and signatures are in public registries:** No additional configuration is needed. Run:
        ```console
        cat <<EOF | kubectl apply -f -
        apiVersion: v1
        kind: ServiceAccount
        metadata:
          name: image-policy-registry-credentials
          namespace: image-policy-system
        EOF
        ```

    * **If the images and signatures are in private registries:** Add secrets to the `imagePullSecrets` property of the service account. Run:
        ```console
        cat <<EOF | kubectl apply -f -
        apiVersion: v1
        kind: ServiceAccount
        metadata:
          name: image-policy-registry-credentials
          namespace: image-policy-system
        imagePullSecrets:
        - name: SECRET-1
        EOF
        ```
        Where `SECRET-1` is a secret that allows the webhook to access the private registry.
        You can specify existing `imagePullSecrets` that are part of the `image-policy-system` namespace,
        or you can create new ones by running:
        ```bash
        kubectl create secret docker-registry SECRET-1 \
          --namespace image-policy-system \
          --docker-server=<server> \
          --docker-username=<username> \
          --docker-password=<password>
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

    - The `name` for the `ClusterImagePolicy` must be `image-policy`.
    - In the `verification.exclude.resources.namespaces` section, add any namespaces that run container images that are unsigned, such as `kube-system`.
    - If no `ClusterImagePolicy` is created, images are permitted into the cluster.
      with the following warning: `Warning: clusterimagepolicies.signing.run.tanzu.vmware.com "image-policy" not found`.
    - For a quicker installation process in a non-production environment, VMware recommends you use the following YAML to create the `ClusterImagePolicy`. This YAML includes a cosign public key, which signed the public cosign image for v1.2.1. The cosign public key validates the specified cosign image. You can add additional namespaces to exclude in the `verification.exclude.resources.namespaces` section, such as a system namespace.
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

        1. Verify that a signed image, validated with a configured public key, launches. Run:
            ```bash
            kubectl run cosign --image=gcr.io/projectsigstore/cosign:v1.2.1 --restart=Never --command -- sleep 900
            ```
            For example:
            ```bash
            $ kubectl run cosign --image=gcr.io/projectsigstore/cosign:v1.2.1 --restart=Never --command -- sleep 900
            pod/cosign created
            ```
        1. Verify that an unsigned image does not launch. Run:
            ```bash
            kubectl run bb --image=busybox --restart=Never
            ```
            For example:
            ```bash
            $ kubectl run bb --image=busybox --restart=Never
            Warning: busybox didn\'t match any pattern in policy. Pod will be created as AllowOnUnmatched flag is true
            pod/bb created
            ```
        1. Verify that a signed image, that does not validate with a configured public key, does not launch. Run:
            ```bash
            kubectl run cosign-fail --image=gcr.io/projectsigstore/cosign:v0.3.0 --command -- sleep 900
            ```
            For example:
            ```bash
            $ kubectl run cosign-fail --image=gcr.io/projectsigstore/cosign:v0.3.0 --command -- sleep 900
            Error from server (The image: gcr.io/projectsigstore/cosign:v0.3.0 is not signed): admission webhook "image-policy-webhook.signing.run.tanzu.vmware.com" denied the request: The image: gcr.io/projectsigstore/cosign:v0.3.0 is not signed
            ```

## <a id='install-scst-scan'></a> Install Supply Chain Security Tools - Scan

**Prerequisite**: [Supply Chain Security Tools - Store](#install-scst-store) must be installed on the cluster for Scan Results to persist. Supply Chain Security Tools - Scan can be installed without [Supply Chain Security Tools - Store](#install-scst-store) already installed. In this case, skip creating a values file. Once [Supply Chain Security Tools - Store](#install-scst-store) is installed, the Supply Chain Security Tools - Scan values file must be updated.

The installation for Supply Chain Security Tools – Scan involves installing two packages:
Scan Controller and Grype Scanner.
The Scan Controller enables you to use a scanner. The Grype Scanner is a scanner. Ensure both the Grype Scanner and the Scan Controller are installed.

To install Supply Chain Security Tools - Scan (Scan Controller):

1. List version information for the package by running:

    ```bash
    tanzu package available list scanning.apps.tanzu.vmware.com --namespace tap-install
    ```

     For example:

    ```console
    $ tanzu package available list scanning.apps.tanzu.vmware.com --namespace tap-install
    / Retrieving package versions for scanning.apps.tanzu.vmware.com...
      NAME                            VERSION       RELEASED-AT
      scanning.apps.tanzu.vmware.com  1.0.0-beta.2
    ```

1. (Optional) To make changes to the default installation settings, run:

    ```bash
    tanzu package available get scanning.apps.tanzu.vmware.com/1.0.0-beta.2 --values-schema -n tap-install
    ```

    For example:

    ```console
    $ tanzu package available get scanning.apps.tanzu.vmware.com/1.0.0-beta.2 --values-schema -n tap-install
    | Retrieving package details for scanning.apps.tanzu.vmware.com/1.0.0-beta.2...
      KEY                        DEFAULT           TYPE    DESCRIPTION
      metadataStoreUrl                             string  Url of the Insight Metadata Store deployed in the cluster
      namespace                  scan-link-system  string  Deployment namespace for the Scan Controller
      resources.limits.cpu       250m              <nil>   Limits describes the maximum amount of cpu resources allowed.
      resources.limits.memory    256Mi             <nil>   Limits describes the maximum amount of memory resources allowed.
      resources.requests.cpu     100m              <nil>   Requests describes the minimum amount of cpu resources required.
      resources.requests.memory  128Mi             <nil>   Requests describes the minimum amount of memory resources required.
      metadataStoreCaSecret                        string  Name of deployed Secret with key ca.crt holding the CA Cert of the Insight Metadata Store deployed in the cluster
      metadataStoreClusterRole                     string  Name of the deployed ClusterRole for read/write access to the Insight Metadata Store deployed in the cluster
    ```

1. Gather the values schema.

1. If [Supply Chain Security Tools - Store](#install-scst-store) is installed, configure a TLS Certificate `Secret` and Read-Write `ClusterRole` for the [Supply Chain Security Tools - Store](#install-scst-store).

    The TLS Certificate necessary for sending requests to the [Supply Chain Security Tools - Store](#install-scst-store) resides in the `metadata-store` namespace. Create the following secret in the `scan-link-system` by copying the CA Certificate from the `metadata-store` namespace by running:

    ```bash
    kubectl create namespace scan-link-system
    kubectl create secret generic metadata-store-ca \
      -n scan-link-system \
      --from-file=ca.crt=<(kubectl get secret app-tls-cert -n metadata-store -o json | jq -r '.data."ca.crt"' | base64 -d)
    ```

    Create the necessary `ClusterRole` for sending requests to the [Supply Chain Security Tools - Store](#install-scst-store) by running:

    ```bash
    kubectl apply -f - -o yaml << EOF
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
      name: metadata-store-read-write
    rules:
    - apiGroups: [ "metadata-store/v1" ]
      resources: [ "all" ]
      verbs: [ "get", "create", "update" ]
    EOF
    ```

1. If [Supply Chain Security Tools - Store](#install-scst-store) is installed, create a `scst-scan-controller-values.yaml` using the following sample as a guide.

    Sample `scst-scan-controller-values.yaml` for Scan Controller:

    ```yaml
    ---
    metadataStoreUrl: https://metadata-store-app.metadata-store.svc.cluster.local:8443
    metadataStoreCaSecret: metadata-store-ca
    metadataStoreClusterRole: metadata-store-read-write
    ```

    The following shows how to determine what these values are:

    The `metadataStoreUrl` value can be determined by:

    ```bash
    kubectl get service -n metadata-store -o name |
      grep app |
      xargs kubectl -n metadata-store get -o jsonpath='{.spec.ports[].name}{"://"}{.metadata.name}{"."}{.metadata.namespace}{".svc.cluster.local:"}{.spec.ports[].port}'
    ```

    The `metadataStoreCaSecret` value is the name of the TLS Certificate `Secret` created above.

    The `metadataStoreClusterRole` value is the name of the `ClusterRole` created above.

4. If [Supply Chain Security Tools - Store](#install-scst-store) is installed, install the package by running (omit the `--values-file` line if installing without [Supply Chain Security Tools - Store](#install-scst-store) already installed):

    ```bash
    tanzu package install scan-controller \
      --package-name scanning.apps.tanzu.vmware.com \
      --version 1.0.0-beta.2 \
      --namespace tap-install \
      --values-file scst-scan-controller-values.yaml
    ```

    For example:

    ```console
    $ tanzu package install scan-controller \
      --package-name scanning.apps.tanzu.vmware.com \
      --version 1.0.0-beta.2 \
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

1. List version information for the package by running:

    ```bash
    tanzu package available list grype.scanning.apps.tanzu.vmware.com --namespace tap-install
    ```

     For example:

    ```console
    $ tanzu package available list grype.scanning.apps.tanzu.vmware.com --namespace tap-install
    / Retrieving package versions for grype.scanning.apps.tanzu.vmware.com...
      NAME                                  VERSION       RELEASED-AT
      grype.scanning.apps.tanzu.vmware.com  1.0.0-beta.2
    ```

1. (Optional) To make changes to the default installation settings, run:

    ```bash
    tanzu package available get grype.scanning.apps.tanzu.vmware.com/1.0.0-beta.2 --values-schema -n tap-install
    ```

    For example:
    ```console
    $ tanzu package available get grype.scanning.apps.tanzu.vmware.com/1.0.0-beta.2 --values-schema -n tap-install
    | Retrieving package details for grype.scanning.apps.tanzu.vmware.com/1.0.0-beta.2...
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
      --version 1.0.0-beta.2 \
      --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package install grype-scanner \
      --package-name grype.scanning.apps.tanzu.vmware.com \
      --version 1.0.0-beta.2 \
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



1. Check what versions of API portal are available to install by running:

    ```bash
    tanzu package available list -n tap-install api-portal.tanzu.vmware.com
    ```

    For example:

    ```console
    $ tanzu package available list api-portal.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for api-portal.tanzu.vmware.com...
      NAME                         VERSION  RELEASED-AT
      api-portal.tanzu.vmware.com  1.0.3    2021-10-13T00:00:00Z
    ```

2. (Optional) To make changes to the default installation settings, run:

    ```bash
    tanzu package available get PACKAGE-NAME/VERSION-NUMBER --values-schema --namespace tap-install
    ```
    Where:

    - `PACKAGE-NAME` is same as step 1 above.
    - `VERSION-NUMBER` is the version of the package listed in step 1 above.

    For example:

    ```bash
    $ tanzu package available get api-portal.tanzu.vmware.com/1.0.3 --values-schema --namespace tap-install
    ```

    For more information about values schema options, see the individual product documentation.

3. Install API portal by running:

    ```console
    tanzu package install api-portal -n tap-install -p api-portal.tanzu.vmware.com -v 1.0.3
    ```

    For example:

    ```console
    $ tanzu package install api-portal -n tap-install -p api-portal.tanzu.vmware.com -v 1.0.3

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

4. For more information about API portal, see [API portal for VMware Tanzu](https://docs.pivotal.io/api-portal).


## <a id='install-services-toolkit'></a> Install Services Toolkit

To install Services Toolkit:

1. See what versions of Services Toolkit are available to install by running:

    ```console
    tanzu package available list -n tap-install services-toolkit.tanzu.vmware.com
    ```

    For example:

    ```console
    $ tanzu package available list -n tap-install services-toolkit.tanzu.vmware.com
    - Retrieving package versions for services-toolkit.tanzu.vmware.com...
      NAME                               VERSION           RELEASED-AT
      services-toolkit.tanzu.vmware.com  0.4.0-rc.2        2021-10-18T09:45:46Z
    ```

1. Install Services Toolkit by running:

    ```console
    tanzu package install services-toolkit -n tap-install -p services-toolkit.tanzu.vmware.com -v 0.4.0-rc.2
    ```

1. Verify that the package installed by running:

    ```console
    tanzu package installed get services-toolkit -n tap-install
    ```

    and checking that the `STATUS` value is `Reconcile succeeded`.

    For example:

    ```console
    $ tanzu package installed get services-toolkit -n tap-install
    | Retrieving installation details for services-toolkit...
    NAME:                    services-toolkit
    PACKAGE-NAME:            services-toolkit.tanzu.vmware.com
    PACKAGE-VERSION:         0.4.0-rc.2
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
    app-live-view          appliveview.tanzu.vmware.com                       0.3.0            Reconcile succeeded
    cloud-native-runtimes  cnrs.tanzu.vmware.com                              1.0.2            Reconcile succeeded
    convention-controller  controller.conventions.apps.tanzu.vmware.com       0.4.2            Reconcile succeeded
    grype-scanner          grype.scanning.apps.tanzu.vmware.com               1.0.0-beta.2     Reconcile succeeded
    image-policy-webhook   image-policy-webhook.signing.run.tanzu.vmware.com  1.0.0-beta.1     Reconcile succeeded
    metadata-store         scst-store.tanzu.vmware.com                        1.0.0-beta.0     Reconcile succeeded
    scan-controller        scanning.apps.tanzu.vmware.com                     1.0.0-beta.2     Reconcile succeeded
    services-toolkit       services-toolkit.tanzu.vmware.com                  0.4.0-rc.2       Reconcile succeeded
    service-bindings       service-bindings.labs.vmware.com                   0.5.0            Reconcile succeeded
    source-controller      controller.source.apps.tanzu.vmware.com            0.1.2            Reconcile succeeded
    tbs                    buildservice.tanzu.vmware.com                      1.3.0            Reconcile succeeded
    ```

## <a id='setup'></a> Set Up Developer Namespaces to Use Installed Packages

To create a `Workload` for your application using the registry credentials specified above,
run the following commands to add credentials and Role-Based Access Control (RBAC) rules to the namespace that you plan to create the `Workload` in:


1. Add read/write registry credentials to the developer namespace. Run:
    ```bash
    $ tanzu secret registry add registry-credentials --registry REGISTRY-SERVER --username REGISTRY-USERNAME --password REGISTRY-PASSWORD --namespace YOUR-NAMESPACE
    ```
    Where `YOUR-NAMESPACE` is the name you want for the developer namespace.
    For example, use `default` for the default namespace.

2. Add placeholder read secrets, a service account, and RBAC rules to the developer namespace. Run:
    ```bash
    $ cat <<EOF | kubectl -n YOUR-NAMESPACE apply -f -

    apiVersion: v1
    kind: Secret
    metadata:
      name: tap-registry
      annotations:
        secretgen.carvel.dev/image-pull-secret: ""
    type: kubernetes.io/dockerconfigjson
    data:
      .dockerconfigjson: e30K

    ---
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: service-account # use value from "Install Default Supply Chain"
    secrets:
      - name: registry-credentials
    imagePullSecrets:
      - name: registry-credentials
      - name: tap-registry

    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: Role
    metadata:
      name: kapp-permissions
      annotations:
        kapp.k14s.io/change-group: "role"
    rules:
      - apiGroups:
          - servicebinding.io
        resources: ['servicebindings']
        verbs: ['*']
      - apiGroups:
          - services.tanzu.vmware.com
        resources: ['resourceclaims']
        verbs: ['*']
      - apiGroups:
          - serving.knative.dev
        resources: ['services']
        verbs: ['*']
      - apiGroups: [""]
        resources: ['configmaps']
        verbs: ['get', 'watch', 'list', 'create', 'update', 'patch', 'delete']

    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      name: kapp-permissions
      annotations:
        kapp.k14s.io/change-rule: "upsert after upserting role"
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: Role
      name: kapp-permissions
    subjects:
      - kind: ServiceAccount
        name: service-account # use value from "Install Default Supply Chain"

    EOF
    ```
    Where `YOUR-NAMESPACE` is the namespace you want to use.
    Use `-n default` for the default namespace. We recommend using the `default` namespace, as Debug & Live Update features with the Tanzu Developer Tools for VSCode extension only work with the `default` namespace at this time.

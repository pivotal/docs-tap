# Installing individual packages

This document describes how to install individual Tanzu Application Platform packages
from the Tanzu Application Platform package repository.

Use the instructions to this page if you do not want to use a profile to install packages
or if you want to install additional packages after installing a profile.

Before you install the packages, ensure that you have completed the prerequisites, configured
and verified the cluster, accepted the EULA, and installed the Tanzu CLI with any required plugins.
For information, see [Installing Part I: Prerequisites, EULA, and CLI](install-general.md).

+ [Install cert-manager and FluxCD source controller](#install-prereqs)
+ [Install Cloud Native Runtimes](#install-cnr)
+ [Install Application Accelerator](#install-app-accelerator)
+ [Install Convention Service](#install-convention-service)
+ [Install Source Controller](#install-source-controller)
+ [Install Developer Conventions](#install-developer-conventions)
+ [Install Spring Boot Conventions](#install-spring-boot-convention)
+ [Install Application Live View](#install-app-live-view)
+ [Install Tanzu Application Platform GUI](#install-tap-gui)
+ [Install Learning Center for Tanzu Application Platform](#install-learning-center)
+ [Install Service Bindings](#install-service-bindings)
+ [Install Tanzu Build Service](#install-tbs)
+ [Install Supply Chain Choreographer](#install-scc)
+ [Install Out of the Box Templates](#install-ootb-templates)
+ [Install Default Supply Chain](#install-ootb-supply-chain-basic)
+ [Install Supply Chain Security Tools - Store](#install-scst-store)
+ [Install Supply Chain Security Tools - Sign](#install-scst-sign)
+ [Install Supply Chain Security Tools - Scan](#install-scst-scan)
+ [Install API portal](#install-api-portal)
+ [Install Services Toolkit](#install-services-toolkit)
+ [Install Tekton](#install-tekton)


## <a id='install-prereqs'></a> Install cert-manager and FluxCD source controller

cert_manager and FluxCD source controller are installed as part of all profiles. If you do not want to use a profile, install them manually.

> **Note:** In future versions both cert-manager and FluxCD source controller will be shipped as packages.

* **cert-manager**:
    * Install cert-manager by running:
        ```
        kapp deploy -y -a cert-manager -f https://github.com/jetstack/cert-manager/releases/download/v1.5.3/cert-manager.yaml
        ```
        We have verified the Tanzu Application Platform repo bundle packages installation with cert-manager version v1.5.3.

        * Verify installed cert-manager version by running:
        For example:
        ```
        kubectl get deployment cert-manager -n cert-manager -o yaml | grep 'app.kubernetes.io/version: v'
           app.kubernetes.io/version: v1.5.3
              app.kubernetes.io/version: v1.5.3
        ```
* **FluxCD source-controller**:
    Install FluxCD source-controller using the following procedure.

     1. Create the namespace `flux-system`.

        ```
        kubectl create namespace flux-system
        ```

     2. Create the `clusterrolebinding` by running:
        ```
        kubectl create clusterrolebinding default-admin \
        --clusterrole=cluster-admin \
        --serviceaccount=flux-system:default
        ```
     3. Install FluxCD Source Controller by running:
        ```
        kapp deploy -y -a flux-source-controller -n flux-system \
        -f https://github.com/fluxcd/source-controller/releases/download/v0.15.4/source-controller.crds.yaml \
        -f https://github.com/fluxcd/source-controller/releases/download/v0.15.4/source-controller.deployment.yaml
        ```
        We have verified the Tanzu Application Platform repo bundle packages installation with FluxCD source-controller version v0.15.4.


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

1. (Optional) Make changes to the default installation settings

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
          local_dns.domain            <nil>    string   Optional: Set a custom domain for CoreDNS. Only applicable when "local_dns.enable" is set to "true", "provider" is set to "local" and running on Kind.
          local_dns.enable            false    boolean  Optional: Only for when "provider" is set to "local" and running on Kind. Set to true to enable local DNS.
          pdb.enable                  true     boolean  Optional: Set to true to enable Pod Disruption Budget. If provider local is set to "local", the PDB will be disabled automatically.
          provider                    <nil>    string   Optional: Kubernetes cluster provider. To be specified if deploying CNR on a local Kubernetes cluster provider.
        ```

    1. Create a `cnr-values.yaml` using the following sample as a guide:

        Sample `cnr-values.yaml` for Cloud Native Runtimes:


        ```yaml
        ---
        # if deploying on a local cluster such as Kind. Otherwise, you can remove this field
        provider: local
        ```

        > **Note:** For most installations, you can leave the `cnr-values.yaml` empty, and use the default values.

        If you are running on a single-node cluster, like kind or minikube, set the `provider: local`
        option. This option reduces resource requirements by using a HostPort service instead of a
        LoadBalancer, and reduces the number of replicas.

        For more information about using Cloud Native Runtimes with kind, see
        [local kind configuration guide for Cloud Native Runtimes](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/1.0/tanzu-cloud-native-runtimes-1-0/GUID-local-dns.html#config-cluster).
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

    Use an empty file for `cnr-values.yaml` if you want the default installation configuration. Otherwise see the previous step to learn more about setting installation configuration values.

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

   > **Note:** This step covers configuring a namespace to run Knative services.
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

 **Prerequisite**: Cert-manager installed on the cluster. See [Install Prerequisites](#install-prereqs).

To install Convention Controller:

1. List version information for the package by running:
    ```bash
    tanzu package available list controller.conventions.apps.tanzu.vmware.com --namespace tap-install
    ```

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

    For example:
    ```
    tanzu package install convention-controller -p controller.conventions.apps.tanzu.vmware.com -v 0.4.2 -n tap-install
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

    For example:
    ```
    tanzu package installed get convention-controller -n tap-install
    Retrieving installation details for convention-controller...
    NAME:                    convention-controller
    PACKAGE-NAME:            controller.conventions.apps.tanzu.vmware.com
    PACKAGE-VERSION:         0.4.2
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    STATUS should be 'Reconcile succeeded.'

    ```bash
    kubectl get pods -n conventions-system
    ```

    For example:

    ```bash
    $ kubectl get pods -n conventions-system
    NAME                                             READY   STATUS    RESTARTS   AGE
    conventions-controller-manager-596c65f75-j9dmn   1/1     Running   0          72s
    ```

    STATUS should be 'Running.'


## <a id='install-source-controller'></a> Install Source Controller

Use the following procedure to install Source Controller.

**Prerequisite**: Fluxcd Source Controller installed on the cluster.

See [Install cert-manager and FluxCD source controller](#install-prereqs).


To install Source Controller:

1. List version information for the package by running:

    ```bash
    tanzu package available list controller.source.apps.tanzu.vmware.com --namespace tap-install
    ```

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

    For example:
    ```
    tanzu package install source-controller -p controller.source.apps.tanzu.vmware.com -v 0.1.2 -n tap-install
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

    For example:
    ```
    tanzu package installed get source-controller -n tap-install
    Retrieving installation details for sourcer-controller...
    NAME:                    sourcer-controller
    PACKAGE-NAME:            controller.source.apps.tanzu.vmware.com
    PACKAGE-VERSION:         0.1.2
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    STATUS should be 'Reconcile succeeded.'

    ```bash
    kubectl get pods -n source-system
    ```

    For example:

    ```bash
    $ kubectl get pods -n source-system
    NAME                                        READY   STATUS    RESTARTS   AGE
    source-controller-manager-f68dc7bb6-4lrn6   1/1     Running   0          45h
    ```

    STATUS should be 'Running.'

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

Before you install Application Accelerator, you must have:

- Flux SourceController installed on the cluster.
See [Install cert-manager and FluxCD source controller](#install-prereqs).

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
   see the [Application Accelerator for VMware Tanzu documentation](https://docs.vmware.com/en/Application-Accelerator-for-VMware-Tanzu/0.4/acc-docs/GUID-installation-install.html).

## <a id='install-tbs'></a> Install Tanzu Build Service

This section provides a quick-start guide for installing Tanzu Build Service as part of Tanzu Application Platform using the Tanzu CLI.

> **Note:** This procedure might not include some configurations required for your specific environment. For more advanced details on installing Tanzu Build Service, see [Installing Tanzu Build Service](https://docs.vmware.com/en/VMware-Tanzu-Build-Service/index.html).


### Prerequisites

* You have access to a Docker registry that Tanzu Build Service can use to create builder images. Approximately 5GB of registry space is required.
* Your Docker registry is accessible with username and password credentials.


### Install Tanzu Build Service using the Tanzu CLI

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
      buildservice.tanzu.vmware.com  1.3.1    2021-10-25T00:00:00Z
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
    $ tanzu package available get buildservice.tanzu.vmware.com/1.3.1 --values-schema --namespace tap-install
    ```

    For more information about values schema options, see the individual product documentation.


1. Gather the values schema by running:

    ```bash
    tanzu package available get buildservice.tanzu.vmware.com/1.3.1 --values-schema --namespace tap-install
    ```

    For example:

    ```bash
    $ tanzu package available get buildservice.tanzu.vmware.com/1.3.1 --values-schema --namespace tap-install
    | Retrieving package details for buildservice.tanzu.vmware.com/1.3.1...
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
    tanzu package install tbs -p buildservice.tanzu.vmware.com -v 1.3.1 -n tap-install -f tbs-values.yaml --poll-timeout 30m
    ```

    For example:

    ```bash
    $ tanzu package install tbs -p buildservice.tanzu.vmware.com -v 1.3.1 -n tap-install -f tbs-values.yaml --poll-timeout 30m
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
Each pre-approved supply chain creates a paved road to production and orchestrates supply chain resources. You can test, build, scan, and deploy. Developers can focus on delivering value to
users. App Operators can have peace of mind that all code in production has passed
through an approved workflow.

For example, Supply Chain Choreographer passes the results of fetching source code to the component
that knows how to build a container image from of it and then passes the container image
to a component that knows how to deploy the image.

```bash
# Install the version 0.0.7 of the `cartographer.tanzu.vmware.com`
# package. Naming the installation as `cartographer`.
#
tanzu package install cartographer \
  --namespace tap-install \
  --package-name cartographer.tanzu.vmware.com \
  --version 0.0.7
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

## <a id='install-ootb-templates'></a> Install Out of the Box Templates

The Out of the Box Templates are used by all Out of the Box Supply Chains.
There is a list of resources in each supply chain. Each resource points to an Out of the Box Template.

To install Out of the Box Templates:

1. Install the package by running:

   ```bash
    tanzu package install ootb-templates \
      --package-name ootb-templates.tanzu.vmware.com \
      --version 0.3.0-build.5 \
      --namespace tap-install
    ```


## <a id='install-ootb-supply-chain-basic'></a> Install default Supply Chain

Install the default Supply Chain, called Out of the Box Supply Chain Basic, by running:

1. Gather the values schema:

    ```console
    tanzu package available get ootb-supply-chain-basic.tanzu.vmware.com/0.3.0-build.5 --values-schema -n tap-install
    ```

    For example:

    ```console
    $ tanzu package available get ootb-supply-chain-basic.tanzu.vmware.com/0.3.0-build.5 --values-schema -n tap-install
    | Retrieving package details for ootb-supply-chain-basic.tanzu.vmware.com/0.3.0-build.5...

    KEY                  DEFAULT          TYPE    DESCRIPTION
    registry.repository  <nil>            string  Name of the repository in the image registry server where the application images from the workloads should be pushed to (required).
    registry.server      index.docker.io  string  Name of the registry server where application images should be pushed to.
    service_account      default          string  Name of the service account in the namespace where the Workload is submitted to utilize for providing registry credentials to Tanzu Build Service (TBS) Image objects as well as deploying the application.
    cluster_builder      default          string  Name of the Tanzu Build Service (TBS) ClusterBuilder to use by default on image objects managed by the supply chain.
    ```


1. Create a `ootb-supply-chain-values.yaml` using the following sample as a guide.

    Sample `ootb-supply-chain-values.yaml` for the default Supply Chain:

    ```yaml
    ---
    registry:
      server: REGISTRY-SERVER
      repository: REGISTRY-REPOSITORY
    service_account: default
    ```

1. Install the package by running:

     ```bash
    tanzu package install ootb-supply-chain-basic \
      --package-name ootb-supply-chain-basic.tanzu.vmware.com \
      --version 0.3.0-build.5 \
      --namespace tap-install \
      --values-file ootb-supply-chain-values.yaml
    ```

> **Note:** The `default` service account and required secrets are created in
[Set Up Developer Namespaces to Use Installed Packages](#setup).

> **Note:** Only one supply chain should be installed in the cluster at a time.

## <a id='install-developer-conventions'></a> Install Developer Conventions

To install developer conventions:

**Prerequisite**: Convention Service installed on the cluster. See [Install Convention Service](#install-convention-service).

1. Get the exact name and version information for the Developer Conventions package to be installed by running:

    ```bash
    tanzu package available list developer-conventions.tanzu.vmware.com --namespace tap-install
    ```

    For example:
    ```bash
    $ tanzu package available list developer-conventions.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for developer-conventions.tanzu.vmware.com
      NAME                                    VERSION        RELEASED-AT
      developer-conventions.tanzu.vmware.com  0.3.0          2021-10-19T00:00:00Z
    ```

1. Install the package by running:

    ```bash
    tanzu package install developer-conventions \
      --package-name developer-conventions.tanzu.vmware.com \
      --version 0.3.0 \
      --namespace tap-install
    ```

1. Verify the package install by running:

    ```bash
    tanzu package installed get developer-conventions --namespace tap-install
    ```

    For example:
    ```bash
    tanzu package installed get developer-conventions -n tap-install
    | Retrieving installation details for developer-conventions...
    NAME:                    developer-conventions
    PACKAGE-NAME:            developer-conventions.tanzu.vmware.com
    PACKAGE-VERSION:         0.3.0
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    STATUS should be 'Reconcile succeeded.'


## <a id='install-spring-boot-convention'></a> Install Spring Boot Conventions

To install Spring Boot conventions:

**Prerequisite**: Convention Service installed on the cluster. See [Install Convention Service](#install-prereqs).

1. Get the exact name and version information for the Spring Boot conventions package to be installed by running:

    ```console
    tanzu package available list spring-boot-conventions.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list spring-boot-conventions.tanzu.vmware.com --namespace tap-install
    / Retrieving package versions for spring-boot-conventions.tanzu.vmware.com...
      NAME                                       VERSION   RELEASED-AT
      ...
      spring-boot-conventions.tanzu.vmware.com   0.1.2     2021-10-28T00:00:00Z
      ...
    ```

1. Install the package by running:

    ```bash
    tanzu package install spring-boot-conventions \
      --package-name spring-boot-conventions.tanzu.vmware.com \
      --version 0.1.2 \
      --namespace tap-install
    ```

1. Verify the package install by running:

    ```bash
    tanzu package installed get spring-boot-conventions --namespace tap-install
    ```

    For example:
    ```bash
    tanzu package installed get spring-boot-conventions -n tap-install
    | Retrieving installation details for spring-boot-conventions...
    NAME:                    spring-boot-conventions
    PACKAGE-NAME:            spring-boot-conventions.tanzu.vmware.com
    PACKAGE-VERSION:         0.1.2
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    STATUS should be 'Reconcile succeeded.'



## <a id="install-app-live-view"></a>Install Application Live View

To install Application Live View:

**Prerequisite**: Convention Service installed on the cluster. See [Install Convention Service](#install-convention-service).

1. List version information for the package by running:

    ```bash
    tanzu package available list appliveview.tanzu.vmware.com --namespace tap-install
    ```

     For example:

    ```bash
    $ tanzu package available list appliveview.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for appliveview.tanzu.vmware.com...
      NAME                          VERSION        RELEASED-AT
      appliveview.tanzu.vmware.com  1.0.0-build.1  2021-11-24T00:00:00Z
    ```

1. (Optional) To make changes to the default installation settings, run:

    ```bash
    tanzu package available get appliveview.tanzu.vmware.com/1.0.0-build.1 --values-schema --namespace tap-install
    ```

    For example:

    ```bash
    $ tanzu package available get appliveview.tanzu.vmware.com/1.0.0-build.1 --values-schema --namespace tap-install
    - Retrieving package details for appliveview.tanzu.vmware.com/1.0.0-build.1...
      KEY                   DEFAULT        TYPE    DESCRIPTION
      service_type          ClusterIP      string  The service type for the Application Live View server can be LoadBalancer, NodePort, or ClusterIP
    ```

    For more information about values schema options, see the individual product documentation.

1. Gather the values schema.

1. Create a `app-live-view-values.yaml` using the following sample as a guide:

   ```yaml
   ---
   service_type: ClusterIP
   ```

   Where:

   - `service_type` is the Kubernetes service type for the Application Live View server.
   This can be LoadBalancer, NodePort, or ClusterIP.

   The application live view server and its components are deployed in `app-live-view` namespace by default. The connector is deployed as a `DaemonSet` and there is one connector instance per node in the Kubernetes cluster. This instance is responsible for observing all the apps running on that node.

1. Install the package by running:

    ```console
    tanzu package install app-live-view -p appliveview.tanzu.vmware.com -v 1.0.0-build.1 -n tap-install -f app-live-view-values.yaml
    ```

    For example:

    ```console
    $ tanzu package install app-live-view -p appliveview.tanzu.vmware.com -v 1.0.0-build.1 -n tap-install -f app-live-view-values.yaml
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
    see the [Application Live View documentation](https://docs.vmware.com/en/Application-Live-View-for-VMware-Tanzu/1.0/docs/GUID-index.html).

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
    PACKAGE-VERSION:         1.0.0-build.1
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```
    STATUS should be `Reconcile succeeded`.


The Application Live View UI plugin is part of Tanzu Application Platform GUI. To access the Application Live View UI, 
   see the [ Application Live View in Tanzu Application Platform GUI ](https://docs-staging.vmware.com/en/Tanzu-Application-Platform/0.4/tap/GUID-tap-gui-plugins-app-live-view.html).



## <a id='install-tap-gui'></a> Install Tanzu Application Platform GUI

To install Tanzu Application Platform GUI, see the following sections.

### Prerequisites in addition to Tanzu Application Platform requirements

**Required**

- Git repository for the software catalogs and a token allowing read access.
Supported Git infrastructure includes:
    - GitHub
    - GitLab
    - Azure DevOps
- Blank Software Catalog from the Tanzu Application section of Tanzu Network

**Optional**

- Tanzu Application Platform tools: Tanzu Application Platform GUI has plugins for the
following Tanzu Application Platform tools.
If you plan on running workloads with these capabilities, you need these tools installed alongside
Tanzu Application Platform GUI.
If you choose not to deploy workloads with these tools, the GUI shows menu options that you cannot
select.
    - Tanzu Cloud Native Runtimes
    - Tanzu App Live View
- Data cache: Your software catalog is stored on Git infrastructure, as mentioned in the
required prerequisites. However, you also have the option to use a PostgreSQL database to
cache this information. If you do not specify any values here, a SQLite in-memory database is used
instead.
    - PostgreSQL database and connection information
- Authentication:
    - OIDC Identity Provider connection information
- Customer-developed documentation:
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
      tap-gui.tanzu.vmware.com  0.3.0-rc.4  2021-10-28T13:14:23Z
    ```

2. (Optional) To make changes to the default installation settings, run:

    ```bash
    tanzu package available get tap-gui.tanzu.vmware.com/0.3.0-rc.4 --values-schema --namespace tap-install
    ```

    For more information about values schema options, see the individual product documentation.


1. Create `tap-gui-values.yaml` using the following example code, replacing all `<PLACEHOLDERS>`
with your relevant values. The meanings of some placeholders are explained in this example:

    ```yaml
    namespace: tap-gui
    service_type: <SERVICE-TYPE>
    app_config:
      app:
        baseUrl: https://<EXTERNAL-IP>:<PORT>
      integrations:
        gitlab: # Other integrations available
          - host: <GITLAB-HOST>
            apiBaseUrl: https://<GITLAB-URL>/api/v4
            token: <GITLAB-TOKEN>
      catalog:
        locations:
          - type: url
            target: https://<GIT-CATALOG-URL>/catalog-info.yaml
      backend:
          baseUrl: https://<EXTERNAL-IP>:<PORT>
          cors:
              origin: https://<EXTERNAL-IP>:<PORT>
      # database: # Only needed if you intend to support with an existing PostgreSQL database. The catalog is still refreshed from Git.
      #     client: pg
      #      connection:
      #        host: <PGSQL-HOST>
      #        port: <PGSQL-PORT>
      #        user: <PGSQL-USER>
      #        password: <PGSQL-PWD>
      #        ssl: {rejectUnauthorized: false} # May be needed if using self-signed certs

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
      #        metadataUrl: <AUTH-OIDC-METADATA-URL> # metadataUrl is a json file with generic oidc provider config. It contains the authorizationUrl and tokenUrl. These values are read from the metadataUrl file by Backstage and so they do not need to be specified explicitly here. To support OIDC authentication, you must create an OAuth client in your upstream provider, when setting up the client make sure to include the authorized redirect URI as: https://[BASE_URL]/api/auth/oidc/handler/frame
      #        clientId: <AUTH-OIDC-CLIENT-ID>
      #        clientSecret: <AUTH-OIDC-CLIENT-SECRET>
      #        tokenSignedResponseAlg: <AUTH-OIDC-TOKEN-SIGNED-RESPONSE-ALG> # default='RS256'
      #        scope: <AUTH-OIDC-SCOPE> # default='openid profile email'
      #        prompt: <TYPE> # default=none (allowed values: auto, none, consent, login)      
    ```
    Where:

    - `<SERVICE-TYPE>` is your inbound traffic mechanism: LoadBalancer or Ingress.
    - `<EXTERNAL-IP>:<PORT>` is your Ingress hostname or LoadBalancer information.
       If you are using a load balancer that is dynamically provisioned by the cloud provider,
       leave this value blank initially and, after the install is complete,
       run a subsequent `tanzu package installed update`.
    - `<GIT-CATALOG-URL>` is the path to the `catalog-info.yaml` catalog definition file from either the included  Blank catalog (provided as an additional download named "Blank Tanzu Application Platform GUI Catalog") or a Backstage-compliant catalog that you've already built and posted on the Git infrastucture that you specified in the Integration section.

    > **Note:** The `app_config` section follows the same configuration model that Backstage uses.
    For more information, see the [Backstage documentation](https://backstage.io/docs/conf/).
    Detailed configuration of the OIDC auth capabilities are in this [Backstage OAuth documentation](https://backstage.io/docs/auth/oauth).

    > **Note:** The `integrations` section uses GitLab. If you want additional integrations, see the
    format in this [Backstage integration documentation](https://backstage.io/docs/integrations/).

1. Install the package by running:

    ```console
    tanzu package install tap-gui \
     --package-name tap-gui.tanzu.vmware.com \
     --version 0.3.0-rc.4 -n tap-install \
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
    PACKAGE-VERSION:         0.3.0-rc.4
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```
    `STATUS` should be `Reconcile succeeded`.

1. To access Tanzu Application Platform GUI, use the service you exposed in the `service_type`
field in the values file.


## <a id='install-learning-center'></a> Install Learning Center for Tanzu Application Platform

To install Tanzu Learning Center, see the following sections.

### Prerequisites for Learning Center
**Required**

- [Tanzu Application Platform Prerequisites](install-general.md#prereqs)

- The cluster must have an ingress router configured. Only a basic deployment of the ingress controller is usually required.

- The operator when deploying instances of the workshop environments needs to be able to expose them via an external URL for access. For the custom domain you are using, DNS must have been configured with a wildcard domain to forward all requests for sub domains of the custom domain, to the ingress router of the Kubernetes cluster

- By default the workshop portal and workshop sessions will be accessible over HTTP connections. If you wish to use secure HTTPS connections, you must have access to a wildcard SSL certificate for the domain under which you wish to host the workshops. You cannot use a self signed certificate.

- Any ingress routes created will use the default ingress class. If you have multiple ingress class types available, and you need to override which is used.

### Procedure to install Learning Center

To install Learning Center:

1. List version information for the package by running:

    ```shell
    tanzu package available list learningcenter.tanzu.vmware.com --namespace tap-install
    ```

    Example output:

    ```shell
     NAME                             VERSION        RELEASED-AT
     learningcenter.tanzu.vmware.com  1.0.14-build.1 2021-10-22 17:02:13 -0400 EDT
    ```

1. (Optional) See all the configurable parameters on this package by running:

    ```shell
    tanzu package available get learningcenter.tanzu.vmware.com/1.0.14-build.1 --values-schema -- namespace tap-install
    ```

1. Create a config file named `learning-center-config.yaml`.

1. Add the parameter `ingressDomain` to `learning-center-config.yaml`, as in this example:

    ```yaml
    ingressDomain: YOUR-INGRESS-DOMAIN
    ```

    Where `YOUR-INGRESS-DOMAIN` is the domain name for your Kubernetes cluster.

    When deploying workshop environment instances, the operator must be able to expose the instances
    through an external URL. This access is needed to discover the domain name that can be used as a
    suffix to hostnames for instances.

    For the custom domain you are using, DNS must have been configured with a wildcard domain to
    forward all requests for subdomains of the custom domain to the ingress router of the
    Kubernetes cluster.

    If you are running Kubernetes on your local machine using a system such as `minikube`, and you
    don't have a custom domain name that maps to the IP for the cluster, you can use a `nip.io`
    address.
    For example, if `minikube ip` returns `192.168.64.1`, you can use the `192.168.64.1.nip.io`
    domain.
    You cannot use an address of form `127.0.0.1.nip.io` or `subdomain.localhost`. This will cause a
    failure. Internal services needing to connect to each other will connect to themselves instead,
    because the address would resolve to the host loopback address of `127.0.0.1`.

1. Add the `ingressSecret` to `learning-center-config.yaml`, as in this example:

    ```yaml
    ingressSecret:
        certificate: MIIC2DCCAcCgAwIBAgIBATANBgkqh ...
        privateKey: MIIEpgIBAAKCAQEA7yn3bRHQ5FHMQ ...
    ```

    If you already have a TLS secret, you can copy it to the `educates` namespace or the one you
    defined, and use the `secretName` property as in this exmaple:

    ```yaml
    ingressSecret:
     secretName: workshops.example.com-tls
    ```

    By default the workshop portal and workshop sessions are accessible over HTTP connections.

    To use secure HTTPS connections, you must have access to a wildcard SSL certificate for the
    domain under which you want to host the workshops. You cannot use a self-signed certificate.

    Wildcard certificates can be created using letsencrypt <https://letsencrypt.org/>_.
    After you have the certificate, you can define the `certificate` and `privateKey` properties
    under the `ingressSecret` property to specify the certificate on the configuration yaml.

1. Any ingress routes created use the default ingress class.
If you have multiple ingress class types available, and you need to override which is used, define
the `ingressClass` property in `learning-center-config.yaml` as in this example:

    ```yaml
    ingressClass: contour
    ```

    If you have multiple ingress controllers, ensure you select the correct one.
    For instance, Cloud Native Runtimes (CNR) deploys two ingress controllers.
    In this case you use `contour-external` for Learning Center as in this example:

    ```yaml
    ingressClass: contour-external
    ```

1. Install Learning Center Operator by running:

    ```shell
    tanzu package install learning-center --package-name learningcenter.tanzu.vmware.com --version 1.0.14-build.1 -f learning-center-config.yaml
    ```

    The command above will create a default namespace in your Kubernetes cluster called `educates`,
    and the operator along with any required namespaced resources is created in it.
    A set of custom resource definitions and a global cluster role binding are also created.
    The list of resources you see being created are:

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

    You can check that the operator deployed successfully by running:

    ```shell
    kubectl get all -n educates
    ```

    The Pod for the operator should be marked as running.

### Procedure to install the Self-Guided Tour Training Portal and Workshop

To install the Self-Guided Tour Training Portal and Workshop:

1. Make sure you have the workshop package installed by running:

   ```console
   tanzu package available list workshops.learningcenter.tanzu.vmware.com --namespace tap-install
   ```

2. Install the Learning Center Training Portal with the Self Guided Tour workshop by running:

   ```shell
   tanzu package install learning-center-workshop --package-name workshops.learningcenter.tanzu.vmware.com --version 1.0.7-build.1 -n tap-install
   ```

3. Check the Training Portals available in your environment by running:

    ```shell
    kubectl get trainingportals
    ```

    Example output:

    ```shell
    NAME                 URL                                                ADMINUSERNAME   ADMINPASSWORD                      STATUS
    educates-tutorials   http://educates-tutorials.example.com   educates        QGBaM4CF01toPiZLW5NrXTcIYSpw2UJK   Running
    ```


## <a id='install-service-bindings'></a> Install Service Bindings

Use the following procedure to install Service Bindings:

1. List version information for the package by running:

    ```bash
    tanzu package available list service-bindings.labs.vmware.com --namespace tap-install
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

1. Install the package by running:

    ```bash
    tanzu package install service-bindings -p service-bindings.labs.vmware.com -v 0.5.0 -n tap-install
    ```

    Example output:

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

    Example output:

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

**Prerequisite**: `cert-manager` installed on the cluster. See [Install Prerequisites](#install-prereqs).

Before installing, see [Deployment Details and Configuration](scst-store/deployment_details.md) to review what resources will be deployed.

To install Supply Chain Security Tools - Store:

1. The deployment assumes the user has set up the k8s cluster to provision persistent volumes on demand. Make sure a default storage class is be available in your cluster. Check whether default storage class is set in your cluster by running:

    ```console
    kubect get storageClass
    ```

    For example:

    ```console
    $ kubectl get storageClass
    NAME                 PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
    standard (default)   rancher.io/local-path   Delete          WaitForFirstConsumer   false                  7s
    ```

1. List version information for the package by running:

    ```bash
    tanzu package available list scst-store.tanzu.vmware.com --namespace tap-install
    ```
    For example:

    ```bash
    $ tanzu package available list scst-store.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for scst-store.tanzu.vmware.com...
      NAME                         VERSION       RELEASED-AT
      scst-store.tanzu.vmware.com  1.0.0-beta.2
    ```

1. (Optional) List out all the available deployment configuration options:

    ```sh
    tanzu package available get scst-store.tanzu.vmware.com/1.0.0-beta.2 --values-schema -n tap-install
    ```

    For example:

    ```console
    $ tanzu package available get scst-store.tanzu.vmware.com/1.0.0-beta.2 --values-schema -n tap-install
    | Retrieving package details for scst-store.tanzu.vmware.com/1.0.0-beta.2...
      KEY                               DEFAULT              TYPE     DESCRIPTION
      app_service_type                  LoadBalancer         string   The type of service to use for the metadata app service. This can be set to 'NodePort' or 'LoadBalancer'.
      auth_proxy_host                   0.0.0.0              string   The binding ip address of the kube-rbac-proxy sidecar
      db_host                           metadata-store-db    string   The address to the postgres database host that the metdata-store app uses to connect. The default is set to metadata-store-db which is the postgres service name. Changing this does not change the postgres service name
      db_replicas                       1                    integer  The number of replicas for the metadata-store-db
      db_sslmode                        verify-full          string   Determines the security connection between API server and Postgres database. This can be set to 'verify-ca' or 'verify-full'
      pg_limit_memory                   4Gi                  string   Memory limit for postgres container in metadata-store-db deployment
      app_req_cpu                       100m                 string   CPU request for metadata-store-app container
      app_limit_memory                  512Mi                string   Memory limit for metadata-store-app container
      app_req_memory                    128Mi                string   Memory request for metadata-store-app container
      auth_proxy_port                   8443                 integer  The external port address of the of the kube-rbac-proxy sidecar
      db_name                           metadata-store       string   The name of the database to use.
      db_port                           5432                 string   The database port to use. This is the port to use when connecting to the database pod.
      api_port                          9443                 integer  The internal port for the metadata app api endpoint. This will be used by the kube-rbac-proxy sidecar.
      app_limit_cpu                     250m                 string   CPU limit for metadata-store-app container
      app_replicas                      1                    integer  The number of replicas for the metadata-store-app
      db_user                           metadata-store-user  string   The database user to create and use for updating and querying. The metadata postgres section create this user. The metadata api server uses this username to connect to the database.
      pg_req_memory                     1Gi                  string   Memory request for postgres container in metadata-store-db deployment
      priority_class_name                                    string   If specified, this value is the name of the desired PriorityClass for the metadata-store-db deployment
      use_cert_manager                  true                 string   Cert manager is required to be installed to use this flag. When true, this creates certificates object to be signed by cert manager for the API server and Postgres database. If false, the certificate object have to be provided by the user.
      api_host                          localhost            string   The internal hostname for the metadata api endpoint. This will be used by the kube-rbac-proxy sidecar.
      db_password                       <auto-generated>     string   The database user password. If not specified, the password will be auto-generated.
      storage_class_name                                     string   The storage class name of the persistent volume used by Postgres database for storing data. The default value will use the default class name defined on the cluster.
      database_request_storage          10Gi                 string   The storage requested of the persistent volume used by Postgres database for storing data.
      add_default_rw_service_account    true                 string   Adds a read-write service account which can be used to obtain access token to use metadata-store CLI
    ```

1. **(Optional)** If you want to modify one of the above deployment configurations, you can created a configuration yaml with the custom configuration values you want. For example, if your environment does not support `LoadBalancer`, and you want to use `NodePort`, then create a `scst-store-values.yaml` and configure the `app_service_type` property. This file will be used in the next step.

    ```yaml
    ---
    app_service_type: "NodePort"
    ```

    See [Deployment Details and Configuration](scst-store/deployment_details.md#configuration) for more detailed descriptions of configuration options. 

1. Install the package by running:

    ```sh
    tanzu package install metadata-store \
      --package-name scst-store.tanzu.vmware.com \
      --version 1.0.0-beta.2 \
      --namespace tap-install \
      --values-file scst-store-values.yaml
    ```

    The flag `--values-file` is optional, and used only if you want to customize the deployment configuration. For example:

    ```sh
    $ tanzu package install metadata-store \
      --package-name scst-store.tanzu.vmware.com \
      --version 1.0.0-beta.2 \
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

> **Caution**:
>
> **This component will reject pods if the webhook fails or is misconfigured**.
> If the webhook is preventing the cluster from functioning,
> see [Supply Chain Security Tools - Sign Known Issues](scst-sign/known_issues.md#sign-known-issues-pods-not-admitted)
> for recovery steps.

### Prerequisites

During configuration for this component we will ask you to provide a cosign
public key to use to validate signed images. We will provide an example cosign
public key that will be able to validate an image from the public cosign
registry. If you wish to provide your own key and images you can follow the
[cosign quick start guide](https://github.com/sigstore/cosign#quick-start) to
generate your own keys and sign an image.

### Installation

To install Supply Chain Security Tools - Sign:

1. List version information for the package by running:

    ```shell
    tanzu package available list image-policy-webhook.signing.run.tanzu.vmware.com --namespace tap-install
    ```
    For example:

    ```shell
    $ tanzu package available list image-policy-webhook.signing.run.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for image-policy-webhook.signing.run.tanzu.vmware.com...
      NAME                                               VERSION         RELEASED-AT
      image-policy-webhook.signing.run.tanzu.vmware.com  1.0.0-beta.1    2021-10-25T00:00:00Z
      image-policy-webhook.signing.run.tanzu.vmware.com  1.0.0-beta.2    2021-11-29T00:00:00Z
    ```

1. (Optional) To make changes to the default installation settings, run:
    ```shell
    tanzu package available get image-policy-webhook.signing.run.tanzu.vmware.com/1.0.0-beta.2 --values-schema --namespace tap-install
    ```
    For example:

    ```shell
    $ tanzu package available get image-policy-webhook.signing.run.tanzu.vmware.com/1.0.0-beta.2 --values-schema --namespace tap-install
    | Retrieving package details for image-policy-webhook.signing.run.tanzu.vmware.com/1.0.0-beta.2...
      KEY                     DEFAULT  TYPE     DESCRIPTION
      allow_unmatched_images  false    boolean  Feature flag for enabling admission of images that do not match
                                                any patterns in the image policy configuration.
                                                Set to true to allow images that do not match any patterns into
                                                the cluster with a warning.
      quota.pod_number        <nil>    string   The maximum number of Image Policy Webhook Pods allowed to be
                                                created with the priority class system-cluster-critical. This
                                                value must be enclosed in quotes (""). If this value is not
                                                specified then the default value of 5 is used.
      replicas                <nil>    integer  The number of replicas to be created for the Image Policy
                                                Webhook. This value must not be enclosed in quotes. If this
                                                value is not specified then the default value of 1 is used.
    ```

1. Create a file named `scst-sign-values.yaml` and add the settings you
  would like to customize:

    - `allow_unmatched_images`:
        * **For non-production environments**: To warn the user when images
          do not match any pattern in the policy, but still allow them into
          the cluster, set `allow_unmatched_images` to `true`.
            ```yaml
            ---
            allow_unmatched_images: true
            ```
        * **For production environments**: To deny images that match no patterns in the policy set `allow_unmatched_images` to `false`.
            ```yaml
            ---
            allow_unmatched_images: false
            ```

          > **Note**: For a quicker installation process VMware recommends that
          > you set `allow_unmatched_images` to `true` initially.
          > This setting means that the webhook will allow unsigned images to
          > run if the image does not match any pattern in the policy.
          > To promote to a production environment VMware recommends that you
          > re-install the webhook with `allow_unmatched_images` set to `false`.

    - `quota.pod_number`:
      This setting is the maximum amount of pods that will be allowed in the
      `image-policy-system` namespace with the `system-cluster-critical`
      priority class. This priority class is added to the pods to prevent
      preemption of this component's pods in case of node pressure.

      The default value for this property is 5. If your use case requires
      more than 5 pods deployed of this component adjust this value to
      allow the number of replicas you intend to deploy.

    - `replicas`:
      This settings controls the default amount of replicas that will get deployed by this
      component. The default value is 1.

      * **For production environments**: VMware recommends you increase the
        amount of replicas to 3 to ensure availability of the
        component for better admission performance.

1. Install the package:

    ```shell
    tanzu package install image-policy-webhook \
      --package-name image-policy-webhook.signing.run.tanzu.vmware.com \
      --version 1.0.0-beta.2 \
      --namespace tap-install \
      --values-file scst-sign-values.yaml
    ```

    For example:

    ```shell
    $ tanzu package install image-policy-webhook \
        --package-name image-policy-webhook.signing.run.tanzu.vmware.com \
        --version 1.0.0-beta.2 \
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

   After you run the commands above the webhook will be running.

   > **Note**: This component requires extra configuration steps to work properly. See
   > [Configuring Supply Chain Security Tools - Sign](scst-sign/configuring.md)
   > for instructions on how to apply the required configuration.

## <a id='install-scst-scan'></a> Install Supply Chain Security Tools - Scan

**Prerequisite**: [Supply Chain Security Tools - Store](#install-scst-store) must be installed on the cluster for Scan Results to persist. Supply Chain Security Tools - Scan can be installed without Supply Chain Security Tools - Store already installed. In this case, skip creating a values file. Once Supply Chain Security Tools - Store is installed, the Supply Chain Security Tools - Scan values file must be updated.

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
      metadataStore.url                            string  Url of the Insight Metadata Store deployed in the cluster
      namespace                  scan-link-system  string  Deployment namespace for the Scan Controller
      resources.limits.cpu       250m              <nil>   Limits describes the maximum amount of cpu resources allowed.
      resources.limits.memory    256Mi             <nil>   Limits describes the maximum amount of memory resources allowed.
      resources.requests.cpu     100m              <nil>   Requests describes the minimum amount of cpu resources required.
      resources.requests.memory  128Mi             <nil>   Requests describes the minimum amount of memory resources required.
      metadataStore.caSecret                       string  Name of deployed Secret with key ca.crt holding the CA Cert of the Insight Metadata Store deployed in the cluster
      metadataStore.clusterRole                    string  Name of the deployed ClusterRole for read/write access to the Insight Metadata Store deployed in the cluster
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

    ```console
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
    metadataStore.url: https://metadata-store-app.metadata-store.svc.cluster.local:8443
    metadataStore.caSecret: metadata-store-ca
    metadataStore.clusterRole: metadata-store-read-write
    ```

    The following shows how to determine what these values are:

    The `metadataStore.url` value can be determined by:

    ```bash
    kubectl get service -n metadata-store -o name |
      grep app |
      xargs kubectl -n metadata-store get -o jsonpath='{.spec.ports[].name}{"://"}{.metadata.name}{"."}{.metadata.namespace}{".svc.cluster.local:"}{.spec.ports[].port}'
    ```

    The `metadataStore.caSecret` value is the name of the TLS Certificate `Secret` created above.

    The `metadataStore.clusterRole` value is the name of the `ClusterRole` created above.

4. If [Supply Chain Security Tools - Store](#install-scst-store) is installed, install the package by running (omit the `--values-file` line if installing without [Supply Chain Security Tools - Store](#install-scst-store) already installed):

    ```console
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
      targetImagePullSecret      <EMPTY>  string  Reference to the secret used for pulling images from private registry.
      targetSourceSshSecret      <EMPTY>  string  Reference to the secret containing SSH credentials for cloning private repositories.
    ```

    > **Note:** If you want to use a namespace other than the default namespace, then ensure that the namespace exists before you install.
If the namespace does not exist, then the Grype Scanner installation fails.

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
      services-toolkit.tanzu.vmware.com  0.5.0-rc.2        2021-10-18T09:45:46Z
    ```

1. Install Services Toolkit by running:

    ```console
    tanzu package install services-toolkit -n tap-install -p services-toolkit.tanzu.vmware.com -v 0.5.0-rc.2
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
    PACKAGE-VERSION:         0.5.0-rc.2
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    STATUS should be `Reconcile succeeded`.


## <a id='verify'></a> Verify the installed packages

Use the following procedure to verify that the packages are installed.

1. List the installed packages by running:

    ```bash
    tanzu package installed list --namespace tap-install
    ```

    For example:

    ```bash
    $ tanzu package installed list --namespace tap-install
    \ Retrieving installed packages...
    NAME                     PACKAGE-NAME                                       PACKAGE-VERSION  STATUS
    api-portal               api-portal.tanzu.vmware.com                        1.0.3            Reconcile succeeded
    app-accelerator          accelerator.apps.tanzu.vmware.com                  0.4.0            Reconcile succeeded
    app-live-view            appliveview.tanzu.vmware.com                       1.0.0-build.1     Reconcile succeeded
    cartographer             cartographer.tanzu.vmware.com                      0.0.7            Reconcile succeeded
    cloud-native-runtimes    cnrs.tanzu.vmware.com                              1.0.3            Reconcile succeeded
    convention-controller    controller.conventions.apps.tanzu.vmware.com       0.4.2            Reconcile succeeded
    developer-conventions    developer-conventions.tanzu.vmware.com             0.3.0-build.1    Reconcile succeeded
    grype-scanner            grype.scanning.apps.tanzu.vmware.com               1.0.0-beta.2     Reconcile succeeded
    image-policy-webhook     image-policy-webhook.signing.run.tanzu.vmware.com  1.0.0-beta.1     Reconcile succeeded
    metadata-store           scst-store.tanzu.vmware.com                        1.0.0-beta.1     Reconcile succeeded
    ootb-supply-chain-basic  ootb-supply-chain-basic.tanzu.vmware.com           0.3.0-build.5    Reconcile succeeded
    ootb-templates           ootb-templates.tanzu.vmware.com                    0.3.0-build.5    Reconcile succeeded
    scan-controller          scanning.apps.tanzu.vmware.com                     1.0.0-beta.2     Reconcile succeeded
    service-bindings         service-bindings.labs.vmware.com                   0.5.0            Reconcile succeeded
    services-toolkit         services-toolkit.tanzu.vmware.com                  0.4.0            Reconcile succeeded
    source-controller        controller.source.apps.tanzu.vmware.com            0.1.2            Reconcile succeeded
    tap-gui                  tap-gui.tanzu.vmware.com                           0.3.0-rc.4       Reconcile succeeded
    tbs                      buildservice.tanzu.vmware.com                      1.3.1            Reconcile succeeded
    ```

## <a id='setup'></a> Set Up Developer Namespaces to Use Installed Packages

To create a `Workload` for your application using the registry credentials specified above,
run the following commands to add credentials and Role-Based Access Control (RBAC) rules to the namespace that you plan to create the `Workload` in:


1. Add read/write registry credentials to the developer namespace. Run:

    ```bash
    tanzu secret registry add registry-credentials --server REGISTRY-SERVER --username REGISTRY-USERNAME --password REGISTRY-PASSWORD --namespace YOUR-NAMESPACE
    ```
    Where:

    * `YOUR-NAMESPACE` is the name that you want to use for the developer namespace. For example, use `default` for the default namespace.
    * `REGISTRY-SERVER` is the URL of the registry. For Dockerhub this must be `https://index.docker.io/v1/`. Specifically it must have the leading `https://`, the `v1` path, and the trailing `/`. For GCR this is `gcr.io`.
    

2. Add placeholder read secrets, a service account, and RBAC rules to the developer namespace. Run:

    ```console
    cat <<EOF | kubectl -n YOUR-NAMESPACE apply -f -

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
      name: default
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
          - services.apps.tanzu.vmware.com
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
        name: default

    EOF
    ```


## <a id='install-tekton'></a> Install Tekton

The `testing` out of the box supply chain uses Tekton to run tests defined by
developers before you produce a container image for the source code, preventing
code that fails tests from being promoted to deployment.

To install Tekton with `kapp`, run:

```bash
kapp deploy --yes -a tekton \
  -f https://storage.googleapis.com/tekton-releases/pipeline/previous/v0.28.0/release.yaml
```

For more details on Tekton, see the [Tekton documentation](https://tekton.dev/docs/) and the
[github repository](https://github.com/tektoncd/pipeline).  

You can also view the Tekton [tutorial](https://github.com/tektoncd/pipeline/blob/main/docs/tutorial.md) and
[getting started guide](https://tekton.dev/docs/getting-started/).

Note: In future versions, Tekton will be shipped as a package.

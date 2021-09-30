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
    ```
    kubectl create ns tap-install
    ```

    This namespace is to keep the objects grouped together logically.

2. Create a imagepullsecret:
    ```
    tanzu imagepullsecret add tap-registry \
      --username TANZU-NET-USER --password TANZU-NET-PASSWORD \
      --registry registry.tanzu.vmware.com \
      --export-to-all-namespaces --namespace tap-install
    ```

    Where `TANZU-NET-USER` and `TANZU-NET-PASSWORD` are your credentials for Tanzu Network.

3. Add Tanzu Application Platform package repository to the cluster by running:

    ```
    tanzu package repository add tanzu-tap-repository --url TAP-REPO-IMGPKG --namespace tap-install
    ```

    Where TAP-REPO-IMGPKG is the Tanzu Application Platform repo bundle artifact reference.

    For example:
    ```
    $ tanzu package repository add tanzu-tap-repository \
        --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:0.2.0 \
        --namespace tap-install
    \ Adding package repository 'tanzu-tap-repository'... 

    Added package repository 'tanzu-tap-repository'
    ```

5. Get status of the Tanzu Application Platform package repository, and ensure the status updates to `Reconcile succeeded` by running:

    ```
    tanzu package repository list --namespace tap-install
    ```
    For example:
    ```
    $ tanzu package repository list --namespace tap-install
    - Retrieving repositories...
      NAME                  REPOSITORY                                                         STATUS               DETAILS
      tanzu-tap-repository  registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:0.2.0  Reconcile succeeded
    ```

6. List the available packages by running:

    ```
    tanzu package available list --namespace tap-install
    ```
    For example:
    ```
    $ tanzu package available list --namespace tap-install
    / Retrieving available packages...
      NAME                               DISPLAY-NAME                              SHORT-DESCRIPTION
      accelerator.apps.tanzu.vmware.com  Application Accelerator for VMware Tanzu  Used to create new projects and configurations.                                      
      appliveview.tanzu.vmware.com       Application Live View for VMware Tanzu    App for monitoring and troubleshooting running apps                                  
      cnrs.tanzu.vmware.com              Cloud Native Runtimes                     Cloud Native Runtimes is a serverless runtime based on Knative
    ```

7. List version information for the `cnrs.tanzu.vmware.com` package by running:
    ```
    tanzu package available list cnrs.tanzu.vmware.com --namespace tap-install
    ```
    For example:
    ```
    $ tanzu package available list cnrs.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for cnrs.tanzu.vmware.com...
      NAME                   VERSION  RELEASED-AT
      cnrs.tanzu.vmware.com  1.0.1    2021-07-30T15:18:46Z
    ```


## <a id='general-procedure-to-install-a-package'></a> General Procedure to Install a Package

To install any package from the Tanzu Application Platform package repository:

1. Run:
    ```
    tanzu package available get PACKAGE-NAME/VERSION-NUMBER --values-schema --namespace tap-install
    ```

     Where:

     + `PACKAGE-NAME` is the name of the package listed in step 6 of
     [Add the Tanzu Application Platform Package Repository](#add-package-repositories) above.
     + `VERSION-NUMBER` is the version of the package listed in step 7 of
     [Add the Tanzu Application Platform Package Repository](#add-package-repositories) above.

    For example:
    ```
    $ tanzu package available get cnrs.tanzu.vmware.com/1.0.1 --values-schema --namespace tap-install
    ```

2. Follow the specific installation instructions for each package:

    + [Install Cloud Native Runtimes](#install-cnr)
    + [Install Application Accelerator](#install-app-accelerator)
    + [Install Application Live View](#install-app-live-view)
    + [Install Supply Chain Choreographer](#-install-supply-chain-choreographer)
    + [Install Default Supply Chains](#-install-default-supply-chains) 
    + [Install Supply Chain Security Tools - Store](#install-scst-store)
    + [Install Supply Chain Security Tools - Sign](#install-scst-sign)
    + [Install Supply Chain Security Tools - Scan](#install-scst-scan)
    + [Install API portal](#install-api-portal)
    + [Install SCP Toolkit](#install-scp-toolkit)
    + [Install Convention Service](#install-convention-service)
    + [Install Source Controller](#install-source-controller)
    + [Install Service Bindings](#install-service-bindings)
    + [Install Tanzu Build Service](#install-tbs)


## <a id='install-cnr'></a> Install Cloud Native Runtimes

To install Cloud Native Runtimes:

1. Follow the instructions in [Install Packages](#install-packages) above.


    ```
    tanzu package available get cnrs.tanzu.vmware.com/1.0.1 --values-schema -n tap-install
    ```
    For example:
    ```
    $ tanzu package available get cnrs.tanzu.vmware.com/1.0.1 --values-schema -n tap-install
    | Retrieving package details for cnrs.tanzu.vmware.com/1.0.1...
      KEY                         DEFAULT  TYPE             DESCRIPTION
      pdb.enable                  true     boolean  Optional: Set to true to enable Pod Disruption Budget. If provider local is set to "local", the PDB will be disabled automatically.
      provider                    <nil>    string   Optional: Kubernetes cluster provider. To be specified if deploying CNR on TKGs or on a local Kubernetes cluster provider.
      ingress.external.namespace  <nil>    string   Optional: Only valid if a Contour instance already present in the cluster. Specify a namespace where an existing Contour is installed on your cluster (for external services) if you want CNR to use your Contour instance.
      ingress.internal.namespace  <nil>    string   Optional: Only valid if a Contour instance already present in the cluster. Specify a namespace where an existing Contour is installed on your cluster (for internal services) if you want CNR to use your Contour instance.
      ingress.reuse_crds          false    boolean  Optional: Only valid if a Contour instance already present in the cluster. Set to "true" if you want CNR to re-use the cluster's existing Contour CRDs.
      local_dns.enable            false    boolean  Optional: Only for when "provider" is set to "local" and running on Kind. Set to true to enable local DNS.
      local_dns.domain            <nil>    string   Optional: Set a custom domain for the Knative services.
    ```

2. Gather the values schema.

3. Create a `cnr-values.yaml` using the following sample as a guide:

    Sample `cnr-values.yaml` for Cloud Native Runtimes:

    ```
    ---
    # if deploying on a local cluster such as Kind. Otherwise, you can use the defaults values to install CNR.
    provider: local
    ```

    In Tanzu Kubernetes Grid environments, Contour packages that are already been present might conflict
    with the Cloud Native Runtimes installation.
    For how to prevent conflicts,
    see [Installing Cloud Native Runtimes for Tanzu with an Existing Contour Installation](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/1.0/tanzu-cloud-native-runtimes-1-0/GUID-contour.html) in the Cloud Native Runtimes documentation.
    Then, in the `values.yaml` file, specify values for `ingress.reuse_crds`, `ingress.external.namespace`,
    and `ingress.internal.namespace` as appropriate.

    For a local Kubernetes cluster, set `provider: "local"`.
    For other infrastructures, do not set `provider`.

4. Install the package by running:

    ```
    tanzu package install cloud-native-runtimes -p cnrs.tanzu.vmware.com -v 1.0.1 -n tap-install -f cnr-values.yaml
    ```
    For example:
    ```
    $ tanzu package install cloud-native-runtimes -p cnrs.tanzu.vmware.com -v 1.0.1 -n tap-install -f cnr-values.yaml
    - Installing package 'cnrs.tanzu.vmware.com'
    | Getting package metadata for 'cnrs.tanzu.vmware.com'
    | Creating service account 'cloud-native-runtimes-tap-install-sa'
    | Creating cluster admin role 'cloud-native-runtimes-tap-install-cluster-role'
    | Creating cluster role binding 'cloud-native-runtimes-tap-install-cluster-rolebinding'
    - Creating package resource
    - Package install status: Reconciling

     Added installed package 'cloud-native-runtimes' in namespace 'tap-install'
    ```
5. Verify the package install by running:

    ```
    tanzu package installed get cloud-native-runtimes -n tap-install
    ```
    For example:
    ```
    tanzu package installed get cloud-native-runtimes -n tap-install
    | Retrieving installation details for cc...
    NAME:                    cloud-native-runtimes
    PACKAGE-NAME:            cnrs.tanzu.vmware.com
    PACKAGE-VERSION:         1.0.1
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:    
    ```
    STATUS should be `Reconcile succeeded`.


## <a id='install-app-accelerator'></a> Install Application Accelerator

To install Application Accelerator:

**Prerequisite**: Flux installed on the cluster.
For how to install Flux,
see [Install Flux2](https://docs.vmware.com/en/Application-Accelerator-for-VMware-Tanzu/0.2/acc-docs/GUID-installation-install.html#install-flux2-2)
in the Application Accelerator documentation.

1. Follow the instructions in [Install Packages](#install-packages) above.

2. Gather the values schema.

3. Create an `app-accelerator-values.yaml` using the following sample as a guide:

    ```
    server:
      # Set this service_type to "NodePort" for local clusters like minikube.
      service_type: "LoadBalancer"
      watched_namespace: "default"
      engine_invocation_url: "http://acc-engine.accelerator-system.svc.cluster.local/invocations"
    engine:
      service_type: "ClusterIP"
    ```

4. Install the package by running:

    ```
    tanzu package install app-accelerator -p accelerator.apps.tanzu.vmware.com -v 0.3.0 -n tap-install -f app-accelerator-values.yaml
    ```
    For example:
    ```
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

5. Verify the package install by running:

    ```
    tanzu package installed get app-accelerator -n tap-install
    ```
    For example:
    ```
    tanzu package installed get app-accelerator -n tap-install
    | Retrieving installation details for cc...
    NAME:                    app-accelerator
    PACKAGE-NAME:            accelerator.apps.tanzu.vmware.com
    PACKAGE-VERSION:         0.3.0
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:    
    ```
    STATUS should be Reconcile succeeded.

## <a id="install-app-live-view"></a>Install Application Live View

To install Application Live View:

1. Follow the instructions in [Install Packages](#install-packages) above.

2. Follow the instructions in [Install Convention Service](#install-convention-service).

3. Gather the values schema.

4. Create a `app-live-view-values.yaml` using the following sample as a guide:

    Sample `app-live-view-values.yaml` for Application Live View:

    ```
    ---
    connector_namespaces: [foo, bar]
    server_namespace: tap-install
    ```
    The server_namespace is the namespace to which the Application Live View server is deployed. Typically you should pick the namespace you created earlier, tap-install. The connector_namespaces should be a list of namespaces in which you want Application Live View to monitor your apps. To each of those namespace an instance of the Application Live View Connector will be deployed.

5. Install the package by running:

    ```
    tanzu package install app-live-view -p appliveview.tanzu.vmware.com -v 0.2.0 -n tap-install -f app-live-view-values.yaml
    ```
    For example:
    ```
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

6. Verify the package install by running:

    ```
    tanzu package installed get app-live-view -n tap-install
    ```
    For example:
    ```
    tanzu package installed get app-live-view -n tap-install
    | Retrieving installation details for cc...
    NAME:                    app-live-view
    PACKAGE-NAME:            appliveview.tanzu.vmware.com
    PACKAGE-VERSION:         0.2.0
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:    
    ```
    STATUS should be Reconcile succeeded.

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

- **[cert-manager]**, for provisioning certificates for the webhook
  servers that some controllers register with Kubernetes' API server to
  validate and modify objects when update

```bash
CERT_MANAGER_VERSION=1.5.3

kapp deploy --yes -a cert-manager \
  -f https://github.com/jetstack/cert-manager/releases/download/v$CERT_MANAGER_VERSION/cert-manager.yaml
```

- **[kapp-controller]**, for providing to Kubernetes both packaging and
  application primitives (i.e., used for installing some of the
  dependencies here as well as deploying the applications that go
  through this supplychain)

```bash
KAPP_CONTROLLER_VERSION=0.25.0

kapp deploy --yes -a kapp-controller \
    -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/download/v$KAPP_CONTROLLER_VERSION/release.yml
```

- **[secretgen-controller]**, for filling placeholder secrets with the
  contents of shared credentials that we can define once and keep in
  sync everywhere we want.

```bash
SECRETGEN_CONTROLLER_VERSION=0.5.0

kapp deploy --yes -a secretgen-controller \
  -f https://github.com/vmware-tanzu/carvel-secretgen-controller/releases/download/v$SECRETGEN_CONTROLLER_VERSION/release.yml
```

- **flux2 source-controller**, for bringing the capability of making source
  code changes available to the components in the supply chain. As _Application
  Accelerator_ already depends on it too, see [#install-app-accelerator].


#### TAP Prerequisites

- [Cloud Native Runtimes](#-install-cloud-native-runtimes)
- [Convention Service](#convention-service) TODO: where is the convention service install doc?
- [Tanzu Build Service](#tanzu-build-service) TODO: point to the TBS install docs


#### Tekton

[tekton] is used by the supply chain to run tests defined by the developers
before we get to the point of producing a container image for the source code,
effectively preventing code that fails tests to being promoted all the way to a
deployment.

```bash
TEKTON_VERSION=0.28.0

kapp deploy --yes -a tekton \
  -f https://storage.googleapis.com/tekton-releases/pipeline/previous/v$TEKTON_VERSION/release.yaml
```

### Cartographer Installation

Cartographer is what provides the custom resource definitions that this
supply chain makes use of, bringing the capability of choreographing the
components that form the software supply chain, passing the results of,
say, fetching source code, to the component that knows how to build a
container image out of it, to then a component that knows how to deploy
it ... so on and so forth.


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

```bash
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


```bash
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

2. Gather the values schema.

3. Create a `scst-store-values.yaml` using the following sample as a guide:

    Sample `scst-store-values.yaml` for Supply Chain Security Tools - Store:

    ```yaml
    db_password: "password0123456"
    app_service_type: "LoadBalancer"
    ```

    Here, `app_service_type` has been set to `LoadBalancer`.
    If your environment does not support `LoadBalancer`, omit this line and it will use the default value `NodePort`.

4. Install the package by running:

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
    ```
    tanzu package available get image-policy-webhook.signing.run.tanzu.vmware.com/1.0.0-beta.0 --values-schema
    | Retrieving package details for image-policy-webhook.signing.run.tanzu.vmware.com/1.0.0-beta.0...
      KEY                DEFAULT  TYPE     DESCRIPTION
      warn_on_unmatched  false    boolean  Feature flag for enabling admission of images that do not match
                                           any patterns in the image policy configuration.
                                           Set to true to allow images that do not match any patterns into
                                           the cluster with a warning.

    ```
1. Create a file named `values.yaml` with a `warn_on_unmatched` property.
   * **For non-production environments**: To warn the user when images do not match any pattern in the policy, but still allow them into the cluster, set `warn_on_unmatched`
   to `true`.
       ```yaml
       ---
       warn_on_unmatched: true
       ```
   * **For production environments**: To deny images that do not match any pattern in the
   policy, set `warn_on_unmatched` to `false`.
       ```yaml
       ---
       warn_on_unmatched: false
       ```
   **Note**: For a quicker installation process, VMware recommends that you set `warn_on_unmatched`
   to `true`. This means that the webhook does not prevent unsigned images from running. To promote
   to a production environment, VMware recommends that you re-install the webhook with `warn_on_unmatched`
   set to `false`.
1. Install the package:
   ```bash
   tanzu package install webhook \
     --package-name image-policy-webhook.signing.run.tanzu.vmware.com \
     --version 1.0.0-beta.0 \
     --namespace tap-install \
     --values-file values.yaml

    | Installing package 'image-policy-webhook.signing.run.tanzu.vmware.com'
    | Getting namespace 'default'
    | Getting package metadata for 'image-policy-webhook.signing.run.tanzu.vmware.com'
    | Creating service account 'webhook-default-sa'
    | Creating cluster admin role 'webhook-default-cluster-role'
    | Creating cluster role binding 'webhook-default-cluster-rolebinding'
    | Creating secret 'webhook-default-values'
    / Creating package resource
    - Package install status: Reconciling

    Added installed package 'webhook' in namespace 'default'
   ```
1. After the webhook is installed and running, create a service account named `registry-credentials` in the `image-policy-system` namespace. This is a required configuration even if the images and signatures are in public registries.
   ```yaml
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: registry-credentials
      namespace: image-policy-system
    ```

1. If the registry or registries that hold your images and signatures are private, provide the webhook with credentials to access them. You provide these credentials by adding them to the `registry-credentials` service account created above.
    ```yaml
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: registry-credentials
      namespace: image-policy-system
    imagePullSecrets:
    - name: SECRET
    ```
    Where `SECRET` is a secret that allows the webhook to access the private registry. Add additional secrets to `imagePullSecrets` as required.

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
       ```

       (Optional) Run the following commands to test the webhook if you are using the `cosign-key`:

       ```bash
       $ kubectl run cosign --image=gcr.io/projectsigstore/cosign:v1.2.1 --restart=Never --command -- sleep 900
       pod/cosign created
       ```
       ```bash
       $ kubectl run bb --image=busybox --restart=Never
       Warning: busybox didn\'t match any pattern in policy. Pod will be created as WarnOnUnmatched flag is true
       pod/bb created
       ```
       ```bash
       $ kubectl run cosign-fail --image=gcr.io/projectsigstore/cosign:v0.3.0 --command -- sleep 900
       Error from server (The image: gcr.io/projectsigstore/cosign:v0.3.0 is not signed): admission webhook "image-policy-webhook.signing.run.tanzu.vmware.com" denied the request: The image: gcr.io/projectsigstore/cosign:v0.3.0 is not signed
       ```

## <a id='install-scst-scan'></a> Install Supply Chain Security Tools - Scan

The installation for Supply Chain Security Tools – Scan involves installing two packages: Scan Controller and Grype Scanner.
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

2. Gather the values schema.
3. Create a `scst-scan-controller-values.yaml` using the following sample as a guide:

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

    The `metadataStoreTokenSecret` is a reference to a secret that you will create and contains the Metadata Store token.
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

1. Follow the instructions in [Install Packages](#install-packages) above.

2. Check what versions of API portal are available to install by running:
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

3. Create a container registry secret named `api-portal-image-pull-secret`.

   ```console
   $ kubectl create secret docker-registry api-portal-image-pull-secret -n tap-install \
     --docker-server=registry.tanzu.vmware.com \
     --docker-username=TANZU-NET-USER \
     --docker-password=TANZU-NET-PASSWORD
   secret/api-portal-image-pull-secret created
   ```
   - where `TANZU-NET-USER` and `TANZU-NET-PASSWORD` are your credentials for Tanzu Network.

4. Install API portal.

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

5. Visit [API portal for VMware Tanzu](https://docs.pivotal.io/api-portal/1-0/) for more information about API portal.

## Install SCP Toolkit

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
    $ tanzu package install scp-toolkit -n tap-install -p scp-toolkit.tanzu.vmware.com -v 0.3.0
    ```

1. Verify that the package installed by running:

    ```console
    tanzu package installed get scp-toolkit -n tap-install
    ```

    and checking that the `STATUS` value is `Reconcile succeeded`.

    For example:

    ```console
    $ tanzu package installed get scp-toolkit -n tap-install
    | Retrieving installation details for cc...
    NAME:                    scp-toolkit
    PACKAGE-NAME:            scp-toolkit.tanzu.vmware.com
    PACKAGE-VERSION:         0.3.0
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    STATUS should be Reconcile succeeded.

## <a id='install-convention-service'></a> Install Convention Service 

 Use the following procedure to install Convention Service.

 **Prerequisite**: 
 
    - Cert-manager installed on the cluster. See [Install Prerequisites](install-general.md#prereqs).

 1. Follow the instructions in [Install Packages](#install-packages) above.

 2. Install the package. Run:

    ```bash
    $ tanzu package install convention-controller -p controller.conventions.apps.tanzu.vmware.com -v 0.4.2 -n tap-install
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

 3. Verify the package install by running:

    ```bash
    $ tanzu package installed get convention-controller -n tap-install
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

 **Prerequisite**: 
 
    - Fluxcd Source Controller installed on the cluster. See [Install Prerequisites](install-general.md#prereqs).

 1. Follow the instructions in [Install Packages](#install-packages) above.

 2. Install the package. Run:

    ```bash
    $ tanzu package install source-controller -p controller.source.apps.tanzu.vmware.com -v 0.1.2 -n tap-install
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

 3. Verify the package install by running:
 
    ```bash
    $ tanzu package installed get source-controller -n tap-install
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

## <a id='install-service-bindings'></a> Install Service Bindings 

 Use the following procedure to install Service Bindings:

 1. Follow the instructions in [Install Packages](#install-packages) above.

 2. Install the package. Run:

    ```bash
    $ tanzu package install service-bindings -p service-bindings.labs.vmware.com -v 0.5.0 -n tap-install
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

 3. Verify the package install by running:

    ```bash
    $ tanzu package installed get service-bindings -n tap-install
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
    $ kubectl get pods -n source-system
    NAME                       READY   STATUS    RESTARTS   AGE
    manager-6d85fffbcd-j4gvs   1/1     Running   0          22s
    ```
    STATUS should be `Running`.

## <a id='verify'></a> Verify the Installed Packages

Use the following procedure to verify that the packages are installed.

1. List the installed packages by running:
    ```
    tanzu package installed list --namespace tap-install
    ```
    For example:
    ```
    $ tanzu package installed list --namespace tap-install
    \ Retrieving installed packages...
      NAME                   PACKAGE-NAME                                        PACKAGE-VERSION  STATUS
      app-accelerator        accelerator.apps.tanzu.vmware.com                   0.3.0            Reconcile succeeded
      app-live-view          appliveview.tanzu.vmware.com                        0.2.0            Reconcile succeeded
      cloud-native-runtimes  cnrs.tanzu.vmware.com                               1.0.1            Reconcile succeeded
      service-bindings       service-bindings.labs.vmware.com                    0.5.0            Reconcile succeeded
      source-controller      controller.source.apps.tanzu.vmware.com             0.1.2            Reconcile succeeded
      convention-controller  controller.conventions.apps.tanzu.vmware.com        0.4.2            Reconcile succeeded
    ```

## <a id='install-tbs'></a> Install Tanzu Build Service 

This topic is meant to serve as a quick-start guide for TAP installs of Tanzu Build Service using the tanzu cli and may not include some configurations required for your specific environment. For more advanced details on installation, see [Installing Tanzu Build Service](https://docs.pivotal.io/build-service/installing.html).

### Prerequisites

* Ensure you have access to a docker registry that Tanzu Build Service can use to create Builder images. Approximately 5gb of registry space is required.

### Assumptions

For this example setup, we will make the following assumptions:

* You have successfully added the TAP package repository to your Cluster
* Your registry is accesible with username and password credentials. 
* You have accepted the necessary TanzuNet EULAs specified in the TAP pre-requisites

### Installing Using the Tanzu CLI

1. Follow instructions in Install Packages above

2. Gather values schema
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

3. Create a `tbs-values.yaml` using the following sample as a guide

Sample `tbs-values.yaml` for Tanzu Build Service:

```yaml
---
kp_default_repository: <some-registry.com/some-path-to-install>
kp_default_repository_password: <registry-username>
kp_default_repository_username: <registry-username>
tanzunet_username: <tanzunet_username@email.com>
tanzunet_password: <tanzunet_password>
```
The `kp_default_repository` is the registry location that all TBS dependencies and builder images will be written. The install requires a `kp_default_repository_username` and `kp_default_repository_password` in order to write to the repository location.

The TanzuNet credentials allow for configuration of the Dependencies Updater.  This resource will access and install the build dependencies (buildpacks and stacks) TBS needs on your Cluster.  It will also keep these dependencies up to date as new versions are released on TanzuNet.

The optional values not included in this sample provide additional configuration for production use cases.

Check  [Installing Tanzu Build Service](https://docs.pivotal.io/build-service/installing.html) for more information.

4.  Install the package by running

Installing the `buildservice.tanzu.vmware.com` package with tanzunet credentials will automatically relocate buildpack dependencies to your cluster. This install process may take some time. 

```bash
tanzu package install tbs -p buildservice.tanzu.vmware.com -v 1.3.0 -n tap-install -f tbs-values.yaml --poll-interval 15s
```
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


5. Verify the package install by running

```bash
$ tanzu package installed get tbs -n tap-install
- Retrieving installation details for tbs...
NAME:                    tbs
PACKAGE-NAME:            buildservice.tanzu.vmware.com
PACKAGE-VERSION:         1.3.0
STATUS:                  Reconcile succeeded
CONDITIONS:              [{ReconcileSucceeded True  }]
USEFUL-ERROR-MESSAGE:
```

You should also be able to see the clusterbuilders created by the TBS install

```bash
$ kubectl get clusterbuilders

NAME      LATESTIMAGE                                                                                      READY
base      my-registry.com/tbs@sha256:8732fadb92d8afa40bcef2d885e9730b372484a39b4a7f718291f574645f4bf2      True
default   my-registry.com/tbs@sha256:8732fadb92d8afa40bcef2d885e9730b372484a39b4a7f718291f574645f4bf2      True
full      my-registry.com/tbs@sha256:f7cdac8b2d97790276821ee3f54c497fba4ec71752eec9a87d22905344471ed8      True
tiny      my-registry.com/tbs@sha256:b9c5348da4c1527c356d2d8b9d48462ea9bf97a98eb379e925bec69c6dd918a5      True

```


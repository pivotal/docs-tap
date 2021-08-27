# <a id='installing'></a> Installing Tanzu Application Platform

This document describes how to install Tanzu Application Platform packages from the TAP package repository.


## <a id='prereqs'></a>Prerequisites

The following prerequisites are required to install Tanzu Application Platform:

* The following Carvel tools are required to install packages using TAP repo bundle.
  For information about the Carvel tool suite,
  see [Carvel](https://carvel.dev/#whole-suite):
    * [kapp](https://github.com/vmware-tanzu/carvel-kapp/releases) (v0.37.0 or later)
    * [ytt](https://github.com/vmware-tanzu/carvel-ytt/releases) (v0.34.0 or later)
    * [imgpkg](https://github.com/vmware-tanzu/carvel-imgpkg/releases) (v0.14.0 or later)
    * [kbld](https://github.com/vmware-tanzu/carvel-kbld/releases) (v0.30.0 or later)
    * [kapp-controller](https://github.com/vmware-tanzu/carvel-kapp-controller) (v0.20.0 or later)

* The Kubernetes command line tool, kubectl, v1.19 or later, installed and authenticated with administrator rights for your target cluster.
* The [Tanzu command line interface (CLI)](ttps://github.com/vmware-tanzu/community-edition/releases/tag/v0.7.0).
   Alternatively, if you have Tanzu Kubernetes Grid,
   see [Download and Unpack the Tanzu CLI](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/1.3/vmware-tanzu-kubernetes-grid-13/GUID-install-cli.html#download-and-unpack-the-tanzu-cli-and-kubectl-1)
   in the Tanzu Kubernetes Grid documentation.


* Tanzu Application Platform is compatible with a Kubernetes cluster (v1.19 or later) on the following Kubernetes providers:

    * Azure Kubernetes Service
    * Amazon Elastic Kubernetes Service
    * kind
    * minikube
    * Tanzu Kubernetes Grid v1.4.0 and later

* For Tanzu Kubernetes Grid, the minimum cluster configuration is as follows:

    * Tanzu Kubernetes Grid on vSphere 7:
      <table class="nice">
        <tr>
          <td>Deployment Type:</td>
          <td>Dev, Prod</td>
        </tr>
        <tr>
          <td>Instance type:</td>
          <td>Medium (2 vCPUs, 8&nbsp;GiB memory)</td>
        </tr>
        <tr>
          <td>Number of worker nodes:</td>
          <td>3</td>
        </tr>
       </table>

    * Tanzu Kubernetes Grid on Azure:
      <table class="nice">
        <tr>
          <td>Deployment Type:</td>
          <td>Dev, Prod</td>
        </tr>
        <tr>
          <td>Instance type:</td>
          <td>Standard D2s v3 (2 vCPUs, 8&nbsp;GiB memory)</td>
        </tr>
        <tr>
          <td>Number of worker nodes:</td>
          <td>3</td>
        </tr>
        </table>

    * Tanzu Kubernetes Grid on AWS:
      <table class="nice">
        <tr>
          <td>Deployment Type:</td>
          <td>Dev, Prod</td>
          </tr>
        <tr>
          <td>Instance type:</td>
          <td>t2.large (2 vCPUs, 8&nbsp;GiB memory)</td>
        </tr>
        <tr>
          <td>Number of worker nodes:</td>
          <td>3</td>
        </tr>
      </table>


## Set and Verify the Kubernetes Cluster configurations

To set and verify the Kubernetes cluster configurations:

1. List the existing contexts by running:

    ```
    kubectl config get-contexts
    CURRENT   NAME                                CLUSTER           AUTHINFO                                NAMESPACE
              aks-repo-trial                      aks-repo-trial    clusterUser_aks-rg-01_aks-repo-trial
    *         aks-tap-cluster                     aks-tap-cluster   clusterUser_aks-rg-01_aks-tap-cluster
              tkg-mgmt-vc-admin@tkg-mgmt-vc       tkg-mgmt-vc       tkg-mgmt-vc-admin
              tkg-vc-antrea-admin@tkg-vc-antrea   tkg-vc-antrea     tkg-vc-antrea-admin
    ```

2. Set the context to the `aks-tap-cluster` context by running:

    ```
    kubectl config use-context aks-tap-cluster
    Switched to context "aks-tap-cluster".
    ```

3. Confirm that the context is set by running:
    ```
    kubectl config current-context
    aks-tap-cluster
    ```

4. List the parameters that are in use by running:
    ```
    kubectl cluster-info
    ```

    For example:
    <pre class="terminal">
    $ kubectl cluster-info
    Kubernetes control plane is running at https://aks-tap-cluster-dns-eec0876a.hcp.eastus.azmk8s.io:443
    healthmodel-replicaset-service is running at https://aks-tap-cluster-dns-eec0876a.hcp.eastus.azmk8s.io:443/api/v1/namespaces/kube-system/services/healthmodel-replicaset-service/proxy
    CoreDNS is running at https://aks-tap-cluster-dns-eec0876a.hcp.eastus.azmk8s.io:443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
    Metrics-server is running at https://aks-tap-cluster-dns-eec0876a.hcp.eastus.azmk8s.io:443/api/v1/namespaces/kube-system/services/https:metrics-server:/proxy

    To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
    </pre>


## Packages in Tanzu Application Platform v0.1

The following packages are available in Tanzu Application Platform:

* Cloud Native Runtimes for VMware Tanzu
* Application Accelerator for VMware Tanzu
* Application Live View for VMware Tanzu
* VMware Tanzu Build Service

Cloud Native Runtimes, Application Accelerator, and Application Live View are available as a package in TAP repo bundle.
For instructions on how to add the TAP package repository and install packages from the repository
see [Add PackageRepositories](#add-package-repositories) and [Install Packages](#install-packages) below.

Tanzu Build Services v1.2.2 can be installed from VMware Tanzu Network.
For installation instructions,
see the [Installing Tanzu Build Service](https://docs.pivotal.io/build-service/installing.html)
in the Tanzu Build Services documentation.


## Accept the EULAs

Before you can install packages, you have to accept the End User License Agreements (EULAs)
for all the components separately.

To accept EULAs:

1. Sign in to [Tanzu Network](https://network.pivotal.io).

2. For each of the following components, accept or confirm that you have accepted the EULA:

    + [Tanzu Application Platform](https://network.pivotal.io/products/tanzu-application-platform/)
    + [Tanzu Build Service](https://network.pivotal.io/products/build-service/) and its associated components,
      [Tanzu Build Service Dependencies](https://network.pivotal.io/products/tbs-dependencies/),
      [Buildpacks for VMware Tanzu](https://network.pivotal.io/products/tanzu-buildpacks-suite), and
      [Stacks for VMware Tanzu](https://network.pivotal.io/products/tanzu-stacks-suite)
    + [Cloud Native Runtimes](https://network.pivotal.io/products/serverless/)
    + [Application Accelerator](https://network.pivotal.io/products/app-accelerator/)
    + [Application Live View](https://network.pivotal.io/products/app-live-view/)

  ![Screenshot of page on Tanzu Network from where you download Tanzu Application Platform packages shows the EULA warning](./images/tap-on-tanzu-net.png)

## <a id='add-package-repositories'></a> Add the TAP Package Repository

To add the TAP package repository:

1. Create a namespace called `tap-install` for deploying the packages of the components by running:
    ```
    kubectl create ns tap-install
    ```

    This namespace is to keep the objects grouped together logically.

2. Create a secret for the namespace:
    ```
    kubectl create secret docker-registry tap-registry \
    -n tap-install \
    --docker-server='registry.pivotal.io' \
    --docker-username=TANZU-NET-USER \
    --docker-password=TANZU-NET-PASSWORD
    ```

    Where `TANZU-NET-USER` and `TANZU-NET-PASSWORD` are your credentials for Tanzu Network.

    > **Note:** You must name the secret `tap-registry` because this secret name is
    hard-coded in the TAP package repository custom resource.

3. Create the TAP package repository custom resource by downloading the sample custom resource
   from [Tanzu Network](https://network.pivotal.io/products/tanzu-application-platform/).

   Alternatively, you can create a file named `tap-package-repo.yaml` with the following contents:

   ```
   apiVersion: packaging.carvel.dev/v1alpha1
   kind: PackageRepository
   metadata:
     name: tanzu-tap-repository
   spec:
     fetch:
       imgpkgBundle:
         image: registry.pivotal.io/tanzu-application-platform/tap-packages:0.1.0 #image location
         secretRef:
           name: tap-registry
   ```

4. Add TAP package repository to the cluster by applying the `tap-package-repo.yaml` to the cluster:

    ```
    kapp deploy -a tap-package-repo -n tap-install -f ./tap-package-repo.yaml -y
    ```

5. Get status of the TAP package repository by running:

    ```
    tanzu package repository list -n tap-install
    - Retrieving repositories...
      NAME                  REPOSITORY                                                         STATUS               DETAILS
      tanzu-tap-repository  registry.pivotal.io/tanzu-application-platform/tap-packages:0.1.0  Reconcile succeeded
    ```

6. List the available packages by running:

    ```
    tanzu package available list -n tap-install
    / Retrieving available packages...
      NAME                          DISPLAY-NAME                              SHORT-DESCRIPTION
      accelerator.apps.tanzu.vmware.com  Application Accelerator for VMware Tanzu  Used to create new projects and configurations.                                      
      appliveview.tanzu.vmware.com       Application Live View for VMware Tanzu    App for monitoring and troubleshooting running apps                                  
      cnrs.tanzu.vmware.com              Cloud Native Runtimes                     Cloud Native Runtimes is a serverless runtime based on Knative
    ```

7. List version information for the `cnrs.tanzu.vmware.com` package by running:

    ```
    tanzu package available list cnrs.tanzu.vmware.com -n tap-install
    - Retrieving package versions for cnrs.tanzu.vmware.com...
      NAME                   VERSION  RELEASED-AT
      cnrs.tanzu.vmware.com  1.0.1    2021-07-30T15:18:46Z
    ```


## <a id='install-packages'></a> Install Packages

The parameters that are required for the installation need to be defined in a YAML file.

The required parameters for the individual packages can be identified by the values schema
that are defined in the package.
You can get these parameters by running a command
as described in the procedure below.

To install any package from the TAP package repository:

1. Run:
    ```
    tanzu package available get PACKAGE-NAME/VERSION --values-schema
    ```

     Where:
     + `PACKAGE-NAME` is the name of the package listed in step 6 of
     [Add the TAP Package Repository](#add-package-repositories) above.
     + `VERSION` is the version of the package listed in step 7 of
     [Add the TAP Package Repository](#add-package-repositories) above.

    For example:
    <pre class='terminal'>tanzu package available get cnrs.tanzu.vmware.com/1.0.1 --values-schema<pre>

The installation of each package is explained in the following sections:

+ [Install Cloud Native Runtimes](#install-cnr)
+ [Install Application Accelerator](#install-app-accelerator)
+ [Install Application Live View](#install-app-live-view)

### <a id='install-crn'></a> Install Cloud Native Runtimes

To install Cloud Native Runtimes:

1. Follow the instructions in [Install Packages](#install-packages) above.

    ```
    tanzu package available get cnrs.tanzu.vmware.com/1.0.1 --values-schema -n tap-install
    | Retrieving package details for cnrs.tanzu.vmware.com/1.0.1...
      KEY                         DEFAULT  TYPE             DESCRIPTION
      registry.server             <nil>    registry server  <nil>
      registry.username           <nil>    string           registry username
      ingress.external.namespace  <nil>    string           external namespace
      ingress.internal.namespace  <nil>    string           internal namespace
      ingress.reuse_crds          false    string           set true to reuse existing Contour instance
      local_dns                   <nil>    string           <nil>
      provider                    <nil>    string           Kubernetes cluster provider
      registry.password           <nil>    string           registry password
    ```

2. Gather the values schema.

3. Populate the `values.yaml`, using the following sample `values.yaml` as a guide:

    Sample `values.yaml` for Cloud Native Runtimes:

    ```
    ---
    registry:
     server: registry.pivotal.io
     username: TANZU-NET-USER
     password: TANZU-NET-PASSWORD

    provider:
    pdb:
     enable: true    

    ingress:
     reuse_crds:
     external:
       namespace:
     internal:
       namespace:    

    Local_dns:
    ```

    In TKG environments, if the Contour addons are already be present, they will conflict with the Cloud Native Runtimes installation.
    For how to prevent conflicts,
    see [Installing Cloud Native Runtimes for Tanzu with an Existing Contour Installation](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/1.0/tanzu-cloud-native-runtimes-1-0/GUID-contour.html) in the Cloud Native Runtimes documentation
    and provide values for `ingress.reuse_crds`, `ingress.external.namespace`, and `ingress.internal.namespace` accordingly.

    Provide a provider based on Infrastructure provider.
    For more information,
    see [Installing Cloud Native Runtimes](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/1.0/tanzu-cloud-native-runtimes-1-0/GUID-install.html)
    in the Cloud Native Runtime documentation.
    For a local Kubernetes cluster use `provider=local`.
    For other infrastructures, `provider` is not required.

4. Install the package by running:

    ```
    root@tkg-cli-client:~# tanzu package install cloud-native-runtimes -p cnrs.tanzu.vmware.com -v 1.0.1 -n tap-install -f values.yaml
    - Installing package 'cnrs.tanzu.vmware.com'
    | Getting package metadata for 'cnrs.tanzu.vmware.com'
    | Creating service account 'cloud-native-runtimes-tap-install-sa'
    | Creating cluster admin role 'cloud-native-runtimes-tap-install-cluster-role'
    | Creating cluster role binding 'cloud-native-runtimes-tap-install-cluster-rolebinding'
    - Creating package resource
    - Package install status: Reconciling

     Added installed package 'cloud-native-runtimes' in namespace 'tap-install'
    ```



### <a id='install-app-accelerator'></a> Install Application Accelerator

To install Application Accelerator:

**Prerequisite**: Flux installed on the cluster.
For how to install Flux,
see [Install the Flux2 dependency](https://docs.vmware.com/en/Application-Accelerator-for-VMware-Tanzu/0.2/acc-docs/GUID-installation-install.html)
in the App Accelerator documentation.

1. Follow the instructions in [Install Packages](#install-packages) above.

2. Gather the values schema.

3. Populate the `values.yaml`, using the following sample `values.yaml` as a guide:

    Sample `values.yaml` for Application Accelerator:

    ```
    registry:
      server: "registry.pivotal.io"
      username: "TANZU-NET-USER"
      password: "TANZU-NET-PASSWORD"
    server:
      service_type: "LoadBalancer"
      watched_namespace: "default"
      engine_invocation_url: "http://acc-engine.accelerator-system.svc.cluster.local/invocations"
    engine:
      service_type: "ClusterIP"
    ```

4. Install the package by running:

    ```
     tanzu package install app-accelerator -p accelerator.apps.tanzu.vmware.com -v 0.2.0 -n tap-install -f values.yaml
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



### <a id="install-app-live-view"></a>Install Application Live View

To install Application Live View:

1. Follow the instructions in [Install Packages](#install-packages) above.

2. Gather the values schema.

3. Populate the `values.yaml`, using the following sample `values.yaml` as a guide:

    Sample `values.yaml` for Application Live View:

    ```
    ---
    registry:
      server: registry.pivotal.io
      username: TANZU-NET-USER
      password: TANZU-NET-PASSWORD
    ```

4. Install the package by running:

    ```
    tanzu package install app-live-view -p appliveview.tanzu.vmware.com -v 0.1.0 -n tap-install -f values.yaml
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
    see the [Application Live View documentation](https://docs.vmware.com/en/Application-Live-View-for-VMware-Tanzu/0.1/app-live-view-docs/GUID-index.html).


## Verify the Installed Packages

To verify that the packages have been installed:

1. List the installed packages by running:

    ```
    tanzu package installed list -n tap-install
    \ Retrieving installed packages...
      NAME                   PACKAGE-NAME                       PACKAGE-VERSION  STATUS
      app-accelerator        accelerator.apps.tanzu.vmware.com  0.2.0            Reconcile succeeded
      app-live-view         appliveview.tanzu.vmware.com        0.1.0            Reconcile succeeded
      cloud-native-runtimes  cnrs.tanzu.vmware.com              1.0.1            Reconcile succeeded
    ```


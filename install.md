# <a id='installing'></a> Installing Tanzu Application Platform

This document describes how to install Tanzu Application Platform packages from the TAP package repository.


## <a id='prereqs'></a>Prerequisites

The following prerequisites are required to install Tanzu Application Platform:

* The following Carvel command line tools are required to install packages using the TAP repo bundle.
  For information about the Carvel tool suite,
  see [Carvel](https://carvel.dev/#whole-suite):
    * [kapp](https://github.com/vmware-tanzu/carvel-kapp/releases) (v0.37.0 or later)
    * [ytt](https://github.com/vmware-tanzu/carvel-ytt/releases) (v0.34.0 or later)
    * [imgpkg](https://github.com/vmware-tanzu/carvel-imgpkg/releases) (v0.14.0 or later)
    * [kbld](https://github.com/vmware-tanzu/carvel-kbld/releases) (v0.30.0 or later)

* kapp-controller v0.20.0 or later. To install kapp-controller, see [Install](https://carvel.dev/kapp-controller/docs/latest/install/) in the Carvel documentation.

* The Kubernetes command line tool, kubectl, v1.19 or later, installed and authenticated with administrator rights for your target cluster.

* Tanzu Application Platform is compatible with a Kubernetes cluster (v1.19 or later) on the following Kubernetes providers:

    * Azure Kubernetes Service
    * Amazon Elastic Kubernetes Service
    * kind
    * minikube


## Set and Verify the Kubernetes Cluster Configurations

To set and verify the Kubernetes cluster configurations:

1. List the existing contexts by running:

    ```
    kubectl config get-contexts
    ```
    For example:
    ```
    $ kubectl config get-contexts
    CURRENT   NAME                                CLUSTER           AUTHINFO                                NAMESPACE
              aks-repo-trial                      aks-repo-trial    clusterUser_aks-rg-01_aks-repo-trial
    *         aks-tap-cluster                     aks-tap-cluster   clusterUser_aks-rg-01_aks-tap-cluster
              tkg-mgmt-vc-admin@tkg-mgmt-vc       tkg-mgmt-vc       tkg-mgmt-vc-admin
              tkg-vc-antrea-admin@tkg-vc-antrea   tkg-vc-antrea     tkg-vc-antrea-admin
    ```

2. Set the context to the `aks-tap-cluster` context by running:

    ```
    kubectl config use-context aks-tap-cluster
    ```
    For example:
    ```
    $ kubectl config use-context aks-tap-cluster
    Switched to context "aks-tap-cluster".
    ```

3. Confirm that the context is set by running:
    
    ```
    kubectl config current-context
    ```
    For example:
    ```
    $ kubectl config current-context
    aks-tap-cluster
    ```

4. List the parameters that are in use by running:
    ```
    kubectl cluster-info
    ```
    For example:
    ```
    $ kubectl cluster-info
    Kubernetes control plane is running at https://aks-tap-cluster-dns-eec0876a.hcp.eastus.azmk8s.io:443
    healthmodel-replicaset-service is running at https://aks-tap-cluster-dns-eec0876a.hcp.eastus.azmk8s.io:443/api/v1/namespaces/kube-system/services/healthmodel-replicaset-service/proxy
    CoreDNS is running at https://aks-tap-cluster-dns-eec0876a.hcp.eastus.azmk8s.io:443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
    Metrics-server is running at https://aks-tap-cluster-dns-eec0876a.hcp.eastus.azmk8s.io:443/api/v1/namespaces/kube-system/services/https:metrics-server:/proxy

    To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
    ```


## Packages in Tanzu Application Platform v0.1

The following packages are available in Tanzu Application Platform:

* Cloud Native Runtimes for VMware Tanzu
* Application Accelerator for VMware Tanzu
* Application Live View for VMware Tanzu
* VMware Tanzu Build Service

Cloud Native Runtimes, Application Accelerator, and Application Live View are available as a package in the TAP repo bundle.
For instructions on how to add the TAP package repository and install packages from the repository,
see [Add PackageRepositories](#add-package-repositories) and [Install Packages](#install-packages) below.

Tanzu Build Services v1.2.2 can be installed from VMware Tanzu Network.
For installation instructions,
see the [Installing Tanzu Build Service](https://docs.pivotal.io/build-service/installing.html)
in the Tanzu Build Services documentation.


## Accept the EULAs

Before you can install packages, you have to accept the End User License Agreements (EULAs)
for each component separately.

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

## Install the Tanzu CLI and Package Plugin

Before you can install Tanzu Application Platform,
you need to download and install the Tanzu CLI and the package plugin for the Tanzu CLI.

Follow the procedure for your operating system:

+ [Linux: Install the Tanzu CLI and Package Plugin](#linux-cli)
+ [Mac: Install the Tanzu CLI and Package Plugin](#mac-cli)
+ [Windows: Install the Tanzu CLI and Package Plugin](#windows-cli)


### <a id='linux-cli'></a> Linux: Install the Tanzu CLI and Package Plugin

To install the Tanzu CLI and package plugin on a Linux operating system:

1. Create a local directory called `tanzu`. 
    ```
    mkdir $HOME/tanzu
    ```
 
2. Sign in to [Tanzu Network](https://network.pivotal.io).

3. Navigate to [Tanzu Application Platform](https://network.pivotal.io/products/tanzu-application-platform/) on Tanzu Network.

4. Download `tanzu-cli-bundle-linux` under the tanzu-cli folder and unpack the TAR file into the `tanzu` directory:
    ```
    tar -xvf tanzu-cli-bundle-linux-amd64.tar -C $HOME/tanzu
    ```
    
5. Install the Tanzu CLI from the `tanzu` directory by running:
    ```
    cd $HOME/tanzu
    sudo install cli/core/v1.4.0-rc.5/tanzu-core-linux_amd64 /usr/local/bin/tanzu
    ```

6. Confirm the installation of the Tanzu CLI by running:
   ```
   tanzu version
   ```

7. From the `tanzu` directory, install the package plugin by running:
   ```
   tanzu plugin clean
   tanzu plugin install -v v1.4.0-rc.5 --local cli package 
   ```

8. Confirm the installation of the Tanzu CLI package plugin by running:
   ```
   tanzu package version
   ```

### <a id='mac-cli'></a> MacOS: Install the Tanzu CLI and Package Plugin

To install the Tanzu CLI and package plugin on a Mac operating system:

1. Create a local directory called `tanzu`. 
    ```
    mkdir $HOME/tanzu
    ```
 
2. Sign in to [Tanzu Network](https://network.pivotal.io).

3. Navigate to [Tanzu Application Platform](https://network.pivotal.io/products/tanzu-application-platform/) on Tanzu Network.

4. Download `tanzu-cli-bundle-mac` under the tanzu-cli folder and unpack the TAR files into the `tanzu` directory.
    ```
    tar -xvf tanzu-cli-bundle-darwin-amd64.tar -C $HOME/tanzu
    ```

5.  Install the Tanzu CLI from the `tanzu` directory by running:
    ```
    cd $HOME/tanzu
    sudo install cli/core/v1.4.0-rc.5/tanzu-core-darwin_amd64 /usr/local/bin/tanzu
    ```

6. Confirm the installation of the Tanzu CLI by running:
   ```
   tanzu version
   ```

7. From the `tanzu` directory, install the package plugin by running:
   ```
   tanzu plugin clean
   tanzu plugin install -v v1.4.0-rc.5 --local cli package 
   ```

8. Confirm the installation of the Tanzu CLI package plugin by running:
   ```
   tanzu package version
   ```

### <a id='windows-cli'></a> Windows: Install the Tanzu CLI and Package Plugin

To install the Tanzu CLI and package plugin on a Windows operating system:

1. Create a local directory called `tanzu-bundle`.
    
2. Sign in to [Tanzu Network](https://network.pivotal.io).

3. Navigate to [Tanzu Application Platform](https://network.pivotal.io/products/tanzu-application-platform/) on Tanzu Network.

4. Download `tanzu-cli-bundle-windows` under the tanzu-cli folder and unpack the TAR files into the `tanzu-bundle` directory.
   
5. Create a new `Program Files\tanzu` folder.
   
6. In the unpacked CLI folder tanzu-bundle, locate and copy the `core/v1.4.0-rc.5/tanzu-core-windows_amd64.exe`
   into the new `Program Files\tanzu` folder.
       
7. Rename `tanzu-core-windows_amd64.exe` to `tanzu.exe`.
    
8. Right-click the `tanzu` folder, select **Properties > Security**,
   and make sure that your user account has the **Full Control** permission.
       
9. Use Windows Search to search for `env`.
    
10. Select **Edit the system environment variables**, and click **Environment Variables**.
    
11. Select the **Path** row under **System variables**, and click **Edit**.
    
12. Click **New** to add a new row, and enter the path to the Tanzu CLI.

13. Confirm the installation of the Tanzu CLI by running in a terminal window:

    ```
    tanzu version
    ```

14. From the command prompt, navigate to the `tanzu-bundle` directory that contains the package plugin,
    and install the plugin by running:
   
    ```
    tanzu plugin clean
    tanzu plugin install -v v1.4.0-rc.5 --local cli package
    ```

15. Confirm the installation of the Tanzu CLI by running:
    ```
    tanzu package version
    ```

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

    > **Note:** You must name the secret `tap-registry`.

3. Create the TAP package repository custom resource by downloading the `sample-package-repo.yaml` file
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

5. Get status of the TAP package repository, and ensure the status updates to `Reconcile succeeded` by running:

    ```
    tanzu package repository list -n tap-install
    ```
    For example:
    ```
    $ tanzu package repository list -n tap-install
    - Retrieving repositories...
      NAME                  REPOSITORY                                                         STATUS               DETAILS
      tanzu-tap-repository  registry.pivotal.io/tanzu-application-platform/tap-packages:0.1.0  Reconcile succeeded
    ```

6. List the available packages by running:


    ```
    tanzu package available list -n tap-install
    ```
    For example:
    ```
    $ tanzu package available list -n tap-install
    / Retrieving available packages...
      NAME                               DISPLAY-NAME                              SHORT-DESCRIPTION
      accelerator.apps.tanzu.vmware.com  Application Accelerator for VMware Tanzu  Used to create new projects and configurations.                                      
      appliveview.tanzu.vmware.com       Application Live View for VMware Tanzu    App for monitoring and troubleshooting running apps                                  
      cnrs.tanzu.vmware.com              Cloud Native Runtimes                     Cloud Native Runtimes is a serverless runtime based on Knative
    ```

7. List version information for the `cnrs.tanzu.vmware.com` package by running:
    ```
    tanzu package available list cnrs.tanzu.vmware.com -n tap-install
    ```
    For example:
    ```
    $ tanzu package available list cnrs.tanzu.vmware.com -n tap-install
    - Retrieving package versions for cnrs.tanzu.vmware.com...
      NAME                   VERSION  RELEASED-AT
      cnrs.tanzu.vmware.com  1.0.1    2021-07-30T15:18:46Z
    ```


## <a id='install-packages'></a> Install Packages

The parameters that are required for the installation need to be defined in a YAML file.

The required parameters for the individual packages can be identified by the values schema
that are defined in the package.
You can get these parameters by running the command
as described in the procedure below.

To install any package from the TAP package repository:

1. Run:
    ```
    tanzu package available get PACKAGE-NAME/VERSION-NUMBER --values-schema -n tap-install
    ```

     Where:

     + `PACKAGE-NAME` is the name of the package listed in step 6 of
     [Add the TAP Package Repository](#add-package-repositories) above.
     + `VERSION-NUMBER` is the version of the package listed in step 7 of
     [Add the TAP Package Repository](#add-package-repositories) above.

    For example:
    ```
    $ tanzu package available get cnrs.tanzu.vmware.com/1.0.1 --values-schema -n tap-install
    ```

2. Follow the specific installation instructions for each package:

    + [Install Cloud Native Runtimes](#install-cnr)
    + [Install Application Accelerator](#install-app-accelerator)
    + [Install Application Live View](#install-app-live-view)


### <a id='install-cnr'></a> Install Cloud Native Runtimes

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

3. Create a `cnr-values.yaml` using the following sample as a guide:

    Sample `cnr-values.yaml` for Cloud Native Runtimes:

    ```
    ---
    registry:
     server: "registry.pivotal.io"
     username: "TANZU-NET-USER"
     password: "TANZU-NET-PASSWORD"

    provider:
    pdb:
     enable: "true"

    ingress:
     reuse_crds:
     external:
       namespace:
     internal:
       namespace:    

    Local_dns:
    ```

    In TKG environments, Contour addons that are already be present might conflict
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



### <a id='install-app-accelerator'></a> Install Application Accelerator

To install Application Accelerator:

**Prerequisite**: Flux installed on the cluster.
For how to install Flux,
see [Install the Flux2 dependency](https://docs.vmware.com/en/Application-Accelerator-for-VMware-Tanzu/0.2/acc-docs/GUID-installation-install.html)
in the App Accelerator documentation.

1. Follow the instructions in [Install Packages](#install-packages) above.

2. Gather the values schema.

3. Create a `app-acclerator-values.yaml` using the following sample as a guide:

    Sample `app-accelerator-values.yaml` for Application Accelerator:

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
    tanzu package install app-accelerator -p accelerator.apps.tanzu.vmware.com -v 0.2.0 -n tap-install -f app-accelerator-values.yaml
    ```
    For example:
    ```
    $ tanzu package install app-accelerator -p accelerator.apps.tanzu.vmware.com -v 0.2.0 -n tap-install -f app-accelerator-values.yaml
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

3. Create a `app-live-view-values.yaml` using the following sample as a guide:

    Sample `app-live-view-values.yaml` for Application Live View:

    ```
    ---
    registry:
      server: "registry.pivotal.io"
      username: "TANZU-NET-USER"
      password: "TANZU-NET-PASSWORD"
    ```

4. Install the package by running:

    ```
    tanzu package install app-live-view -p appliveview.tanzu.vmware.com -v 0.1.0 -n tap-install -f app-live-view-values.yaml
    ```
    For example:
    ```
    $ tanzu package install app-live-view -p appliveview.tanzu.vmware.com -v 0.1.0 -n tap-install -f app-live-view-values.yaml
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


## <a id='verify'></a> Verify the Installed Packages

To verify that the packages are installed:

1. List the installed packages by running:
    ```
    tanzu package installed list -n tap-install
    ```
    For example:
    ```
    $ tanzu package installed list -n tap-install
    \ Retrieving installed packages...
      NAME                   PACKAGE-NAME                       PACKAGE-VERSION  STATUS
      app-accelerator        accelerator.apps.tanzu.vmware.com  0.2.0            Reconcile succeeded
      app-live-view         appliveview.tanzu.vmware.com        0.1.0            Reconcile succeeded
      cloud-native-runtimes  cnrs.tanzu.vmware.com              1.0.1            Reconcile succeeded
    ```


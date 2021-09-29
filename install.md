# <a id='installing'></a> Installing Part II: Packages

This document describes how to install Tanzu Application Platform packages
from the Tanzu Application Platform package repository.

Before you install the packages, ensure that you have completed the prerequisites, configured
and verified the cluster, accepted the EULA, and installed the Tanzu CLI and the package plugin.
For information, see [Installing Part I: Prerequisites, Cluster Configurations, EULA, and CLI](install-general.md).


## <a id='install-packages'></a> About Installing Packages

<<<<<<< HEAD
* A Kubernetes cluster (v1.19 or later) on one of the following Kubernetes providers:

    * Azure Kubernetes Service
    * Amazon Elastic Kubernetes Service
    * kind
    * minikube
    * Tanzu Kubernetes Grid v1.4.0 and later.
      > **Note:** Tanzu Kubernetes Grid v1.3 is not supported.
      If you want support for v1.3, please send feedback.

* The [kapp Carvel command line tool](https://github.com/vmware-tanzu/carvel-kapp/releases) (v0.37.0 or later)

* kapp-controller v0.24.0 or later:

    * For Azure Kubernetes Service, Amazon Elastic Kubernetes Service, kind, and minikube,
      Install kapp-controller by running:
      ```
      kapp deploy -a kc -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/download/KC-VERSION/release.yml
      ```
      Where `KC-VERSION` is the kapp-controller version being installed. Please select v0.24.0+ kapp-controller version from the [Releases page](https://github.com/vmware-tanzu/carvel-kapp-controller/releases).

      For example:
      ```
      kapp deploy -a kc -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/download/v0.24.0/release.yml
      ```

    * For Tanzu Kubernetes Grid, ensure that you are using Tanzu Kubernetes Grid v1.4.0 or later.
      Clusters of this version have kapp-controller v0.23.0 pre-installed.

    * To Verify installed kapp-controller version:

      1. Get kapp-controller deployment and namespace by running:


        ```
        kubectl get deployments -A | grep kapp-controller
        ```
        For example:
        ```
        kubectl get deployments -A | grep kapp-controller
        NAMESPACE                NAME                             READY   UP-TO-DATE   AVAILABLE   AGE
        kapp-controller          kapp-controller                  1/1     1            1           25h   
        ```


      2. Get kapp controller version by running:


        ```
        kubectl get deployment KC-DEPLOYMENT -n KC-NAMESPACE -o yaml | grep kapp-controller.carvel.dev/version
        ```

        Where `KC-DEPLOYMENT` and `KC-NAMESPACE` are kapp-controller deployment name and kapp-controller namespace name respectively from the output of step 1.

        For example:

        ```
        kubectl get deployment kapp-controller -n kapp-controller  -o yaml | grep kapp-controller.carvel.dev/version
        kapp-controller.carvel.dev/version: v0.24.0
        kapp.k14s.io/original: '{"apiVersion":"apps/v1","kind":"Deployment","metadata":{"annotations":{"kapp-controller.carvel.dev/version":"v0.24.0","kbld.k14s.io/images":"-
        ```


* secretgen-controller v0.5.0 or later:

    * Install secretgen-controller by running:

      ```
      kapp deploy -a sg -f https://github.com/vmware-tanzu/carvel-secretgen-controller/releases/download/SG-VERSION/release.yml
      ```

      Where `SG-VERSION` is the secretgen-controller version being installed. Please select v0.5.0+ secretgen-controller version from the [Releases page](https://github.com/vmware-tanzu/carvel-secretgen-controller/releases).

      For example:
      ```
      kapp deploy -a sg -f https://github.com/vmware-tanzu/carvel-secretgen-controller/releases/download/v0.5.0/release.yml
      ```

    * To Verify installed secretgen-controller version:

      1. Get secretgen-controller deployment and namespace by running:


        ```
        kubectl get deployments -A | grep secretgen-controller
        ```
        For example:
        ```
        kubectl get deployments -A | grep secretgen-controller
        NAMESPACE                NAME                             READY   UP-TO-DATE   AVAILABLE   AGE
        secretgen-controller     secretgen-controller             1/1     1            1           22d   
        ```

      2. Get secretgen-controller version by running:


        ```
        kubectl get deployment SG-DEPLOYMENT -n SG-NAMESPACE -o yaml | grep secretgen-controller.carvel.dev/version
        ```
        Where `SG-DEPLOYMENT` and `SG-NAMESPACE` are secretgen-controller deployment name and secretgen-controller namespace name respectively from the output of step 1.

        For example:

        ```
        kubectl get deployment secretgen-controller -n secretgen-controller -oyaml | grep secretgen-controller.carvel.dev/version
        secretgen-controller.carvel.dev/version: v0.5.0
        ```


* cert-manager v1.5.3:

        * Install cert-manager by running:

        ```
        kapp deploy --yes -a cert-manager -f https://github.com/jetstack/cert-manager/releases/download/v1.5.3/cert-manager.yaml
        ```
        We have Qualified TAP repo bundle packages installation with cert-manager version v1.5.3.
        
        * Verify installed cert-manager version by running:

        ```
        kubectl get deployment cert-manager -n cert-manager -o yaml | grep app.kubernetes.io/version
        ```

        For example:

        ```
        kubectl get deployment cert-manager -n cert-manager -o yaml | grep app.kubernetes.io/version
        "app.kubernetes.io/version": v0.5.0
        ```

* Flux-SourceController:

        * Create clusterrolebinding by running:

        ```
        kubectl create clusterrolebinding default-admin \
        --clusterrole=cluster-admin \
        --serviceaccount=default:default
        ```
        * Install Flux-SourceController by running:
        ```
        kapp deploy --yes -a flux-source-controller \
        -f https://github.com/fluxcd/source-controller/releases/download/v0.15.4/source-controller.crds.yaml \
        -f https://github.com/fluxcd/source-controller/releases/download/v0.15.4/source-controller.deployment.yaml
        ```


* The Kubernetes command line tool, kubectl, v1.19 or later, installed and authenticated with administrator rights for your target cluster.

* For Tanzu Kubernetes Grid, the minimum cluster configuration is as follows:

    * Tanzu Kubernetes Grid on vSphere:
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

2.  Set the context to the desired cluster to be used for TAP packages install. 
    For example set the context to the `aks-tap-cluster` context by running:

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
    ```{ .bash .no-copy }
    $ kubectl cluster-info
    Kubernetes control plane is running at https://aks-tap-cluster-dns-eec0876a.hcp.eastus.azmk8s.io:443
    healthmodel-replicaset-service is running at https://aks-tap-cluster-dns-eec0876a.hcp.eastus.azmk8s.io:443/api/v1/namespaces/kube-system/services/healthmodel-replicaset-service/proxy
    CoreDNS is running at https://aks-tap-cluster-dns-eec0876a.hcp.eastus.azmk8s.io:443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
    Metrics-server is running at https://aks-tap-cluster-dns-eec0876a.hcp.eastus.azmk8s.io:443/api/v1/namespaces/kube-system/services/https:metrics-server:/proxy

    To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
    ```

5. Verify kapp-controller is running by running:
   ```
   kubectl get pods -A | grep kapp-controller
   ```
   Pod status should be Running.

6. Verify secretgen-controller is running by running:
   ```
   kubectl get pods -A | grep secretgen-controller
   ```
   Pod status should be Running.


## Packages in Tanzu Application Platform v0.2

The following packages are available in Tanzu Application Platform:

* Cloud Native Runtimes for VMware Tanzu
* Application Accelerator for VMware Tanzu
* Application Live View for VMware Tanzu
* VMware Tanzu Build Service
* SCP Toolkit
* Supply Chain Choreographer for VMware Tanzu
* Default Supply Chain with Testing
* Supply Chain Security Tools for VMware Tanzu
* Convention Service for VMware Tanzu
* Tanzu Source Controller
* Service Bindings for Kubernetes
* API Portal
* 

For instructions on how to add the Tanzu Application Platform package repository and install packages from the repository,
see [Add PackageRepositories](#add-package-repositories) and [Install Packages](#install-packages) below.

You can install Tanzu Build Service v1.2.2 from VMware Tanzu Network.
For production environment installation instructions, see [Installing Tanzu Build Service](https://docs.pivotal.io/build-service/installing.html) in the Tanzu Build Service documentation.
For quick-start installation instructions, suitable for most test environments, see [Getting Started with Tanzu Build Service](https://docs.pivotal.io/build-service/getting-started.html) in the Tanzu Build Service documentation.

## Accept the EULAs

Before you can install packages, you have to accept the End User License Agreements (EULAs)
for each component separately.

To accept EULAs:

1. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

2. For each of the following components, accept or confirm that you have accepted the EULA:

    + [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/)
    + [Tanzu Build Service](https://network.tanzu.vmware.com/products/build-service/) and its associated components,
      [Tanzu Build Service Dependencies](https://network.tanzu.vmware.com/products/tbs-dependencies/),
      [Buildpacks for VMware Tanzu](https://network.tanzu.vmware.com/products/tanzu-buildpacks-suite), and
      [Stacks for VMware Tanzu](https://network.tanzu.vmware.com/products/tanzu-stacks-suite)
    + [Cloud Native Runtimes](https://network.tanzu.vmware.com/products/serverless/)
    + [Application Accelerator](https://network.tanzu.vmware.com/products/app-accelerator/)
    + [Application Live View](https://network.tanzu.vmware.com/products/app-live-view/)

  ![Screenshot of page on Tanzu Network from where you download Tanzu Application Platform packages shows the EULA warning](./images/tap-on-tanzu-net.png)

## Install the Tanzu CLI

Before you can install Tanzu Application Platform,
you need to download and install the Tanzu CLI and the package plugin for the Tanzu CLI.

Follow the procedure for your operating system:

+ [Linux: Install the Tanzu CLI](#linux-cli)
+ [Mac: Install the Tanzu CLI](#mac-cli)
+ [Windows: Install the Tanzu CLI](#windows-cli)


### <a id='linux-cli'></a> Linux: Install the Tanzu CLI

To install the Tanzu CLI on a Linux operating system:

1. Create a local directory called `tanzu`.
    ```
    mkdir $HOME/tanzu
    ```

2. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

3. Navigate to [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/) on Tanzu Network.

4. Download `tanzu-cli-bundle-linux` under the tanzu-cli folder and unpack the TAR file into the `tanzu` directory:
    ```
    tar -xvf tanzu-cli-bundle-linux-amd64.tar -C $HOME/tanzu
    ```

5. Install the Tanzu CLI from the `tanzu` directory by running:
    ```
    cd $HOME/tanzu
    sudo install cli/core/v1.4.0/tanzu-core-linux_amd64 /usr/local/bin/tanzu
    ```

6. Confirm the installation of the Tanzu CLI by running:
   ```
   tanzu version
   ```


### <a id='mac-cli'></a> MacOS: Install the Tanzu CLI

To install the Tanzu CLI on a Mac operating system:

1. Create a local directory called `tanzu`.
    ```
    mkdir $HOME/tanzu
    ```

2. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

3. Navigate to [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/) on Tanzu Network.

4. Download `tanzu-cli-bundle-mac` under the tanzu-cli folder and unpack the TAR files into the `tanzu` directory.
    ```
    tar -xvf tanzu-cli-bundle-darwin-amd64.tar -C $HOME/tanzu
    ```

5.  Install the Tanzu CLI from the `tanzu` directory by running:
    ```
    cd $HOME/tanzu
    sudo install cli/core/v1.4.0/tanzu-core-darwin_amd64 /usr/local/bin/tanzu
    ```

6. Confirm the installation of the Tanzu CLI by running:
   ```
   tanzu version
   ```


### <a id='windows-cli'></a> Windows: Install the Tanzu CLI

To install the Tanzu CLI on a Windows operating system:

1. Create a local directory called `tanzu-bundle`.

2. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

3. Navigate to [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/) on Tanzu Network.

4. Download `tanzu-cli-bundle-windows` under the tanzu-cli folder and unpack the TAR files into the `tanzu-bundle` directory.

5. Create a new `Program Files\tanzu` folder.

6. In the unpacked CLI folder tanzu-bundle, locate and copy the `core/v1.4.0/tanzu-core-windows_amd64.exe`
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

## Install the Tanzu CLI Plugins

After you have installed the tanzu core executable, you must install package, imagepullsecret, apps and app-accelerator CLI plugins.

1. (Optional) Remove existing plugins from any previous CLI installations.

    ```
    tanzu plugin clean
    ```

2. Navigate to the tanzu folder that contains the cli folder.

3. Run the following command from the tanzu directory to install all the plugins for this release.

    ```
    tanzu plugin install --local cli all
    ```
4. Check plugin installation status.

    ```
    tanzu plugin list
    ```
=======
The parameters that are required for the installation need to be defined in a YAML file.

The required parameters for the individual packages can be identified by the values schema
that are defined in the package.
You can get these parameters by running the command
as described in the procedure below.
>>>>>>> main

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
    + [Install Supply Chain Security Tools - Store](#install-scst-store)
    + [Install Supply Chain Security Tools - Sign](#install-scst-sign)
    + [Install Supply Chain Security Tools - Scan](#install-scst-scan)
    + [Install API portal](#install-api-portal)


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
      ingress.external.namespace  <nil>    string           external namespace
      ingress.internal.namespace  <nil>    string           internal namespace
      ingress.reuse_crds          false    string           set true to reuse existing Contour instance
      local_dns                   <nil>    string           <nil>
      provider                    <nil>    string           Kubernetes cluster provider
    ```

2. Gather the values schema.

3. Create a `cnr-values.yaml` using the following sample as a guide:

    Sample `cnr-values.yaml` for Cloud Native Runtimes:

    ```
    ---
    provider:
    pdb:
     enable: "true"

    ingress:
     reuse_crds:
     external:
       namespace:
     internal:
       namespace:    

    local_dns:
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
    STATUS should be Reconcile succeeded.


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

2. Gather the values schema.

3. Create a `app-live-view-values.yaml` using the following sample as a guide:

    Sample `app-live-view-values.yaml` for Application Live View:

    ```
    ---
    connector_namespaces: [foo, bar]
    server_namespace: tap-install
    ```
    The server_namespace is the namespace to which the Application Live View server is deployed. Typically you should pick the namespace you created earlier, tap-install. The connector_namespaces should be a list of namespaces in which you want Application Live View to monitor your apps. To each of those namespace an instance of the Application Live View Connector will be deployed.

4. Install the package by running:

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

5. Verify the package install by running:
    
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
1. Create a file named `values.yaml` with `warn_on_unmatched` property.
   To warn the user when images do not match any pattern in the policy, but still allow them into the cluster,  set it to `true`.
   To deny images that do not match any pattern in the policy, set it to `false`

   ```yaml
   ---
   warn_on_unmatched: true 
   ```

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
1. After the webhook is up and running, create a service account named `registry-credentials` in the `image-policy-system` namespace. This is a required configuration even if the images and signatures are in public registries. 

1. If the registry or registries that hold your images and signatures are private,
you will need to provide the webhook with credentials to access your artifacts. Create your secrets to access those registries in the `image-policy-system`
namespace. These secrets should be added to the `registry-credentials` service account created above.

    For example:

    ```yaml
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: registry-credentials
      namespace: image-policy-system
    imagePullSecrets:
    - name: secret1
    - name: secret2
    ...
    - name: secretn
    ```

1. You must also create a `ClusterImagePolicy` to inform the webhook which images it should validate.
   The cluster image policy is a custom resource definition containing the following information:
   - A list of namespaces to which the policy should not be enforced.
   - A list of public keys complementary to the private keys that were used to sign the images.
   - A list of image name patterns to which we want to enforce the policy, mapping to the public keys to use for each pattern.

   An example policy would look like this:
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
           <content ...>
           -----END PUBLIC KEY-----
       images:
       - namePattern: registry.example.org/myproject/*
         keys:
         - name: first-key
   ```

   As of this writing, the custom resource for the policy must have a name of `image-policy`.

   The platform operator should add to the `verification.exclude.resources.namespaces` section any namespaces that are known to run container images that are not currently signed, such as `kube-system`.

## <a id='install-scst-scan'></a> Install Supply Chain Security Tools - Scan

The installation for Supply Chain Security Tools – Scan involves installing two packages: Scan Controller and Grype Scanner.
Ensure both are installed.

To install Supply Chain Security Tools - Scan (Scan Controller):

1. Follow the instructions in [Install Packages](#install-packages) above.

    ```bash
    tanzu package available get scanning.apps.tanzu.vmware.com/1.0.0-beta.0 --values-schema -n tap-install
    ```
    
    For example:
    ```console
    $ tanzu package available get scanning.apps.tanzu.vmware.com/1.0.0-beta.0 --values-schema -n tap-install
    | Retrieving package details for scanning.apps.tanzu.vmware.com/1.0.0-beta.0...
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
      --version 1.0.0-beta.0 \
      --namespace tap-install \
      --values-file scst-scan-controller-values.yaml
    ```

    For example:
    ```console
    $ tanzu package install scan-controller \
      --package-name scanning.apps.tanzu.vmware.com \
      --version 1.0.0-beta.0 \
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
    tanzu package available get grype.scanning.apps.tanzu.vmware.com/1.0.0-beta.0 --values-schema -n tap-install
    ```
    For example:
    ```console
    $ tanzu package available get grype.scanning.apps.tanzu.vmware.com/1.0.0-beta.0 --values-schema -n tap-install
    | Retrieving package details for grype.scanning.apps.tanzu.vmware.com/1.0.0-beta.0...
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
      --version 1.0.0-beta.0 \
      --namespace tap-install
    ```

    For example:
    ```console
    $ tanzu package install grype-scanner \
      --package-name grype.scanning.apps.tanzu.vmware.com \
      --version 1.0.0-beta.0 \
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

First, follow the instructions in [Install Packages](#install-packages) above.

You can check what versions of API portal are available to install by running:
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

The API portal has several configurations that can be overridden during installation. 
To see the values, along with their defaults, run:

```bash
tanzu package available get -n tap-install api-portal.tanzu.vmware.com/{version} --values-schema
```
- where `{version}`  is the version you wish to install, e.g. `1.0.2`

For example:
```console
tanzu package available get -n tap-install api-portal.tanzu.vmware.com/1.0.2 --values-schema
| Retrieving package details for api-portal.tanzu.vmware.com/1.0.2...
  KEY                                    DEFAULT                                                                                       TYPE     DESCRIPTION
  apiPortalServer.sourceUrlsCacheTtlSec  300                                                                                           string   Time after which they will be refreshed (in seconds)
  apiPortalServer.sourceUrlsTimeoutSec   10                                                                                            string   Timeout for remote OpenAPI retrieval (in seconds)
  apiPortalServer.replicaCount           1                                                                                             integer  Number of replicas
  apiPortalServer.sourceUrls             https://petstore.swagger.io/v2/swagger.json,https://petstore3.swagger.io/api/v3/openapi.json  string   OpenAPI urls to load
  ```

To override these defaults, check out [Installing API portal with Overrides](#install-api-portal-overrides).

### Adding the image pull secret
The API portal requires a container registry secret named `api-portal-image-pull-secret`. 
You can use the same Tanzu Network credentials used when creating your `tap-registry` secret.


### <a id='install-api-portal-defaults'></a> Installing API portal with defaults

To install the API portal with default values, run:

```bash
tanzu package install api-portal -n tap-install -p api-portal.tanzu.vmware.com -v {version}
```
- where `{version}`  is the version you wish to install, e.g. `1.0.2`

You should see a result similar to:
```console
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

### <a id='install-api-portal-overrides'></a> Installing API portal with overrides

To install the API portal with overridden values, create a `values.yaml` file with your values. 
For example here we require two replicas:

```yaml
---
apiPortalServer:
  replicaCount: 2
```

Then run the install command with the `values.yaml`:
```bash
tanzu package install api-portal -n tap-install -p api-portal.tanzu.vmware.com -v {version} -f values.yaml
```
- where `{version}`  is the version you wish to install, e.g. `1.0.2`

You will see an output result similar to [installing with defaults](#install-api-portal-defaults). 
However, you should see two `api-portal-server` pods in your namespace.

### Further Reading

For more information on API portal, check out the documentation [here](https://docs.pivotal.io/api-portal/1-0/).

## <a id='verify'></a> Verify the Installed Packages

To verify that the packages are installed:

1. List the installed packages by running:
    ```
    tanzu package installed list --namespace tap-install
    ```
    For example:
    ```
    $ tanzu package installed list --namespace tap-install
    \ Retrieving installed packages...
      NAME                   PACKAGE-NAME                       PACKAGE-VERSION  STATUS
      app-accelerator        accelerator.apps.tanzu.vmware.com  0.3.0            Reconcile succeeded
      app-live-view         appliveview.tanzu.vmware.com        0.2.0            Reconcile succeeded
      cloud-native-runtimes  cnrs.tanzu.vmware.com              1.0.1            Reconcile succeeded
    ```

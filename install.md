# <a id='installing'></a> Installing Tanzu Application Platform

This document describes how to install Tanzu Application Platform packages from the Tanzu Application Platform package repository.


## <a id='prereqs'></a>Prerequisites

The following prerequisites are required to install Tanzu Application Platform:

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


## <a id='install-packages'></a> Install Packages

The parameters that are required for the installation need to be defined in a YAML file.

The required parameters for the individual packages can be identified by the values schema
that are defined in the package.
You can get these parameters by running the command
as described in the procedure below.

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


### <a id='install-app-accelerator'></a> Install Application Accelerator

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

6. Download and apply sample accelerators:

    1. Download the `sample-accelerators-0-2.yaml` file for Application Accelerator
       from [Tanzu Network](https://network.tanzu.vmware.com/products/app-accelerator).

    2. Apply the manifest file using kubectl by running:

        ```
        kubectl apply -f sample-accelerators-0-2.yaml
        ```


### <a id="install-app-live-view"></a>Install Application Live View

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

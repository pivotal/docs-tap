# <a id='installing'></a> Installing Part I: Prerequisites, Cluster Configurations, EULA, and CLI

This document describes the first part of the installation process for Tanzu Application Platform:

+ [Prerequisites](#prereqs)
+ [Set and Verify the Kubernetes Cluster Configurations](#set-and-verify)
+ [Accept the EULAs](#eulas)
+ [Install the Tanzu CLI and Package Plugin](#cli-and-plugin)


## <a id='prereqs'></a>Prerequisites

The following prerequisites are required to install Tanzu Application Platform:

* A Kubernetes cluster (v1.19 or later) on one of the following Kubernetes providers:

    * Azure Kubernetes Service
    * Amazon Elastic Kubernetes Service
    * kind
    * minikube
  
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


## <a id='set-and-verify'></a> Set and Verify the Kubernetes Cluster Configurations

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

2.  Set the context to the cluster that you want to use for the TAP packages install.
    For example set the context to the `aks-tap-cluster` context by running:

    ```
    kubectl config use-context aks-tap-cluster
    ```
    For example:
    ```
    $ kubectl config use-context aks-tap-cluster
    Switched to context "aks-tap-cluster".
    ```

3. Verify kapp-controller is running by running:
   ```
   kubectl get pods -A | grep kapp-controller
   ```
   Pod status should be Running.

4. Verify secretgen-controller is running by running:
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

## <a id="eulas"></a> Accept the EULAs

Before you can install packages, you have to accept the End User License Agreements (EULAs).

To accept EULAs:

1. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

2. For each of the following components, accept or confirm that you have accepted the EULA:

    + [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/)
    + [Tanzu Build Service](https://network.tanzu.vmware.com/products/build-service/) and its associated components,
      [Tanzu Build Service Dependencies](https://network.tanzu.vmware.com/products/tbs-dependencies/),
      [Buildpacks for VMware Tanzu](https://network.tanzu.vmware.com/products/tanzu-buildpacks-suite), and
      [Stacks for VMware Tanzu](https://network.tanzu.vmware.com/products/tanzu-stacks-suite)

    + [API Portal for VMWare Tanzu](https://network.tanzu.vmware.com/products/api-portal/)
    + [Cloud Native Runtimes](https://network.tanzu.vmware.com/products/serverless/)
    + [Application Accelerator](https://network.tanzu.vmware.com/products/app-accelerator/)
    + [Application Live View](https://network.tanzu.vmware.com/products/app-live-view/)
    + [Supply Chain Security Tools](https://network.tanzu.vmware.com/products/supply-chain-security-tools)

  ![Screenshot of page on Tanzu Network from where you download Tanzu Application Platform packages shows the EULA warning](./images/tap-on-tanzu-net.png)

##<a id='cli-and-plugin'></a> Install the Tanzu CLI

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
    sudo install cli/core/v0.4.0/tanzu-core-linux_amd64 /usr/local/bin/tanzu
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
    sudo install cli/core/v0.4.0/tanzu-core-darwin_amd64 /usr/local/bin/tanzu
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

6. In the unpacked CLI folder tanzu-bundle, locate and copy the `core/v0.4.0/tanzu-core-windows_amd64.exe`
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

5. From the command prompt, navigate to the `tanzu-bundle` directory that contains the accelerator plugin,
    and install the plugin by running:
   ```
   tanzu plugin install --local .\cli accelerator
   ```

6. Confirm the installation of the Tanzu CLI accelerator plugin by running:
   ```
   tanzu accelerator version
   ```

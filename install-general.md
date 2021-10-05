# <a id='installing'></a> Installing Part I: Prerequisites, Cluster Configurations, EULA, and CLI

This document describes the first part of the installation process for Tanzu Application Platform:

+ [Prerequisites](#prereqs)
+ [Set and Verify the Kubernetes Cluster Configurations](#set-and-verify)
+ [Accept the EULAs](#eulas)
+ [Install the Tanzu CLI and Package Plugin](#cli-and-plugin)


## <a id='prereqs'></a>Prerequisites

The following prerequisites are required to install Tanzu Application Platform:

* A [TanzuNet](https://network.tanzu.vmware.com/) account to download TAP packages.

* A container image registry, such as [Harbor](https://goharbor.io/) or [Docker Hub](https://hub.docker.com/) with at least **10 GB** of available storage for application images, base images, and runtime dependencies. Registry credentials with push/write access must be made available to TAP to store images. Note that registry credentials are required for components that pull/read public images from Docker Hub, in order to avoid rate limiting.

* Network access to https://registry.tanzu.vmware.com as well as your chosen container image registry.

* A Kubernetes cluster (v1.19 or later) on one of the following Kubernetes providers:

    * Azure Kubernetes Service
    * Amazon Elastic Kubernetes Service
    * kind
      
        If you are using Cloud Native Runtimes, see [Configure Your Local Kind
        Cluster](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/1.0/tanzu-cloud-native-runtimes-1-0/GUID-local-dns.html#configure-your-local-kind-cluster-1)
        in the Cloud Native Runtimes documentation to configure kind.

    * Google Kubernetes Engine (note that GKE Autopilot clusters do not have required features enabled)
    * minikube

  To deploy all TAP packages, your cluster must have at least **8 GB** of RAM across all nodes available to TAP.
  However, we recommend at least **16 GB** of RAM be available to build and deploy applications.
  
  For a single node cluster, such as KIND, we recommend **4 vCPU** be available, along with **70 GB** disk.
  
  For this beta release, [Pod Security Policies](https://kubernetes.io/docs/concepts/policy/pod-security-policy/) must be configured so that TAP controller pods may run as root.
  
* **The Kubernetes CLI, kubectl, v1.19** or later, installed and authenticated with administrator rights for your target cluster.

* **[kapp Carvel command line tool](https://github.com/vmware-tanzu/carvel-kapp/releases)** (v0.37.0 or later)

* kapp-controller v0.25.0 or later:

    * For Azure Kubernetes Service, Amazon Elastic Kubernetes Service, Google Kubernetes Engine, kind, and minikube,
      Install kapp-controller by running:
      ```
      kapp deploy -a kc -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/download/KC-VERSION/release.yml
      ```
      Where `KC-VERSION` is the kapp-controller version being installed. Please select v0.25.0+ kapp-controller version from the [Releases page](https://github.com/vmware-tanzu/carvel-kapp-controller/releases).

      For example:
      ```
      kapp deploy -a kc -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/download/v0.25.0/release.yml
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
         kapp-controller.carvel.dev/version: v0.25.0
         kapp.k14s.io/original: '{"apiVersion":"apps/v1","kind":"Deployment","metadata":{"annotations":{"kapp-controller.carvel.dev/version":"v0.25.0","kbld.k14s.io/images":"-
         ```


* **secretgen-controller v0.5.0** or later:

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



* **cert-manager v1.5.3**:

    * Install cert-manager by running:

        ```
        kapp deploy -a cert-manager -f https://github.com/jetstack/cert-manager/releases/download/v1.5.3/cert-manager.yaml
        ```
        We have verified the Tanzu Application Platform repo bundle packages installation with cert-manager version v1.5.3.
        
        * Verify installed cert-manager version by running:

        ```
        kubectl get deployment cert-manager -n cert-manager -o yaml | grep 'app.kubernetes.io/version: v'
        ```

        For example:

        ```
        kubectl get deployment cert-manager -n cert-manager -o yaml | grep 'app.kubernetes.io/version: v'
           app.kubernetes.io/version: v1.5.3
              app.kubernetes.io/version: v1.5.3
        ```



* **FluxCD source-controller v0.15.4**:

     * Create namespace `flux-system`
        
        ```
        kubectl create namespace flux-system
        ```
     
     * Create clusterrolebinding by running:

        ```
        kubectl create clusterrolebinding default-admin \
        --clusterrole=cluster-admin \
        --serviceaccount=flux-system:default
        ```
     * Install FluxCD Source Controller by running:
        ```
        kapp deploy -a flux-source-controller -n flux-system \
        -f https://github.com/fluxcd/source-controller/releases/download/v0.15.4/source-controller.crds.yaml \
        -f https://github.com/fluxcd/source-controller/releases/download/v0.15.4/source-controller.deployment.yaml
        ```




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
    * Tanzu Build Service uses the open-source <a href="https://buildpacks.io/">Cloud Native Buildpacks</a> project to turn application source code into container images
* SCP Toolkit
* Supply Chain Choreographer for VMware Tanzu
* Default Supply Chain with Testing
* Supply Chain Security Tools for VMware Tanzu
* Convention Service for VMware Tanzu
* Tanzu Source Controller
* Service Bindings for Kubernetes
* API Portal


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
    + [API portal for VMware Tanzu](https://network.tanzu.vmware.com/products/api-portal/)

## <a id='cli-and-plugin'></a> Install the Tanzu CLI

Before you install Tanzu Application Platform,
download and install the Tanzu CLI and the Tanzu CLI plugins. 
If you have earlier versions of the Tanzu CLI, follow the instructions in [Update the Tanzu CLI](#update-cli).
If you have installed a tanzu CLI for TCE or TKG in the past, please uninstall it and remove the `~/.config/tanzu` directory before trying out TAP.

Follow the procedure for your operating system:

+ [Linux: Install the Tanzu CLI](#linux-cli)
+ [Mac: Install the Tanzu CLI](#mac-cli)
+ [Windows: Install the Tanzu CLI](#windows-cli)


## <a id='linux-cli'></a> Linux: Install the Tanzu CLI

To install the Tanzu CLI on a Linux operating system:

1. Create a local directory called `tanzu`.
    ```
    mkdir $HOME/tanzu
    ```

2. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

3. Navigate to [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/) on Tanzu Network.

4. Click on the `tanzu-cli-0.5.0` folder.

5. Download `tanzu-framework-bundle-linux` and unpack the TAR file into the `tanzu` directory:
    ```
    tar -xvf tanzu-framework-linux-amd64.tar -C $HOME/tanzu
    ```

6. Install the Tanzu CLI from the `tanzu` directory by running:
    ```
    cd $HOME/tanzu
    sudo install cli/core/v0.5.0/tanzu-core-linux_amd64 /usr/local/bin/tanzu
    ```

7. Confirm the installation of the Tanzu CLI by running:
   ```
   tanzu version
   ```


## <a id='mac-cli'></a> MacOS: Install the Tanzu CLI

To install the Tanzu CLI on a Mac operating system:

1. Create a local directory called `tanzu`.
    ```
    mkdir $HOME/tanzu
    ```

2. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

3. Navigate to [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/) on Tanzu Network.

4. Click on the `tanzu-cli-0.5.0` folder.

5. Download `tanzu-framework-bundle-mac` and unpack the TAR file into the `tanzu` directory:
    ```
    tar -xvf tanzu-framework-darwin-amd64.tar -C $HOME/tanzu
    ```

6.  Install the Tanzu CLI from the `tanzu` directory by running:
    ```
    cd $HOME/tanzu
    sudo install cli/core/v0.5.0/tanzu-core-darwin_amd64 /usr/local/bin/tanzu
    ```

7. Confirm the installation of the Tanzu CLI by running:
   ```
   tanzu version
   ```
**If you see the following warning when running `tanzu version` on macOS:** 
```
"tanzu" cannot be opened because the developer cannot be verified
```

To resolve this error, do the following:
  1. Click the Cancel button in the macOS prompt window.
  2. Open the “Security & Privacy” control panel from System Preferences.
  3. Click on the “General” tab.
  4. Click “Allow Anyway” next to the warning message for the tanzu binary.
  5. Enter your system username and password in the macOS prompt window to confirm the changes.
  6. Execute the `tanzu version` command in the term window again.
  7. Click “Open” in the macOS prompt window.

After completing the steps above, there should be no more security issues while running Tanzu CLI commands.

## <a id='windows-cli'></a> Windows: Install the Tanzu CLI

To install the Tanzu CLI on a Windows operating system:

1. Create a local directory called `tanzu-bundle`.

2. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

3. Navigate to [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/) on Tanzu Network.

4. Click on the `tanzu-cli-0.5.0` folder.

5. Download `tanzu-framework-bundle-windows` and unpack the TAR files into the `tanzu-bundle` directory.

5. Create a new `Program Files\tanzu` folder.

6. In the unpacked CLI folder tanzu-bundle, locate and copy the `core/v0.5.0/tanzu-core-windows_amd64.exe`
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
## <a id='update-cli'></a> Update the Tanzu CLI

If you have any earlier version of the Tanzu CLI installed,
do the following before you install the plugins.
For instructions on installing plugins, see [Install the Tanzu CLI Plugins](#install-the-tanzu-cli-plugins).

To remove plugins from earlier versions of the Tanzu CLI:

1. Create a directory named `tanzu`.

2. Navigate to [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/) on Tanzu Network.

3. Click the `tanzu-cli-0.5.0` folder. 

4.  Download `tanzu-framework-bundle-*` for your operating system and unpack the TAR file
    into the `tanzu` directory.

3.  Set the environment variable `TANZU_CLI_NO_INIT` by running:

     ```
     export TANZU_CLI_NO_INIT=true
     ```

 4.  Run this command to make sure the default plugin repo points to the right path:
    ```
    tanzu plugin repo update -b tanzu-cli-framework core
    ```

5.  Remove existing plugins from any previous CLI installations.
    ```
    tanzu plugin clean
    ```

## Install the Tanzu CLI Plugins

After you have installed the tanzu core executable, you must install package, imagepullsecret, apps and app-accelerator CLI plugins.

1. Navigate to the tanzu folder that contains the cli folder.

2. Run the following command from the tanzu directory to install all the plugins for this release.
    ```
    tanzu plugin install --local cli all
    ```
3. Check plugin installation status.
    ```
    tanzu plugin list
    ```
    The versions should mostly reflect the downloaded file version numbers (not all plugins are going to match the exact same download version - i.e. `v0.5.0` below). For example:
    ```
    tanzu plugin list
    NAME                LATEST VERSION  DESCRIPTION                                                                                                                                         REPOSITORY  VERSION  STATUS
    accelerator                         Manage accelerators in a Kubernetes cluster                                                                                                                     v0.3.0   installed
    apps                                Applications on Kubernetes                                                                                                                                      v0.2.0   installed
    cluster                             Kubernetes cluster operations                                                                                                                                   v0.5.0   installed
    imagepullsecret                     Manage image pull secret operations. Image pull secrets enable the package and package repository consumers to authenticate to private registries.              v0.5.0   installed
    kubernetes-release                  Kubernetes release operations                                                                                                                                   v0.5.0   installed
    login                               Login to the platform                                                                                                                                           v0.5.0   installed
    management-cluster                  Kubernetes management cluster operations                                                                                                                        v0.5.0   installed
    package                             Tanzu package management                                                                                                                                        v0.5.0   installed
    pinniped-auth                       Pinniped authentication operations (usually not directly invoked)                                                                                               v0.5.0   installed
    ```
  
**A note regarding the installed plugins:**
The `package`, `imgpullsecret`, `accelerator`, and `apps` plugins will be used to install and/or interact with the Tanzu Application Platform.
    
The installation of this beta product requires cluster-admin privileges. There are additional plugin/commands included with the Tanzu CLI which could have unintended side-effects. For the purposes of installing this beta, VMware recommends against running commands for the following CLI plugins: `cluster`, `kubernetes-release`, `login`, `management-cluster`, and `pinniped-auth`.

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

  ![Screenshot of page on Tanzu Network from where you download Tanzu Application Platform packages shows the EULA warning](./images/tap-on-tanzu-net.png)

##<a id='cli-and-plugin'></a> Install the Tanzu CLI and Package Plugin

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

7. From the `tanzu` directory, install the package plugin by running:
   ```
   tanzu plugin install --local ./cli package
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

7. From the `tanzu` directory, install the package plugin by running:
   ```
   tanzu plugin install --local ./cli package
   ```

8. Confirm the installation of the Tanzu CLI package plugin by running:
   ```
   tanzu package version
   ```

### <a id='windows-cli'></a> Windows: Install the Tanzu CLI and Package Plugin

To install the Tanzu CLI and package plugin on a Windows operating system:

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

14. From the command prompt, navigate to the `tanzu-bundle` directory that contains the package plugin,
    and install the plugin by running:

    ```
    tanzu plugin install --local .\cli package
    ```

15. Confirm the installation of the Tanzu CLI by running:
    ```
    tanzu package version
    ```


# Accepting TAP EULAs, installing Cluster Essentials and the Tanzu CLI

This page describes how to:
  * [Accept TAP EULAs](#accept-eulas)
  * [Set Kubernetes cluster context](#cluster-context)
  * [Install Cluster Essentials for Tanzu](#tanzu-cluster-essentials)
  * [Install or Update the Tanzu CLI and plug-ins](#cli-and-plugin)

## Accept the End User License Agreements<a id="accept-eulas"></a> 

Before downloading and installing TAP packages, you must accept the End User License Agreements (EULAs) as follows:

1. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

2. Accept or confirm that you have accepted the EULAs for each of the following:

    - [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/)
    - [Cluster Essentials for VMware Tanzu](https://network.tanzu.vmware.com/products/tanzu-cluster-essentials/)
    - [Tanzu Build Service Dependencies](https://network.tanzu.vmware.com/products/tbs-dependencies/)
    - [Buildpacks for VMware Tanzu](https://network.tanzu.vmware.com/products/tanzu-buildpacks-suite)
    - [Stacks for VMware Tanzu](https://network.tanzu.vmware.com/products/tanzu-stacks-suite)


****************
**Here's an example of how to accept the EULA for *Tanzu Application Platform***

1. Go to [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/)
1. Select the ***Click here to sign the EULA*** link in the yellow warning box\* under the release drop down as seen in the screen shot below
   
   \*Note: If the yellow warning box is not visible, the EULA has already been accepted.
   
   ![EULA Warning](images/install-tanzu-cli-eulas1.png)
1. Select ***Agree*** in the bottom right of the modal dialog box as seen in the screen shot below

    ![EULA Dialog Box](images/install-tanzu-cli-eulas2.png)
    
1. If you followed the steps above, you have accepted the EULA for Tanzu Application Platform
1. You must now accept the EULAs for 
   - [Cluster Essentials for VMware Tanzu](https://network.tanzu.vmware.com/products/tanzu-cluster-essentials/)
   - [Tanzu Build Service Dependencies](https://network.tanzu.vmware.com/products/tbs-dependencies/)
   - [Buildpacks for VMware Tanzu](https://network.tanzu.vmware.com/products/tanzu-buildpacks-suite)
   - [Stacks for VMware Tanzu](https://network.tanzu.vmware.com/products/tanzu-stacks-suite)


## <a id='cluster-context'></a> Set Kubernetes cluster context

To set the Kubernetes cluster context:

1. List the existing contexts by running:

    ```console
    kubectl config get-contexts
    ```

    For example:

    ```console
    $ kubectl config get-contexts
    CURRENT   NAME                                CLUSTER           AUTHINFO                                NAMESPACE
            aks-repo-trial                      aks-repo-trial    clusterUser_aks-rg-01_aks-repo-trial
    *       aks-tap-cluster                     aks-tap-cluster   clusterUser_aks-rg-01_aks-tap-cluster

    ```

2.  Set the context to the cluster that you want to use for the Tanzu Application Platform packages install.
    For example, set the context to the `aks-tap-cluster` context by running:

    ```console
    kubectl config use-context aks-tap-cluster
    ```

    For example:

    ```console
    $ kubectl config use-context aks-tap-cluster
    Switched to context "aks-tap-cluster".
    ```

## <a id='tanzu-cluster-essentials'></a> Install Cluster Essentials for Tanzu

[Cluster Essentials for VMware Tanzu](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/index.html)
simplifies the process of installing the open-source [Carvel](https://carvel.dev) tools on your cluster.
It includes a script to download and install supported versions of kapp-controller and
secretgen-controller on the target cluster.
It also installs the kapp, imgpkg, ytt, and kbld CLIs on your local machine.
Currently, Cluster Essentials only supports macOS and Linux.

If you are using a VMware Tanzu Kubernetes Grid cluster, you don't need to install Cluster Essentials
because the contents of Cluster Essentials are already installed on your cluster.

To install Cluster Essentials, see [Deploying Cluster Essentials](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/1.1/cluster-essentials/GUID-deploy.html).


## Install or update the Tanzu CLI and plug-ins <a id='cli-and-plugin'></a><a id='install-tanzu-cli'></a>

You'll use the Tanzu CLI and plugins to install and exercise the Tanzu Application Platform functions and features.

The installation steps are below:
1. Sign in to [Tanzu Network](https://network.tanzu.vmware.com)
1. Load the [TAP Release v1.1.0 > tanzu-cli-v0.11.2 download tile](https://network.pivotal.io/products/tanzu-application-platform/#/releases/1078790/file_groups/7867)
1. Click & download the Tanzu Framework Bundle for your OS
1. Create a `$HOME/tanzu` directory (Linux/macOS) or `Program Files\tanzu` folder (Windows) on your computer
1. Click the appropriate OS below to finish the installation:
   * [Linux or macOS](#linux-mac-tanzu-cli)
   * [Windows](#windows-tanzu-cli)

*********************
(Optional) To uninstall a previous version of the Tanzu CLI, its plug-ins and associated files, follow [**these directions**](uninstall.md#remove-tanzu-cli).
*********************

#### Install Tanzu CLI: Linux or macOS<a id='linux-mac-tanzu-cli'></a> 

1. Unpack the downloaded TAR file into the `$HOME/tanzu` directory:

    ```console
    tar -xvf tanzu-framework-linux-amd64.tar -C $HOME/tanzu
    ```

1. Set the environment variable `TANZU_CLI_NO_INIT` to `true` to ensure the local downloaded versions of
the CLI core and plug-ins are installed:

    ```console
    export TANZU_CLI_NO_INIT=true
    ```

1. Install/update the CLI core:
   * **Linux:**

     ```console
     cd $HOME/tanzu
     VERSION=v0.11.2 sudo install cli/core/$VERSION/tanzu-core-linux_amd64 /usr/local/bin/tanzu
     ```
   * **macOS:**

     ```console
     cd $HOME/tanzu
     VERSION=v0.11.2 install cli/core/$VERSION/tanzu-core-darwin_amd64 /usr/local/bin/tanzu
      ```

1. Confirm the install:

    ```console
    tanzu version
    ```

    Expect: 
    
    ```
    version: v0.11.2
    ...
    ```

1. [Install Tanzu CLI plug-ins](#cli-plugin-install)


#### Install Tanzu CLI: Windows<a id='windows-tanzu-cli'></a>

1. Unpack the downloaded TAR file into the `Program Files\tanzu` directory

1. From the `Program Files\tanzu` directory, move and rename the executable from

    ```console
    Program Files\tanzu\core\v0.11.2\tanzu-core-windows_amd64.exe
    ```
    **TO**
    ```console
    Program Files\tanzu\tanzu.exe
    ```

1. From the `Program Files` directory, right-click the `tanzu` folder and select **Properties > Security** (make sure that your user
account has the **Full Control** permission)

1. Use Windows Search to search for `env`

1. Select **Edit the system environment variables** and click **Environment Variables**

1. Select the **Path** row under **System variables** and click **Edit**

1. Click **New** to add a new row and enter the path to **tanzu.exe**

1. Set the environmental variable `TANZU_CLI_NO_INIT` to `true`

1. From the terminal in the `Program Files\tanzu` directory, confirm the install:

   ```console
   tanzu version
   ```

   Expect: 
    
   ```
   version: v0.11.2
   ...
   ```

1. [Install Tanzu CLI plug-ins](#cli-plugin-install)

## Install Tanzu CLI Plug-ins <a id='cli-plugin-install'></a> 

To perform a clean installation of the Tanzu CLI plug-ins:

1. Install plugins from the `$HOME/tanzu` directory (Linux/macOS) or `Program Files\tanzu` folder (Windows):

    ```console
    tanzu plugin install --local cli all
    ```

1. Confirm the plugin install:

    ```console
    tanzu plugin list
    ```

    Expect:

   ```console
    NAME                DESCRIPTION                                                                   SCOPE       DISCOVERY             VERSION      STATUS
    login               Login to the platform                                                         Standalone  default               v0.11.1      not installed
    management-cluster  Kubernetes management-cluster operations                                      Standalone  default               v0.11.1      not installed
    package             Tanzu package management                                                      Standalone  default               v0.11.1      installed
    pinniped-auth       Pinniped authentication operations (usually not directly invoked)             Standalone  default               v0.11.1      not installed
    secret              Tanzu secret management                                                       Standalone  default               v0.11.1      installed
    services            Discover Service Types, Service Instances and manage Resource Claims (ALPHA)  Standalone                        v0.2.0-rc.1  installed
    accelerator         Manage accelerators in a Kubernetes cluster                                   Standalone                        v1.1.0       installed
    apps                Applications on Kubernetes                                                    Standalone                        v0.5.0       installed
    insight             post & query image, package, source, and vulnerability data                   Standalone                        v1.1.0       installed
   ```

* **Note:** Currently, `insight` plug-in only supports macOS and Linux.

You can now proceed with installing Tanzu Application Platform. For more information, see
**[Installing the Tanzu Application Platform Package and Profiles](install.md)**.

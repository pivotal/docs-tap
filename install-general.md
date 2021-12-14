# Installing Part I: prerequisites, EULA, and CLI

This document describes the first part of the installation process for Tanzu Application Platform:

+ [Prerequisites](#prereqs)
+ [Accept the EULAs](#eulas)
+ [Install or Update the Tanzu CLI and Plugins](#cli-and-plugin)


## <a id='prereqs'></a>Prerequisites

The following are required to install Tanzu Application Platform:

### Tanzu Network and container image registry requirements

Installation requires:

* A [Tanzu Network](https://network.tanzu.vmware.com/) account to download
Tanzu Application Platform packages.

* A container image registry, such as [Harbor](https://goharbor.io/) or
[Docker Hub](https://hub.docker.com/) with at least **10&nbsp;GB** of available storage for
application images, base images, and runtime dependencies.
When available, VMware recommends using a paid registry account to avoid potential rate-limiting associated with some free registry offerings.

* Registry credentials with push and write access made available to Tanzu Application Platform to
store images.

* Network access to https://registry.tanzu.vmware.com

* Network access to your chosen container image registry.

* Latest version of Chrome, Firefox, or Edge.
Tanzu Application Platform GUI currently does not support Safari browser.

#### Tanzu Application Platform GUI

- Git repository for the Tanzu Application Platform GUI's software catalogs, along with a token allowing read access.
  Supported Git infrastructure includes:
    - GitHub
    - GitLab
    - Azure DevOps
- Tanzu Application Platform GUI Blank Catalog from the Tanzu Application section of Tanzu Network
  - To install this, navigate to [Tanzu Network](https://network.tanzu.vmware.com/) and select the Tanzu Application Platform. Under the list of available files to download, there will be a folder titled `tap-gui-catalogs`. Inside that folder is a compressed archive titled `Tanzu Application Platform Blank Catalog`. You'll need to extract that catalog to the preceding Git repository of choice. This serves as the configuration location for your Organization's Catalog inside Tanzu Application Platform GUI.
  - The Tanzu Application Platform GUI catalog allows for two approaches towards storing catalog information:
        - The default option uses an in-memory database and is suitable for test and development scenarios.
          This reads the catalog data from Git URLs that you specify in the `tap-values.yml` file.
          This data is ephemeral and any operations that cause the `server` pod in the `tap-gui` namespace to be re-created
          also cause this data to be rebuilt from the Git location.
          This can cause issues when you manually register entities through the UI because
          they only exist in the database and are lost when that in-memory database gets rebuilt.
            - For production use-cases, use a PostgreSQL database that exists outside the Tanzu Application Platform's packaging.
          This stores all the catalog data persistently both from the Git locations and from the GUI's manual entity registrations.

### Kubernetes cluster requirements
Installation requires:

* Kubernetes cluster v1.19 or later on one of the following Kubernetes providers:

    * Azure Kubernetes Service
    * Amazon Elastic Kubernetes Service
    * Google Kubernetes Engine
        * GKE Autopilot clusters do not have required features enabled
    * Kind
        * Supported only on Linux operating system.
        * Minimum requirements: 8 CPUs for i9 or equivalent, 12 CPUs for i7 or equivalent, 8 GB RAM (12+ GB recommended), and 120 GB disk space.
        * If you are using Cloud Native Runtimes, see [Configure Your Local Kind
        Cluster](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/1.0/tanzu-cloud-native-runtimes-1-0/GUID-local-dns.html#config-cluster).
        * Because Kind doesn't support LoadBalancer, make sure to use NodePort when defining service types.
    * Minikube
        * Minimum requirements for VM: 8 CPUs for i9 or equivalent, 12 CPUs for i7 or equivalent, 8 GB RAM (12+ GB recommended), and 120 GB disk space.
        * VMware recommends at least 16 GB of total host memory.
        * On MacOS only Hyperkit driver is supported; Docker driver is not supported.
   * Tanzu Kubernetes Grid v1.4
        * Do not use a Tanzu Kubernetes Grid cluster that runs production workloads.
        * To install Tanzu Application Platform on Tanzu Kubernetes Grid v1.4,
          see [Installing with Tanzu Kubernetes Grid v1.4](install-tkg.md).
   * Tanzu Community Edition v0.9.1
        * Visit the Tanzu Community Edition installation page to follow installation instructions at [Tanzu Community Edition](install-tce.md)

    To deploy all Tanzu Application Platform packages, your cluster must have at least **8&nbsp;GB** of RAM across all nodes available to Tanzu Application Platform. At least 8 CPUs for i9 or equivalent or 12 CPUs for i7 or equivalent must be available to Tanzu Application Platform components.
    VMware recommends that at least **16&nbsp;GB** of RAM is available to build and deploy applications, including for Kind and Minikube.

    Your cluster must support the creation of Services of type `LoadBalancer` to install Cloud Native Runtimes package. The exception is [`provider: local` installation](#install-cnr), which removes container replication and uses `NodePort` Services for HTTP ingress. For information about services of type `LoadBalancer`, see the [Kubernetes documentation](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer) and your cloud provider documentation. For information about Tanzu Kubernetes Grid support for Service type `LoadBalancer`, see [Install VMware NSX Advanced Load Balancer on a vSphere Distributed Switch](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/1.3/vmware-tanzu-kubernetes-grid-13/GUID-mgmt-clusters-install-nsx-adv-lb.html).

    Your cluster must also have at least **70&nbsp;GB** of disk per node.

* [Pod Security Policies](https://kubernetes.io/docs/concepts/policy/pod-security-policy/)
must be configured so that Tanzu Application Platform controller
pods can run as root.

### Tools and CLI requirements
Installation requires:

* The Kubernetes CLI, kubectl, v1.19, v1.20 or v1.21, installed and authenticated with administrator rights for your target cluster. See [Install Tools](https://kubernetes.io/docs/tasks/tools/) in the Kubernetes documentation.

* To set the Kubernetes cluster context:

    1. List the existing contexts by running:

        ```
        kubectl config get-contexts
        ```

        For example:

        ```
        $ kubectl config get-contexts
        CURRENT   NAME                                CLUSTER           AUTHINFO                                NAMESPACE
                aks-repo-trial                      aks-repo-trial    clusterUser_aks-rg-01_aks-repo-trial
        *       aks-tap-cluster                     aks-tap-cluster   clusterUser_aks-rg-01_aks-tap-cluster
                tkg-mgmt-vc-admin@tkg-mgmt-vc       tkg-mgmt-vc       tkg-mgmt-vc-admin
                tkg-vc-antrea-admin@tkg-vc-antrea   tkg-vc-antrea     tkg-vc-antrea-admin
        ```

    2.  Set the context to the cluster that you want to use for the Tanzu Application Platform packages install.
        For example set the context to the `aks-tap-cluster` context by running:

        ```
        kubectl config use-context aks-tap-cluster
        ```

        For example:

        ```
        $ kubectl config use-context aks-tap-cluster
        Switched to context "aks-tap-cluster".
        ```


## <a id="eulas"></a> Accept the EULAs

Before you can install packages, you have to accept the End User License Agreements (EULAs).

To accept EULAs:

1. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

2. For each of the following components, accept or confirm that you have accepted the EULA:

    + [Cluster Essentials for VMware Tanzu](https://network.tanzu.vmware.com/products/tanzu-cluster-essentials/#/releases/1011100)
    + [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/)
    + [Tanzu Build Service](https://network.tanzu.vmware.com/products/build-service/) and its associated components:
      + [Tanzu Build Service Dependencies](https://network.tanzu.vmware.com/products/tbs-dependencies/)
      + [Buildpacks for VMware Tanzu](https://network.tanzu.vmware.com/products/tanzu-buildpacks-suite)
      + [Stacks for VMware Tanzu](https://network.tanzu.vmware.com/products/tanzu-stacks-suite)

## <a id='tanzu-cluster-essentials'></a> Install Cluster Essentials for VMware Tanzu

If you are operating a Tanzu Kubernetes Grid or Tanzu Community Edition cluster, the Cluster Essentials are already installed.

For other Kubernetes providers, follow the steps below:

1. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

3. Navigate to [Cluster Essentials for VMware Tanzu](https://network.tanzu.vmware.com/products/tanzu-cluster-essentials/) on Tanzu Network.

4. Download `tanzu-cluster-essentials-darwin-amd64-1.0.0.tgz` (for OS X) or `tanzu-cluster-essentials-linux-amd64-1.0.0.tgz` (for Linux)
   and unpack the TAR file into `tanzu-cluster-essentials` directory:

    ```
    mkdir $HOME/tanzu-cluster-essentials
    tar -xvf tanzu-cluster-essentials-darwin-amd64-1.0.0.tgz -C $HOME/tanzu-cluster-essentials
    ```

5. Configure and run `install.sh`, which installs kapp-controller and secretgen-controller on your cluster:

    ```
    export INSTALL_BUNDLE=registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:82dfaf70656b54dcba0d4def85ccae1578ff27054e7533d08320244af7fb0343
    export INSTALL_REGISTRY_HOSTNAME=registry.tanzu.vmware.com
    export INSTALL_REGISTRY_USERNAME=TANZU-NET-USER
    export INSTALL_REGISTRY_PASSWORD=TANZU-NET-PASSWORD
    cd $HOME/tanzu-cluster-essentials
    ./install.sh
    ```

    Where `TANZU-NET-USER` and `TANZU-NET-PASSWORD` are your credentials for Tanzu Network.

6. Install the `kapp` CLI onto your `$PATH`:

    ```
    sudo cp $HOME/tanzu-cluster-essentials/kapp /usr/local/bin/kapp
    ```

## <a id='cli-and-plugin'></a> Install or update the Tanzu CLI and plugins

Choose the install scenario that is right for you:

   + [Instructions for a clean install of Tanzu CLI](#tanzu-cli-clean-install)
   + [Instructions for updating Tanzu CLI that was installed for a previous Tanzu Application Platform release](#udpate-previous-tap-tanzu-cli)
   + [Instructions for updating Tanzu CLI that was previously installed for Tanzu Kubernetes Grid and/or Tanzu Community Edition](#udpate-tkg-tce-tanzu-cli)  


### <a id='tanzu-cli-clean-install'></a> Clean install Tanzu CLI

To perform a clean installation of Tanzu CLI:

1. If applicable, uninstall Tanzu CLI, plug-ins, and associated files by following the steps in
[Remove Tanzu CLI, plug-ins, and associated files](uninstall.md#remove-tanzu-cli).

1. Follow the procedure for your operating system:

    + [Linux: Install the Tanzu CLI](#linux-cli)
    + [Mac: Install the Tanzu CLI](#mac-cli)
    + [Windows: Install the Tanzu CLI](#windows-cli)


#### <a id='linux-cli'></a> Linux: Install the Tanzu CLI

To install the Tanzu CLI on a Linux operating system:

1. Create a directory named `tanzu`:
    ```
    mkdir $HOME/tanzu
    ```

2. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

3. Navigate to [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/) on Tanzu Network.

4. Click the `tanzu-cli-0.12.0` folder.

5. Download `tanzu-framework-bundle-linux` and unpack the TAR file into the `tanzu` directory:
    ```
    tar -xvf tanzu-framework-linux-amd64.tar -C $HOME/tanzu
    ```

6. Install the CLI core:
    ```
    cd $HOME/tanzu
    sudo install cli/core/v0.12.0/tanzu-core-linux_amd64 /usr/local/bin/tanzu
    ```

7. Confirm installation of the CLI core:
   ```
   tanzu version
   ```
   Expect `version: v0.12.0`

8. Proceed to [Instructions for a clean install of Tanzu CLI Plugins](#cli-plugin-clean-install).


#### <a id='mac-cli'></a>MacOS: Install the Tanzu CLI

To install the Tanzu CLI on a Mac operating system:

1. Create a directory named `tanzu`:
    ```
    mkdir $HOME/tanzu
    ```

2. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

3. Navigate to [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/) on Tanzu Network.

4. Click the `tanzu-cli-0.12.0` folder.

5. Download `tanzu-framework-bundle-mac` and unpack the TAR file into the `tanzu` directory:
    ```
    tar -xvf tanzu-framework-darwin-amd64.tar -C $HOME/tanzu
    ```

6.  Install the CLI core:
    ```
    cd $HOME/tanzu
    install cli/core/v0.12.0/tanzu-core-darwin_amd64 /usr/local/bin/tanzu
    ```

7. Confirm installation of the CLI core:
   ```
   tanzu version
   ```
   Expect `version: v0.12.0`

   If you see the following warning when running `Tanzu version` on macOS:
   ```
   "tanzu" cannot be opened because the developer cannot be verified
   ```

   To resolve this error, do the following:

   1. Click **Cancel** in the macOS prompt window.

   2. Open the **Security & Privacy** control panel from **System Preferences**.

   3. Click **General**.

   4. Click **Allow Anyway** next to the warning message for the Tanzu binary.

   5. Enter your system username and password in the macOS prompt window to confirm the changes.

   6. Execute the `Tanzu version` command in the terminal window again.

   7. Click **Open** in the macOS prompt window. After completing the steps above, there should be no more security issues while running Tanzu CLI commands.

   8. Proceed to [Instructions for a clean install of Tanzu CLI Plugins](#cli-plugin-clean-install).


#### <a id='windows-cli'></a>Windows: Install the Tanzu CLI

To install the Tanzu CLI on a Windows operating system:

  1. Create a directory called `tanzu-bundle`.

  2. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

  3. Navigate to [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/) on Tanzu Network.

  4. Click the `tanzu-cli-0.12.0` folder.

  5. Download `tanzu-framework-bundle-windows` and unpack the TAR files into the `tanzu-bundle` directory.

  6. Create a new `Program Files\tanzu` folder.

  7. In the unpacked CLI folder tanzu-bundle, locate and copy the `core/v0.12.0/tanzu-core-windows_amd64.exe`
     into the new `Program Files\tanzu` folder.

  8. Rename `tanzu-core-windows_amd64.exe` to `tanzu.exe`.

  9. Right-click the `tanzu` folder, select **Properties > Security**,
     and make sure that your user account has the **Full Control** permission.

  10. Use Windows Search to search for `env`.

  11. Select **Edit the system environment variables**, and click **Environment Variables**.

  12. Select the **Path** row under **System variables**, and click **Edit**.

  13. Click **New** to add a new row, and enter the path to the Tanzu CLI.

  14. From the `tanzu` directory, confirm the installation of the Tanzu CLI by running the following in a terminal window:
      ```
      tanzu version
      ```
      Expect `version: v0.12.0`

  15. Proceed to [Clean Install Tanzu CLI Plugins](#cli-plugin-clean-install)

## <a id='cli-plugin-clean-install'></a> Clean install Tanzu CLI plugins

To perform a clean installation of the Tanzu CLI plugins:

1. Disable the **context-aware CLI for plugins** feature so that the downloaded plugins
   can be installed without errors:

   ```
   tanzu config set features.global.context-aware-cli-for-plugins false
   ```

2. Install the local versions of the plugins you downloaded:

    ```
    tanzu plugin install --local cli all
    ```

3. Check the plugin installation status:

    ```
    tanzu plugin list
    ```

    Expect to see the following:

    ```
    tanzu plugin list
    NAME                LATEST VERSION  DESCRIPTION                                                        REPOSITORY  VERSION  STATUS
    accelerator                         Manage accelerators in a Kubernetes cluster                                    v0.5.0   installed
    apps                                Applications on Kubernetes                                                     v0.3.0   installed
    cluster             v0.12.0         Kubernetes cluster operations                                      core        v0.12.0  installed
    kubernetes-release  v0.12.0         Kubernetes release operations                                      core        v0.12.0  installed
    login               v0.12.0         Login to the platform                                              core        v0.12.0  installed
    management-cluster  v0.12.0         Kubernetes management cluster operations                           core        v0.12.0  installed
    package             v0.12.0         Tanzu package management                                           core        v0.12.0  installed
    pinniped-auth       v0.12.0         Pinniped authentication operations (usually not directly invoked)  core        v0.12.0  installed
    secret              v0.12.0         Tanzu secret management                                            core        v0.12.0  installed
    services                            Discover Service Types and manage Service Instances (ALPHA)                    v0.1.0   installed
    ```

    Ensure that you have the `package`, `secret`, `accelerator`, `services`, and `apps` plugins.
    You need these plugins to install and interact with the Tanzu Application Platform.

    Tanzu Application Platform beta requires cluster-admin privileges.
    Running commands associated with the additional plugins can have unintended side-effects.
    VMware recommends against running `cluster`, `kubernetes-release`, `login`, `management-cluster`,
    and `pinniped-auth` commands.

You can now proceed with installing Tanzu Application Platform. For more information, see
**[Installing Part II: Profiles](install.md)**.


## <a id='udpate-previous-tap-tanzu-cli'></a>Instructions for updating Tanzu CLI that was installed for a previous release of Tanzu Application Platform

If you have an earlier version of the Tanzu CLI on your local machine,
then follow this procedure instead of the preceeding clean install procedure:

  1. If a directory called `tanzu` does not exist, create one:

     ```
     mkdir $HOME/tanzu
     ```

  2. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

  3. Navigate to [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/)
on Tanzu Network.

  4. Click the **tanzu-cli-0.12.0** directory.

  5. Download the CLI bundle corresponding with your operating system. For example, if your client
operating system is Linux, download the `tanzu-framework-linux-amd64.tar` bundle.

  6. If they exist, delete any CLI files from a previous install:
     ```
     rm -rf $HOME/tanzu/cli
     ```

  7. Unpack the TAR file in the `tanzu` directory:

     ```
     tar -xvf tanzu-framework-linux-amd64.tar -C $HOME/tanzu
     ```

  8. Navigate to the `tanzu` directory:

     ```
     cd $HOME/tanzu
     ```

  9. Set env var `TANZU_CLI_NO_INIT` to true to install the local plugin versions you've just downloaded:

     ```
     export TANZU_CLI_NO_INIT=true
     ```

  10. List the plugins to find out if the `imagepullsecret` plugin if it was previously installed,
      and if it was installed delete it:

      ```
      tanzu plugin list
      tanzu plugin delete imagepullsecret
      ```

  11. Remove previously installed plugin binaries:

      ```
      rm -rf ~/Library/Application\ Support/tanzu-cli/*
      ```

  12. Check to see what version of the Tanzu CLI core is currently installed:

      ```
      tanzu version
      ```

  13. If the version returned is `v0.10.0` or later,
      disable the **context-aware CLI for plugins** feature so the downloaded CLI core
      and plugins can be installed without errors:

      ```
      tanzu config set features.global.context-aware-cli-for-plugins false
      ```

  14. Update the core CLI:

      ```
      tanzu update --local ./cli
      ```
      Expect to see a user prompt - submit "y"


  15. Check installation status for the core CLI:

      ```
      tanzu version
      ```
      Expect `version: v0.12.0`


  16. If the version returned in step 12 above is earlier than `v0.10.0`,
      disable the **context-aware CLI for plugins** feature so that the downloaded plugins
      can be installed without errors:

      ```
      tanzu config set features.global.context-aware-cli-for-plugins false
      ```

  17. Install new plugin versions:
      ```
      tanzu plugin install --local cli all
      ```

  18. Check installation status for plugins:

      ```
      tanzu plugin list
      ```

      Expect to see the following:
      ```
      tanzu plugin list
      NAME                LATEST VERSION  DESCRIPTION                                                        REPOSITORY  VERSION  STATUS
      accelerator                         Manage accelerators in a Kubernetes cluster                                    v0.5.0   installed
      apps                                Applications on Kubernetes                                                     v0.3.0   installed
      cluster             v0.12.0         Kubernetes cluster operations                                      core        v0.12.0  installed
      kubernetes-release  v0.12.0         Kubernetes release operations                                      core        v0.12.0  installed
      login               v0.12.0         Login to the platform                                              core        v0.12.0  installed
      management-cluster  v0.12.0         Kubernetes management cluster operations                           core        v0.12.0  installed
      package             v0.12.0         Tanzu package management                                           core        v0.12.0  installed
      pinniped-auth       v0.12.0         Pinniped authentication operations (usually not directly invoked)  core        v0.12.0  installed
      secret              v0.12.0         Tanzu secret management                                            core        v0.12.0  installed
      services                            Discover Service Types and manage Service Instances (ALPHA)                    v0.1.0   installed
      ```

You can now install Tanzu Application Platform.
See **[Installing Part II: Profiles](install.md)**.


## <a id='udpate-tkg-tce-tanzu-cli'></a>Instructions for updating Tanzu CLI previously installed for Tanzu Kubernetes Grid or Tanzu Community Edition

If you want to maintain the Tanzu CLI and plugins you installed previously
for interacting with Tanzu Kubernetes Grid or Tanzu Community Edition, you only need to update/add the Tanzu Application Platform specific plugins as follows:

  1. Create a directory named `tanzu`:

     ```
     mkdir $HOME/tanzu
     ```
     If `tanzu` already exists, delete the files within it.

  2. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

  3. Navigate to [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/)
on Tanzu Network.

  4. Click the **tanzu-cli-0.12.0** directory.

  5. Download the CLI bundle corresponding to your operating system. For example, if your client
operating system is Linux, download the `tanzu-framework-linux-amd64.tar` bundle.

  6. Unpack the TAR file in the `tanzu` directory by running:

     ```
     tar -xvf tanzu-framework-linux-amd64.tar -C $HOME/tanzu
     ```

  7. Navigate to the `tanzu` directory by running:

     ```
     cd $HOME/tanzu
     ```

  8. Set env var `TANZU_CLI_NO_INIT` to true to install the local plugin versions you've just downloaded:

     ```
     export TANZU_CLI_NO_INIT=true
     ```

  9. Check to see if the `imagepullsecret` and `package` plugins are already installed:

     ```
     tanzu plugin list
     ```

     If either is present present, delete them:

     ```
     tanzu plugin delete imagepullsecret
     ```

     And/Or

     ```
     tanzu plugin delete package
     ```

  10. Check to see what version of the Tanzu CLI core is installed:

      ```
      tanzu version
      ```

  11. If the version returned is `v0.11.0` or later,
      disable the **context-aware CLI for plugins** feature so that the downloaded plugins
      can be installed without errors:

      ```
      tanzu config set features.global.context-aware-cli-for-plugins false
      ```

  12. Install the `secret` plugin by running:

      ```
      tanzu plugin install secret --local ./cli
      ```

  13. Install the `accelerator` plugin by running:

      ```
      tanzu plugin install accelerator --local ./cli
      ```

  14. Install the `apps` plugin by running:

      ```
      tanzu plugin install apps --local ./cli
      ```

  15. Install the updated `package` plugin by running:

      ```
      tanzu plugin install package --local ./cli
      ```


  16. Install the `services` plugin by running:

      ```
      tanzu plugin install services --local ./cli
      ```


  17. Verify that the Tanzu Application Platform plugins are present:

      ```
      tanzu plugin list
      ```

      Expect the following to be included in the list:
      ```
      tanzu plugin list
      NAME                LATEST VERSION  DESCRIPTION                                                        REPOSITORY  VERSION  STATUS
      accelerator                         Manage accelerators in a Kubernetes cluster                                    v0.5.0   installed
      apps                                Applications on Kubernetes                                                     v0.3.0   installed
      package             v0.12.0         Tanzu package management                                           core        v0.12.0  installed
      secret              v0.12.0         Tanzu secret management                                            core        v0.12.0  installed
      services                            Discover Service Types and manage Service Instances (ALPHA)                    v0.1.0   installed
      ```

You can now install Tanzu Application Platform on Tanzu Kubernetes Grid or Tanzu Community Edition.
For more information, see:

* [Installing Tanzu Application Platform on a Tanzu Community Edition v0.9.1 cluster](install-tce.html#install-tap)
* [Installing Tanzu Application Platform on a Tanzu Kubernetes Grid v1.4 cluster](install-tkg.html#install-tap)

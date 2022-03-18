# Installing the Tanzu CLI

## <a id="accept-eulas"></a> Accept the End User License Agreements

Before installing packages, you must accept the End User License Agreements (EULAs).

To accept EULAs:

1. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

2. For each of the following components, accept or confirm that you have accepted the EULA:

    - [Cluster Essentials for VMware Tanzu](https://network.tanzu.vmware.com/products/tanzu-cluster-essentials/#/releases/1011100)
    - [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/)
    - [Tanzu Build Service](https://network.tanzu.vmware.com/products/build-service/) and its associated components:
        - [Tanzu Build Service Dependencies](https://network.tanzu.vmware.com/products/tbs-dependencies/)
        - [Buildpacks for VMware Tanzu](https://network.tanzu.vmware.com/products/tanzu-buildpacks-suite)
        - [Stacks for VMware Tanzu](https://network.tanzu.vmware.com/products/tanzu-stacks-suite)


This is an example of how to accept EULAs for Tanzu Application Platform:
After signing in to Tanzu Network, select the "Click here to sign the EULA" link in the yellow warning box under the release drop down as seen in the following screen shot. (If this warning is not there then the EULA has already been  accepted).

![EULA Warning](images/install-tanzu-cli-eulas1.png)

Select "Agree" in the bottom right of the dialog box that comes up as seen in the following screen shot.

![EULA Dialog Box](images/install-tanzu-cli-eulas2.png)

This example shows that you have now accepted the EULAs for Tanzu Application Platform. In addition, you must accept the EULAs for Cluster Essentials for VMware Tanzu and for Tanzu Build Services and its associated components as stated above.

## <a id='install-tanzu-cli'></a> Installing the Tanzu CLI

This document describes how to [Set Kubernetes cluster context](#cluster-context),
[Install Cluster Essentials for VMware Tanzu](#tanzu-cluster-essentials),
and [Install or Update the Tanzu CLI and plug-ins](#cli-and-plugin) for Tanzu Application Platform:

## <a id='cluster-context'></a> Set Kubernetes cluster context

To set the Kubernetes cluster context:

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

    ```

2.  Set the context to the cluster that you want to use for the Tanzu Application Platform packages install.
    For example, set the context to the `aks-tap-cluster` context by running:

    ```
    kubectl config use-context aks-tap-cluster
    ```

    For example:

    ```
    $ kubectl config use-context aks-tap-cluster
    Switched to context "aks-tap-cluster".
    ```

## <a id='tanzu-cluster-essentials'></a> Install Cluster Essentials for VMware Tanzu

> **Note:** If you use Tanzu Kubernetes Grid (TKG) multi-cloud v1.5.1 or later, skip this section.
> Clusters on TKG v1.5.1 or later do not require Cluster Essentials for VMware Tanzu.

The Cluster Essentials for VMware Tanzu package simplifies the process of installing the open-source [Carvel](https://carvel.dev) tools on your cluster.
It includes a script that uses the Carvel CLI tools to download and install the server-side components `kapp-controller` and `secretgen-crontroller` on the targeted cluster.
Currently, only MacOS and Linux are supported for Cluster Essentials for VMware Tanzu.

To install cluster essentials for VMware Tanzu:

1. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

1. Navigate to [Cluster Essentials for VMware Tanzu](https://network.tanzu.vmware.com/products/tanzu-cluster-essentials/) on VMware Tanzu Network.

1. If using macOS, download `tanzu-cluster-essentials-darwin-amd64-1.0.0.tgz`.
If using Linux, download `tanzu-cluster-essentials-linux-amd64-1.0.0.tgz`.

1. Unpack the TAR file into the `tanzu-cluster-essentials` directory by running:

    ```
    mkdir $HOME/tanzu-cluster-essentials
    tar -xvf DOWNLOADED-CLUSTER-ESSENTIALS-PACKAGE -C $HOME/tanzu-cluster-essentials
    ```

    Where `DOWNLOADED-CLUSTER-ESSENTIALS-PACKAGE` is the cluster essentials package you
    downloaded.

1. Configure and run `install.sh`, which installs kapp-controller and secretgen-controller on your cluster:

    ```
    export INSTALL_BUNDLE=registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:82dfaf70656b54dcba0d4def85ccae1578ff27054e7533d08320244af7fb0343
    export INSTALL_REGISTRY_HOSTNAME=registry.tanzu.vmware.com
    export INSTALL_REGISTRY_USERNAME=TANZU-NET-USER
    export INSTALL_REGISTRY_PASSWORD=TANZU-NET-PASSWORD
    cd $HOME/tanzu-cluster-essentials
    ./install.sh
    ```

    Where `TANZU-NET-USER` and `TANZU-NET-PASSWORD` are your credentials for
    VMware Tanzu Network.

1. Install the `kapp` CLI onto your `$PATH`:

    ```
    sudo cp $HOME/tanzu-cluster-essentials/kapp /usr/local/bin/kapp
    ```

1. Install the `imgpkg` CLI onto your `$PATH`:

    ```
    sudo cp $HOME/tanzu-cluster-essentials/imgpkg /usr/local/bin/imgpkg
    ```

## <a id='cli-and-plugin'></a> Install or update the Tanzu CLI and plug-ins

Choose the install scenario that is right for you:

   + [Cleanly Install Tanzu CLI](#tanzu-cli-clean-install)
   + [Updating Tanzu CLI Installed for a Previous Tanzu Application Platform Release](#update-prev-tap-tanzu-cli)


### <a id='tanzu-cli-clean-install'></a> Cleanly Install Tanzu CLI

To perform a clean installation of Tanzu CLI:

1. If applicable, uninstall Tanzu CLI, plug-ins, and associated files by following the steps in
[Remove Tanzu CLI, plug-ins, and associated files](uninstall.md#remove-tanzu-cli).

1. Follow the procedure for your operating system:

    + [Linux: Install the Tanzu CLI](#linux-tanzu-cli)
    + [Mac: Install the Tanzu CLI](#mac-tanzu-cli)
    + [Windows: Install the Tanzu CLI](#windows-tanzu-cli)


#### <a id='linux-tanzu-cli'></a> Linux: Install the Tanzu CLI

To install the Tanzu CLI on a Linux operating system:

1. Create a directory named `tanzu` by running:

    ```
    mkdir $HOME/tanzu
    ```

1. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

1. Navigate to [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/) on VMware Tanzu Network.

1. Click the Tanzu CLI folder for your Tanzu Application Platform version:

    * For v1.0.2 or v1.0.1, select `tanzu-cli-v0.11.1`.
    * For v1.0.0, select `tanzu-cli-v0.10.0`.

1. Download `tanzu-framework-bundle-linux` and unpack the TAR file into the `tanzu` directory by running:

    ```
    tar -xvf tanzu-framework-linux-amd64.tar -C $HOME/tanzu
    ```

1. Set environment variable `TANZU_CLI_NO_INIT` to `true` to ensure the local downloaded versions of
the CLI core and plug-ins are installed:

    ```
    export TANZU_CLI_NO_INIT=true
    ```

1. Install the CLI core by running:

    ```
    cd $HOME/tanzu
    sudo install cli/core/VERSION/tanzu-core-linux_amd64 /usr/local/bin/tanzu
    ```

    Where `VERSION` is:

    * `v0.11.1` if you are on Tanzu Application Platform v1.0.1 or v1.0.2
    * `v0.10.0` if you are on Tanzu Application Platform v1.0.0

1. Confirm installation of the CLI core by running:

    ```
    tanzu version
    ```

    The expected output is:

    * `version: v0.11.1` for Tanzu Application Platform v1.0.1 or v1.0.2
    * `version: v0.10.0` for Tanzu Application Platform v1.0.0

1. Proceed to [Cleanly Install Tanzu CLI Plug-ins](#cli-plugin-clean-install).


#### <a id='mac-tanzu-cli'></a>Mac: Install the Tanzu CLI

To install the Tanzu CLI on macOS:

1. Create a directory named `tanzu`:

    ```
    mkdir $HOME/tanzu
    ```

1. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

1. Navigate to [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/) on VMware Tanzu Network.

1. Click the Tanzu CLI folder for your Tanzu Application Platform version:

    * For v1.0.2 or v1.0.1, select `tanzu-cli-v0.11.1`.
    * For v1.0.0, select `tanzu-cli-v0.10.0`.

1. Download `tanzu-framework-bundle-mac` and unpack the TAR file into the `tanzu` directory:

    ```
    tar -xvf tanzu-framework-darwin-amd64.tar -C $HOME/tanzu
    ```

1. Set environment variable `TANZU_CLI_NO_INIT` to `true` to ensure the local downloaded versions of
the CLI core and plug-ins are installed:

     ```
     export TANZU_CLI_NO_INIT=true
     ```

1. Install the CLI core by running:

    ```
    cd $HOME/tanzu
    install cli/core/VERSION/tanzu-core-darwin_amd64 /usr/local/bin/tanzu
    ```

    Where `VERSION` is:

    * `v0.11.1` if you are on Tanzu Application Platform v1.0.1 or v1.0.2
    * `v0.10.0` if you are on Tanzu Application Platform v1.0.0

1. Confirm installation of the CLI core by running:

    ```
    tanzu version
    ```

    The expected output is:

    * `version: v0.11.1` for Tanzu Application Platform v1.0.1 or v1.0.2
    * `version: v0.10.0` for Tanzu Application Platform v1.0.0

1. Proceed to [Cleanly Install Tanzu CLI Plug-ins](#cli-plugin-clean-install).


#### <a id='windows-tanzu-cli'></a>Windows: Install the Tanzu CLI

To install the Tanzu CLI on Windows:

1. Create a directory called `tanzu-bundle`.

1. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

1. Navigate to [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/) on Tanzu Network.

1. Click the Tanzu CLI folder for your Tanzu Application Platform version:

    * For v1.0.2 or v1.0.1, select `tanzu-cli-v0.11.1`.
    * For v1.0.0, select `tanzu-cli-v0.10.0`.

1. Download `tanzu-framework-bundle-windows` and unpack the TAR files into the `tanzu-bundle` directory.

1. Create a new `Program Files\tanzu` folder.

1. In the unpacked CLI folder `tanzu-bundle`, locate and copy

    ```
    core/VERSION/tanzu-core-windows_amd64.exe
    ```

    Where `VERSION` is:

    * `v0.11.1` if you are on Tanzu Application Platform v1.0.1 or v1.0.2
    * `v0.10.0` if you are on Tanzu Application Platform v1.0.0

1. Paste the file into the new `Program Files\tanzu` directory.

1. Rename `tanzu-core-windows_amd64.exe` as `tanzu.exe`.

1. Right-click the `tanzu` folder, select **Properties > Security**, and make sure that your user
account has the **Full Control** permission.

1. Use Windows Search to search for `env`.

1. Select **Edit the system environment variables**, and click **Environment Variables**.

1. Select the **Path** row under **System variables**, and click **Edit**.

1. Click **New** to add a new row, and enter the path to the Tanzu CLI.

1. Set the environmental variable `TANZU_CLI_NO_INIT` to `true`.

1. From the `tanzu` directory, confirm the installation of the Tanzu CLI by running the following
command in a terminal window:

    ```
    tanzu version
    ```

    The expected output is:

    * `version: v0.11.1` for Tanzu Application Platform v1.0.1 or v1.0.2
    * `version: v0.10.0` for Tanzu Application Platform v1.0.0

1. Proceed to [Cleanly Install Tanzu CLI Plug-ins](#cli-plugin-clean-install)

## <a id='cli-plugin-clean-install'></a> Cleanly Install Tanzu CLI Plug-ins

To perform a clean installation of the Tanzu CLI plug-ins:

1. If it hasn't been done already, set environment variable `TANZU_CLI_NO_INIT` to `true` to assure the locally downloaded plug-ins are installed:

    ```
    export TANZU_CLI_NO_INIT=true
    ```

2. From your `tanzu` directory, Install the local versions of the plug-ins you downloaded by running:

    ```
    cd $HOME/tanzu
    tanzu plugin install --local cli all
    ```

3. Check the plug-in installation status by running:

    ```
    tanzu plugin list
    ```

    If using Tanzu Application Platform v1.0.0, expect to see the following:

    ```
    tanzu plugin list
    NAME                LATEST VERSION  DESCRIPTION                                                        REPOSITORY  VERSION  STATUS
    accelerator                         Manage accelerators in a Kubernetes cluster                                    v1.0.0   installed
    apps                                Applications on Kubernetes                                                     v0.4.0   installed
    cluster             v0.13.1         Kubernetes cluster operations                                      core        v0.10.0  installed
    kubernetes-release  v0.13.1         Kubernetes release operations                                      core        v0.10.0  installed
    login               v0.13.1         Login to the platform                                              core        v0.10.0  installed
    management-cluster  v0.13.1         Kubernetes management cluster operations                           core        v0.10.0  installed
    package             v0.13.1         Tanzu package management                                           core        v0.10.0  installed
    pinniped-auth       v0.13.1         Pinniped authentication operations (usually not directly invoked)  core        v0.10.0  installed
    secret              v0.13.1         Tanzu secret management                                            core        v0.10.0  installed
    services                            Discover Service Types and manage Service Instances (ALPHA)                    v0.1.1   installed
    ```

    If using Tanzu Application Platform v1.0.1, expect to see the following:

    ```
    tanzu plugin list
    NAME                DESCRIPTION                                                        SCOPE       DISCOVERY  VERSION  STATUS
    login               Login to the platform                                              Standalone  default    v0.11.1  not installed
    management-cluster  Kubernetes management-cluster operations                           Standalone  default    v0.11.1  not installed
    package             Tanzu package management                                           Standalone  default    v0.11.1  installed
    pinniped-auth       Pinniped authentication operations (usually not directly invoked)  Standalone  default    v0.11.1  not installed
    secret              Tanzu secret management                                            Standalone  default    v0.11.1  installed
    accelerator         Manage accelerators in a Kubernetes cluster                        Standalone             v1.0.1   installed
    apps                Applications on Kubernetes                                         Standalone             v0.4.1   installed
    services            Discover Service Types and manage Service Instances (ALPHA)        Standalone             v0.1.1   installed
    ```

    If using Tanzu Application Platform v1.0.2, expect to see the following:

    ```
    tanzu plugin list
    NAME                DESCRIPTION                                                        SCOPE       DISCOVERY  VERSION  STATUS
    login               Login to the platform                                              Standalone  default    v0.11.1  not installed
    management-cluster  Kubernetes management-cluster operations                           Standalone  default    v0.11.1  not installed
    package             Tanzu package management                                           Standalone  default    v0.11.1  installed
    pinniped-auth       Pinniped authentication operations (usually not directly invoked)  Standalone  default    v0.11.1  not installed
    secret              Tanzu secret management                                            Standalone  default    v0.11.1  installed
    accelerator         Manage accelerators in a Kubernetes cluster                        Standalone             v1.0.1   installed
    apps                Applications on Kubernetes                                         Standalone             v0.4.1   installed
    services            Discover Service Types and manage Service Instances (ALPHA)        Standalone             v0.1.2   installed  
    ```

    Ensure that you have the `accelerator`, `apps`, `package`, `secret`, and `services` plug-ins.
    You need these plug-ins to install and interact with the Tanzu Application Platform.

    Tanzu Application Platform requires cluster-admin privileges.
    Running commands associated with the additional plug-ins can have unintended side effects.
    VMware discourages running `cluster`, `kubernetes-release`, `login`, `management-cluster`,
    and `pinniped-auth` commands.

You can now proceed with installing Tanzu Application Platform. For more information, see
**[Installing the Tanzu Application Platform Package and Profiles](install.md)**.


## <a id='update-prev-tap-tanzu-cli'></a>Updating Tanzu CLI Installed for a Previous Tanzu Application Platform Release

To update Tanzu CLI if it was installed on an earlier release of Tanzu Application Platform, follow the relevant procedure below.

### <a id='update-tap-tanzu-cli-1-0-0'></a> Updating Tanzu CLI Installed for Tanzu Application Platform v1.0.0 or v1.0.1

Follow these instructions to update the Tanzu CLI that was installed for Tanzu Application Platform
v1.0.0 or v1.0.1:

1. Uninstall Tanzu CLI, plug-ins, and associated files by following the steps in
[Remove Tanzu CLI, plug-ins, and associated files](uninstall.md#remove-tanzu-cli).

1. Perform a clean install of the Tanzu CLI by following the steps in [Cleanly Install Tanzu CLI](#tanzu-cli-clean-install) above.

1. If a directory named `tanzu` does not exist, create one by running:

    ```
    mkdir $HOME/tanzu
    ```

2. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

3. Navigate to [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/)
on Tanzu Network.

4. Click the **tanzu-cli-v0.11.1** directory.

5. Download the CLI bundle corresponding with your operating system. For example, if your client
operating system is Linux, download the `tanzu-framework-linux-amd64.tar` bundle.

6. If they exist, delete any CLI files from previous installs by running:

    ```
    rm -rf $HOME/tanzu/cli
    ```

7. Unpack the TAR file in the `tanzu` directory by running:

    ```
    tar -xvf tanzu-framework-linux-amd64.tar -C $HOME/tanzu
    ```

8. Navigate to the `tanzu` directory by running:

    ```
    cd $HOME/tanzu
    ```

9. Set environment variable `TANZU_CLI_NO_INIT` to `true` to install the local versions of the CLI core and plug-ins you've downloaded:

    ```
    export TANZU_CLI_NO_INIT=true
    ```

10. Update the core CLI by running:

    ```
    tanzu update --local ./cli
    ```
    Expect to see a user prompt - submit `y`


11. Check installation status for the core CLI by running:

    ```
    tanzu version
    ```

    Expected output: `version: v0.11.1`


12. Install new plug-in versions by running:

    ```
    tanzu plugin install --local cli all
    ```

13. Check installation status for plug-ins by running:

    ```
    tanzu plugin list
    ```

    Expect to see the following:

    ```
    tanzu plugin list
    NAME                DESCRIPTION                                                        SCOPE       DISCOVERY  VERSION  STATUS
    login               Login to the platform                                              Standalone  default    v0.11.1  not installed
    management-cluster  Kubernetes management-cluster operations                           Standalone  default    v0.11.1  not installed
    package             Tanzu package management                                           Standalone  default    v0.11.1  installed
    pinniped-auth       Pinniped authentication operations (usually not directly invoked)  Standalone  default    v0.11.1  not installed
    secret              Tanzu secret management                                            Standalone  default    v0.11.1  installed
    accelerator         Manage accelerators in a Kubernetes cluster                        Standalone             v1.0.1   installed
    apps                Applications on Kubernetes                                         Standalone             v0.4.1   installed
    services            Discover Service Types and manage Service Instances (ALPHA)        Standalone             v0.1.2   installed
    ```

You can now install Tanzu Application Platform.
See **[Installing the Tanzu Application Platform Package and Profiles](install.md)**.

### <a id='update-tap-tanzu-cli-0-4'></a> Updating Tanzu CLI Installed for Tanzu Application Platform v0.4 or earlier

Follow these instructions to update the Tanzu CLI that was installed for Tanzu Application Platform
v0.4 or earlier:

1. Uninstall Tanzu CLI, plug-ins, and associated files by following the steps in
[Remove Tanzu CLI, plug-ins, and associated files](uninstall.md#remove-tanzu-cli).

1. Perform a clean install of the Tanzu CLI by following the steps in [Cleanly Install Tanzu CLI](#tanzu-cli-clean-install) above.

1. If a directory named `tanzu` does not exist, create one by running:

   ```
   mkdir $HOME/tanzu
   ```

2. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

3. Navigate to [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/)
on Tanzu Network.

4. Click the **tanzu-cli-v0.10.0** directory.

5. Download the CLI bundle corresponding with your operating system. For example, if your client
operating system is Linux, download the `tanzu-framework-linux-amd64.tar` bundle.

6. If they exist, delete any CLI files from previous installs by running:

   ```
   rm -rf $HOME/tanzu/cli
   ```

7. Unpack the TAR file in the `tanzu` directory by running:

   ```
   tar -xvf tanzu-framework-linux-amd64.tar -C $HOME/tanzu
   ```

8. Navigate to the `tanzu` directory by running:

   ```
   cd $HOME/tanzu
   ```

9. Set env var `TANZU_CLI_NO_INIT` to `true` to install the local versions of the CLI core and plug-ins you've downloaded:

   ```
   export TANZU_CLI_NO_INIT=true
   ```

10. Update the core CLI by running:

    ```
    tanzu update --local ./cli
    ```
    Expect to see a user prompt - submit `y`


11. Check installation status for the core CLI by running:

    ```
    tanzu version
    ```

    Expected output: `version: v0.10.0`

12. List the plug-ins to see if the `imagepullsecret` plug-in was previously installed by running:

    ```
    tanzu plugin list
    ```

    If installed, delete it by running:

    ```
    tanzu plugin delete imagepullsecret
    ```

13. Remove previously installed plug-in binaries by running:

    ```
    rm -rf ~/Library/Application\ Support/tanzu-cli/*
    ```

14. Install new plug-in versions by running:

    ```
    tanzu plugin install --local cli all
    ```

15. Check installation status for plug-ins by running:

    ```
    tanzu plugin list
    ```

    Expect to see the following:

    ```
    tanzu plugin list
    NAME                LATEST VERSION  DESCRIPTION                                                        REPOSITORY  VERSION  STATUS
    accelerator                         Manage accelerators in a Kubernetes cluster                                    v1.0.0   installed
    apps                                Applications on Kubernetes                                                     v1.0.1   installed
    cluster             v0.13.1         Kubernetes cluster operations                                      core        v0.10.0  installed
    kubernetes-release  v0.13.1         Kubernetes release operations                                      core        v0.10.0  installed
    login               v0.13.1         Login to the platform                                              core        v0.10.0  installed
    management-cluster  v0.13.1         Kubernetes management cluster operations                           core        v0.10.0  installed
    package             v0.13.1         Tanzu package management                                           core        v0.10.0  installed
    pinniped-auth       v0.13.1         Pinniped authentication operations (usually not directly invoked)  core        v0.10.0  installed
    secret              v0.13.1         Tanzu secret management                                            core        v0.10.0  installed
    services                            Discover Service Types and manage Service Instances (ALPHA)                    v0.1.1   installed
    ```

You can now install Tanzu Application Platform.
See **[Installing the Tanzu Application Platform Package and Profiles](install.md)**.

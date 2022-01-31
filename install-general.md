# Installing part I: CLI

This document describes the first part of the installation process for Tanzu Application Platform:

+ [Accept the EULAs](#eulas)
+ [Install Cluster Essentials for VMware Tanzu](#tanzu-cluster-essentials)
+ [Install or Update the Tanzu CLI and plug-ins](#cli-and-plugin)

## <a id='tanzu-cluster-essentials'></a> Install Cluster Essentials for VMware Tanzu

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

## <a id='cli-and-plugin'></a> Install or update the Tanzu CLI and plug-ins

Choose the install scenario that is right for you:

   + [Instructions for a clean install of Tanzu CLI](#tanzu-cli-clean-install)
   + [Instructions for updating Tanzu CLI that was installed for a previous Tanzu Application Platform release](#update-prev-tap-tanzu-cli)


### <a id='tanzu-cli-clean-install'></a> Clean install Tanzu CLI

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

2. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

3. Navigate to [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/) on Tanzu Network.

4. Click the `tanzu-cli-v0.10.0` folder.

5. Download `tanzu-framework-bundle-linux` and unpack the TAR file into the `tanzu` directory by running:
    ```
    tar -xvf tanzu-framework-linux-amd64.tar -C $HOME/tanzu
    ```

6. Set env var `TANZU_CLI_NO_INIT` to `true` to assure the local downloaded versions of the CLI core and plug-ins are installed:

     ```
     export TANZU_CLI_NO_INIT=true
     ```

7. Install the CLI core by running:

    ```
    cd $HOME/tanzu
    sudo install cli/core/v0.10.0/tanzu-core-linux_amd64 /usr/local/bin/tanzu
    ```

8. Confirm installation of the CLI core by running:

   ```
   tanzu version
   ```

   Expected output: `version: v0.10.0`

9. Proceed to [Instructions for a clean install of Tanzu CLI plug-ins](#cli-plugin-clean-install).


#### <a id='mac-tanzu-cli'></a>MacOS: Install the Tanzu CLI

To install the Tanzu CLI on a Mac operating system:

1. Create a directory named `tanzu`:
    ```
    mkdir $HOME/tanzu
    ```

2. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

3. Navigate to [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/) on Tanzu Network.

4. Click the `tanzu-cli-v0.10.0` folder.

5. Download `tanzu-framework-bundle-mac` and unpack the TAR file into the `tanzu` directory:
    ```
    tar -xvf tanzu-framework-darwin-amd64.tar -C $HOME/tanzu
    ```

6. Set env var `TANZU_CLI_NO_INIT` to `true` to assure the local downloaded versions of the CLI core and plug-ins are installed:

     ```
     export TANZU_CLI_NO_INIT=true
     ```

7.  Install the CLI core by running:

    ```
    cd $HOME/tanzu
    install cli/core/v0.10.0/tanzu-core-darwin_amd64 /usr/local/bin/tanzu
    ```

8. Confirm installation of the CLI core by running:

   ```
   tanzu version
   ```

   Expected output: `version: v0.10.0`

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

   8. Proceed to [Instructions for a clean install of Tanzu CLI plug-ins](#cli-plugin-clean-install).


#### <a id='windows-tanzu-cli'></a>Windows: Install the Tanzu CLI

To install the Tanzu CLI on a Windows operating system:

  1. Create a directory called `tanzu-bundle`.

  2. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

  3. Navigate to [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/) on Tanzu Network.

  4. Click the `tanzu-cli-v0.10.0` folder.

  5. Download `tanzu-framework-bundle-windows` and unpack the TAR files into the `tanzu-bundle` directory.

  6. Create a new `Program Files\tanzu` folder.

  7. In the unpacked CLI folder tanzu-bundle, locate and copy the `core/v0.10.0/tanzu-core-windows_amd64.exe`
     into the new `Program Files\tanzu` folder.

  8. Rename `tanzu-core-windows_amd64.exe` to `tanzu.exe`.

  9. Right-click the `tanzu` folder, select **Properties > Security**,
     and make sure that your user account has the **Full Control** permission.

  10. Use Windows Search to search for `env`.

  11. Select **Edit the system environment variables**, and click **Environment Variables**.

  12. Select the **Path** row under **System variables**, and click **Edit**.

  13. Click **New** to add a new row, and enter the path to the Tanzu CLI.

  14. Set the environmental variable `TANZU_CLI_NO_INIT` to `true`.

  15. From the `tanzu` directory, confirm the installation of the Tanzu CLI by running the following command in a terminal window:

      ```
      tanzu version
      ```

      Expected output: `version: v0.10.0`

  16. Proceed to [Clean Install Tanzu CLI plug-ins](#cli-plugin-clean-install)

## <a id='cli-plugin-clean-install'></a> Clean install Tanzu CLI plug-ins

To perform a clean installation of the Tanzu CLI plug-ins:

1. If it hasn't been done already, set env var `TANZU_CLI_NO_INIT` to `true` to assure the locally downloaded plug-ins are installed:

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

    Expect to see the following:

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

    Ensure that you have the `accelerator`, `apps`, `package`, `secret`, and `services` plug-ins.
    You need these plug-ins to install and interact with the Tanzu Application Platform.

    Tanzu Application Platform requires cluster-admin privileges.
    Running commands associated with the additional plug-ins can have unintended side effects.
    VMware recommends against running `cluster`, `kubernetes-release`, `login`, `management-cluster`,
    and `pinniped-auth` commands.

You can now proceed with installing Tanzu Application Platform. For more information, see
**[Installing part II: Profiles](install.md)**.


## <a id='update-prev-tap-tanzu-cli'></a>Instructions for updating Tanzu CLI that was installed for a previous release of Tanzu Application Platform

Follow these instructions to update the Tanzu CLI that was installed for a previous release of Tanzu Application Platform:

- If your Tanzu CLI version is **greater than `v0.10.0`**, you must [delete your existing Tanzu CLI, plug-ins, and associated files](uninstall.md#remove-tanzu-cli) and then perform a [clean install](#tanzu-cli-clean-install)
- If your Tanzu CLI version is **less than or equal to `v0.10.0`**, proceed to step 1.<br/>

**Steps:**

1. If a directory called `tanzu` does not exist, create one by running:

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

You can now install Tanzu Application Platform.
See **[Installing part II: Profiles](install.md)**.

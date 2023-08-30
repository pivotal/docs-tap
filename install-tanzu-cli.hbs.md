# Install Tanzu CLI

This topic tells you how to accept the EULAs, and install the Tanzu CLI and plug-ins on Tanzu Application Platform (commonly known as TAP).

- [Install Tanzu CLI](#install-tanzu-cli)
  - [ Accept the End User License Agreements](#-accept-the-end-user-license-agreements)
    - [ Example of accepting the Tanzu Application Platform EULA](#-example-of-accepting-the-tanzu-application-platform-eula)
  - [ Set the Kubernetes cluster context](#-set-the-kubernetes-cluster-context)
  - [ Install or update the Tanzu CLI and plug-ins](#-install-or-update-the-tanzu-cli-and-plug-ins)
    - [ Install the Tanzu CLI](#-install-the-tanzu-cli)
    - [ Install Tanzu CLI Plug-ins](#-install-tanzu-cli-plug-ins)
      - [List the versions of each plug-in group available across Tanzu](#list-the-versions-of-each-plug-in-group-available-across-tanzu)
      - [List the versions of the Tanzu Application Platform specific plug-in group](#list-the-versions-of-the-tanzu-application-platform-specific-plug-in-group)
      - [Install the version of the Tanzu Application Platform plug-in group matching your target environment](#install-the-version-of-the-tanzu-application-platform-plug-in-group-matching-your-target-environment)
      - [Verify the plug-in group list against the plug-ins that were installed](#verify-the-plug-in-group-list-against-the-plug-ins-that-were-installed)
  - [Next steps](#next-steps)

## <a id='accept-eulas'></a> Accept the End User License Agreements

Before downloading and installing Tanzu Application Platform packages, you must accept the
End User License Agreements (EULAs) as follows:

1. Sign in to [VMware Tanzu Network](https://network.tanzu.vmware.com).

2. Accept or confirm that you have accepted the EULAs for each of the following:

    - [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/)
    - [Cluster Essentials for VMware Tanzu](https://network.tanzu.vmware.com/products/tanzu-cluster-essentials/)

### <a id='accept-tap-eula-example'></a> Example of accepting the Tanzu Application Platform EULA

To accept the Tanzu Application Platform EULA:

1. Go to [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/).

2. Select the ***Click here to sign the EULA*** link in the yellow warning box under the release
   drop-down menu. If the yellow warning box is not visible, the EULA has already been accepted.

    ![Screenshot of a VMware Tanzu Network download page with notice stating user must sign EULA before downloading.](images/install-tanzu-cli-eulas1.png)

3. Select ***Agree*** in the bottom-right of the dialog box as seen in the following screenshot.

    ![Screenshot of a dialog box inviting the reader to accept the EULA. The Agree button is framed.](images/install-tanzu-cli-eulas2.png)

## <a id='cluster-context'></a> Set the Kubernetes cluster context

For information about the supported Kubernetes cluster providers and versions, see
[Kubernetes cluster requirements](prerequisites.hbs.md#k8s-cluster-reqs).

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

2. If you are managing multiple cluster contexts, set the context to the cluster that you want to use
   for the Tanzu Application Platform packages installation by running:

    ```console
    kubectl config use-context CONTEXT
    ```

    Where `CONTEXT` is the cluster that you want to use. For example, `aks-tap-cluster`.

    For example:

    ```console
    $ kubectl config use-context aks-tap-cluster
    Switched to context "aks-tap-cluster".
    ```

## <a id='cli-and-plugin'></a> Install or update the Tanzu CLI and plug-ins

The Tanzu CLI and plug-ins enable you to install and use the Tanzu Application Platform functions
and features.

### <a id="install-cli"></a> Install the Tanzu CLI

The Tanzu CLI core v1.0.0 distributed with Tanzu Application Platform is forward and backward
compatible with all supported Tanzu Application Platform versions. Run a single command to install
the plug-in group version that matches the Tanzu Application Platform version on any target environment.
For more information, see [Install Plugins](#install-plugins).

Use a package manager to install Tanzu CLI on Windows, Mac, or Linux OS. Alternatively, download
and install manually from Tanzu Network, VMware Customer Connect, or GitHub.


Basic installation instructions are provided below. For more information including how to install
the Tanzu CLI and CLI plug-ins in Internet-restricted environments, see the 
[VMware Tanzu CLI](https://docs.vmware.com/en/VMware-Tanzu-CLI/1.0/tanzu-cli/index.html) documentation.

> **Note** To retain an existing installation of the Tanzu CLI, move the CLI binary from `/usr/local/bin/tanzu`
or `C:\Program Files\tanzu` on Windows to a different location before following the steps below.

Install using a package manager
: To install the Tanzu CLI using a package manager:

   1. Follow the instructions for your package manager below. This installs the latest version of the CLI available in the package registry.

      * **Homebrew (MacOS):**

         ```console
         brew update
         brew install vmware-tanzu/tanzu/tanzu-cli
         ```

      * **Chocolatey (Windows):**

         ```console
         choco install tanzu-cli
         ```

         The `tanzu-cli` package is part of the main [Chocolatey Community Repository](https://community.chocolatey.org/packages). When a new `tanzu-cli` version is released, it might not be available immediately. If the above command fails, run:


         ```console
         choco install tanzu-cli --version TANZU-CLI-VERSION
         ```

         Where `TANZU-CLI-VERSION` is the Tanzu CLI version you want to install.

         For example:

         ```console
         choco install tanzu-cli --version {{ vars.tanzu-cli.version }}
         ```

      * **APT (Debian or Ubuntu):**

         ```console
         sudo mkdir -p /etc/apt/keyrings/
         sudo apt-get update
         sudo apt-get install -y ca-certificates curl gpg
         curl -fsSL https://packages.vmware.com/tools/keys/VMWARE-PACKAGING-GPG-RSA-KEY.pub | sudo gpg --dearmor -o /etc/apt/keyrings/tanzu-archive-keyring.gpg
         echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/tanzu-archive-keyring.gpg] https://storage.googleapis.com/tanzu-cli-os-packages/apt tanzu-cli-jessie main" | sudo tee /etc/apt/sources.list.d/tanzu.list
         sudo apt-get update
         sudo apt-get install -y tanzu-cli

         ```

      * **YUM or DNF (RHEL):**

         ```console
         cat << EOF | sudo tee /etc/yum.repos.d/tanzu-cli.repo
         [tanzu-cli]
         name=Tanzu CLI
         baseurl=https://storage.googleapis.com/tanzu-cli-os-packages/rpm/tanzu-cli
         enabled=1
         gpgcheck=1
         repo_gpgcheck=1
         gpgkey=https://packages.vmware.com/tools/keys/VMWARE-PACKAGING-GPG-RSA-KEY.pub
         EOF

         sudo yum install -y tanzu-cli # If you are using DNF, run sudo dnf install -y tanzu-cli.
         ```

   1. Check that the correct version of the CLI is properly installed.

      ```console
      tanzu version
      version: v{{ vars.tanzu-cli.version }}
      ...
      ```

Install from a binary release
: To install the Tanzu CLI from a binary release:
  
  1. Download the Tanzu CLI binary from one of the following locations:
     * **VMware Tanzu Network**
       
       1. Go to [VMware Tanzu Network](https://network.pivotal.io/products/tanzu-application-platform/).
       2. Choose the {{ vars.tap_version }} release from the Release dropdown menu.
       3. Click the tanzu-core-cli-binaries item from the result set.
       4. Download the Tanzu CLI binary for your operating system.

     * **VMware Customer Connect**

       1. Go to [VMware Customer Connect](https://customerconnect.vmware.com/downloads/details?downloadGroup=TCLI-100&productId=1455&rPId=109066).
       2. Download the Tanzu CLI binary for your operating system.

     * **GitHub**

       1. Go to [Tanzu CLI release v{{ vars.tanzu-cli.version }} on GitHub](https://github.com/vmware-tanzu/tanzu-cli/releases/tag/v{{ vars.tanzu-cli.version }}).
       2. Download the Tanzu CLI binary for your operating system, for example, `tanzu-cli-windows-amd64.tar.gz`.

  2. Use an extraction tool to unpack the binary file:

        * **macOS:**

           ```console
           tar -xvf tanzu-cli-darwin-amd64.tar.gz
           ```

        * **Linux:**

           ```console
           tar -xvf tanzu-cli-linux-amd64.tar.gz
           ```

        * **Windows:**

           Use the Windows extractor tool to unzip `tanzu-cli-windows-amd64.zip`.

  3. Make the CLI available to the system:

        * cd to the directory containing the extracted CLI binary

        * **macOS:**

           Install the binary to `/usr/local/bin`:

           ```console
           install tanzu-cli-darwin_amd64 /usr/local/bin/tanzu
           ```

        * **Linux:**

           Install the binary to `/usr/local/bin`:

           ```console
           sudo install tanzu-cli-linux_amd64 /usr/local/bin/tanzu
           ```

        * **Windows:**

           1. Create a new `Program Files\tanzu` folder.
           2. Copy the `tanzu-cli-windows_amd64.exe` file into the new `Program Files\tanzu` folder.
           3. Rename `tanzu-cli-windows_amd64.exe` to `tanzu.exe`.
           4. Right-click the `tanzu` folder, select **Properties** > **Security**, and make sure that your user account has the **Full Control** permission.
           5. Use Windows Search to search for `env`.
           6. Select **Edit the system environment variables** and click the **Environment Variables** button.
           7. Select the `Path` row under **System variables**, and click **Edit**.
           8. Click **New** to add a new row and enter the path to the Tanzu CLI. The path value must not include the `.exe` extension. For example, `C:\Program Files\tanzu`.

  4. Check that the correct version of the CLI is properly installed:

        ```console
        tanzu version
        version: v{{ vars.tanzu-cli.version }}
        ...
        ```

### <a id="install-plugins"></a> Install Tanzu CLI Plug-ins

There is a group of Tanzu CLI plug-ins which extend the Tanzu CLI Core with Tanzu Application Platform
specific feature functionality.
The plug-ins can be installed as a group with a single command.
Versioned releases of the Tanzu Application Platform specific plug-in group align to each supported
Tanzu Application Platform version.
This makes it easy to switch between different versions of Tanzu Application Platforms environments.

Use the following commands to search for, install, and verify Tanzu CLI plug-in groups.

#### List the versions of each plug-in group available across Tanzu

  ```console
  tanzu plugin group search --show-details
  ```

#### List the versions of the Tanzu Application Platform specific plug-in group

  ```console
  tanzu plugin group search --name vmware-tanzu/default --show-details
  ```

#### Install the version of the Tanzu Application Platform plug-in group matching your target environment

  ```console
  tanzu plugin install --group vmware-tap/default:v{{ vars.tap_version }}
  ```

#### Verify the plug-in group list against the plug-ins that were installed

  ```console
  tanzu plugin group get vmware-tap/default:v{{ vars.tap_version }}
  ```

  ```console
  tanzu plugin list
  ```
  ```
  
For air-gapped installation, see the [Installing the Tanzu CLI in Internet-Restricted Environments](https://docs.vmware.com/en/VMware-Tanzu-CLI/{{ vars.tanzu-cli.url_version }}/tanzu-cli/index.html#internet-restricted-install) section of the Tanzu CLI
documentation.

## <a id='next-steps'></a>Next steps

For online installation:

- [Deploy Cluster Essentials*](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/deploy.html)
- [Install the Tanzu Application Platform package and profiles](install-online/profile.hbs.md)

For air-gapped installation:

- [Deploy Cluster Essentials](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/deploy.html)
- [Install Tanzu Application Platform in an air-gapped environment](install-offline/profile.hbs.md)

\* _When you use a VMware Tanzu Kubernetes Grid cluster, you do not need to install Cluster
Essentials because the contents of Cluster Essentials are already installed on your cluster._

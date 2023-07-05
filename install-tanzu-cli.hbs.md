# Accept Tanzu Application Platform EULAs and installing Tanzu CLI

This topic describes how to install Tanzu CLI and plugins.

## <a id='accept-eulas'></a>Accept the End User License Agreements

Before downloading and installing Tanzu Application Platform packages, you must accept the
End User License Agreements (EULAs) as follows:

1. Sign in to [VMware Tanzu Network](https://network.tanzu.vmware.com).

2. Accept or confirm that you have accepted the EULAs for each of the following:

    - [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/)
    - [Cluster Essentials for VMware Tanzu](https://network.tanzu.vmware.com/products/tanzu-cluster-essentials/)

### Example of accepting the Tanzu Application Platform EULA

To accept the Tanzu Application Platform EULA:

1. Go to [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/).

2. Select the ***Click here to sign the EULA*** link in the yellow warning box under the release
   drop-down menu. If the yellow warning box is not visible, the EULA has already been accepted.

    ![Screenshot of a VMware Tanzu Network download page with notice stating user must sign EULA before downloading.](images/install-tanzu-cli-eulas1.png)

3. Select ***Agree*** in the bottom-right of the dialog box as seen in the following screenshot.

    ![Screenshot of a dialog box inviting the reader to accept the EULA. The Agree button is framed.](images/install-tanzu-cli-eulas2.png)

## Set the Kubernetes cluster context

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

 From Tanzu Application Platform v{{ vars.tap_version }} and later, the Tanzu CLI and the CLI plugins
required to interact with Tanzu Application Platform are released and distributed independently
from Tanzu Application Platform itself.

1. [Install the Tanzu CLI](#install-cli)
1. [Install Tanzu CLI Plugins](#install-plugins)

### <a id="install-cli"></a> Install the Tanzu CLI

From Tanzu Application Platform v{{ vars.tap_version }} and later, the Tanzu CLI is released and
distributed independently from Tanzu Application Platform. The Tanzu CLI can be installed using a
package manager such as Chocolatey, Homebrew, APT, YUM, and DNF, or it can be installed from a
binary release.

Basic installation instructions are provided below. For more information including how to install
the Tanzu CLI and CLI plugins in Internet restricted environments,
see the [VMware Tanzu CLI](https://docs.vmware.com/en/VMware-Tanzu-CLI/0.90.0/tanzu-cli/index.html) documentation.

> **Note** If you want to retain an existing installation of the Tanzu CLI, move the CLI binary from `/usr/local/bin/tanzu` or `C:\Program Files\tanzu` on Windows to a different location before following
the steps below.

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

         The `tanzu-cli` package is part of the main [Chocolatey Community Repository](https://community.chocolatey.org/packages). When a new `tanzu-cli` version is released, it may not be available immediately. If the above command fails, run:


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
: You can download the Tanzu CLI binary from VMware Customer Connect or GitHub.

  To download a binary release of the Tanzu CLI from Customer Connect and then install it:

  1. Download and unpack the Tanzu CLI binary:

     1. Download the Tanzu CLI binary for your operating system from
        [Customer Connect](https://customerconnect.vmware.com/downloads/details?downloadGroup=TCLI-090&productId=1431).
     1. Use an extraction tool to unpack the binary file, for example, on Linux or macOS, you can
     use the `tar` command.

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
        8. Click **New** to add a new row and enter the path to the `tanzu` CLI. The path value must not include the `.exe` extension. For example, `C:\Program Files\tanzu`.

  4. Check that the correct version of the CLI is properly installed.

     ```console
     tanzu version
     version: v{{ vars.tanzu-cli.version }}
     ...
     ```

### <a id="install-plugins"></a> Install Tanzu CLI Plugins

Run the following command to install the CLI plugins required for Tanzu Application Platform:

   ```console
   tanzu plugin install --group vmware-tap/default:v1.6.0
   ```

For more information about the latest `tanzu plugin` features and sub-commands, see the [tanzu plugin](https://docs.vmware.com/en/VMware-Tanzu-CLI/{{ vars.tanzu-cli.version }}/tanzu-cli/tanzu-plugin.html) topic in the VMware Tanzu CLI documentation.

## Next steps

For online installation:

- [Deploy Cluster Essentials*](https://{{ vars.staging_toggle }}.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/deploy.html)
- [Install the Tanzu Application Platform package and profiles](install-online/profile.hbs.md)

For air-gapped installation:

- [Deploy Cluster Essentials*](https://{{ vars.staging_toggle }}.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/deploy.html)
- [Install Tanzu Application Platform in an air-gapped environment](install-offline/profile.hbs.md)

For GitOps (beta) installation:

- [Deploy Cluster Essentials*](https://{{ vars.staging_toggle }}.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/deploy.html)

- [Install Tanzu Application Platform through GitOps with ESO](install-gitops/eso.hbs.md)
- [Install Tanzu Application Platform through Gitops with SOPS](install-gitops/sops.hbs.md)

\* _When you use a VMware Tanzu Kubernetes Grid cluster, you do not need to install Cluster
Essentials because the contents of Cluster Essentials are already installed on your cluster._

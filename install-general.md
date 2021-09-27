# <a id='installing'></a> Installing Part I: Cluster Configurations, EULA, and CLI

This document describes the first part of the installation process for Tanzu Application Platform:

+ [Set and Verify the Kubernetes Cluster Configurations](#set-and-verify)
+ [Accept the EULAs](#eulas)
+ [Install the Tanzu CLI and Package Plugin](#cli-and-plugin)

##<a id='set-and-verify'></a> Set and Verify the Kubernetes Cluster Configurations

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



##<a id="eulas"></a> Accept the EULAs

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
    + [Supply Chain Security Tools](https://network.tanzu.vmware.com/products/supply-chain-security-tools)

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


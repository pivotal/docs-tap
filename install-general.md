# <a id='installing'></a> Installing Part I: EULA, CLI, and Package Repository

This document describes how to install Tanzu Application Platform things

## Set and Verify the Kubernetes Cluster Configurations

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

2.  Set the context to the desired cluster to be used for TAP packages install. 
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



## Accept the EULAs

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

## Install the Tanzu CLI and Package Plugin

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

## <a id='add-package-repositories'></a> Add the Tanzu Application Platform Package Repository

To add the Tanzu Application Platform package repository:

1. Create a namespace called `tap-install` for deploying the packages of the components by running:
    ```
    kubectl create ns tap-install
    ```

    This namespace is to keep the objects grouped together logically.

2. Create a imagepullsecret:
    ```
    tanzu imagepullsecret add tap-registry --username TANZU-NET-USER --password TANZU-NET-PASSWORD --registry registry.tanzu.vmware.com --export-to-all-namespaces -n tap-install
    ```

    Where `TANZU-NET-USER` and `TANZU-NET-PASSWORD` are your credentials for Tanzu Network.

3. Add Tanzu Application Platform package repository to the cluster by running:

    ```
    tanzu package repository add tanzu-tap-repository --url TAP-REPO-IMGPKG -n tap-install
    ```

    Where TAP-REPO-IMGPKG is the Tanzu Application Platform repo bundle artifact reference.

    For example:
    ```
    $ tanzu package repository add tanzu-tap-repository --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:0.2.0 -n tap-install
    \ Adding package repository 'tanzu-tap-repository'... 
    Added package repository 'tanzu-tap-repository'
    ```

5. Get status of the Tanzu Application Platform package repository, and ensure the status updates to `Reconcile succeeded` by running:

    ```
    tanzu package repository list -n tap-install
    ```
    For example:
    ```
    $ tanzu package repository list -n tap-install
    - Retrieving repositories...
      NAME                  REPOSITORY                                                         STATUS               DETAILS
      tanzu-tap-repository  registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:0.2.0  Reconcile succeeded
    ```

6. List the available packages by running:


    ```
    tanzu package available list -n tap-install
    ```
    For example:
    ```
    $ tanzu package available list -n tap-install
    / Retrieving available packages...
      NAME                               DISPLAY-NAME                              SHORT-DESCRIPTION
      accelerator.apps.tanzu.vmware.com  Application Accelerator for VMware Tanzu  Used to create new projects and configurations.                                      
      appliveview.tanzu.vmware.com       Application Live View for VMware Tanzu    App for monitoring and troubleshooting running apps                                  
      cnrs.tanzu.vmware.com              Cloud Native Runtimes                     Cloud Native Runtimes is a serverless runtime based on Knative
    ```

7. List version information for the `cnrs.tanzu.vmware.com` package by running:
    ```
    tanzu package available list cnrs.tanzu.vmware.com -n tap-install
    ```
    For example:
    ```
    $ tanzu package available list cnrs.tanzu.vmware.com -n tap-install
    - Retrieving package versions for cnrs.tanzu.vmware.com...
      NAME                   VERSION  RELEASED-AT
      cnrs.tanzu.vmware.com  1.0.1    2021-07-30T15:18:46Z
    ```



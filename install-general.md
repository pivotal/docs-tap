# Installing Part I: Prerequisites, EULA, and CLI

This document describes the first part of the installation process for Tanzu Application Platform:

+ [Prerequisites](#prereqs)
+ [Accept the EULAs](#eulas)
+ [Install or Update the Tanzu CLI and Plugins](#cli-and-plugin)



## <a id='prereqs'></a>Prerequisites

The following are required to install Tanzu Application Platform:

### Tanzu Network and Container Image Registry Requirements

Installation requires:

* A [Tanzu Network](https://network.tanzu.vmware.com/) account to download
Tanzu Application Platform packages.

* A container image registry, such as [Harbor](https://goharbor.io/) or
[Docker Hub](https://hub.docker.com/) with at least **10&nbsp;GB** of available storage for
application images, base images, and runtime dependencies.
    * When available, VMware recommends using a paid registry account to avoid potential
    rate-limiting associated with some free registry offerings.
    * VMware recommends using a paid registry account, if available, to avoid potential
    rate-limiting associated with some free registry offerings dependencies.


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
  - You can find this by navigating to [Tanzu Network](https://network.tanzu.vmware.com/) and selecting the Tanzu Application Platform. Under the list of available files to download, you should see a fodler titled `tap-gui-catalogs`. Inside that folder is a compressed archive titled Tanzu Application Platform Blank Catalog. You'll need to extract that catalog to the above Git repository of choice. This serves as the configuration location for your Organziation's Catalog inside Tanzu Application Platform GUI.

### Kubernetes Cluster Requirements
Installation requires:

* Kubernetes cluster v1.19 or later on one of the following Kubernetes providers:

    * Azure Kubernetes Service
    * Amazon Elastic Kubernetes Service
    * Google Kubernetes Engine
        * GKE Autopilot clusters do not have required features enabled.
    * Kind
        * Supported only on Linux operating system.
        * Minimum requirements: 8 CPUs for i9 or equivalent, 12 CPUs for i7 or equivalent, 8 GB RAM (12+ GB recommended), and 120 GB disk space.
        * If you are using Cloud Native Runtimes, see [Configure Your Local Kind
        Cluster](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/1.0/tanzu-cloud-native-runtimes-1-0/GUID-local-dns.html#configure-your-local-kind-cluster-1).
    * Minikube
        * Minimum requirements for VM: 8 CPUs for i9 or equivalent, 12 CPUs for i7 or equivalent, 8 GB RAM (12+ GB recommended), and 120 GB disk space.
        * VMware recommends at least 16 GB of total host memory.
        * On MacOS only Hyperkit driver is supported; Docker driver is not supported.
   * Tanzu Kubernetes Grid v1.4
        * Do not use a Tanzu Kubernetes Grid cluster that runs production workloads.
        * To install Tanzu Application Platform on Tanzu Kubernetes Grid v1.4,
          see [Installing with Tanzu Kubernetes Grid v1.4](install-tkg.md).
   * Tanzu Community Edition v0.9.1
        * To install Tanzu Community Edition v0.9.1, see [Installing on a Tanzu Community Edition v0.9.1 Cluster](install-tce.md).

    To deploy all Tanzu Application Platform packages, your cluster must have at least **8&nbsp;GB** of RAM across all nodes available to Tanzu Application Platform. At least 8 CPUs for i9 or equivalent or 12 CPUs for i7 or equivalent must be available to Tanzu Application Platform components.
    VMware recommends that at least **16&nbsp;GB** of RAM is available to build and deploy applications, including for Kind and Minikube.

    Your cluster must support the creation of Services of type `LoadBalancer` to install Cloud Native Runtimes package. The exception is [`provider: local` installation](#install-cnr), which removes container replication and uses `NodePort` Services for HTTP ingress. For information about services of type `LoadBalancer`, see the [Kubernetes documentation](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer) and your cloud provider documentation. For information about Tanzu Kubernetes Grid support for Service type `LoadBalancer`, see [Install VMware NSX Advanced Load Balancer on a vSphere Distributed Switch](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/1.3/vmware-tanzu-kubernetes-grid-13/GUID-mgmt-clusters-install-nsx-adv-lb.html#nsx-advanced-load-balancer-deployment-topology-0).

    Your cluster must also have at least **70&nbsp;GB** of disk per node.

* [Pod Security Policies](https://kubernetes.io/docs/concepts/policy/pod-security-policy/)
must be configured so that Tanzu Application Platform controller
pods can run as root.

### Tools and CLI Requirements
Installation requires:

* [Kapp Carvel command line tool](https://github.com/vmware-tanzu/carvel-kapp/releases) v0.37.0 or later.

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

* Kapp-controller v0.29.0 or later:

     *  If you are using Tanzu Kubernetes Grid v1.4, see [Install kapp-controller](install-tkg.md#install-kappcontroller-1).
     *  If you are using Tanzu Community Edition, see [Install kapp-controller](install-tce.md#install-kappcontroller-1).
    * Install kapp-controller by running:

      ```
      kapp deploy -y -a kc -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/download/KC-VERSION/release.yml
      ```
      Where `KC-VERSION` is the Kapp-controller version being installed.

      Select v0.29.0+ Kapp-controller version for Azure Kubernetes Service, Amazon Elastic Kubernetes Service,
      Google Kubernetes Engine, Kind, and Minikube from the [Releases page](https://github.com/vmware-tanzu/carvel-kapp-controller/releases).

      For example:
      ```
      kapp deploy -y -a kc -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/download/v0.29.0/release.yml
      ```
    * Verify Kapp-controller is running by running:
         ```
         kubectl get pods -A | grep kapp-controller
         ```
         Pod status should be Running.

    * (Optional) Verify installed Kapp-controller version:

      1. Get Kapp-controller deployment and namespace by running:
         ```
         kubectl get deployments -A | grep kapp-controller
         ```

         For example:
         ```
         kubectl get deployments -A | grep kapp-controller
         NAMESPACE                NAME                             READY   UP-TO-DATE   AVAILABLE   AGE
         kapp-controller          kapp-controller                  1/1     1            1           25h   
         ```
      2. Get Kapp controller version by running:
         ```
         kubectl get deployment KC-DEPLOYMENT -n KC-NAMESPACE -o yaml | grep kapp-controller.carvel.dev/version
         ```

         Where `KC-DEPLOYMENT` and `KC-NAMESPACE` are Kapp-controller deployment name and Kapp-controller namespace name respectively from the output of step 1.

         For example:
         ```
         kubectl get deployment kapp-controller -n kapp-controller  -o yaml | grep kapp-controller.carvel.dev/version
         kapp-controller.carvel.dev/version: v0.29.0
         kapp.k14s.io/original: '{"apiVersion":"apps/v1","kind":"Deployment","metadata":{"annotations":{"kapp-controller.carvel.dev/version":"v0.29.0","kbld.k14s.io/images":"-
         ```


* Secretgen-controller:

    * Install Secretgen-controller by running:

      ```
      kapp deploy -y -a sg -f https://github.com/vmware-tanzu/carvel-secretgen-controller/releases/download/SG-VERSION/release.yml
      ```

      Where `SG-VERSION` is the Secretgen-controller version being installed.
      Select v0.6.0+ Secretgen-controller version from the [Releases page](https://github.com/vmware-tanzu/carvel-secretgen-controller/releases).

      For example:
      ```
      kapp deploy -y -a sg -f https://github.com/vmware-tanzu/carvel-secretgen-controller/releases/download/v0.6.0/release.yml
      ```
    * Verify Secretgen-controller is running by running:
         ```
         kubectl get pods -A | grep secretgen-controller
         ```
        Pod status should be Running.

    * (Optional) Verify the Secretgen-controller version you installed:

      1. Get Secretgen-controller deployment and namespace by running:
         ```
         kubectl get deployments -A | grep secretgen-controller
         ```
         For example:
         ```
         kubectl get deployments -A | grep secretgen-controller
         NAMESPACE                NAME                             READY   UP-TO-DATE   AVAILABLE   AGE
         secretgen-controller     secretgen-controller             1/1     1            1           22d   
         ```

      2. Get Secretgen-controller version by running:
         ```
         kubectl get deployment SG-DEPLOYMENT -n SG-NAMESPACE -o yaml | grep secretgen-controller.carvel.dev/version
         ```
         Where `SG-DEPLOYMENT` and `SG-NAMESPACE` are Secretgen-controller deployment name and Secretgen-controller namespace name respectively from the output of step 1.

         For example:

         ```
         kubectl get deployment secretgen-controller -n secretgen-controller -oyaml | grep secretgen-controller.carvel.dev/version
         secretgen-controller.carvel.dev/version: v0.6.0
         ```


## <a id="eulas"></a> Accept the EULAs

Before you can install packages, you have to accept the End User License Agreements (EULAs).

To accept EULAs:

1. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

2. For each of the following components, accept or confirm that you have accepted the EULA:

    + [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/)
    + [Tanzu Build Service](https://network.tanzu.vmware.com/products/build-service/) and its associated components:
      + [Tanzu Build Service Dependencies](https://network.tanzu.vmware.com/products/tbs-dependencies/)
      + [Buildpacks for VMware Tanzu](https://network.tanzu.vmware.com/products/tanzu-buildpacks-suite)
      + [Stacks for VMware Tanzu](https://network.tanzu.vmware.com/products/tanzu-stacks-suite)


## <a id='cli-and-plugin'></a> Install or Update the Tanzu CLI and Plugins

Choose the install scenario that is right for you:

   + [Instructions for a clean install of Tanzu CLI](#tanzu-cli-clean-install)
   + [Instructions for updating Tanzu CLI that was installed for a previous Tanzu Application Platform release](#udpate-previous-tap-tanzu-cli)
   + [Instructions for updating Tanzu CLI that was previously installed for Tanzu Kubernetes Grid and Tanzu Community Edition](#udpate-tkg-tce-tanzu-cli)  


### <a id='tanzu-cli-clean-install'></a>Instructions for a Clean Install of Tanzu CLI

Follow the procedure for your OS:

   + [Linux: Install the Tanzu CLI](#linux-cli)
   + [Mac: Install the Tanzu CLI](#mac-cli)
   + [Windows: Install the Tanzu CLI](#windows-cli)


#### <a id='linux-cli'></a>Linux: Install the Tanzu CLI

To install the Tanzu CLI on a Linux operating system:

1. Create a local directory called `tanzu`.
    ```
    mkdir $HOME/tanzu
    ```

2. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

3. Navigate to [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/) on Tanzu Network.

4. Click the `tanzu-cli-0.10.0` folder.

5. Download `tanzu-framework-bundle-linux` and unpack the TAR file into the `tanzu` directory:
    ```
    tar -xvf tanzu-framework-linux-amd64.tar -C $HOME/tanzu
    ```

6. Install the Tanzu CLI from the `tanzu` directory by running:
    ```
    cd $HOME/tanzu
    sudo install cli/core/v0.9.0/tanzu-core-linux_amd64 /usr/local/bin/tanzu
    ```

7. Confirm the installation of the Tanzu CLI by running:
   ```
   tanzu version
   ```
   Expect `version: v0.9.0`

8. Proceed to [Instructions for a clean install of Tanzu CLI Plugins](#cli-plugin-clean-install).


#### <a id='mac-cli'></a>MacOS: Install the Tanzu CLI

To install the Tanzu CLI on a Mac operating system:

1. Create a local directory called `tanzu`.
    ```
    mkdir $HOME/tanzu
    ```

2. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

3. Navigate to [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/) on Tanzu Network.

4. Click the `tanzu-cli-0.10.0` folder.

5. Download `tanzu-framework-bundle-mac` and unpack the TAR file into the `tanzu` directory:
    ```
    tar -xvf tanzu-framework-darwin-amd64.tar -C $HOME/tanzu
    ```

6.  Install the Tanzu CLI from the `tanzu` directory by running:
    ```
    cd $HOME/tanzu
    sudo install cli/core/v0.9.0/tanzu-core-darwin_amd64 /usr/local/bin/tanzu
    ```

7. Confirm the installation of the Tanzu CLI by running:
   ```
   tanzu version
   ```
   Expect `version: v0.9.0`

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

   7. Click **Open** in the macOS prompt window.

   After completing the steps above, there should be no more security issues while running Tanzu CLI commands.

   8. Proceed to [Instructions for a clean install of Tanzu CLI Plugins](#cli-plugin-clean-install).


#### <a id='windows-cli'></a>Windows: Install the Tanzu CLI

To install the Tanzu CLI on a Windows operating system:

  1. Create a local directory called `tanzu-bundle`.

  2. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

  3. Navigate to [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/) on Tanzu Network.

  4. Click the `tanzu-cli-0.10.0` folder.

  5. Download `tanzu-framework-bundle-windows` and unpack the TAR files into the `tanzu-bundle` directory.

  6. Create a new `Program Files\tanzu` folder.

  7. In the unpacked CLI folder tanzu-bundle, locate and copy the `core/v0.9.0/tanzu-core-windows_amd64.exe`
   into the new `Program Files\tanzu` folder.

  8. Rename `tanzu-core-windows_amd64.exe` to `tanzu.exe`.

  9. Right-click the `tanzu` folder, select **Properties > Security**,
   and make sure that your user account has the **Full Control** permission.

  10. Use Windows Search to search for `env`.

  11. Select **Edit the system environment variables**, and click **Environment Variables**.

  12. Select the **Path** row under **System variables**, and click **Edit**.

  13. Click **New** to add a new row, and enter the path to the Tanzu CLI.

  14. Confirm the installation of the Tanzu CLI by running in a terminal window:
    ```
    tanzu version
    ```
    Expect `version: v0.9.0`

  15. Proceed to [Clean Install Tanzu CLI Plugins](#cli-plugin-clean-install)

## <a id='cli-plugin-clean-install'></a> Clean Install Tanzu CLI Plugins

To perform a clean installation of the Tanzu CLI plugins:

1. Run the following command from the `tanzu` directory:

    ```bash
    tanzu plugin install --local cli all
    ```

2. Check the plugin installation status by running:

    ```console
    tanzu plugin list
    ```

    Expect to see the following:

    ```console
     tanzu plugin list
     NAME                LATEST VERSION  DESCRIPTION                                                        REPOSITORY  VERSION  STATUS
     accelerator                         Manage accelerators in a Kubernetes cluster                                    v0.4.1   installed
     apps                                Applications on Kubernetes                                                     v0.2.0   installed
     cluster             v0.10.0         Kubernetes cluster operations                                      core        v0.9.0   upgrade available
     kubernetes-release  v0.10.0         Kubernetes release operations                                      core        v0.9.0   upgrade available
     login               v0.10.0         Login to the platform                                              core        v0.9.0   upgrade available
     management-cluster  v0.10.0         Kubernetes management cluster operations                           core        v0.9.0   upgrade available
     package             v0.10.0         Tanzu package management                                           core        v0.9.0   upgrade available
     pinniped-auth       v0.10.0         Pinniped authentication operations (usually not directly invoked)  core        v0.9.0   upgrade available
     secret              v0.10.0         Tanzu secret management                                            core        v0.9.0   upgrade available
    ```       

You need the `package`, `secret`, `accelerator` and `apps` plugins to install or interact with the
Tanzu Application Platform. You can ignore the rest.

Tanzu Application Platform beta requires cluster-admin privileges.
Running commands associated with the additional plugins can have unintended side-effects.
VMware recommends against running `cluster`, `kubernetes-release`, `login`, `management-cluster`,
and `pinniped-auth` commands.

You can now proceed with installing Tanzu Application Platform. For more information, see
**[Installing Part II: Profiles](install.md)**.


## <a id='udpate-previous-tap-tanzu-cli'></a>Instructions for updating Tanzu CLI that was installed for a previous Tanzu Application Platform release

If you'd like to the update the Tanzu CLI core and plugins you installed previously for Tanzu Application Platform Beta 2:

  1.  Create a directory named `tanzu` by running:
    ```console
    mkdir $HOME/tanzu
    ```

  2. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

  3. Navigate to [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/)
on Tanzu Network.

  4. Click the **tanzu-cli-0.10.0** directory.

  5. Download the CLI bundle corresponding with your operating system. For example, if your client
operating system is Linux, download the `tanzu-framework-linux-amd64.tar` bundle.

  6. Unpack the TAR file in the `tanzu` directory by running:
    ```bash
    tar -xvf tanzu-framework-linux-amd64.tar -C $HOME/tanzu
    ```

  7. Navigate to the `tanzu` directory by running:
    ```bash
    cd $HOME/tanzu
    ```

  8. Delete the `imagepullsecret` plugin (it will be replaced by a new `secret` plugin):
    ```bash
    tanzu plugin delete imagepullsecret
    ```

  9. Run the following command from the tanzu directory to update core cli and the previously installed plugins:
    ```
    tanzu update --local ./cli
    ```
    Expect to see a user prompt - submit "y"

  10. Manually install the new `secret` plugin
    ```
    tanzu plugin install secret --local ./cli   
    ```

  11. Check installation status for Tanzu CLI Core
    ```bash
    tanzu version
    ```
    Expect `version: v0.9.0`

  12. Check installation status for Tanzu CLI Core
    ```bash
    tanzu plugin list
    ```
    Expect to see the following:
    ```
     tanzu plugin list
     NAME                LATEST VERSION  DESCRIPTION                                                        REPOSITORY  VERSION  STATUS
     accelerator                         Manage accelerators in a Kubernetes cluster                                    v0.4.1   installed
     apps                                Applications on Kubernetes                                                     v0.2.0   installed
     cluster             v0.10.0         Kubernetes cluster operations                                      core        v0.9.0   upgrade available
     kubernetes-release  v0.10.0         Kubernetes release operations                                      core        v0.9.0   upgrade available
     login               v0.10.0         Login to the platform                                              core        v0.9.0   upgrade available
     management-cluster  v0.10.0         Kubernetes management cluster operations                           core        v0.9.0   upgrade available
     package             v0.10.0         Tanzu package management                                           core        v0.9.0   upgrade available
     pinniped-auth       v0.10.0         Pinniped authentication operations (usually not directly invoked)  core        v0.9.0   upgrade available
     secret              v0.10.0         Tanzu secret management                                            core        v0.9.0   upgrade available
    ```

  13. You may now proceed with installing Tanzu Application Platform via **[Installing Part II: Profiles](install.md)**.


## <a id='udpate-tkg-tce-tanzu-cli'></a>Instructions for updating Tanzu CLI that was previously installed for Tanzu Kubernetes Grid and Tanzu Community Edition

If you'd like to maintain the Tanzu CLI core and plugins you installed previously
for interacting with Tanzu Kubernetes Grid or Tanzu Community Edition, you only need to update/add the Tanzu Application Platform specific plugins as follows:

  1. Create a directory named `tanzu` by running:
    ```console
    mkdir $HOME/tanzu
    ```

  2. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

  3. Navigate to [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/)
on Tanzu Network.

  4. Click the **tanzu-cli-0.10.0** directory.

  5. Download the CLI bundle corresponding to your operating system. For example, if your client
operating system is Linux, download the `tanzu-framework-linux-amd64.tar` bundle.

  6. Unpack the TAR file in the `tanzu` directory by running:
    ```bash
    tar -xvf tanzu-framework-linux-amd64.tar -C $HOME/tanzu
    ```

  7. Navigate to the `tanzu` directory by running:
    ```bash
    cd $HOME/tanzu
    ```

  8. Check to see if the `imagepullsecret` and `package` plugins are already installed:
    ```bash
    tanzu plugin list
    ```
   If either is present present, delete them by running:
    ```bash
    tanzu plugin delete imagepullsecret
    ```
   And/Or
    ```bash
    tanzu plugin delete package
    ```

  9. Install the `secret` plugin by running:
    ```bash
    tanzu plugin install secret --local ./cli
    ```

  10. Install the `accelerator` plugin by running:
    ```bash
    tanzu plugin install accelerator --local ./cli
    ```

  11. Install the `apps` plugin by running:
    ```bash
    tanzu plugin install apps --local ./cli
    ```

  12. Install the updated `package` plugin by running:
    ```bash
    tanzu plugin install package --local ./cli
    ```

  13. Verify the Tanzu Application Platform plugins present:
    ```bash
    tanzu plugin list
    ```
    Expect the following to be included in the list:
    ```
    NAME                LATEST VERSION  DESCRIPTION                                                        REPOSITORY  VERSION  STATUS
    accelerator                         Manage accelerators in a Kubernetes cluster                                    v0.4.1   installed
    apps                                Applications on Kubernetes                                                     v0.2.0   installed
    package                             Tanzu package management                                           core        v0.10.0  installed
    secret                              Tanzu secret management                                            core        v0.10.0  installed
    ```

  14. You may now proceed with installing Tanzu Application Platform on Tanzu Kubernetes Grid or Tanzu Community Edition. For more information, see:
    * **[Installing Tanzu Application Platform on a Tanzu Community Edition v0.9.1 Cluster](install-tce.html#install-tap)**
    * **[Installing Tanzu Application Platform on a Tanzu Kubernetes Grid v1.4 Cluster](install-tkg.html#install-tap)**

# Installing Tanzu Application Platform

You can install Tanzu Application Platform by using one of the following methods:

- [Installing Tanzu Application Platform online](#install-online)
- [Installing Tanzu Application Platform in an air-gapped environment (Beta)](#install-air-gap)
- [Deploying Tanzu Application Platform on Amazon EKS using AWS QuickStart](https://furry-guide-233b9019.pages.github.io/)

## <a id='install-online'></a>Installing Tanzu Application Platform online

The process of installing Tanzu Application Platform on your own Kubernetes clusters with internet access includes the following tasks:

|Step|Task|Link|
|----|----|----|
|1.| Review the prerequisites to ensure that you have set up everything required before beginning the installation |[Prerequisites](prerequisites.html)|
|2.| Accept Tanzu Application Platform EULAs and install the Tanzu CLI |[Accepting Tanzu Application Platform EULAs and installing the Tanzu CLI](install-tanzu-cli.html)|
|3.| Install Cluster Essentials for Tanzu* |[Deploying Cluster Essentials](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/1.2/cluster-essentials/GUID-deploy.html)|
|4.| Add the Tanzu Application Platform package repository, prepare your Tanzu Application Platform profile, and install the profile to the cluster |[Installing the Tanzu Application Platform package and profiles](install.html)|
|5.| (Optional) Install any additional packages that were not in the profile |[Installing Individual Packages](install-components.html)|
|6.| Set up developer namespaces to use installed packages |[Setting up developer namespaces to use installed packages](set-up-namespaces.html)|
|7.| Install developer tools into your integrated development environment (IDE) |[Installing Tanzu Developer Tools for VSCode](vscode-extension/installation.html)|

\* _When you use a VMware Tanzu Kubernetes Grid cluster, there is no need to install Cluster Essentials because the contents of Cluster Essentials are already installed on your cluster._

After installing Tanzu Application Platform on to your Kubernetes clusters, proceed with [Getting started with the Tanzu Application Platform](getting-started.html).

## <a id='install-air-gap'></a>Installing Tanzu Application Platform in an air-gapped environment (Beta)

The process of installing Tanzu Application Platform on your own Kubernetes clusters in an air-gapped environment includes the following tasks:

|Step|Task|Link|
|----|----|----|
|1.| Review the prerequisites to ensure that you have set up everything required before beginning the installation |[Prerequisites](prerequisites.html)|
|2.| Accept Tanzu Application Platform EULAs and install the Tanzu CLI |[Accepting Tanzu Application Platform EULAs and installing the Tanzu CLI](install-tanzu-cli.html)|
|3.| Install Cluster Essentials for Tanzu* |[Deploying Cluster Essentials](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/1.2/cluster-essentials/GUID-deploy.html)|
|4.| Add the Tanzu Application Platform package repository, prepare your Tanzu Application Platform profile, and install the profile to the cluster |[Install Tanzu Application Platform in an air-gapped environment](install-air-gap.html)|
|5.| Install Tanzu Build Service full dependencies |[Install Tanzu Build Service dependencies air-gapped](tanzu-build-service/install-airgapped.html#tbs-offline-install-deps)|
|6.| Configure custom CAs for Tanzu Application Platform GUI | [Configuring custom CAs for Tanzu Application Platform GUI](tap-gui/non-standard-certs.md) |
|7.| Add the certificate for the private Git repository in the Accelerator system namespace |[Configure Application Accelerator](application-accelerator/configuration.html)|
|8.| Apply patch to Grype |[Using Grype in offline and air-gapped environments](scst-scan/offline-airgap.html)|
|9.| Set up developer namespaces to use installed packages |[Setting up developer namespaces to use installed packages](set-up-namespaces.html)|

\* _When you use a VMware Tanzu Kubernetes Grid cluster, there is no need to install Cluster Essentials because the contents of Cluster Essentials are already installed on your cluster._

After installing Tanzu Application Platform on to your air-gapped cluster, you can start creating workloads that run in your air-gapped containers.
For instructions, see [Deploy your first air-gapped workload (beta)](getting-started/air-gap-workload.html).

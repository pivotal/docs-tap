# Installing Tanzu Application Platform

You can install Tanzu Application Platform by using one of the following methods:

- [Installing Tanzu Application Platform online](#install-online). For Tanzu Application Platform on a Kubernetes cluster with internet access.
- [Installing Tanzu Application Platform in an air-gapped environment](#install-air-gap). For Tanzu Application Platform on a Kubernetes cluster air-gapped from external traffic.
- [Installing Tanzu Application Platform in AWS](#install-on-aws). For installing Tanzu Application platform using AWS Cloud Services.
- [Deploying Tanzu Application Platform through AWS Quick Start on Amazon EKS](https://aws.amazon.com/quickstart/architecture/vmware-tanzu-application-platform/). For a reference deployment of Tanzu Application Platform on Amazon Elastic Kubernetes Service (Amazon EKS) using AWS CloudFormation.

## <a id='install-online'></a>Installing Tanzu Application Platform online

To install Tanzu Application Platform on your Kubernetes clusters with internet access:

|Step|Task|Link|
|----|----|----|
|1.| Review the prerequisites to ensure you have met all requirements before installing. |[Prerequisites](prerequisites.html)|
|2.| Accept Tanzu Application Platform EULAs and install the Tanzu CLI. |[Accepting Tanzu Application Platform EULAs and installing the Tanzu CLI](install-tanzu-cli.html)|
|3.| Install Cluster Essentials for Tanzu*. |[Deploying Cluster Essentials](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/1.2/cluster-essentials/GUID-deploy.html)|
|4.| Add the Tanzu Application Platform package repository, prepare your Tanzu Application Platform profile, and install the profile to the cluster. |[Installing the Tanzu Application Platform package and profiles](install.html)|
|5.| (Optional) Install any additional packages that were not in the profile. |[Installing Individual Packages](install-components.html)|
|6.| Set up developer namespaces to use installed packages. |[Setting up developer namespaces to use installed packages](set-up-namespaces.html)|
|7.| Install developer tools into your integrated development environment (IDE). |[Installing Tanzu Developer Tools for VS Code](vscode-extension/install.html)|

\* _When you use a VMware Tanzu Kubernetes Grid cluster, there is no need to install Cluster Essentials because the contents of Cluster Essentials are already installed on your cluster._

After installing Tanzu Application Platform on to your Kubernetes clusters, proceed with [Getting started with the Tanzu Application Platform](getting-started.html).

## <a id='install-air-gap'></a>Installing Tanzu Application Platform in an air-gapped environment

To install Tanzu Application Platform on your Kubernetes clusters in an air-gapped environment:

|Step|Task|Link|
|----|----|----|
|1.| Review the prerequisites to ensure you have met all requirements before installing. |[Prerequisites](prerequisites.html)|
|2.| Accept Tanzu Application Platform EULAs and install the Tanzu CLI. |[Accepting Tanzu Application Platform EULAs and installing the Tanzu CLI](install-tanzu-cli.html)|
|3.| Install Cluster Essentials for Tanzu*. |[Deploying Cluster Essentials](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/1.2/cluster-essentials/GUID-deploy.html)|
|4.| Add the Tanzu Application Platform package repository, prepare your Tanzu Application Platform profile, and install the profile to the cluster. |[Installing Tanzu Application Platform in an air-gapped environment](install-air-gap.html)|
|5.| Install Tanzu Build Service full dependencies. |[Installing the Tanzu Build Service dependencies](tbs-offline-install-deps.html)|
|6.| Configure custom certificate authorities for Tanzu Application Platform GUI. |[Configuring custom certificate authorities for Tanzu Application Platform GUI](tap-gui/non-standard-certs.html) |
|7.| Add the certificate for the private Git repository in the Accelerator system namespace. |[Configuring Application Accelerator](application-accelerator/configuration.html)|
|8.| Apply patch to Grype. |[Using Grype in offline and air-gapped environments](scst-scan/offline-airgap.html)|
|9.| Set up developer namespaces to use installed packages. |[Setting up developer namespaces to use installed packages](set-up-namespaces.html)|

\* _When you use a VMware Tanzu Kubernetes Grid cluster, there is no need to install Cluster Essentials because the contents of Cluster Essentials are already installed on your cluster._

After installing Tanzu Application Platform on to your air-gapped cluster, you can start creating workloads that run in your air-gapped containers.
For instructions, see [Deploy your first air-gapped workload](getting-started/air-gap-workload.html).

## <a id='install-on-aws'></a>Installing Tanzu Application Platform on AWS Cloud

To install Tanzu Application Platform on [Amazon Elastic Kubernetes Services (EKS)](https://aws.amazon.com/eks/) by using [Amazon Elastic Container Registry (ECR)](https://aws.amazon.com/ecr/):

> **Note:** The outcome of this deployment is similar to the outcome of [Deploying Tanzu Application Platform through AWS Quick Start on Amazon EKS](https://aws.amazon.com/quickstart/architecture/vmware-tanzu-application-platform/), but it gives the users the flexibility to customize the deployment.

|Step|Task|Link|
|----|----|----|
|1.| Review the prerequisites to ensure that you have set up everything required before beginning the installation |[Prerequisites](prerequisites.html)|
|2.| Accept Tanzu Application Platform EULAs and install the Tanzu CLI |[Accepting Tanzu Application Platform EULAs and installing the Tanzu CLI](install-tanzu-cli.html)|
|3.| Create AWS Resources (EKS Cluster, roles, etc)|[Create AWS Resources](aws-resources.html)|
|4.| Install Cluster Essentials for Tanzu |[Deploying Cluster Essentials](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/1.2/cluster-essentials/GUID-deploy.html)|
|5.| Add the Tanzu Application Platform package repository, prepare your Tanzu Application Platform profile, and install the profile to the cluster |[Installing the Tanzu Application Platform package and profiles](install-aws.html)|
|6.| (Optional) Install any additional packages that were not in the profile |[Installing Individual Packages](install-components.html)|
|7.| Set up developer namespaces to use installed packages |[Setting up developer namespaces to use installed packages](set-up-namespaces-aws.html)|
|8.| Install developer tools into your integrated development environment (IDE) |[Installing Tanzu Developer Tools for VS Code](vscode-extension/install.html)|

After installing Tanzu Application Platform on to your Kubernetes clusters, proceed with [Getting started with the Tanzu Application Platform](getting-started.html).

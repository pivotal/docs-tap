# Installing Tanzu Application Platform

You can install Tanzu Application Platform by using **either** of the following methods:

- [Installing Tanzu Application Platform on your own Kubernetes clusters](#install-own-cluster)
- [Installing Tanzu Application Platform by using AWS Quick Start](#install-aws)

## <a id='install-own-cluster'></a>Installing Tanzu Application Platform on your own Kubernetes clusters

### <a id='prepare-tap'></a>Prepare to deploy Tanzu Application Platform

Complete the following tasks before you deploy Tanzu Application Platform on your own Kubernetes clusters:

|Step|Task|Link|
|----|----|----|
|1.| Review the prerequisites to ensure that you have set up everything required before beginning the installation |[Prerequisites](prerequisites.html)|
|2.| Accept Tanzu Application Platform EULAs and install the Tanzu CLI |[Accepting Tanzu Application Platform EULAs and installing the Tanzu CLI](install-tanzu-cli.html)|
|3.| Install Cluster Essentials for Tanzu* |[Deploying Cluster Essentials](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/1.1/cluster-essentials/GUID-deploy.html)|

\* _When you use a VMware Tanzu Kubernetes Grid cluster, there is no need to install Cluster Essentials because the contents of Cluster Essentials are already installed on your cluster._

### <a id='deploy-tap'></a>Deploy Tanzu Application Platform

Complete the following tasks to deploy Tanzu Application Platform on your own Kubernetes clusters:

|Step|Task|Link|
|----|----|----|
|1.| Add the Tanzu Application Platform package repository, prepare your Tanzu Application Platform profile, and install the profile to the cluster |[Installing the Tanzu Application Platform package and profiles](install.html)|
|2.| (Optional) Install any additional packages that were not in the profile |[Installing Individual Packages](install-components.html)|
|3.| Set up developer namespaces to use installed packages |[Setting up developer namespaces to use installed packages](set-up-namespaces.html)|

## <a id='install-aws'></a>Installing Tanzu Application Platform by using AWS Quick Start

The process of installing Tanzu Application Platform by using AWS Quick Start includes the following tasks:

|Step|Task|Link|
|----|----|----|
|1.| task 1 |[link name 1](external link 1)|
|2.| task 2 |[link name 2](external link 2)|
|3.| task 3 |[link name 3](external link 3)|

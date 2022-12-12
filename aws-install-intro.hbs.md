# Installing Tanzu Application Platform (AWS)

You can install Tanzu Application Platform on [Amazon Elastic Kubernetes Services (EKS)](https://aws.amazon.com/eks/) by using [Amazon Elastic Container Registry (ECR)](https://aws.amazon.com/ecr/).
The outcome of this deployment is similar to the outcome of [Deploying Tanzu Application Platform through AWS Quick Start on Amazon EKS](https://aws.amazon.com/quickstart/architecture/vmware-tanzu-application-platform/), but it provides added flexibility to customize the deployment.

To install, take the following steps.

|Step|Task|Link|
|----|----|----|
|1.| Review the prerequisites to ensure that you have set up everything required before beginning the installation |[Prerequisites](prerequisites.hbs.md)|
|2.| Accept Tanzu Application Platform EULAs and install the Tanzu CLI |[Accepting Tanzu Application Platform EULAs and installing the Tanzu CLI](install-tanzu-cli.hbs.md)|
|3.| Create AWS Resources (EKS Cluster, roles, etc)|[Create AWS Resources](aws-resources.hbs.md)|
|4.| Install Cluster Essentials for Tanzu |[Deploying Cluster Essentials](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/GUID-deploy.html)|
|5.| Add the Tanzu Application Platform package repository, prepare your Tanzu Application Platform profile, and install the profile to the cluster |[Installing the Tanzu Application Platform package and profiles](install-aws.hbs.md)|
|6.| (Optional) Install any additional packages that were not in the profile |[Installing Individual Packages](install-components.hbs.md)|
|7.| Set up developer namespaces to use installed packages |[Setting up developer namespaces to use installed packages](set-up-namespaces-aws.hbs.md)|
|8.| Install developer tools into your integrated development environment (IDE) |[Installing Tanzu Developer Tools for VS Code](vscode-install-aws.hbs.md)|

After installing Tanzu Application Platform on to your Kubernetes clusters, proceed with [Get started with Tanzu Application Platform](getting-started.hbs.md).  But don't forget to create your ECR repositories for your workload (.e.g. tanzu-application-platform/tanzu-java-web-app-default, tanzu-application-platform/tanzu-java-web-app-default-bundle, and tanzu-application-platform/tanzu-java-web-app-default-source).

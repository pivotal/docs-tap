# Install Tanzu Application Platform (AWS)

You can install Tanzu Application Platform (commonly known as TAP) on 
[Amazon Elastic Kubernetes Services (EKS)](https://aws.amazon.com/eks/) by using 
[Amazon Elastic Container Registry (ECR)](https://aws.amazon.com/ecr/).

To install, take the following steps.

|Step|Task|Link|
|----|----|----|
|1.| Review the prerequisites to ensure that you have set up everything required before beginning the installation |[Prerequisites](../prerequisites.hbs.md)|
|2.| Accept Tanzu Application Platform EULAs and install the Tanzu CLI |[Accept Tanzu Application Platform EULAs and installing the Tanzu CLI](../install-tanzu-cli.hbs.md)|
|3.| Create AWS Resources (EKS Cluster, roles, etc)|[Create AWS Resources](resources.hbs.md)|
|4.| Install Cluster Essentials for Tanzu |[Deploy Cluster Essentials](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/deploy.html)|
|5.| Add the Tanzu Application Platform package repository, prepare your Tanzu Application Platform profile, and install the profile to the cluster |[Install the Tanzu Application Platform package and profiles](profile.hbs.md)|
|6.| (Optional) Install any additional packages that were not in the profile |[Install individual packages](../install-online/components.hbs.md)|
|7.| Set up developer namespaces to use your installed packages |[Set up developer namespaces to use your installed packages](set-up-namespaces.hbs.md)|
|8.| Install developer tools into your integrated development environment (IDE) |[Install Tanzu Developer Tools for your VS Code](vscode-install.hbs.md)|

After installing Tanzu Application Platform on your Kubernetes clusters,
[get started with Tanzu Application Platform](../getting-started.hbs.md) and create your ECR repositories
for your workload, such as `tanzu-application-platform/tanzu-java-web-app-default`,
`tanzu-application-platform/tanzu-java-web-app-default-bundle`, and
`tanzu-application-platform/tanzu-java-web-app-default-source`.

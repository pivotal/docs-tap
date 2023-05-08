# Install Tanzu Application Platform (online)

To install Tanzu Application Platform (commonly known as TAP) on your Kubernetes 
clusters with internet access:

|Step|Task|Link|
|----|----|----|
|1.| Review the prerequisites to ensure you have met all requirements before installing. |[Prerequisites](../prerequisites.hbs.md)|
|2.| Accept Tanzu Application Platform EULAs and install the Tanzu CLI. |[Accept Tanzu Application Platform EULAs and installing the Tanzu CLI](../install-tanzu-cli.hbs.md)|
|3.| Install Cluster Essentials for Tanzu*. |[Deploy Cluster Essentials](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/deploy.html)|
|4.| Add the Tanzu Application Platform package repository, prepare your Tanzu Application Platform profile, and install the profile to the cluster. |[Install the Tanzu Application Platform package and profiles](profile.hbs.md)|
|5.| (Optional) Install any additional packages that were not in the profile. |[Install individual packages](components.hbs.md)|
|6.| Set up developer namespaces to use your installed packages. |[Set up developer namespaces to use your installed packages](set-up-namespaces.hbs.md)|
|7.| Install developer tools into your integrated development environment (IDE). |[Install Tanzu Developer Tools for your VS Code](vscode-install.hbs.md)|

\* _When you use a VMware Tanzu Kubernetes Grid cluster, there is no need to install Cluster Essentials because the contents of Cluster Essentials are already installed on your cluster._

After installing Tanzu Application Platform on to your Kubernetes clusters, proceed with [Get started with Tanzu Application Platform](../getting-started.html).

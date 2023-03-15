# GitOps 

To install Tanzu Application Platform on your Kubernetes clusters using GitOps:

SOPS
: Install with sensitive data encrypted in hosted Git repo:

    |Step|Task|Link|
    |----|----|----|
    |1.| Review the prerequisites to ensure you have met all requirements before installing. |[Prerequisites](prerequisites.hbs.md)|
    |2.| Accept Tanzu Application Platform EULAs and install the Tanzu CLI. |[Accept Tanzu Application Platform EULAs and installing the Tanzu CLI](install-tanzu-cli.hbs.md)|
    |3.| Install Cluster Essentials for Tanzu*. |[Deploy Cluster Essentials](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/deploy.html)|
    |4.| Install Tanzu Application Platform. |[Install Tanzu Application Platform via Gitops](gitops-install-sops.hbs.md)
    |5.| (Optional) Install any additional packages that were not in the profile. |[Install individual packages](install-components.hbs.md)|
    |6.| Set up developer namespaces to use installed packages. |[Set up developer namespaces to use installed packages](set-up-namespaces.hbs.md)|
    |7.| Install developer tools into your integrated development environment (IDE). |[Install Tanzu Developer Tools for VS Code](vscode-install-online.hbs.md)|

ESO
: Install with sensitive data encrypted in AWS Secret Store:

    |Step|Task|Link|
    |----|----|----|
    |1.| Review the prerequisites to ensure you have met all requirements before installing. |[Prerequisites](prerequisites.hbs.md)|
    |2.| Accept Tanzu Application Platform EULAs and install the Tanzu CLI. |[Accept Tanzu Application Platform EULAs and installing the Tanzu CLI](install-tanzu-cli.hbs.md)|
    |x | --- reviewed to here --- | .. |
    |3.| Create AWS Resources (EKS Cluster, roles, etc)|[Create AWS Resources](aws-resources.hbs.md)|
    |4.| Install Cluster Essentials for Tanzu*. |[Deploy Cluster Essentials](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/deploy.html)|
    |5.| Add the Tanzu Application Platform package repository, prepare your Tanzu Application Platform profile, and install the profile to the cluster. |[Install the Tanzu Application Platform package and profiles](install-gitops-eso.hbs.md)|
    |6.| (Optional) Install any additional packages that were not in the profile. |[Install individual packages](install-components.hbs.md)|
    |7.| Set up developer namespaces to use installed packages. |[Set up developer namespaces to use installed packages](set-up-namespaces.hbs.md)|
    |8.| Install developer tools into your integrated development environment (IDE). |[Install Tanzu Developer Tools for VS Code](vscode-install-online.hbs.md)|

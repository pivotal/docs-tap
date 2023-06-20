# Install Tanzu Application Platform (GitOps)

GitOps is a set of practices and principles to manage Kubernetes infrastructure and application deployments using Git as the single source of truth. It promotes declarative configurations and automated workflows to ensure consistency, reliability, and traceability in the deployment process.
 
Some of the key components involved in GitOps with Kubernetes:

- **Git as the Single Source of Truth**: The desired state is stored in a Git repository. Whenever the cluster state needs to be changed, instead of modifying it directly on the cluster, it has to be changed in the git repository.
- **Declarative Configuration**: GitOps follows a declarative approach, where the desired state is defined in declarative configuration files.
- **Pull-based Synchronization**: GitOps follows a pull-based model. Kubernetes cluster periodically pulls the desired state from the Git repository. This approach ensures that the cluster is always in sync with the desired configuration.

## How Tanzu RI supports GitOps

Tanzu GitOps RI is based on the same packaging API as the Tanzu Application Platform (i.e. Carvel). Carvel Packaging APIs support all the above characteristics which we have defined earlier and thus can enable GitOps flow natively.
- All the packaging APIs are declarative in nature.
- Among many options to fetch the manifest which needs to be deployed, it can also pull the content from the git thus making git the source of truth.
- Packages installed get reconciled every time after the syncPeriod is expired (by default it is 10 min). As part of the reconciliation, it will again get the manifest from the git repository and in case the desired state is different from the actual state on Kubernetes, it will converge the resources to their desired state declared in git.
 
## GitOps benefits:
- **Compliance and Auditing Capabilities**: In GitOps, git is the only source of truth. Thus an auditor can get the audit trail of every configuration change.
- **Disaster Recovery**: Disaster recovery is an organization's method of regaining access and functionality to its IT infrastructure after a natural or human disaster. Since all the configurations were stored in Git, disaster recovery becomes as simple as reapplying the desired configuration version.
- **Repeatable**: No need to run individual Tanzu CLI commands with environment variables/configuration files locally on a machine. All configuration/service accounts required for access are all configured together in a shared git repository. Any operator can edit a file and the behavior of the system is not dependent on their local environment.

>**Caution** Tanzu Application Platform (GitOps) is currently in beta and is intended for evaluation and test purposes only. Do not use in a production environment.

{{#unless vars.hide_content}}
<!-- TODO: this release is ready for production use in a specific set of conditions, review these conditions to see if your situation qualifies
  - general GitOps benefits/wants
  - if you want a simple instance and can store sensitive data encrypted ni your git repo ==> #SOPS
  - if you need to store secrest in external store blah blah... => #ESO

-->
{{/unless}}

Choose one of the following install paths to install Tanzu Application Platform on your Kubernetes clusters through GitOps:

GitOps with Secrets OPerationS (SOPS)
: Applies to the scenario when you want a simple instance and store sensitive data encrypted in your Git repo:

    |Step|Task|Link|
    |----|----|----|
    |1.| Review the prerequisites to ensure you have met all requirements before installing. |[Prerequisites](../prerequisites.hbs.md)|
    |2.| Accept Tanzu Application Platform EULAs and install the Tanzu CLI. |[Accept Tanzu Application Platform EULAs and installing the Tanzu CLI](../install-tanzu-cli.hbs.md)|
    |3.| Install Cluster Essentials for Tanzu*. |[Deploy Cluster Essentials](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/deploy.html)|
    |4.| Install Tanzu Application Platform. |[Install Tanzu Application Platform through Gitops with Secrets OPerationS (SOPS)](sops.hbs.md)
    |5.| (Optional) Install any additional packages that were not in the profile. |[Install individual packages](components.hbs.md)|
    |6.| Set up developer namespaces to use your installed packages. |[Set up developer namespaces to use your installed packages](set-up-namespaces.hbs.md)|
    |7.| Install developer tools into your integrated development environment (IDE). |[Install Tanzu Developer Tools for your VS Code](vscode-install.hbs.md)|

GitOps with External Secrets Operator (ESO)
: Applies to the scenario when you want to store sensitive data in external store:

    <!-- ... "Supported on AWS Secrets Manager" ... -->

    |Step|Task|Link|
    |----|----|----|
    |1.| Review the prerequisites to ensure you have met all requirements before installing. |[Prerequisites](../prerequisites.hbs.md)|
    |2.| Accept Tanzu Application Platform EULAs and install the Tanzu CLI. |[Accept Tanzu Application Platform EULAs and installing the Tanzu CLI](../install-tanzu-cli.hbs.md)|
    |3.| Create AWS Resources (EKS Cluster, roles, etc)|[Create AWS Resources](../install-aws/resources.hbs.md)|
    |4.| Install Cluster Essentials for Tanzu*. |[Deploy Cluster Essentials](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/deploy.html)|
    |5.| Add the Tanzu Application Platform package repository, prepare your Tanzu Application Platform profile, and install the profile to the cluster. |[Install Tanzu Application Platform through GitOps with External Secrets Operator (ESO)](eso.hbs.md)|
    |6.| (Optional) Install any additional packages that were not in the profile. |[Install individual packages](components.hbs.md)|
    |7.| Set up developer namespaces to use your installed packages. |[Set up developer namespaces to use your installed packages](set-up-namespaces.hbs.md)|
    |8.| Install developer tools into your integrated development environment (IDE). |[Install Tanzu Developer Tools for your VS Code](vscode-install.hbs.md)|

\* _When you use a VMware Tanzu Kubernetes Grid cluster, there is no need to install Cluster Essentials because the contents of Cluster Essentials are already installed on your cluster._

After installing Tanzu Application Platform on to your Kubernetes clusters, proceed with [Get started with Tanzu Application Platform](../getting-started.hbs.md).

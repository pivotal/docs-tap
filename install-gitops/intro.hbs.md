# Install Tanzu Application Platform (GitOps)

GitOps is a set of practices and principles to manage Kubernetes infrastructure and application deployments using Git as the single source of truth. It promotes declarative configurations and automated workflows to ensure consistency, reliability, and traceability for your application deployments.
 
The key components involved in implementing GitOps with Kubernetes include:

- **Git as the single source of truth**: The desired state is stored in a Git repository. To change the cluster state, you must change it in the Git repository instead of modifying it directly on the cluster.
- **Declarative configuration**: GitOps follows a declarative approach, where the desired state is defined in the declarative configuration files.
- **Pull-based synchronization**: GitOps follows a pull-based model. Kubernetes cluster periodically pulls the desired state from the Git repository. This approach ensures that the cluster is always in sync with the desired configuration.

>**Caution** Tanzu Application Platform (GitOps) is currently in beta and is intended for evaluation and test purposes only. Do not use in a production environment.

## <a id="tanzu-gitops-ri"></a> How Tanzu RI supports GitOps

The Tanzu GitOps Reference Implementation (RI) is built upon Carvel, which shares the same packaging APIs as the Tanzu Application Platform. Carvel packaging APIs support all the GitOps features and enables a native GitOps flow.

- All the packaging APIs are declarative in nature.
- Among many options to fetch the manifest to be deployed, it can also pull the content from the Git repository, making Git the source of truth.
- Packages installed are reconciled every time after the SyncPeriod expires (10 minutes by default). As part of the reconciliation, it fetches the manifest from the Git repository and when the desired state is different from the actual state on Kubernetes, it converges the resources to their desired state declared in Git.
 
## <a id="benefits"></a>GitOps benefits

GitOps offers the following benefits:

- **Compliance and auditing capabilities**: In GitOps, Git is the single source of truth, enabling auditors to access a complete audit trail of all configuration changes.
- **Disaster recovery**: Disaster recovery involves an organization's efforts to restore access and function to its IT infrastructure. With all configurations securely stored in Git, disaster recovery becomes as straightforward  as reapplying the desired configuration version.
- **Repeatable**: Running Tanzu CLI commands with environment variables or configuration files on a local machine is no longer required. Instead, all the necessary configurations and service accounts for access are configured in a shared Git repository. This approach allows any operator to make edits to a file, and the system's behavior remains independent of their local environment.

{{#unless vars.hide_content}}
<!-- TODO: this release is ready for production use in a specific set of conditions, review these conditions to see if your situation qualifies
  - general GitOps benefits/wants
  - if you want a simple instance and can store sensitive data encrypted ni your git repo ==> #SOPS
  - if you need to store secrest in external store blah blah... => #ESO

-->
{{/unless}}

## <a id="install-paths"></a>GitOps install paths

Choose one of the following install paths to install Tanzu Application Platform on your Kubernetes clusters through GitOps:

>**Note** To decide which approach to use, see [Choosing SOPS or ESO](reference.hbs.md#choosing-sops-or-eso).

## <a id='sops'></a>GitOps with Secrets OPerationS (SOPS)

Applies to the scenario when you want a simple instance and store sensitive data encrypted in your Git repo:

|Step|Task|Link|
|----|----|----|
|1.| Review the prerequisites to ensure you have met all requirements before installing. |[Prerequisites](../prerequisites.hbs.md)|
|2.| Accept Tanzu Application Platform EULAs and install the Tanzu CLI. |[Accept Tanzu Application Platform EULAs and installing the Tanzu CLI](../install-tanzu-cli.hbs.md)|
|3.| Install Cluster Essentials for Tanzu*. |[Deploy Cluster Essentials](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/deploy.html)|
|4.| Install Tanzu Application Platform. |[Install Tanzu Application Platform through Gitops with Secrets OPerationS (SOPS)](sops.hbs.md)
|5.| (Optional) Install any additional packages that were not in the profile. |[Install individual packages](components.hbs.md)|
|6.| Set up developer namespaces to use your installed packages. |[Set up developer namespaces to use your installed packages](set-up-namespaces.hbs.md)|
|7.| Install developer tools into your integrated development environment (IDE). |[Install Tanzu Developer Tools for your VS Code](vscode-install.hbs.md)|

## <a id='eso'></a>GitOps with External Secrets Operator (ESO)

AWS Secrets Manager
: Applies to the scenario when you want to store sensitive data in AWS Secrets Manager:

    |Step|Task|Link|
    |----|----|----|
    |1.| Review the prerequisites to ensure you have met all requirements before installing. |[Prerequisites](../prerequisites.hbs.md)|
    |2.| Accept Tanzu Application Platform EULAs and install the Tanzu CLI. |[Accept Tanzu Application Platform EULAs and installing the Tanzu CLI](../install-tanzu-cli.hbs.md)|
    |3.| Create AWS Resources such as EKS cluster and roles)|[Create AWS Resources](../install-aws/resources.hbs.md)|
    |4.| Install Cluster Essentials for Tanzu*. |[Deploy Cluster Essentials](https://{{ vars.staging_toggle }}.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/deploy.html)|
    |5.| Install Tanzu Application Platform. |[Install Tanzu Application Platform through GitOps using AWS Secrets Manager](eso/aws-secrets-manager.hbs.md)|
    |6.| (Optional) Install any additional packages that were not in the profile. |[Install individual packages](components.hbs.md)|
    |7.| Set up developer namespaces to use your installed packages. |[Set up developer namespaces to use your installed packages](set-up-namespaces.hbs.md)|
    |8.| Install developer tools into your integrated development environment (IDE). |[Install Tanzu Developer Tools for your VS Code](vscode-install.hbs.md)|

HashiCorp Vault
: Applies to the scenario when you want to store sensitive data in HashiCorp Vault:

    |Step|Task|Link|
    |----|----|----|
    |1.| Review the prerequisites to ensure you have met all requirements before installing. |[Prerequisites](../prerequisites.hbs.md)|
    |2.| Accept Tanzu Application Platform EULAs and install the Tanzu CLI. |[Accept Tanzu Application Platform EULAs and installing the Tanzu CLI](../install-tanzu-cli.hbs.md)|
    |3.| Install Cluster Essentials for Tanzu*. |[Deploy Cluster Essentials](https://{{ vars.staging_toggle }}.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/deploy.html)|
    |4.| Install Tanzu Application Platform. |[Install Tanzu Application Platform through GitOps using HashiCorp Vault](eso/hashicorp-vault.hbs.md)|
    |5.| (Optional) Install any additional packages that were not in the profile. |[Install individual packages](components.hbs.md)|
    |6.| Set up developer namespaces to use your installed packages. |[Set up developer namespaces to use your installed packages](set-up-namespaces.hbs.md)|
    |7.| Install developer tools into your integrated development environment (IDE). |[Install Tanzu Developer Tools for your VS Code](vscode-install.hbs.md)|

\* _When you use a VMware Tanzu Kubernetes Grid cluster, there is no need to install Cluster Essentials because the contents of Cluster Essentials are already installed on your cluster._

After installing Tanzu Application Platform on to your Kubernetes clusters, proceed with [Get started with Tanzu Application Platform](../getting-started.hbs.md).

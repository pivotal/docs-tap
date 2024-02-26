# Construct a Supply Chain using the CLI

{{> 'partials/supply-chain/beta-banner' }} 

## Prequisites
You will need the following CLI tools installed on your local machine:

* [Tanzu CLI](../../../install-tanzu-cli.hbs.md#install-tanzu-cli)
* [**supplychain** Tanzu CLI plugin](../how-to/install-the-cli.hbs.md)

You will need the following Packages installed on the Tanzu Application Platform cluster that you will be using to author your first supply chain:

* [Tanzu Supply Chain](../how-to/installing-supply-chain/about.hbs.md) and the out of the box catalog component packages.

To confirm if all the right packages are installed, run the following command and see if the following packages are installed and reconciled successfully.
```
$ kubectl get pkgi -A

NAMESPACE     NAME                               PACKAGE NAME                                          PACKAGE VERSION                       DESCRIPTION           AGE
tap-install   alm-catalog-component              alm-catalog.component.apps.tanzu.vmware.com           0.1.4                                 Reconcile succeeded   15d
...
tap-install   buildpack-build-component          buildpack-build.component.apps.tanzu.vmware.com       0.0.2                                 Reconcile succeeded   15d
...
tap-install   conventions-component              conventions.component.apps.tanzu.vmware.com           0.0.3                                 Reconcile succeeded   15d
...
tap-install   git-writer-component               git-writer.component.apps.tanzu.vmware.com            0.1.3                                 Reconcile succeeded   15d
...
tap-install   managed-resource-controller        managed-resource-controller.apps.tanzu.vmware.com     0.1.2                                 Reconcile succeeded   15d
...
tap-install   namespace-provisioner              namespace-provisioner.apps.tanzu.vmware.com           0.6.2                                 Reconcile succeeded   15d
...
tap-install   source-component                   source.component.apps.tanzu.vmware.com                0.0.1                                 Reconcile succeeded   15d
...
tap-install   supply-chain                       supply-chain.apps.tanzu.vmware.com                    0.1.16                                Reconcile succeeded   15d
tap-install   supply-chain-catalog               supply-chain-catalog.apps.tanzu.vmware.com            0.1.1                                 Reconcile succeeded   15d
...
tap-install   trivy-app-scanning-component       trivy.app-scanning.component.apps.tanzu.vmware.com    0.0.1-alpha.build.40376886+b5f4e614   Reconcile succeeded   15d
...
```

>**Important**
> Recommended way to install the Tanzu Supply chain is by using the beta `Authoring` TAP profile. Please refer to the [Installing with the 'authoring' profile](../how-to/installing-supply-chain/install-authoring-profile.hbs.md) documentation for installing TAP Authoring profile.

## SupplyChain authoring

The `tanzu supplychain` CLI plugin can be used by Platform Engineers to author `SupplyChains` for their developers. The `supplychain` CLI plugin supports 2 modes of operation.

* Interactive way using the guided wizard
* Non-Interactive way using Flags

But before you get to either of those options, you are required to initialize the local directory you are working on for the `supplychain` CLI generate command. You can do that using the `tanzu supplychain init` command.

### Initialize the local directory

>**Important**
> SupplyChains, especially the authoring resources `SupplyChain`, `Component` and dependent Tekton `Pipeline`/`Task`, are designed to be delivered to clusters via a Git repository and GitOps source promotion style. As a Platform Engineers, you should author the `SupplyChain` as a collection of yaml files in a file system backed by Git, and test and debug by pushing all the files to a single namespace on the `authoring` profile cluster. When you are happy with the new or modified `SupplyChain`, commit it to Git and create a pull/merge request.

The `tanzu supplychain init` command creates:

* `config.yaml` file that contains the information about the group name, and the description of the Supplychain group.
* `supplychains`, `components`, `pipelines` and `tasks` directories which will be auto populated by the authoring wizard later in this tutorial.
* `Makefile` which will has the targets to install/uninstall the SupplyChain and related dependencies on any TAP Build/Full profile clusters.
* `README.md` file which has instructions on how to use the targets in the `Makefile`.

The `tanzu supplychain init` command take 2 optional flags:

* `--group`: Group of the supplychains **(default "supplychains.tanzu.vmware.com")**
* `--description`: Description of the Group. **(default "")**


## Ensure your Components and Supply Chains adhere to version constraints

Please refer to the reference doc on [Understanding SupplyChains](./../../explanation/supply-chains.hbs.md#supply-chains-cannot-change-an-api-once-it-is-on-cluster), specifically the section labelled `Supply Chains cannot change an API once it is on-cluster` for information on how `SupplyChains` and `Components` should be versioned in order to avoid delivery failures of your `Supplychain` resources to your Build clusters.

## Reference Guides

### Out of the Box Catalog of Components

* [Catalog of Tanzu Supply Chain Components](./../../../reference/catalog/about.hbs.md)
* [Output Types for Catalog Components](./../../../reference/catalog/output-types.hbs.md)

### Reference Guides

* [Understand SupplyChains](./../../explanation/supply-chains.hbs.md)
* [Understand Components](./../../explanation/components.hbs.md)
* [Understand Resumptions](./../../explanation/resumptions.hbs.md)
* [Understand Workloads](./../../explanation/workloads.hbs.md)
* [Understand WorkloadRuns](./../../explanation/workload-runs.hbs.md)

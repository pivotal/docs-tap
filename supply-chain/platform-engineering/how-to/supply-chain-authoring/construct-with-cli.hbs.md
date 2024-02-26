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

SupplyChains, particularly the authoring resources such as `SupplyChain`, `Component`, and the Tekton `Pipeline`/`Task` dependencies, are intended to be deployed to clusters through a Git repository using the GitOps source promotion methodology. As a Platform Engineer, the recommended approach involves authoring the `SupplyChain` using a set of YAML files within a Git-backed file system. Testing and debugging can be performed by pushing all files to a single namespace on the `authoring` profile cluster. Once satisfied with the new or modified `SupplyChain`, it should be committed to Git, initiating a pull/merge request. However, managing a potentially large number of YAML manifests manually can be error-prone. This is where the `tanzu supplychain` CLI plugin becomes invaluable. Platform Engineers can leverage the `tanzu supplychain` CLI plugin to streamline the authoring process for `SupplyChains` tailored to their developers.

The `supplychain` CLI plugin supports 2 modes of operation for generating SupplyChains.

* **Interactive** way using the guided wizard
* **Non-Interactive** way using flags

But before you get to either of those options, you are required to initialize the local directory you are working on for the `supplychain` CLI generate command. You can do that using the `tanzu supplychain init` command.

>**Important**
> Ideally, Platform Engineers should execute the `tanzu supplychain init/generate` commands on the local version of their GitOps repository, which they intend to utilize for deploying SupplyChains to their Build clusters. The `tanzu supplychain` CLI plugin commands are designed to assist Platform Engineers in scaffolding and populating the local directory with the intended configuration of SupplyChains that they plan to deploy in their Build clusters.

### Initialize the local directory

The `tanzu supplychain init` command creates:

* `config.yaml` file that contains the information about the group name, and the description of the Supplychain group.
* `supplychains`, `components`, `pipelines` and `tasks` directories which will be auto populated by the authoring wizard later in this tutorial.
* `Makefile` which will has the targets to install/uninstall the SupplyChain and related dependencies on any TAP Build/Full profile clusters.
* `README.md` file which has instructions on how to use the targets in the `Makefile`.

The `tanzu supplychain init` command take 2 optional flags:

* `--group`: Group of the supplychains **(default "supplychains.tanzu.vmware.com")**
  * Group is used for auto populating `spec.defines.group` of the [SupplyChain API](../../../reference/api/supplychain.hbs.md#specdefinesgroup)
* `--description`: Description of the Group. **(default "")**

>**Important**
> After being set up with the designated `group`, the local directory becomes a hub for shipping one or more `SupplyChains`. It's important to note that within this local directory, every `SupplyChain` should share the same `group`, and this group information is stored in the `config.yaml` file. Conversely, in your GitOps repository, multiple folders can exist, each initialized with distinct groups such as `hr.supplychains.company.biz`, `finance.supplychains.company.biz`, and so on. Each of these folders is capable of accommodating multiple `SupplyChains` tailored to their respective groups.

Here is an example on how to execute the `tanzu supplychain init` command:

```
$ tanzu supplychain init --group supplychains.tanzu.vmware.com --description "This is my first Supplychain group"

Initializing group supplychains.tanzu.vmware.com
Creating directory structure
 ├─ supplychains/
 ├─ components/
 ├─ pipelines/
 ├─ tasks/
 ├─ Makefile
 ├─ README.md
 └─ config.yaml

Writing group configuration to config.yaml
```

### Inspecting Components available to author Supply Chains

As a Platform Engineer, I want to know which components are available for me to use in my SupplyChain. I can do that by running the following command:

```
$ tanzu supplychain component list

Listing components from the catalog
  NAME                             INPUTS                                                        OUTPUTS                                                       AGE  
  app-config-server-1.0.0          conventions[conventions]                                      oci-yaml-files[oci-yaml-files], oci-ytt-files[oci-ytt-files]  14d  
  app-config-web-1.0.0             conventions[conventions]                                      oci-yaml-files[oci-yaml-files], oci-ytt-files[oci-ytt-files]  14d  
  app-config-worker-1.0.0          conventions[conventions]                                      oci-yaml-files[oci-yaml-files], oci-ytt-files[oci-ytt-files]  14d  
  carvel-package-1.0.0             oci-yaml-files[oci-yaml-files], oci-ytt-files[oci-ytt-files]  package[package]                                              14d  
  deployer-1.0.0                   package[package]                                              <none>                                                        14d  
  source-package-translator-1.0.0  source[source]                                                package[package]                                              14d  
  conventions-1.0.0                image[image]                                                  conventions[conventions]                                      14d  
  app-config-web-1.0.0             conventions[conventions]                                      oci-yaml-files[oci-yaml-files], oci-ytt-files[oci-ytt-files]  14d   
  git-writer-1.0.0                 package[package]                                              <none>                                                        14d  
  git-writer-pr-1.0.0              package[package]                                              git-pr[git-pr]                                                14d  
  source-git-provider-1.0.0        <none>                                                        source[source], git[git]                                      14d  
  buildpack-build-1.0.0            source[source], git[git]                                      image[image]                                                  14d  
  trivy-image-scan-1.0.0           image[image], git[git]                                        <none>                                                        14d  

🔎 To view the details of a component, use 'tanzu supplychain component get'
```
You can use the `-w/--wide` flag on the list command to see a more verbose output including description of each components.

>**Important**
> The `tanzu supplychain component list` command scans for `Component` custom resources labeled with `supply-chain.apps.tanzu.vmware.com/catalog`. Those `Component` custom resources possessing this label are the ones taken into account for authoring `SupplyChains` with the CLI. Notably, the `Components` installed during the SupplyChain installation lack this label. This labeling distinction serves as the basis for differentiating between "Cataloged" and "Installed" `Components` in the CLI.

To get more information about what each component on the cluster, run the `tanzu supplychain component get` command. For example, to get the infomation about the `source-git-provider` component, run the following command:

```
$ tanzu supplychain component get source-git-provider-1.0.0 -n source-provider --show-details

📡 Overview
   name:         source-git-provider-1.0.0
   namespace:    source-provider
   age:          14d
   status:       True
   reason:       Ready
   description:  Monitors a git repository

📝 Configuration
   source:
     #! Use this object to retrieve source from a git repository.
     #! The tag, commit and branch fields are mutually exclusive, use only one.
     #! Required
     git:
       #! A git branch ref to watch for new source
       branch: "main"
       #! A git commit sha to use
       commit: ""
       #! A git tag ref to watch for new source
       tag: "v1.0.0"
       #! The url to the git source repository
       #! Required
       url: "https://github.com/acme/my-workload.git"
     #! The sub path in the bundle to locate source code
     subPath: ""

📤 Outputs
   git
    ├─ digest: $(resumptions.check-source.results.sha)
    ├─ type: git
    └─ url: $(resumptions.check-source.results.url)
   source
    ├─ digest: $(pipeline.results.digest)
    ├─ type: source
    └─ url: $(pipeline.results.url)

🏃 Pipeline   
    ├─ name: source-git-provider
    └─ 📋 parameters
       ├─ git-url: $(workload.spec.source.git.url)
       ├─ sha: $(resumptions.check-source.results.sha)
       └─ workload-name: $(workload.metadata.name)

🔁 Resumptions
   - check-source runs source-git-check task every 300s
     📋 Parameters
      ├─ git-branch: $(workload.spec.source.git.branch)
      ├─ git-commit: $(workload.spec.source.git.commit)
      ├─ git-tag: $(workload.spec.source.git.tag)
      └─ git-url: $(workload.spec.source.git.url)

🔎 To generate a supplychain using the available components, use 'tanzu supplychain generate'

```


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

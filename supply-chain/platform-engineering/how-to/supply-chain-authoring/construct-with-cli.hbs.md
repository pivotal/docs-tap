# Construct a Supply Chain using the CLI

{{> 'partials/supply-chain/beta-banner' }}

## Prerequisites

You will need the following CLI tools installed on your local machine:

* [Tanzu CLI](../../../../install-tanzu-cli.hbs.md#install-tanzu-cli)
* [**supplychain** Tanzu CLI plug-in](../../how-to/install-the-cli.hbs.md)

You will need the following Packages installed on the Tanzu Application Platform cluster that you will be using to author your first supply chain:

* [Tanzu Supply Chain](../../how-to/installing-supply-chain/about.hbs.md) and the out of the box catalog component packages.

To confirm if all the right packages are installed, run the following command and see if the following packages are installed and reconciled successfully.

```console
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
> VMware recommends that you install the Tanzu Supply chain using the beta `Authoring` profile.
For more information, see [Installing with the 'authoring' profile](../../how-to/installing-supply-chain/install-authoring-profile.hbs.md).

## SupplyChain authoring

SupplyChains, particularly the authoring resources such as `SupplyChain`, `Component`, and the Tekton `Pipeline`/`Task` dependencies, are intended to be deployed to clusters through a Git repository using the GitOps source promotion methodology. As a Platform Engineer, the recommended approach involves authoring the `SupplyChain` using a set of YAML files within a Git-backed file system. Testing and debugging can be performed by pushing all files to a single namespace on the `authoring` profile cluster. Once satisfied with the new or modified `SupplyChain`, it should be committed to Git, initiating a pull/merge request. However, managing a potentially large number of YAML manifests manually can be error-prone. This is where the `tanzu supplychain` CLI plug-in becomes invaluable. Platform Engineers can leverage the `tanzu supplychain` CLI plug-in to streamline the authoring process for `SupplyChains` tailored to their developers.

The `supplychain` CLI plug-in supports 2 modes of operation for generating SupplyChains.

* **Interactive** way using the guided wizard
* **Non-Interactive** way using flags

Before you use modes, you must use the `tanzu supplychain init` command to initialize the local directory for the `supplychain` CLI generate command. You can do that using.

>**Important**
> Ideally, Platform Engineers should execute the `tanzu supplychain init/generate` commands on the local version of their GitOps repository, which they intend to utilize for deploying SupplyChains to their Build clusters. The `tanzu supplychain` CLI plug-in commands are designed to assist Platform Engineers in scaffolding and populating the local directory with the intended configuration of SupplyChains that they plan to deploy in their Build clusters.

### Initialize the local directory

The `tanzu supplychain init` command creates:

* `config.yaml` file that contains the information about the group name, and the description of the Supplychain group.
* `supplychains`, `components`, `pipelines` and `tasks` directories which will be auto populated by the authoring wizard later in this tutorial.
* `Makefile` which has the targets to install or uninstall the SupplyChain and related dependencies on any Build/Full profile clusters.
* `README.md` file which has instructions on how to use the targets in the `Makefile`.

The `tanzu supplychain init` command takes two optional flags:

* `--group`: Group of the supplychains **(default "supplychains.tanzu.vmware.com")**
  * Group is used for auto-populating `spec.defines.group` of the [SupplyChain API](../../../reference/api/supplychain.hbs.md#specdefinesgroup)
* `--description`: Description of the Group. **(default "")**

>**Important**
> After being set up with the designated `group`, the local directory becomes a hub for shipping one or more `SupplyChains`. Within this local directory, every `SupplyChain` should share the same `group`, and this group information is stored in the `config.yaml` file. Conversely, in your GitOps repository, multiple folders can exist, each initialized with distinct groups such as `hr.supplychains.company.biz`, `finance.supplychains.company.biz`, and so on. Each of these folders is capable of accommodating multiple `SupplyChains` tailored to their respective groups.

Here is an example of how to execute the `tanzu supplychain init` command:

```console
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

As a Platform Engineer, you want to know which components are available  to use in you SupplyChain.
Run:

```console
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

You can use the `-w/--wide` flag on the list command to see a more detailed output including a
description of each component.

>**Important**
> The `tanzu supplychain component list` command scans for `Component` custom resources labeled with `supply-chain.apps.tanzu.vmware.com/catalog`. Those `Component` custom resources possessing this label are the ones taken into account for authoring `SupplyChains` with the CLI. Notably, the `Components` installed during the SupplyChain installation lack this label. This labeling distinction serves as the basis for differentiating between "Cataloged" and "Installed" `Components` in the CLI.

To get more information about each component on the cluster, run the `tanzu supplychain component get` command. For example, to get information about the `source-git-provider` component, run:

```console
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

## Generate the SupplyChain

As mentioned earlier, the `tanzu supplychain` CLI plug-in supports two modes of operation for generating SupplyChains.

* **Interactive** way using the guided wizard
* **Non-Interactive** way using flags

Interactive
: To kick off the wizard, use the following command:

    ```console
    $ tanzu supplychain generate
    ```

    The wizard prompt for the following:
    
    * Name of the Developer Interface
      * This value is used for auto-populating `spec.defines` section of the [SupplyChain API](../../../reference/api/supplychain.hbs.md)
    * Description of the `SupplyChain`
    * Stages of your `SupplyChain`
      * The `tanzu supplychain` CLI knows what stages are already part of the `SupplyChain` and removes them from the list of stages to add.

    Here are the example values for the prompts for the wizard workflow that will generate a functioning `SupplyChain`:

    * **What Kind would you like to use as the developer interface?** AppBuildV1
    * **Give Supply chain a description?** Supply chain that pulls the source code from git repo, builds it using buildpacks and package the output as Carvel package.
    * **Select a component as the first stage of the supply chain?** source-git-provider-1.0.0
    * **Select a component as the next stage of the supply chain?** buildpack-build-1.0.0
    * **Select a component as the next stage of the supply chain?** conventions-1.0.0
    * **Select a component as the next stage of the supply chain?** app-config-server-1.0.0
    * **Select a component as the next stage of the supply chain?** carvel-package-1.0.0
    * **Select a component as the next stage of the supply chain?** git-writer-pr-1.0.0
    * **Select a component as the next stage of the supply chain?** Done

Non-Interactive
: To generate the Supply chain using Flags, use the following command:

    ```console
    $ tanzu supplychain generate --kind AppBuildV1 --description "Supply chain that pulls the source code from git repo, builds it using buildpacks and package the output as Carvel package." --component "source-git-provider-1.0.0" --component "buildpack-build-1.0.0" --component "conventions-1.0.0" --component "app-config-server-1.0.0" --component "carvel-package-1.0.0" --component "git-writer-pr-1.0.0"
    ```

After you have selected the components for your chain, the `tanzu supplychain` CLI should create the required files to deploy your SupplyChain in the current directory and the output should look as follows:

```console
✓ Successfully fetched all component dependencies
Created file supplychains/appbuildv1.yaml
Created file components/app-config-server-1.0.0.yaml
Created file components/buildpack-build-1.0.0.yaml
Created file components/carvel-package-1.0.0.yaml
Created file components/conventions-1.0.0.yaml
Created file components/git-writer-pr-1.0.0.yaml
Created file components/source-git-provider-1.0.0.yaml
Created file pipelines/app-config-server.yaml
Created file pipelines/buildpack-build.yaml
Created file pipelines/carvel-package.yaml
Created file pipelines/conventions.yaml
Created file pipelines/git-writer.yaml
Created file pipelines/source-git-provider.yaml
Created file tasks/calculate-digest.yaml
Created file tasks/carvel-package-git-clone.yaml
Created file tasks/carvel-package.yaml
Created file tasks/check-builders.yaml
Created file tasks/fetch-tgz-content-oci.yaml
Created file tasks/git-writer.yaml
Created file tasks/gitops-git-clone.yaml
Created file tasks/prepare-build.yaml
Created file tasks/source-git-check.yaml
Created file tasks/source-git-clone.yaml
Created file tasks/store-content-oci.yaml
```

## Enforce proper ordering of Components in the SupplyChain

`Components` have zero or more `inputs` and `outputs`. The `inputs` of a `Component` should be fulfilled by another `Component` in the `SupplyChain` that precedes it. If not, you have a Component at a stage in a `SupplyChain` that will never run. Due to the strong typing nature of the Tanzu Supply Chains design, the Supply chain will return an error if a component expects an [input] that has not been [output] by a previous stage. For detailed information on the API specification for `Supplychain`, see the [SupplyChain API](./../../../reference/api/supplychain.hbs.md) reference documentation.

* If you are authoring the CLI in an interactive manner, the entries that get populated for `stage` selection already take this logic into account. The CLI only shows you components if all the inputs for that component are already satisfied by some other component in the `SupplyChain`.
* If you are authoring using the non-interactive manner, the CLI will throw an error. See example below:

```console
$ tanzu supplychain generate --kind AppBuildV1 --description "Supply chain that pulls the source code from git repo, builds it using buildpacks and package the output as Carvel package." --component "buildpack-build-1.0.0" --component "conventions-1.0.0" --component "app-config-server-1.0.0" --component "carvel-package-1.0.0" --component "git-writer-pr-1.0.0"

Error: unable to find the component buildpack-build-1.0.0 or the component buildpack-build-1.0.0 does not match expected input value
```

## Ensure your Components and Supply Chains adhere to version constraints

For information about versioning `SupplyChains` and `Components` to avoid delivery failures of your `Supplychain` resources to your Build clusters, see [Supply Chains cannot change an API once it is on-cluster](./../../explanation/supply-chains.hbs.md#not-change-api).

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

# Build your first Supply Chain

{{> 'partials/supply-chain/beta-banner' }}

In this section, we will be using the `supplychain` CLI plug-in to create our first SupplyChain for our developers. This SupplyChain will be able to pull the source code from the Git Repository, build it and package it as a Carvel package. The SupplyChain will then PR the Carvel package to a GitOps repository so the built package can be installed on the Run clusters.

## Prerequisites

You will need the following CLI tools installed on your local machine:

* [Tanzu CLI](../../../install-tanzu-cli.hbs.md#install-tanzu-cli)
* [**supplychain** Tanzu CLI plug-in](../how-to/install-the-cli.hbs.md)

You will need the following Packages installed on the Tanzu Application Platform cluster that you will be using to author your first supply chain:

* [Tanzu Supply Chain](../how-to/installing-supply-chain/about.hbs.md) and the out of the box catalog component packages.

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
> VMware recommend that you install the Tanzu Supply Chain using the beta `Authoring` profile.
For more information, see [Installing with the 'authoring' profile](../how-to/installing-supply-chain/install-authoring-profile.hbs.md).

## Getting Started

We now have an `Authoring` profile cluster that has the Tanzu Supply Chain controller, Managed Resource Controller, and Component packages installed on the cluster and we are ready to build our first SupplyChain. As a Platform Engineer, I want to know which components are available for me to use in my SupplyChain. I can do that by running the following command:

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

You can use the `-w/--wide` flag on the list command to see a more verbose output including a description of each component.

To get more information about each component on the cluster, run the `tanzu supplychain component get` command. For example, to get the infomation about the `source-git-provider` component, run the following command:

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

```console
Now that we know what components are available to create our SupplyChain, let's start the authoring process. The first step is to scaffold the current directory using the `tanzu supplychain init` command as follows:

```console
$ mkdir myfirstsupplychaingroup
$ cd myfirstsupplychaingroup
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

The `tanzu supplychain init` command creates:

* `config.yaml` file that contains the information about the group name, and the description of the Supplychain group.
* `supplychains`, `components`, `pipelines` and `tasks` directories which will be auto populated by the authoring wizard later in this tutorial.
* `Makefile` which has the targets to install/uninstall the SupplyChain and related dependencies on any Build/Full profile clusters.
* `README.md` file which has instructions on how to use the targets in the `Makefile`.

Our current directory is now initialized, and we can use the SupplyChain authoring wizard to generate our first SupplyChain. To kick off the wizard, use the following command:

```console
$ tanzu supplychain generate
```

In the prompts that follow, add the following values:

* **What Kind would you like to use as the developer interface?** AppBuildV1
* **Give Supply chain a description?** Supply chain that pulls the source code from git repo, builds it using buildpacks and package the output as Carvel package.
* **Select a component as the first stage of the supply chain?** source-git-provider-1.0.0
* **Select a component as the next stage of the supply chain?** buildpack-build-1.0.0
* **Select a component as the next stage of the supply chain?** conventions-1.0.0
* **Select a component as the next stage of the supply chain?** app-config-server-1.0.0
* **Select a component as the next stage of the supply chain?** carvel-package-1.0.0
* **Select a component as the next stage of the supply chain?** git-writer-pr-1.0.0
* **Select a component as the next stage of the supply chain?** Done

After you have selected the components for your chain, the wizard should create the required files to deploy your SupplyChain in the current directory and the output should look as follows:

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

You have now authored your first SupplyChain! you can view the SupplyChain definition created by the wizard by viewing the manifest created in the `supplychains/` folder as follows:

```console
$ cat supplychains/appbuildv1.yaml

apiVersion: supply-chain.apps.tanzu.vmware.com/v1alpha1
kind: SupplyChain
metadata:
    name: appbuildv1
spec:
    defines:
        group: supplychains.tanzu.vmware.com
        kind: AppBuildV1
        plural: appbuildv1s
        version: v1alpha1
    description: Supply chain that pulls the source code from git repo, builds it using buildpacks and package the output as Carvel package.
    stages:
        - componentRef:
            name: source-git-provider-1.0.0
          name: source-git-provider
        - componentRef:
            name: buildpack-build-1.0.0
          name: buildpack-build
        - componentRef:
            name: conventions-1.0.0
          name: conventions
        - componentRef:
            name: app-config-server-1.0.0
          name: app-config-server
        - componentRef:
            name: carvel-package-1.0.0
          name: carvel-package
        - componentRef:
            name: git-writer-pr-1.0.0
          name: git-writer-pr
```

## Next Steps

Now we need to deploy this `SupplyChain` to your Tanzu Application Platform clusters where your developers will be creating the `Workloads`. For instructions, see [How To install a Supply Chain](../how-to/deploying-supply-chains/install.hbs.md).

# Useful links

* [Supply Chain API Reference](../../reference/api/supplychain.hbs.md)
* [Component Catalog](../../reference/catalog/about.hbs.md)
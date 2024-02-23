# Build your first Supply Chain

{{> 'partials/supply-chain/beta-banner' }}

In this section, we will be using the `supplychain` CLI plugin to create our first SupplyChain for our developers. This SupplyChain will be able to pull the source code from the Git Repository, build it and package it as a Carvel package. The SupplyChain will then PR the Carvel package to a GitOps repository so the built package can be installed on the Run clusters.

## Prequisites
You will need the following CLI tools installed on your local machine:

* [Tanzu CLI](../../../install-tanzu-cli.hbs.md#install-tanzu-cli)
* [**supplychain** Tanzu CLI plugin](../how-to/install-the-cli.hbs.md)

You will need the following Packages installed on the Tanzu Application Platform cluster that you will be using to author your first supply chain:

* [Tanzu Supply Chain](../how-to/installing-supply-chain/about.hbs.md) and the out of the box catalog component packages.

>**Important**
> Recommended way to install the Tanzu Supply chain is by using the beta `Authoring` TAP profile. Please refer to the [Installing with the 'authoring' profile](../how-to/installing-supply-chain/install-authoring-profile.hbs.md) documentation for installing TAP Authoring profile.

## Getting Started

We now have a TAP `Authoring` profile cluster that has the Tanzu Supply Chain controller, Managed Resource Controller and Component packages installed on the cluster and we are ready to build our first SupplyChain. As a Platform Engineer, I want to know which components are available for me to use in my SupplyChain. I can do that by running the following command:

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
Now that we know what all components are available to create our SupplyChain, lets start the authoring process. First step would be to scaffold the current directory using the `tanzu supplychain init` command as follows:

```
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
* `Makefile` which will has the targets to install/uninstall the SupplyChain and related dependencies on any TAP Build/Full profile clusters.
* `README.md` file which has instructions on how to use the targets in the `Makefile`.

Our current directory is now initialized, and we can use the SupplyChain authoring wizard to generate our first SupplyChain. To kick off the wizard, use the following command:

```
$ tanzu supplychain generate
? What Kind would you like to use as the developer interface?
```
We will call our Developer interface `AppBuildV1`.

```
$ tanzu supplychain generate
? What Kind would you like to use as the developer interface? AppBuildV1
? Give Supply chain a description? 
```

We will 

[//]: # (Keep this section at the bottom of the doc)
# Useful links

* [Supply Chain API Reference](../../reference/api/supplychain.hbs.md)
* [Component Catalog](../../reference/catalog/about.hbs.md)
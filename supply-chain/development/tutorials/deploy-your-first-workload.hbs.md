# Tutorial: Deploy your first Workload

{{> 'partials/supply-chain/beta-banner' }} 

In this section, we will be using the `workload` CLI plugin for developers to create our first `Workload`. Our Platform Engineer has created some Supply Chains for us to use, which can pull the source code from our source repository, build it and the built artifact will be shipped to a GitOps repository of Platform Engineer's choice.

## Prequisites
You will need the following CLI tools installed on your local machine:

* [Tanzu CLI](../../../install-tanzu-cli.hbs.md#install-tanzu-cli)
* [**workload** Tanzu CLI plugin](../how-to/install-the-cli.hbs.md)

## Getting Started

As a developer, the first thing we want to know is what `SupplyChain` are available to us, and what kinds of `Workloads` we can create, that would trigger those `SupplyChain`. You can run the following `tanzu workload` command to get the list:

```
$ tanzu workload kind list

 KIND                                       VERSION   DESCRIPTION                                                                       
  appbuildv1s.supplychains.tanzu.vmware.com  v1alpha1  Supply chain that pulls the source code from git repo, builds it using            
                                                       buildpacks and package the output as Carvel package.                              

🔎 To generate a workload for one of these kinds, use 'tanzu workload generate'
```

The command output shows that we have a kind `appbuildv1s.supplychains.tanzu.vmware.com` that we can use to generate our workload. The CLI also shows a hint on the next command to use in the process. Let's use the `tanzu workload generate` command to build our workload. We will be using the sample app [tanzu-java-web-app](https://github.com/vmware-tanzu/application-accelerator-samples/tree/main/tanzu-java-web-app) for this tutorial.

```yaml
$ tanzu workload generate tanzu-java-web-app

apiVersion: supplychains.tanzu.vmware.com/v1alpha1
kind: AppBuildV1
metadata:
  name: tanzu-java-web-app
spec:
  #! Configuration for the generated Carvel Package
  carvel:
    ...
  gitOps:
    ...
  #! Configuration for the registry to use
  registry:
    ...
  source:
    ...
  #! Kpack build specification
  build:
    ...
```

>**Note**
>When you run the `tanzu workload generate` command, the `workload` CLI checks what kinds are available and shows a selector if multiple kinds are available. If a single kind is available, it uses that and generates the scaffold of the `Workload` for that kind.

>**Caution** The Beta version of the Tanzu Supply Chain does not support Platform Engineer level overrides and defaults just yet. Therefore, the `Workload` generate command will also show the entries that a Platform Engineer is supposed to set, like the registry details. Once the overrides features is available, a Platform Engineer will be able to set Platform level values like the registry details, and those entries will not be part of the `generate` command output as that is something a Platform Engineer does not want a Developer to override. This will result in a `Workload` spec that is much smaller, and one that only has values that a Developer should be able to provide for the `SupplyChain` implementing a clear seperation of concern between the Platform Engieering role and the Developer role.


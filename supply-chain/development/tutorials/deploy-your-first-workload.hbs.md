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

The command output shows that we have a kind `appbuildv1s.supplychains.tanzu.vmware.com` that we can use to generate our workload. The CLI also shows a hint on the next command to use in the process. Let's use the `tanzu workload generate` command to build our workload. We will be using the sample app [tanzu-java-web-app](https://github.com/vmware-tanzu/application-accelerator-samples/tree/main/tanzu-java-web-app) for this tutorial. Run the following command to create a `Workload` of kind `AppBuildV1`:

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

We can pipe the output of the generate command into a `workload.yaml` file as follows:
```
$ tanzu workload generate tanzu-java-web-app --kind appbuildv1s.supplychains.tanzu.vmware.com > workload.yaml
```
>**Note**
>If you have more than one kind available in the cluster, you must provide a `--kind` flag to disambiguate if you are piping the `generate` output to a file. `--kind` flag supports tab auto-completion to make it easier for developer to choose a kind.

Next step is to edit the `workload.yaml` file and put the appropriate values in the file for each required entries. Here is what our sample `workload.yaml` looks like:

```yaml
apiVersion: supplychains.tanzu.vmware.com/v1alpha1
kind: AppBuildV1
metadata:
  name: tanzu-java-web-app
spec:
  gitOps:
    baseBranch: "main"
    subPath: "packages"
    url: <gitops-repo-path>
  registry:
    repository: <repository-path>
    server: <registry-server>
  source:
    git:
      branch: "main"
      url: "https://github.com/vmware-tanzu/application-accelerator-samples.git"
    subPath: "tanzu-java-web-app"
  carvel:
    packageName: "tanzu-java-web-app"
    packageDomain: "tanzu.vmware.com"
```
>**Caution** The Beta version of the Tanzu Supply Chain does not support Platform Engineer level overrides and defaults just yet. Therefore, the `Workload` generate command will also show the entries that a Platform Engineer is supposed to set, like the registry details. Once the overrides features is available, a Platform Engineer will be able to set Platform level values like the registry details, and those entries will not be part of the `generate` command output as that is something a Platform Engineer does not want a Developer to override. This will result in a `Workload` spec that is much smaller, and one that only has values that a Developer should be able to provide for the `SupplyChain` implementing a clear seperation of concern between the Platform Engieering role and the Developer role.


After you customize the `workload.yaml` with your setup details, its time to apply the `Workload` of type `AppBuildV1`.
We will use the following to command to apply our `AppBuildV1` workload to the cluster. 

```
$ tanzu workload apply

🔎 Creating workload:
      1 + |---
      2 + |apiVersion: supplychains.tanzu.vmware.com/v1alpha1
      3 + |kind: AppBuildV1
      4 + |metadata:
      5 + |  name: tanzu-java-web-app
      6 + |  namespace: dev
      7 + |spec:
      8 + |  carvel:
      9 + |    packageDomain: tanzu.vmware.com
     10 + |    packageName: tanzu-java-web-app
     11 + |  gitOps:
     12 + |    baseBranch: main
     13 + |    subPath: packages
     14 + |    url: <gitops-repo-path>
     15 + |  registry:
     16 + |    repository: <repository-path>
     17 + |    server: <registry-server>
     18 + |  source:
     19 + |    git:
     20 + |      branch: main
     21 + |      url: https://github.com/vmware-tanzu/application-accelerator-samples.git
     22 + |    subPath: tanzu-java-web-app
Create workload tanzu-java-web-app from workload.yaml? [yN]: y
✓ Successfully created workload tanzu-java-web-app
```

>**Note**
>`tanzu workload create/apply` command looks for a file named `workload.yaml` by default. If you name your file something other than `workload.yaml`, you can specify the `-f` flag to point to it.

Our `AppBuildV1` workload is applied to the cluster. For the purpose of this tutorial, we are using the `dev` namespace. To see all the workloads of each kind running in your namespace, use the `tanzu workload list` command as follows:

```
$ tanzu workload list

Listing workloads from the dev namespace

  NAME                KIND                                       VERSION   AGE  
  tanzu-java-web-app  appbuildv1s.supplychains.tanzu.vmware.com  v1alpha1  30m  

🔎 To see more details about a workload, use 'tanzu workload get workload-name --kind workload-kind'
```

To see all the workloads running in all namespaces, run the `tanzu workload list -A`.

Now that we see our `tanzu-java-web-app` workload in the workload list, Let's see how its progressing through the Supply chain. Run the following command to get more information about your workload:

```
$ tanzu workload get tanzu-java-web-app

📡 Overview
   name:       tanzu-java-web-app
   kind:       appbuildv1s.supplychains.tanzu.vmware.com/tanzu-java-web-app
   namespace:  dev
   age:        15m

🏃 Runs:
  ID                            STATUS   DURATION  AGE  
  tanzu-java-web-app-run-454m5  Running  2m        2m  

🔎 To view a run information, use 'tanzu workload run get run-id'
```

From the output, we see that a `WorkloadRun` named `tanzu-java-web-app-run-454m5` was created when we applied our `AppBuildV1` workload using the apply command, and its in the `Running` state. There are multiple reasons why a new `WorkloadRun` will be created for your `Workload`, but few are developer triggered. Updates to your `Workload`, like changing the values in the `workload.yaml` and reapplying to the cluster will create a new `WorkloadRun`. Platform Engineering activities like updating the Buildpack builder images can also cause your `Workload` to rebuild, creating a new `WorkloadRun` with newer base images. Other activities like pushing new commits to your Source code repository that is referred by the `Workload` can also cause a new run of the `Workload` to build the latest source from your Git repository.


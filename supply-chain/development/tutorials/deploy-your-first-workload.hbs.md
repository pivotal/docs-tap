# Tutorial: Deploy your first Workload

{{> 'partials/supply-chain/beta-banner' }} 

In this section, you will use the Tanzu Workload CLI plug-in to create your first `Workload`. The Platform Engineer has already created some Supply Chains for you to use, which can pull the source code from the source repository and build it. The built artifact will be shipped to a GitOps repository determined by the  Platform Engineer.

## Prerequisites

You will need the following CLI tools installed on your local machine:

- [Tanzu CLI](../../../install-tanzu-cli.hbs.md#install-tanzu-cli)
- [Tanzu Workload CLI plug-in](../how-to/install-the-cli.hbs.md)

## Getting Started

As a developer, the first thing you want to know is what `SupplyChain` are available to you, and what kinds of `Workloads` you can create, that would trigger those `SupplyChain`. Run the following `tanzu workload` command to get the list:

```console
$ tanzu workload kind list

  KIND                                       VERSION   DESCRIPTION                                                                       
  appbuildv1s.supplychains.tanzu.vmware.com  v1alpha1  Supply chain that pulls the source code from git repo, builds it using            
                                                       buildpacks and package the output as Carvel package.                              

🔎 To generate a workload for one of these kinds, use 'tanzu workload generate'
```

The command output shows that you have a kind `appbuildv1s.supplychains.tanzu.vmware.com` that you can use to generate the workload. The Tanzu CLI also shows a hint on the next command to use in the process. Use the `tanzu workload generate` command to build your workload. Use the sample app [tanzu-java-web-app](https://github.com/vmware-tanzu/application-accelerator-samples/tree/main/tanzu-java-web-app) for this tutorial. Run the following command to create a `Workload` of kind `AppBuildV1`:

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

>**Note** When you run the `tanzu workload generate` command, the Tanzu Workload CLI checks what kinds are available and shows a selector if multiple kinds are available. If a single kind is available, it uses that and generates the scaffold of the `Workload` for that kind.

pipe the output of the generate command into a `workload.yaml` file:

```console
$ tanzu workload generate tanzu-java-web-app --kind appbuildv1s.supplychains.tanzu.vmware.com > workload.yaml
```

>**Note** If you have more than one kind available in the cluster, you must provide a `--kind` flag to disambiguate if you are piping the `generate` output to a file. `--kind` flag supports tab auto-completion to make it easier for developer to choose a kind.

The next step is to edit the `workload.yaml` file and put the appropriate values in the file for each required entries. Here is what our sample `workload.yaml` looks like:

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

>**Caution** The Beta version of the Tanzu Supply Chain does not support Platform Engineer level overrides and defaults just yet. Therefore, the `Workload` generate command will also show the entries that a Platform Engineer is supposed to set, like the registry details. Once the overrides feature is available, a Platform Engineer will be able to set Platform level values like the registry details, and those entries will not be part of the `generate` command output as that is something a Platform Engineer does not want a Developer to override. This will result in a `Workload` spec that is much smaller and one that only has values that a Developer should be able to provide for the `SupplyChain` implementing a clear separation of concern between the Platform Engieering role and the Developer role.

After you customize the `workload.yaml` with your setup details, its time to apply the `Workload` of type `AppBuildV1`.
Use the following to command to apply your `AppBuildV1` workload to the cluster. 

```console
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

>**Note** The `tanzu workload create/apply` command looks for a file named `workload.yaml` by default. If you name your file something other than `workload.yaml`, specify the `-f` flag to point to it.

The `AppBuildV1` workload is applied to the cluster. For the purpose of this tutorial, use the `dev` namespace. To see all the workloads of each kind running in your namespace, use the `tanzu workload list` command as follows:

```console
$ tanzu workload list

Listing workloads from the dev namespace

  NAME                KIND                                       VERSION   AGE  
  tanzu-java-web-app  appbuildv1s.supplychains.tanzu.vmware.com  v1alpha1  30m  

🔎 To see more details about a workload, use 'tanzu workload get workload-name --kind workload-kind'
```

To see all the workloads running in all namespaces, run the `tanzu workload list -A`.

Now that you see the `tanzu-java-web-app` workload in the workload list. Run the following to see how its progressing through the Supply chain command:

```console
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

From the output, you see that a `WorkloadRun` named `tanzu-java-web-app-run-454m5` was created when you applied the `AppBuildV1` workload and its in the `Running` state. There are multiple reasons why a new `WorkloadRun` will be created for your `Workload`, but few are developer triggered. Updates to your `Workload`, like changing the values in the `workload.yaml` and reapplying to the cluster will create a new `WorkloadRun`. Platform Engineering activities like updating the Buildpack builder images can also cause your `Workload` to rebuild, creating a new `WorkloadRun` with newer base images. Other activities like pushing new commits to your Source code repository that is referred by the `Workload` can also cause a new run of the `Workload` to build the latest source from your Git repository.

The `tanzu workload get` command shows you:

- Overview of your workload like `name`, `kind` and `namespace`.
- Last 2 successful `WorkloadRuns`
- Last 1 failed `WorkloadRun`
- All running `WorkloadRuns`
- Error section from the last failed `WorkloadRun`

To see more information about what stages your workload is going through, output, duration, and result of each stage, run the `tanzu workload run get` command:

```console
$ tanzu workload run get tanzu-java-web-app-run-454m5 --show-details

📡 Overview
   name:        tanzu-java-web-app
   kind:        appbuildv1s.supplychains.tanzu.vmware.com/tanzu-java-web-app
   run id:      appbuildv1runs.supplychains.tanzu.vmware.com/tanzu-java-web-app-run-454m5
   status:      Running
   namespace:   dev
   age:         14m

📓 Spec
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

🏃 Stages   
    ├─ source-git-provider
    │  ├─ 📋 check-source - Success
    │  │  ├─ Duration: 31s
    │  │  └─ Results
    │  │     ├─ message: using git-branch: main
    │  │     ├─ sha: e4e23867bcffcbf7a165e2fefe3c48dc28b076d6
    │  │     └─ url: https://github.com/vmware-tanzu/application-accelerator-samples.git
    │  └─ 📋 pipeline - Success
    │     ├─ Duration: 1m28s
    │     └─ Results
    │        ├─ url: <image-url>
    │        └─ digest: <image-sha>
    ├─ buildpack-build
    │  ├─ 📋 check-builders - Success
    │  │  ├─ Duration: 26s
    │  │  └─ Results
    │  │     ├─ builder-image: <builder-image-used>
    │  │     ├─ message: Builders resolved
    │  │     └─ run-image: <run-image-used>
    │  └─ 📋 pipeline - Success
    │     ├─ Duration: 2m59s
    │     └─ Results
    │        ├─ url: <image-url>
    │        └─ digest: <image-sha>
    ├─ conventions
    │  └─ 📋 pipeline - Success
    │     ├─ Duration: 33s
    │     └─ Results
    │        ├─ url: <image-url>
    │        └─ digest: <image-sha>
    ├─ app-config-server
    │  └─ 📋 pipeline - Running
    │     └─ Duration: 22.37089s
    ├─ carvel-package
    │  └─ 📋 pipeline - Not Started
    └─ git-writer-pr
       └─ 📋 pipeline - Not Started
```

>**Note** `--show-details` is an optional flag that shows the verbose output of the `tanzu workload run get` command. The default output only shows the `stages` and their `status`.

Once your `WorkloadRun` has successfully gone through the Supply Chain, the output of the `Workload` and `WorkloadRun` will look as follows:

Workload Run Output
: **tanzu workload run get tanzu-java-web-app-run-454m5 --show-details**

    ```console
    📡 Overview
        name:        tanzu-java-web-app
        kind:        appbuildv1s.supplychains.tanzu.vmware.com/tanzu-java-web-app
        run id:      appbuildv1runs.supplychains.tanzu.vmware.com/tanzu-java-web-app-run-454m5
        status:      Succeeded
        namespace:   dev
        age:         68m

    📓 Spec
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

    🏃 Stages   
        ├─ source-git-provider
        │  ├─ 📋 check-source - Success
        │  │  ├─ Duration: 31s
        │  │  └─ Results
        │  │     ├─ message: using git-branch: main
        │  │     ├─ sha: e4e23867bcffcbf7a165e2fefe3c48dc28b076d6
        │  │     └─ url: https://github.com/vmware-tanzu/application-accelerator-samples.git
        │  └─ 📋 pipeline - Success
        │     ├─ Duration: 1m28s
        │     └─ Results
        │        ├─ url: <image-url>
        │        └─ digest: <image-sha>
        ├─ buildpack-build
        │  ├─ 📋 check-builders - Success
        │  │  ├─ Duration: 26s
        │  │  └─ Results
        │  │     ├─ builder-image: <builder-image-used>
        │  │     ├─ message: Builders resolved
        │  │     └─ run-image: <run-image-used>
        │  └─ 📋 pipeline - Success
        │     ├─ Duration: 2m59s
        │     └─ Results
        │        ├─ url: <image-url>
        │        └─ digest: <image-sha>
        ├─ conventions
        │  └─ 📋 pipeline - Success
        │     ├─ Duration: 33s
        │     └─ Results
        │        ├─ url: <image-url>
        │        └─ digest: <image-sha>
        ├─ app-config-server
        │  └─ 📋 pipeline - Success
        │     ├─ Duration: 1m12s
        │     └─ Results
        │        ├─ url: <image-url>
        │        ├─ digest: <image-sha>
        │        ├─ url-overlay: <image-url>
        │        └─ digest-overlay: <image-sha>
        ├─ carvel-package
        │  └─ 📋 pipeline - Success
        │     ├─ Duration: 49s
        │     └─ Results
        │        ├─ url: <image-url>
        │        └─ digest: <image-sha>
        └─ git-writer-pr
        └─ 📋 pipeline - Success
            ├─ Duration: 34s
            └─ Results
                ├─ url: <pull-request-url-to-gitops-repo>
                └─ digest: <image-sha>
    ```

Workload Get Output
: **tanzu workload get tanzu-java-web-app**

    ```console
    📡 Overview
       name:       tanzu-java-web-app
       kind:       appbuildv1s.supplychains.tanzu.vmware.com/tanzu-java-web-app
       namespace:  dev
       age:        74m

    🏃 Runs:
       ID                            STATUS     DURATION  AGE  
       tanzu-java-web-app-run-454m5  Succeeded  16m       72m  

    🔎 To view a run information, use 'tanzu workload run get run-id'
    ```

As per the description of the `AppBuildV1` kind from the `tanzu workload kind list` command, the Supply chain should pull the source code from Git repository, build it using buildpacks and package the output as a Carvel package. That output should then be shipped to the GitOps repository that is configured by the Platform Engineer. In your Supply Chain, once the `WorkloadRun` succeeds, you can see the URL for the pull request to the GitOps repository in the `tanzu workload run get --show-details` output in the `gitops-pr` stage results.

You have successfully deployed your first workload using Tanzu Supply Chains.

## Next Steps

Check out these [How to Guides](./../how-to/about.hbs.md) for developers for learning more about Tanzu Supply Chains.

## References

- [Understand Workloads](../explanation/workloads.hbs.md)
- [Understand WorkloadRuns](../explanation/workloads.hbs.md)
# Work with Workloads

{{> 'partials/supply-chain/beta-banner' }}

This topic describes how to:

- Find the kinds of Workloads you can use
- Create and delete a Workload
- Observe runs of your Workloads

## Find the kinds of Workloads you can use

Use the Tanzu Workload CLI plug-in to discover available `Workload` kinds. Run:

```console
tanzu workload kinds list
```

Example output:

```console
KIND                        VERSION   DESCRIPTION
buildserverapps.vmware.com  v1        Builds a Kubernetes deployment app exposed using a Service using Buildpacks.
buildwebapps.vmware.com     v1        Pulls the source code from a Git repository and builds a Knative Service app using Buildpacks.
buildworkerapps.vmware.com  v1        Creates a background worker app deployed as Kubernetes deployment using Buildpacks.
  
🔎 To generate a workload for one of these kinds, use 'tanzu workload generate'
```

## Create and delete a Workload

In this section, you will:

- Generate a Workload manifest
- Create a Workload
- Apply a Workload
- Delete a Workload

### Generate a Workload manifest

1. Generate a `Workload` manifest with default configuration:

    ```console
    tanzu workload generate my-web-app --kind buildwebapps.vmware.com
    ```

    Example output:

    ```console
    apiVersion: vmware.com/v1
    kind: BuildWebApp
    metadata:
      name: my-web-app
    spec:
      source:
        #! Use this object to retrieve source from a git repository.
        #! The tag, commit, and branch fields are mutually exclusive, use only one.
        #! Required
        git:
          #! A git branch ref to watch for new source
          branch: ""
          #! A git commit sha to use
          commit: ""
          #! A git tag ref to watch for new source
          tag: ""
          #! The url to the git source repository
          #! Required
          url: ""
        #! path inside the source to build from (build has no access to paths above the subPath)
        subPath: ""
    ...
    #! other configuration
    ```

1. Pipe the output into a `workload.yaml` file. This `Workload` manifest can be stored in a file for
use by the `tanzu workload create`, `tanzu workload apply`, and `tanzu workload get` commands:

    ```console
    tanzu workload generate my-web-app --kind buildwebapps.vmware.com > workload.yaml
    ```

### Create a Workload

1. Create a `Workload` on the cluster from a manifest. Run:

    ```console
    tanzu workload create --file workload.yaml --namespace build
    ```

    Example output:

    ```console
    Creating workload:
          1 + |---
          2 + |apiVersion: vmware.com/v1
          3 + |kind: BuildWebApp
          4 + |metadata:
          5 + |  name: my-web-app
          6 + |  namespace: build
          7 + |spec:
          8 + |  source:
          9 + |    git:
        10 + |      branch: ""
        11 + |      commit: ""
        12 + |      tag: ""
        13 + |      url: ""
        14 + |    subPath: ""
        15 + |  ...
    Create workload my-web-app from workload.yaml? [yN]: y
    Successfully created workload my-web-app
    ```

1. The `Workload` name provided in the manifest can be overridden by providing a name as an argument:

    ```console
    tanzu workload create my-web-app-2 --file workload.yaml --namespace build
    ```

### Apply a Workload

1. The `tanzu workload create` command can only be used to create a `Workload` that does not already
exist. To update an existing `Workload`, use `tanzu workload apply`. Apply a `Workload` manifest to
the cluster:

    ```console
    tanzu workload apply --file workload.yaml --namespace build
    ```

    Example output:

    ```console
    Creating workload:
          1 + |---
          2 + |apiVersion: vmware.com/v1
          3 + |kind: BuildWebApp
          4 + |metadata:
          5 + |  name: my-web-app
          6 + |  namespace: build
          7 + |spec:
          8 + |  source:
          9 + |    git:
        10 + |      branch: ""
        11 + |      commit: ""
        12 + |      tag: ""
        13 + |      url: ""
        14 + |    subPath: ""
        15 + |  ...
    Create workload my-web-app from workload.yaml? [yN]: y
    Successfully created workload my-web-app
    ```

1. The `Workload` name provided in the manifest can be overridden by providing a name as an argument:

    ```console
    tanzu workload apply my-web-app-2 --file workload.yaml --namespace build
    ```

### Delete a Workload

Delete a `Workload` by name within a namespace.

```console
tanzu workload delete --file /tmp/workload.yaml --namespace build
```

Example output:

```console
Really delete the workload my-web-app of kind buildwebapps.vmware.com from the build namespace? [yN]: y
Successfully deleted workload my-web-app
```

>**Note** Deleting a `Workload` prevents new builds while preserving built images in the registry.

## Observe the Runs of your Workload

Use the Tanzu Workload CLI plug-in to observe `Workloads` and their `WorkloadRuns`.

In this section, you will:

- List Workloads
- Get a Workload
- Get a Workload run

1. Lists all `Workloads` on the cluster:

    ```console
    tanzu workload list --namespace build
    ```

    Example output:

    ```console
    Listing workloads from the build namespace

      NAME        KIND                     VERSION  AGE
      my-web-app  buildwebapps.vmware.com  v1       6m54s
    ```

1. Get the details of the specified `Workload` within a namespace:

    ```console
    $ tanzu workload get my-web-app --namespace build
    Overview
      name:       my-web-app
      kind:       buildwebapps.vmware.com/my-web-app
      namespace:  build
      age:        17s

    Runs:
      ID                    STATUS   DURATION  AGE
      my-web-app-run-lxwrm  Running  0s        17s
    ```

1. Get the [Workload] output as YAML or JSON for programmatic use:

    ```console
    $ tanzu workload get my-web-app --namespace build -o yaml
    ---
    apiVersion: vmware.com/v1
    kind: BuildWebApp
    metadata:
      name: my-web-app
      namespace: build
    spec:
      ...
    ```

1. Get the details of the specified [Workload Run] within a namespace:

    ```console
    tanzu workload run get my-web-app-run-lxwrm -n build --show-details
    ```

    Example output:

    ```console
    Overview
      name:        my-web-app
      kind:        buildwebapps.vmware.com/my-web-app
      run id:      buildwebappruns.vmware.com/my-web-app-run-lxwrm
      status:      Running
      namespace:   build
      age:         39s

    Spec
          1 + |---
          2 + |apiVersion: vmware.com/v1
          3 + |kind: BuildWebApp
          4 + |metadata:
          5 + |  name: my-web-app
          6 + |  namespace: build
          7 + |spec:
          8 + |...

    Stages
        ├─ source-git-provider
        │  ├─ check-source - Success
        │  │  ├─ Duration: 6s
        │  │  └─ Results
        │  │     ├─ message: using git-branch: main
        │  │     ├─ sha: <image SHA>
        │  │     └─ url: <image URL>
        │  └─ pipeline - Success
        │     ├─ Duration: 1m38s
        │     └─ Results
        │        ├─ url: <image URL>
        │        └─ digest: <image SHA>
        ├─ buildpack-build
        │  ├─ check-builders - Success
        │  │  ├─ Duration: 5s
        │  │  └─ Results
        │  │     ├─ builder-image: <image URL>
        │  │     ├─ message: Builders resolved
        │  │     └─ run-image: <image URL>
        │  └─ pipeline - Success
        │     ├─ Duration: 50s
        │     └─ Results
        │        ├─ url: <image URL>
        │        └─ digest: <image SHA>
        ├─ conventions
        │  └─ pipeline - Running
        │     └─ Duration: 53.693499s
        ├─ app-config-web
        │  └─ pipeline - Not Started
        ├─ carvel-package
        │  └─ pipeline - Not Started
        └─ git-writer-pr
          └─ pipeline - Not Started
    ```



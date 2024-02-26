# How to observe the Runs of your Workload

{{> 'partials/supply-chain/beta-banner' }} 

`Workloads` and their `WorkloadRuns` can be observed using the Tanzu `workload` CLI plug-in.

## List Workloads

Lists all `Workloads` on the cluster:

```console
$ tanzu workload list --namespace build
Listing workloads from the build namespace

  NAME        KIND                     VERSION  AGE
  my-web-app  buildwebapps.vmware.com  v1       6m54s
```

## Get a Workload

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

## Get a Workload Run

Get the details of the specified [Workload Run] within a namespace:

```console
$ tanzu workload run get my-web-app-run-lxwrm -n build --show-details
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

## References

- [Understand Workloads](../explanation/workloads.hbs.md)
- [Understand WorkloadRuns](../explanation/workloads.hbs.md)

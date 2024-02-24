# How to create a Workload

{{> 'partials/supply-chain/beta-banner' }}

The Tanzu `workload` CLI plugin provides commands that allow a Developer to generate a `Workload` manifest, apply it to a cluster, and delete it from a cluster.

## Generate a Workload manifest

Generate a `Workload` manifest with default configuration:

```console
$ tanzu workload generate my-web-app --kind buildwebapps.vmware.com
apiVersion: vmware.com/v1
kind: BuildWebApp
metadata:
  name: my-web-app
spec:
  source:
    #! Use this object to retrieve source from a git repository.
    #! The tag, commit and branch fields are mutually exclusive, use only one.
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

This `Workload` manifest can be stored in a file for use by the `tanzu workload create`, `tanzu workload apply`, and `tanzu workload get` commands:

```console
$ tanzu workload generate my-web-app --kind buildwebapps.vmware.com > workload.yaml
```

## Create a Workload

Create a `Workload` on the cluster from a the manifest:

```console
$ tanzu workload create --file workload.yaml --namespace build
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

The `Workload` name provided in the manifest can be overridden by providing a name as an argument:

```console
tanzu workload create my-web-app-2 --file workload.yaml --namespace build
```

>**Note**
>The `tanzu workload create` command can only be used to create a `Workload` that does not already exist. To update an existing `Workload`, use `tanzu workload apply`.


## Apply a Workload

Apply a `Workload` manifest to the cluster.

This command 

```console
$ tanzu workload apply --file workload.yaml --namespace build
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

The `Workload` name provided in the manifest can be overridden by providing a name as an argument:

```console
tanzu workload apply my-web-app-2 --file workload.yaml --namespace build
```

>**Note**
>The `tanzu workload apply` command can used to create **or** update a `Workload`.

## Delete a Workload

Delete a `Workload` by name within a namespace.

```console
$ tanzu workload delete --file /tmp/workload.yaml --namespace build
Really delete the workload my-web-app of kind buildwebapps.vmware.com from the build namespace? [yN]: y
Successfully deleted workload my-web-app
```

>**Note**
>Deleting a `Workload` prevents new builds while preserving built images in the registry.

## References

[Understand Workloads](../explanation/workloads.hbs.md)
[Understand WorkloadRuns](../explanation/workloads.hbs.md)

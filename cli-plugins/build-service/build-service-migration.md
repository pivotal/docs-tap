# tanzu build-service

This topic tells you how to use the Build Service CLI plug-in to view all the Tanzu Build Service
resources on any Kubernetes cluster that has Tanzu Application Platform (commonly known as TAP) or
Tanzu Build Service (commonly known as TBS) installed.

## Installation

## Usage

**CLI plugin:** build-service | **Plugin version:** v1.0.0 | **Target:** Kubernetes

**Syntax:**

```console
tanzu kubernetes build-service [command]
```

****Aliases:****

```console
  build-service, buildservice, tbs, bs
```

**Available Commands:**

```console
  build            Build Commands
  builder          Builder Commands
  buildpack        Buildpack Commands
  clusterbuilder   ClusterBuilder Commands
  clusterbuildpack ClusterBuildpack Commands
  clusterstack     ClusterStack Commands
  clusterstore     ClusterStore Commands
  image            Image com
```

****Flags:****

```console
  -h, --help   help for build-service
```

### tanzu build-service build

**Usage:**

  tanzu kubernetes build-service build [command]

**Aliases:**

```console
  build, builds
```

**Available Commands:**

```console
  list        List builds
  logs        Tails logs for an image resource build
  status      Display status for an image resource build
```

**Flags:**

```console
  -h, --help   help for build
```

#### tanzu build-service build list

Prints a table of the most important information about the available builders in the provided namespace.

The namespace defaults to the Kubernetes current-context namespace.

**Usage:**

```console
  tanzu kubernetes build-service builder list [flags]
```

**Examples:**

```console
  tanzu build-service builder list
tanzu build-service builder list -n my-namespace
```

**Flags:**

```console
  -h, --help               help for list
  -n, --namespace string   kubernetes namespace
```

#### tanzu build-service build logs

Tails logs from the containers of a specific build of an image resource in the provided namespace.

The build defaults to the latest build number.
The namespace defaults to the kubernetes current-context namespace.

**Usage:**

```console
  tanzu kubernetes build-service builder [command]
```

**Aliases:**

```console
  builder, builders
```

**Available Commands:**

```console
  list        List available builders
  status      Display status of a builder
```

**Flags:**

```console
  -h, --help   help for builder
```

#### tanzu build-service build status

Prints detailed information about the status of a specific build of an image resource in the provided namespace.

The build defaults to the latest build number.
The namespace defaults to the kubernetes current-context namespace.

**Usage:**

```console
  tanzu kubernetes build-service build status <image-name> [flags]
```

**Examples:**

```console
  tanzu build-service build status my-image
tanzu build-service build status my-image -b 2 -n my-namespace
```

**Flags:**

```console
  -b, --build string       build number
  -h, --help               help for status
  -n, --namespace string   kubernetes namespace
```

### tanzu build-service builder

**Usage:**

```console
  tanzu kubernetes build-service builder [command]
```

**Aliases:**

```console
  builder, builders
```

**Available Commands:**

```console
  list        List available builders
  status      Display status of a builder
```

**Flags:**

```console
  -h, --help   help for builder
```

#### tanzu build-service builder list

Prints a table of the most important information about the available builders in the provided namespace.

The namespace defaults to the kubernetes current-context namespace.

**Usage:**

```console
  tanzu kubernetes build-service builder list [flags]
```

**Examples:**

```console
  tanzu build-service builder list
tanzu build-service builder list -n my-namespace
```

**Flags:**

```console
  -h, --help               help for list
  -n, --namespace string   kubernetes namespace
```

#### tanzu build-service builder status

Prints detailed information about the status of a specific builder in the provided namespace.

The namespace defaults to the kubernetes current-context namespace.

**Usage:**

```console
  tanzu kubernetes build-service builder status <name> [flags]
```

**Examples:**

```console
  tanzu build-service builder status my-builder
tanzu build-service builder status -n my-namespace other-builder

**Flags:**

```console
  -h, --help               help for status
  -n, --namespace string   kubernetes namespace
```

### tanzu build-service buildpack

**Usage:**

```console
  tanzu kubernetes build-service buildpack [command]
```

**Aliases:**

```console
  buildpack, buildpacks
```

**Available Commands:**

```console
  list        List available buildpacks
  status      Display status of a buildpack
```

**Flags:**

```console
  -h, --help   help for buildpack
```

#### tanzu build-service buildpack list

Prints a table of the most important information about the available buildpacks in the provided namespace.

The namespace defaults to the kubernetes current-context namespace.

**Usage:**

```console
  tanzu kubernetes build-service buildpack list [flags]
```

**Examples:**

```console
  tanzu build-service buildpack list
tanzu build-service buildpack list -n my-namespace
```

**Flags:**

```console
  -h, --help               help for list
  -n, --namespace string   kubernetes namespace
```

#### tanzu build-service buildpack status

Prints detailed information about the status of a specific buildpack in the provided namespace.

The namespace defaults to the kubernetes current-context namespace.

**Usage:**

```console
  tanzu kubernetes build-service buildpack status <name> [flags]
```

**Examples:**

```console
  tanzu build-service buildpack status my-buildpack
tanzu build-service buildpack status -n my-namespace other-buildpack
```

**Flags:**

```console
  -h, --help               help for status
  -n, --namespace string   kubernetes namespace
```

### tanzu build-service clusterbuilder

**Usage:**

```console
  tanzu kubernetes build-service clusterbuilder [command]
```

**Aliases:**

```console
  clusterbuilder, clusterbuilders
```

**Available Commands:**

```console
  list        List available cluster builders
  status      Display cluster builder status
```

**Flags:**

```console
  -h, --help   help for clusterbuilder
```

#### tanzu build-service clusterbuilder list

Prints a table of the most important information about the available cluster builders.

**Usage:**

```console
  tanzu kubernetes build-service clusterbuilder list [flags]
```

**Examples:**

```console
  tanzu build-service clusterbuilder list
```

**Flags:**

```console
  -h, --help   help for list
```

#### tanzu build-service clusterbuilder status

Prints detailed information about the status of a specific cluster builder.

**Usage:**

```console
  tanzu kubernetes build-service clusterbuilder status <name> [flags]
```

**Examples:**

```console
  tanzu build-service clusterbuilder status my-builder
```

**Flags:**

```console
  -h, --help   help for status
```

### tanzu build-service clusterbuildpack

**Usage:**

```console
  tanzu kubernetes build-service clusterbuildpack [command]
```

**Aliases:**

```console
  clusterbuildpack, clusterbuildpacks
```

**Available Commands:**

```console
  list        List available cluster buildpacks
  status      Display status of a buildpack
```

**Flags:**

```console
  -h, --help   help for clusterbuildpack
```

#### tanzu build-service clusterbuildpack list

Prints a table of the most important information about the available cluster buildpacks in
the provided namespace.

**Usage:**

```console
  tanzu kubernetes build-service clusterbuildpack list [flags]
```

**Examples:**

```console
  tanzu build-service clusterbuildpack list
```

**Flags:**

```console
  -h, --help   help for list
```

#### tanzu build-service clusterbuildpack status

Prints detailed information about the status of a specific buildpack in the provided namespace.

The namespace defaults to the kubernetes current-context namespace.

**Usage:**

```console
  tanzu kubernetes build-service clusterbuildpack status <name> [flags]
```

**Examples:**

```console
  tanzu build-service clusterbuildpack status my-buildpack
```

**Flags:**

```console
  -h, --help               help for status
  -n, --namespace string   kubernetes namespace
```

### tanzu build-service clusterstack

**Usage:**

```console
  tanzu kubernetes build-service clusterstack [command]
```

**Aliases:**

```console
  clusterstack, clusterstacks
```

**Available Commands:**

```console
  list        List cluster stacks
  status      Display cluster stack status
```

**Flags:**

```console
  -h, --help   help for clusterstack
```

#### tanzu build-service clusterstack list

Prints a table of the most important information about cluster-scoped stacks in the cluster.

**Usage:**

```console
  tanzu kubernetes build-service clusterstack list [flags]
```

**Examples:**

```console
  tanzu build-service clusterstack list
```

**Flags:**

```console
  -h, --help   help for list
```

#### tanzu build-service clusterstack status

Prints detailed information about the status of a specific cluster-scoped stack.

**Usage:**

```console
  tanzu kubernetes build-service clusterstack status <name> [flags]
```

**Examples:**

```console
  tanzu build-service clusterstack status my-stack
```

**Flags:**

```console
  -h, --help      help for status
  -v, --verbose   display mixins
```

### tanzu build-service clusterstore

**Usage:**

```console
  tanzu kubernetes build-service clusterstore [command]
```

**Aliases:**

```console
  clusterstore, clusterstores
```

**Available Commands:**

```console
  list        List cluster stores
  status      Display cluster store status
```

**Flags:**

```console
  -h, --help   help for clusterstore
```

#### tanzu build-service clusterstore list

Prints a table of the most important information about cluster-scoped stores

**Usage:**

```console
  tanzu kubernetes build-service clusterstore list [flags]
```

**Examples:**

```console
  tanzu build-service clusterstore list
```

**Flags:**

```console
  -h, --help   help for list
```

#### tanzu build-service clusterstore status

Prints information about the status of a specific cluster-scoped store.

**Usage:**

```console
  tanzu kubernetes build-service clusterstore status <store-name> [flags]
```

**Examples:**

```console
  tanzu build-service clusterstore status my-store
```

**Flags:**

```console
  -h, --help      help for status
  -v, --verbose   includes buildpacks and detection order
```

### tanzu build-service image

**Usage:**

```console
  tanzu kubernetes build-service image [command]
```

**Aliases:**

```console
  image, images
```

**Available Commands:**

```console
  list        List image resources
  status      Display status of an image resource
  trigger     Trigger an image resource build
```

**Flags:**

```console
  -h, --help   help for image
```

#### tanzu build-service image list

Prints a table of the most important information about image resources in the provided namespace.

The namespace defaults to the kubernetes current-context namespace.

**Usage:**

```console
  tanzu kubernetes build-service image list [flags]
```

**Examples:**

```console
  tanzu build-service image list
tanzu build-service image list -A
tanzu build-service image list -n my-namespace
tanzu build-service image list --filter ready=true --filter latest-reason=commit,trigger
```

**Flags:**

```console
  -A, --all-namespaces       Return objects found in all namespaces
      --filter stringArray   Each new filter argument requires an additional filter flag.
                             Multiple values can be provided using comma separation.
                             Supported filters and values:
                               builder=string
                               clusterbuilder=string
                               latest-reason=commit,trigger,config,stack,buildpack
                               ready=true,false,unknown
  -h, --help                 help for list
  -n, --namespace string     kubernetes namespace
```

#### tanzu build-service image status

Prints detailed information about the status of a specific image resource in the provided namespace.

The namespace defaults to the kubernetes current-context namespace.

**Usage:**

```console
  tanzu kubernetes build-service image status <name> [flags]
```

**Examples:**

```console
  tanzu build-service image status my-image
tanzu build-service image status my-other-image -n my-namespace
```

**Flags:**

```console
  -h, --help               help for status
  -n, --namespace string   kubernetes namespace
```

#### tanzu build-service image trigger

Trigger a build using current inputs for a specific image resource in the provided namespace.

**Usage:**

```console
  tanzu kubernetes build-service image trigger <name> [flags]
```

**Examples:**

```console
  tanzu build-service image trigger my-image
```

**Flags:**

```console
  -h, --help               help for trigger
  -n, --namespace string   kubernetes namespace
```

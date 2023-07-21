# Build Service CLI plug-in overview

Use the Build Service CLI plug-in to view all the Tanzu Build Service resources on any Kubernetes cluster that has Tanzu Application Platform or Tanzu Build Service installed.

## <a id='command-reference'></a>Command reference

For information about all available commands, see [Command Reference](command-reference/tanzu_build-service.md).

### <a id='image-command'></a>Image Command

The Image command is used to interact with the kpack Image resource that is created by the supply chain. 

#### Image List

You can list all Images in the Workload namespace by running:

```console
tanzu build-service image list -n <WORKLOAD_NAMESPACE>
```
#### Image Status

To get status about a particular image you can run:

```console
tanzu build-service image status <IMAGE_NAME> -n <WORKLOAD_NAMESPACE>
```

This is useful to see information about the latest build and what triggered it, as well as source info and general status messages. 
If the previous build has finished you can see the buildpacks that were used as well.

### <a id='build-command'></a>Build Command

The build command is used to investigate and debug failures with builds. 

#### Build List
To see all the builds associated with an Image you can run:

```console
tanzu build-service build list <IMAGE_NAME> -n <WORKLOAD_NAMESPACE>
```

#### Build Status
To view more details about the latest build:

```console
tanzu build-service build status <IMAGE_NAME> -n <WORKLOAD_NAMESPACE>
```
or 

```console
tanzu build-service build status <IMAGE_NAME> -n <WORKLOAD_NAMESPACE> --build <BUILD_NUMBER>
```
for details about a particular build

#### Build Logs

To view logs from the latest build:

```console
tanzu build-service build logs <IMAGE_NAME> -n <WORKLOAD_NAMESPACE>
```
or

```console
tanzu build-service build logs <IMAGE_NAME> -n <WORKLOAD_NAMESPACE> --build <BUILD_NUMBER>
```
for details about a particular build

### <a id='clusterbuilder-command'></a>ClusterBuilder Command

The ClusterBuilder command can be used to list available builders and examine their contents

#### ClusterBuilder List

To list all ClusterBuilders that can be used by a workload, run:
```console
tanzu build-service clusterbuilder list
```

To see a detailed view of all the buildpack versions inside a ClusterBuilder:
```console
tanzu build-service clusterbuilder status <CLUSTERBUILDER_NAME>
```

### <a id='clusterbuildpack-command'></a>ClusterBuildpack Command

The ClusterBuildpack command can be used to list information about available buildpacks

#### ClusterBuildpack List

To list all language family ClusterBuildpacks:
```console
tanzu build-service clusterbuildpack list
```

To see a detailed view of a particular language family buildpack and see its component buildpack versions:
```console
tanzu build-service clusterbuildpack status <CLUSTERBUILDPACK_NAME>
```

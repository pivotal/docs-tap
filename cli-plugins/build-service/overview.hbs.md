# Build Service CLI plug-in overview

Use the Build Service CLI plug-in to view all the Tanzu Build Service resources on any
Kubernetes cluster that has Tanzu Application Platform or Tanzu Build Service installed.

## <a id='command-reference'></a>Command reference

For information about all available commands, see [Command Reference](command-reference/tanzu_build-service.hbs.md).

### <a id='image-command'></a>Image Command

Use the `image` command to interact with the kpack image resource that is created by the supply
chain.

#### Image List

To list all the images in the workload namespace, run:

```console
tanzu build-service image list -n WORKLOAD-NAMESPACE
```

#### Image Status

To get status about a particular image, run:

```console
tanzu build-service image status IMAGE_NAME -n WORKLOAD-NAMESPACE
```

This displays information about the latest build, what triggered the latest build, source
information, and a general status message.

If the previous build has finished you can see the buildpacks that were used.

### <a id='build-command'></a>Build Command

Use the `build` command to investigate and debug failures with builds.

#### Build List

To see all the builds associated with an image, run:

```console
tanzu build-service build list IMAGE_NAME -n WORKLOAD-NAMESPACE
```

#### Build Status

To view more details about the latest build, run:

```console
tanzu build-service build status IMAGE_NAME -n WORKLOAD-NAMESPACE
```

To view details about a particular build, run:

```console
tanzu build-service build status IMAGE-NAME -n WORKLOAD-NAMESPACE --build BUILD-NUMBER
```

#### Build Logs

To view logs from the latest build, run:

```console
tanzu build-service build logs IMAGE-NAME -n WORKLOAD-NAMESPACE
```

For details about a particular build, run

```console
tanzu build-service build logs IMAGE-NAME -n WORKLOAD-NAMESPACE --build BUILD-NUMBER
```

### <a id='clusterbuilder-command'></a>ClusterBuilder Command

Use the `clusterbuilder` command to list available builders and examine their contents.

#### ClusterBuilder List

To list all ClusterBuilders that can be used by a workload, run:

```console
tanzu build-service clusterbuilder list
```

To see a detailed view of all the buildpack versions inside a ClusterBuilder:

```console
tanzu build-service clusterbuilder status CLUSTERBUILDER-NAME
```

### <a id='clusterbuildpack-command'></a>ClusterBuildpack Command

Use the `clusterbuildpack` command to list information about available buildpacks.

#### ClusterBuildpack List

To list all language family ClusterBuildpacks, run:

```console
tanzu build-service clusterbuildpack list
```

To see a detailed view of a particular language family buildpack and see its component buildpack
 versions, run:

```console
tanzu build-service clusterbuildpack status CLUSTERBUILDPACK-NAME
```

# Source Controller

Tanzu Source Controller provides a standard interface for artifact acquisition. It supports two resource types,

- ImageRepository
- MavenArtifact

An `ImageRepository` resource can resolve the source from the contents of an image in an image registry. This functionality enables app developers to create and update workloads from local source code or a code repository.

A `MavenArtifact` resource can resolve a binary artifact from a Maven repository. This functionality enables the supply chain to support artifacts produced externally.

> Note: Fetching `RELEASE` version from github packages is not currently supported

Tanzu Source Controller extends the functionality of the FluxCD Source Controller Kubernetes operator. For more information about FluxCD Source Controller, see the
[fluxcd/source-controller](https://github.com/fluxcd/source-controller) project on GitHub.

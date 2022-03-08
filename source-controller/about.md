# Source Controller

Tanzu Source Controller provides a common interface for artifact acquisition. With it, an
`ImageRepository` resource can resolve source from the contents of an image in an image registry.
This functionality enables app developers to create and update workloads from local source code or
from a code repository.

Tanzu Source Controller extends the functionality of the FluxCD Source Controller Kubernetes
operator. For more information about FluxCD Source Controller, see the
[fluxcd/source-controller](https://github.com/fluxcd/source-controller) project on GitHub.

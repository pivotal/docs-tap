# Overview of Local Source Proxy

Local Source Proxy provides a secure and convenient solution for developers to interact with
external registries without the need for the knowledge of registry specifics such as endpoints,
credentials, and certificates. This eliminates the burden of Platform/App operators having to
distribute registry credentials to developer workstations.

With Local Source Proxy, developers are not required to provide the source image location when
deploying their workloads from a local source through any mechanism, including IDE extensions. They
can seamlessly deploy their applications without the need to keep track of where their local source
is uploaded or manage registry credentials on their local machines.

As a result, the `--source-image` flag in the Apps CLI becomes optional, and there is no longer a
need for docker registry credentials on the developer’s local machine. Local Source Proxy
abstracts these details, making the deployment process more streamlined and user-friendly for
developers.

By removing the requirement for specific registry information and credentials, Local Source
Proxy simplifies the developer experience and allows them to focus on their application development
rather than managing registry-related complexities.

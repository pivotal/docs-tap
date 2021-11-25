# Supply Chain Security Tools for VMware Tanzu - Sign

Supply Chain Security Tools - Sign provides an admission webhook that verifies
signatures on container images used by Kubernetes resources and adds annotations
to them according to their verification status. It intercepts all resources that
create pods as part of their lifecycle: `Pod`s, `ReplicaSet`s, `Deployment`s,
`Job`s, `StatefulSet`s, `DaemonSet`s, and `CronJob`s.

This component uses [cosign](https://github.com/sigstore/cosign#cosign) as its
backend for signature verification and is compatible only with cosign signatures.
When cosign `signs` an image, it generates a signature in an OCI-compliant
format and pushes it to the registry alongside the image with the tag
`sha256-<image-digest>.sig`. The webhook needs credentials to access this
artifact when it is hosted in a registry protected by authentication.

By default, once installed, this component does not create any policy resources
and will not enforce any kind of policy.
The operator must create a `ClusterImagePolicy` resource in the cluster
containing all required image patterns and cosign keys for verification.

This component gets secret information from running resources and their service
accounts in order to authenticate against private registries at admission time.
If you use [containerd-configured registry credentials](https://github.com/containerd/containerd/blob/main/docs/cri/registry.md#configure-registry-credentials)
or other mechanism that causes your resources and service accounts to not have an
`imagePullSecrets` field informed, you will need to create a secret in any
namespace of your preference that grants read access to the location of your
container images and signatures and inform it as part of your policy
configuration. For more information, see
[informing secrets for cosign verify](configuring.md#inform-secrets).

## Install

Supply Chain Security Tools - Sign is released as an individual Tanzu Application
Platform component.

To install, see [Install Supply Chain Security Tools - Sign](../install-components.md#install-scst-sign).

## Configure

The webhook deployed by Supply Chain Security Tools - Sign requires extra input
from the operator before it starts enforcing policies.

To configure your installed component properly, see
[Configuring Supply Chains Security Tools - Sign](configuring.md).

## Known Issues

See [Supply Chain Security Tools - Sign Known Issues](known_issues.md).

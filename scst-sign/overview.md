# Supply Chain Security Tools for VMware Tanzu - Sign

Supply Chain Security Tools - Sign provides an admission webhook that:
* Verifies signatures on container images used by Kubernetes resources.
* Enforces policy by allowing or denying container images from running based
on configuration.
* Adds metadata to verified resources according to their verification status.

It intercepts all resources that create pods as part of their lifecycle: `Pod`s,
`ReplicaSet`s, `Deployment`s, `Job`s, `StatefulSet`s, `DaemonSet`s, and `CronJob`s.

This component uses [cosign](https://github.com/sigstore/cosign#cosign) as its
backend for signature verification and is compatible only with cosign signatures.
When cosign signs an image, it generates a signature in an OCI-compliant format
and pushes it to the the same registry where the image is stored. The signature is
identified by a tag in the format `sha256-<image-digest>.sig`, where `<image-digest>`
is the digest of the image that this signature belongs to. The webhook needs
credentials to access this artifact when it is hosted in a registry protected by
authentication.

By default, once installed, this component does not include any policy resources
and will not enforce any kind of policy.
The operator must create a `ClusterImagePolicy` resource in the cluster before
the webhook can perform any kind of verifications. This `ClusterImagePolicy`
resource contains all image patterns the operator wants to verify and their
corresponding cosign public keys.

Typically, the webhook gets credentials from running resources and their service
accounts in order to authenticate against private registries at admission time.
There are other mechanisms that the webhook uses for finding credentials.
For more information on providing credentials, see
[Providing credentials for the webhook](configuring.md#providing-credentials-package).

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

## Release Notes

See [Supply Chain Security Tools - Sign Release Notes](release-notes.md).
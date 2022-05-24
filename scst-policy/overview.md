# Supply Chain Security Tools for VMware Tanzu - Policy Controller

Supply Chain Security Tools - Policy Controller provides an admission WebHook that:

- Verifies signatures on container images used by Kubernetes resources.
- Enforces policy by allowing or denying container images from running based
on configuration.
- Adds metadata to verified resources according to their verification status. 
**TODO**: ^^ is this true???
It intercepts all resources that create Pods as part of their lifecycle:

* `Pod`s,
* `ReplicaSet`s
* `Deployment`s
* `Job`s
* `StatefulSet`s
* `DaemonSet`s
* `CronJob`s.

This component is the successor to Supply Chain Security Tools - Sign. 
**TODO** 
- worked with sigstore to take scst sign and develop an open source version
- 

This component uses Sigstore's Policy Controller, currently found in 
[Cosign](https://github.com/sigstore/cosign) (but will be moved to 
[Policy Controller](https://github.com/sigstore/policy-controller)) as its backend 
for signature verification and is compatible only with cosign signatures. When cosign signs 
an image, it generates a signature in an OCI-compliant format and pushes it to the 
same registry where the image is stored. The signature is identified by a tag in 
the format `sha256-<image-digest>.sig`, where `<image-digest>` is the digest of 
the image that this signature belongs to. The WebHook needs credentials to access 
this artifact when hosted in a registry protected by authentication.

**TODO** is the below true??
By default, once installed, this component does not include any policy resources
and does not enforce any policy.
The operator must create a `ClusterImagePolicy` resource in the cluster before
the WebHook can perform any verifications. This `ClusterImagePolicy`
resource contains all image patterns the operator wants to verify, and their
corresponding cosign public keys.

Typically, the WebHook gets credentials from running resources and their service
accounts to authenticate against private registries at admission time.
There are other mechanisms that the WebHook uses for finding credentials.
For more information about providing credentials, see
[Providing Credentials for the WebHook](configuring.md#provide-creds-for-package).

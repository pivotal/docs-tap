# Supply Chain Security Tools for VMware Tanzu - Policy Controller

Supply Chain Security Tools - Policy Controller is a security tool that helps operators ensure that the container images in their registry have not been tampered with. Policy Controller is a Kubernetes Admission Controller that allows operators to apply policies that verify container images have valid signatures before being admitted to a cluster.

The Policy Controller:
- Verifies signatures on container images used by Kubernetes resources.
- Enforces policies to allow or deny images being admitted a cluster.
- Adds metadata to verified resources according to their verification status. 
**TODO**: ^^ is this true???
It enforces its policies against all resources that create `Pod`s as part of their lifecycle:

* `Pod`s,
* `ReplicaSet`s
* `Deployment`s
* `Job`s
* `StatefulSet`s
* `DaemonSet`s
* `CronJob`s.

This component is the successor to `Supply Chain Security Tools - Sign`, which is now deprecated. Support and maintenance for `Supply Chain Security Tools - Sign` will continue; please monitor Release Notes for updates. 

**TODO** 
- worked with sigstore to take scst sign and develop an open source version
- 

This component is based on Sigstore's Policy Controller, currently found in 
[Cosign](https://github.com/sigstore/cosign) (to be relocated to 
[Policy Controller](https://github.com/sigstore/policy-controller)) and is compatible only with `cosign` signatures. When `cosign` signs 
an image, it generates a signature as an OCI-compliant artifact and pushes it to the 
same registry where the image is stored. The signature is identified by a tag in 
the format `sha256-<image-digest>.sig`, where `<image-digest>` is the digest of 
the image that this signature belongs to. The Policy Controller webhook needs credentials to access 
this artifact when hosted in a registry protected by authentication.

**TODO** is the below true??
NOTE: Installing Policy Controller will not enforce any policies by default. The operator must define a policy in a
`ClusterImagePolicy` resource in the cluster before
the webhook can perform any signature verifications. This `ClusterImagePolicy`
resource contains all image source patterns the operator wants to verify, and their
corresponding `cosign` public keys.

Typically, the webhook gets registry credentials from running resources and their service
accounts to authenticate against private registries at admission time.
There are other mechanisms that the webhook uses for finding credentials.
For more information about providing credentials, see
[Providing Credentials for the Webhook](configuring.md#provide-creds-for-package).

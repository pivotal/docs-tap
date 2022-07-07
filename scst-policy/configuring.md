# Configuring Supply Chain Security Tools - Policy

This component requires extra configuration steps to verify your
container images.

## <a id="admission-of-images"></a> Admission of Images

An image is admitted after it is validated against all policies with
matching image patterns, and where at least one valid signature is obtained from
the authorities provided in the matched
[ClusterImagePolicy](#create-cip-resource) later in the topic. Within a single policy, every 
signature must be valid. When more than one policy has a matching image pattern,
the image much match at least one signature from each ClusterImagePolicy.

## <a id="including-namespaces"></a> Including Namespaces

The Policy Controller only validates resources in namespaces
that have chosen to opt-in. This is done by adding the label
`policy.sigstore.dev/include: "true"` to the namespace resource.

```console
kubectl label namespace my-secure-namespace policy.sigstore.dev/include=true
```

## <a id="create-cip-resource"></a> Create a `ClusterImagePolicy` resource

The cluster image policy is a custom resource containing the following properties:

* `images`: The images block defines the patterns of images that must be
  subject to the `ClusterImagePolicy`. If multiple policies match a particular
  image, _ALL_ of those policies must be satisfied for the image to be admitted.
  If there is no host in the `glob` field, `index.docker.io` is used for the
  host. When no repository is specified, the image pattern defaults to `library`.

* `authorities`: The authorities block defines the rules for discovering and validating signatures. Discovery is done by using the `sources` field, and is specified on any entry. Signatures are cryptographically verified using one of the `key` or `keyless` fields.

When a policy is selected to be evaluated against the matched image, the
authorities are used to validate signatures. If at least one authority is
satisfied and a signature is validated, the policy is validated.

### <a id="cip-images"></a> `images`

In a ClusterImagePolicy, `spec.images` specifies a list of glob matching patterns.
These patterns are matched against the image digest in `PodSpec` for resources
attempting deployment.

Glob matches against images using semantics similar to golang filepaths. A `**` is matched against all subdirectories. To make it easier to specify images, there are few defaults when an image is matched, such as:

- If there is no host in the glob pattern, `index.docker.io` is used for the host.
  This allows users to specify commonly found images from Docker as
  `myproject/nginx` instead of `index.docker.io/myproject/nginx`

- If the image is specified without multiple path elements (not separated by
  `/`), then `library` is defaulted. For example, specifying `busybox`, the
  resultant glob defaults to `library/busybox`. And combined
  with the previous defaulting, the resultant glob is
  `index.docker.io/library/busybox`.

A sample of a ClusterImagePolicy which matches against all images using glob:

```yaml
apiVersion: policy.sigstore.dev/v1beta1
kind: ClusterImagePolicy
metadata:
  name: image-policy
spec:
  images:
  - glob: "**"
```

### <a id="cip-authorities"></a> `authorities`

Authorities listed in the `authorities` block of the ClusterImagePolicy are
`key` or `keyless` specifications.

Each `key` authority can contain a PEM-encoded ECDSA public key, a `secretRef`,
or a `kms` path.

>**Note:** Currently, only ECDSA public keys are supported.

```yaml
spec:
  authorities:
    - key:
        data: |
          -----BEGIN PUBLIC KEY-----
          ...
          -----END PUBLIC KEY-----
    - key:
        secretRef:
          name: secretName
    - key:
        kms: KMSPATH
``` 

Each keyless authority can contain a Fulcio URL, a Rekor URL, a certificate, or
an array of identities.

```yaml
spec:
  authorities:
    - keyless:
        url: https://fulcio.example.com
        ca-cert:
          data: Certificate Data
      ctlog:
        url: https://rekor.example.com
    - keyless:
        url: https://fulcio.example.com
        ca-cert:
          secretRef:
            name: secretName
    - keyless:
        identities:
          - issuer: https://accounts.google.com
            subject: .*@example.com
          - issuer: https://token.actions.githubusercontent.com
            subject: https://github.com/mycompany/*/.github/workflows/*@*
```

The authorities are evaluated using the "any of" operator to admit container
images. For each Pod, the Policy Controller iterates over the list of containers
and init containers. For every policy that matches against the images, they must
each have at least one valid signature obtained using the authorities specified.
If an image does not match any policy, the Policy Controller
does not admit the image.

## <a id='provide-creds-for-package'></a> Provide credentials for the package

There are three ways the package reads credentials to authenticate to registries
protected by authentication:

1. Reading `imagePullSecrets` directly from the resource being admitted. See [Container image pull secrets](https://kubernetes.io/docs/concepts/configuration/secret/#using-imagepullsecrets) in the Kubernetes documentation.

1. Reading `imagePullSecrets` from the service account the resource is running as. See [Arranging for imagePullSecrets to be automatically attached](https://kubernetes.io/docs/concepts/configuration/secret/#arranging-for-imagepullsecrets-to-be-automatically-attached) in the Kubernetes documentation.

1. Reading a `secretRef` from the `ClusterImagePolicy` resource's
`signaturePullSecrets` when specifying the cosign signature source.

Authentication can fail for the following scenarios:

- A not valid credential is specified in the `imagePullSecrets` of the resource
  or in the service account the resource runs as.
- A not valid credential is specified in the `ClusterImagePolicy` `signaturePullSecrets` field.

### <a id="provide-pol-auth-secrets"></a> Provide secrets for authentication in your policy

You can provide secrets for authentication as part of the policy
configuration. The `oci` location is the image location or a remote location
where signatures are configured to be stored during signing.
The `signaturePullSecrets` must be found in the namespace of the
deploying Pod resource.

By default, `imagePullSecrets` from the resource or service account is used
while the default `oci` location is the image location.

See the following example:

```yaml
spec:
  authorities:
    - key:
        data: |
          -----BEGIN PUBLIC KEY-----
          ...
          -----END PUBLIC KEY-----
      source:
        - oci: registry.example.com/project/signature-location
          signaturePullSecrets:
            - name: mysecret
    - keyless:
        url: https://fulcio.example.com
      source:
        - oci: registry.example.com/project/signature-location
          signaturePullSecrets:
            - name: mysecret
``` 

VMware recommends using a set of credentials with the least amount of
privilege that allows reading the signature stored in your registry.

## <a id="verify-configuration"></a> Verify your configuration

A sample policy:
```yaml
apiVersion: policy.sigstore.dev/v1beta1
kind: ClusterImagePolicy
metadata:
  name: image-policy
spec:
  images:
  - glob: "gcr.io/projectsigstore/cosign*"
  authorities:
  - name: official-cosign-key
    key:
      data: |
        -----BEGIN PUBLIC KEY-----
        MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEhyQCx0E9wQWSFI9ULGwy3BuRklnt
        IqozONbbdbqz11hlRJy9c7SG+hdcFl9jE9uE/dwtuwU2MqU9T/cN0YkWww==
        -----END PUBLIC KEY-----
``` 

When using the sample policy, run these commands to verify your configuration:

1. Verify that the Policy Controller admits the signed image that validates
with the configured public key. Run:

    ```console
    kubectl run cosign \
      --image=gcr.io/projectsigstore/cosign:v1.2.1 \
      --dry-run=server
    ```

    For example:

    ```console
    $ kubectl run cosign \
      --image=gcr.io/projectsigstore/cosign:v1.2.1 \
      --dry-run=server
    pod/cosign created (server dry run)
    ```

1. Verify that the Policy Controller rejects the unsigned image. Run:

    ```console
    kubectl run busybox --image=busybox --dry-run=server
    ```

    For example:

    ```console
    $ kubectl run busybox --image=busybox --dry-run=server
      Error from server (BadRequest): admission webhook "policy.sigstore.dev" denied the request: validation failed: no matching signatures:
      : spec.containers[0].image
      index.docker.io/library/busybox@sha256:3614ca5eacf0a3a1bcc361c939202a974b4902b9334ff36eb29ffe9011aaad83
    ```

    In the output, it did not specify which authorities were used as there was
    no policy found that matched the image.
    Therefore, the image fails to validate for a signature and fails to deploy.

1. Verify that the Policy Controller rejects a matched image signed with a
different key than the one configured. Run:

    ```console
    kubectl run cosign-fail \
      --image=gcr.io/projectsigstore/cosign:v0.3.0 \
      --dry-run=server
    ```

    For example:

    ```console
    $ kubectl run cosign-fail \
        --image=gcr.io/projectsigstore/cosign:v0.3.0 \
        --dry-run=server
      Error from server (BadRequest): admission webhook "policy.sigstore.dev" denied the request: validation failed: failed policy: image-policy: spec.containers[0].image
      gcr.io/projectsigstore/cosign@sha256:135d8c5e27bdc917f04b415fc947d7d5b1137f99bb8fa00bffc3eca1856e9c52 failed to validate public keys with authority official-cosign-key for gcr.io/projectsigstore/cosign@sha256:135d8c5e27bdc917f04b415fc947d7d5b1137f99bb8fa00bffc3eca1856e9c52: no matching signatures:
    ```

    In the output, it specifies which authorities were used for validation when
    a policy was found that matched the image. In this case, the authority used
    was `official-cosign-key`. If no name is specified, it is defaulted to
    `authority-#`.

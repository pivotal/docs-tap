# Configuring Supply Chain Security Tools - Policy

This topic describes how you can configure Supply Chain Security Tools - Policy.
SCST - Policy requires extra configuration steps to verify your container
images.

## <a id="admission-of-images"></a> Admission of Images

An image is admitted after it is validated against all policies with
matching image patterns, and where at least one valid signature is obtained from
the authorities provided in the matched
[ClusterImagePolicy](#create-cip-resource) later in the topic. Within a single policy, every
signature must be valid. When more than one policy has a matching image pattern,
the image must match at least one signature from each ClusterImagePolicy.

## <a id="including-namespaces"></a> Including Namespaces

The Policy Controller only validates resources in namespaces
that have chosen to opt-in. This is done by adding the label
`policy.sigstore.dev/include: "true"` to the namespace resource.

```console
kubectl label namespace my-secure-namespace policy.sigstore.dev/include=true
```

>**Caution** Without a Policy Controller ClusterImagePolicy applied, there are
fallback behaviors where images are validated against the public Sigstore
Rekor and Fulcio servers by using a keyless authority flow. Therefore, if the
deploying image is signed publicly by a third-party using the keyless
authority flow, the image is admitted as it can validate against the public
Rekor and Fulcio. To avoid this behavior, develop, and apply a ClusterImagePolicy
that applies to the images being deployed in the namespace.

## <a id="create-cip-resource"></a> Create a `ClusterImagePolicy` resource

The cluster image policy is a custom resource containing the following properties:

* `images`: The images block defines the patterns of images that must be
  subject to the `ClusterImagePolicy`. If multiple policies match a particular
  image, _ALL_ of those policies must be satisfied for the image to be admitted.

  Policy Controller by default defines if the following globs are specified:

  - If `*` is specified, the `glob` matching behavior is `index.docker.io/library/*`.
  - If `*/*` is specified, the `glob` matching behavior is `index.docker.io/*/*`.
  With these defaults, you require the `glob` pattern `**` to match against all images.
  If your image is hosted on Docker Hub, include `index.docker.io` as the host for the glob.

* `authorities`: The authorities block defines the rules for discovering and validating signatures. Discovery is done by using the `sources` text box, and is specified on any entry. Signatures are cryptographically verified using one of the `key` or `keyless` text boxes.

When a policy is selected to be evaluated against the matched image, the
authorities are used to validate signatures. If at least one authority is
satisfied and a signature is validated, the policy is validated.

### <a id="cip-mode"></a> `mode`

In a ClusterImagePolicy, `spec.mode` specifies the action of a policy:

- `enforce`: The default behavior. If the policy fails to validate the image, the policy fails.
- `warn`: If the policy fails to validate the image, validation error messages are converted to Warnings and the policy passes.

A sample of a ClusterImagePolicy which has `warn` mode configured.

```yaml
---
apiVersion: policy.sigstore.dev/v1beta1
kind: ClusterImagePolicy
metadata:
  name: POLICY-NAME
spec:
  mode: warn
```

When `enforce` mode rejects an image, the image is not admitted.

Sample output message:
```
error: failed to patch: admission webhook "policy.sigstore.dev" denied the request: validation failed: failed policy: POLICY-NAME: spec.template.spec.containers[0].image
IMAGE-REFERENCE signature key validation failed for authority authority-0 for IMAGE-REFERENCE: GET IMAGE-SIGNATURE-REFERENCE: DENIED: denied; denied
failed policy: <POLICY_NAME>: spec.template.spec.containers[1].image
IMAGE-REFERENCE signature key validation failed for authority authority-0 for IMAGE-REFERENCE: GET IMAGE-SIGNATURE-REFERENCE: DENIED: denied; denied
```

When `warn` mode rejects an image, the image is admitted.

Sample output message:
```
Warning: failed policy: POLICY-NAME: spec.template.spec.containers[0].image
Warning: IMAGE-REFERENCE signature key validation failed for authority authority-0 for IMAGE-REFERENCE: GET IMAGE-SIGNATURE-REFERENCE: DENIED: denied; denied
Warning: failed policy: POLICY-NAME: spec.template.spec.containers[1].image
Warning: IMAGE-REFERENCE signature key validation failed for authority authority-0 for IMAGE-REFERENCE: GET IMAGE-SIGNATURE-REFERENCE: DENIED: denied; denied
```

If a namespace contains both signed and unsigned images, utilizing two ClusterImagePolicies can address this.
One policy can be configured with `enforce` for images that are signed and the other policy can be configured with `warn` to allow expected unsigned images.

For example, allowing unsigned `tap-packages` images required for the platform through a `warn` policy.
However, the signed images produced from Tanzu Build Service are verified with an `enforce` policy.

If `Warning` is undesirable, you might configure a `static.action` `pass` authority to allow expected unsigned images.
For information about static action authorities, see the [Static Action](#cip-static-action) documentation.

### <a id="cip-images"></a> `images`

In a ClusterImagePolicy, `spec.images` specifies a list of glob matching patterns.
These patterns are matched against the image digest in `PodSpec` for resources
attempting deployment.

Policy Controller defines the following globs by default:
- If `*` is specified, the `glob` matching behavior is `index.docker.io/library/*`.
- If `*/*` is specified, the `glob` matching behavior is `index.docker.io/*/*`.

With these defaults, you require the `glob` pattern `**` to match against all images.
If your image is hosted on Docker Hub, include `index.docker.io` as the host for the glob.

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

> **Important** Only ECDSA public keys are supported.

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

>**Note** The secret referenced in `key.secretRef.name` must be created
in the `cosign-system` namespace or the namespace where the Policy Controller
is installed. Such secret must only contain one `data` entry with the public key.

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
images. For each pod, the Policy Controller iterates over the list of containers
and init containers. For every policy that matches against the images, they must
each have at least one valid signature obtained using the authorities specified.
If an image does not match any policy, the Policy Controller
does not admit the image.

#### <a id="cip-static-action"></a> `static.action`

ClusterImagePolicy authorities are configured to always `pass` or `fail` with `static.action`.

Sample `ClusterImagePolicy` with static action `fail`.

```yaml
apiVersion: policy.sigstore.dev/v1beta1
kind: ClusterImagePolicy
metadata:
  name: POLICY-NAME
spec:
  authorities:
  - static:
      action: fail
```

A sample output of static action `fail`:

```
error: failed to patch: admission webhook "policy.sigstore.dev" denied the request: validation failed: failed policy: POLICY-NAME: spec.template.spec.containers[0].image
IMAGE-REFERENCE disallowed by static policy
failed policy: POLICY-NAME: spec.template.spec.containers[1].image
IMAGE-REFERENCE disallowed by static policy
```

Images that are unsigned in a namespace with validation enabled are admitted with an authority with static action `pass`.

A scenario where this applies is configuring a policy with `static.action` `pass` for `tap-packages` images. Another policy is then configured to validate signed images produced by Tanzu Build Service. This allows images from `tap-packages`, which are unsigned and required by the platform, to be admitted while still validating signed built images from Tanzu Build Service. See [Configure your supply chain to sign and verify your image builds](../getting-started/config-supply-chain.md#config-sc-to-img-builds) for an example.

If `Warning` messages are desirable for admitted images where validation failed, you can configure a policy with `warn` mode and valid authorities.
For information about ClusterImagePolicy modes, see the [Mode](#cip-mode) documentation.

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
- A not valid credential is specified in the `ClusterImagePolicy` `signaturePullSecrets` text box.

### <a id="provide-pol-auth-secrets"></a> Provide secrets for authentication in your policy

You can provide secrets for authentication as part of the policy
configuration. The `oci` location is the image location or a remote location
where signatures are configured to be stored during signing.
The `signaturePullSecrets` is available in the `cosign-system` namespace
or the namespace where the Policy Controller is installed.

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

1. Verify that the Policy Controller rejects the unmatched image. Run:

    ```console
    kubectl run busybox --image=busybox --dry-run=server
    ```

    For example:

    ```console
    $ kubectl run busybox --image=busybox --dry-run=server
      Error from server (BadRequest): admission webhook "policy.sigstore.dev" denied the request: validation failed: no matching policies: spec.containers[0].image
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

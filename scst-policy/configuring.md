# Configuring Supply Chain Security Tools - Policy

This component requires extra configuration steps to start verifying your
container images properly.

## <a id="admission-of-images"></a> Admission of Images

An image is admitted after it is validated against all policies with
matching image patterns, and where at least one valid signature obtained from
the authorities provided in each of the matched
[ClusterImagePolicy](#create-cip-resource). Within a single policy, any single
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
  subject to the ClusterImagePolicy. If multiple policies match a particular
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

Glob matches against images using semantics similar to golang filepaths. A `**` is used to match against all subdirectories. To make it easier to specify images, there are few defaults when an image is matched, namely:

- If there is no host in the glob pattern, `index.docker.io` is used for the host.
  This allows users to specify commonly found images from Docker as
  `myproject/nginx` instead of `index.docker.io/myproject/nginx`

- If the image is specified without multiple path elements (not separated by
  `/`), then library is defaulted. For example, specifying busybox causes library/busybox. And combined with earlier, causes a match being made
  against index.docker.io/library/busybox.

A sample of a ClusterImagePolicy which matches against all images using glob:

```console
apiVersion: policy.sigstore.dev/v1beta1
kind: ClusterImagePolicy
metadata:
  name: image-policy
spec:
  images:
  - glob: "*"
```

### <a id="cip-authorities"></a> `authorities`

Authorities listed in the `authorities` block of the ClusterImagePolicy can be `key` specifications. Each `key` authority can contain a raw public key, a
`secretRef` or a `kms` path.

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

Authorities can be `keyless` specifications. Each keyless authority can contain
a Fulcio URL, a certificate or an array of identities.

```yaml
spec:
  authorities:
    - keyless:
        url: https://fulcio.example.com
        ca-cert:
          data: Certificate Data
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

The following is an example `ClusterImagePolicy` which matches against all
images using a glob:

```yaml
apiVersion: policy.sigstore.dev/v1beta1
kind: ClusterImagePolicy
metadata:
  name: image-policy
spec:
  images:
  - glob: "*"
```

The patterns are evaluated using the "any of" operator to admit container
images. For each Pod, the Policy Controller iterates over the list of containers
and init containers. The Pod is verified when there is at least one key
specified in `spec.authorities[]` for each container image that matches
`spec.images[]`.

## <a id='provide-creds-for-package'></a> Provide credentials for the package

There are four ways the package reads credentials to authenticate to registries
protected by authentication, in order:

1. [Reading `imagePullSecrets` directly from the resource being admitted](https://kubernetes.io/docs/concepts/configuration/secret/#using-imagepullsecrets).

1. [Reading `imagePullSecrets` from the service account the resource is running as](https://kubernetes.io/docs/concepts/configuration/secret/#arranging-for-imagepullsecrets-to-be-automatically-attached).

1. Reading a `secretRef` from the `ClusterImagePolicy` resource applied to the cluster for the
container image name pattern that matches the container being admitted.

1. [Reading `imagePullSecrets` from the `image-policy-registry-credentials` service account](#provide-secrets-iprc-sa)
in the deployment namespace.

Because the order in which credentials are loaded matters, authentication fails in the following scenarios:

- A not valid credential is specified in the `imagePullSecrets` of the resource
  or in the service account the resource runs as.
- A not valid credential is specified in the `ClusterImagePolicy` `signaturePullSecrets` field.

To prevent this issue, choose a single authentication method to validate signatures for your resources.

If you use [containerd-configured registry credentials](https://github.com/containerd/containerd/blob/main/docs/cri/registry.md#configure-registry-credentials)
or another mechanism that causes your resources and service accounts to not
include an `imagePullSecrets` field, you must provide credentials to
the Policy Controller using one of the following mechanisms:

1. Create secret resources in any namespace of your preference that grants read
access to the location of your container images and signatures and include it
as part of your policy configuration.

1. Create secret resources and include them in the `image-policy-registry-credentials`
service account. The service account and the secrets must be created in the
deployment namespace.

### <a id="provide-pol-auth-secrets"></a> Provide secrets for authentication in your policy

You can provide secrets for authentication as part of the name pattern policy
configuration provided your use meets the following conditions:

* Your images and signatures reside in a registry protected by authentication.

* You do not have `signaturePullSecrets` configured in your ClusterImagePolicy
  or in the `ServiceAccount`s that your runnable resources use.

* You want the Policy Controller to verify these container images.

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
    - keyless:
        url: https://fulcio.example.com
      source:
        - oci: registry.example.com/project/signature-location
          signaturePullSecrets:
          - name: mysecret
```

>**Note:** You must grant the service account
`image-policy-controller-manager` in the deployment namespace RBAC
permissions for the verbs `get` and `list` in the namespace that hosts
your secrets.

VMware recommends using a set of credentials with the least amount of
privilege that allows reading the signature stored in your registry.

### <a id="provide-secrets-iprc-sa"></a> Provide secrets for authentication in the `image-policy-registry-credentials` service account

If you prefer to provide your secrets in the `image-policy-registry-credentials`
service account, follow these steps:

1. Create the required secrets in the deployment namespace (once per secret):

    ```console
    kubectl create secret docker-registry SECRET-1 \
      --namespace image-policy-system \
      --docker-server=<server> \
      --docker-username=<username> \
      --docker-password=<password>
    ```

1. Create the `image-policy-registry-credentials` service account in the
deployment namespace and add the secret name (one or more) in the earlier step to the
`imagePullSecrets` section:

    ```console
    cat <<EOF | kubectl apply -f -
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: image-policy-registry-credentials
      namespace: image-policy-system
    imagePullSecrets:
    - name: SECRET-1
    EOF
    ```
    Where `SECRET-1` is a secret that allows the Policy Controller to pull signatures from
    the private registry.

    Add additional secrets to `imagePullSecrets` as required.

## <a id="verify-configuration"></a> Verify your configuration

If you are using the suggested key `cosign-key` shown in the previous section
then run these commands to verify your configuration:

1. Verify that a signed image, validated with a configured public key, starts.
Run:

    ```console
    kubectl run cosign \
      --image=gcr.io/projectsigstore/cosign:v1.2.1 \
      --restart=Never \
      --command -- sleep 900
    ```

    For example:

    ```console
    $ kubectl run cosign \
      --image=gcr.io/projectsigstore/cosign:v1.2.1 \
      --restart=Never \
      --command -- sleep 900
    pod/cosign created
    ```

1. Verify that an unsigned image does not start. Run:

    ```console
    kubectl run bb --image=busybox --restart=Never
    ```

    For example:

    ```console
    $ kubectl run bb --image=busybox --restart=Never
    Warning: busybox did not match any image policies. Container will be created as AllowUnmatchedImages flag is true.
    pod/bb created
    ```

1. Verify that an image signed with a key that does not match the configured
public key does not start. Run:

    ```console
    kubectl run cosign-fail \
      --image=gcr.io/projectsigstore/cosign:v0.3.0 \
      --command -- sleep 900
    ```

    For example:

    ```console
    $ kubectl run cosign-fail \
      --image=gcr.io/projectsigstore/cosign:v0.3.0 \
      --command -- sleep 900
    Error from server (The image: gcr.io/projectsigstore/cosign:v0.3.0 is not signed.): admission webhook "image-policy-webhook.signing.apps.tanzu.com" denied the request: The image: gcr.io/projectsigstore/cosign:v0.3.0 is not signed.
    ```

# Configuring Supply Chain Security Tools - Sign

This component requires extra configuration steps to start verifying your
container images properly.

## Create a `ClusterImagePolicy` Resource
The cluster image policy is a custom resource containing the following properties:

* `spec.verification.exclude.resources.namespaces`: a list of namespaces where
this policy will not be enforced.

* `spec.verification.keys`: a list of public keys complementary to the private
keys that were used to sign the images.

* `spec.verification.images[].namePattern`: image name patterns for which the
policy is enforced. Each image name pattern is mapped to the required public
keys and, optionally, a secret that grants authentication to the private
registry where images and signatures that match a given pattern are stored.

The following is an example `ClusterImagePolicy`:

```yaml
---
apiVersion: signing.run.tanzu.vmware.com/v1alpha1
kind: ClusterImagePolicy
metadata:
    name: image-policy
spec:
  verification:
    exclude:
      resources:
        namespaces:
        - kube-system
    keys:
    - name: first-key
      publicKey: |
        -----BEGIN PUBLIC KEY-----
        ...
        -----END PUBLIC KEY-----
    images:
    - namePattern: registry.example.org/myproject/*
      keys:
      - name: first-key
    - namePattern: registry.example.org/authproject/*
      secretRef:
        name: secret-name
        namespace: namespace-name
      keys:
      - name: first-key
```

The `name` for the `ClusterImagePolicy` resource must be `image-policy`.

Add any namespaces that run container images that are not signed in the
`spec.verification.exclude.resources.namespaces` section, such as the
`kube-system` namespace.
>
If no `ClusterImagePolicy` resource is created all images are admitted into
the cluster with the following warning:

```
Warning: clusterimagepolicies.signing.run.tanzu.vmware.com "image-policy" not found. Image policy enforcement was not applied.
```
>
For a simpler installation process in a non-production environment,
use the manifest below to create the `ClusterImagePolicy`
resource. This manifest includes a cosign public key which signed the public
cosign v1.2.1 image. The cosign public key validates the specified cosign
images. Container images running in system namespaces are currently not
signed. You must configure the image policy webhook to allow these unsigned
images by adding system namespaces to the
`spec.verification.exclude.resources.namespaces` section.

```bash
cat <<EOF | kubectl apply -f -
apiVersion: signing.run.tanzu.vmware.com/v1alpha1
kind: ClusterImagePolicy
metadata:
  name: image-policy
spec:
  verification:
    exclude:
      resources:
        namespaces:
        - kube-system
    keys:
    - name: cosign-key
      publicKey: |
        -----BEGIN PUBLIC KEY-----
        MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEhyQCx0E9wQWSFI9ULGwy3BuRklnt
        IqozONbbdbqz11hlRJy9c7SG+hdcFl9jE9uE/dwtuwU2MqU9T/cN0YkWww==
        -----END PUBLIC KEY-----
    images:
    - namePattern: gcr.io/projectsigstore/cosign*
      keys:
      - name: cosign-key
EOF
```

## <a id='providing-credentials-package'></a> Providing credentials for the package

There are four ways the package reads credentials to authenticate to registries
protected by authentication, in order:

1. [Reading `imagePullSecrets` directly from the resource being admitted](https://kubernetes.io/docs/concepts/configuration/secret/#using-imagepullsecrets).

1. [Reading `imagePullSecrets` from the service account the resource is running as](https://kubernetes.io/docs/concepts/configuration/secret/#arranging-for-imagepullsecrets-to-be-automatically-attached).

1. [Reading a `secretRef` from the `ClusterImagePolicy` resource](#secret-ref-cluster-image-policy)
applied to the cluster for the container image name pattern that matches the
container being admitted.

1. [Reading `imagePullSecrets` from the `image-policy-registry-credentials` service account](#secrets-registry-credentials-sa)
in the `image-policy-system` namespace.

If you use [containerd-configured registry credentials](https://github.com/containerd/containerd/blob/main/docs/cri/registry.md#configure-registry-credentials)
or another mechanism that causes your resources and service accounts to not
include an `imagePullSecrets` field, you will need to provide credentials to
the webhook using one of the following mechanisms:

1. Create secret resources in any namespace of your preference that grants read
access to the location of your container images and signatures and include it
as part of your policy configuration.

1. Create secret resources and include them in the `image-policy-registry-credentials`
service account. The service account and the secrets must be created in the
`image-policy-system` namespace.

### <a id="secret-ref-cluster-image-policy"></a> Providing secrets for authentication in your policy

If your use case matches the following conditions:
* Your images and signatures reside in a registry protected by authentication.

* You do not have `imagePullSecrets` configured in your runnable resources or
in the `ServiceAccount`s your runnable resources use.

* You would like this webhook to check these container images.

You can provide secrets for authentication as part of the name pattern policy
configuration, as shown in the example below:

```yaml
---
apiVersion: signing.run.tanzu.vmware.com/v1alpha1
kind: ClusterImagePolicy
metadata:
  name: image-policy
spec:
  verification:
    exclude:
      resources:
        namespaces:
        - kube-system
    keys:
    - name: first-key
      publicKey: |
        -----BEGIN PUBLIC KEY-----
        ...
        -----END PUBLIC KEY-----
    images:
    - namePattern: registry.example.org/myproject/*
      # Your secret reference must be included here
      secretRef:
        name: your-secret
        namespace: your-namespace
      keys:
      - name: first-key
```

> **Note**: you may need to grant the service account
> `image-policy-controller-manager` in the namespace `image-policy-system` RBAC
> permissions for the verbs `get` and `list` in the namespace you choose to host
> your secrets.

VMware suggests the use of a set of credentials with the least amount of
privilege that will allow reading the signature stored in your registry.

### <a id="secrets-registry-credentials-sa"></a> Providing secrets for authentication in the `image-policy-registry-credentials` service account

If you prefer to provide your secrets in the `image-policy-registry-credentials`
service account instead follow the steps below:

1. Create the required secrets in the `image-policy-system` namespace (once per secret):
    ```shell
    kubectl create secret docker-registry SECRET-1 \
      --namespace image-policy-system \
      --docker-server=<server> \
      --docker-username=<username> \
      --docker-password=<password>
    ```

1. Create the `image-policy-registry-credentials` in the `image-policy-system`
namespace and add the secret names from step 1 to the `imagePullSecrets` section:
    ```shell
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

    where `SECRET-1` is a secret that allows the webhook to pull signatures from
    the private registry.

    Add additional secrets to `imagePullSecrets` as required.


## Verify your configuration

If you are using the suggested key `cosign-key` shown in the previous section
then you can run the following commands to check your configuration:

1. Verify that a signed image, validated with a configured public key, launches.
Run:
    ```shell
    kubectl run cosign \
      --image=gcr.io/projectsigstore/cosign:v1.2.1 \
      --restart=Never \
      --command -- sleep 900
    ```

    For example:

    ```shell
    $ kubectl run cosign \
      --image=gcr.io/projectsigstore/cosign:v1.2.1 \
      --restart=Never \
      --command -- sleep 900
    pod/cosign created
    ```

1. Verify that an unsigned image does not launch. Run:
    ```shell
    kubectl run bb --image=busybox --restart=Never
    ```

    For example:

    ```shell
    $ kubectl run bb --image=busybox --restart=Never
    Warning: busybox did not match any image policies. Container will be created as AllowUnmatchedImages flag is true.
    pod/bb created
    ```

1. Verify that an image signed with a key that does not match the configured
public key will not launch. Run:
    ```shell
    kubectl run cosign-fail \
      --image=gcr.io/projectsigstore/cosign:v0.3.0 \
      --command -- sleep 900
    ```

    For example:

    ```shell
    $ kubectl run cosign-fail \
      --image=gcr.io/projectsigstore/cosign:v0.3.0 \
      --command -- sleep 900
    Error from server (The image: gcr.io/projectsigstore/cosign:v0.3.0 is not signed.): admission webhook "image-policy-webhook.signing.run.tanzu.vmware.com" denied the request: The image: gcr.io/projectsigstore/cosign:v0.3.0 is not signed.
    ```

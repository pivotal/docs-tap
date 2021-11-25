# Configuring Supply Chain Security Tools - Sign

This component requires extra configuration steps to start verifying your
container images properly.

## Secrets for private registries

There are four ways this component looks for secrets to authenticate against
private registries in the following order:
1. Reading `imagePullSecrets` directly from the resource being admitted.
1. Reading `imagePullSecrets` from the service account the resource is running
as.
1. Reading `secretRef` from the `ClusterImagePolicy` applied to the cluster for
that given container image name pattern.
1. Reading `imagePullSecrets` from the `image-policy-registry-credentials`
service account in the `image-policy-system` namespace.

If your setup includes registry authentication from your cluster's container
runtime configuration files, VMware suggests the creation of your secrets in a
namespace of your choice and the use of
[secrets for patterns in the cluster image policy](#secret-ref-cluster-image-policy).

## Create a `ClusterImagePolicy`
The cluster image policy is a custom resource containing the following information:
- A list of namespaces to which the policy should not be enforced.
- A list of public keys complementary to the private keys that were used to sign
the images.
- A list of image name patterns against which the policy is enforced. Each image
name pattern is mapped to the required public keys.
- Optionally, a secret that grants authentication to a given name pattern in
your policy.

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
```

> **Note**:
>   - The `name` for the `ClusterImagePolicy` resource must be `image-policy`.
>   - In the `verification.exclude.resources.namespaces` section, add any
>   namespaces that run container images that are unsigned, such as `kube-system`.
>   - If no `ClusterImagePolicy` is created, all images are admitted into the
>   cluster with the following warning:
>     ```
>     Warning: clusterimagepolicies.signing.run.tanzu.vmware.com "image-policy" not found. Image policy enforcement was not applied.
>     ```
>   - For a quicker installation process in a non-production environment,
>   VMware recommends you use the manifest below to create the `ClusterImagePolicy`.
>   This manifest includes a cosign public key, which signed the public cosign
>   image for v1.2.1. The cosign public key validates the specified cosign image.
>   You can add additional namespaces to exclude in the `verification.exclude.resources.namespaces`
>   section, such as a system namespace.

```shell
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

### <a id="secret-ref-cluster-image-policy"></a> Informing secrets for authentication in your policy

If you have signatures hosted in a private registry that you would like to be
checked by this webhook and you have no `imagePullSecrets` in either your
resource or the service account your resource runs as, you can inform your
credentials as a secret reference in your policy:

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
      secretRef:
        name: your-secret
        namespace: your-namespace
      keys:
      - name: first-key
```

**Note**: you will need to grant the service account
`image-policy-controller-manager` in the namespace `image-policy-system` RBAC
permissions for the verbs `get` and `list` in the namespace you choose to host
your secrets.

VMware suggests the use of a set of credentials with the least amount of
privilege that will allow reading the signature stored in your registry.

### Informing secrets for authentication in the `image-policy-registry-credentials` service account

If you prefer to inform your secrets in the `image-policy-registry-credentials`
service account instead, follow the steps below:

1. Create the required secrets in the `image-policy-system` namespace:
    ```shell
    kubectl create secret docker-registry SECRET-1 \
      --namespace image-policy-system \
      --docker-server=<server> \
      --docker-username=<username> \
      --docker-password=<password>
    ```

1. Create the `image-policy-registry-credentials` in the `image-policy-system`
namespace, and add the created secrets to the `imagePullSecrets` section:
    ```bash
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

Run the following commands to check your configuration if you are using the
suggested key `cosign-key` shown in the previous section:

1. Verify that a signed image, validated with a configured public key, launches. Run:
    ```bash
    kubectl run cosign \
      --image=gcr.io/projectsigstore/cosign:v1.2.1 \
      --restart=Never \
      --command -- sleep 900
    ```

    For example:

    ```bash
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

1. Verify that an image signed with a key that does not match the public key configured will not launch. Run:
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

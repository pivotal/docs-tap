# Migration From Supply Chain Security Tools - Sign

This section will go over how to migrate the ClusterImagePolicy resource
from Image Policy Webhook to Policy Controller. For more information on
additional features introduced in Policy Controller, see
[Configuring Supply Chain Security Tools - Policy](configuring.md).

**Note:** There is currently no equivalent of "AllowUnmatchedImages"
VMware recommends that users sign public images and have the signature
stored in their own repository that can be referenced by specifying a source
in the ClusterImagePolicy authorities.

# Namespace exclude cosign-system
[comment]: <> (TODO: Exclude 'cosign-system' namespace)

# Map ImagePolicyWebhook
[comment]: <> (TODO: Quick overview on what is required)

## Apply namespace labels to enable Policy Controller
[comment]: <> (TODO: How to include namespaces)

### Excluding Namespaces
Policy Controller works with an opt-in system. Operators must update namespaces
with the label `policy.sigstore.dev/include: "true"` to the namespace resource
to enable Policy Controller verification.

```console
kubectl label namespace my-secure-namespace policy.sigstore.dev/include=true
```

The namespaces found in `spec.verification.exclude.resources.namespaces[]` would
not be updated with the label. Therefore, they are exempted from Policy
Controller validation.

**Image Policy Webhook:**
```yaml
---
apiVersion: signing.apps.tanzu.vmware.com/v1beta1
kind: ClusterImagePolicy
metadata:
  name: image-policy
spec:
  verification:
    ...

    exclude:
      resources:
        namespaces:
        - image-policy-system
        - kube-system
        - cert-manager

    ...
```

### Specifying Public Keys

`spec.verification.keys[].publicKey` from Image Policy Webhook is mapped to
`spec.authorities[].key.data` from Policy Controller.

The `name` associated to each `key` is no longer required. Image Policy Webhook
has direct association between `key` name and `imagePattern`. For Policy
Controller, multiple ClusterImagePolicy resources can be defined to create
direct association between image patterns and key authorities.

image patterns and keys are scoped to each ClusterImagePolicy resource.

Therefore, to have direct association be isolated between `key` and
`imagePattern`, multiple Policy Controller ClusterImagePolicy must be created.
Each ClusterImagePolicy would have the image glob pattern defined and the
associated key authorities defined.

**Image Policy Webhook:**
```yaml
---
apiVersion: signing.apps.tanzu.vmware.com/v1beta1
kind: ClusterImagePolicy
metadata:
  name: image-policy
spec:
  verification:
    ...

    keys:
    - name: official-cosign-key
      publicKey: |
        -----BEGIN PUBLIC KEY-----
        MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEhyQCx0E9wQWSFI9ULGwy3BuRklnt
        IqozONbbdbqz11hlRJy9c7SG+hdcFl9jE9uE/dwtuwU2MqU9T/cN0YkWww==
        -----END PUBLIC KEY-----

    ...
```

**Policy Controller:**
```yaml
---
apiVersion: policy.sigstore.dev/v1alpha1
kind: ClusterImagePolicy
metadata:
  name: POLICY_NAME
spec:
  authorities:
  ...

  - key:
      data: |
        -----BEGIN PUBLIC KEY-----
        MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEhyQCx0E9wQWSFI9ULGwy3BuRklnt
        IqozONbbdbqz11hlRJy9c7SG+hdcFl9jE9uE/dwtuwU2MqU9T/cN0YkWww==
        -----END PUBLIC KEY-----

  ...
```


# Specifying Image Matching

[comment]: <> (TODO [denny] wildcarding differences)
[comment]: <> (previously required index.docker.io/[library])
[comment]: <> (now uses slash separating wildcarding so * and ** is different)

**Image Policy Webhook:**
```yaml
---
apiVersion: signing.apps.tanzu.vmware.com/v1beta1
kind: ClusterImagePolicy
metadata:
  name: image-policy
spec:
  verification:
    ...

    images:
    - namePattern: gcr.io/projectsigstore/cosign*
      keys:
      - name: official-cosign-key
      secretRef:
        name: your-secret
        namespace: your-namespace

    ...
```

**Policy Controller:**
```yaml
---
apiVersion: policy.sigstore.dev/v1alpha1
kind: ClusterImagePolicy
metadata:
  name: POLICY_NAME
spec:
  images:
  - glob: gcr.io/projectsigstore/cosign*
```
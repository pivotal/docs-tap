# Migration From Supply Chain Security Tools - Sign

This section will go over how to migrate the `ClusterImagePolicy` resource
from Image Policy Webhook to Policy Controller. For more information on
additional features introduced in Policy Controller, see
[Configuring Supply Chain Security Tools - Policy](configuring.md).

**Note:** There is currently no equivalent of "AllowUnmatchedImages"
VMware recommends that users sign public images and have the signature
stored in their own repository that can be referenced by specifying a source
in the `ClusterImagePolicy` authorities.

## Add Policy Controller Namespace to Image Policy Webhook

If there is an active Image Policy Webhook `ClusterImagePolicy`, it will prevent
Policy Controller from deploying. To ensure that Policy Controller deploys,
update the Image Policy Webhook `ClusterImagePolicy` by adding `cosign-system`
to the excluded namespaces. If an alternative `deployment_namespace` will be
specified for installing Policy Controller, exclude that namespace.
For more information on how to exclude namespaces, see
[Configuring Supply Chain Security Tools - Sign](../scst-sign/configuring.md#create-cip-resource)

## Enable Policy Controller on Namespaces

Policy Controller works with an opt-in system. Operators must update namespaces
with the label `policy.sigstore.dev/include: "true"` to the namespace resource
to enable Policy Controller verification.

```console
kubectl label namespace my-secure-namespace policy.sigstore.dev/include=true
```

## Policy Controller ClusterImagePolicy

The Policy Controller `ClusterImagePolicy` does not have a name requirement.
Image Policy Controller required that the `ClusterImagePolicy` be named
`image-policy` and that there be only one `ClusterImagePolicy`. Multiple
Policy Controller `ClusterImagePolicies` can be applied. During validation, all
`ClusterImagePolicy` that have an image `glob` pattern that matches the
deploying image will be evaluated. All matched `ClusterImagePolicies` must be
valid. For a `ClusterImagePolicy` to be valid, at least one authority in the
policy must successfully validate the signature of the deploying image.


## Excluding Namespaces

The namespaces listed in `spec.verification.exclude.resources.namespaces[]`
should have `policy.sigstore.dev/include` set to `false` or not be set.
Therefore, they are exempted from Policy Controller validation.

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

## Specifying Public Keys

`spec.verification.keys[].publicKey` from Image Policy Webhook is mapped to
`spec.authorities[].key.data` for Policy Controller.

The `name` associated to each `key` is no longer required. Image Policy Webhook
has direct association between `key` name and `imagePattern`. For Policy
Controller, multiple `ClusterImagePolicy` resources can be defined to create
direct association between image patterns and key authorities.

Image patterns and keys are scoped to each `ClusterImagePolicy` resource.

Therefore, to have direct association be isolated between `key` and
`imagePattern`, multiple Policy Controller `ClusterImagePolicy` must be created.
Each `ClusterImagePolicy` would have the image glob pattern defined and the
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
apiVersion: policy.sigstore.dev/v1beta1
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


## Specifying Image Matching

`spec.verification.images[].namePattern` from Image Policy Webhook maps to
`spec.images[].glob` for Policy Controller.

Policy Controller follows more closely to `glob` matching. For Image Policy
Webhook, `registry.com/*` would wildcard all projects and images under the
registry. However, `glob` matching uses `/` separator delimiting. Therefore,
the `glob` wildcard matching equivalent is `registry.com/**/*`. The `**` allows
for recursive project path matching while the trailing `*` images found in the
terminating project path.

If only one level of pathing is required, the `glob` pattern would be
`registry.com/*/*`.

Policy Controller also have defaults defined. If `*` is specified, the `glob`
matching behavior will be `index.docker.io/library/*`. If `*/*` is specified,
the `glob` matching behavior will be `index.docker.io/*/*`. With these defaults,
the `glob` pattern `**` will match against all images.

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
apiVersion: policy.sigstore.dev/v1beta1
kind: ClusterImagePolicy
metadata:
  name: POLICY_NAME
spec:
  images:
  - glob: gcr.io/projectsigstore/cosign*
```
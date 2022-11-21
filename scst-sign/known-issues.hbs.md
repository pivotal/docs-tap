# Known Issues

This topic contains known issues and workarounds for Supply Chain Security Tools - Sign.

## Invalid TUF key

### Description

The first request to the image-policy-webhook fails with the following error message:

```bash
panic: Failed to initialize TUF client from  : updating local metadata and targets:
error updating to TUF remote mirror: tuf: invalid key
```

The image policy webhook tries to initialize TUF keys during the first request for signature verification.
Due to a breaking change in [go-tuf](https://github.com/theupdateframework/go-tuf/issues/379),
the initialization fails when using the Official Sigstore TUF root.

### Solution

Upgrade to Image Policy Webhook v1.1.9 available in Tanzu Application Platform v1.3.2.

### Workaround

Manually trigger the first request to the image policy webhook.

#### Steps

1. Create the `ClusterImagePolicy` with a pattern and any public key:

    For example:

    ```yaml
    ---
    apiVersion: signing.apps.tanzu.vmware.com/v1beta1
    kind: ClusterImagePolicy
    metadata:
        name: image-policy
    spec:
        verification:
        exclude:
            resources:
            namespaces:
            - kube-system
            - <TAP system namespaces>
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
    ```

1. Create a pod that matches the pattern in `ClusterImagePolicy` to trigger a verification.

    ```console
    kubectl run cosign \
      --image=gcr.io/projectsigstore/cosign:v1.2.1 \
      --restart=Never \
      --command -- sleep 900
    ```

1. You can delete or edit the `ClusterImagePolicy` for further use.

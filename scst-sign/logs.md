# Logs messages and reasons

The following is the list of possible logs messages the webhook emits.

## Log message

```
clusterimagepolicies.signing.apps.tanzu.vmware.com "image-policy" not found. Image policy enforcement was not applied.
```

### Explanation

The Image Policy was not created in the cluster and the webhook did not check any container images for signatures.

---

## Log message

```
<namespace> is excluded. The ImagePolicy will not be applied.
```

### Explanation

- An image policy is present in the cluster.
- The namespace is present in the `verification.exclude.resouces.namespaces` property of the policy.
- Any container images trying to get created in this namespace will not be checked for signatures.

---

## Log message

```
Could not verify against any image policies for container image: <container image>.
```

### Explanation

- An image policy is present in the cluster.
- The `AllowUnMatchedImages` flag is set to `false` or is absent.
- The namespace is not excluded.
- Image of the container being installed does not match any pattern present in the policy and was rejected by the webhook.

---

## Log message

```
<container image> did not match any image policies. Container will be created as AllowUnmatchedImages flag is true.
```

### Explanation

- An image policy is present in the cluster.
- The `AllowUnMatchedImages` flag is set to `true`.
- The namespace you are installing your resource in is not excluded.
- Image of the container being installed does not match any pattern present in the policy and was allowed to be created.

---

## Log message

```
failed to find signature for image.
```

### Explanation

- An image policy is present in the cluster.
- The namespace you are installing your resource in is not excluded.
- Image of the container being installed matches a pattern in the policy.
- The webhook was not able to verify the signature.

---

## Log message

```
The image: <container image> is not signed.
```

### Explanation

- An image policy is present in the cluster.
- The namespace you are installing your resource in is not excluded.
- Image of the container being installed matches a pattern in the policy.
- The image is not signed.

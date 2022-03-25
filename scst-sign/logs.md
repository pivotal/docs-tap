# Logs messages and reasons

Log messages follow a JSON format. Each log can contain the following keys:

| Key        | Description |
| ---------- | ----------- |
| level      | Log level |
| ts         | Timestamp |
| logger     | Name of the logger component which provided the log message |
| msg        | Log message |
| object     | Relevant object that triggered the log message |
| error      | A message for the error.<br> Only present with "error" log level |
| stacktrace | A stacktrace for where the error occured.<br> Only present with error level |

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
<Namespace> is excluded. The ImagePolicy will not be applied.
```

### Explanation

- An image policy is present in the cluster.
- The namespace is present in the `verification.exclude.resouces.namespaces` property of the policy.
- Any container images trying to get created in this namespace will not be checked for signatures.

---

## Log message

```
Could not verify against any image policies for container image: <ContainerImage>.
```

### Explanation

- An image policy is present in the cluster.
- The `AllowUnMatchedImages` flag is set to `false` or is absent.
- The namespace is not excluded.
- Image of the container being installed does not match any pattern present in the policy and was rejected by the webhook.

---

## Log message

```
<ContainerImage> did not match any image policies. Container will be created as AllowUnmatchedImages flag is true.
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
The image: <ContainerImage> is not signed.
```

### Explanation

- An image policy is present in the cluster.
- The namespace you are installing your resource in is not excluded.
- Image of the container being installed matches a pattern in the policy.
- The image is not signed.

---

## Log message

```
failed to decode resource
```

### Explanation

- The resource type is not supported.
- Currently supported v1 versions of:
  - Pod
  - Deployment
  - StatefulSet
  - DaemonSet
  - ReplicaSet
  - Job
  - CronJob (and v1beta1)

---

## Log message

```
failed to verify
```

### Explanation

- An image policy is present in the cluster.
- The namespace you are installing your resource in is not excluded.
- Image of the container being installed matches a pattern.
- The webhook can not verify the signature.

---

## Log message

```
matching pattern: <Pattern> against image <ContainerImage>
matching registry patterns: [{<Image NamePattern, Keys, SecretRef>}]
```

### Explanation

- Provide the pattern that matches the container image.
- Provide the corresponding `Image` configuration from the `ClusterImagePolicy` that matches the container image.

---

## Log message

```
service account not found
```

### Explanation

- The fallback service account, "image-policy-registry-credentials", was not found in the namespace of which the webhook is installed.
- The fallback service account is deprecated and was originally purposed to storing `imagePullSecrets` for container images and their co-located `cosign` signatures.

---

## Log message

```
unmatched image policy: <ContainerImage>
```

### Explanation

- Container image does not match any policy image patterns.

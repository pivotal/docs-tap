### Symptom

When you attempt to Live Update your workload, the following error message appears in the log:

```console
ERROR: Build Failed: apply command timed out after 30s - see }}\{{https://docs.tilt.dev/api.html#api.update_settings\{{ for how to increase}}
```

### Cause

Kubernetes times out on upserts over 30 seconds.

### Solution

Add `update_settings (k8s_upsert_timeout_secs = 300)` to the Tiltfile.
For more information, see the [Tiltfile documentation](https://docs.tilt.dev/api.html#api.update_settings).
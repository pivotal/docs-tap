# Sample private source scan

## <a id="define-resources"></a>Define the resources

1. Create a [Kubernetes Secret](https://kubernetes.io/docs/concepts/configuration/secret/#use-case-pod-with-ssh-keys) named `secret-ssh-auth` with an SSH key for cloning a git repository.

2. Create `sample-private-source-scan.yaml`:

```yaml
---
apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
kind: SourceScan
metadata:
  name: sample-private-source-scan
spec:
  git:
    url: URL
    revision: REVISION
    knownHosts: |
      KNOWN_HOSTS
  scanTemplate: private-source-scan-template
```

Where:
* `URL` is the git clone repository via ssh
* `REVISION` is the commit hash
* `KNOWN_HOSTS` are the [SSH client stored host keys](https://www.ssh.com/academy/ssh/host-key#known-host-keys)

For example:
```yaml
---
apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
kind: SourceScan
metadata:
  name: sample-private-source-scan
spec:
  git:
    url: git@github.com:acme/website.git
    revision: 25as5e7df56c6401111be514a2f3666179ba04d0
    knownHosts: |
      10.254.171.53 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItb
POVVQF/CzuAeQNv4fZVf2pLxpGHle15zkpxOosckequUDxoq
  scanTemplate: private-source-scan-template
```

## <a id="set-up-watch"></a>(Optional) Set up a watch

Before deploying, set up a watch in another terminal to see things process, which will be quick:

```console
watch kubectl get scantemplates,scanpolicies,sourcescans,imagescans,pods,jobs
```

For more information, see [Observing and Troubleshooting](../observing.md).

## <a id="deploy-resources"></a>Deploy the resources

```console
kubectl apply -f sample-private-source-scan.yaml
```

## <a id="view-scan-status"></a>View the scan status

Once the scan has completed, run:

```console
kubectl describe sourcescan sample-private-source-scan
```

Notice the `Status.Conditions` includes a `Reason: JobFinished` and `Message: The scan job finished`.

For more information, see [Viewing and Understanding Scan Status Conditions](../results.md).

## <a id="clean-up"></a>Clean up

```console
kubectl delete -f sample-private-source-scan.yaml
```

## <a id="view-vuln-reports"></a>View vulnerability reports

After completing the scans, [query the Supply Chain Security Tools - Store](../../cli-plugins/insight/query-data.md) to view your vulnerability results.

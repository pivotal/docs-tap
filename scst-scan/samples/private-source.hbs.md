# Sample private source scan

## <a id="define-resources"></a>Define the resources

Create `sample-private-source-scan.yaml` and ensure you enter a valid private SSH key value in the secret:

```yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: secret-ssh-auth
type: kubernetes.io/ssh-auth
stringData:
  ssh-privatekey: <insert your PEM-encoded ssh private key>

---
apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
kind: SourceScan
metadata:
  name: sample-private-source-scan
spec:
  git:
    url: <git clone via ssh>
    revision: <branch, tag or commit digest>
    knownHosts: |
      <known host>
      <another host etc>
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

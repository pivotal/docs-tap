# Sample private source scan

## Define the resources
Create `sample-private-source-scan.yaml` and ensure you enter a valid private ssh key value in the secret:

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
apiVersion: scanning.apps.tanzu.vmware.com/v1alpha1
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

## (Optional) Set up a watch
Before deploying, set up a watch in another terminal to see things process which will be quick.
```bash
watch kubectl get scantemplates,scanpolicies,sourcescans,imagescans,pods,jobs
```

For more information, refer to [Observing and Troubleshooting](../observing.md).

## Deploy the resources
```bash
kubectl apply -f sample-private-source-scan.yaml
```

## View the scan status
Once the scan has completed, perform:
```bash
kubectl describe sourcescan sample-private-source-scan
```
and notice the `Status.Conditions` includes a `Reason: JobFinished` and `Message: The scan job finished`.

For more information, refer to [Viewing and Understanding Scan Status Conditions](../results.md).

## Clean up
```bash
kubectl delete -f sample-private-source-scan.yaml
```

## View vulnerability reports
See [Viewing Vulnerability Reports](../viewing-reports.md) section

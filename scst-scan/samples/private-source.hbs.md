# Sample private source scan

## <a id="define-resources"></a>Define the resources

1. Create a [Kubernetes Secret](https://kubernetes.io/docs/concepts/configuration/secret/#use-case-pod-with-ssh-keys) named `secret-ssh-auth` with an SSH key for cloning a git repository.

```console
cat <<EOF | kubectl create -f -
apiVersion: v1
kind: Secret
metadata:
  name: secret-ssh-auth
  annotations:
    tekton.dev/git-0: https://github.com
    tekton.dev/git-1: https://gitlab.com
type: kubernetes.io/ssh-auth
stringData:
  ssh-privatekey: |
    -----BEGIN OPENSSH PRIVATE KEY-----
    ....
    ....
    -----END OPENSSH PRIVATE KEY-----
EOF
```

Where `.stringData.ssh-privatekey` contains the private key with pull-permissions

2. Create `sample-private-source-scan.yaml`:

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

Before deploying the resources to a user specified namespace, set up a watch in another terminal to view the progression:

```console
watch kubectl get sourcescans,imagescans,pods,taskruns,scantemplates,scanpolicies -n DEV-NAMESPACE
```

Where `DEV-NAMESPACE` is the developer namespace where the scanner is installed.

For more information, see [Observing and Troubleshooting](../observing.md).

## <a id="deploy-resources"></a>Deploy the resources

```console
kubectl apply -f sample-private-source-scan.yaml -n DEV-NAMESPACE
```

Where `DEV-NAMESPACE` is the developer namespace where the scanner is installed.

## <a id="view-scan-status"></a>View the scan status

Once the scan has completed, run:

```console
kubectl describe sourcescan sample-private-source-scan -n DEV-NAMESPACE
```

Notice the `Status.Conditions` includes a `Reason: JobFinished` and `Message: The scan job finished`.

For more information, see [Viewing and Understanding Scan Status Conditions](../results.md).

## <a id="clean-up"></a>Clean up

```console
kubectl delete -f sample-private-source-scan.yaml -n DEV-NAMESPACE
```

## <a id="view-vuln-reports"></a>View vulnerability reports

After completing the scans, [query the Supply Chain Security Tools - Store](../../cli-plugins/insight/query-data.md) to view your vulnerability results.

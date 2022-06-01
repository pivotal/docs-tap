# Sample public source scan of a blob

This example performs a scan against source code in a `.tar.gz` file. This can be helpful in a Supply Chain, where there can be a `GitRepository` step that handles cloning a repository and outputting the source code as a compressed archive.

## <a id="define-resources"></a>Define the resources

Create `public-blob-source-example.yaml`:

```yaml
---
apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
kind: ScanTemplate
metadata:
  name: public-blob-source-scan-template
spec:
  template:
    restartPolicy: Never
    imagePullSecrets:
      - name: scanner-secret-ref
    volumes:
      - name: workspace
        emptyDir: {}
    initContainers:
      - name: repo
        image: harbor-repo.vmware.com/supply_chain_security_tools/grype-templates@sha256:6d69a83d24e0ffbe2e527d8d414da7393137f00dd180437930a36251376a7912
        imagePullPolicy: IfNotPresent
        volumeMounts:
          - name: workspace
            mountPath: /workspace
            readOnly: false
        command: ["/bin/bash"]
        args:
          - "-c"
          - "./source/untar-gitrepository.sh $REPOSITORY /workspace"
    containers:
      - name: scanner
        image: harbor-repo.vmware.com/supply_chain_security_tools/grype-templates@sha256:6d69a83d24e0ffbe2e527d8d414da7393137f00dd180437930a36251376a7912
        imagePullPolicy: IfNotPresent
        volumeMounts:
          - name: workspace
            mountPath: /workspace
            readOnly: false
        command: ["/bin/bash"]
        args: ["-c", "grype dir:/workspace/source -o cyclonedx"]

---
apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
kind: SourceScan
metadata:
  name: public-blob-source-example
spec:
  blob:
    url: "https://gitlab.com/nina-data/ckan/-/archive/master/ckan-master.tar.gz"
  scanTemplate: public-blob-source-scan-template
```

## <a id="set-up-watch"></a>(Optional) Set up a watch

Before deploying, set up a watch in another terminal to see things process:

```console
watch kubectl get scantemplates,scanpolicies,sourcescans,imagescans,pods,jobs
```

For more information, see [Observing and Troubleshooting](../observing.md).

## <a id="deploy-resources"></a>Deploy the resources

```console
kubectl apply -f public-blob-source-example.yaml
```

## <a id="view-scan-results"></a>View the scan results

When the scan completes, perform:

```console
kubectl describe sourcescan public-blob-source-example
```

Notice the `Status.Conditions` includes a `Reason: JobFinished` and `Message: The scan job finished`.

For more information, see [Viewing and Understanding Scan Status Conditions](../results.md).

## <a id="clean-up"></a>Clean up

```console
kubectl delete -f public-blob-source-example.yaml
```

## <a id="view-vuln-reports"></a>View vulnerability reports

After completing the scans, [query the Supply Chain Security Tools - Store](../../cli-plugins/insight/query-data.md) to view your vulnerability results.

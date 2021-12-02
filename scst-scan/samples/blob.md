# Sample public source scan of a blob
This example will perform a scan against a source code in a `.tar.gz` file. This can be helpful in a Supply Chain, where there can be a `GitRepository` step that handles cloning a repository and outputting the source code as a compressed archive.

## Define the resources
Create `public-blob-source-example.yaml`:
```yaml
---
apiVersion: scst-scan.apps.tanzu.vmware.com/v1alpha1
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
apiVersion: scst-scan.apps.tanzu.vmware.com/v1alpha1
kind: SourceScan
metadata:
  name: public-blob-source-example
spec:
  blob:
    url: "https://gitlab.com/nina-data/ckan/-/archive/master/ckan-master.tar.gz"
  scanTemplate: public-blob-source-scan-template
```

## (Optional) Set up a watch
Before deploying, set up a watch in another terminal to see things process which will be quick.
```bash
watch kubectl get scantemplates,scanpolicies,sourcescans,imagescans,pods,jobs
```

For more information, refer to [Observing and Troubleshooting](../observing.md).

## Deploy the resources
```bash
kubectl apply -f public-blob-source-example.yaml
```

## View the scan results
Once the scan has completed, perform:
```bash
kubectl describe sourcescan public-blob-source-example
```
and notice the `Status.Conditions` includes a `Reason: JobFinished` and `Message: The scan job finished`.

For more information, refer to [Viewing and Understanding Scan Status Conditions](../results.md).

## Clean up
```bash
kubectl delete -f public-blob-source-example.yaml
```

## View vulnerability reports
See [Viewing Vulnerability Reports](../viewing-reports.md) section
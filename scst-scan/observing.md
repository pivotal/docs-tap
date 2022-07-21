# Observing and troubleshooting

This section shows how to observe the scan job and get logs.

## <a id="watch-inflight-jobs"></a>Watching in-flight jobs
The scan will run inside the job, which creates a Pod. Both the job and Pod will be cleaned up automatically after completion. You can set a watch on the job and Pod before applying a new scan to observe the job deployment.

```
watch kubectl get scantemplates,scanpolicies,sourcescans,imagescans,pods,jobs
```

## <a id="troubleshooting"></a>Troubleshooting
If you run into any problems or face non-expected behavior, you can always address the logs to get more feedback.

```
kubectl -n scan-link-system logs -f deployment/scan-link-controller-manager -c manager
```

### <a id="miss-img-ps"></a>Missing target image pull secret

Scanning an image from a private registry requires an image pull secret to exist in the Scan CR's namespace and be referenced as `grype.targetImagePullSecret` in `tap-values.yml`. See [Installing the Tanzu Application Platform Package and Profiles](../install.md) for more information.

If a private image scan is triggered and the secret is not configured, the scan job will fail with the error as follows:

```
Job.batch "scan-${app}-${id}" is invalid: [spec.template.spec.volumes[2].secret.secretName: Required value, spec.template.spec.containers[0].volumeMounts[2].name: Not found: "registry-cred"]
```

### <a id="reporting-wrong-blob-url"></a> Blob Source Scan is reporting wrong source URL

  A Source Scan for a blob artifact can result in reporting in the `status.artifact` and `status.compliantArtifact` for the wrong URL for the resource, passing the remote ssh URL instead of the cluster local fluxcd one. One symptom of this issue is the `image-builder` failing with a `ssh:// is an unsupported protocol` error message. 

  You can confirm you're having this problem running a `kubectl describe` in the affected resource and comparing the `spec.blob.url` value against the `status.artifact.blob.url`. For example:

  ```console
  kubectl describe sourcescan <SOURCE-SCAN-NAME> -n <DEV-NAMESPACE>
  ```

  Compare the output:

  ```console
  ...
  spec:
    blob:
      ...
      url: http://source-controller.flux-system.svc.cluster.local./gitrepository/sample/repo/8d4cea98b0fa9e0112d58414099d0229f190f7f1.tar.gz
      ...
  status:
    artifact:
      blob:
        ...
        url: ssh://git@github.com:sample/repo.git
    compliantArtifact:
      blob:
        ...
        url: ssh://git@github.com:sample/repo.git
  ```

  **Workaround:** There are a few workarounds you can try to fix this issue:
  
    1. This problem is resolved in Supply Chain Security Tools - Scan `v1.2.0`. Upgrade your Supply Chain Security Tools - Scan and Grype Scanner deployment to version `v1.2.0` or later.
    1. Configure your SourceScan or Workload to connect to the repository by using HTTPS instead of using SSH.
    1. Edit the FluxCD GitRepository resource to not include the `.git` directory.
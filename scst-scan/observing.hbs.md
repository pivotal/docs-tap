# Observe Supply Chain Security Tools - Scan

This section outlines observability and troubleshooting methods and issues for using the Supply
Chain Security Tools - Scan components.

## <a id="watch-inflight-jobs"></a>Watching in-flight jobs
The scan will run inside the job, which creates a Pod. Both the job and Pod will be cleaned up automatically after completion. You can set a watch on the job and Pod before applying a new scan to observe the job deployment.

```
watch kubectl get scantemplates,scanpolicies,sourcescans,imagescans,pods,jobs
```

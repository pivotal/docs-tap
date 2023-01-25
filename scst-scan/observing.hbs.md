# Observing and troubleshooting

This section shows how to observe the scan job and get logs.


## <a id="watch-inflight-jobs"></a> Watching in-flight jobs

The scan will run inside the job, which creates a Pod. Both the job and Pod will be cleaned up
automatically after completion.
You can set a watch on the job and Pod before applying a new scan to observe the job deployment.

```console
watch kubectl get scantemplates,scanpolicies,sourcescans,imagescans,pods,jobs
```
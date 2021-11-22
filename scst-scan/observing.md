# Observing and troubleshooting

This sections shows how to observe the scan job and get logs.

## Watching in flight jobs
The scan will run inside the job which creates a pod. Both the job and pod will be cleaned up automatically after completion. You can set a watch on the job and pod before applying a new scan to observe the job deploy.
```bash
watch kubectl get scantemplates,scanpolicies,sourcescans,imagescans,pods,jobs
```

## Troubleshooting
If you run into any problem or face a non-expected behavior, you can always address the logs to get some more feedback on what's going on.
```bash
kubectl -n scan-link-system logs -f deployment/scan-link-controller-manager -c manager
```

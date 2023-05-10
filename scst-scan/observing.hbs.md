# Observe Supply Chain Security Tools - Scan

This topic outlines observability and troubleshooting methods and issues you can use with SCST - Scan components.

## <a id="observability"></a> Observability

The scans  run inside a Kubernetes Job where the Job creates a pod. Both the Job and pod are cleaned
up after completion.

Before applying a new scan, you can set a watch on the Jobs, Pods, SourceScans, Imagescans to
observe their progression:

```console
watch kubectl get sourcescans,imagescans,pods,taskruns,scantemplates,scanpolicies -n DEV-NAMESPACE
```
Where `DEV-NAMESPACE` is the developer namespace where the scanner is installed.
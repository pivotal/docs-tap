# Observe Supply Chain Security Tools - Scan

This topic outlines observability and troubleshooting methods and issues for using the SCST - Scan components.

## <a id="observability"></a> Observability

The scans run inside a Tekton TaskRun where the TaskRun creates a pod. Both the TaskRun and pod are cleaned up after completion.

Before applying a new scan, you can set a watch on the TaskRuns, Pods, SourceScans, Imagescans to observe their progression:

```console
watch kubectl get sourcescans,imagescans,pods,taskruns,scantemplates,scanpolicies
```

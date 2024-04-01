# Observe Supply Chain Security Tools - Scan

> **Note** This topic is part of Scan 1.0. Scan 1.0 has been deprecated as of the TAP 1.9 release.  Scan 1.0 will remain the default in the [test and scan supply chain](../getting-started/add-test-and-security.hbs.md#add-testing-and-scanning-to-your-application) in the TAP 1.9 release but it is recommended to opt-in to Scan 2.0 as Scan 1.0 will be replaced as the default and removed in a future version.  For more information about Scan 1.0 versus Scan 2.0, see the [scan overview page](./overview.hbs.md)

This topic outlines observability and troubleshooting methods and issues you can use with SCST - Scan components.

## <a id="observability"></a> Observability

The scans run inside a Tekton TaskRun where the TaskRun creates a pod. Both the TaskRun and pod are cleaned up after completion.

Before applying a new scan, you can set a watch on the TaskRuns, Pods, SourceScans, and Imagescans to observe their progression:

```console
watch kubectl get sourcescans,imagescans,pods,taskruns,scantemplates,scanpolicies -n DEV-NAMESPACE
```
Where `DEV-NAMESPACE` is the developer namespace where the scanner is installed.
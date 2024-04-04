# Observe Supply Chain Security Tools - Scan

This topic outlines observability and troubleshooting methods and issues you can use with SCST - Scan components.

> **Note** This topic uses SCST - Scan 1.0. SCST - Scan 1.0 is deprecated in
Tanzu Application Platform v1.9 and later. In Tanzu Application Platform v1.9, SCST - Scan 1.0 is
still the default in Supply Chain with Testing. For more information, see [Add testing and scanning to your application](../getting-started/add-test-and-security.hbs.md#add-testing-and-scanning-to-your-application).
VMware recommends using SCST - Scan 2.0 as SCST - Scan 1.0 will be removed in a future version and
SCST - Scan 2.0 will be the default. For more information, see [SCST - Scan versions](./overview.hbs.md).

## <a id="observability"></a> Observability

The scans run inside a Tekton TaskRun where the TaskRun creates a pod. Both the TaskRun and pod are cleaned up after completion.

Before applying a new scan, you can set a watch on the TaskRuns, Pods, SourceScans, and Imagescans to observe their progression:

```console
watch kubectl get sourcescans,imagescans,pods,taskruns,scantemplates,scanpolicies -n DEV-NAMESPACE
```
Where `DEV-NAMESPACE` is the developer namespace where the scanner is installed.
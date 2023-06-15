# Supply Chain Security Tools - Scan 2.0 (beta)

This topic describes how you can install and configure Supply Chain Security Tools - Scan 2.0.

>**Important** SCST - Scan 2.0 is in beta, which means that it is still in
>active development by VMware and might be subject to change at any point. Users
>might encounter unexpected behavior due to capability gaps. This is an opt-in
>component to gather early feedback from beta testers and is not installed by
>default with any profile.

## <a id="overview"></a>Overview

SCST - Scan 2.0 is responsible for providing the framework to scan applications
for their security posture. Scanning container images for known Common
Vulnerabilities and Exposures (CVEs) implements this framework. This framework
simplifies integration for new plug-ins by allowing users to integrate new scan
engines by minimizing the scope of the scan engine to only scan and push results
to an OCI compliant registry.

During scanning:

- The `ImageVulnerabilityScan` creates a [Tekton PipelineRun](https://tekton.dev/docs/pipelines/pipelineruns/) which instantiates a Pipeline. The Pipeline Spec specifies the tasks `workspace-setup-task`, `scan-task`, and `publish-task` to set up the workspace and environment configuration, run a scan, and publish results to an OCI compliant registry.
- Each Task contains steps which execute commands to achieve the goal of the Task.
- The PipelineRun creates corresponding TaskRuns for every Task in the Pipeline and executes them.
- A Tekton Sidecar as a [no-op sidecar](https://github.com/tektoncd/pipeline/blob/main/cmd/nop/README.md#stopping-sidecar-containers) triggers Tekton's injected sidecar cleanup.

>**Note** SCST - Scan 2.0 is in beta and supersedes the [SCST - Scan component](overview.hbs.md).

## <a id="features"></a>Features

SCST - Scan 2.0 includes the following features:

- Tekton is used as the orchestrator of the scan to align with overall Tanzu Application Platform use of Tekton for multi-step activities.
- Users can define their own `ImageVulnerabilityScan` Custom Resource (CR) to incorporate their own specifications. Mapping logic turns the domain-specific specifications into a Tekton PipelineRun.
- CycloneDX-formatted scan results are pushed to an OCI registry for long-term storage.
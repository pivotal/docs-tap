# Glossary of Terms

These are terms that are used throughout the documentation and within the extension itself. Some of these terms are unique to the Tanzu Application Platform, while others may have a different meaning outside of the Tanzu Application Platform and have been included here for clarification.

## Terms

### <a id="live-update"></a>Live Update
Live Update (facilitated by [Tilt](https://docs.tilt.dev/)) enables you to deploy your workload once, then save changes to the code and see those changes reflected in the workload running on the cluster within seconds. In their own words “Tilt automates all the steps from a code change to a new process: watching files, building container images, and bringing your environment up-to-date.” which means that while using Live Update, all you have to do is save your code changes to see them reflected in your application running on your cluster - no redeploy necessary.

### <a id="tiltfile"></a>Tiltfile
The Tiltfile is a file with no extension that is required for Tilt to enable the Live Update functionality. For more information about the Tiltfile see [Tilt’s documentation](https://docs.tilt.dev/tiltfile_concepts.html).
Debugging on the Cluster

The Tanzu Developer Tools extension enables you to debug your application in a production-like environment* by debugging on your TAP-enabled Kubernetes cluster

> **Note:** An environment’s similarity to production relies on keeping dependencies updated, among other variables.

### <a id="yaml-file-format"></a>YAML File Format
YAML “is a human-readable data-serialization language. It is commonly used for configuration files…”. For more information see the [YAML Wikipedia entry](https://en.wikipedia.org/wiki/YAML).

### <a id="workload-yaml"></a>workload.yaml File
The workload yaml file is a required configuration file used by the Tanzu Application Platform to specify the details of an application including its name, type, and source code URL.

### <a id="catalog-info-yaml"></a>catalog-Info.yaml File
The catalog-info yaml file enables the workloads created with the Tanzu Developer Tools extension to be visible in the [TAP GUI](https://github.com/pivotal/docs-tap/blob/main/tap-gui/about.md).

### <a id="code-snippet"></a>Code Snippet
[Code snippets](https://code.visualstudio.com/docs/editor/userdefinedsnippets) enable you to quickly add the files necessary to develop against the Tanzu Application Platform (TAP) to existing projects by creating a template in an empty file which you fill out with the required information.

### <a id="source-image"></a>Source Image
Registry location to publish local source code, for example "registry.io/yourapp-source". Must include both a registry and a project name.

### <a id="local-path"></a>Local Path
The Local Path value tells the Tanzu Developer Tools extension which directory on your local file system to bring into the source image (link to source image definition on this page) container image. The default local path value is the current directory (where your open VS Code project’s files are saved).

### <a id="kubernetes-context"></a>Kubernetes Context
A Kubernetes Context is “... a set of access parameters that contains a Kubernetes cluster, a user, and a namespace. A kubernetes context acts like a set of coordinates that describe the target of the kubernetes commands you run. For more information see the [Kubernetes Documentation](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/).

### <a id="kubernetes-namespace"></a>Kubernetes Namespace
As defined by the [Kubernetes documentation](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/), “In Kubernetes, namespaces provide a mechanism for isolating groups of resources within a single cluster. Names of resources need to be unique within a namespace, but not across namespaces. ”

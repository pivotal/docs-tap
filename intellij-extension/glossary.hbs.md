# Glossary of terms

This topic gives you explanations of common terms used throughout the Tanzu Developer Tools for IntelliJ
documentation, and within the extension itself.
Some of these terms are unique to Tanzu Application Platform, while others might have a different
meaning outside of Tanzu Application Platform and are included here for clarification.

## <a id="live-update"></a> Live Update

Live Update, facilitated by [Tilt](https://docs.tilt.dev/), enables you to deploy your workload
once, save changes to the code, and see those changes reflected in the workload running on the
cluster within seconds.

## <a id="tiltfile"></a> Tiltfile

The Tiltfile is a file with no extension that is required for Tilt to enable the Live Update feature.
For more information about the Tiltfile, see the
[Tilt documentation](https://docs.tilt.dev/tiltfile_concepts.html).

## <a id="debug"></a> Debugging on the cluster

The Tanzu Developer Tools on IntelliJ extension enables you to debug your application in an environment
similar to production by debugging on your Tanzu Application Platform enabled Kubernetes cluster.

> **Note** An environment’s similarity to production relies on keeping dependencies updated, among
> other variables.

## <a id="yaml-file-format"></a> YAML file format

YAML is a human-readable data-serialization language. It is commonly used for configuration files.
For more information, see the [YAML Wikipedia entry](https://en.wikipedia.org/wiki/YAML).

## <a id="workload-yaml"></a> workload.yaml file

The workload YAML file is a required configuration file used by the Tanzu Application Platform to
specify the details of an application including its name, type, and source code URL.

## <a id="catalog-info-yaml"></a> catalog-info.yaml file

The catalog-info YAML file enables the workloads created with the Tanzu Developer Tools for IntelliJ
extension to be visible in [Tanzu Developer Portal](../tap-gui/about.hbs.md).

## <a id="code-snippet"></a> Code snippet

[Code snippets](https://code.visualstudio.com/docs/editor/userdefinedsnippets)
enable you to quickly add project files that are necessary to develop using Tanzu Application Platform
by creating a template in an empty file that you fill out with the required information.

## <a id="source-image"></a> Source image

The source image is the registry location to publish local source code, for example,
`registry.io/yourapp-source`. This must include both a registry and a project name.

## <a id="local-path"></a> Local path

The local path value tells the Tanzu Developer Tools for IntelliJ extension which directory
on your local file system to bring into the [source image](#source-image) container image.
The default local path value is the current directory where you saved the files for your open IntelliJ
project.

## <a id="kubernetes-context"></a> Kubernetes context

A Kubernetes context is a set of access parameters that contains a Kubernetes cluster, a user, and a
namespace. A Kubernetes context acts like a set of coordinates that describe the target of the
Kubernetes commands that you run. For more information, see the
[Kubernetes documentation](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/).

## <a id="kubernetes-namespace"></a>Kubernetes namespace

As defined by the
[Kubernetes documentation](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/),
in Kubernetes, namespaces provide a mechanism for isolating groups of resources within a single
cluster. Names of resources need to be unique within a namespace, but not across namespaces.

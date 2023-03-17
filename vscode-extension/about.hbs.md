# Overview of VMware Tanzu Developer Tools for Visual Studio Code

Tanzu Developer Tools for Visual Studio Code (VS Code) is the official VMware Tanzu IDE extension for
VS Code.
It helps you develop with the Tanzu Application Platform.
This Tanzu Developer Tools extension enables you to rapidly iterate on your workloads on supported Kubernetes
clusters with Tanzu Application Platform installed.

Tanzu Developer Tools for VS Code currently supports VS Code only on macOS for Java applications.

## <a id="extension-features"></a> Extension Features

**Deploy applications directly from VS Code**

The extension enables rapid iteration of your applications on
Tanzu Application Platform by deploying them as workloads directly from within VS Code.

**See code updates running on-cluster in seconds**

With Live Update (facilitated by Tilt), the extension enables you to deploy
your workload once, save changes to the code and see those changes reflected within seconds in the
workload running on the cluster.

**Debug workloads directly on the cluster**

The extension enables you to debug your application in a production-like
environment by debugging on your Kubernetes cluster enabled by Tanzu Application Platform.
An environment’s similarity to production relies on keeping dependencies and other variables updated.

*An environment’s similarity to production relies on keeping dependencies updated, among other variables.

From the Workloads panel you can see any workload found within the cluster and namespace specified in
the current kubectl context.

# Overview of Tanzu Developer Tools for VS Code

Tanzu Developer Tools for Visual Studio Code (VS Code) is the official VMware Tanzu IDE extension
for VS Code. The extension helps you develop with Tanzu Application Platform and enables you to
rapidly iterate on your workloads on supported Kubernetes clusters that have Tanzu Application
Platform installed.

Tanzu Developer Tools for VS Code currently supports VS Code only on macOS for Java applications.

## <a id="extension-features"></a> Extension features

- **Deploy applications directly from VS Code**
  Rapidly iterate on your applications on Tanzu Application Platform by deploying them as workloads
  directly from within VS Code.

- **See code updates running on-cluster in seconds**
  With Live Update (facilitated by Tilt), you can deploy your workload once, save changes to the code
  and then see those changes reflected within seconds in the workload running on the cluster.

- **Debug workloads directly on the cluster**
  Debug your application in a production-like environment by debugging on your Kubernetes cluster
  that has Tanzu Application Platform.
  An environment’s similarity to production relies on keeping dependencies and other variables updated.

- **See workloads running on the cluster**
  From the Workloads panel you can see any workload found within the cluster and namespace specified
  in the current kubectl context.

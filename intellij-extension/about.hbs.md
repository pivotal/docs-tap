# Overview of Tanzu Developer Tools for IntelliJ

Tanzu Developer Tools for IntelliJ is VMware Tanzu's official IDE extension for IntelliJ IDEA to help
you develop with the Tanzu Application Platform.
This extension enables you to rapidly iterate on your workloads on supported Kubernetes clusters that
have Tanzu Application Platform installed.

Tanzu Developer Tools for IntelliJ currently supports Java applications on macOS and Windows.

## <a id="extension-features"></a> Extension features

This extension gives the following features.

- **Deploy applications directly from IntelliJ**
  Rapidly iterate on your applications on Tanzu Application Platform and deploy them as workloads
  directly from within IntelliJ.

- **See code updates running on-cluster in seconds**
  With the use of Live Update facilitated by Tilt, deploy your workload once, save changes to the
  code and then, seconds later, see those changes reflected in the workload running on the cluster.

- **Debug workloads directly on the cluster**
  Debug your application in a production-like environment by debugging on your Kubernetes cluster
  that has Tanzu Application Platform.
  An environment’s similarity to production relies on keeping dependencies updated, among other
  variables.

- **See workloads running on the cluster**
  From the Workloads panel you can see any workload found within the cluster and namespace specified
  in the current kubectl context.

- **Work with microservices in a Java monorepo**
  Tanzu Developer Tools for IntelliJ v1.3 and later supports working with a monorepo containing
  multiple modules that represent different microservices.
  This makes it possible to deploy, debug, and live update multiple workloads simultaneously from
  the same IntelliJ multimodule project. For more information about projects with multiple modules,
  see the
  [IntelliJ documentation](https://www.jetbrains.com/help/idea/creating-and-managing-modules.html#modules-idea-java).
  For more information about a typical monorepo setup, see
  [Working with microservices in a monorepo](using-the-extension.hbs.md#mono-repo).

-  **Note** The new variation of the out-of-the-box (OOTB) Basic supply chains, which output [Carvel packages](../scc/carvel-package-supply-chain.hbs.md) to enable configuring multiple runtime environment, is not yet supported in this plugin.

## <a id="next-steps"></a> Next steps

[Follow the steps to install the extension](install.hbs.md).

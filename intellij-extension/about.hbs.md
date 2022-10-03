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
  From the workload panel you can see any workload found within the cluster and namespace specified
  in the current kubectl context.

- **Work with Microservices in a Java Monorepo**
  Since version 1.3 we support working with Monorepo containing multiple 'modules' representing 
  different 'microservices'. This means it is possible to Deploy, Debug and Live update multiple
  workloads simultaneously from the same [InteliJ multimodule project](https://www.jetbrains.com/help/idea/creating-and-managing-modules.html#modules-idea-java).

## <a id="next-steps"></a> Next steps

[Follow the steps to install the extension](install.md).

# Overview of Tanzu Developer Tools for Visual Studio

Tanzu Developer Tools for Visual Studio is VMware Tanzu’s official IDE extension for Visual Studio 2022 to help you develop with the Tanzu Application Platform.
This extension enables you to rapidly iterate on your workloads on supported Kubernetes clusters that have Tanzu Application Platform installed.

Tanzu Developer Tools for Visual Studio currently supports .NET C# applications.

This extension is for Microsoft Visual Studio 2022 only. It is incompatible with Visual Studio Code or Visual Studio for Mac.

> **Note** This extension is in the beta stage of development.

## Extension Features

The extension has the following features:

- **Deploy applications directly from Visual Studio**
  Rapidly iterate on your applications on Tanzu Application Platform and deploy them as workloads directly from within Visual Studio.

- **See code updates running on-cluster in seconds**
  With the use of Live Update facilitated by Tilt, deploy your workload once, save changes to the code and then, seconds later, see those changes reflected in the workload running on the cluster.

- **Debug workloads directly on the cluster**
  Debug your application in a production-like environment by debugging on your Kubernetes cluster that has Tanzu Application Platform.
  An environment’s similarity to production relies on keeping dependencies updated, among other variables.

- **Work with microservices in a Visual Studio Solution**
  Work with multiple solution projects that represent discrete microservices.
  This makes it possible to deploy, debug, and Live Update multiple workloads simultaneously from the same solution.

{{> 'partials/ide-extensions/no-ootb-basic-variation' }}

## <a id="next-steps"/>Next steps

[Install Tanzu Developer Tools for Visual Studio](install.hbs.md).

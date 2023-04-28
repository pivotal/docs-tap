# Overview of Tanzu Developer Tools for Visual Studio

VMware Tanzu Developer Tools for Visual Studio is the official VMware Tanzu IDE extension for
Visual Studio 2022.
The extension helps you develop with Tanzu Application Platform and enables you to rapidly iterate
on your workloads on supported Kubernetes clusters that have Tanzu Application Platform installed.

This plug-in extends Microsoft Visual Studio 2022 only. It is incompatible with Visual Studio Code
and Visual Studio for Mac.

> **Note** This extension is in the beta stage of development.

## Extension Features

The extension has the following features:

- **See code updates running on-cluster in seconds**

  With the use of Live Update facilitated by Tilt, deploy your workload once, save changes to the code
  and then, seconds later, see those changes reflected in the workload running on the cluster.
  All Live Update output is filtered to its own output pane window within Visual Studio.

- **Debug workloads directly on the cluster**

  Debug your application in a production-like environment by debugging on a Kubernetes cluster of
  yours that has Tanzu Application Platform.
  The similarity of an environment to production relies on keeping dependencies updated, among other
  variables.

- **Deploy a workload to a Kubernetes cluster**

  Deploy your workload straight to your Kubernetes cluster and, after you're finished using it, you
  can delete it. All the output for deleting a workload is filtered to its own output pane window
  within Visual Studio.

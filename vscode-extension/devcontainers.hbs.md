# Dev Containers support

This topic tells you about using DevContainers to develop applications on Tanzu Application Platform.

Support for Dev Containers is currently **experimental**.

## <a id="intro"></a> Introduction to Dev Containers

A Development Container (or Dev Container for short) allows you to use a container as a full-featured development environment. It can be used to run an application, to separate tools, libraries, or runtimes needed for working with a codebase, and to aid in continuous integration and testing. For more information visit [containers.dev](https://containers.dev/)

## <a id="prerequisites"></a> Prerequisites

- Docker [Desktop 2.0+](https://www.docker.com/products/docker-desktop) or [Rancher Desktop](https://rancherdesktop.io/) on Windows and macOS.
- VScode Dev Containers [extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
- More detailed information about requirements in the VScode docs on [https://code.visualstudio.com/docs/devcontainers/containers#\_system-requirements](devcontainers)
- AMD architecture: The current alpha release of tanzu devcontainer does not yet support ARM (e.g. Apple M1 Silicon).

## <a id="getting-started"></a> Getting started

You can start a new project with Dev Containers support or add Dev Containers support for an existing project:

### <a id="new-project"></a> Setting up a new project using Accelerators

1. From Accelerator page in TAP GUI, select the Tanzu Java Web App accelerator
2. Select the desired options
3. Check the box for "Include .devcontainer.json (amd64 support only)"
4. Open the project using VScode
5. Follow VSCode prompts to restart IDE in devcontainer and you will be connected to the devcontainer

### <a id="existing-project"></a> Adding dev container support to an existing project

1. Open project with VScode, make sure you are using Tanzu Developer Tools plugin 1.1.0 or above
2. Create an empty new file named devcontainer
3. Type tanzu devcontainer and hit enter
4. Rename the file to .devcontainer.json file
5. Follow VSCode prompts to restart IDE in devcontainer and you will be connected to the devcontainer

## <a id="usage"></a> Usage

### <a id="use-cluster"></a> Connect to your cluster

When you start working in your devcontainer for the first time, you will need to login and connect to your
Tanzu kubernetes cluster. The way you do that exactly will vary depending on your cloud provider. For example,
for Google Cloud you might run a command similar to this:

```
gcloud container clusters get-credentials ${your_cluster_name} --region ${your_region} --project ${your_google_cloud_project_name}
```

Refer to the documentation of your specific cloud provider for detailed information on how to connect to a cluster.

Once you logged into the cluster you will need to Restart the IDE for it to become aware of the new cluster connection: press CTRL-SHIFT-P (or CMD-SHIFT-P on Mac) and choose
"Developer: Reload Window" in the command palette.

You are now ready to start working on your code and deploy it to your cluster and monitor
your workloads in the Tanzu Panel.

## <a id="cli-eula"></a> Tanzu CLI EULA and other Legal Requirements

Notice that in the `.devcontainer.json` you can find the following:

```
"projects.registry.vmware.com/tanzu-developer-containers/features/vmware-tanzu-dev-tools": {
   "acceptEula": true, // <-- See https://www.vmware.com/vmware-general-terms.html
   "acceptCeip": false // <-- See https://www.vmware.com/solutions/trustvmware/ceip.html
}
```

When building the devcontainer it installs `tanzu` cli. To
[avoid interactive prompts](https://github.com/vmware-tanzu/tanzu-cli/blob/main/docs/quickstart/install.md#automatic-prompts-and-potential-mitigations)
from breaking the installation process, some options have to be preselected:

1. `"acceptEula": true` means you accept the EULA (https://www.vmware.com/vmware-general-terms.html).

2. `"acceptCeip": false` means you did not agree to participate in
   [Tanzu CEIP Program](https://www.vmware.com/solutions/trustvmware/ceip.html). It is set by default to false, if you did want to participate in the program
   you can change that value to `true` instead.

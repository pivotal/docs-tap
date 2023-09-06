# Use development containers to launch a development environment (alpha)

This topic tells you about using development containers (sometimes shortened to dev containers) to
launch a ready-to-code development environment. This enables developers to connect to a
pre-configured dev container that includes all Tanzu tools and IDE extensions required for
development on Tanzu pre-installed.

> **Caution** Support for development containers is currently in alpha testing. It is intended for
> evaluation and test purposes only.

## <a id="overview"></a> Overview of development containers

A development container enables you to use a container as a full-featured development environment.
It can be used to run an application, to separate tools, libraries, or runtimes needed for working
with a codebase, and to aid in continuous integration and testing. For more information, see
[containers.dev](https://containers.dev/)

## <a id="prerequisites"></a> Prerequisites

Obtain the following:

- [Docker Desktop v2.0 or later](https://www.docker.com/products/docker-desktop/) or
  [Rancher Desktop](https://rancherdesktop.io/) on Windows or macOS. If using Docker Desktop, ensure
  that you meet the [system requirements for the VS Code Dev Containers extension](https://code.visualstudio.com/docs/devcontainers/containers#_system-requirements).
- The Visual Studio Code [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
- AMD architecture, because `tanzu devcontainer` does not yet support ARM, such as Apple M1 Silicon.

## <a id="get-started"></a> Get started

You can start a new project with support for development containers or you can add support for
development containers to an existing project:

### <a id="new-project"></a> Set up a new project by using accelerators and development containers

To set up a new project:

1. From the Accelerator page in Tanzu Developer Portal, select the Tanzu Java Web App accelerator.
2. Select the options you want.
3. Select the checkbox for **Include .devcontainer.json (amd64 support only)**.
4. Open the project in VS Code.
5. Follow the VS Code prompts to restart the IDE in `devcontainer` to connect to the development
   container.

### <a id="existing-project"></a> Add a development container to an existing project

To add a development container to an existing project:

1. Open project with Visual Studio Code and ensure that you have the Tanzu Developer Tools plug-in
   v1.1.0 or later.
2. Create an empty new file named `devcontainer`.
3. Type `tanzu devcontainer` and press Enter.
4. Rename the file as `.devcontainer.json`.
5. Follow the Visual Studio Code prompts to restart the IDE in `devcontainer` to connect to the
   development container.

## <a id="use-dev-container"></a> Use the development container

### <a id="use-cluster"></a> Connect to your cluster

When you start working in your development container for the first time, you need to log in and
connect to your Tanzu Kubernetes cluster. The way you do that exactly will vary depending on your
cloud provider. For example, for Google Cloud you might run a command similar to this:

```console
gcloud container clusters get-credentials ${your_cluster_name} --region ${your_region} --project ${your_google_cloud_project_name}
```

Refer to the documentation of your specific cloud provider for detailed information on how to
connect to a cluster.

After you log into the cluster you will need to restart the IDE for it to become aware of the new
cluster connection: press CTRL-SHIFT-P (or CMD-SHIFT-P on macOS) and select **Developer: Reload Window**
in the command palette.

You are now ready to start working on your code and deploy it to your cluster and monitor your
workloads in the Tanzu Panel. Please follow the user guide at
[Use Tanzu Developer Tools for VS Code](using-the-extension.hbs.md) to continue your development with
Tanzu Developer Tools for VS Code.

## <a id="cli-eula"></a> Tanzu CLI VMware General Terms and other Legal Requirements

Notice that in the `.devcontainer.json` you can find the following:

```json
"projects.registry.vmware.com/tanzu-developer-containers/features/vmware-tanzu-dev-tools": {
   "acceptEula": true, // <-- See https://www.vmware.com/vmware-general-terms.html
   "acceptCeip": false // <-- See https://www.vmware.com/solutions/trustvmware/ceip.html
}
```

When building `devcontainer`, Tanzu CLI is installed.
To [avoid interactive prompts](https://github.com/vmware-tanzu/tanzu-cli/blob/main/docs/quickstart/install.md#automatic-prompts-and-potential-mitigations)
from breaking the installation process, some options have to be preselected:

1. `"acceptEula": true` means you accept the VMware general terms (https://www.vmware.com/vmware-general-terms.html).

2. `"acceptCeip": false` means you did not agree to participate in
   [Tanzu CEIP Program](https://www.vmware.com/solutions/trustvmware/ceip.html).
   It is set by default to false, if you did want to participate in the program you can change that
   value to `true` instead.

# Get started with Tanzu Application Platform

Welcome to the Tanzu Application Platform. The guides in this section offer hands-on instruction to help get developers and operators started on Tanzu Application Platform. Before you start, be sure to complete all of the prerequisites in the following section.

## <a id="get-started-prereqs"></a>Getting started prerequisites

Verify you have successfully:

- **Installed the Tanzu Application Platform**<br>
See [Installing Tanzu Application Platform](install-intro.md).

- **Installed the Tanzu Application Platform on the target Kubernetes cluster**<br>
See [Installing the Tanzu CLI](install-tanzu-cli.md) and [Installing the Tanzu Application Platform Package and Profiles](install-online/profile.hbs.md).

- **Set the default kubeconfig context to the target Kubernetes cluster**<br>
See [Changing clusters](cli-plugins/apps/tutorials.hbs.md#changing-clusters).

- **Installed Out of The Box (OOTB) Supply Chain Basic**<br>
See [Install Out of The Box Supply Chain Basic](scc/install-ootb-sc-basic.md).
If you used the default profiles provided in [Installing the Tanzu Application Platform Package and Profiles](install-online/profile.hbs.md), you have already installed the Out of The Box (OOTB) Supply Chain Basic.

- **Installed Tekton Pipelines**<br>
  See [Install Tekton Pipelines](tekton/install-tekton.md).
  If you used the default profiles provided in
  [Installing the Tanzu Application Platform Package and Profiles](install-online/profile.hbs.md),
  you have already installed Tekton Pipelines.

- **Set up a developer namespace to accommodate the developer workload**<br>
See [Set up developer namespaces to use your installed packages](install-online/set-up-namespaces.hbs.md).

- **Installed Tanzu Application Platform GUI**<br>
See [Install Tanzu Application Platform GUI](tap-gui/install-tap-gui.md).
If you used the Full or View profiles provided in [Installing the Tanzu Application Platform Package and Profiles](install-online/profile.hbs.md),
you have already installed Tanzu Application Platform GUI.

- **Installed the VS Code Tanzu Extension**<br>
See [Install the Visual Studio Code Tanzu Extension](vscode-extension/install.md) for instructions.

When you have completed these prerequisites, you are ready to get started.

## Next steps

For developers:

- [Create an application accelerator](getting-started/create-app-accelerator.hbs.md)
- [Deploy an app on Tanzu Application Platform](getting-started/deploy-first-app.md)
- [Deploy Spring Cloud Applications to Tanzu Application Platform](getting-started/spring-apps/deploy-spring-cloud-apps.hbs.md)

For operators:

- [Add testing and scanning to your application](getting-started/add-test-and-security.hbs.md)
- [Configure image signing](getting-started/config-supply-chain.hbs.md)

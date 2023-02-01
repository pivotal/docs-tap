# Create an accelerator
> **Note** This guide follows a "quick start" format, see the [Application Accelerator docs](/application-accelerator/about-application-accelerator.hbs.md) for advanced features.

## <a id="you-will"></a>What you will do

- Create a new accelerator project which contains an `accelerator.yaml` and `README.md`.
- Update the `accelerator.yaml` to alter the project's `README.md`.
- Test your accelerator locally using the Tanzu CLI's `generate-from-local` command.
- Create a new git repository for the project and push the project to it.
- Register the accelerator in a Tanzu Application Platform instance.
- View the new accelerator in the Tanzu Application Platform GUI and generate a new project from it.

## <a id="ide-set-up-for-authoring"></a>Setting up [VS Code](https://code.visualstudio.com/download) for authoring accelerators

1. To streamline accelerator authoring, code assist capabilities are available through the [YAML plugin](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml). To install the extension navigate to the [YAML plugin's Marketplace page](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml) and click the **"Install"** button.
2. Once installed, editing files entitled `accelerator.yaml` will now automatically use the code assist capabilities.

## Creating a simple project

1. Create a new folder for the project named `myProject` and change directories to the newly created folder.
```bash
mkdir myProject
cd myProject
```
2. Create two new files in the `myProject` folder named `README.md` and `accelerator.yaml`.

```bash
touch README.MD accelerator.yaml
```
3. Using VS Code, open the `README.md` and copy and paste the following text into it.
```
## Tanzu Application Accelerator Sample Project

This is some very important placeholder text that should describe what this project does and how to use it.

### How to use the Sample Project
```
4. 

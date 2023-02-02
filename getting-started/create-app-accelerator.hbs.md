# Create an accelerator
> **Note** This guide follows a "quick start" format, see the [Application Accelerator docs](/application-accelerator/about-application-accelerator.hbs.md) for advanced features.

## <a id="you-will"></a>What you will do

- Create a new accelerator project which contains an `accelerator.yaml` and `README.md`.
- Define the `accelerator.yaml` to alter the project's `README.md`.
- Test your accelerator locally using the Tanzu CLI's `generate-from-local` command.
- Create a new git repository for the project and push the project to it.
- Register the accelerator in a Tanzu Application Platform instance.
- View the new accelerator in the Tanzu Application Platform GUI and generate a new project from it.

## <a id="ide-set-up-for-authoring"></a>Set up [VS Code](https://code.visualstudio.com/download) for authoring accelerators

1. To simplify accelerator authoring, code assist capabilities are available through the [YAML plugin](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml). To install the extension navigate to the [YAML plugin's Marketplace page](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml) and click the **"Install"** button.
2. Once installed, editing files entitled `accelerator.yaml` will now automatically use the code assist capabilities.

## Create a simple project

### Set up the project directory
1. Create a new folder for the project named `myProject` and change directories to the newly created folder.
```bash
mkdir myProject
cd myProject
```
2. Create two new files in the `myProject` folder named `README.md` and `accelerator.yaml`.

```bash
touch README.MD accelerator.yaml
```
### Prepare the `README.md` and `accelerator.yaml`
The following instructions will require using VS Code to edit the files

1. Using VS Code, open the `README.md`, copy and paste the following text into it, and save the file. `<CONFIGURABLE_PARAMETER_#>` will be what is targeted to be transformed during project generation in the upcoming `accelerator.yaml` definition.
```markdown
## Tanzu Application Accelerator Sample Project

This is some very important placeholder text that should describe what this project can do and how to use it.

Here are some configurable parameters:

<CONFIGURABLE_PARAMETER_1>
<CONFIGURABLE_PARAMETER_2>
```

1. Open the `accelerator.yaml` and begin populating the file section using the snippet below. This section contains important information such as the accelerator's display name, description, tags, and more. 

    >**Tip** See the [Creating accelerator.yaml doc](/application-accelerator/creating-accelerators/accelerator-yaml.hbs.md#accelerator-metadata) for all the possible parameters available in this section.

```yaml
accelerator:
  displayName: Simple Accelerator
  description: Contains just a README
  iconUrl: https://blogs.vmware.com/wp-content/uploads/2022/02/tap.png
  tags:
    - simple
    - getting-started
```
2. Add the configuration parameters using the snippet below. This configures what parameters will be displayed in the accelerator form during project creation. 

    In this example snippet, the field `firstConfigurableParameter` takes in text that is provided by the user. The `secondConfigurableParameter` does the same thing except it will only be displayed if the user checks `secondConfigurableParameterCheckbox` because of the `dependsOn` parameter.

    > **Tip** For more information on possible options, see the [Creating accelerator.yaml doc](/application-accelerator/creating-accelerators/accelerator-yaml.hbs.md#accelerator-options).
```yaml
# Place this after the 'tags' section
  options:
    - name: firstConfigurableParameter
      inputType: text
      label: The text used to replace the first placeholder text in the README.md. Converted to lowercase.
      defaultValue: Configurable Parameter 1
      required: true
    - name: secondConfigurableParameterCheckbox
      inputType: checkbox
      dataType: boolean
      label: Enable to configure the second configurable parameter, otherwise use the default value.
    - name: secondConfigurableParameter
      inputType: text
      label: The text used to replace the second placeholder text in the README.md. Converted to lowercase.
      defaultValue: Configurable Parameter 2
      dependsOn: 
        name: secondConfigurableParameterCheckbox
```
3. 

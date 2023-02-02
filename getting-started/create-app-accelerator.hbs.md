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

2. Open the `accelerator.yaml` and begin populating the file section using the snippet below. This section contains important information such as the accelerator's display name, description, tags, and more. 

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
3. Add the configuration parameters using the snippet below. This configures what parameters will be displayed in the accelerator form during project creation. 

    In this example snippet, the field `firstConfigurableParameter` takes in text that is provided by the user. The `secondConfigurableParameter` does the same thing except it will only be displayed if the user checks `secondConfigurableParameterCheckbox` because of the `dependsOn` parameter.

    > **Tip** For more information on possible options, see the [Creating accelerator.yaml doc](/application-accelerator/creating-accelerators/accelerator-yaml.hbs.md#accelerator-options).
```yaml
# Place this after the 'tags' section from the previous step
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
4. Add the `engine` configuration using the snippet below and save the file.

    The `engine` configuration tells the `accelerator engine` behind the scenes what needs to be done to the project files during project creation. In this example, this instructs the engine to replace `<CONFIGURABLE_PARAMETER_1>` and, if the checkbox is checked, `<CONFIGURABLE_PARAMETER_2>` with the parameters that the user passes in during project creation. 
    
    This also leverages a simple [Spring Expression Language (SpEL)](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#expressions) syntax to convert the text input to all lowercase.

    >**Tip** For more information about the possible parameters for use within the `engine` section, see the [Creating accelerator.yaml doc](/application-accelerator/creating-accelerators/accelerator-yaml.hbs.md#engine).

```yaml
# Place this after the `options` section from the previous step
engine:
  merge:
    - include: [ "README.md" ]
      chain:
        - type: ReplaceText
          substitutions:
            - text: "<CONFIGURABLE_PARAMETER_1>"
              with: "#firstConfigurableParameter.toLowerCase()"
        - condition: "#secondConfigurableParameterCheckbox"
          chain:
          - type: ReplaceText
            substitutions:
              - text: "<CONFIGURABLE_PARAMETER_2>"
                with: "#secondConfigurableParameter.toLowerCase()"
```
### Test the accelerator
It is important to quickly test and iterate on accelerators as they are being developed to ensure that the resulting project is being generated as expected.

1. Using any terminal of your choice which has access to the `tanzu` command, run the following command to test the accelerator created earlier.

    This step takes the local `accelerator.yaml` and project files, configures the project using the parameters passed in through the `--options` field, and outputs the project to a specified directory.

    >**Note** this step requires that the `accelerator` endpoint is exposed and accessible.

```bash
tanzu accelerator generate-from-local -- \
    --accelerator-path simple-accelerator="$(pwd)" \ # The path to new accelerator
    --server-url TANZU-APPLICATION-ACCELERATOR-URL \ # Example: https://accelerator.mytapcluster.myorg.com
    --options '{"firstConfigurableParameter": "Parameter 1", "secondConfigurableParameterCheckbox": true, "secondConfigurableParameter":"Parameter 2"}' \
    -o "${HOME}/simple-accelerator/" # Change this path to change where the project folder gets generated
```
2. Once the project is generated, a status message will be displayed.
```
generated project simple-accelerator
```
3. Navigate to output directory and validate that the `README.md` has been updated based on the `--options` specified in the `generate-from-local` command above.
```
## Tanzu Application Accelerator Sample Project

This is some very important placeholder text that should describe what this project can do and how to use it.

Here are some configurable parameters:

parameter 1
parameter 2
```

## Upload the project to a git repository
The Application Accelerator system and Tanzu Application Platform GUI depends on an accelerator project living inside a git repository. For this example, [GitHub](https://github.com/) will be used.

1. [Create a new repository in GitHub](https://docs.github.com/en/get-started/quickstart/create-a-repo) and ensure that the "Visibility" is set to "Public". Click "Create Repository".
2. To push your accelerator project (**not** the generated project from `generate-from-local`) to GitHub, follow the instructions that GitHub provides for the *"…or create a new repository on the command line"* that is shown after clicking "Create Repository". The instructions can also be found on the ["Adding locally hosted code to GitHub"](https://docs.github.com/en/get-started/importing-your-projects-to-github/importing-source-code-to-github/adding-locally-hosted-code-to-github#adding-a-local-repository-to-github-using-git) page.
3. Verify that the project has been successfully pushed to the target repository.

## Register the accelerator to the Tanzu Application Platform GUI

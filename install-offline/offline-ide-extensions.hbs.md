# Install IDE extensions in your air-gapped environment

This topic tells you how to install IDE extensions in your air-gapped environment.

To install VS Code or IntelliJ extensions in an air-gapped environment, you cannot use 
IDE's built-in UI, because it downloads and install extensions directly from VS Code or 
IntelliJ Marketplace.

The following are high-level steps to install IDE extensions in your air-gapped environment:

1. Outside the air-gapped environment: 
    1. Download the extension as an archive from VS Code or IntelliJ Marketplace. 
    2. Copy the extension to a location that is accessible from within the air-gapped environment.
2. In the air-gapped environment: 
    1. Install the extension into the IDE by using the archive generated earlier.

## <a id="vscode"></a> Install VS Code in your air-gapped environment

Follow these steps to retrieve the `.vsix` archive and install VS Code in your air-gapped environment:

1. Find the extension you want to install on VS Code Marketplace. For example: 

    - [Tanzu Developer Tools for Vscode](https://marketplace.visualstudio.com/items?itemName=vmware.tanzu-dev-tools)
    - [Tanzu App Accelerator for Vscode](https://marketplace.visualstudio.com/items?itemName=vmware.tanzu-app-accelerator)

2. In a column on the right side of the screen, under **Resources**, click the
**Download Extension** link. 

    A file called `vmware.tanzu-dev-tools-${version}.vsix` is downloaded. 

3. Save the file to a location that is accessible from your air-gapped environment. For example, a USB drive.

4. Repeat these steps for all extensions you want to install, including any dependencies.

    For example, Tanzu Developer Tools for VS Code requires all of the following extensions as dependencies:

    - [Red Hat Java](https://marketplace.visualstudio.com/items?itemName=redhat.java)
    - [Red Hat Yaml](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml)
    - [Debugger for Java](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-debug)

    The Application Accelerator extension, on the other hand, does not require additional dependencies.

5. In your air-gapped environment, install VS Code extensions as follows:

    1. Open VS Code
    2. Open the command palette by pressing CTRL-SHIFT-P or CMD-SHIFT-P on Mac.
    3. In the search box, type **vsix** and select **Install from VSIX...**.

    You can script this step by using commands such as:

    ```console
    code --install-extension ${path_to_vsix_file}
    ```

## <a id="intellij"></a> Install IntelliJ in your air-gapped environment

Follow these steps to retrieve the `.zip` archive and install IntelliJ in your air-gapped environment:

1. Find the extension you want to install on [Jetbrains Marketplace](https://plugins.jetbrains.com/). 
For example, [Tanzu Developer Tools for IntelliJ](https://plugins.jetbrains.com/plugin/21823-tanzu-developer-tools).

2. Click **Get** near the top-right of the screen.

3. Find the version you want to download and click the **Download** link. 

    A file called `Tanzu_Developer_Tools-${version}.zip` is downloaded. 

4. Save the file to a location that is accessible from your air-gapped environment. For example, a USB drive.

5. Repeat these steps for all extensions you want to install.

6. Follow the instructions in the [IntelliJ documentation](https://www.jetbrains.com/help/idea/managing-plugins.html#install_plugin_from_disk) to install IntelliJ.

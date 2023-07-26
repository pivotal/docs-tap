# Use the Application Accelerator Visual Studio Code extension

This topic describes how to use the Application Accelerator Visual Studio Code extension to explore
and generate projects from the defined accelerators in Tanzu Application Platform (commonly known as TAP) using VS Code.

The Application Accelerator Visual Studio Code extension lets you explore and generate projects
from the defined accelerators in Tanzu Application Platform using VS Code.

## <a id="dependencies"></a> Dependencies

To use the VS Code extension, you must interact with the `acc-server`. For more
information, see [How to expose this server follow the instructions](../cli-plugins/accelerator/overview.md#server-api-connections).

## <a id="vs-code-app-accel-install"></a> Installation

Use the following steps to install the Application Accelerator Visual Studio extension:

1. Sign in to VMware Tanzu Network and download the "Tanzu App Accelerator Extension for Visual Studio Code" file from the product page for [VMware Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform).

2. Open VS Code.

    **Option 1:**

    1. From the Command Palette (cmd + shift + P), run "Extensions: Install from VSIX...".

    2. Select the extension file **tanzu-app-accelerator-0.1.2.vsix**.

        ![The Command palette is open and Extensions: Install from VSIX appears in the drop-down menu.](../images/vscode-install1.png).

    **Option 2:**

    3. Select the **Extensions** tab: ![The extensions tab icon, which is a square cut in fourths with the top right fourth moved diagnally away from the other three.](../images/vscode-install2.png).

    4. Select `Install from VSIX…` from the overflow menu.

        ![The VS Code interface extensions page overflow menu is open with Install from VSIX... highlighted.](../images/vscode-install3.png).

## <a id="configure-the-extention"></a> Configure the extension

Before using the extension, you need follow the next steps:

1. Go to VS Code settings - click **Code > Preferences > Settings > Extensions > Tanzu App Accelerator**.

2. Look for the setting `Acc Server Url`.

3. Add the `acc-server` URL.

   ![The Server Configure Setting page is open with the acc server URL highlighted](../images/acc-server-config.png)

## <a id="using-the-extension"></a> Using the extension

After adding the `acc-server` URL you can explore the defined accelerators
accessing the new added icon:

![The explorer panel is open, the TIMELINE drop-down is selected, and the Demo Types icon is highlighted.](../images/app-accelerators-vscode-icon.png)

Choose any of the defined accelerators, fill the options and click  the `generate project`

![The accelerator tab is open to the Hello Fun accelerator form. The text boxes display example text and the Generate Project button is highlighted.](../images/acc-form.png)

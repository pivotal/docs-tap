# Application Accelerator Visual Studio Code extension
The application Accelerator Visual Studio Code extension lets you explore and generate projects 
from the defined accelerators in Tanzu Application Platform using VSCode. 

# Dependencies
To use the vscode extension, you need to interact with the `acc-server`, for more 
information on how to expose this server follow the instructions [here](./acc-cli.md#server-api-connections)

# <a id="vs-code-app-accel-install"></a> Installation

1. Download Tanzu App Accelerator Extension for Visual Studio Code from the Tanzu Network

2. Open VS Code.

    **Option 1:**
     
    1. From the Command Palette (cmd + shift + P), run "Extensions: Install from VSIX...".
    
    2. Select the extension file **tanzu-app-accelerator-0.1.1.vsix**.
    
    ![Command palette open showing text Extensions: INSTALL FROM VSIX...](../images/vscode-install1.png)
    
    **Option 2:**
    
    1. Select the **Extensions** tab: ![The extensions tab icon which is a square cut in fourths with the top-right fourth moved away from the other three](../images/vscode-install2.png)
    
    2. Select `Install from VSIX…` from the overflow menu.
    
    ![The VS Code interface showing the extensions tab open, the overflow menu in the extensions tab open, and the "Install from VSIX..." option highlighted](../images/vscode-install3.png)

# Configure the extension 

Before using the extension, you need follow the next steps:

1. go to VSCode settings

2. look for the setting `Acc Server Url`    

3. Add the `acc-server` URL

![Setting](../images/acc-server-config.png)

# Using the extension

After adding the `acc-server` URL you should be able to explore the defined accelerators
accessing the new added icon:

![extension](../images/app-accelerators-vscode-icon.png)

Choose any of the defined accelerators, fill the options and click on the `generate project`

![accelerator](../images/acc-form.png)
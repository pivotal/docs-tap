# Airgapped installation of IDE extensions

To install Vscode or IntelliJ extensions in an 'air-gapped' environment you cannot rely on 
IDE's built-in UI which downloads and install extensions directly from the Vscode or IntelliJ 
marketplace.

Instead you will need to do this in several separate steps:

1. Outside the airgapped environment: 
  download the extensions as an archice from the respective marketplace (Vscode/IntelliJ)
  and copy them somewhere that is accessible from within the airgapped environment.
2. In the airgapped environment: Install the extension into the IDE using the archives from step 1.

Both Vscode and IntelliJ provide the means to do this, but the details differ slightly.

## Vscode

### Getting the `.vsix` archives

Find the extension you want to install on the Vscode marketplace. For example: 

- [Tanzu Developer Tools for Vscode](https://marketplace.visualstudio.com/items?itemName=vmware.tanzu-dev-tools)
- [Tanzu App Accelerator for Vscode](https://marketplace.visualstudio.com/items?itemName=vmware.tanzu-app-accelerator)

In a column on the right side of the screen, under "Resources", click on the
"Download Extension" link. A file called `vmware.tanzu-dev-tools-${version}.vsix` is downloaded. 
Save the file somewhere that can be made accessible to your airgapped environment (e.g. a USB drive).

You will need to repeat these steps for all extensions you want to install, **including any dependencies**.

Specifically, for *Tanzu Developer Tools* you will need all of the following extensions as dependencies:

- [Red Hat Java](https://marketplace.visualstudio.com/items?itemName=redhat.java)
- [Red Hat Yaml](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml)
- [Debugger for Java](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-debug)

The Application Accelerator extension on the other hand does not require additional dependencies.

### Installing 

Inside the air-gapped environment you can install vscode extensions as follows:

- Open Vscode
- Open the command palette (CTRL-SHIFT-P or CMD-SHIFT-P on Mac).
- In the Search box type "vsix" and select "Install from VSIX..."

It is possible to 'script' this step of the process using commands like:

```
code --install-extension ${path_to_vsix_file}
```

## IntelliJ

### Getting the `.zip` archive

Find the extension you want to install on the [Jetbrains marketplace](https://plugins.jetbrains.com/). For example, 
[Tanzu Developer Tools for IntelliJ](https://plugins.jetbrains.com/plugin/21823-tanzu-developer-tools).

Click the "Get" button near top-right of the screen.

Find the version you want to download (probably the latest) and click the "Download" link next to it. A file called `Tanzu_Developer_Tools-${version}.zip` is downloaded. Save the file to somewhere that can be made accessible to your
airgapped environment (e.g. a USB drive).

You will need to repeat these steps for all extensions you want to install.

### Installing

Follow the instructions in the IntelliJ documentation on [Installing plugin from Disk](https://www.jetbrains.com/help/idea/managing-plugins.html#install_plugin_from_disk).
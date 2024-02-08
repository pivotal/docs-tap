# Using a local Application Accelerator engine server

This topic tells you how to run a local Application Accelerator engine server that can be used for testing accelerators that you are authoring and actively working on.

## <a id="accel-local-engine-server"></a>Running a local engine server

When you are authoring your accelerator, it is convenient to be able to generate a project based on the local files so you can verify that the accelerator provides the defined options and that it generates the correct set of files.

With the local engine server, you can serve your accelerators with their fragments on `localhost`, including any changes you have locally, and use the VS Code "Tanzu App Accelerator" extension or the Tanzu CLI Accelerator plugin to generate new projects based on these local files. 

Once you are happy with the new or modifed accelerators and fragments you can commit them to a Git repository and then publish them to a cluster to give others access to them.

### <a id="install-local-engine-server"></a>Install the local engine server

Sign in to [VMware Tanzu Network](https://network.tanzu.vmware.com/) then go to the [Tanzu Application Platform product page](https://network.tanzu.vmware.com/products/tanzu-application-platform) and select your TAP version.

There is a file group named `Application Accelerator Engine Server-v1.8.1` that contains four different ZIP archives, one for each of `macos-aarch64`, `macos-amd64`, `windows` and `linux`. Download the one that matches you OS and architecture.

The ZIP file contains the local engine server and a Java runtime for running the server. Extract it to a local directory, eith using the `unzip` command or any other extraction tool.

>**Note** For macOS users we need to do the following steps in order to open an app from an unidentified developer:
>(We are working on having these artifacts signed using an Apple developer account to avoid these extra steps)
>
>In the Finder on your Mac, locate the directory where you extracted the downloaded ZIP file and expand the "acc-engine" directory.
>
>  We need to "control-open" the following files:
>  - control-click `acc-engine/app/bin/ytt` and then click Open. This will run it in a terminal that you can close.
>  - control-click `acc-engine/app/bin/java` and then click Open. This will run it in a terminal that you can close.
>
> The above app files are saved as exceptions to your security settings.
> You can now run them without getting a verification message.

Open a terminal window and change directory to `acc-engine` located inside the directory where you extracted the ZIP file.

You need to set an `ACC_LOCAL_FILES` env var pointing to a directory that contains the fragments and accelerators that you are working on and want to use with the local engine server. There needs to be a directory named `accelerators` and one named `fragments`. Under these directories you can provide your local accelerators and fragments.

      workspace
      ├── accelerators
      │   └── hello-world
      │       ├── ...
      └── fragments
          ├── build-wrapper-maven
          │   ├── ...
          ├── java-version
          │   ├── ...

For macOS and Linux you can set this env var using a command like this:

    export ACC_LOCAL_FILES="$HOME/workspace"

For Windows Powershell you can set this env var using a command like this:

    $Env:ACC_LOCAL_FILES="$HOME\workspace"

Once this has been prepared, we can start the local engine server using the `engine` script from the terminal.

    ./engine

### <a id="use-local-engine-server"></a>Use the local engine server to generate projects

The latest versions of the VS Code Tanzu "App Accelerator" extension and the Tanzu CLI Accelerator plugin now has settings to use the local engine server instead of the regular cluster endpoints.

For the VS Code "Tanzu App Accelerator" extension there is a new setting under "Tanzu Application Accelerator".
Look for the checkbox that says "Use Local Server instead of Developer Portal". If you check that box, then the plugin will show available accelerators from the local engine server you started above. They can be used the same way that you use accelerators loaded from the Developer Portal.

For the Tanzu CLI Accelerator plugin, the "list", "get" and generate commands now have a `--local-server` flag to use instead of the `--server-url` one.

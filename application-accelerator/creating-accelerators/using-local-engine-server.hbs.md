# Use a local Application Accelerator engine server

This topic tells you how to run a local Application Accelerator engine server that you can use for
testing accelerators that you are authoring.

## <a id="overview"></a> About running a local engine server

When you are authoring your accelerator, you might want to generate a project based on the local files.
This is so you can verify that the accelerator provides the defined options and that it generates
the correct set of files.

With the local engine server, you can serve your accelerators with their fragments on `localhost`,
including any changes you have locally, and use the VS Code Tanzu App Accelerator extension or the
Tanzu CLI Accelerator plug-in to generate new projects based on these local files.

After you are happy with the new or modified accelerators and fragments, you can commit them to a Git
repository and then publish them to a cluster to give others access to them.

## <a id="install-local-engine-server"></a>Install the local engine server

To install the local engine server:

1. Sign in to [VMware Tanzu Network](https://network.tanzu.vmware.com/).

1. Go to the [Tanzu Application Platform product page](https://network.tanzu.vmware.com/products/tanzu-application-platform).

1. Select your Tanzu Application Platform version from the release drop-down menu.

1. From the list of resources, select the file group named `Application Accelerator Engine Server-v1.8.1`.
   It contains four different ZIP archives,
  `macos-aarch64`, `macos-amd64`, `windows`, and `linux`. Download the ZIP file for your operating
  system and architecture.

  The ZIP file contains the local engine server and a Java runtime for
  running the server.

1. Extract the ZIP file to a local directory, by using the `unzip` command or any other extraction tool.

1. For macOS users, you must do the following steps to open an app from an unidentified developer:

    > **Note** VMware plans to have these artifacts signed using an Apple developer account
    to avoid these extra steps.

    1. In the Finder on your Mac, locate the directory where you extracted the downloaded ZIP file
       and expand the `acc-engine` directory.

    1. Control-open the following files:

        - Control-click `acc-engine/app/bin/ytt` and then click **Open**. This runs it in a terminal
        that you can close.

        - Control-click `acc-engine/app/bin/java` and then click **Open**. This runs it in a terminal
        that you can close.

        The app files you control-opened are saved as exceptions to your security settings.
        You can now run them without getting a verification message.

1. Open a terminal window and change directory to `acc-engine` located inside the directory where
   you extracted the ZIP file.

1. Set an `ACC_LOCAL_FILES` environment variable pointing to a directory that contains the fragments
   and accelerators that you are working on and want to use with the local engine server.
   There must be a directory named `accelerators` and one named `fragments`.
   Under these directories you can provide your local accelerators and fragments.

    ```
      workspace
      ├── accelerators
      │   └── hello-world
      │       ├── ...
      └── fragments
          ├── build-wrapper-maven
          │   ├── ...
          ├── java-version
          │   ├── ...
    ```

    - For macOS and Linux you can set this environment variable by running, for example:

        ```console
        export ACC_LOCAL_FILES="$HOME/workspace"
        ```

    - For Windows Powershell you can set this environment variable by running, for example:

        ```console
        $Env:ACC_LOCAL_FILES="$HOME\workspace"
        ```

1. Start the local engine server using the `engine` script from the terminal by running:

    ```console
    ./engine
    ```

## <a id="use-local-engine-server"></a>Use the local engine server to generate projects

The latest versions of the VS Code Tanzu App Accelerator extension and the Tanzu CLI Accelerator plug-in
has settings to use the local engine server instead of the regular cluster endpoints.

For the VS Code Tanzu App Accelerator extension there is a new setting under
**Tanzu Application Accelerator**.
If you select the **Use Local Server instead of Developer Portal"** check box,
the plug-in shows available accelerators from the local engine server you started in
[Install the local engine server](#install-local-engine-server).
You can use them in the same way that you use accelerators loaded from the Developer Portal.

For the Tanzu CLI Accelerator plug-in, the `list`, `get`, and `generate` commands now have a
`--local-server` flag to use instead of the `--server-url` one.

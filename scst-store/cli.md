# Install the CLI

This topic explains how to install the `insight` CLI:

1. Sign in to [Tanzu Network](https://network.tanzu.vmware.com/).
1. Navigate to [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/). 
1. Select the TAP release. In the list of released files, select *insight-metadata-cli-v1.0.0-beta0*. 
1. Choose the file for your operating system. 
    >**Note:** MacOS is a Darwin-based platform.

1. Put the binary in a location that is either already in your `PATH` environment variable, 
or add the location of the CLI to your `PATH` variable.
1. Rename the binary to make it easier to invoke with your command line. 
For example, `mv insight-1.0.0-alpha_darwin insight`.

<details><summary>MacOS only:</summary>
<br/>

MacOS does not recognize that the insight binary is safe to run because it has not been signed by Apple. To allow your computer to run the binary, perform the following steps:

1. In the command line, run: 

    ```
    insight version
    ```
    A pop-up appears to notify you that the program is not trusted.

1. Open **System Preferences** > **Security & Privacy** > **General**.
1. Under **Allow apps identified from**, make sure the **App store and identified developers** radio button is selected.
1. Re-run the insight binary until an **Allow** button appears under the **Allow apps identified from** section, and then click **Allow**.
</details>
<br>
<br>
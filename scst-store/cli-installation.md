# CLI installation

>**Note:** The `insight` CLI is in beta and is separate from the `tanzu` CLI.
>It works with Tanzu Application Platform v1.0.0.

This topic explains how to install the `insight` CLI.

1. Log in to [Tanzu Network](https://network.tanzu.vmware.com/) on your browser.
1. Search for and select [Supply Chain Security Tools for VMware Tanzu](https://network.tanzu.vmware.com/products/supply-chain-security-tools).
1. Choose the file for your operating system.
    
    >**Note:** macOS is a Darwin-based platform.
    
1. Put the binary in a location that is either already in your `PATH` environment variable,
or add the location of the CLI to your `PATH` variable.
1. Rename the binary to make it easier to invoke with your command line.
For example, `mv insight-1.0.1_darwin_amd64 insight`.

<details><summary>macOS only:</summary>
<br/>

macOS does not recognize that the insight binary is safe to run because Apple has not signed it. To allow your computer to run the binary, perform the following steps:

1. In the command line, run:

    ```
    insight version
    ```
    A pop-up appears to notify you that the program is not trusted.

1. Open **System Preferences** > **Security & Privacy** > **General**.
1. Under **Allow apps identified from**, ensure the **App store and identified developers** radio button is selected.
1. Re-run the insight binary until an **Allow** button appears under the **Allow apps identified from** section, and then click **Allow**.
</details>
<br>
<br>

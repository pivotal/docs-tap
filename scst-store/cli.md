# CLI

The Supply Chain Security Tools - Store CLI, called `insight`, allows you to query the store. 
With the Command Line Interface (CLI), you can query for information about images, packages, and vulnerabilities that have been submitted to the store.

## Installing the CLI

To install the CLI:

1. Sign in to [Tanzu Network](https://network.tanzu.vmware.com/).
2. Navigate to [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/). 
3. Select the TAP release. In the list of released files, select *insight-metadata-cli-v1.0.0-beta0*. 
4. Choose the file for your operating system. 
    >**Note:** MacOS is a Darwin-based platform.
  
5. Put the binary in a location that is either already in your `PATH` environment variable, 
or add the location of the CLI to your `PATH` variable.
6. Rename the binary to make it easier to invoke with your command line. 
For example, `mv insight-1.0.0-alpha_darwin insight`.

<details><summary>MacOS only:</summary>
<br/>
MacOS does not recognize that the insight binary is safe to run because it has not been signed by Apple. 

To allow your computer to run the binary, perform the following steps:

1. In the command line, run: 
    ```
    insight version
    ```
    A pop-up appears to notify you that the program is not trusted.
3. Open **System Preferences** > **Security & Privacy** > **General**.
5. Under **Allow apps identified from**, make sure the **App store and identified developers** radio button is selected.
6. Re-run the insight binary until an **Allow** button appears under the **Allow apps identified from** section, and then click **Allow**.
</details>
<br>
<br>

# Setup
To set up the CLI:

Be sure to have the prerequisites from [Using Supply Chain Security Tools - Store](using_metadata_store.md#prerequisites):
* [Enable an encrypted connection to the store](enable_encrypted_connection.md)
* [Create a user and get an access token](create_service_account_access_token.md)
* [Configure the CLI](configure_cli.md)

# Usage

See [Using Supply Chain Security Tools - Store](using_metadata_store.md#getting-started) for different ways to incorporate the CLI into a workflow.

After the setup, you should be able to run use the CLI and get information that is stored in the database. Use `--help` option to get the available commands.

For examples, see the files in the docs folder, starting with the [`insight` commands](cli_docs/insight.md).

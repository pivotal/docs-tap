# CLI

The SCST - Store CLI, called `insight`, is the easiest way to query the store. With the CLI, you can query for information about images, packages, and vulnerabilities that's been submitted to the store.

## Installation

1. Go to Tanzu Network and find the [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/). Select the release of TAP you're using. In the list of released files, select *insight-metadata-cli-v1.0.0-beta0*. Then choose the file for the operating system platform you're targetting. Note: MacOS is a Darwin-based platform.
2. Put the binary in a location that is either already in your PATH environment variable, OR add the location of the CLI to your PATH variable.
3. Rename the binary to make it easier to invoke via command line, e.g. `mv insight-1.0.0-alpha_darwin insight`.

<details><summary>MacOS only:</summary>
<br/>
MacOS will not recognize that the insight binary is safe to run because it hasn't been signed by Apple. To allow your computer to run it anyways, perform the following steps:

1. Invoke the insight binary from the command line, e.g. `insight version`
2. A pop-up will appear notifying you that the program is not trusted
3. Open the System Preferences 'settings' 
4. Go to 'Security and Privacy' -> 'General' tab
5. Under the 'Allow apps identified from', make sure the 'App store and other identified developers' radio button is selected
6. re-run the insight binary until an 'Allow' button appears under the 'Allow apps identified from' section, then click 'Allow'
</details>

# Setup

* [Enable an encrypted connection to the store](enable_encrypted_connection.md)
* [Create a user and get an access token](create_service_account_access_token.md)
* [Configure the CLI](configure_cli.md)

# Usage

See [Using Supply Chain Security Tools - Store](using_metadata_store.md)

After the setup, you should be able to run use the CLI and get information that is stored in the database. Use `--help` option to get the available commands.

For examples, see the files in the docs folder, starting with the [`insight` commands](cli_docs/insight.md).

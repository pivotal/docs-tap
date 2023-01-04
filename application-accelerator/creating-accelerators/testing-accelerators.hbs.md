# Testing accelerators

This topic describes how to test an updated accelerator (or fragment) that is not yet registered in your TAP cluster.

## <a id="testing-accelerators-rapid-iteration"></a>Generating a project from local sources
As you are authoring an accelerator, you may wish to try out your accelerator before committing any changes you've made.

With the `tanzu accelerator generate-from-local` command you can run your accelerator (or
fragment), including any changes you have locally, specify a set of options and view the
generated project.

You can run the accelerator using the components on your TAP cluster, without impacting the state of the TAP cluster.

To do so ensure you have the following prerequisites on your machine:

  - The Tanzu CLI is installed, with the Application Accelerator plugin. For details on installing the Tanzu CLI and plugins, see [Tanzu CLI](../../cli-plugins/tanzu-cli.md)
  - The server URL is pointing to the TAP cluster you want to test with. For details on setting the server URL, see [Application Accelerator CLI plug-in overview](../../cli-plugins/accelerator/overview.md)

> *Note:* No changes will be made to the TAP cluster that is provided via the server URL.
> No new accelerators/fragments will be registered or modified. A TAP cluster is
> required in order to ensure consistency between the version that is used for testing
> and the version that is used when the accelerator is registered. Furthermore, it allows
> using registered fragments and accelerators as dependencies for the local accelerator/fragment.

For example, to use the accelerator that is located at the path `workspace/java-rest` your command will look something like:

```console
tanzu accelerator generate-from-local --accelerator-path java-rest=workspace/java-rest --fragment-names tap-workload,java-version --options '{"projectName":"test"}' --output-dir generated-project
```

This will generate the project in the local directory `generated-project`, using the
accelerator located at `workspace/java-rest`, the fragments `tap-workload` and
`java-version` which are assumed to be already registered in the TAP cluster and the
option `projectName` set to `test`.

To instead use the fragment named `java-version` that is located at the path `workspace/version` your command will look something like:

```console
tanzu accelerator generate-from-local --accelerator-name java-rest --fragment-paths java-version=workspace/version --fragment-names tap-workload --options '{"projectName":"test"}' --output-dir generated-project
```

This will generate the project in the local directory `generated-project` on your machine,
using the accelerator `java-rest` and the fragment `tap-workload` which are assumed to be
already registered in the TAP cluster, the fragment named `java-version` located at
`workspace/version` on your machine and the option `projectName` set to `test`.

<!-- For the full documentation for the `generate-from-local` command see the reference [tanzu accelerator generate-from-local](../../cli-plugins/accelerator/command-reference/tanzu_accelerator_generate.hbs.md). Commented out because this xref does not exist and I cannot find any generate-from-local content to reference. -->

## <a id="creating-accelerators-ci-cd-pipeline"></a>CI/CD Pipeline
As you iterate on an accelerator, you may wish to have some automated assertions that run before any changes to the accelerator are accepted.

The process for generating a project from the committed source files is the same as described above.

Once the generated project is available, you can run various assertions on it:
```console
cd generated-project
test -f build.gradle
./gradlew test
```

If you have multiple assertions, you may choose to run a pre-defined script:
```console
cd generated-project
../assertions/validate-generate-project.sh
```

You may choose to generate multiple projects from the same accelerator, providing different
options for each and running different assertions on each generated project.

### <a id="tanzu-cli-in-ci-cd"></a>Getting the Tanzu CLI in a CI/CD pipeline

If the Tanzu CLI is already available in your CI/CD pipeline you can skip this section.

We provide an example script that is agnostic to the CI/CD system it is running on.
The script below requires a variable named `TANZU_REFRESH_TOKEN` which holds a personal
Tanzu Network refresh token. To generate such a token see
[How to Authenticate](https://network.tanzu.vmware.com/docs/api#how-to-authenticate).
The script also uses `curl` and `jq`.

The script below downloads artifacts compatible with TAP version 1.3 and a Linux operating
system. Update the script to suit the TAP version and OS that you are using.

```bash
#!/bin/bash

# Get access token using personal Tanzu Network refresh token
# See https://network.tanzu.vmware.com/docs/api#how-to-authenticate
ACCESS_TOKEN=$(curl -X POST https://network.tanzu.vmware.com/api/v2/authentication/access_tokens -d '{"refresh_token":"'"$TANZU_REFRESH_TOKEN"'"}' | jq -r ".access_token")

# Download bundle
# See https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.3/tap/GUID-install-tanzu-cli.html#cli-plugin-install
# Update url to download desired version
mkdir -p $HOME/tanzu
curl -L -X GET https://network.tanzu.vmware.com/api/v2/products/tanzu-application-platform/releases/1205491/product_files/1352407/download -H "Authorization: Bearer $ACCESS_TOKEN" --output bundle.tar

# Unpack bundle
export TANZU_CLI_NO_INIT=true
export VERSION=v0.25.0 # Update to desired version
tar -xvf bundle.tar -C $HOME/tanzu
cd $HOME/tanzu

# Install CLI
# Update to use desired OS
sudo install cli/core/$VERSION/tanzu-core-linux_amd64 /usr/local/bin/tanzu

# Install plugins
tanzu plugin install --local cli accelerator
```

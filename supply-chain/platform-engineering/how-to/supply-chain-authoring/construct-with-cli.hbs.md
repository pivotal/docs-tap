# Construct a Supply Chain using the Tanzu CLI

This topic tells you how to construct a SupplyChain resource by using the
Tanzu Supply Chain CLI plug-in.

{{> 'partials/supply-chain/beta-banner' }}

## Prerequisites

1. Ensure that the [Tanzu CLI](../../../../install-tanzu-cli.hbs.md#install-tanzu-cli), and [Tanzu Supply Chain CLI plug-in](../../../platform-engineering/how-to/install-the-cli.hbs.md) are installed on your local machine.

2. Ensure that Tanzu Supply Chain packages and Catalog Component packages are installed on the Tanzu Application Platform cluster that you are using to author your first supply chain.
<br>
- If you [Install Tanzu Supply Chain with the authoring profile (recommended)](../../how-to/installing-supply-chain/install-authoring-profile.hbs.md), these packages are automatically installed.
- If you [Install Tanzu Supply Chain manually (not recommended)](../../how-to/installing-supply-chain/installing-manually.hbs.md), you must install the packages individually.

## SupplyChain authoring

Deploy SupplyChain authoring resources such as `SupplyChain`, `Component`, and the Tekton `Pipeline`/`Task` to clusters through a Git repository by using the GitOps source promotion methodology.

For a Platform Engineer, the recommended approach is:

- Author the `SupplyChain` by using a set of YAML files within a Git-backed file system.
- Test and debug by pushing all files to a single namespace on the `authoring` profile cluster.
- When you are satisfied with the new or modified `SupplyChain`, use a pull request to commit to Git.

Managing a potentially large number of YAML manifests manually can be error-prone.
Platform Engineers can use the Tanzu Supplychain CLI plug-in to streamline the authoring
process for `SupplyChains` tailored to their developers.

### Initialize the local directory

First use the `tanzu supplychain init` command to initialize the local directory for the `tanzu supplychain generate` command. Run:

```console
tanzu supplychain init --group supplychains.tanzu.vmware.com --description "MY-SUPPLYCHAIN-GROUP"
```

Where

- `--group`: (Optional) Group of the supplychains. The default is `supplychains.tanzu.vmware.com`.
Used for auto-populating `spec.defines.group` of the [SupplyChain API](../../../reference/api/supplychain.hbs.md#specdefinesgroup).
- `--description`: (Optional) Description of the Group. The default is "".

The `tanzu supplychain init` command creates:

- `config.yaml` file that contains the information about the group name, and the description of the Supplychain group.
- `supplychains`, `components`, `pipelines`, and `tasks` directories which are auto-populated by the authoring wizard later in this tutorial.
- `Makefile` which has the targets to install or uninstall the SupplyChain and related dependencies on any Build or Full profile clusters.
- `README.md` file which has instructions on how to use the targets in the `Makefile`.

>**Important** After being set up with the designated `group`, the local directory becomes a hub
for shipping one or more `SupplyChains`. Within this local directory, every `SupplyChain` 
shares the same `group`, and this group information is stored in the `config.yaml` file.
Conversely, in your GitOps repository, multiple directories can exist, each initialized with distinct
groups such as `hr.supplychains.company.biz`, `finance.supplychains.company.biz`, and so on. Each of
these directories is capable of accommodating multiple `SupplyChains` tailored to their respective groups.

Example output from `tanzu supplychain init` command:

```console
Initializing group supplychains.tanzu.vmware.com
Creating directory structure
 ├─ supplychains/
 ├─ components/
 ├─ pipelines/
 ├─ tasks/
 ├─ Makefile
 ├─ README.md
 └─ config.yaml

Writing group configuration to config.yaml
```

### Inspecting Components available to author Supply Chains

1. As a Platform Engineer, you want to know which components are available  to use in your SupplyChain.
Run:

    ```console
    tanzu supplychain component list
    ```

    Example output

    ```console
    Listing components from the catalog
      NAME                             INPUTS                                                        OUTPUTS                                                       AGE
      app-config-server-1.0.0          conventions[conventions]                                      oci-yaml-files[oci-yaml-files], oci-ytt-files[oci-ytt-files]  14d
      app-config-web-1.0.0             conventions[conventions]                                      oci-yaml-files[oci-yaml-files], oci-ytt-files[oci-ytt-files]  14d
      app-config-worker-1.0.0          conventions[conventions]                                      oci-yaml-files[oci-yaml-files], oci-ytt-files[oci-ytt-files]  14d
      carvel-package-1.0.0             oci-yaml-files[oci-yaml-files], oci-ytt-files[oci-ytt-files]  package[package]                                              14d
      deployer-1.0.0                   package[package]                                              <none>                                                        14d
      source-package-translator-1.0.0  source[source]                                                package[package]                                              14d
      conventions-1.0.0                image[image]                                                  conventions[conventions]                                      14d
      app-config-web-1.0.0             conventions[conventions]                                      oci-yaml-files[oci-yaml-files], oci-ytt-files[oci-ytt-files]  14d
      git-writer-1.0.0                 package[package]                                              <none>                                                        14d
      git-writer-pr-1.0.0              package[package]                                              git-pr[git-pr]                                                14d
      source-git-provider-1.0.0        <none>                                                        source[source], git[git]                                      14d
      buildpack-build-1.0.0            source[source], git[git]                                      image[image]                                                  14d
      trivy-image-scan-1.0.0           image[image], git[git]                                        <none>                                                        14d

    🔎 To view the details of a component, use 'tanzu supplychain component get'
    ```

    Use the `-w/--wide` flag to see a more detailed output including a
    description of each component.

    >**Important** The `tanzu supplychain component list` command scans for `Component` custom resources
    labeled with `supply-chain.apps.tanzu.vmware.com/catalog`. Those `Component` custom resources
    possessing this label are the ones taken into account for authoring `SupplyChains` with the Tanzu
    CLI. Notably, the `Components` installed during the SupplyChain installation lack this label.
    This labeling distinction serves as the basis for differentiating between "Cataloged" and "Installed" `Components` in the CLI.

1. To get more information about each component on the cluster, run the `tanzu supplychain component get` command. For example, to get information about the `source-git-provider` component, run:

    ```console
    tanzu supplychain component get source-git-provider-1.0.0 -n source-provider --show-details
    ```

    Example output

    ```console
    📡 Overview
      name:         source-git-provider-1.0.0
      namespace:    source-provider
      age:          14d
      status:       True
      reason:       Ready
      description:  Monitors a git repository

    📝 Configuration
      source:
        #! Use this object to retrieve source from a git repository.
        #! The tag, commit, and branch fields are mutually exclusive, use only one.
        #! Required
        git:
          #! A git branch ref to watch for new source
          branch: "main"
          #! A git commit sha to use
          commit: ""
          #! A git tag ref to watch for new source
          tag: "v1.0.0"
          #! The url to the git source repository
          #! Required
          url: "https://github.com/acme/my-workload.git"
        #! The sub path in the bundle to locate source code
        subPath: ""

    📤 Outputs
      git
        ├─ digest: $(resumptions.check-source.results.sha)
        ├─ type: git
        └─ url: $(resumptions.check-source.results.url)
      source
        ├─ digest: $(pipeline.results.digest)
        ├─ type: source
        └─ url: $(pipeline.results.url)

    🏃 Pipeline
        ├─ name: source-git-provider
        └─ 📋 parameters
          ├─ git-url: $(workload.spec.source.git.url)
          ├─ sha: $(resumptions.check-source.results.sha)
          └─ workload-name: $(workload.metadata.name)

    🔁 Resumptions
      - check-source runs source-git-check task every 300s
        📋 Parameters
          ├─ git-branch: $(workload.spec.source.git.branch)
          ├─ git-commit: $(workload.spec.source.git.commit)
          ├─ git-tag: $(workload.spec.source.git.tag)
          └─ git-url: $(workload.spec.source.git.url)

    🔎 To generate a supplychain using the available components, use 'tanzu supplychain generate'

    ```

## Generate the SupplyChain

The Tanzu Supply Chain CLI plug-in supports two modes of operation for generating SupplyChains.

- Interactive: Use a guided wizard.
- Non-Interactive: Use flags.

Interactive
: Start the wizard:

    ```console
    tanzu supplychain generate
    ```

    The wizard prompts for the following:

    |**Prompt**|**Example value**|
    |:--|:--|
    |What Kind would you like to use as the developer interface?|`AppBuildV1` (This value is used for auto-populating the `spec.defines` section of the [SupplyChain API](../../../reference/api/supplychain.hbs.md))|
    |Give Supply chain a description?|`Supply chain that pulls the source code from Git repository, builds it using buildpacks and package the output as Carvel package.`|
    |Select a component as the first stage of the supply chain?|`source-git-provider-1.0.0`|
    |Select a component as the first stage of the supply chain?|`buildpack-build-1.0.0`|
    |Select a component as the first stage of the supply chain?|`conventions-1.0.0`|
    |Select a component as the first stage of the supply chain?|`app-config-server-1.0.0`|
    |Select a component as the first stage of the supply chain?|`carvel-package-1.0.0`|
    |Select a component as the first stage of the supply chain?|`git-writer-pr-1.0.0`|
    |Select a component as the first stage of the supply chain?|`Done`|

    The Tanzu Supply Chain CLI knows what stages are already part of the SupplyChain and removes
    them from the list of stages to add.

Non-interactive
: Generate the Supply chain by using flags:

    ```console
    tanzu supplychain generate \
    --kind AppBuildV1 \
    --description "Supply chain that pulls the source code from git repo, builds it using buildpacks and package the output as Carvel package." \
    --component "source-git-provider-1.0.0" \
    --component "buildpack-build-1.0.0" \
    --component "conventions-1.0.0" \
    --component "app-config-server-1.0.0" \
    --component "carvel-package-1.0.0" \
    --component "git-writer-pr-1.0.0"
    ```

When you have selected the components, the Tanzu Supply Chain CLI plug-in creates
the required files to deploy your SupplyChain in the current directory

For example:

```console
✓ Successfully fetched all component dependencies
Created file supplychains/appbuildv1.yaml
Created file components/app-config-server-1.0.0.yaml
Created file components/buildpack-build-1.0.0.yaml
Created file components/carvel-package-1.0.0.yaml
Created file components/conventions-1.0.0.yaml
Created file components/git-writer-pr-1.0.0.yaml
Created file components/source-git-provider-1.0.0.yaml
Created file pipelines/app-config-server.yaml
Created file pipelines/buildpack-build.yaml
Created file pipelines/carvel-package.yaml
Created file pipelines/conventions.yaml
Created file pipelines/git-writer.yaml
Created file pipelines/source-git-provider.yaml
Created file tasks/calculate-digest.yaml
Created file tasks/carvel-package-git-clone.yaml
Created file tasks/carvel-package.yaml
Created file tasks/check-builders.yaml
Created file tasks/fetch-tgz-content-oci.yaml
Created file tasks/git-writer.yaml
Created file tasks/gitops-git-clone.yaml
Created file tasks/prepare-build.yaml
Created file tasks/source-git-check.yaml
Created file tasks/source-git-clone.yaml
Created file tasks/store-content-oci.yaml
```

## Enforce proper ordering of Components in the SupplyChain

Components have zero or more inputs and outputs. The inputs for a component must be
fulfilled by a preceding component in the SupplyChain. If not, there will be a component
at a stage in a SupplyChain that will not run.  Proper ordering is handled
differently depending on whether you are authoring using the interactive or non-interactive method.

Interactive
: 
  The entries that get populated for stage selection already take the ordering logic into account.
  The CLI only shows components for selection if the inputs for that component are already
  satisfied by another component in the SupplyChain.

Non-interactive
: 

  The SupplyChain returns an error if a
  component expects an input that has not been output by a previous stage. For example:

  ```console
  $ tanzu supplychain generate \
  --kind AppBuildV1 \
  --description "Supply chain that pulls the source code from Git repository, builds it using buildpacks and packages the output as Carvel package." \
  --component "buildpack-build-1.0.0" \
  --component "conventions-1.0.0" \
  --component "app-config-server-1.0.0" \
  --component "carvel-package-1.0.0" \
  --component "git-writer-pr-1.0.0"
  ```

  Example error output:

  ```console
  Error: unable to find the component buildpack-build-1.0.0 or the component buildpack-build-1.0.0 does not match expected input value
  ```

For detailed information about the API specification for
SupplyChain, see the [SupplyChain API](./../../../reference/api/supplychain.hbs.md) reference documentation.

## Ensure that your Components and Supply Chains adhere to version constraints

For information about versioning SupplyChains and Components to avoid delivery failures of your SupplyChain resources to your Build clusters, see [Supply Chains enforce immutability](./../../explanation/supply-chains.hbs.md#immutability).

## Reference Guides

### Out of the Box Catalog of Components

- [Catalog of Tanzu Supply Chain Components](./../../../reference/catalog/about.hbs.md)
- [Output Types for Catalog Components](./../../../reference/catalog/output-types.hbs.md)

### Reference Guides

- [Overview of SupplyChains](./../../explanation/supply-chains.hbs.md)
- [Overview of Components](./../../explanation/components.hbs.md)
- [Overview of Resumptions](./../../explanation/resumptions.hbs.md)
- [Overview of Workloads](./../../explanation/workloads.hbs.md)
- [Overview of WorkloadRuns](./../../explanation/workload-runs.hbs.md)

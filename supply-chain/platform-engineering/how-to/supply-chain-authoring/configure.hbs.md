# Configure a Supply Chain using the Tanzu CLI

This topic tells you how to construct a SupplyChain configuration.

{{> 'partials/supply-chain/beta-banner' }}

## Prerequisites

1. Ensure that the [Tanzu CLI](../../../../install-tanzu-cli.hbs.md#install-tanzu-cli), and [Tanzu Supply Chain CLI plug-in](../../../platform-engineering/how-to/install-the-cli.hbs.md) are installed on your local machine.

2. Ensure that Tanzu Supply Chain packages and Catalog Component packages are installed on the Tanzu Application Platform cluster that you are using to author your first supply chain.
<br>
- If you [Install Tanzu Supply Chain with the authoring profile (recommended)](../../how-to/installing-supply-chain/install-authoring-profile.hbs.md), these packages are automatically installed.
- If you [Install Tanzu Supply Chain manually (not recommended)](../../how-to/installing-supply-chain/installing-manually.hbs.md), you must install the packages individually.

## SupplyChain configuration

SupplyChains can be configured to supply default/override values to each component that is defined. 
This allows a Platform Engineer to either pre-populate common default values for a component or override values to always be some value which the developer cannot modify.

### Overrides

Allow the platform engineer to define values that **cannot** be changed by Developers using the `Workload` (Developer API).
By configuring overrides for each component in the SupplyChain, the generated `Workload` will **not** contain values that have been overriden.

**Example Use case:**

As a platform engineer, I want all built images to be accessible only via my organizations QA registry.

#### Generate SupplyChain with Overrides

Generate the Supply chain by supplying the `--allow-overrides` flag:

```console
tanzu supplychain generate \
    --kind AppBuildV1 \
    --description "Supply chain that pulls the source code from git repo, builds it using buildpacks and package the output as Carvel package." \
    --component "source-git-provider-1.0.0" \
    --component "buildpack-build-1.0.0" \
    --component "conventions-1.0.0" \
    --component "app-config-server-1.0.0" \
    --component "carvel-package-1.0.0" \
    --component "git-writer-pr-1.0.0" \
    --allow-overrides
```

The Tanzu Supply Chain CLI plug-in creates the required files to deploy your SupplyChain in the current directory:

```
✓ Successfully fetched all component dependencies
Created file supplychains/appbuildv1.yaml
...
```

To configure overrides, open `supplychains/appbuildv1.yaml` in your editor and navigate to the following section:

```
  ...
  config:
    overrides:
        # Platform Engineer provided registry overrides
        - path: spec.registry.repository
          value: "YOUR-REGISTRY-REPO"
        - path: spec.registry.server
          value: "YOUR-REGISTRY-SERVER"

        # Platform Engineer provided build overrides
        - path: spec.build.builder.kind
          value: clusterbuilder
        - path: spec.build.builder.name
          value: default
        - path: spec.build.cache.enabled
          value: false
        - path: spec.build.cache.image
          value: ""
        - path: spec.build.serviceAccountName
          value: default
        
        # Platform Engineer provided carvel package component overrides
        - path: spec.carvel.caCertData
          value: ""
        - path: spec.carvel.iaasAuthEnabled
          value: false
        - path: spec.carvel.packageDomain
          value: "default.tap"
        - path: spec.carvel.serviceAccountName
          value: "default"
        - path: spec.carvel.valuesSecretName
          value: ""

        # Platform Engineer provided GitOps repo overrides
        - path: spec.gitOps.baseBranch
          value: main
        - path: spec.gitOps.branch
          value: main
        - path: spec.gitOps.subPath
          value: "YOUR-GITOPS-REPO-SUBPATH"
        - path: spec.gitOps.url
          value: "YOUR-GITOPS-REPO-URL"
```

#### Configure overrides

Overrides consist of:

- `path`: path to the configuration value, formatted as either:
  1. The full path to the field you wish to set.
  2. The path to any structure where all desired child fields must be set.
- `value`: String or YAML structured value.

##### Examples

Full path
: Example path `spec.registry.repository`:

    ```yaml
    config:
      overrides:
        - path: spec.registry.repository
          value: "https://my-registry.url.com"
    ```

    Note that we did not provide a value for `spec.registry.server`, it will **not** be available to modify in the `Workload`.

Path to any key representing a YAML object
: Example path `spec.registry`:

    ```yaml
    config:
      overrides:
        - path: spec.registry
          value:
            repository: "https://my-registry.url.com"
    ```

  Example path `spec`:

    ```yaml
    config:
      overrides:
        - path: spec
          value:
            registry:
              repository: "https://my-registry.url.com"
    ```

    **Note that we did not provide a value for `spec.registry.server`, it will *not* be available to modify in the `Workload`.**

  Example path `spec` with empty value:

    ```yaml
    config:
      defaults:
        - path: spec
          value: {}
    ```

    **This results in a Workload without a spec.**


### Defaults

Allow the platform engineer to define default values that **can** be changed by Developers using the `Workload` (Developer API).
By configuring defaults for each component in the SupplyChain, the generated `Workload` will contain default values.

**Example Use case:**

As a platform engineer, I want to provide a default service account in my supplychain to simplify the configuration a developer must provide, but allow developers to modify if necessary.

#### Configure defaults

Defaults consist of:

- `path`: path to the configuration value, formatted as either:
  1. The full path to the field you wish to set.
  2. The path to any structure where all desired child fields must be set.
- `value`: String or YAML structured value.

#### Generate SupplyChain with Defaults

Generate the Supply chain by supplying the `--allow-defaults` flag:

```console
tanzu supplychain generate \
    --kind AppBuildV1 \
    --description "Supply chain that pulls the source code from git repo, builds it using buildpacks and package the output as Carvel package." --component "source-git-provider-1.0.0" --component "buildpack-build-1.0.0" --component "conventions-1.0.0" \
    --component "app-config-server-1.0.0" \
    --component "carvel-package-1.0.0" \
    --component "git-writer-pr-1.0.0" \
    --allow-defaults
```

The Tanzu Supply Chain CLI plug-in creates the required files to deploy your SupplyChain in the current directory:

```
✓ Successfully fetched all component dependencies
Created file supplychains/appbuildv1.yaml
...
```

To configure defaults, open `supplychains/appbuildv1.yaml` in your editor and navigate to the following section:

```
  ...
  config:
    defaults:
        # Platform Engineer provided registry defaults
        - path: spec.registry.repository
        value: "YOUR-REGISTRY-REPO"
        - path: spec.registry.server
        value: "YOUR-REGISTRY-SERVER"

        # Platform Engineer provided build defaults
        - path: spec.build.builder.kind
          value: clusterbuilder
        - path: spec.build.builder.name
          value: default
        - path: spec.build.cache.enabled
          value: false
        - path: spec.build.cache.image
          value: ""
        - path: spec.build.serviceAccountName
          value: default
        
        # Platform Engineer provided carvel package component defaults
        - path: spec.carvel.caCertData
          value: ""
        - path: spec.carvel.iaasAuthEnabled
          value: false
        - path: spec.carvel.packageDomain
          value: "default.tap"
        - path: spec.carvel.serviceAccountName
          value: "default"
        - path: spec.carvel.valuesSecretName
          value: ""

        # Platform Engineer provided GitOps repo defaults
        - path: spec.gitOps.baseBranch
          value: main
        - path: spec.gitOps.branch
          value: main
        - path: spec.gitOps.subPath
          value: "YOUR-GITOPS-REPO-SUBPATH"
        - path: spec.gitOps.url
          value: "YOUR-GITOPS-REPO-URL"
```

##### Examples

Full path
: Example path `spec.registry.repository`:

    ```yaml
    config:
      defaults:
        - path: spec.registry.repository
          value: "https://my-default-registry.url.com"
    ```

Path to any key representing a YAML object
: Example path `spec.registry`:

    ```yaml
    config:
      defaults:
        - path: spec.registry
          value:
            repository: "https://my-default-registry.url.com"
    ```

  Example path `spec`:

    ```yaml
    config:
      defaults:
        - path: spec
          value:
            registry:
              repository: "https://my-default-registry.url.com"
    ```

## Reference Guides

### SupplyChain API

- [SupplyChain API](./../../../reference/api/supplychain.hbs.md)

### Reference Guides

- [Overview of SupplyChains](./../../explanation/supply-chains.hbs.md)
- [Overview of Components](./../../explanation/components.hbs.md)
- [Overview of Resumptions](./../../explanation/resumptions.hbs.md)
- [Overview of Workloads](./../../explanation/workloads.hbs.md)
- [Overview of WorkloadRuns](./../../explanation/workload-runs.hbs.md)

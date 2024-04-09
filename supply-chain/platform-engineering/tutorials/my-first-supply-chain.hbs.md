# Build your first Supply Chain

This topic tells you how to use the Tanzu Supply Chain CLI plug-in to create a SupplyChain
for developers to use.

{{> 'partials/supply-chain/beta-banner' }}

This SupplyChain retrieves the source code from a Git repository, and proceeds with building and
packaging it as a Carvel package. Subsequently, it initiates a pull request (PR) to transfer the Carvel
package to a GitOps repository, facilitating the installation of the built package on the Run
clusters. In this tutorial, you will construct a supply chain to build, test, and package Java Maven
applications.

## Prerequisites

1. Ensure that the [Tanzu CLI](../../../install-tanzu-cli.hbs.md#install-tanzu-cli) and
[Tanzu Supply Chain CLI plug-ins](../how-to/install-the-cli.hbs.md) are installed on your local machine.

2. Ensure that [Tanzu Supply Chain](../how-to/installing-supply-chain/about.hbs.md) is installed
on the Tanzu Application Platform cluster that you are using to author your first supply chain.

## Browse the component catalog

When you have completed the prerequisites, you have the
Tanzu Supply Chain controller, Managed Resource Controller, and Component packages installed on the
cluster and you are ready to build your first SupplyChain.

1. As a Platform Engineer, you want to know which components are available to use in your SupplyChain.
Run:

    ```console
    tanzu supplychain component list
    ```

    Example output:

    ```console
    Listing components from the catalog
    NAMESPACE                   NAME                             AGE  DESCRIPTION                                                                       
    alm-catalog                 app-config-server-1.0.0          18h  Generates configuration for a Server application from a Conventions PodIntent.    
    alm-catalog                 app-config-web-1.0.0             18h  Generates configuration for a Web application from a Conventions PodIntent.       
    alm-catalog                 app-config-worker-1.0.0          18h  Generates configuration for a Worker application from a Conventions PodIntent.    
    alm-catalog                 carvel-package-1.0.0             18h  Generates a carvel package from OCI images containing raw YAML files and YTT      
                                                                      files.                                                                            
    alm-catalog                 deployer-1.0.0                   18h  Deploys K8s resources to the cluster.                                             
    alm-catalog                 source-package-translator-1.0.0  18h  Takes the type source and immediately outputs it as type package.                 
    conventions-component       conventions-1.0.0                18h  The Conventions component analyzes the `image` input as described in the          
    git-writer-catalog          git-writer-1.0.0                 18h  Writes carvel package config directly to a gitops repository                      
    git-writer-catalog          git-writer-pr-1.0.0              18h  Writes carvel package config to a gitops repository and opens a PR                
    kaniko-catalog              kaniko-build-1.0.0               18h  Builds an app with kaniko                                                         
    source-provider             source-git-provider-1.0.0        18h  Source git provider retrieves source code and monitors a git repository.          
    tbs-catalog                 buildpack-build-1.0.0            18h  Builds an app with buildpacks using kpack                                         
    trivy-app-scanning-catalog  trivy-image-scan-1.0.0           18h  Performs a trivy image scan using the scan 2.0 components                         

    🔎 To view the details of a component, use 'tanzu supplychain component get'
    ```

    Use the `-w/--wide` flag to see a more detailed output including a inputs/outputs of each component.

2. To get more information about each component on the cluster, use the
`tanzu supplychain component get` command. For example, to get the information about the
`source-git-provider` component, run:

  ```console
  tanzu supplychain component get source-git-provider-1.0.0 --show-details
  ```

  Example output:

    ```console
    📡 Overview
      name:         source-git-provider-1.0.0
      namespace:    source-provider
      age:          19h
      status:       True
      reason:       Ready
      description:  Source git provider retrieves source code and monitors a git repository.

    📝 Configuration
      source:
        #! Use this object to retrieve source from a git repository.
        #! The tag, commit and branch fields are mutually exclusive, use only one.
        #! Required
        git:
          #! A git branch ref to watch for new source
          #! Example: "main"
          branch: ""
          #! A git commit sha to use
          commit: ""
          #! A git tag ref to watch for new source
          #! Example: "v1.0.0"
          tag: ""
          #! The url to the git source repository
          #! Example: "https://github.com/acme/my-workload.git"
          #! Required
          url: ""
        #! The sub path in the bundle to locate source code
        #! Example: "sub-dir"
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
      - check-source runs source-git-check task every 60s
        📋 Parameters
          ├─ git-branch: $(workload.spec.source.git.branch)
          ├─ git-commit: $(workload.spec.source.git.commit)
          ├─ git-tag: $(workload.spec.source.git.tag)
          └─ git-url: $(workload.spec.source.git.url)

    🔎 To generate a supplychain using the available components, use 'tanzu supplychain generate'
    ```

## Generate a SupplyChain

1. Now that you know what components are available to create your SupplyChain, start the
authoring process. Use the `tanzu supplychain init` command to scaffold the current directory. Run:

    ```console
    mkdir myfirstsupplychaingroup
    cd myfirstsupplychaingroup
    tanzu supplychain init --group supplychains.tanzu.vmware.com --description "This is my first Supplychain group"
    ```

    Example output:

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

    The `tanzu supplychain init` command creates the following:

    - `config.yaml` file that contains the information about the group name, and the description of
    the SupplyChain group.
    - `supplychains`, `components`, `pipelines`, and `tasks` directories which are auto-populated by
    the authoring wizard later in this tutorial.
    - `Makefile` which has the targets to install and uninstall the SupplyChain and related
    dependencies on any build or full profile clusters.
    - `README.md` file which has instructions on how to use the targets in the `Makefile`.

2. Your current directory is now initialized, use the SupplyChain authoring wizard to
generate your first SupplyChain. Start the wizard:

    ```console
    tanzu supplychain generate --allow-defaults --allow-overrides
    ```

3. In the wizard prompts that follow, add the following values:

    |Prompt|Value|
    |:--|:--|
    |What Kind would you like to use as the developer interface?|`MavenAppBuildv1`|
    |Give Supply chain a description?|`Supply chain that pulls the Maven app source code from Git repository, builds it using buildpacks and packages the output as Carvel package.`|
    |Select a component as the first stage of the supply chain?|`source-git-provider-1.0.0`|
    |Select a component as the next stage of the supply chain?|`buildpack-build-1.0.0`|
    |Select a component as the next stage of the supply chain?|`conventions-1.0.0`|
    |Select a component as the next stage of the supply chain?|`app-config-server-1.0.0`|
    |Select a component as the next stage of the supply chain?|`carvel-package-1.0.0`|
    |Select a component as the next stage of the supply chain?|`git-writer-pr-1.0.0`|
    |Select a component as the next stage of the supply chain?|`Done`|

    After you have selected the components, the wizard creates the required files to
    deploy your SupplyChain in the current directory. Example output:

    ```console
    ✓ Successfully fetched all component dependencies
    Created file supplychains/mavenappbuildv1.yaml
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

4. You have now authored your first SupplyChain. View the SupplyChain definition created by the wizard
by viewing the manifest created in the `supplychains/` directory. Run:

    ```console
    cat supplychains/mavenappbuildv1.yaml
    ```

    Example output

    ```console
    apiVersion: supply-chain.apps.tanzu.vmware.com/v1alpha1
    kind: SupplyChain
    metadata:
        name: mavenappbuildv1
    spec:
        defines:
            group: supplychains.tanzu.vmware.com
            kind: MavenAppBuildv1
            plural: mavenappbuildv1s
            version: v1alpha1
        description: Supply chain that pulls the maven app source code from Git repository, builds it using buildpacks and packages the output as Carvel package.
        stages:
            - componentRef:
                name: source-git-provider-1.0.0
              name: source-git-provider
            - componentRef:
                name: buildpack-build-1.0.0
              name: buildpack-build
            - componentRef:
                name: conventions-1.0.0
              name: conventions
            - componentRef:
                name: app-config-server-1.0.0
              name: app-config-server
            - componentRef:
                name: carvel-package-1.0.0
              name: carvel-package
            - componentRef:
                name: git-writer-pr-1.0.0
              name: git-writer-pr
        config:
        #   overrides:
              ...
        #   defaults:
              ...
    ```

    The CLI generated `SupplyChain` manifest has the following information:

    - Name of the SupplyChain.
    - The Kind definition of the Developer API (Workload) it will create.
    - Stages in the SupplyChain. The order of the stages are important as the stages are executed
    sequentially. Each stage is represented by a component.
    - `overrides`: The configuration supplied by a platform engineer for a stage (component)
    in the SupplyChain that cannot be overridden by developers using the `Workload` (Developer API)
    created by this SupplyChain.
    - `defaults`: The configuration supplied by a platform engineer for a stage (component)
    in the SupplyChain that can be overridden by developers using the `Workload` (Developer API)
    created by this SupplyChain. If the developer does not override the configuration, the platform
    engineer provides the default value.

## Configure a SupplyChain to run securely

To configure a SupplyChain to run securely, decide where the SupplyChain stages run, and refine the
Developer API (Workload) using overrides and defaults.

### Decide where the SupplyChain stages run

Tanzu Supply Chain execute workloads created by developers in accordance with the
continuous delivery guidelines established by platform engineers. To ensure compliance and security,
platform engineers must supply configurations and sensitive secrets that are not accessible to
developers. While supply chains can operate within hardened namespaces to address these concerns,
certain elements of a supply chain workload must remain configurable by developers.

>**Important** Each stage within a supply chain can be configured to operate within either the
`supplychain` namespace, where the `Supplychain` will be deployed, or the `developer` namespace,
where the `Workload` will be generated by the developer. By default, every stage in a supply chain
operates within the `supplychain` namespace.
This namespace is secure, restricting developers access to create or view sensitive resources such
as secrets. Nevertheless, there are scenarios where developers must provide secrets required by
specific stages within the supply chain.

For our generated supply chain, the `source-git-provider` stage operates within the
`developer` namespace. Developers need the capability to create a git-secret for their
private Git repository where their source code is stored, without requiring involvement from platform
engineers. Some stages, such as `buildpack-build` and `git-writer-pr`, should not operate within the developer namespace. The `buildpack-build` stage requires registry credentials for storing the
built images, and the `git-writer-pr` stage requires git-secret with write permissions to generate
a PR to the GitOps repository.
Developers do not have access to provide or view these secrets due to compliance reasons, as they
might contain sensitive corporate data.

To do this, update the `source-git-provider` stage of the generated `supplychains/mavenappbuildv1.yaml` file as follows:

```console
...
      - componentRef:
          name: source-git-provider-1.0.0
        name: source-git-provider
        securityContext:
          runAs: workload
...
```

This tells the SupplyChain to run the `source-git-provider` stage in the `developer` namespace
where the developer source Git repository secret needed by `source-git-provider` is provided by
developers. All other steps run in the `supplychain` namespace where a platform engineer can
provide the necessary secrets for the `buildpack-build` stage and the `git-writer-pr` stage during
supply chain installation.

### Refine the Developer API (Workload) using overrides and defaults

When you generate a supply chain using the `tanzu supplychain generate`
command, use the `--allow-defaults` and `--allow-overrides` to generate all the fields that are
accessible in the Developer API (Workload) for developers to configure.
These fields represent the configurations exposed by the components.
Run the `tanzu supplychain component get` command to view the configurations exposed by the
components.
Inspect the `config.overrides` section of the `supplychains/mavenappbuildv1.yaml` file
generated by the CLI to see all the values that developers can specify in a `Workload`.

Some fields, such as `spec.registry`, can only be defined by platform engineers, who can
provide the necessary secrets to access those locations in the secure `supplychain` namespace.
Developers cannot override these values. This is where the overrides feature
becomes relevant. Platform engineers uncomment the fields they want to override and
provide the corresponding values at the supply chain level. When these overrides are implemented,
these fields are no longer accessible within the `Workload`.

To do this, update the `config.overrides` section of the generated `supplychains/mavenappbuildv1.yaml`
file as follows:

```console
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
...
```

## Review our SupplyChain

Here is an example of what a `SupplyChain` looks like when the configuration is complete:

```console
apiVersion: supply-chain.apps.tanzu.vmware.com/v1alpha1
kind: SupplyChain
metadata:
    name: mavenappbuildv1
spec:
    defines:
        group: supplychains.tanzu.vmware.com
        kind: MavenAppBuildv1
        plural: mavenappbuildv1s
        version: v1alpha1
    description: Supply chain that pulls the maven app source code from Git repository, builds it using buildpacks and packages the output as Carvel package.
    stages:
        - componentRef:
            name: source-git-provider-1.0.0
          name: source-git-provider
          securityContext:
            runAs: workload
        - componentRef:
            name: buildpack-build-1.0.0
          name: buildpack-build
        - componentRef:
            name: conventions-1.0.0
          name: conventions
        - componentRef:
            name: app-config-server-1.0.0
          name: app-config-server
        - componentRef:
            name: carvel-package-1.0.0
          name: carvel-package
        - componentRef:
            name: git-writer-pr-1.0.0
          name: git-writer-pr

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
        - path: spec.gitOps.subPath
          value: "YOUR-GITOPS-REPO-SUBPATH"
        - path: spec.gitOps.url
          value: "YOUR-GITOPS-REPO-URL"

```

## Next Steps

Deploy the `SupplyChain` to your Tanzu Application Platform clusters where your developers are
creating the `Workloads`. For instructions, see
[Install an authored Supply Chain](../how-to/deploying-supply-chains/install.hbs.md).

### Useful links

- [Supply Chain API Reference](../../reference/api/supplychain.hbs.md)
- [Component Catalog](../../reference/catalog/about.hbs.md)
# Creating accelerators

This topic tells you how to create an accelerator in Tanzu Developer Portal
(formerly named Tanzu Application Platform GUI).

An accelerator contains your conforming code and configurations that developers can use to create new
projects that by default follow the standards defined in your accelerators.

## <a id="creating-acc-prereqs"></a>Prerequisites

The following prerequisites are required to create an accelerator:

- Application Accelerator is installed. For information about installing Application Accelerator,
    see [Installing Application Accelerator for VMware Tanzu](../install-app-acc.md).
- You can access Tanzu Developer Portal from a browser or use the Application
    Accelerator extension for VS Code.
  - For more information about Tanzu Developer Portal, see
    [Overview of Tanzu Developer Portal](../../tap-gui/about.hbs.md).
  - For more information about Application Accelerator extension for VS Code, see
    [Application Accelerator  Visual Studio Code extension](../vscode.md).
- kubectl is installed and authenticated with admin rights for your target cluster.

## <a id="creating-acc-get-started"></a>Getting started

You can use any Git repository to create an accelerator. You need the URL of the repository to
create an accelerator.

For this example, the Git repository is `public` and contains a `README.md` file. These are options
available when you create repositories on GitHub.

Use the following procedure to create an accelerator based on this Git repository:

1. Clone your Git repository.

2. Create a file named `accelerator.yaml` in the root directory of this Git repository.

3. Add the following content to the `accelerator.yaml` file:

    ```yaml
    accelerator:
      displayName: Simple Accelerator
      description: Contains just a README
      iconUrl: https://images.freecreatives.com/wp-content/uploads/2015/05/smiley-559124_640.jpg
      tags:
      - simple
      - getting-started
    ```

    Feel free to use a different icon if it uses a reachable URL.

4. Add the new `accelerator.yaml` file, commit this change and push to your Git repository.

## <a id="publishing-the-new-acc"></a>Publishing the new accelerator

1. To publish your new accelerator, run:

    ```console
    tanzu accelerator create simple --git-repository ${GIT_REPOSITORY_URL} --git-branch ${GIT_REPOSITORY_BRANCH}
    ```

    Where:

    - `GIT-REPOSITORY-URL` is the URL for your Git repository where the accelerator is located.
    - `GIT-REPOSITORY-BRANCH` is the name of the branch where you pushed the new `accelerator.yaml` file.

2. Refresh Tanzu Developer Portal or the Application Accelerator extension in VS Code to
   reveal the newly published accelerator. It might take a few seconds to refresh the catalog and
   add an entry for your new accelerator.

    ![Screenshot showing the new Simple Accelerator included in Tanzu Developer Portal.](../images/new-accelerator-deployed-v1-1.png)

Alternatively, use the Tanzu CLI to create a separate manifest file and apply it to
the cluster.

1. Create a `simple-manifest.yaml` file and add the following content, filling in with your Git
repository and branch values.

    ```yaml
    apiVersion: accelerator.apps.tanzu.vmware.com/v1alpha1
    kind: Accelerator
    metadata:
      name: simple
      namespace: accelerator-system
    spec:
      git:
        url: YOUR-GIT-REPOSITORY-URL
        ref:
          branch: YOUR-GIT-BRANCH
    ```

2. To apply the `simple-manifest.yaml`, run this command in your terminal in the directory where you
   created this file:

    ```console
    tanzu accelerator apply -f simple-manifest.yaml
    ```

## <a id="using-local-path"></a>Using local-path for publishing accelerators

You can publish an accelerator directly from a local directory on your system. This helps when
authoring accelerators and allows you to avoid having to commit every small change to a remote Git
repository. You can also specify `--interval` so the accelerator is reconciled quicker when VMware
>push new changes.

```console
tanzu accelerator create simple --local-path ${ACCELERATOR_PATH} --source-image ${SOURCE_IMAGE_REPO} --interval 10s
```

Where:

- `ACCELERATOR-PATH` is the path to the accelerator source. It is a fully qualified or a relative
  path. If your current directory is already the directory where your source is, then use ".".
- `SOURCE-IMAGE-REPO` is the name of the OCI image repository where you want to push the new
  accelerator source. If using Docker Hub, use something such as
  `docker.io/YOUR_DOCKER_ID/simple-accelerator-source`.

After you have made any additional changes, you can push the latest to the same OCI image repository using:

```console
tanzu accelerator push --local-path ${ACCELERATOR_PATH} --source-image ${SOURCE_IMAGE_REPO}
```

The accelerator now reflects the new content after approximately a 10-second wait as specified
in the previous command.

## <a id="using-acc-fragments"></a>Using accelerator fragments

Accelerator fragments are reusable accelerator components that can provide options, files, or
transforms. They can be imported from accelerators using an `import` entry and the transforms from
the fragment can be referenced in an `InvokeFragment` transform in the accelerator that is declaring
the import. For additional details see [InvokeFragment transform](transforms/invoke-fragment.md).

The accelerator samples include three fragments - `java-version`, `tap-initialize`, and
`live-update`. See
[vmware-tanzu/application-accelerator-samples/fragments](https://github.com/vmware-tanzu/application-accelerator-samples/tree/tap-1.3/fragments)
Git repository for the content of these fragments.

To discover what fragments are available to use, run:

```console
tanzu accelerator fragment list
```

Look a the `java-version` fragment as an example. It contains the following `accelerator.yaml` file:

```console
accelerator:
  options:
  - name: javaVersion
    inputType: select
    label: Java version to use
    choices:
    - value: "1.8"
      text: Java 8
    - value: "11"
      text: Java 11
    - value: "17"
      text: Java 17
    defaultValue: "11"
    required: true

engine:
  merge:
    - include: [ "pom.xml" ]
      chain:
      - type: ReplaceText
        regex:
          pattern: "<java.version>.*<"
          with: "'<java.version>' + #javaVersion + '<'"
    - include: [ "build.gradle" ]
      chain:
      - type: ReplaceText
        regex:
          pattern: "sourceCompatibility = .*"
          with: "'sourceCompatibility = ''' + #javaVersion + ''''"
    - include: [ "config/workload.yaml" ]
      chain:
      - type: ReplaceText
        condition: "#javaVersion == '17'"
        substitutions:
          - text: "spec:"
            with: "'spec:\n  build:\n    env:\n    - name: BP_JVM_VERSION\n      value: \"17\"'"
```

This fragment contributes the following to any accelerator that imports it:

1. An option named `javaVersion` with three choices `Java 8`, `Java 11`, and `Java 17`
2. Three `ReplaceText` transforms:
    - If the accelerator has a `pom.xml` file, then what is specified for `<java.version>` is
      replaced with the chosen version.
    - If the accelerator has a `build.gradle` file, then what is specified for `sourceCompatibility`
      is replaced with the chosen version.
    - If the accelerator has a `config/workload.yaml` file, and the user selected "Java 17" then a
      build environment entry of BP_JVM_VERSION is inserted into the `spec:` section.

## <a id="deploy-accelerator-frags"></a>Deploying accelerator fragments

To deploy new fragments to the accelerator system, use the new `tanzu accelerator fragment
create` CLI command or apply a custom resource manifest file with either `kubectl apply` or
the `tanzu accelerator apply` commands.

The resource manifest for the `java-version` fragment looks like this:

```console
apiVersion: accelerator.apps.tanzu.vmware.com/v1alpha1
kind: Fragment
metadata:
  name: java-version
  namespace: accelerator-system
spec:
  displayName: Select Java Version
  git:
    ref:
      tag: GIT_TAG_VERSION
    url: https://github.com/vmware-tanzu/application-accelerator-samples.git
    subPath: fragments/java-version
```

Where `GIT-TAG-VERSION` is the Git tag of the `java-version` fragment. For example, `tap-1.4.0` is a
valid Git tag for the `java-version` fragment.

To create the fragment, save the above manifest in a `java-version.yaml` file) and run:

```console
tanzu accelerator apply -f ./java-version.yaml
```

>**Note** The `accelerator apply` command can be used to apply both Accelerator and Fragment resources.

To avoid having to create a separate manifest file, run:

```console
tanzu accelerator fragment create java-version \
  --git-repo https://github.com/vmware-tanzu/application-accelerator-samples.git \
  --git-tag ${GIT_TAG_VERSION} \
  --git-sub-path fragments/java-version
```

Where `GIT-TAG-VERSION` is the Git tag of the `java-version` fragment. For example,`tap-1.4.0` is a
valid Git tag for the `java-version` fragment.

Now you can use this `java-version` fragment in an accelerator:

```console
accelerator:
  displayName: Hello Fragment
  description: A sample app
  tags:
  - java
  - spring
  - cloud
  - tanzu

  imports:
  - name: java-version

engine:
  merge:
    - include: ["**/*"]
    - type: InvokeFragment
      reference: java-version
```

The earlier accelerator imports the `java-version` which, as seen earlier, provides an option to
select the Java version to use for the project. It then instructs the engine to run the transforms
provided in the fragment that updates the Java version used in `pom.xml` or `build.gradle` files
from the accelerator.

For more detail on the use of fragments, see [InvokeFragment transform](transforms/invoke-fragment.md).

## <a id="Next-steps"></a>Next steps

Learn how to:

- Write an [accelerator.yaml](accelerator-yaml.md).
- Configure accelerators with [Accelerator Custom Resources](accelerator-crd.md).
- Manipulate files using [Transforms](transform-intro.md).
- Use [SpEL in the accelerator.yaml file](spel-samples.md).

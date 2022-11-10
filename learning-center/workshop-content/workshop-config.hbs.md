# Workshop configuration

There are two main parts to the configuration for a workshop. The first specifies the structure of the workshop content and the second defines the runtime requirements for deploying the workshop.

## <a id="content-structure"></a> Specifying structure of the content

There are multiple ways you can configure a workshop to specify the structure of the content. The sample workshops use YAML files.

The `workshop/modules.yaml` file provides details about the list of available modules that make up your workshop and data variables for use in content.

The list of available modules represents all of the modules available to you. You might not use all of them. You might want to run variations of your workshop, such as for different programming languages. As such, which modules are active and are used for a specific workshop are listed in the separate `workshop/workshop.yaml` file. The active modules are listed with the name to be given to that workshop.

By default the `workshop.yaml` file specifies what modules are used. When you want to deliver different variations of the workshop content, you can provide multiple workshop files with different names. For example, you can name the workshop files `workshop-java.yaml` and `workshop-python.yaml`.

Where you have multiple workshop files and don't have the default `workshop.yaml` file, you can specify the default workshop file by setting the `WORKSHOP_FILE` environment variable in the runtime configuration.

The format for listing the available modules in the `workshop/modules.yaml` file is:

```yaml
modules:
  workshop-overview:
    name: Workshop Overview
    exit_sign: Setup Environment
  setup-environment:
    name: Setup Environment
    exit_sign: Start Workshop
  exercises/01-sample-content:
    name: Sample Content
  workshop-summary:
    name: Workshop Summary
    exit_sign: Finish Workshop
```

Each available module is listed under `modules`, where the name used corresponds to the path to the file containing the content for that module. Any extension identifying the content type is left off.

For each module, set the `name` field to the page title to be displayed for that module. If no fields are provided and `name` is not set, the title for the module is derived from the name of the module file.

The corresponding `workshop/workshop.yaml` file, where all available modules are used, would have the format:

```yaml
name: Markdown Sample
modules:
  activate:
    - workshop-overview
    - setup-environment
    - exercises/01-sample-content
    - workshop-summary
```

The top-level `name` field in this file is the name of this variation of the workshop content.

The `modules.activate` field is a list of modules to be used for the workshop. The names in this list must match the names as they appear in the modules file.

The order in which modules are listed under the `modules.activate` field in the workshop configuration file dictates the order pages are traversed. The order in which modules appear in the modules configuration file is not relevant.

At the bottom of each page, a **Continue** button is displayed to allow the user to go to the next page in sequence. You can customize the label on this button by setting the `exit_sign` field in the entry for the module in the modules configuration file.

In the last module in the workshop, a button is displayed, but where the user goes after clicking it varies. If you want the user to go to a different website upon completion, you can set the `exit_link` field of the final module to an external URL. Alternatively, you can set the `RESTART_URL` environment variable in a workshop environment to control where the user goes. If a destination for the final page is not provided, the user is redirected back to the starting page of the workshop.

When the user uses the training portal, the training portal overrides this environment variable so, at the completion of a workshop, the user returns to the training portal.

VMware recommends that for the last page, the `exit_sign` be set to "Finish Workshop" and `exit_link` not be specified. This enables the destination to be controlled from the workshop environment or training portal.

## <a id="specify-runtime-config"></a> Specifying the runtime configuration

You can deploy workshop images directly to a container runtime. The Learning Center Operator is provided to manage deployments into a Kubernetes cluster. You define the configuration for the Learning Center Operator with a `Workshop` CRD in the `resources/workshop.yaml` file:

  ```yaml
  apiVersion: learningcenter.tanzu.vmware.com/v1beta1
  kind: Workshop
  metadata:
    name: lab-markdown-sample
  spec:
    vendor: learningcenter.tanzu.vmware.com
    title: Markdown Sample
    description: A sample workshop using Markdown
    url: YOUR-GIT-URL-FOR-LAB-MARKDOWN-SAMPLE
    content:
      image: {YOUR-REGISTRY-URL}/lab-markdown-sample:main
    duration: 15m
    session:
      namespaces:
        budget: small
      applications:
        console:
          enabled: true
        editor:
          enabled: true
  ```

  Where:

  - `YOUR-GIT-URL-FOR-LAB-MARKDOWN-SAMPLE` is the Git repository URL for `lab-markdown-sample`. For example, `{YOUR-GIT-REPO-URL}/lab-markdown-sample`.

In this sample, a custom workshop image bundles the workshop content into its own container image. The `content.image` setting specifies this. To instead download workshop content from a GitHub repository at runtime, use:

  ```yaml
  apiVersion: learningcenter.tanzu.vmware.com/v1beta1
  kind: Workshop
  metadata:
    name: lab-markdown-sample
  spec:
    vendor: learningcenter.tanzu.vmware.com
    title: Markdown Sample
    description: A sample workshop using Markdown
    url: YOUR-GIT-URL-FOR-LAB-MARKDOWN-SAMPLE
    content:
      files: YOUR-GIT-URL-FOR-LAB-MARKDOWN-SAMPLE
    duration: 15m
    session:
      namespaces:
        budget: small
      applications:
        console:
          enabled: true
        editor:
          enabled: true
  ```

  Where:
  
  - `YOUR-GIT-URL-FOR-LAB-MARKDOWN-SAMPLE` is the Git repository URL for `lab-markdown-sample`. For example, `{YOUR-GIT-REPO-URL}/lab-markdown-sample`.

The difference is the use of the `content.files` setting.
Here, the workshop content is overlaid on top of the standard workshop base image. To use an alternate base image with additional applications or packages installed, specify the alternate image against the `content.image` setting at the same time you set `content.files`.

## Next steps

- Learn about configuration options for the workshop.yaml custom resource definitions (CRD) in [Workshop resource](../runtime-environment/workshop-definition.md).

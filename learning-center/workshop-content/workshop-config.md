# Workshop configuration

There are two main parts to the configuration for a workshop. The first specifies the structure of the workshop content and the second defines the runtime requirements for deploying the workshop.

## Specifying structure of the content

There are multiple ways you can set up the configuration of a workshop to specify the structure of the content. The way used in the sample workshops is through YAML files.

The ``workshop/modules.yaml`` file provides details on the list of available modules which make up your workshop, and data variables for use in content.

In the case of the list of modules, not all modules may end up being used. This is because this list represents the full set of modules you have available and might use. You may want to run variations of your workshop, such as for different programming languages. As such, which modules are active and are used for a specific workshop are listed in the separate ``workshop/workshop.yaml`` file along with the name to be given to the workshop when using that set of modules.

By default the ``workshop.yaml`` file is used to drive what modules are used. Where you want to deliver different variations of the workshop content, you can provide multiple workshop files with different names. You might, for example, instead provide ``workshop-java.yaml`` and ``workshop-python.yaml``.

Where you have multiple workshop files and don't have the default ``workshop.yaml`` file, you can specify the default workshop file to use by setting the ``WORKSHOP_FILE`` environment variable in the runtime configuration for the workshop.

The format for listing the available modules in the ``workshop/modules.yaml`` file is:

```
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

Each available module is listed under ``modules``, where the name used corresponds to the path to the file containing the content for that module, with any extension identifying the content type left off.

For each module, set the ``name`` field to the page title to be displayed for that module. If no fields are provided and ``name`` is not set, the title for the module is calculated from the name of the module file.

The corresponding ``workshop/workshop.yaml`` file, where all available modules were being used, would have the format:

```
name: Markdown Sample
modules:
  activate:
    - workshop-overview
    - setup-environment
    - exercises/01-sample-content
    - workshop-summary
```

The top level ``name`` field in this file is the name for this variation of the workshop content.

The ``modules.activate`` field is a list of modules to be used for the workshop. The names in this list must match the names as they appear in the modules file.

The order in which pages are traversed is dictated by the order in which modules are listed under the ``modules.activate`` field in the workshop configuration file. The order in which modules appear in the modules configuration file is not relevant.

At the bottom of each page a "Continue" button is displayed for you to go to the next page in sequence. The label on this button can be customized by setting the ``exit_sign`` field in the entry for the module in the modules configuration file.

For the last module in the workshop, a button is still displayed, but where the user goes after pressing the button can vary.

If you want the user to go to a different web site upon completion you can set the ``exit_link`` field of the final module to an external URL. Alternatively, you can set the ``RESTART_URL`` environment variable from a workshop environment to control where the user goes.

If a destination for the final page is not provided, the user is redirected back to the starting page of the workshop.

When the user uses the training portal, the training portal overrides this environment variable so that, at the completion of a workshop, the user goes back to the training portal.

The recommendation is that for the last page the ``exit_sign`` be set to "Finish Workshop" and ``exit_link`` not be specified. This enables the destination to be controlled from the workshop environment or training portal.

## Specifying the runtime configuration

Workshop images can be deployed directly to a container runtime. The Learning Center Operator is provided to manage deployments into a Kubernetes cluster. You define the configuration for the Learning Center Operator is defined by a ``Workshop`` custom resource definition in the ``resources/workshop.yaml`` file:

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-markdown-sample
spec:
  vendor: learningcenter.tanzu.vmware.com
  title: Markdown Sample
  description: A sample workshop using Markdown
  url: https://github.com/eduk8s/lab-markdown-sample
  content:
    image: quay.io/eduk8s/lab-markdown-sample:master
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

In this sample, a custom workshop image is used to bundle the workshop content into its own container image. This was specified by the ``content.image`` setting. If instead you want to download workshop content from a GitHub repository at runtime, you would use:

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-markdown-sample
spec:
  vendor: learningcenter.tanzu.vmware.com
  title: Markdown Sample
  description: A sample workshop using Markdown
  url: https://github.com/eduk8s/lab-markdown-sample
  content:
    files: github.com/eduk8s/lab-markdown-sample
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

The difference is the use of the ``content.files`` setting.
Here, the workshop content is overlaid on top of the standard workshop base image. If you wanted to use an alternate base image with additional applications or packages installed, you would specify the alternate image against the ``content.image`` setting at the same time as setting ``content.files``.

The format of this file and others in the ``resources`` directory is covered later in the documentation which discusses the setup of a workshop environment under Kubernetes.

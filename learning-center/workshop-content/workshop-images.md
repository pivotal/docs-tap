# Workshop images

The workshop environment for the Learning Center is packaged up as container image. You can execute the image with remote content pulled down from GitHub or a web server. Alternatively, you can bundle your workshop content, including any extra tools required, in a new container image derived from the workshop environment base image.

## Templates for creating a workshop

To get you started with your own workshop content, a number of sample workshops are provided.
Different templates (Markdown or AsciiDoc) are available to use depending on the syntax you use to create the workshop.
These templates are available in a zip file called `LEARNING-CENTER-WORKSHOP-SAMPLES.ZIP` on the [Tanzu Network TAP Product Page](https://network.tanzu.vmware.com/products/tanzu-application-platform).
The zip file contains the following projects which you can upload to your own Git repository:

- lab-markdown-sample
- lab-asciidoc-sample

When creating your own workshops, a suggested convention is to always prefix the directory name with the Git repository name where it is being hosted. For example, the prefix can be `lab-`.
This way it stands out as a workshop or lab when you have a whole bunch of Git repositories on the same Git hosting service account or organization.

Note that you should not make the name you use for a workshop too long, else the DNS host name used for applications deployed from the workshop, when using certain methods of deployment, may exceed the 63 character limit. This is because the workshop deployment name is used as part of the namespace for each workshop session, which will in turn be used in the DNS host names generated for the ingress hostname. It is suggested to keep the workshop name, and thus your repository name to 25 characters or less.

## Workshop content directory layout

When you have created a copy of the sample workshop content, you will see a number of files located in the top level directory, and a number of sub directories forming a hierarchy.

The files in the top level directory are:

* ``README.md`` - A file telling everyone what the workshop in your Git repository is about, and how to deploy it. Replace the current content provided in the sample workshop with your own.
* ``LICENSE`` - A license file so people are clear about how they can use your workshop content. Replace this with what license you want to apply to your workshop content.
* ``Dockerfile`` - Steps to build your workshop into an image ready for deployment. This would be left as is, unless you want to customize it to install additional system packages or tools.
* ``kustomization.yaml`` - A kustomize resource file for loading the workshop definition. When using this, the Learning Center operator still needs to have first been deployed.
* ``.dockerignore`` - List of files to ignore when building the workshop content into an image.
* ``.eduk8signore`` - List of files to ignore when downloading workshop content into the workshop environment at runtime.

Key sub directories and the files contained within them are:

* ``workshop`` - Directory under which your workshop files reside.
* ``workshop/modules.yaml`` - Configuration file with details of available modules which make up your workshop, and data variables for use in content.
* ``workshop/workshop.yaml`` - Configuration file which provides the name of the workshop, the list of active modules for the workshop, and any overrides for data variables.
* ``workshop/content`` - Directory under which your workshop content resides, including images to be displayed in the content.
* ``resources`` - Directory under which Kubernetes custom resources are stored for deploying the workshop using the Learning Center.
* ``resources/workshop.yaml`` - The custom resources for the Learning Center which describes your workshop and requirements it may have when being deployed.
* ``resources/training-portal.yaml`` - A sample custom resource for the Learning Center for creating a training portal for the workshop, encompassing the workshop environment and a workshop instance.

A workshop may consist of other configuration files, and directories with other types of content, but this is the minimal set of files to get you started.

## Directory for workshop exercises

Because of the proliferation of files and directories at the top level of the repository and thus potentially the home directory for the user when running the workshop environment, you can push files required for exercises during the workshop into the ``exercises`` sub directory below the root of the repository.

When such an ``exercises`` sub directory exists, the initial working directory for the embedded terminal when created will be set to be ``$HOME/exercises`` instead of ``$HOME``. Further, if the embedded editor is enabled, the sub directory will be opened as the workspace for the editor and only directories and files in that sub directory will be visible through the default view of the editor.

Note that the ``exercises`` directory isn't set as the home directory of the user. This means that if a user inadvertently runs ``cd`` with no arguments from the terminal, they will end up back in the home directory.

To try and avoid confusion and provide a means for a user to easily get back to where they need to be, it is recommended if instructing users to change directories, to always provide a full path relative to the home directory. Thus use a path of the form ``~/exercises/example-1`` rather than ``example-1``, to the ``cd`` command if changing directories. By using a full path, they can execute the command again and know they will end up back in the required location.

# Building an image

You can build an image by bundling workshop content from the Learning Center workshop base image. Do this to include extra system or third-You party tools or configuration. For this purpose, the sample workshop templates provide a `Dockerfile`.

## <a id="structure-of-the-dockerfile"></a>Structure of the Dockerfile

The structure of the `Dockerfile` provided with the sample workshop templates is:

```
FROM registry.tanzu.vmware.com/tanzu-application-platform/tap-packages@sha256:681ef8d2e6fc8414b3783e4de424adbfabf2aa0126e34fa7dcd07dab61e55a89

COPY --chown=1001:0 . /home/eduk8s/

RUN mv /home/eduk8s/workshop /opt/workshop

RUN fix-permissions /home/eduk8s
```

Custom workshop images must be built on the `registry.tanzu.vmware.com/tanzu-application-platform/tap-packages@sha256:681ef8d2e6fc8414b3783e4de424adbfabf2aa0126e34fa7dcd07dab61e55a89` workshop image. You can do this directly or you can also create an intermediate base image to install extra packages required by a number of different workshops.

The default action when building the container image when using the `Dockerfile` is to copy all files to the `/home/eduk8s` directory. The `--chown=1001:0` option ensures that files are owned by the appropriate user and group. The `workshop` subdirectory is then moved to `/opt/workshop` so that it is not visible to the user and in a special location to be searched for workshop content, in addition to `/home/eduk8s/workshop`. To have other files or directories from the repository ignored, list them in the `.dockerignore` file.

You can include `RUN` statements in the `Dockerfile` to run custom-build steps, but the `USER` inherited from the base image has user ID `1001` and is not the `root` user.

## <a id="base-images-and-version-tags"></a>Bases images and version tags

The sample `Dockerfile` provided above and with the GitHub repository workshop templates references the workshop base image as:

```
registry.tanzu.vmware.com/tanzu-application-platform/tap-packages@sha256:681ef8d2e6fc8414b3783e4de424adbfabf2aa0126e34fa7dcd07dab61e55a89
```


## <a id="custom-workshop-base-iamges"></a>Custom workshop base images

The `base-environment` workshop images include language run times for Node.js and Python. If you need a different language runtime or a different version of a language runtime, you must create a custom workshop base image which includes the supported environment you need. This custom workshop image is derived from `base-environment` but includes the extra runtime components needed.

Below you can see a Dockerfile example on how to create a Java JDK11-customized image:

```
ARG IMAGE_REPOSITORY=dev.registry.tanzu.vmware.com/learning-center
FROM ${IMAGE_REPOSITORY}/pkgs-java-tools as java-tools
FROM registry.tanzu.vmware.com/tanzu-application-platform/tap-packages@sha256:681ef8d2e6fc8414b3783e4de424adbfabf2aa0126e34fa7dcd07dab61e55a89
COPY --from=java-tools --chown=1001:0 /opt/jdk11 /opt/java
COPY --from=java-tools --chown=1001:0 /opt/gradle /opt/gradle
COPY --from=java-tools --chown=1001:0 /opt/maven /opt/maven
COPY --from=java-tools --chown=1001:0 /opt/code-server/extensions/.  /opt/code-server/extensions/
COPY --from=java-tools --chown=1001:0 /home/eduk8s/. /home/eduk8s/
COPY --from=java-tools --chown=1001:0 /opt/eduk8s/. /opt/eduk8s/
ENV PATH=/opt/java/bin:/opt/gradle/bin:/opt/maven/bin:$PATH \
    JAVA_HOME=/opt/java \
    M2_HOME=/opt/maven
```


## <a id="install-extra-system-packages"></a>Installing extra system packages

Installation of extra system packages requires the installation to be run as `root`. To do this you must first switch the user commands before running the command and then switch the user back to user ID of `1001` when done.

```
USER root

RUN ... commands to install system packages

USER 1001
```

VMware recommends that you only use the `root` user to install extra system packages. Don't use the `root` user when adding anything under `/home/eduk8s`. Otherwise, you must ensure the user ID and group for directories and files are set to `1001:0` and then run the `fix-permissions` command if necessary.

One problem to guard against though is that when running any command as `root`, you must temporarily override the value of the `HOME` environment variable and set it to `/root`.

If you don't do this, because the `HOME` environment variable is by default set to `/home/eduk8s`, the `root` user might drop configuration files in `/home/eduk8s`, thinking it is the `root` home directory. This can cause commands run later during the workshop to fail if they try and update the same configuration files as they have wrong permissions.

Fixing the file and group ownership and running `fix-permissions` can help with this problem, but not always, because of the strange permissions the `root` user may apply and how container image layers work. It is therefore recommended instead to always use:

```
USER root

RUN HOME=/root && \
    ... commands to install system packages

USER 1001
```

## <a id="install-third-party-packages"></a>Installing third-party packages

If you are not using system packaging tools to install extra packages, but are instead manually downloading packages and optionally compiling them to binaries, it is better to do this as the default user and not `root`.

If compiling packages, VMware recommends to always work in a temporary directory under `/tmp` and to remove the directory as part of the same `RUN` statement when done.

If what is being installed is a binary, you can install it into the `/home/eduk8s/bin`. This directory is in the application search path defined by the `PATH` environment variable for the image.

To install a whole directory hierarchy of files, you can create a separate directory under `/opt` to install everything. You can then override the `PATH` environment variable in the `Dockerfile` to add any extra directory for application binaries and scripts and the `LD_LIBRARY_PATH` environment variable for the location of shared libraries.

If installing any files from a `RUN` instruction into `/home/eduk8s`, VMware recommends that you run `fix-permissions` as part of the same instruction to avoid copies of files being made into a new layer, which applies to the case where `fix-permissions` is only run in a later `RUN` instruction. You can still leave the final `RUN` instruction for `fix-permissions` as it is smart enough not to apply changes if the file permissions are already set correctly and so it does not trigger a copy of a file when run more than once.

# Building an image

Bundling workshop content into an image built from the Learning Center workshop base image would be done where you need to include extra system or third party tools, and/or configuration. For this purpose, the sample workshop templates provide a ``Dockerfile``.

## Structure of the Dockerfile

The structure of the ``Dockerfile`` provided with the sample workshop templates is:

```text
FROM projects.registry.vmware.com/educates/base-environment

COPY --chown=1001:0 . /home/eduk8s/

RUN mv /home/eduk8s/workshop /opt/workshop

RUN fix-permissions /home/eduk8s
```

A custom workshop image needs to be built on the ``projects.registry.vmware.com/educates/base-environment`` workshop image. This could be directly, or you could also create an intermediate base image if you needed to install extra packages which were required by a number of different workshops.

The default action when building the container image when using the ``Dockerfile`` is to copy all files to the ``/home/eduk8s`` directory. The ``--chown=1001:0`` option ensures that files are owned by the appropriate user and group. The ``workshop`` subdirectory is then moved to ``/opt/workshop`` so that it is out of the way and not visible to the user. This is a special location which will be searched for workshop content, in addition to ``/home/eduk8s/workshop``. To have other files or directories from the repository ignored, list them in the ``.dockerignore`` file.

It is possible to include ``RUN`` statements in the ``Dockerfile`` to run custom build steps, but the ``USER`` inherited from the base image will be that having user ID ``1001`` and will not be the ``root`` user.

## Bases images and version tags

The sample ``Dockerfile`` provided above and with the GitHub repository workshop templates references the workshop base image as:

```
projects.registry.vmware.com/educates/base-environment
```

This has the ``latest`` tag implicit to it that will follow the most up to date image made available for production use, but what actual version is used will depend on when the last time the base image was pulled using that tag into the platform you are building images.


## Custom workshop base images

The ``base-environment`` workshop images include language run times for Node.js and Python. If you need a different language runtime, or need a different version of a language runtime, you will need to create a custom workshop base image which includes the supported environment you need. This custom workshop image would be derived from ``base-environment`` but include the extra runtime components needed. 

Below you can see a Dockerfile example on how to create a Java JDK11 customized image:

```text
ARG IMAGE_REPOSITORY=projects.registry.vmware.com/educates
FROM ${IMAGE_REPOSITORY}/pkgs-java-tools as java-tools
FROM ${IMAGE_REPOSITORY}/base-environment
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


## Installing extra system packages

Installation of extra system packages requires the installation to be run as ``root``. To do this you will need to switch the user commands are run as before running the command. You should then switch the user back to user ID of ``1001`` when done.

```text
USER root

RUN ... commands to install system packages

USER 1001
```

It is recommended you only use the ``root`` user to install extra system packages. Don't use the ``root`` user when adding anything under ``/home/eduk8s``. If you do you will need to ensure the user ID and group for directories and files are set to ``1001:0`` and then run the ``fix-permissions`` command if necessary.

One problem you should guard against though is that when running any command as ``root``, you should temporarily override the value of the ``HOME`` environment variable and set it to ``/root``.

If you don't do this, because the ``HOME`` environment variable is by default set to ``/home/eduk8s``, the ``root`` user may drop configuration files in ``/home/eduk8s``, thinking it is the ``root`` home directory. This can cause commands run later during the workshop to fail, if they try and update the same configuration files, as they will have wrong permissions.

Fixing the file and group ownership and running ``fix-permissions`` may help with this problem, but not always because of the strange permissions the ``root`` user may apply and how container image layers work. It is therefore recommended instead to always use:

```text
USER root

RUN HOME=/root && \
    ... commands to install system packages

USER 1001
```

## Installing third-party packages

If you are not using system packaging tools to install extra packages, but are instead manually downloading packages, and optionally compiling them to binaries, it is better to do this as the default user and not ``root``.

If compiling packages, it is recommended to always work in a temporary directory under ``/tmp`` and to remove the directory as part of the same ``RUN`` statement when done.

If what is being installed is just a binary, it can be installed into the ``/home/eduk8s/bin``. This directory is automatically in the application search path defined by the ``PATH`` environment variable for the image.

If you need to install a whole directory hierarchy of files, create a separate directory under ``/opt`` to install everything. You can then override the ``PATH`` environment variable in the ``Dockerfile`` to add any extra directory for application binaries and scripts, and the ``LD_LIBRARY_PATH`` environment variable for the location of shared libraries.

If installing any files from a ``RUN`` instruction into ``/home/eduk8s``, it is recommended you run ``fix-permissions`` as part of the same instruction to avoid copies of files being made into a new layer, which would be the case if ``fix-permissions`` is only run in a later ``RUN`` instruction. You can still leave the final ``RUN`` instruction for ``fix-permissions`` as it is smart enough not to apply changes if the file permissions are already set correctly, and so it will not trigger a copy of a file when run more than once.

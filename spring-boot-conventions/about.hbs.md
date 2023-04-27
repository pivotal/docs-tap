# Spring Boot conventions

This topic tells you about Spring Boot convention server.

## <a id="overview"></a>Overview

The Spring Boot convention server is a bundle of small conventions applied to any Spring Boot
application that is submitted to the supply chain in which the convention controller is configured.

Run the `docker inspect` command to make the Spring Boot convention server look inside the image.
Example command:

```console
$ docker inspect springio/petclinic
```

Example output:

```console
[
    {
        "Id": "sha256:...",
        "RepoTags": [
            "springio/petclinic:latest"
        ],
        "RepoDigests": [
            "springio/petclinic@sha256:..."
        ],
        "Parent": "",
        "Container": "",
        ...
        "ContainerConfig": {
            "Hostname": "",
            "Domainname": "",
            "User": "",
            ...
            "Labels": null
        },
        "DockerVersion": "",
        "Author": "",
        "Config": {
...
]
```

The convention server searches inside the image for `Config -> Labels -> io.buildpacks.build.metadata`
to find the `bom` file. It looks inside the `bom` file for metadata to evaluate whether the
convention is to be applied.

For the list of conventions, see [Conventions](reference/conventions.hbs.md).

# Spring Boot conventions

## <a id="overview"></a>Overview

The Spring Boot convention server is a bundle of smaller conventions applied to any Spring Boot application submitted to the supply chain in which the convention controller is configured.

The Spring Boot convention server looks inside the image such as the following `docker inspect` command:

`$ docker inspect springio/petclinic`

```bash
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

The convention server searches inside the image for `Config -> Labels -> io.buildpacks.build.metadata` to find the `bom` file. It looks inside the `bom` file for metadata to evaluate whether the convention is to be applied.

For the list of conventions, see [Conventions](reference/conventions.md).

# Spring Boot conventions

## Overview

The _Spring Boot Convention Server_ is a bundle of smaller conventions applied to any Spring Boot Application submitted to the supply chain in which the convention controller is configured.

The _Spring Boot Convention Server_ looks inside the image similar to `docker inspect` command, like this:

`$ docker inspect springio/petclinic`

```
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

The convention server searches inside the image for `Config -> Labels -> io.buildpacks.build.metadata` to find the `bom` file. It looks inside the `bom` file for metadata to evaluate whether the convention is going to be applied.

Check the list of [conventions](reference/CONVENTIONS.md)

## Troubleshooting

For basic troubleshooting, see the [troubleshooting guide](./troubleshooting.md).

# Spring Boot conventions <!-- omit in toc -->

## Overview

The _Spring Boot Convention Server_ is a bundle of smaller conventions applied to any Spring Boot Application submitted to the supply chain in which the convention controller is configured.

The _Spring Boot Convention Server_ looks inside the image similar to `docker inspect` command like this:

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

Then the convention search inside the image for `Config -> Labels -> io.buildpacks.build.metadata` to find the `bom` and inside it look for different metadata to evaluate if the convention is got to be applied or not

Check the list of conventions [here](reference/CONVENTIONS.md)

## Troubleshooting

If you are having trouble, you can refer to the troubleshooting guide [here](./troubleshooting.md).
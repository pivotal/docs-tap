# Spring Boot conventions

## Overview

The _Spring Boot Convention Server_ is a bundle of smaller conventions applied to any Spring Boot Application submitted to the supply chain in which the convention controller is configured.

The _Spring Boot Convention Server_ looks inside the image like the following `docker inspect` command:

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

## Collecting logs from the _Spring Boot Convention Server_

If you have trouble, you can retrieve and examine the logs from the _Spring Boot Convention Server_.

1. The _Spring Boot Convention Server_ creates a namespace to contain all of the associated resources, by default the namespace is `spring-boot-convention`. Inspect the logs using the following command:

    ```
    $ kubectl logs -l app=spring-boot-webhook -n spring-boot-convention

    {"level":"info","timestamp":"2021-11-11T16:00:26.597Z","caller":"spring-boot-conventions/server.go:83","msg":"Succesfully applied convention: spring-boot","component":"spring-boot-conventions"}
    {"level":"info","timestamp":"2021-11-11T16:00:26.597Z","caller":"spring-boot-conventions/server.go:83","msg":"Succesfully applied convention: spring-boot-graceful-shutdown","component":"spring-boot-conventions"}
    {"level":"info","timestamp":"2021-11-11T16:00:26.597Z","caller":"spring-boot-conventions/server.go:83","msg":"Succesfully applied convention: spring-boot-web","component":"spring-boot-conventions"}
    {"level":"info","timestamp":"2021-11-11T16:00:26.597Z","caller":"spring-boot-conventions/server.go:83","msg":"Succesfully applied convention: spring-boot-actuator","component":"spring-boot-conventions"}
    {"level":"info","timestamp":"2021-11-11T16:00:26.597Z","caller":"spring-boot-conventions/server.go:83","msg":"Succesfully applied convention: service-intent-mysql","component":"spring-boot-conventions"}
    ```

2. For all of the conventions that were applied successfully, a log entry is added. In case of an error, a log entry is added with a description.

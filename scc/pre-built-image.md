# Pre-built image

For those applications that already have a predefined way of building their
container images, the supply chains included in the Out of the Box packages
support specifying a pre-built image to be used in the final application while
still going through the same set of stages as any other Workload.


## Workload

To specify a pre-built image, the `workoad.spec.image` field should be set with
the name of the container image that contains the application to be deployed.

Using the Tanzu CLI, that means leveraging the `--image` field of `tanzu apps
workload create` command:

```console
$ tanzu apps workload create --help
--image image        pre-built image, skips the source resolution and build 
                     phases of the supply chain
```

For instance, assuming we have an image named `IMAGE`, we can create a workload
making use of the flag mentioned above:

```bash
tanzu apps workload create tanzu-java-web-app \
  --app tanzu-java-web-app \
  --type web \
  --image IMAGE
```
```console
Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  labels:
      6 + |    app.kubernetes.io/part-of: hello-world
      7 + |    apps.tanzu.vmware.com/workload-type: web
      8 + |  name: tanzu-java-web-app
      9 + |  namespace: default
     10 + |spec:
     11 + |  image: IMAGE
```

## Out of the Box Supply Chains

In TAP v1.1, the three packages that relate to supply chains
(`ootb-supply-chain-basic`, `ootb-supply-chain-testing`, and
`ootb-supply-chain-testing-scanning`) have each received the addition of a new
supply chain that allows one to provide a pre-built container image for their
application, taking the process of building the image out of the flow.

```
ootb-supply-chain-basic

    (cluster)  basic-image-to-url   ClusterSupplyChain            (!) new
    ^          source-to-url        ClusterSupplyChain


ootb-supply-chain-testing

    (cluster)  testing-image-to-url  ClusterSupplyChain           (!) new
    ^          source-test-to-url    ClusterSupplyChain


ootb-supply-chain-testing-scanning

    (cluster)  scanning-image-scan-to-url    ClusterSupplyChain   (!) new
    ^          source-test-scan-to-url       ClusterSupplyChain
```

To leverage the supply chains that expect a pre-built image, the only change to
the Workload that is necessary is `workoad.spec.image` field being set to the
name of the container image that brings the application to be deployed.

That's because those new supply chains make use of a new Cartographer feature
that lets us increase the specificity of supply chain selection by leveraging
the `matchFields` selector rule. 

In summary, the selection takes place as follows:

- _ootb-supply-chain-basic_
  - from source: label `apps.tanzu.vmware.com/workload-type: web`
  - pre-built image: label `apps.tanzu.vmware.com/workload-type: web` **and**
    `workload.spec.image` set

- _ootb-supply-chain-testing_
  - from source: labels `apps.tanzu.vmware.com/workload-type: web` and
    `apps.tanzu.vmware.com/has-tests: true`
  - pre-built image: label `apps.tanzu.vmware.com/workload-type: web` **and**
    `workload.spec.image` set

- _ootb-supply-chain-testing-scanning_
  - from source: labels `apps.tanzu.vmware.com/workload-type: web` and
    `apps.tanzu.vmware.com/has-tests: true`
  - pre-built image: label `apps.tanzu.vmware.com/workload-type: web` **and**
    `workload.spec.image` set


To summarize: Workloads that already work with the supply chains pre TAP 1.1.0
will continue working matching against the same supply chain as before.
Workloads that want to bring a pre-built container image should set
`workload.spec.image`.



## How it works

Under the hood, an `ImageRepository` object will be created to keep track of
new images pushed under that name, making available to further resources in the
supply chain the final digest-based of the latest it found.

Whenever a new image is pushed with that image name, the `ImageRepository`
object will detect it, and then make it available to further resources by
updating its own `imagerepository.status.artifact.revision` with the absolute
name of that image (i.e., the image name including the digest of the latest one
found).

For instance, let's create a Workload using an image named `hello-world`,
tagged `tanzu-java-web-app` hosted under `ghcr.io` in the `kontinue`
repository:

```bash
tanzu apps workload create tanzu-java-web-app \
  --app tanzu-java-web-app \
  --type web \
  --image ghcr.io/kontinue/hello-world:tanzu-java-web-app
```

After a couple seconds, we should see the `ImageRepository` object created for
keeping track of images named
`ghcr.io/kontinue/hello-world:tanzu-java-web-app`:


```scala
Workload/tanzu-java-web-app
├─ImageRepository/tanzu-java-web-app        #! this
├─PodIntent/tanzu-java-web-app
├─ConfigMap/tanzu-java-web-app
└─Runnable/tanzu-java-web-app-config-writer
  └─TaskRun/tanzu-java-web-app-config-writer-p2lzv
    └─Pod/tanzu-java-web-app-config-writer-p2lzv-pod
```

Inspecting the `Workload` status (more specifically,
`workload.status.resources`), we can see the `image-provider` resource
promoting to further resources the image it found:

```yaml
apiVersion: carto.run/v1alpha1
kind: Workload
spec:
  image: ghcr.io/kontinue/hello-world:tanzu-java-web-app
status:
  resources:
    - name: image-provider
      outputs:
        # output being made available to further resources in the supply chain
        # (in this case, the latest image it found under that name).
        #
        - name: image
          lastTransitionTime: "2022-04-01T15:05:01Z"
          preview: ghcr.io/kontinue/hello-world:tanzu-java-web-app@sha256:9fb930a...

      # reference to the object managed by the supply chain for this
      # resource
      #
      stampedRef:
        apiVersion: source.apps.tanzu.vmware.com/v1alpha1
        kind: ImageRepository
        name: tanzu-java-web-app
        namespace: workload
      
      # reference to the template that defined how this object should look
      # like
      #
      templateRef:
        apiVersion: carto.run/v1alpha1
        kind: ClusterImageTemplate
        name: image-provider-template
```

That image found by the ImageRepository objects is then carried through the
supply chain all the way to the final configuration that gets pushed to either
a git repository or image registry so that it can be deployed in a run cluster.

> **Note:** the image name matches the one we supplied in the
> `workload.spec.image` field but it also includes the exact digest of the
> latest image found under that tag. If a new image was pushed to that same
> tag, we'd see the `ImageRepository` resolving that name to a different digest
> corresponding to the new image pushed.


## Examples

Aside from the gotchas outlined in the section below, it's mostly transparent
to the supply chain how one came up with the image being provided.

In the examples below we showcase a couple ways that one could end up building
container images for a Java-based application and having it carried through the
supply chains all the way to a running service.


### Dockerfile

Perhaps the most common way of building container images, with a Dockerfile we
get to specify a base image, on top of which certain operations should occur
(like, compiling the code), mutating the contents of the filesystem all the way
to a final container image that has our application built as well as any
runtime dependencies that it needs.

Here we leverage the `maven` base image for compiling our application code, and
then the very minimal distroless `java17-debian11` image for providing a JRE
that can run our built application. 

With the image built, we then push it to a container image registry, and then
reference it in the Workload.

1. Create a Dockerfile that describes how to build our application and make it
   available as a container image

    ```Dockerfile
    ARG BUILDER_IMAGE=maven
    ARG RUNTIME_IMAGE=gcr.io/distroless/java17-debian11


    FROM $BUILDER_IMAGE AS build

            ADD . .
            RUN unset MAVEN_CONFIG && ./mvnw clean package -B -DskipTests


    FROM $RUNTIME_IMAGE AS runtime

            COPY --from=build /target/demo-0.0.1-SNAPSHOT.jar /demo.jar
            CMD [ "/demo.jar" ]
    ```

2. Push the container image to an image registry

    ```bash
    docker build -t IMAGE .
    docker push IMAGE
    ```

3. Create a workload that makes use of it

    ```bash
    tanzu apps workload create tanzu-java-web-app \
      --type web \
      --app tanzu-java-web-app \
      --image IMAGE
    ```
    ```console
    Create workload:
          1 + |---
          2 + |apiVersion: carto.run/v1alpha1
          3 + |kind: Workload
          4 + |metadata:
          5 + |  labels:
          6 + |    app.kubernetes.io/part-of: hello-world
          7 + |    apps.tanzu.vmware.com/workload-type: web
          8 + |  name: tanzu-java-web-app
          9 + |  namespace: default
         10 + |spec:
         11 + |  image: IMAGE
    ```

4. Observe that we get it running

    ```bash
    tanzu apps workload get tanzu-java-web-app
    ```
    ```console
    # tanzu-java-web-app: Ready
    ---
    lastTransitionTime: "2022-04-06T19:32:46Z"
    message: ""
    reason: Ready
    status: "True"
    type: Ready

    Workload pods
    NAME                                                   STATUS      RESTARTS   AGE
    tanzu-java-web-app-00001-deployment-7d7df5ccf5-k58rt   Running     0          32s
    tanzu-java-web-app-config-writer-xjmvw-pod             Succeeded   0          89s

    Workload Knative Services
    NAME                 READY   URL
    tanzu-java-web-app   Ready   http://tanzu-java-web-app.default.example.com
    ```


### Sprint Boot's `build-image` Maven target

For those familiar with Spring Boot's `build-image` target, we can make use of
it for coming up with a container image that runs out application, and making
use of it should work just as well as with the Dockerfile above.

For instance, using the same sample repository as mentioned before
(https://github.com/sample-accelerators/tanzu-java-web-app), we can run from
the root of that repository the following command

```bash
IMAGE=ghcr.io/kontinue/hello-world:tanzu-java-web-app
./mvnw spring-boot:build-image -Dspring-boot.build-image.imageName=$IMAGE
```
```console
[INFO] Scanning for projects...
[INFO]
[INFO] --------------------------< com.example:demo >--------------------------
[INFO] Building demo 0.0.1-SNAPSHOT
[INFO] --------------------------------[ jar ]---------------------------------
[INFO]
...
[INFO]
[INFO] Successfully built image 'ghcr.io/kontinue/hello-world:tanzu-java-web-app'
[INFO]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  39.257 s
[INFO] Finished at: 2022-04-06T19:40:16Z
[INFO] ------------------------------------------------------------------------
```

With the image built, we can now push it to the container image registry:

```bash
IMAGE=ghcr.io/kontinue/hello-world:tanzu-java-web-app
docker push $IMAGE
```
```console
The push refers to repository [ghcr.io/kontinue/hello-world]
1dc94a70dbaa: Preparing
...
9d6787a516e7: Pushed
tanzu-java-web-app: digest: sha256:7140722ea396af69fb3d0ad12e9b4419bc3e67d9c5d8a2f6a1421decc4828ace size: 4497
```

Having pushed the container image, we should see the same results as in the
section above where we build the image with a `Dockerfile`.

To know more about building container images for Spring Boot application, make
sure you check out [Spring Boot with Docker][sboot-docker]

[sboot-docker]: https://spring.io/guides/gs/spring-boot-docker


## Gotchas

As the supply chains still aim at Knative as the runtime for the container
image provided, the application must adhere to Knative standards when it comes
to bringing the container up and serving traffic to it:

- **Listen on port 8080**

The Knative service gets created with the pod template spec being set to have
the container port set to 8080, so it's expected that regardless of how the
application's container image is built, to have a socket listenning on 8080.

```
ports:
  - containerPort: 8080
    name: user-port
    protocol: TCP
```

- **Non-privileged user ID**

By default, the container instiated as part of the pod will be ran as user
1000.

```
securityContext:
  runAsUser: 1000
```

- **Arguments other than the image's default entrypoint**

Because there is no way of supplying arguments down to the pod template spec
that will be used in the Knative service, it's expected that the container
image is able to run based solely on the default entrypoint configured for it
(in the case of Dockerfiles, the combination of ENTRYPOINT and CMD).

In case extra configuration should be provided, environment variables can be
used (see `--env` flags in `tanzu apps workload create` or
`workload.spec.env`).

- **Credentials for pulling the container image at runtime**

The image provided will not be relocated to an internal image registry, so, any
components that end up touching the image must have the necessary credentials
for pulling it. In practice, that means attaching to the serviceaccounts used
for both Workload and Deliverable a secret that contains the credentials to
pull that container image.

Similarly, if the image is hosted in a registry whose certificates have been
signed by a private certificate authority, then not only the components of the
supply chains and delivery must trust it, but also the Kubernetes nodes in the
run cluster.

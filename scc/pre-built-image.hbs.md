# Using a prebuilt image

For apps that build container images in a predefined way, the supply chains
in the Out of the Box packages enable you to specify a prebuilt image.
This uses the same stages as any other workload.

## <a id="requirements"></a> Requirements for prebuilt images

Supply chains aim at Knative as the runtime for the container image you provide.
Your app must adhere to the following Knative standards:

- **Container port listens on port 8080**

    The Knative service is created with the container port set to `8080` in the pod template spec
    Therefore, your container image must have a socket listening on `8080`.

    ```yaml
    ports:
      - containerPort: 8080
        name: user-port
        protocol: TCP
    ```

- **Non-privileged user ID**

    By default, the container initiated as part of the pod is run as user 1000.

    ```yaml
    securityContext:
      runAsUser: 1000
    ```

- **Arguments other than the image's default ENTRYPOINT**

    In most cases the container image runs using the `ENTRYPOINT` it was configured with.
    In the case of Dockerfiles, the combination of `ENTRYPOINT` and `CMD`.

    If you need extra configuration for your image, use `--env` flags with the
    `tanzu apps workload create` command or modify `spec.env` in your `workload.yaml` file.

- **Credentials for pulling the container image at runtime**

    The image you provide is not relocated to an internal container image registry.
    Any components associated with the image must have the necessary credentials
    to pull it. For the service accounts used for the workload and deliverable,
    you must attach a secret that contains the credentials to pull the container image.

    If the image is hosted in a registry that has certificates
    signed by a private certificate authority, the components of the
    supply chains, delivery, and the Kubernetes nodes in the run cluster must
    trust the certificate.

## <a id="workload"></a> Configure your workload to use a prebuilt image

To select a prebuilt image, set the `spec.image` field in your `workload.yaml` file
with the name of the container image that contains the app to deploy by running:

```bash
tanzu apps workload create WORKLOAD-NAME \
  --app APP-NAME \
  --type TYPE \
  --image IMAGE
```

Where:

- `WORKLOAD-NAME` is the name you choose for your workload.
- `APP-NAME` is the name of your app.
- `TYPE` is the type of your app.
- `IMAGE` is the container image that contains the app you want to deploy.

For example, if you have an image named `IMAGE`, you can create a workload
with the flag mentioned earlier:

```bash
tanzu apps workload create tanzu-java-web-app \
  --app tanzu-java-web-app \
  --type web \
  --image IMAGE
```

Expected output:

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

When you run `tanzu apps workload create` command with the `--image` field,
the source resolution and build phases of the supply chain are skipped.

## <a id="examples"></a> Examples

The following examples show ways that you can build container images for a
Java-based app and complete the supply chains to a running service.

### <a id="dockerfile"></a> Using a Dockerfile

Using a Dockerfile is the most common way of building container images. You
can select a base image, on top of which certain operations must occur,
such as compiling code, and mutate the contents of the file system
to a final container image that has a build of your app and any
required runtime dependencies.

Here you use the `maven` base image for compiling your app code, and
then the minimal distroless `java17-debian11` image for providing a JRE
that can run your app when it is built.

After building the image, you push it to a container image registry, and then
reference it in the workload.

1. Create a Dockerfile that describes how to build your app and make it
   available as a container image:

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

2. Push the container image to a container image registry by running:

    ```bash
    docker build -t IMAGE .
    docker push IMAGE
    ```

3. Create a workload by running:

    ```bash
    tanzu apps workload create tanzu-java-web-app \
      --type web \
      --app tanzu-java-web-app \
      --image IMAGE
    ```

    Expected output:

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

4. Run the following workload:

    ```bash
    tanzu apps workload get tanzu-java-web-app
    ```
    Expected output:

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

### <a id="sb-maven"></a> Using Spring Boot's `build-image` Maven target

You can use Spring Boot's `build-image` target to build a container image that runs your app.
The `build-image` target must use a Dockerfile.

For example, using the same sample repository as mentioned before
(https://github.com/sample-accelerators/tanzu-java-web-app):

1. Build the image by running the following command from the root of the repository:

    ```bash
    IMAGE=ghcr.io/kontinue/hello-world:tanzu-java-web-app
    ./mvnw spring-boot:build-image -Dspring-boot.build-image.imageName=$IMAGE
    ```

    Expected output:

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

1. Push the image you built to the container image registry by running:

    ```bash
    IMAGE=ghcr.io/kontinue/hello-world:tanzu-java-web-app
    docker push $IMAGE
    ```

    Expected output:

    ```console
    The push refers to repository [ghcr.io/kontinue/hello-world]
    1dc94a70dbaa: Preparing
    ...
    9d6787a516e7: Pushed
    tanzu-java-web-app: digest: sha256:7140722ea396af69fb3d0ad12e9b4419bc3e67d9c5d8a2f6a1421decc4828ace size: 4497
    ```

After you push the container image, you see the same results as building the image
[using a Dockerfile](#dockerfile).

For more information about building container images for a Spring Boot app,
see [Spring Boot with Docker](https://spring.io/guides/gs/spring-boot-docker)

## <a id="ootb-supply-chain"></a> About Out of the Box Supply Chains

In Tanzu Application Platform, the `ootb-supply-chain-basic`, `ootb-supply-chain-testing`, and
`ootb-supply-chain-testing-scanning` packages each receive a new
supply chain that provides a prebuilt container image for your
app.

```text
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

To leverage the supply chains that expect a prebuilt image, you must set
the `spec.image` field in the workload to the
name of the container image that contains the app to deploy.

The new supply chains use a Cartographer feature
that lets VMware increase the specificity of supply chain selection by using
the `matchFields` selector rule.

The selection takes place as follows:

- _ootb-supply-chain-basic_
  - From source: label `apps.tanzu.vmware.com/workload-type: web`
  - Prebuilt image: label `apps.tanzu.vmware.com/workload-type: web` **and**
    set `spec.image` in the `workload.yaml`

- _ootb-supply-chain-testing_
  - From source: labels `apps.tanzu.vmware.com/workload-type: web` and `apps.tanzu.vmware.com/has-tests: true`
  - Prebuilt image: label `apps.tanzu.vmware.com/workload-type: web` **and**
    set `spec.image` in the `workload.yaml`

- _ootb-supply-chain-testing-scanning_
  - From source: labels `apps.tanzu.vmware.com/workload-type: web` and `apps.tanzu.vmware.com/has-tests: true`
  - Prebuilt image: label `apps.tanzu.vmware.com/workload-type: web` **and**
    set `spec.image` in the `workload.yaml`

Workloads that already work with the supply chains before Tanzu Application Platform v1.1
continue to work with the same supply chain.
Workloads that bring a prebuilt container image must set `spec.image` in the `workload.yaml`.


## <a id="how-it-works"></a> Understanding the supply chain for a prebuilt image

An `ImageRepository` object is created to keep track of
new images pushed under that name.
`ImageRepository` makes the image available to further resources in the
supply chain, providing the final digest of the latest image.

Whenever a new image is pushed to the workload's image location, the `ImageRepository`
detects the change. The image is then available to further resources by
updating its `imagerepository.status.artifact.revision` with an absolute
reference to that image.

For example, if you create a workload using an image named `hello-world`,
tagged `tanzu-java-web-app` hosted under `ghcr.io` in the `kontinue`
repository:

```bash
tanzu apps workload create tanzu-java-web-app \
  --app tanzu-java-web-app \
  --type web \
  --image ghcr.io/kontinue/hello-world:tanzu-java-web-app
```

After a couple seconds, you see the `ImageRepository` object created to
keep track of images named
`ghcr.io/kontinue/hello-world:tanzu-java-web-app`:


```scala
Workload/tanzu-java-web-app
├─ImageRepository/tanzu-java-web-app        
├─PodIntent/tanzu-java-web-app
├─ConfigMap/tanzu-java-web-app
└─Runnable/tanzu-java-web-app-config-writer
  └─TaskRun/tanzu-java-web-app-config-writer-p2lzv
    └─Pod/tanzu-java-web-app-config-writer-p2lzv-pod
```

If you inspect the status in `status.resources` in the `workload.yaml`, you see the `image-provider` resource
promoting the image it found to further resources:

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

The image found by the `ImageRepository` object is carried through the
supply chain to the final configuration. This is pushed to either
a Git repository or image registry so that it is deployed in a run cluster.

>**Note:** The image name matches the image name supplied in the `spec.image` field in the `workload.yaml`, but also includes the digest of the latest image found under the tag. If a new image is pushed to the same tag, you see the `ImageRepository` resolving the name to a different digest corresponding to the new image pushed.

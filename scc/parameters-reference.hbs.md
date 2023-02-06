# Workload parameters reference

The supply chains and templates provided by the out of the box packages contain
a series of parameters that customize supply chain behavior. This topic
describes the `workload.spec.params` parameters that are configured in Workload
objects to change their behavior. They are organized by the resource in the
supply chain where they are used.

> **Note** This topic describes parameters you can use to customize the scan
> policy for scanning source code that are related to a resource available in
> the `ootb-supply-chain-testing-scanning`. This topic does not cover parameters
> for the `ootb-supply-chain-basic` or `ootb-supply-chain-testing` supply
> chains.

```console
source-provider                     fetches source code
    |
    |  source
    |
source-tester                       tests source code
    |
    |  source
    |
source-scanner                      scans source code
    |
    |  source
    |
image-provider                      builds app container image
    |
    |  image
    |
image-scanner                       scans app container image
    |
    |  image
    |
config-provider                     tailors a pod spec based on the app image
    |                               and conventions setup in the cluster
    |  podtemplate spec
    |
app-config                          creates kubernetes config files (knative
    |                               service / deployment depending on workload
    |                               type)
    |  kubernetes configuration
    |
service-bindings                    adds service bindings to the set of config
    |                               files
    |  kubernetes configuration
    |
api-descriptors                     adds apidescriptors to the set of config
    |                               files
    |  kubernetes configuration
    |
config-writer                       writes the configuration to a destination
                                    (git or registry) for further deployment
                                    to a `run` cluster
```

For information about supply chains, see:

- [Out of the Box Supply Chain Basic](ootb-supply-chain-basic.hbs.md)
- [Out of the Box Supply Chain Testing](ootb-supply-chain-testing.hbs.md)
- [Out of the Box Supply Chain Testing Scanning](ootb-supply-chain-testing-scanning.hbs.md)

## Source provider

The `source-provider` resource in the supply chain creates
objects that fetch either source code or pre-compiled Java applications.
This is configured in each Workload. See [Building from
Source](building-from-source.hbs.md).

### GitRepository

Use `gitrepository` when fetching source code from Git repositories. This
resource makes further resources available in the supply chain, such as the
contents of the Git repository as a tarball available in the cluster.

Parameters:

<table>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>gitImplementation<code></td>
    <td>
      The library used to fetch source code.
      If not provided, TAP's default implementation will use <code>go-git</code>,
      which works with the providers currently supported by TAP: Github and Gitlab.
      An alternate value that may be used with other git providers is <code>libggit2</code>.
    </td>
    <td>
      <pre>
      - name: gitImplementation
        value: libggit2
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_ssh_secret<code></td>
    <td>
      Name of the secret used to provide credentials for the Git repository.
      The secret with this name must exist in the same namespace as the <code>Workload</code>.
      The credentials must be sufficient to read the repository.
      If not provided, TAP will default to look for a secret named <code>git-ssh</code>.
      See <a href="git-auth.html">Git authentication</a>.
    </td>
    <td>
      <pre>
      - name: gitops_ssh_secret
        value: git-credentials
      </pre>
    </td>
  </tr>
</table>

> **Note** Some git providers, notably Azure DevOps, require you to use
> `libgit2` due to the server-side implementation providing support
> only for [git's v2 protocol](https://git-scm.com/docs/protocol-v2).
> For information about the features supported by each implementation, see
> [git implementation](https://fluxcd.io/flux/components/source/gitrepositories/#git-implementation)
> in the flux documentation.

For an example using the Tanzu CLI to create a Workload using GitHub as the provider of source code,
see [Create a workload from GitHub
repository](../cli-plugins/apps/create-workload.hbs.md#-create-a-workload-from-github-repository).

For information about GitRepository objects, see
[GitRepository](https://fluxcd.io/flux/components/source/gitrepositories/).

### ImageRepository

You use ImageRepository when fetching source code from container images. It
makes the contents of the container image available as a tarball to further
resources in the supply chain. The contents of the container image
are fetched using Git or Maven.

Parameters:

<table>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>serviceAccount<code></td>
    <td>
      Name of the service account, providing credentials to `ImageRepository` for fetching container images.
      The service account must exist in the same namespace as the Workload.
    </td>
    <td>
      <pre>
      - name: serviceAccount
        value: default
      </pre>
    </td>
  </tr>

</table>

For information about the ImageRepository resource, see [ImageRepository reference
docs](../source-controller/reference.hbs.md#imagerepository).

For information about how to use the Tanzu CLI to create a workload leveraging ImageRepository refer to
[Create a workload from local source
code](../cli-plugins/apps/create-workload.hbs.md#-create-a-workload-from-local-source-code).

> **Note** When using the Tanzu CLI to configure this `serviceAccount` parameter, use `--param serviceAccount=...`.
> (The similarly named `--service-account` flag sets a different value:
> the `spec.serviceAccountName` key in the Workload object.)

### MavenArtifact

When carrying pre-built Java artifacts, `MavenArtifact` makes the artifact available to
further resources in the supply chain as a tarball. You can wrap the tarball as
a container image for further deployment.

Differently from `git` and `image`, its configuration is solely driven by
parameters in the Workload.

Parameters:

<table>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>maven<code></td>
    <td>
      Points to the Maven artifact to fetch and the polling interval.
    </td>
    <td>
      <pre>
      - name: maven
        value:
          artifactId: springboot-initial
          groupId: com.example
          version: RELEASE
          classifier: sources         # optional
          type: jar                   # optional
          artifactRetryTimeout: 1m0s  # optional
      </pre>
    </td>
  </tr>
</table>

For information about the
custom resource, see [MavenArtifact reference
docs](../source-controller/reference.hbs.md#mavenartifact).

For information about how to use the custom resource with the `tanzu apps workload` CLI plug-in [Create a Workload from Maven repository
artifact](../cli-plugins/apps/create-workload.hbs.md#workload-maven).

## source-tester

The `source-tester` resource is in the `ootb-supply-chain-testing` and
`ootb-supply-chain-testing-scanning` supply chains.
As implied by the name, it depends on the source-provider resource and is intended to run tests against
source code revisions.

The resource creates a [Runnable](https://cartographer.sh/docs/v0.4.0/reference/runnable/)
object. This Runnable object ensures that a new [Tekton
PipelineRun](https://tekton.dev/docs/pipelines/pipelineruns/) object is created with every change to
the resource's inputs. The PipelineRun calls the execution of a Tekton Pipeline which is in the same
namespace as the Workload.

Parameters:

<table>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>testing_pipeline_matching_labels<code></td>
    <td>
      Set of labels to use when searching for Tekton Pipeline objects in the
      same namespace as the Workload. By default, a Pipeline labeled as
      `apps.tanzu.vmware.com/pipeline: test` is selected, but when using
      this parameter, it's possible to override the behavior.
    </td>
    <td>
      <pre>
      - name: testing_pipeline_matching_labels
        value:
          apps.tanzu.vmware.com/pipeline: test
          my.company/language: golang
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>testing_pipeline_params<code></td>
    <td>
      Set of extra parameters, aside from `source-url` and
      `source-revision`, to pass to the Tekton Pipeline. The Tekton Pipeline
      <b>must</b> declare both the required parameters `source-url` and
      `source-revision` as well the extra ones declared in this table.
    </td>
    <td>
      <pre>
      - name: testing_pipeline_params
        value:
        - name: verbose
          value: true
      </pre>
    </td>
  </tr>

</table>

For information about how to set up the
Workload namespace for testing with Tekton, see [Out of the Box Supply Chain with
Testing](ootb-supply-chain-testing.hbs.md).

For information about how to use the parameters to customize this resource to
test using a Jenkins cluster, see [Out of the Box Supply Chain
with Testing on Jenkins](ootb-supply-chain-testing-with-jenkins.hbs.md).

## source-scanner

The `source-scanner` resource, used only in the
`ootb-supply-chain-testing-scanning` supply chain, scans the source code by pointing a
[SourceScan](../scst-scan/scan-crs.hbs.md#sourcescan) object at the same source
code as the tests.

You can customize behavior for both [CVEs evaluation](../scst-scan/policies.hbs.md) with parameters.

Parameters:

<table>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>scanning_source_template<code></td>
    <td>
      Name of the ScanTemplate object in the same namespace as the Workload to
      use for running the scans against the source code.
    </td>
    <td>
      <pre>
      - name: scanning_source_template
        value: private-source-scan-template
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>scanning_source_policy<code></td>
    <td>
      Name of the ScanPolicy object in the same namespace as the Workload to
      use when evaluating the scan results of a source scan.
    </td>
    <td>
      <pre>
      - name: scanning_source_policy
        value: allowlist-policy
      </pre>
    </td>
  </tr>
</table>

See [Out of the Box Supply Chain with Testing and
Scanning](ootb-supply-chain-testing-scanning.hbs.md) for details about how to
set up the Workload namespace with the ScanPolicy and ScanTemplate required for
this resource, and [SourceScan reference](../scst-scan/scan-crs.hbs.md#sourcescan)
for details about the SourceScan custom resource.

For information about how the artifacts found
during scanning are catalogued, see [Supply Chain Security Tools for Tanzu –
Store](../scst-store/overview.hbs.md).

## image-provider

The `image-provider` provides a container image of the built application.

Different parameters apply depending on how the Workload is configured (for example, when using [pre-built
images](pre-built-image.hbs.md) vs [building from
source](building-from-source.hbs.md)):

- Building from source: an object is created to build an image from the earlier source steps. This object is either a:
  - Kpack Image for building with Cloud Native Buildpacks. [Read more]((#kpack-image))
  - Tekton TaskRun for building images from Dockerfiles. [Read more](#taskruns-for-dockerfile-based-builds)

- Pre-built: an `ImageRepository` object is created to fetch the specified image from an image registry.
  [Read more](#pre-built-image-imagerepository)

### Kpack Image

The Kpack Image object provides a means for building a container image out of source code or pre-built Java artifact.
See [About Tanzu Build Service](../tanzu-build-service/tbs-about.hbs.md).

Parameters:

<table>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>serviceAccount<code></td>
    <td>
      Name of the service account providing credentials for the configured image registry.
      `Image` will use these credentials to push built container images to the registry.
      The service account must exist in the same namespace as the Workload.
    </td>
    <td>
      <pre>
      - name: serviceAccount
        value: default
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>clusterBuilder<code></td>
    <td>
      Name of the Kpack cluster builder to use in the Kpack Image
      object created.
    </td>
    <td>
      <pre>
      - name: clusterBuilder
        value: nodejs-cluster-builder
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>buildServiceBindings<code></td>
    <td>
      Definition of a list of service bindings to make use at build time. For example,
      providing credentials for fetching dependencies from
      repositories that require credentials.
    </td>
    <td>
      <pre>
      - name: buildServiceBindings
        value:
          - name: settings-xml
            kind: Secret
            apiVersion: v1
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>live-update<code></td>
    <td>
      enable the use of Tilt's live-update function.
    </td>
    <td>
      <pre>
      - name: live-update
        value: "true"
      </pre>
    </td>
  </tr>

</table>

> **Note** When using the Tanzu CLI to configure this `serviceAccount` parameter, use `--param serviceAccount=...`.
> (The similarly named `--service-account` flag sets a different value:
> the `spec.serviceAccountName` key in the Workload object.)

For information about
the integration with Tanzu Build Service, see [Tanzu Build Service Integration](tbs.hbs.md).

For information about `live-update`, see [Developer Conventions](../developer-conventions/about.hbs.md) and [Overview of Tanzu Developer Tools for IntelliJ](../intellij-extension/about.hbs.md).

For information about using Kpack builders with `clusterBuilder`, see [Builders](https://github.com/pivotal/kpack/blob/main/docs/builders.md).

For information about `buildServiceBindings`, see [Service
Bindings](https://github.com/pivotal/kpack/blob/main/docs/servicebindings.md).

### TaskRuns for Dockerfile-based builds

To perform Dockerfile-based builds, all the supply chains
instantiate Tekton TaskRun objects to call the execution of
[kaniko](https://github.com/GoogleContainerTools/kaniko) builds.

Parameters:

<table>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>dockerfile<code></td>
    <td>relative path to the Dockerfile file in the build context</td>
    <td><pre>./Dockerfile</pre></td>
  </tr>

  <tr>
    <td><code>docker_build_context<code></td>
    <td>relative path to the directory where the build context is</td>
    <td><pre>.</pre></td>
  </tr>

  <tr>
    <td><code>docker_build_extra_args<code></td>
    <td>
      List of flags to pass directly to kaniko,such as providing arguments to a build.
    </td>
    <td><pre>- --build-arg=FOO=BAR</pre></td>
  </tr>

  <tr>
    <td><code>serviceAccount<code></td>
    <td>
      Name of the service account to use for providing Docker credentials.
      The service account must exist in the same namespace as the Workload.
      The service account must have a secret associated with the credentials.
      See <a href="https://tekton.dev/docs/pipelines/auth/#configuring-authentication-for-docker">Configuring
      authentication for Docker</a> in the Tekton documentation.
    </td>
    <td>
      <pre>
      - name: serviceAccount
        value: default
      </pre>
    </td>
  </tr>
</table>

For information about how to use Dockerfile-based builds and limits associated with the function, see
[Dockerfile-based builds](dockerfile-based-builds.hbs.md).

### Pre-built image (ImageRepository)

Developers may choose to build their application outside of the supply chain.
In this case, they would provide an image reference under `workload.spec.image`.
An `ImageRepository` object is created to fetch images pushed under that name.
This makes the content-addressable name, such as the image name containing the digest,
available for further resources in the supply chain.

Parameters:

<table>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>serviceAccount<code></td>
    <td>
      name of the serviceaccount to use for providing the necessary credentials to `ImageRepository` for fetching
      the container images.
      The service account must exist in the same namespace as the Workload.
    </td>
    <td>
      <pre>
      - name: serviceAccount
        value: default
      </pre>
    </td>
  </tr>
</table>

> **Note** When using the Tanzu CLI to configure this `serviceAccount` parameter, use `--param serviceAccount=...`.
> (The similarly named `--service-account` flag sets a different value:
> the `spec.serviceAccountName` key in the Workload object.)

For information about the
ImageRepository resource, see [ImageRepository reference
docs](../source-controller/reference.hbs.md#imagerepository).
For information about the prebuild image function, see [Using a prebuilt
image](pre-built-image.hbs.md).

## image-scanner

The `image-scanner` resource is used by the `ootb-supply-chain-testing-scanning` supply chain.
This resource is responsible for creating an `ImageScan` object. This object scans the container image,
persists the results in a store, and prevents the image from moving
forward if CVEs are found which are not compliant with its referenced ScanPolicy.

Parameters:

<table>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>scanning_image_template<code></td>
    <td>
      Name of the ScanTemplate object for running the scans against a container image.
      The ScanTemplate must be in the same namespace as the Workload.
    </td>
    <td>
      <pre>
      - name: scanning_image_template
        value: private-image-scan-template
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>scanning_image_policy<code></td>
    <td>
      Name of the ScanPolicy object for evaluating the scan results of an image scan.
      The ScanPolicy must be in the same namespace as the Workload.
    </td>
    <td>
      <pre>
      - name: scanning_image_policy
        value: allowlist-policy
      </pre>
    </td>
  </tr>
</table>

For information about the ImageScan custom resource, see [ImageScan reference](../scst-scan/scan-crs.hbs.md#imagescan).

For information about how the artifacts found
during scanning are catalogued, see [Supply Chain Security Tools for Tanzu –
Store](../scst-store/overview.hbs.md).

## config-provider

The `config-provider` resource creates a [PodIntent](../cartographer-conventions/reference/pod-intent.hbs.md)
object. The PodIntent leverages conventions installed on the cluster. Teh PodIntent object is responsible for
generating a PodTemplateSpec. The PodTemplateSpec is used in app configs, such as knative services and deployments,
to represent the shape of the pods to run the application in containers. See
[PodTemplateSpec](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-template-v1/#PodTemplateSpec)
in the Kubernetes documentation.

Parameters:

<table>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>serviceAccount<code></td>
    <td>
      Name of the serviceAccount providing necessary credentials to `PodIntent`.
      The serviceAccount must be in the same namespace as the Workload.
      The serviceAccount is set as the `serviceAccountName` in the podtemplatespec.
      The credentials associated with the serviceAccount must allow fetching the container image
      used to inspect the metadata passed to convention servers.
    </td>
    <td>
      <pre>
      - name: serviceAccount
        value: default
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>annotations<code></td>
    <td>
     Extra set of annotations to pass down to the PodTemplateSpec.
    </td>
    <td>
      <pre>
      - name: annotations
        value:
          name: my-application
          version: v1.2.3
          team: store
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>debug<code></td>
    <td>
      Put the workload in debug mode.
    </td>
    <td>
      <pre>
      - name: debug
        value: "true"
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>live-update<code></td>
    <td>
      Enable live-updating of the code (for innerloop development).
    </td>
    <td>
      <pre>
      - name: live-update
        value: "true"
      </pre>
    </td>
  </tr>
</table>

> **Note** When using the Tanzu CLI to configure this `serviceAccount` parameter, use `--param serviceAccount=...`.
> (The similarly named `--service-account` flag sets a different value:
> the `spec.serviceAccountName` key in the Workload object.)

See [Cartographer Conventions](../cartographer-conventions/about.hbs.md) to know
more about the controller behind `PodIntent`.

See [Developer
Conventions](../developer-conventions/about.hbs.md) and [Spring Boot
Conventions](../spring-boot-conventions/about.hbs.md) for more details about the two
convention servers enabled by default in Tanzu Application Platform installations.


## app-config

The `app-config` resource is responsible for creating a ConfigMap. Into the .data field of the ConfigMap it will write
Kubernetes configuration (k8s object definitions) that instantiate the application.

The resource is configured to allow three types of workloads. Which workload type is created is configured through the
labels set on the Workload object created by the developer:

- `apps.tanzu.vmware.com/workload-type: web`
- `apps.tanzu.vmware.com/workload-type: worker`
- `apps.tanzu.vmware.com/workload-type: server`

Only the `server` workload type has the following configurable parameters:

<table>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>ports<code></td>
    <td>
      Set of network ports to expose from the application to the Kubernetes
      cluster.
    </td>
    <td>
      <pre>
      - name: ports
        value:
          - containerPort: 2025
            name: smtp
            port: 25
      </pre>
    </td>
  </tr>
</table>


See [workload types](../workloads/workload-types.hbs.md) for more details about the
three different types of workloads, and [`server`-specific Workload
parameters](../workloads/server.hbs.md#-server-specific-workload-parameters) for a
more detailed overview of the ports parameter.

## service-bindings

The `service-bindings` resource adds
[ServiceBindings](../service-bindings/about.hbs.md) to the set of Kubernetes
configuration files.

Parameters:

<table>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>annotations<code></td>
    <td>
     Extra set of annotations to pass down to the ServiceBinding and
     ResourceClaim objects.
    </td>
    <td>
      <pre>
      - name: annotations
        value:
          name: my-application
          version: v1.2.3
          team: store
      </pre>
    </td>
  </tr>
</table>

For an example, see
[`--service-ref`](../cli-plugins/apps/command-reference/workload_create_update_apply.hbs.md#apply-service-ref)
in the Tanzu CLI documentation.
For an overview of the function, see
[Consume services on Tanzu Application Platform](../getting-started/consume-services.hbs.md).

## apidescriptors

The `api-descriptor` resource takes care of adding an
[APIDescriptor](../api-auto-registration/key-concepts.hbs.md) to the set of
Kubernetes objects to deploy such that API auto registration takes place.

Parameters:

<table>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>annotations<code></td>
    <td>
     Extra set of annotations to pass down to the APIDescriptor object.
    </td>
    <td>
      <pre>
      - name: annotations
        value:
          name: my-application
          version: v1.2.3
          team: store
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>api_descriptor<code></td>
    <td>
     Information used to fill the state that you want of the APIDescriptor object
    (its spec).
    </td>
    <td>
      <pre>
      - name: api_descriptor
        value:
          type: openapi
          location:
            baseURL: http://petclinic-hard-coded.my-apps.tapdemo.vmware.com/
            path: "/v3/api
          owner: team-petclinic
          system: pet-clinics
          description: "example"
      </pre>
    </td>
  </tr>
</table>

> **Note** it's required that the Workload include the
> `apis.apps.tanzu.vmware.com/register-api: "true"` label to activate
> this function.

See [Use API Auto Registration](../api-auto-registration/usage.hbs.md) for more
details about API auto registration.

## config-writer (git or registry)

The `config-writer` resource is responsible for performing the last mile of the
supply chain: persisting in an external system (registry or git repository) the
Kubernetes configuration generated throughout the supply chain.

It can do so in three distinct manners:

- publishing the configuration to a container image registry
- publishing the configuration to a Git repository
  - pushing a commit to a branch (e.g. main), or
  - pushing a commit to a branch (e.g. feature_branch) _and_ opening a pull request to another (e.g. main)

Details about the different modes of operation are found in [Gitops vs
RegistryOps](gitops-vs-regops.hbs.md) with the parameters documented in
place.

## deliverable

The `deliverable` resource is responsible for creating a `Deliverable` object
that represents the intention of delivering to the cluster the configuration
that are produced by the supply chain.

Parameters:

<table>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>serviceAccount<code></td>
    <td>
      Name of the service account (in the same namespace as the Deliverable) to
      use for providing the necessary permissions to create the children
      objects for deploying the objects created by the supply chain to the
      cluster.
    </td>
    <td>
      <pre>
      - name: serviceAccount
        value: default
      </pre>
    </td>
  </tr>
</table>

> **Note** When using the Tanzu CLI to configure this `serviceAccount` parameter, use `--param serviceAccount=...`.
> (The similarly named `--service-account` flag sets a different value:
> the `spec.serviceAccountName` key in the Workload object.)

> **Note** On build clusters where a corresponding `ClusterDelivery` doesn't
> exist, the Deliverable takes no effect (similarly to a Workload without a
> SupplyChain, no action is taken).

## Deliverable Parameters reference

This section describes the parameters that are provided to the
Deliverable object, such as what is set on `deliverable.spec.params`.

The Deliverable is relevant in the context of deploying to a Kubernetes cluster
that the configuration that is produced through the resources defined by
a ClusterSupplyChain:

```console
      Workload              (according to ClusterSupplyChain in `build` cluster)

        - fetch source
        - build
        - test
        - scan
        - generate kubernetes config
        - push k8s config to git repository / image registry


      Deliverable           (according to ClusterDelivery in `run` cluster)

        - fetch kubernetes config (from git repository / image registry)
        - apply kubernetes objects to cluster

```

In the following section, you find the reference documentation that relates specifically to the
two resources defined in the `basic` ClusterDelivery part of the
`ootb-delivery-basic` package:

```console
source-provider                     fetches kubernetes configuration
    |
    |  kubernetes configuration
    |
app-deploy                          deploys to the cluster the objects in the
                                    kubernetes configuration fetched
```

For information about the ClusterDelivery shipped with `ootb-delivery-basic`,
and the templates used by it, see:

- [Out of the Box Delivery Basic](ootb-delivery-basic.hbs.md)
- [Out of the Box Templates](ootb-templates.hbs.md)

For information about the use of the Deliverable object in a multicluster
environment, see [Getting started with multicluster Tanzu Application
Platform](../multicluster/getting-started.hbs.md).

For reference information about Deliverable, see [Deliverable and Delivery
custom resources](https://cartographer.sh/docs/v0.5.0/reference/deliverable/).

## source provider

The `source-provider` resource in the basic ClusterDelivery creates objects
that continuously fetches Kubernetes configuration files from a Git repository
or container image registry so that it can apply those to the cluster.

Regardless of where it fetches that Kubernetes configuration from, Git
repository or container image registry, it exposes those files to further resources along
the ClusterDelivery as a tarball.

### GitRepository

A GitRepository object is instantiated when `deliverable.spec.source.git`
is configured to continuously look for a Kubernetes
configuration pushed to a Git repository, making it available for
resources in the ClusterDelivery.

Parameters:

<table>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>gitImplementation<code></td>
    <td>
      VMware recommends that you use the underlying library for fetching the
      source code.  Either <code>libggit2</code>, required for Azure DevOps, or
      <code>go-git</code>.
    </td>
    <td>
      <pre>
      - name: gitImplementation
        value: libggit2
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_ssh_secret<code></td>
    <td>
      Name of the secret in the same namespace as the <code>Deliverable</code> used for
      providing credentials for fetching Kubernetes configuration files from
      the Git repository pointed at.<br><br>
      For more information, see <a href="git-auth.html">Git authentication</a>.
    </td>
    <td>
      <pre>
      - name: gitops_ssh_secret
        value: git-credentials
      </pre>
    </td>
  </tr>
</table>

> **Note** It might not be necessary to change the default Git implementation
> but some providers, such as Azure DevOps, require you to use `libgit2` due to
> the server-side implementation providing support only for [Git v2
> protocol](https://git-scm.com/docs/protocol-v2). For information about the
> features supported by each implementation, see [Git
> implementation](https://fluxcd.io/flux/components/source/gitrepositories/#git-implementation) in the flux documentation.

For information about how to create a Workload that uses a GitHub
repository as the provider of source code, see [Create a workload from GitHub
repository](../cli-plugins/apps/create-workload.hbs.md#-create-a-workload-from-github-repository).

For information about GitRepository objects, see
[GitRepository](https://fluxcd.io/flux/components/source/gitrepositories/).

### ImageRepository

An ImageRepository object is instantiated when
`deliverable.spec.source.image` is configured to continuously
look for Kubernetes configuration files pushed to a container image registry
as opposed to a Git repository.

Parameters:

<table>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>serviceAccount<code></td>
    <td>
      Name of the service account, in the same namespace as the Deliverable, you
      want to use to provide the necessary permissions for `kapp-controller` to
      deploy the objects to the cluster.
    </td>
    <td>
      <pre>
      - name: serviceAccount
        value: default
      </pre>
    </td>
  </tr>

</table>

For information about custom resource details, see [ImageRepository reference
docs](../source-controller/reference.hbs.md#imagerepository).

> **Note** When using the Tanzu CLI to configure this `serviceAccount` parameter, use `--param serviceAccount=...`.
> (The similarly named `--service-account` flag sets a different value:
> the `spec.serviceAccountName` key in the Workload object.)

## app deployer

The `app-deploy` resource in the ClusterDelivery is responsible for applying the
Kubernetes configuration that is built by the supply chain, pushed to
either a Git repository or image repository, and applied to the cluster.

### App

Regardless of where the configuration comes from, an
[`App`](https://carvel.dev/kapp-controller/docs/v0.41.0/app-overview/) object is
instantiated to deploy the set of Kubernetes configuration files to the cluster.

Parameters:

<table>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>serviceAccount<code></td>
    <td>
      Name of the service account, in the same namespace as the Deliverable,
      you want to use to provide the necessary privileges for `App` to apply
      the Kubernetes objects to the cluster.
    </td>
    <td>
      <pre>
      - name: serviceAccount
        value: default
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_sub_path<code> (deprecated)</td>
    <td>
      Sub directory within the configuration bundle that is used for
      looking up the files to apply to the Kubernetes cluster.
    </td>
    <td>
      <pre>
      - name: gitops_sub_path
        value: ./config
      </pre>
    </td>
  </tr>

</table>

> **Note** The `gitops_sub_path` parameter is deprecated. Use `deliverable.spec.source.subPath` instead.

> **Note** When using the Tanzu CLI to configure this `serviceAccount` parameter, use `--param serviceAccount=...`.
> (The similarly named `--service-account` flag sets a different value:
> the `spec.serviceAccountName` key in the Workload object.)

For details about RBAC and how `kapp-controller` makes use of the ServiceAccount provided via the Deliverable's
`serviceAccount` parameter,
see [`kapp-controller`'s Security Model](https://carvel.dev/kapp-controller/docs/v0.41.0/security-model/).
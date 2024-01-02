# Parameter reference

This topic tells you about the default supply chains and templates provided by Tanzu Application Platform (commonly known as TAP). It describes the `workload.spec.params` parameters that are configured in workload objects, and the `deliverable.spec.params` parameters that are configured
in the deliverable object.

## <a id="workload-parameter"></a> Workload Parameter Reference

The supply chains and templates provided by the Out of the Box packages contain a series of
parameters that customize supply chain behavior. This section describes the `workload.spec.params`
parameters that can be configured in workload objects. The following table provides a list of supply
chain resources organized by the resource in the supply chain where they are used. Some of these
resources might not be applicable depending on the supply chain in use.

### List of Supply Chain Resources for Workload Object

| Supply Chain Resource                 | Output Type              | Purpose                                                                                         | Basic | Testing | Scanning |
|---------------------------------------|--------------------------|-------------------------------------------------------------------------------------------------|-------|---------|----------|
| [source-provider](#source-provider)   | Source                   | Fetches source code                                                                             | Yes   | Yes     | Yes      |
| [source-tester](#source-tester)       | Source                   | Tests source code                                                                               | No    | Yes     | Yes      |
| [source-scanner](#source-scanner)     | Source                   | Scans source code                                                                               | No    | No      | Yes      |
| [image-provider](#image-provider)     | Image                    | Builds application container image                                                              | Yes   | Yes     | Yes      |
| [image-scanner](#image-scanner)       | Image                    | Scans application container image                                                               | No    | No      | Yes      |
| [config-provider](#config-provider)   | Podtemplate spec         | Tailors a pod spec based on the application image and conventions set up in the cluster         | Yes   | Yes     | Yes      |
| [app-config](#app-config)             | Kubernetes configuration | Creates Kubernetes config files (knative service/deployment - depending on workload type)       | Yes   | Yes     | Yes      |
| [service-bindings](#service-bindings) | Kubernetes configuration | Adds service bindings to the set of config files                                                | Yes   | Yes     | Yes      |
| [api-descriptors](#api-descriptors)   | Kubernetes configuration | Adds api descriptors to the set of config files                                                 | Yes   | Yes     | Yes      |
| [config-writer](#config-writer)       | Kubernetes configuration | Writes configuration to a destination (git or registry) for further deployment to a run cluster | Yes   | Yes     | Yes      |
| [deliverable](#deliverable)           | Kubernetes configuration | Writes deliverable content to be extracted for use in a run cluster                             | Yes   | Yes     | Yes      |

For information about supply chains, see:

- [Out of the Box Supply Chain Basic](../scc/ootb-supply-chain-basic.hbs.md)
- [Out of the Box Supply Chain Testing](../scc/ootb-supply-chain-testing.hbs.md)
- [Out of the Box Supply Chain Testing Scanning](../scc/ootb-supply-chain-testing-scanning.hbs.md)
### <a id="source-provider"></a>source-provider

The `source-provider` resource in the supply chain creates objects that fetch either source code or
pre-compiled Java applications depending on how the workload is configured.
For more information, see [Building from Source](../scc/building-from-source.hbs.md).

#### GitRepository

Use `gitrepository` when fetching source code from Git repositories. This resource makes further
resources available in the supply chain, such as the contents of the Git repository as a tarball
available in the cluster.

Parameters:

<table>
  <thead>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>
  </thead>
  <tbody>
  <tr>
    <td><code>gitImplementation</code></td>
    <td>
      VMware recommends that you use the underlying library for fetching the source code.
      Either <code>libgit2</code>, required for Azure DevOps, or
      <code>go-git</code>.
    </td>
    <td>
      <pre>
      - name: gitImplementation
        value: libgit2
      </pre>
    </td>
  </tr>
  <tr>
    <td><code>gitops_ssh_secret</code></td>
    <td>
      The name of the secret in the same namespace as the `Workload` used for
      providing credentials for fetching source code from the Git repository.
      For more information, see <a href="../scc/git-auth.hbs.md">Git authentication</a>.
    </td>
    <td>
      <pre>
      - name: gitops_ssh_secret
        value: git-credentials
      </pre>
    </td>
  </tr>
  </tbody>
</table>

It might not be necessary to change the default Git  implementation, but some providers such as
Azure DevOps, require you to use `libgit2` as the server-side implementation provides support
 only for [git's v2 protocol](https://git-scm.com/docs/protocol-v2).

For information about the features supported by each implementation, see
[Git implementation](https://fluxcd.io/flux/components/source/gitrepositories/#git-implementation) in the Flux documentation.

For information about how to create a workload that uses a GitHub
repository as the provider of source code, see [Create a workload from GitHub
repository](../cli-plugins/apps/create-workload.hbs.md#workload-local-source).

For more information about GitRepository objects, see
[Git Repository](https://fluxcd.io/flux/components/source/gitrepositories/) in the Flux documentation.

#### ImageRepository

Use the ImageRepository when fetching source code from container images. It
makes the contents of the container image available as a tarball to further
resources in the supply chain. The contents of the container image
are fetched by using Git or Maven.
For more information, see [Create a workload
from local source code](../cli-plugins/apps/create-workload.hbs.md#workload-local-source).

Parameters:

<table>
  <thead>
  <tr>
    <th>Parameter Name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>
  </thead>
  <tbody>
  <tr>
    <td><code>serviceAccount</code></td>
    <td>
      The name of the service account (in the same namespace as the workload) to use
      to provide the credentials to `ImageRepository` for fetching
      the container images.
    </td>
    <td>
      <pre>
      - name: serviceAccount
        value: default
      </pre>
    </td>
  </tr>
  </tbody>
</table>

The `--service-account` flag sets the `spec.serviceAccountName` key in the workload object. To
configure the `serviceAccount` parameter, use `--param serviceAccount=SERVICE-ACCOUNT`.

For information about custom resource details, see [ImageRepository](../source-controller/reference.hbs.md#imagerepository) reference topic.

For information about how to use ImageRepository with the Tanzu
CLI, see [Create a workload](../cli-plugins/apps/create-workload.hbs.md#cli-plugins).
#### MavenArtifact

When carrying pre-built Java artifacts, `MavenArtifact` makes the artifact available to
further resources in the supply chain as a tarball. You can wrap the tarball as
a container image for further deployment. Differently from `git` and `image`, its configuration
is solely driven by parameters in the workload.

Parameters:

<table>
  <thead>
  <tr>
    <th>Parameter Name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>
  </thead>
  <tbody>
  <tr>
    <td><code>maven</code></td>
    <td>
      Points to the maven artifact to fetch and the polling interval.
    </td>
    <td>
      <pre>
      - name: maven
        value:
          artifactId: springboot-initial
          groupId: com.example
          version: RELEASE
          classifier: sources         # optional
          type: # optional
          artifactRetryTimeout: 1m0s  # optional
      </pre>
    </td>
  </tr>
  </tbody>
</table>

For information about the
custom resource, see [MavenArtifact reference
docs](../source-controller/reference.hbs.md#mavenartifact).

For information about how to use the custom resource with the `tanzu apps workload` CLI
plug-in, see [Create a workload from Maven repository
artifact](../cli-plugins/apps/create-workload.hbs.md#workload-maven).

### <a id="source-tester"></a>source-tester

The `source-tester` resource is in `ootb-supply-chain-testing` and
`ootb-supply-chain-testing-scanning`. This resource is responsible for instantiating a
Tekton [PipelineRun](https://tekton.dev/docs/pipelines/pipelineruns/) object that
calls the execution of a Tekton Pipeline, in the same namespace as the
workload, whenever its inputs change. For example, the source code revision that you want to test changes.

A [Runnable](https://cartographer.sh/docs/v0.4.0/reference/runnable/)
object is instantiated to ensure that there's always a run for a particular set
of inputs. The parameters are passed from the workload down to Runnable's
Pipeline selection mechanism through `testing_pipeline_matching_labels` and the
execution of the PipelineRuns through `testing_pipeline_params`.

Parameters:

<table>
  <thead>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>
  </thead>
  <tbody>
  <tr>
    <td><code>testing_pipeline_matching_labels</code></td>
    <td>
      The set of labels to use when searching for Tekton Pipeline objects in the
      same namespace as the workload. By default, a Pipeline labeled as
      `apps.tanzu.vmware.com/pipeline: test` is selected, but when using
      this parameter, it's possible to override the behavior.
    </td>
    <td>
      <pre>
      - name: testing_pipeline_matching_labels
        value:
          apps.tanzu.com/pipeline: test
          my.company/language: golang
      </pre>
    </td>
  </tr>
  <tr>
    <td><code>testing_pipeline_params</code></td>
    <td>
      The set of extra parameters, aside from `source-url` and
      `source-revision`, to pass to the Tekton Pipeline. The Tekton Pipeline
      <b>must</b> declare both the required parameters `source-url` and
      `source-revision` and the extra ones declared in this table.
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
  </tbody>
</table>

For information about how to set up the
Workload namespace for testing with Tekton, see [Out of the Box Supply Chain with
Testing](../scc/ootb-supply-chain-testing.hbs.md).

For information about how to use the parameters to customize this resource to
test using a Jenkins cluster, see [Out of the Box Supply Chain
with Testing on Jenkins](../scc/ootb-supply-chain-testing-with-jenkins.hbs.md).

### <a id="source-scanner"></a>source-scanner

The `source-scanner` resource is available in
`ootb-supply-chain-testing-scanning`. It scans the source code
that is tested by pointing a
[SourceScan](../scst-scan/scan-crs.hbs.md#sourcescan) object at the same source
code as the tests.

You can customize behavior for both [CVEs evaluation](../scst-scan/policies.hbs.md) with parameters.

Parameters:

<table>
  <thead>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>
  </thead>
  <tbody>
  <tr>
    <td><code>scanning_source_template</code></td>
    <td>
      The name of the ScanTemplate object (in the same namespace as the workload) to
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
    <td><code>scanning_source_policy</code></td>
    <td>
      The name of the ScanPolicy object (in the same namespace as the workload) to
      use when evaluating the scan results of a source scan.
    </td>
    <td>
      <pre>
      - name: scanning_source_policy
        value: allowlist-policy
      </pre>
    </td>
  </tr>
  </tbody>
</table>

For more information, see [Out of the Box Supply Chain with Testing and
Scanning](../scc/ootb-supply-chain-testing-scanning.hbs.md) for details about how to
set up the workload namespace with the ScanPolicy and ScanTemplate required for
this resource, and [SourceScan reference](../scst-scan/scan-crs.hbs.md#sourcescan)
for details about the SourceScan custom resource.

For information about how the artifacts found
during scanning are catalogued, see [Supply Chain Security Tools for Tanzu –
Store](../scst-store/overview.hbs.md).

### <a id="image-provider"></a>image-provider

The `image-provider` in the supply chains provides a
container image carrying the application already built to further resources.

Different semantics apply, depending on how the workload is configured, for example, if using [pre-built
images](../scc/pre-built-image.hbs.md) or [building from
source](../scc/building-from-source.hbs.md):

- pre-built: an `ImageRepository` object is created aiming at providing a
  reference to the latest image found matching the name as specified in
  `workload.spec.image`

- building from source: an image builder object is created (either Kpack's
  `Image` or a `Runnable` for creating Tekton TaskRuns for building images from
  Dockerfiles)

#### Kpack Image

Use the Kpack Image object to build a
container image out of source code or pre-built Java artifact. This makes the
container image available to further resources in the supply chain through a
content addressable image reference that's carried to the final
deployment objects unchanged.
For more information, see [Tanzu Build Service](../tanzu-build-service/tbs-about.hbs.md).

Parameters:

<table>
  <thead>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>
  </thead>
  <tbody>
  <tr>
    <td><code>serviceAccount</code></td>
    <td>
      The name of the serviceaccount (in the same namespace as the workload) to use
      for providing credentials to `Image` for pushing the
      container images it builds to the configured registry.
    </td>
    <td>
      <pre>
      - name: serviceAccount
        value: default
      </pre>
    </td>
  </tr>
  <tr>
    <td><code>clusterBuilder</code></td>
    <td>
      The name of the Kpack cluster builder to use in the Kpack Image
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
    <td><code>buildServiceBindings</code></td>
    <td>
      The definition of a list of service bindings to use at build time. For example,
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
    <td><code>live-update</code></td>
    <td>
      Enables the use of Tilt's live-update function.
    </td>
    <td>
      <pre>
      - name: live-update
        value: "true"
      </pre>
    </td>
  </tr>
  </tbody>
</table>

The `--service-account` flag sets the `spec.serviceAccountName` key in  the workload object.
To configure the `serviceAccount` parameter, use  `--param serviceAccount=SERVICE-ACCOUNT`.

For information about
the integration with Tanzu Build Service, see [Tanzu Build Service Integration](../scc/tbs.hbs.md).

For information about `live-update`, see [Developer Conventions](../developer-conventions/about.hbs.md)
and [Overview of Tanzu Developer Tools for IntelliJ](../intellij-extension/about.hbs.md).

For information about using Kpack builders with `clusterBuilder`,
see [Builders](https://github.com/pivotal/kpack/blob/main/docs/builders.md).

For information about `buildServiceBindings`, see [Service
Bindings](https://github.com/pivotal/kpack/blob/main/docs/servicebindings.md).

#### Runnable (TaskRuns for Dockerfile-based builds)

To perform Dockerfile-based builds, all the supply chains instantiate a Runnable object that
instantiates Tekton TaskRun objects to call the execution of [kaniko](https://github.com/GoogleContainerTools/kaniko)  builds.

Parameters:

<table>
  <thead>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>
  </thead>
  <tbody>
  <tr>
    <td><code>dockerfile</code></td>
    <td>The relative path to the Dockerfile file in the build context.</td>
    <td><pre>./Dockerfile</pre></td>
  </tr>
  <tr>
    <td><code>docker_build_context</code></td>
    <td>The relative path to the directory where the build context is.</td>
    <td><pre>.</pre></td>
  </tr>
  <tr>
    <td><code>docker_build_extra_args</code></td>
    <td>
      List of flags to pass directly to Kaniko, such as providing arguments to a build.
    </td>
    <td><pre>- --build-arg=FOO=BAR</pre></td>
  </tr>
  </tbody>
</table>

For information about how to use Dockerfile-based builds and limitations associated with the function,
see [Dockerfile-based builds](../scc/dockerfile-based-builds.hbs.md).

#### Pre-built image (ImageRepository)

For applications that already have their container images built outside
the supply chains, such as providing an image reference under
`workload.spec.image`, an `ImageRepository` object is created to keep track of
any images pushed under that name. This makes the content-addressable name, such as
the image name containing the digest, available for further resources in the
supply chain.

Parameters:

<table>
  <thead>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>
  </thead>
  <tbody>
  <tr>
    <td><code>serviceAccount</code></td>
    <td>
      The name of the serviceaccount (in the same namespace as the workload) to use
      for providing the credentials to `ImageRepository` for fetching
      the container images.
    </td>
    <td>
      <pre>
      - name: serviceAccount
        value: default
      </pre>
    </td>
  </tr>
  </tbody>
</table>

The `--service-account` flag sets the `spec.serviceAccountName` key in the workload object. To
configure the `serviceAccount` parameter, use  `--param serviceAccount=...`.

For information about the
ImageRepository resource, see [ImageRepository reference
docs](../source-controller/reference.hbs.md#imagerepository).
For information about the prebuild image function, see [Using a prebuilt
image](../scc/pre-built-image.hbs.md).

### <a id="image-scanner"></a>image-scanner

The `image-scanner` resource is included only in `ootb-supply-chain-testing-scanning`.
This resource scans a container image (either built by using the supply chain or prebuilt),
persisting the results in the store, and gating the image from moving forward in
case the CVEs found are not compliant with the ScanPolicy referenced by the ImageScan
object create for doing so.

Parameters:

<table>
  <thead>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>
  </thead>
  <tbody>
  <tr>
    <td><code>scanning_image_template</code></td>
    <td>
      The name of the ScanTemplate object (in the same namespace as the workload) to
      use for running the scans against a container image.
    </td>
    <td>
      <pre>
      - name: scanning_image_template
        value: private-image-scan-template
      </pre>
    </td>
  </tr>
  <tr>
    <td><code>scanning_image_policy</code></td>
    <td>
      The name of the ScanPolicy object (in the same namespace as the workload) to
      use when evaluating the scan results of an image scan.
    </td>
    <td>
      <pre>
      - name: scanning_image_policy
        value: allowlist-policy
      </pre>
    </td>
  </tr>
  </tbody>
</table>

For information about the ImageScan custom resource, see [ImageScan reference](../scst-scan/scan-crs.hbs.md#imagescan).

For information about how the artifacts found
during scanning are catalogued, see [Supply Chain Security Tools for Tanzu –
Store](../scst-store/overview.hbs.md).

### <a id ="config-provider"></a>config-provider

The `config-provider` resource in the supply chains generates a PodTemplateSpec
to use in application configs, such as Knative services and deployments,
to represent the desired pod configuration to instantiate to run the application in containers.
For more information, see [PodTemplateSpec](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-template-v1/#PodTemplateSpec) in the Kubernetes documentation.

The `config-provider` resource manages a [PodIntent](../cartographer-conventions/reference/pod-intent.hbs.md)
object that represents the intention of having PodTemplateSpec enhanced with conventions installed
in the cluster whose final representation is then passed forward to other resources to form the
final deployment configuration.

Parameters:

<table>
  <thead>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>
  </thead>
  <tbody>
  <tr>
    <td><code>serviceAccount</code></td>
    <td>
      The name of the serviceaccount (in the same namespace as the workload) to use
      for providing the necessary credentials to `PodIntent` for fetching
      the container image to inspect the metadata to pass to convention
      servers and the serviceAccountName set in the
      podtemplatespec.
    </td>
    <td>
      <pre>
      - name: serviceAccount
        value: default
      </pre>
    </td>
  </tr>
  <tr>
    <td><code>annotations</code></td>
    <td>
     An extra set of annotations to pass down to the PodTemplateSpec.
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
    <td><code>debug</code></td>
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
    <td><code>live-update</code></td>
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
  </tbody>
</table>

The `--service-account` flag sets the `spec.serviceAccountName` key in the workload object.
To configure the `serviceAccount` parameter, use `--param serviceAccount=SERVICE-ACCOUNT`.

For more information about the controller behind `PodIntent`, see [Cartographer Conventions](../cartographer-conventions/about.hbs.md).

For more details about the two
convention servers enabled by default in Tanzu Application Platform installations, see [Developer
Conventions](../developer-conventions/about.hbs.md) and [Spring Boot
conventions](../spring-boot-conventions/about.hbs.md).

### <a id ="app-config"></a>app-config

The `app-config` resource prepares a ConfigMap with the
Kubernetes configuration that is used for instantiating an application in
the form of a particular workload type in a cluster.

The resource is configured in the supply chain to allow, by
default, three types of workloads with the selection of which workload type to
apply based on the labels set in the workload object created by the developer:

- `apps.tanzu.vmware.com/workload-type: web`
- `apps.tanzu.vmware.com/workload-type: worker`
- `apps.tanzu.vmware.com/workload-type: server`

Only the `server` workload type has the following configurable parameters:

<table>
  <thead>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>example</th>
  </tr>
  </thead>
  <tbody>
  <tr>
    <td><code>ports</code></td>
    <td>
      The set of network ports to expose from the application to the Kubernetes
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
  </tbody>
</table>

For more information about the three different types of workloads, see [workload types](../workloads/workload-types.hbs.md).
For a more detailed overview of the ports parameter, see [server-specific Workload
parameters](../workloads/server.hbs.md#-server-specific-workload-parameters).

### <a id ="service-bindings"></a>service-bindings

The `service-bindings` resource adds
[ServiceBindings](../service-bindings/about.hbs.md) to the set of Kubernetes
configuration files to promote for deployment.

Parameters:

<table>
  <thead>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>
  </thead>
  <tbody>
  <tr>
    <td><code>annotations</code></td>
    <td>
     The extra set of annotations to pass down to the ServiceBinding and
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
  </tbody>
</table>

For an example, see
[--service-ref](../cli-plugins/apps/command-reference/workload_create_update_apply.hbs.md#apply-service-ref)
in Tanzu CLI documentation.

For an overview of the function, see [Consume services on
Tanzu Application Platform](../getting-started/consume-services.hbs.md).

### <a id ="api-descriptors"></a>api-descriptors

The `api-descriptor` resource adds an
[APIDescriptor](../api-auto-registration/key-concepts.hbs.md) to the set of
Kubernetes objects to deploy. This enables API auto registration.

Parameters:

<table>
  <thead>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>
  </thead>
  <tbody>
  <tr>
    <td><code>annotations</code></td>
    <td>
     An extra set of annotations to pass down to the APIDescriptor object.
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
    <td><code>api_descriptor</code></td>
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
            path: "/v3/api"
          owner: team-petclinic
          system: pet-clinics
          description: "example"
      </pre>
    </td>
  </tr>
  </tbody>
</table>

The workload must include the `apis.apps.tanzu.vmware.com/register-api: "true"` label to activate
this function.

For more details about API auto registration, see [Use API Auto Registration](../api-auto-registration/usage.hbs.md).

### <a id ="config-writer"></a> config-writer (git or registry)

The `config-writer` resource is responsible for performing the last mile of the
supply chain: persisting in an external system (registry or Git repository) the
Kubernetes configuration generated throughout the supply chain.

There are three methods:

- publishing the configuration to a container image registry
- publishing the configuration to a Git repository by using the push of a commit, or
- publishing the configuration to a Git repository by pushing a commit _and_ opening a pull request.

For more information about the different modes of operation, see [Gitops vs
RegistryOps](../scc/gitops-vs-regops.hbs.md).

### <a id ="deliverable"></a> deliverable

The `deliverable` resource creates a `deliverable` object
that represents the intention of delivering to the cluster the configurations
that are produced by the supply chain.

Parameters:

<table>
  <thead>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>
  </thead>
  <tbody>
  <tr>
    <td><code>serviceAccount</code></td>
    <td>
      The name of the serviceaccount (in the same namespace as the deliverable) to
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
  </tbody>
</table>

The `--service-account` flag sets the `spec.serviceAccountName` key in the workload object.
To configure the `serviceAccount` parameter, use `--param serviceAccount=SERVICE-ACCOUNT`.

On build clusters where a corresponding `ClusterDelivery` doesn't exist, the deliverable takes no
effect (similarly to a workload without a SupplyChain, no action is taken).

## <a id ="deliverable-parameters"></a>Deliverable Parameters Reference

The deliverable object applies the configuration produced by the resources defined by a
ClusterSupplyChain to a Kubernetes cluster.

This section describes the `deliverable.spec.params` parameters that can be configured in the
deliverable object. The following section describes the two resources defined in the
ClusterDelivery resources section. These are part of the `ootb-delivery-basic` package:

### List of Cluster Delivery Resources for Deliverable Object

| Cluster Delivery Resource               | Output Type | Purpose                                                                         |
|-----------------------------------------|-------------|---------------------------------------------------------------------------------|
| [source provider](#source-provider-del) | Source      | Fetches the Kubernetes configuration file from Git repository or image registry |
| [app deployer](#app-deployer)           | Source      | Applies configuration produced by a supply chain to the cluster                 |

For information about the ClusterDelivery shipped with `ootb-delivery-basic`,
and the templates used by it, see:

- [Out of the Box Delivery Basic](../scc/ootb-delivery-basic.hbs.md)
- [Out of the Templates](../scc/ootb-templates.hbs.md)

For information about the use of the deliverable object in a multicluster
environment, see [Getting started with multicluster Tanzu Application
Platform](../multicluster/getting-started.hbs.md).

For reference information about deliverable, see [Deliverable and Delivery
custom resources](https://cartographer.sh/docs/v0.5.0/reference/deliverable/) in the Cartographer documentation.

### <a id ="source-provider-del"></a>source-provider

The `source-provider` resource in the basic ClusterDelivery creates objects
that continuously fetch Kubernetes configuration files from a Git repository
or container image registry so that it can apply those to the cluster.

Regardless of where it fetches that Kubernetes configuration from (Git
repository or image registry), it exposes those files to further resources along
the ClusterDelivery as a tarball.

#### GitRepository

A GitRepository object is instantiated when `deliverable.spec.source.git`
is configured to continuously look for a Kubernetes
configuration pushed to a Git repository, making it available for
resources in the ClusterDelivery.

Parameters:

<table>
  <thead>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>
  </thead>
  <tbody>
  <tr>
    <td><code>gitImplementation</code></td>
    <td>
      VMware recommends that you use the underlying library for fetching the
      source code.  Either <code>libgit2</code>, required for Azure DevOps, or
      <code>go-git</code>.
    </td>
    <td>
      <pre>
      - name: gitImplementation
        value: libgit2
      </pre>
    </td>
  </tr>
  <tr>
    <td><code>gitops_ssh_secret</code></td>
    <td>
      The name of the secret in the same namespace as the `deliverable` used for
      providing credentials for fetching Kubernetes configuration files from
      the Git repository pointed at. See [Git authentication](../scc/git-auth.md).
    </td>
    <td>
      <pre>
      - name: gitops_ssh_secret
        value: git-credentials
      </pre>
    </td>
  </tr>
  </tbody>
</table>

It might not be necessary to change the default Git implementation but some providers, such as
Azure DevOps, require you to use `libgit2` as the server-side implementation provides support only
for [git's v2 protocol](https://git-scm.com/docs/protocol-v2).

For information about the features supported by each implementation, see [git
implementation](https://fluxcd.io/flux/components/source/gitrepositories/#git-implementation) in the Flux
documentation.

For information about how to create a workload that uses a GitHub repository as the provider
of source code, see [Create a workload from GitHub repository](../cli-plugins/apps/create-workload.hbs.md#-create-a-workload-from-github-repository).

For information about GitRepository objects, see [GitRepository](https://fluxcd.io/flux/components/source/gitrepositories/).

#### ImageRepository

An ImageRepository object is instantiated when `deliverable.spec.source.image` is configured to
continuously look for Kubernetes configuration files pushed to a container image registry as opposed
to a Git repository.

Parameters:

<table>
  <thead>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>
  </thead>
  <tbody>
  <tr>
    <td><code>serviceAccount</code></td>
    <td>
      The name of the service account, in the same namespace as the deliverable, you
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
  </tbody>
</table>

The `--service-account` flag sets the `spec.serviceAccountName` key in the deliverable object.
To configure the `serviceAccount` parameter, use `--param serviceAccount=SERVICE-ACCOUNT`.

For information about custom resource details, see [ImageRepository reference
docs](../source-controller/reference.hbs.md#imagerepository).

### <a id="app-deployer"></a>app deployer

The `app-deploy` resource in the ClusterDelivery applies the
Kubernetes configuration that is built by the supply chain, pushed to
either a Git repository or image repository, and applied to the cluster.

#### App

Regardless of where the configuration comes from, an
[App](https://carvel.dev/kapp-controller/docs/v0.41.0/app-overview/) object is
instantiated to deploy the set of Kubernetes configuration files to the cluster.

Parameters:

<table>
  <thead>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>
  </thead>
  <tbody>
  <tr>
    <td><code>serviceAccount</code></td>
    <td>
      The name of the service account, in the same namespace as the deliverable,
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
      The subdirectory within the configuration bundle used for
      looking up the files to apply to the Kubernetes cluster.
    </td>
    <td>
      <pre>
      - name: gitops_sub_path
        value: ./config
      </pre>
    </td>
  </tr>
  </tbody>
</table>

The `gitops_sub_path` parameter is deprecated. Use `deliverable.spec.source.subPath` instead.

The `--service-account` flag sets the `spec.serviceAccountName` key in  the deliverable object.

To configure the `serviceAccount` parameter, use `--param serviceAccount=SERVICE-ACCOUNT`.

For details about RBAC and how `kapp-controller` uses the ServiceAccount provided to it using the
`serviceAccount` parameter in the `deliverable` object, see [`kapp-controller`'s Security
Model](https://carvel.dev/kapp-controller/docs/v0.41.0/security-model/) in the Carvel documentation.

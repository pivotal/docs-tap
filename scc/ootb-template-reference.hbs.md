# Template reference

All the objects referenced in this topic are [Cartographer Templates](https://cartographer.sh/docs/v0.6.0/reference/template/)
packaged in [Out of the Box Templates](ootb-templates.hbs.md).
Their purpose, the one or more objects they create, the supply chains that include them, and
the parameters they use are detailed in this topic.

## source-template

### Purpose

Creates an object to fetch source code and make that code available
to other objects in the supply chain. See [Building from
Source](building-from-source.hbs.md).

### Used by

- [Source-to-URL](ootb-supply-chain-reference.hbs.md#source-to-url) in the `source-provider` step.
- [Source-Test-to-URL](ootb-supply-chain-reference.hbs.md#source-test-to-url) in the `source-provider` step.
- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan-to-url) in the `source-provider` step.
- [Source-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#source-to-url-package-experimental) in the `source-provider` step.

### Creates

The source-template creates one of three objects, either:

- GitRepository. Created if the workload has `.spec.source.git` defined.
- MavenArtifact. Created if the template is provided a value for the parameter `maven`.
- ImageRepository. Created if the workload has `.spec.source.image` defined.

#### GitRepository

`GitRepository` makes source code from a particular commit available as a tarball in the
cluster. Other resources in the supply chain can then access that code.

##### Parameters

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
      If not provided, Tanzu Application Platform's default implementation uses <code>go-git</code>,
      which works with the providers supported by Tanzu Application Platform: GitHub and GitLab.
      An alternate value that can be used with other Git providers is <code>libgit2</code>.
    </td>
    <td>
      <pre>
      - name: gitImplementation
        value: libgit2
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_ssh_secret<code></td>
    <td>
      Name of the secret used to provide credentials for the Git repository.
      The secret with this name must exist in the same namespace as the <code>Workload</code>.
      The credentials must be sufficient to read the repository.
      If not provided, Tanzu Application Platform defaults to look for a secret named <code>git-ssh</code>.
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

> **Note** Some Git providers, notably Azure DevOps, require you to use
> `libgit2` due to the server-side implementation providing support
> only for [git's v2 protocol](https://git-scm.com/docs/protocol-v2).
> For information about the features supported by each implementation, see
> [git implementation](https://fluxcd.io/flux/components/source/gitrepositories/#git-implementation)
> in the flux documentation.

##### More information

For an example using the Tanzu CLI to create a Workload using GitHub as the provider of source code,
see [Create a workload from GitHub
repository](../cli-plugins/apps/create-workload.hbs.md#-create-a-workload-from-github-repository).

For information about GitRepository objects, see
[GitRepository](https://fluxcd.io/flux/components/source/gitrepositories/).

#### ImageRepository

`ImageRepository` makes the contents of a container image available as a tarball on the cluster.

##### Parameters

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

> **Note** When using the Tanzu CLI to configure this `serviceAccount` parameter, use `--param serviceAccount=...`.
> The similarly named `--service-account` flag sets a different value:
> the `spec.serviceAccountName` key in the Workload object.

##### More information

For information about the ImageRepository resource, see the [ImageRepository reference
documentation](../source-controller/reference.hbs.md#image-repository).

For information about how to use the Tanzu CLI to create a workload leveraging ImageRepository, see
[Create a workload from local source
code](../cli-plugins/apps/create-workload.hbs.md#-create-a-workload-from-local-source-code).

#### MavenArtifact

`MavenArtifact` makes a pre-built Java artifact available to as a tarball on the cluster.

While the `source-template` leverages the workload's `.spec.source` field when creating a
`GitRepository` or `ImageRepository` object, the creation of the `MavenArtifact` relies only on
parameters in the Workload.

##### Parameters

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
    <td><code>maven_repository_url<code></td>
    <td>
      Specifies the Maven repository from which to fetch
    </td>
    <td>
      <pre>
      - name: maven_repository_url
        value: https://repo1.maven.org/maven2/
      </pre>
    </td>
    <td><code>maven_repository_secret_name<code></td>
    <td>
      Specifies the secret containing credentials necessary to fetch from the Maven repository.
      The secret named must exist in the same workspace as the workload.
    </td>
    <td>
      <pre>
      - name: maven_repository_secret_name
        value: auth-secret
      </pre>
    </td>
  </tr>
</table>

##### More information

For information about the custom resource, see [MavenArtifact reference
docs](../source-controller/reference.hbs.md#mavenartifact).

For information about how to use the custom resource with the `tanzu apps workload` CLI plug-in [Create a Workload from Maven repository
artifact](../cli-plugins/apps/create-workload.hbs.md#workload-maven).

## testing-pipeline

### Purpose

Tests the source code provided in the supply chain.
Testing depends on a user provided
[Tekton Pipeline](https://tekton.dev/docs/pipelines/pipelines/#overview).
Parameters for this template allow for selection of the proper Pipeline and
for specification of additional values to pass to the Pipeline.

### Used by

- [Source-Test-to-URL](ootb-supply-chain-reference.hbs.md#source-test-to-url) in the source-tester step.
- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan-to-url) in the source-tester step.

These are used as the `source-tester` resource.

### Creates

`testing-pipeline`creates a [Runnable](https://cartographer.sh/docs/v0.4.0/reference/runnable/)
object. This Runnable provides inputs to the
[ClusterRunTemplate](https://cartographer.sh/docs/v0.4.0/reference/runnable/#clusterruntemplate)
named [tekton-source-pipelinerun](ootb-cluster-run-template-reference.hbs.md#tekton-source-pipelinerun).

### Parameters

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
      `apps.tanzu.vmware.com/pipeline: test` is selected.
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
      Set of parameters to pass to the Tekton Pipeline.
      To this set of parameters, the template always adds the source URL
      and revision as `source-url` and `source-revision`.
    </td>
    <td>
      <pre>
      - name: testing_pipeline_params
        value:
        - name: verbose
          value: true
        - name: foo
          value: bar
      </pre>
    </td>
  </tr>

</table>

### More information

For information about the ClusterRunTemplate that pairs with the Runnable, read
[tekton-source-pipelinerun](ootb-cluster-run-template-reference.hbs.md#tekton-source-pipelinerun)

For information about the Tekton Pipeline that the user must create, read the [OOTB Supply Chain
Testing documentation of the Pipeline](ootb-supply-chain-testing.hbs.md#a-idtekton-pipelinea-tektonpipeline)

## source-scanner-template

### Purpose
Scans the source code for vulnerabilities.

### Used by

- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan-to-url) in the source-scanner step.

This is used as the `source-scanner` resource.

### Creates

[SourceScan](../scst-scan/overview.hbs.md)

### Parameters

<table>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>scanning_source_template<code></td>
    <td>
      Name of the ScanTemplate object to use for running the scans.
      The ScanTemplate must be in the same namespace as the Workload.
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
      Name of the ScanPolicy object to use when evaluating the scan results of a source scan.
      The ScanPolicy must be in the same namespace as the Workload.
    </td>
    <td>
      <pre>
      - name: scanning_source_policy
        value: allowlist-policy
      </pre>
    </td>
  </tr>
</table>

### More information

For information about how to set up the Workload namespace with the ScanPolicy and
ScanTemplate required for this resource, see [Out of the Box Supply Chain with Testing and
Scanning](ootb-supply-chain-testing-scanning.hbs.md#a-iddeveloper-namespacea-developer-namespace).

For information about the SourceScan custom resource, see [SourceScan reference](../scst-scan/scan-crs.hbs.md#sourcescan).

For information about how the artifacts found
during scanning are catalogued, see [Supply Chain Security Tools for Tanzu –
Store](../scst-store/overview.hbs.md).

## image-provider-template

### Purpose

Fetches a container image of a prebuilt application,
specified in the workload's `.spec.image` field.
This makes the content-addressable name, (e.g. the image name containing the digest)
available to other resources in the supply chain.

### Used by

- [Basic-Image-to-URL](ootb-supply-chain-reference.hbs.md#basic-image-to-url) in the image-provider step.
- [Testing-Image-to-URL](ootb-supply-chain-reference.hbs.md#testing-image-to-url) in the image-provider step.
- [Scanning-Image-Scan-to-URL](ootb-supply-chain-reference.hbs.md#scanning-image-scan-to-url) in the image-provider step.
- [Basic-Image-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#basic-image-to-url-package-experimental) in the image-provider step.

These are used as the `image-provider` resource.

### Creates

ImageRepository.source.apps.tanzu.vmware.com

### Parameters

<table>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>serviceAccount<code></td>
    <td>
      Name of the service account providing credentials for the target image registry.
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
> The similarly named `--service-account` flag sets a different value:
> the `spec.serviceAccountName` key in the Workload object.

### More information

For information about the ImageRepository resource,
see [ImageRepository reference docs](../source-controller/reference.hbs.md#imagerepository).

For information about prebuilt images,
see [Using a prebuilt image](pre-built-image.hbs.md).

## kpack-template

### Purpose

Builds an container image from source code using [cloud native buildpacks](https://buildpacks.io/).

### Used by

- [Source-to-URL](ootb-supply-chain-reference.hbs.md#source-to-url) in the image-provider step.
- [Source-Test-to-URL](ootb-supply-chain-reference.hbs.md#source-test-to-url) in the image-provider step.
- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan-to-url) in the image-provider step.
- [Source-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#source-to-url-package-experimental) in the image-provider step.

These are used as the `image-provider` resource when the workload parameter `dockerfile` is not defined.

### Creates

[Image.kpack.io](https://github.com/pivotal/kpack/blob/main/docs/image.md)

### Parameters

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
      `Image` uses these credentials to push built container images to the registry.
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
      Name of the Kpack Cluster Builder to use.
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
      Enable the use of Tilt's live-update function.
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
> The similarly named `--service-account` flag sets a different value:
> the `spec.serviceAccountName` key in the Workload object.

### More information

For information about the integration with Tanzu Build Service,
see [Tanzu Build Service Integration](tbs.hbs.md).

For information about `live-update`,
see [Developer Conventions](../developer-conventions/about.hbs.md) and [Overview of Tanzu Developer Tools for IntelliJ](../intellij-extension/about.hbs.md).

For information about using Kpack builders with `clusterBuilder`,
see [Builders](https://github.com/pivotal/kpack/blob/main/docs/builders.md).

For information about `buildServiceBindings`,
see [Service Bindings](https://github.com/pivotal/kpack/blob/main/docs/servicebindings.md).

## kaniko-template

### Purpose

Build an image for source code that includes a Dockerfile.

### Used by

- [Source-to-URL](ootb-supply-chain-reference.hbs.md#source-to-url) in the image-provider step.
- [Source-Test-to-URL](ootb-supply-chain-reference.hbs.md#source-test-to-url) in the image-provider step.
- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan-to-url) in the image-provider step.
- [Source-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#source-to-url-package-experimental) in the image-provider step.

These are used as the `image-provider` resource when the workload parameter `dockerfile` is defined.

### Creates

A taskrun.tekton.dev which provides configuration to a Tekton ClusterTask to build an image with kaniko.

This template uses the [lifecycle: tekton](https://cartographer.sh/docs/v0.6.0/lifecycle/)
flag to create new immutable objects rather than updating the previous object.

### Parameters

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

  <tr>
    <td><code>registry<code></td>
    <td>
      Specification of the registry server and repository in which the built image is placed.
    </td>
    <td>
      <pre>
      - name: registry
        value:
          server: index.docker.io
          repository: web-team
      </pre>
    </td>
  </tr>
</table>

### More information

For information about how to use Dockerfile-based builds and limits associated with the function, see
[Dockerfile-based builds](dockerfile-based-builds.hbs.md).

For information about `lifecycle:tekton`,
read [Cartographer Lifecycle](https://cartographer.sh/docs/v0.6.0/lifecycle/).

## image-scanner-template

### Purpose

Scans the container image for vulnerabilities,
persists the results in a store,
and prevents the image from moving forward
if CVEs are found which are not compliant with its referenced ScanPolicy.

### Used by

- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan-to-url) in the image-scanner step.
- [Scanning-Image-Scan-to-URL](ootb-supply-chain-reference.hbs.md#scanning-image-scan-to-url) in the image-scanner step.

### Creates

ImageScan.scanning.apps.tanzu.vmware.com

### Parameters

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

### More -nformation

For information about the ImageScan custom resource,
see [ImageScan reference](../scst-scan/scan-crs.hbs.md#imagescan).

For information about how the artifacts found during scanning are catalogued,
see [Supply Chain Security Tools for Tanzu – Store](../scst-store/overview.hbs.md).

## convention-template

### Purpose

Create the PodTemplateSpec for the Kubernetes configuration (e.g. the knative service or kubernetes deployment)
which are applied to the cluster.

### Used by

- [Source-to-URL](ootb-supply-chain-reference.hbs.md#source-to-url) in the config-provider step.
- [Basic-Image-to-URL](ootb-supply-chain-reference.hbs.md#basic-image-to-url) in the config-provider step.
- [Source-Test-to-URL](ootb-supply-chain-reference.hbs.md#source-test-to-url) in the config-provider step.
- [Testing-Image-to-URL](ootb-supply-chain-reference.hbs.md#testing-image-to-url) in the config-provider step.
- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan-to-url) in the config-provider step.
- [Scanning-Image-Scan-to-URL](ootb-supply-chain-reference.hbs.md#scanning-image-scan-to-url) in the config-provider step.
- [Source-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#source-to-url-package-experimental) in the config-provider step.
- [Basic-Image-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#basic-image-to-url-package-experimental) in the config-provider step.

### Creates

Creates a [PodIntent](../cartographer-conventions/reference/pod-intent.hbs.md) object.
The PodIntent leverages conventions installed on the cluster.
The PodIntent object is responsible for generating a PodTemplateSpec.
The PodTemplateSpec is used in app configs, such as knative services and deployments,
to represent the shape of the pods to run the application in containers.

### Parameters

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
> The similarly named `--service-account` flag sets a different value:
> the `spec.serviceAccountName` key in the Workload object.

### More information

For information about `PodTemplateSpec`, see
[PodTemplateSpec](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-template-v1/#PodTemplateSpec)
in the Kubernetes documentation.

For information about conventions, see
[Cartographer Conventions](../cartographer-conventions/about.hbs.md).

For information about the two convention servers enabled by default in Tanzu
Application Platform installations, see [Developer
Conventions](../developer-conventions/about.hbs.md) and [Spring Boot
Conventions](../spring-boot-conventions/about.hbs.md).

## config-template

### Purpose

For workloads with the label `apps.tanzu.vmware.com/workload-type: web`, define a knative service.

### Used by

- [Source-to-URL](ootb-supply-chain-reference.hbs.md#source-to-url) in the app-config step.
- [Basic-Image-to-URL](ootb-supply-chain-reference.hbs.md#basic-image-to-url) in the app-config step.
- [Source-Test-to-URL](ootb-supply-chain-reference.hbs.md#source-test-to-url) in the app-config step.
- [Testing-Image-to-URL](ootb-supply-chain-reference.hbs.md#testing-image-to-url) in the app-config step.
- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan-to-url) in the app-config step.
- [Scanning-Image-Scan-to-URL](ootb-supply-chain-reference.hbs.md#scanning-image-scan-to-url) in the app-config step.

### Creates

A ConfigMap, in which the data field has a key `delivery.yaml` whose value is the definition of a knative service.

### Parameters

None

### More information

See [workload types](../workloads/workload-types.hbs.md) for more details about the
three different types of workloads.

## worker-template

### Purpose

For workloads with the label `apps.tanzu.vmware.com/workload-type: worker`, define a Kubernetes Deployment.

### Used by

- [Source-to-URL](ootb-supply-chain-reference.hbs.md#source-to-url) in the app-config step.
- [Basic-Image-to-URL](ootb-supply-chain-reference.hbs.md#basic-image-to-url) in the app-config step.
- [Source-Test-to-URL](ootb-supply-chain-reference.hbs.md#source-test-to-url) in the app-config step.
- [Testing-Image-to-URL](ootb-supply-chain-reference.hbs.md#testing-image-to-url) in the app-config step.
- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan-to-url) in the app-config step.
- [Scanning-Image-Scan-to-URL](ootb-supply-chain-reference.hbs.md#scanning-image-scan-to-url) in the app-config step.

### Creates

A ConfigMap, in which the data field has a key `delivery.yaml` whose value is the definition of a Kubernetes Deployment.

### Parameters

None

### More information

For information about the three different types of workloads, see [workload
types](../workloads/workload-types.hbs.md).

## server-template

### Purpose

For workloads with the label `apps.tanzu.vmware.com/workload-type: server`,
define a Kubernetes Deployment and a Kubernetes Service.

### Used by

- [Source-to-URL](ootb-supply-chain-reference.hbs.md#source-to-url) in the app-config step.
- [Basic-Image-to-URL](ootb-supply-chain-reference.hbs.md#basic-image-to-url) in the app-config step.
- [Source-Test-to-URL](ootb-supply-chain-reference.hbs.md#source-test-to-url) in the app-config step.
- [Testing-Image-to-URL](ootb-supply-chain-reference.hbs.md#testing-image-to-url) in the app-config step.
- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan-to-url) in the app-config step.
- [Scanning-Image-Scan-to-URL](ootb-supply-chain-reference.hbs.md#scanning-image-scan-to-url) in the app-config step.
- [Source-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#source-to-url-package-experimental) in the app-config step.
- [Basic-Image-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#basic-image-to-url-package-experimental) in the app-config step.

### Creates

A ConfigMap, in which the data field has a key `delivery.yaml` whose value is the definitions of a Kubernetes
Deployment and a Kubernetes Service to expose the pods.

### Parameters

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

### More information

For information about the three different types of workloads, see [workload
types](../workloads/workload-types.hbs.md).

For information about the ports parameter, see [server-specific Workload
parameters](../workloads/server.hbs.md#-server-specific-workload-parameters).

## service-bindings

### Purpose

Adds [ServiceBindings](../service-bindings/about.hbs.md)
to the set of Kubernetes configuration files.

### Used by

- [Source-to-URL](ootb-supply-chain-reference.hbs.md#source-to-url) in the service-bindings step.
- [Basic-Image-to-URL](ootb-supply-chain-reference.hbs.md#basic-image-to-url) in the service-bindings step.
- [Source-Test-to-URL](ootb-supply-chain-reference.hbs.md#source-test-to-url) in the service-bindings step.
- [Testing-Image-to-URL](ootb-supply-chain-reference.hbs.md#testing-image-to-url) in the service-bindings step.
- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan-to-url) in the service-bindings step.
- [Scanning-Image-Scan-to-URL](ootb-supply-chain-reference.hbs.md#scanning-image-scan-to-url) in the service-bindings step.
- [Source-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#source-to-url-package-experimental) in the service-bindings step.
- [Basic-Image-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#basic-image-to-url-package-experimental) in the service-bindings step.

### Creates

A ConfigMap. This template consumes input of multiple deployment YAML files and
enriches the input with ResourceClaims and ServiceBindings if the workload contains serviceClaims.

### Parameters

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

### More information

For an example, see
[--service-ref](../cli-plugins/apps/command-reference/workload_create_update_apply.hbs.md#apply-service-ref)
in the Tanzu CLI documentation.

For an overview of the function, see
[Consume services on Tanzu Application Platform](../getting-started/consume-services.hbs.md).

## api-descriptors

### Purpose

The `api-descriptor` resource takes care of adding an
[APIDescriptor](../api-auto-registration/key-concepts.hbs.md) to the set of
Kubernetes objects to deploy such that API auto registration takes place.

### Used by

- [Source-to-URL](ootb-supply-chain-reference.hbs.md#source-to-url) in the api-descriptors step.
- [Basic-Image-to-URL](ootb-supply-chain-reference.hbs.md#basic-image-to-url) in the api-descriptors step.
- [Source-Test-to-URL](ootb-supply-chain-reference.hbs.md#source-test-to-url) in the api-descriptors step.
- [Testing-Image-to-URL](ootb-supply-chain-reference.hbs.md#testing-image-to-url) in the api-descriptors step.
- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan-to-url) in the api-descriptors step.
- [Scanning-Image-Scan-to-URL](ootb-supply-chain-reference.hbs.md#scanning-image-scan-to-url) in the api-descriptors step.
- [Source-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#source-to-url-package-experimental) in the api-descriptors step.
- [Basic-Image-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#basic-image-to-url-package-experimental) in the api-descriptors step.

### Creates

A ConfigMap. This template consumes input of multiple YAML files and
enriches the input with an APIDescriptor if
the workload has a label `apis.apps.tanzu.vmware.com/register-api` == to `true`.

### Parameters

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

### More information

For information about API auto registration, see [Use API Auto Registration](../api-auto-registration/usage.hbs.md).

## config-writer-template

### Purpose

Persist in an external system, such as a registry or git repository, the
Kubernetes configuration passed to the template.

### Used by

- [Source-to-URL](ootb-supply-chain-reference.hbs.md#source-to-url) in the config-writer step.
- [Basic-Image-to-URL](ootb-supply-chain-reference.hbs.md#basic-image-to-url) in the config-writer step.
- [Source-Test-to-URL](ootb-supply-chain-reference.hbs.md#source-test-to-url) in the config-writer step.
- [Testing-Image-to-URL](ootb-supply-chain-reference.hbs.md#testing-image-to-url) in the config-writer step.
- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan-to-url) in the config-writer step.
- [Scanning-Image-Scan-to-URL](ootb-supply-chain-reference.hbs.md#scanning-image-scan-to-url) in the config-writer step.

### Creates

A runnable which creates a Tekton TaskRun that refers either to
the Tekton Task `git-writer` or the Tekton Task `image-writer`.

### Parameters

<table>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>serviceAccount<code></td>
    <td>
      Name of the service account which provides the credentials to the registry or repository.
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
    <td><code>gitops_branch<code></td>
    <td>
      Name of the branch to push the configuration to.
    </td>
    <td>
      <pre>
      - name: gitops_branch
        value: main
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_user_name<code></td>
    <td>
      User name to use in the commits.
    </td>
    <td>
      <pre>
      - name: gitops_user_name
        value: "Alice Lee"
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_user_email<code></td>
    <td>
      User email address to use in the commits.
    </td>
    <td>
      <pre>
      - name: gitops_user_email
        value: alice@example.com
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_commit_message<code></td>
    <td>
      Message to write as the body of the commits produced for pushing configuration to the Git repository.
    </td>
    <td>
      <pre>
      - name: gitops_commit_message
        value: "ci bump"
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_repository<code></td>
    <td>
      The full repository URL to which the configuration is committed.
      <b>DEPRECATED</b>
    </td>
    <td>
      <pre>
      - name: gitops_repository
        value: "https://github.com/vmware-tanzu/cartographer"
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_repository_prefix<code></td>
    <td>
      The prefix of the repository URL.
      <b>DEPRECATED</b>
    </td>
    <td>
      <pre>
      - name: gitops_repository
        value: "https://github.com/vmware-tanzu/"
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_server_address<code></td>
    <td>
      The server URL of the Git repository to which configuration is applied.
    </td>
    <td>
      <pre>
      - name: gitops_server_address
        value: "https://github.com/"
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_repository_owner<code></td>
    <td>
      The owner/organization to which the repository belongs.
    </td>
    <td>
      <pre>
      - name: gitops_repository_owner
        value: vmware-tanzu
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_repository_name<code></td>
    <td>
      The name of the repository.
    </td>
    <td>
      <pre>
      - name: gitops_repository_name
        value: cartographer
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>registry<code></td>
    <td>
      Specification of the registry server and repository in which the configuration is placed.
    </td>
    <td>
      <pre>
      - name: registry
        value:
          server: index.docker.io
          repository: web-team
          ca_cert_data:
            -----BEGIN CERTIFICATE-----
            MIIFXzCCA0egAwIBAgIJAJYm37SFocjlMA0GCSqGSIb3DQEBDQUAMEY...
            -----END CERTIFICATE-----
      </pre>
    </td>
  </tr>

</table>

### More information

For information about operating this template, see [Gitops vs RegistryOps](gitops-vs-regops.hbs.md)
and the [config-writer-and-pull-requester-template](#config-writer-and-pull-requester-template).

## config-writer-and-pull-requester-template

### Purpose

Persist the passed in Kubernetes configuration to a branch in a repository and open a pull request to another branch.
This process allows for manual review of configuration before deployment to a cluster.

### Used by

- [Source-to-URL](ootb-supply-chain-reference.hbs.md#source-to-url) in the config-writer step.
- [Basic-Image-to-URL](ootb-supply-chain-reference.hbs.md#basic-image-to-url) in the config-writer step.
- [Source-Test-to-URL](ootb-supply-chain-reference.hbs.md#source-test-to-url) in the config-writer step.
- [Testing-Image-to-URL](ootb-supply-chain-reference.hbs.md#testing-image-to-url) in the config-writer step.
- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan-to-url) in the config-writer step.
- [Scanning-Image-Scan-to-URL](ootb-supply-chain-reference.hbs.md#scanning-image-scan-to-url) in the config-writer step.

### Creates

A runnable which provides configuration to the ClusterRunTemplate `commit-and-pr-pipelinerun` to create a
Tekton TaskRun. The Tekton TaskRun refers to the Tekton Task `commit-and-pr`.

### Parameters

<table>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>serviceAccount<code></td>
    <td>
      Name of the service account which provides the credentials to the registry or repository.
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
    <td><code>gitops_commit_branch<code></td>
    <td>
      Name of the branch to which configuration is pushed.
    </td>
    <td>
      <pre>
      - name: gitops_commit_branch
        value: feature
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_branch<code></td>
    <td>
      Name of the branch to which a pull request is opened.
    </td>
    <td>
      <pre>
      - name: gitops_branch
        value: main
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_user_name<code></td>
    <td>
      User name to use in the commits.
    </td>
    <td>
      <pre>
      - name: gitops_user_name
        value: "Alice Lee"
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_user_email<code></td>
    <td>
      User email address to use in the commits.
    </td>
    <td>
      <pre>
      - name: gitops_user_email
        value: alice@example.com
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_commit_message<code></td>
    <td>
      Message to write as the body of the commits produced for pushing configuration to the Git repository.
    </td>
    <td>
      <pre>
      - name: gitops_commit_message
        value: "ci bump"
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_pull_request_title<code></td>
    <td>
      Title of the pull request to be opened.
    </td>
    <td>
      <pre>
      - name: gitops_pull_request_title
        value: "ready for review"
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_pull_request_body<code></td>
    <td>
      Body of the pull request to be opened.
    </td>
    <td>
      <pre>
      - name: gitops_pull_request_body
        value: "generated by supply chain"
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_server_address<code></td>
    <td>
      The server URL of the Git repository to which configuration is applied.
    </td>
    <td>
      <pre>
      - name: gitops_server_address
        value: "https://github.com/"
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_repository_owner<code></td>
    <td>
      The owner/organization to which the repository belongs.
    </td>
    <td>
      <pre>
      - name: gitops_repository_owner
        value: vmware-tanzu
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_repository_name<code></td>
    <td>
      The name of the repository.
    </td>
    <td>
      <pre>
      - name: gitops_repository_name
        value: cartographer
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_server_kind<code></td>
    <td>
      The kind of Git provider
    </td>
    <td>
      <pre>
      - name: gitops_server_kind
        value: gitlab
      </pre>
    </td>
  </tr>

</table>

### More information

For information about the operation of this template, see [Gitops vs RegistryOps](gitops-vs-regops.hbs.md)
and the [config-writer-template](#config-writer-template).

## deliverable-template

### Purpose

Create a deliverable which
[pairs with a Delivery](https://cartographer.sh/docs/v0.6.0/architecture/#clusterdelivery)
to deploy Kubernetes configuration on the cluster.

### Used by

- [Source-to-URL](ootb-supply-chain-reference.hbs.md#source-to-url) in the deliverable step.
- [Basic-Image-to-URL](ootb-supply-chain-reference.hbs.md#basic-image-to-url) in the deliverable step.
- [Source-Test-to-URL](ootb-supply-chain-reference.hbs.md#source-test-to-url) in the deliverable step.
- [Testing-Image-to-URL](ootb-supply-chain-reference.hbs.md#testing-image-to-url) in the deliverable step.
- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan-to-url) in the deliverable step.
- [Scanning-Image-Scan-to-URL](ootb-supply-chain-reference.hbs.md#scanning-image-scan-to-url) in the deliverable step.

### Creates

A [Deliverable](https://cartographer.sh/docs/v0.6.0/reference/deliverable/#deliverable)
preconfigured with reference to a repository or registry from which to fetch Kubernetes configuration.

### Parameters

<table>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>serviceAccount<code></td>
    <td>
      Name of the service account providing the necessary permissions for
      the Delivery to create children objects.
      Populates the Deliverable's serviceAccount parameter.
      The service account must be in the same namespace as the Deliverable.
    </td>
    <td>
      <pre>
      - name: serviceAccount
        value: default
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_ssh_secret<code></td>
    <td>
      Name of the secret where credentials exist for fetching the configuration
      from a Git repository. Populates the Deliverable's gitops_ssh_secret parameter.
      The service account must be in the same namespace as the Deliverable.
    </td>
    <td>
      <pre>
      - name: gitops_ssh_secret
        value: ssh-secret
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_branch<code></td>
    <td>
      Name of the branch from which to fetch the configuration.
    </td>
    <td>
      <pre>
      - name: gitops_branch
        value: main
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_repository<code></td>
    <td>
      The full repository URL to which the configuration is fetched.
      <b>DEPRECATED</b>
    </td>
    <td>
      <pre>
      - name: gitops_repository
        value: "https://github.com/vmware-tanzu/cartographer"
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_repository_prefix<code></td>
    <td>
      The prefix of the repository URL.
      <b>DEPRECATED</b>
    </td>
    <td>
      <pre>
      - name: gitops_repository
        value: "https://github.com/vmware-tanzu/"
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_server_address<code></td>
    <td>
      The server URL of the Git repository from which configuration is fetched.
    </td>
    <td>
      <pre>
      - name: gitops_server_address
        value: "https://github.com/"
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_repository_owner<code></td>
    <td>
      The owner/organization to which the repository belongs.
    </td>
    <td>
      <pre>
      - name: gitops_repository_owner
        value: vmware-tanzu
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_repository_name<code></td>
    <td>
      The name of the repository.
    </td>
    <td>
      <pre>
      - name: gitops_repository_name
        value: cartographer
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>registry<code></td>
    <td>
      Specification of the registry server and repository from which the configuration is fetched.
    </td>
    <td>
      <pre>
      - name: registry
        value:
          server: index.docker.io
          repository: web-team
          ca_cert_data:
            -----BEGIN CERTIFICATE-----
            MIIFXzCCA0egAwIBAgIJAJYm37SFocjlMA0GCSqGSIb3DQEBDQUAMEY...
            -----END CERTIFICATE-----
      </pre>
    </td>
  </tr>
</table>

> **Note** When using the Tanzu CLI to configure this `serviceAccount` parameter, use `--param serviceAccount=...`.
> The similarly named `--service-account` flag sets a different value:
> the `spec.serviceAccountName` key in the Workload object.

### More information

For information about the ClusterDelivery shipped with `ootb-delivery-basic`,
see [Out of the Box Delivery Basic](ootb-delivery-basic.hbs.md).

## external-deliverable-template

### Purpose

Create a definition of a deliverable which a user can manually applied to
an external kubernetes cluster. When a properly configured Delivery is installed on that
external cluster, the Deliverable will
[pair with the Delivery](https://cartographer.sh/docs/v0.6.0/architecture/#clusterdelivery)
to deploy Kubernetes configuration on the cluster. For example, the [OOTB Delivery](ootb-delivery-basic.hbs.md).

### Used by

- [Source-to-URL](ootb-supply-chain-reference.hbs.md#source-to-url) in the deliverable step.
- [Basic-Image-to-URL](ootb-supply-chain-reference.hbs.md#basic-image-to-url) in the deliverable step.
- [Source-Test-to-URL](ootb-supply-chain-reference.hbs.md#source-test-to-url) in the deliverable step.
- [Testing-Image-to-URL](ootb-supply-chain-reference.hbs.md#testing-image-to-url) in the deliverable step.
- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan-to-url) in the deliverable step.
- [Scanning-Image-Scan-to-URL](ootb-supply-chain-reference.hbs.md#scanning-image-scan-to-url) in the deliverable step.

### Creates

A configmap in which the `.data` field has a key `deliverable` for which the value is the YAML definition
of a [Deliverable](https://cartographer.sh/docs/v0.6.0/reference/deliverable/#deliverable).

### Parameters

<table>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>serviceAccount<code></td>
    <td>
      Name of the service account providing the necessary permissions for
      the Delivery to create children objects.
      Populates the Deliverable's serviceAccount parameter.
      The service account must be in the same namespace as the Deliverable.
    </td>
    <td>
      <pre>
      - name: serviceAccount
        value: default
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_ssh_secret<code></td>
    <td>
      Name of the secret where credentials exist for fetching the configuration
      from a Git repository. Populates the Deliverable's gitops_ssh_secret parameter.
      The service account must be in the same namespace as the Deliverable.
    </td>
    <td>
      <pre>
      - name: gitops_ssh_secret
        value: ssh-secret
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_branch<code></td>
    <td>
      Name of the branch from which to fetch the configuration.
    </td>
    <td>
      <pre>
      - name: gitops_branch
        value: main
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_repository<code></td>
    <td>
      The full repository URL to which the configuration is fetched.
      <b>DEPRECATED</b>
    </td>
    <td>
      <pre>
      - name: gitops_repository
        value: "https://github.com/vmware-tanzu/cartographer"
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_repository_prefix<code></td>
    <td>
      The prefix of the repository URL.
      <b>DEPRECATED</b>
    </td>
    <td>
      <pre>
      - name: gitops_repository
        value: "https://github.com/vmware-tanzu/"
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_server_address<code></td>
    <td>
      The server URL of the Git repository from which configuration is fetched.
    </td>
    <td>
      <pre>
      - name: gitops_server_address
        value: "https://github.com/"
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_repository_owner<code></td>
    <td>
      The owner/organization to which the repository belongs.
    </td>
    <td>
      <pre>
      - name: gitops_repository_owner
        value: vmware-tanzu
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_repository_name<code></td>
    <td>
      The name of the repository.
    </td>
    <td>
      <pre>
      - name: gitops_repository_name
        value: cartographer
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>registry<code></td>
    <td>
      Specification of the registry server and repository from which the configuration is fetched.
    </td>
    <td>
      <pre>
      - name: registry
        value:
          server: index.docker.io
          repository: web-team
          ca_cert_data:
            -----BEGIN CERTIFICATE-----
            MIIFXzCCA0egAwIBAgIJAJYm37SFocjlMA0GCSqGSIb3DQEBDQUAMEY...
            -----END CERTIFICATE-----
      </pre>
    </td>
  </tr>
</table>

### More information

For information about the ClusterDelivery shipped with `ootb-delivery-basic`,
see [Out of the Box Delivery Basic](ootb-delivery-basic.hbs.md).

For information about using the Deliverable object in a multicluster
environment, see [Getting started with multicluster Tanzu Application
Platform](../multicluster/getting-started.hbs.md).

## delivery-source-template

### Purpose

Continuously fetches Kubernetes configuration files from a Git repository
or container image registry and makes them available on the cluster.

### Used by

- [Delivery-Basic](ootb-delivery-reference.hbs.md#delivery-basic)

### Creates

The source-template creates one of three objects, either:
- GitRepository. Created if the deliverable has `.spec.source.git` defined.
- ImageRepository. Created if the deliverable has `.spec.source.image` defined.

#### GitRepository

`GitRepository` makes source code from a particular commit available as a tarball in the
cluster. Other resources in the supply chain can then access that code.

##### Parameters

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
      If not provided, Tanzu Application Platform's default implementation uses <code>go-git</code>,
      which works with the providers supported by Tanzu Application Platform: GitHub and GitLab.
      An alternate value that you can use with other Git providers is <code>libgit2</code>.
    </td>
    <td>
      <pre>
      - name: gitImplementation
        value: libgit2
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_ssh_secret<code></td>
    <td>
      Name of the secret used to provide credentials for the Git repository.
      The secret with this name must exist in the same namespace as the <code>Deliverable</code>.
      The credentials must be sufficient to read the repository.
      If not provided, Tanzu Application Platform defaults to look for a secret named <code>git-ssh</code>.
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

> **Note** Some Git providers, notably Azure DevOps, require you to use
> `libgit2` due to the server-side implementation providing support
> only for [git's v2 protocol](https://git-scm.com/docs/protocol-v2).
> For information about the features supported by each implementation, see
> [git implementation](https://fluxcd.io/flux/components/source/gitrepositories/#git-implementation)
> in the flux documentation.

##### More information

For an example using the Tanzu CLI to create a Workload using GitHub as the provider of source code,
see [Create a workload from GitHub
repository](../cli-plugins/apps/create-workload.hbs.md#-create-a-workload-from-github-repository).

For information about GitRepository objects, see
[GitRepository](https://fluxcd.io/flux/components/source/gitrepositories/).

#### ImageRepository

`ImageRepository` makes the contents of a container image available as a tarball on the cluster.

##### Parameters

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
      The service account must exist in the same namespace as the Deliverable.
    </td>
    <td>
      <pre>
      - name: serviceAccount
        value: default
      </pre>
    </td>
  </tr>

</table>

##### More information

For information about the ImageRepository resource, see [ImageRepository reference
docs](../source-controller/reference.hbs.md#imagerepository).

## app-deploy

### Purpose
Applies Kubernetes configuration to the cluster.

### Used by

- [Delivery-Basic](ootb-delivery-reference.hbs.md#delivery-basic)

### Creates

A [kapp App](https://carvel.dev/kapp-controller/docs/v0.41.0/app-overview/).

### Parameters

<table>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>serviceAccount<code></td>
    <td>
      Name of the service account providing the necessary privileges for `App` to apply
      the Kubernetes objects to the cluster.
      The service account must be in the same namespace as the Deliverable.
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
      looking up the files to apply to the Kubernetes cluster. <b>DEPRECATED</b>
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

### More information

For details about RBAC and how `kapp-controller` makes use of the ServiceAccount provided through the Deliverable's
`serviceAccount` parameter,
see [kapp-controller's Security Model](https://carvel.dev/kapp-controller/docs/v0.41.0/security-model/).

## carvel-package (experimental)

### Purpose

Bundles Kubernetes configuration into a Carvel Package.

### Used by

- [Source-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#source-to-url-package-experimental) in the carvel-package step.
- [Basic-Image-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#basic-image-to-url-package-experimental) in the carvel-package step.

### Creates

A taskrun.tekton.dev which provides configuration to a Tekton ClusterTask to bundle Kubernetes configuration into a Carvel Package.

This template uses the [`lifecycle: tekton`](https://cartographer.sh/docs/v0.6.0/lifecycle/)
flag to create new immutable objects rather than updating the previous object.

### Parameters

<table>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
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

  <tr>
    <td><code>registry<code></td>
    <td>
      Specification of the registry server and repository in which the built image is placed.
    </td>
    <td>
      <pre>
      - name: registry
        value:
          server: index.docker.io
          repository: web-team
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>carvel_package_gitops_subpath<code></td>
    <td>
      Specifies the subpath to which Carvel Packages should be written.
    </td>
    <td>
      <pre>
      - name: carvel_package_gitops_subpath
        value: path/to/my/dir
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>carvel_package_name_suffix<code></td>
    <td>
      Specifies the suffix to append to the Carvel Package name. The format is WORKLOAD_NAME.WORKLOAD_NAMESPACE.carvel_package_name_suffix The full Carvel Package name must be a valid DNS subdomain name as defined in RFC 1123.
    </td>
    <td>
      <pre>
      - name: carvel_package_name_suffix
        value: vmware.com
      </pre>
    </td>
  </tr>
</table>

### More Information

To read more about `lifecycle:tekton`,
read [Cartographer Lifecycle](https://cartographer.sh/docs/v0.6.0/lifecycle/).

## package-config-writer-template (experimental)

### Purpose

Persist in an external git repository the Carvel Package Kubernetes configuration passed to the template.

### Used by

- [Source-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#source-to-url-package-experimental) in the config-writer step.
- [Basic-Image-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#basic-image-to-url-package-experimental) in the config-writer step.

### Creates

A runnable which creates a Tekton TaskRun that refers either to the Tekton Task `git-writer`.

### Parameters

<table>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>serviceAccount<code></td>
    <td>
      Name of the service account which provides the credentials to the registry or repository.
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
    <td><code>gitops_branch<code></td>
    <td>
      Name of the branch to push the configuration to.
    </td>
    <td>
      <pre>
      - name: gitops_branch
        value: main
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_user_name<code></td>
    <td>
      User name to use in the commits.
    </td>
    <td>
      <pre>
      - name: gitops_user_name
        value: "Alice Lee"
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_user_email<code></td>
    <td>
      User email address to use in the commits.
    </td>
    <td>
      <pre>
      - name: gitops_user_email
        value: alice@example.com
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_commit_message<code></td>
    <td>
      Message to write as the body of the commits produced for pushing configuration to the Git repository.
    </td>
    <td>
      <pre>
      - name: gitops_commit_message
        value: "ci bump"
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_repository<code></td>
    <td>
      The full repository URL to which the configuration is committed.
      <b>DEPRECATED</b>
    </td>
    <td>
      <pre>
      - name: gitops_repository
        value: "https://github.com/vmware-tanzu/cartographer"
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_repository_prefix<code></td>
    <td>
      The prefix of the repository URL.
      <b>DEPRECATED</b>
    </td>
    <td>
      <pre>
      - name: gitops_repository
        value: "https://github.com/vmware-tanzu/"
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_server_address<code></td>
    <td>
      The server URL of the Git repository to which configuration is applied.
    </td>
    <td>
      <pre>
      - name: gitops_server_address
        value: "https://github.com/"
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_repository_owner<code></td>
    <td>
      The owner/organization to which the repository belongs.
    </td>
    <td>
      <pre>
      - name: gitops_repository_owner
        value: vmware-tanzu
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_repository_name<code></td>
    <td>
      The name of the repository.
    </td>
    <td>
      <pre>
      - name: gitops_repository_name
        value: cartographer
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>registry<code></td>
    <td>
      Specification of the registry server and repository in which the configuration is placed.
    </td>
    <td>
      <pre>
      - name: registry
        value:
          server: index.docker.io
          repository: web-team
          ca_cert_data:
            -----BEGIN CERTIFICATE-----
            MIIFXzCCA0egAwIBAgIJAJYm37SFocjlMA0GCSqGSIb3DQEBDQUAMEY...
            -----END CERTIFICATE-----
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>carvel_package_gitops_subpath<code></td>
    <td>
      Specifies the subpath to which Carvel Packages should be written.
    </td>
    <td>
      <pre>
      - name: carvel_package_gitops_subpath
        value: path/to/my/dir
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>carvel_package_name_suffix<code></td>
    <td>
      Specifies the suffix to append to the Carvel Package name. The format is WORKLOAD_NAME.WORKLOAD_NAMESPACE.carvel_package_name_suffix The full Carvel Package name must be a valid DNS subdomain name as defined in RFC 1123.
    </td>
    <td>
      <pre>
      - name: carvel_package_name_suffix
        value: vmware.com
      </pre>
    </td>
  </tr>
</table>

### More Information

See [Gitops vs RegistryOps](gitops-vs-regops.hbs.md) for more information about the operation of this template
and of the [package-config-writer-and-pull-requester-template (experimental)](#package-config-writer-and-pull-requester-template-experimental).

## package-config-writer-and-pull-requester-template (experimental)

### Purpose
Persist the passed in Carvel Package Kubernetes configuration to a branch in a repository and open a pull request to another branch.
(This process allows for manual review of configuration before deployment to a cluster)

### Used by

- [Source-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#source-to-url-package-experimental) in the config-writer step.
- [Basic-Image-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#basic-image-to-url-package-experimental) in the config-writer step.

### Creates

A runnable which provides configuration to the ClusterRunTemplate `commit-and-pr-pipelinerun` to create a
Tekton TaskRun. The Tekton TaskRun refers to the Tekton Task `commit-and-pr`.

### Parameters

<table>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>serviceAccount<code></td>
    <td>
      Name of the service account which provides the credentials to the registry or repository.
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
    <td><code>gitops_commit_branch<code></td>
    <td>
      Name of the branch to which configuration is pushed.
    </td>
    <td>
      <pre>
      - name: gitops_commit_branch
        value: feature
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_branch<code></td>
    <td>
      Name of the branch to which a pull request is opened.
    </td>
    <td>
      <pre>
      - name: gitops_branch
        value: main
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_user_name<code></td>
    <td>
      User name to use in the commits.
    </td>
    <td>
      <pre>
      - name: gitops_user_name
        value: "Alice Lee"
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_user_email<code></td>
    <td>
      User email address to use in the commits.
    </td>
    <td>
      <pre>
      - name: gitops_user_email
        value: alice@example.com
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_commit_message<code></td>
    <td>
      Message to write as the body of the commits produced for pushing configuration to the Git repository.
    </td>
    <td>
      <pre>
      - name: gitops_commit_message
        value: "ci bump"
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_pull_request_title<code></td>
    <td>
      Title of the pull request to be opened.
    </td>
    <td>
      <pre>
      - name: gitops_pull_request_title
        value: "ready for review"
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_pull_request_body<code></td>
    <td>
      Body of the pull request to be opened.
    </td>
    <td>
      <pre>
      - name: gitops_pull_request_body
        value: "generated by supply chain"
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_server_address<code></td>
    <td>
      The server URL of the Git repository to which configuration is applied.
    </td>
    <td>
      <pre>
      - name: gitops_server_address
        value: "https://github.com/"
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_repository_owner<code></td>
    <td>
      The owner/organization to which the repository belongs.
    </td>
    <td>
      <pre>
      - name: gitops_repository_owner
        value: vmware-tanzu
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_repository_name<code></td>
    <td>
      The name of the repository.
    </td>
    <td>
      <pre>
      - name: gitops_repository_name
        value: cartographer
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_server_kind<code></td>
    <td>
      The kind of Git provider
    </td>
    <td>
      <pre>
      - name: gitops_server_kind
        value: gitlab
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>carvel_package_gitops_subpath<code></td>
    <td>
      Specifies the subpath to which Carvel Packages should be written.
    </td>
    <td>
      <pre>
      - name: carvel_package_gitops_subpath
        value: path/to/my/dir
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>carvel_package_name_suffix<code></td>
    <td>
      Specifies the suffix to append to the Carvel Package name. The format is WORKLOAD_NAME.WORKLOAD_NAMESPACE.carvel_package_name_suffix The full Carvel Package name must be a valid DNS subdomain name as defined in RFC 1123.
    </td>
    <td>
      <pre>
      - name: carvel_package_name_suffix
        value: vmware.com
      </pre>
    </td>
  </tr>

</table>

### More Information

See [Gitops vs RegistryOps](gitops-vs-regops.hbs.md) for more information about the operation of this template
and of the [package-config-writer-template (experimental)](#package-config-writer-template-experimental).

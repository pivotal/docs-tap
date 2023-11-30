# Template reference for Supply Chain Choreographer

This topic describes the objects from templates that you can use with Supply Chain Choreographer.

All the objects referenced in this topic are
[Cartographer Templates](https://cartographer.sh/docs/v0.6.0/reference/template/)
packaged in [Out of the Box Templates](ootb-templates.hbs.md).

This topic describes:

- The purpose of the templates
- The one or more objects that the templates create
- The supply chains that include the templates
- The parameters that the templates use

## <a id='source-template'></a> source-template

### <a id='source-template-purpose'></a> Purpose

Creates an object to fetch source code and make that code available
to other objects in the supply chain. See [Building from
Source](building-from-source.hbs.md).

### <a id='source-template-used'></a> Used by

- [Source-to-URL](ootb-supply-chain-reference.hbs.md#source-url) in the `source-provider` step.
- [Source-Test-to-URL](ootb-supply-chain-reference.hbs.md#source-test) in the `source-provider` step.
- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan) in the `source-provider` step.
- [Source-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#source-package) in the `source-provider` step.

### <a id='source-template-creates'></a> Creates

The source-template creates one of three objects, either:

- GitRepository. Created if the workload has `.spec.source.git` defined.
- MavenArtifact. Created if the template is provided a value for the parameter `maven`.
- ImageRepository. Created if the workload has `.spec.source.image` defined.

#### <a id='source-template-git-repo'></a> GitRepository

`GitRepository` makes source code from a particular commit available as a tarball in the
cluster. Other resources in the supply chain can then access that code.

##### <a id='source-template-params'></a> Parameters

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
    </td>
    <td>
      <pre>
      - name: gitImplementation
        value: go-git`
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

##### <a id='source-template-more-info'></a> More information

For an example using the Tanzu CLI to create a Workload using GitHub as the provider of source code,
see [Create a workload from GitHub repository](../cli-plugins/apps/tutorials/create-update-workload.hbs.md#create-workload-from-git-source).

For information about GitRepository objects, see
[GitRepository](https://fluxcd.io/flux/components/source/gitrepositories/).

#### <a id='image-repository'></a> ImageRepository

`ImageRepository` makes the contents of a container image available as a tarball on the cluster.

##### <a id='image-repository-params'></a> Parameters

<table>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>serviceAccount<code></td>
    <td>
      Name of the service account, providing credentials to <code>ImageRepository</code> for fetching container images.
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

##### <a id='image-repository-more-info'></a> More information

For information about the ImageRepository resource, see the [ImageRepository reference
documentation](../source-controller/reference.hbs.md#image-repository).

For information about how to use the Tanzu CLI to create a workload leveraging ImageRepository, see
[Create a workload from local source code](../cli-plugins/apps/tutorials/create-update-workload.hbs.md#create-a-workload-from-local-source).

#### <a id='maven-artifact'></a> MavenArtifact

`MavenArtifact` makes a pre-built Java artifact available to as a tarball on the cluster.

While the `source-template` leverages the workload's `.spec.source` field when creating a
`GitRepository` or `ImageRepository` object, the creation of the `MavenArtifact` relies only on
parameters in the Workload.

##### <a id='maven-artifact-params'></a> Parameters

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
    <tr>
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
    </tr>
    <tr>
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
</table>

##### <a id='maven-artifact-more-info'></a> More information

For information about the custom resource, see [MavenArtifact reference
docs](../source-controller/reference.hbs.md#maven-artifact).

For information about how to use the custom resource with the Tanzu Apps CLI plug-in, see [Create a workload from a Maven repository artifact](../cli-plugins/apps/tutorials/create-update-workload.hbs.md#create-workload-maven).

## <a id='testing-pipeline'></a> testing-pipeline

### <a id='testing-pipeline-purpose'></a> Purpose

Tests the source code provided in the supply chain.
Testing depends on a user provided
[Tekton Pipeline](https://tekton.dev/docs/pipelines/pipelines/#overview).
Parameters for this template allow for selection of the proper Pipeline and
for specification of additional values to pass to the Pipeline.

### <a id='testing-pipeline-used'></a> Used by

- [Source-Test-to-URL](ootb-supply-chain-reference.hbs.md#source-test) in the source-tester step.
- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan) in the source-tester step.

These are used as the `source-tester` resource.

### <a id='testing-pipeline-creates'></a> Creates

`testing-pipeline`creates a [Runnable](https://cartographer.sh/docs/v0.4.0/reference/runnable/)
object. This Runnable provides inputs to the
[ClusterRunTemplate](https://cartographer.sh/docs/v0.4.0/reference/runnable/#clusterruntemplate)
named [tekton-source-pipelinerun](ootb-cluster-run-template-reference.hbs.md#tekton-source).

### <a id='testing-pipeline-params'></a> Parameters

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
      <code>apps.tanzu.vmware.com/pipeline: test</code> is selected.
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
      and revision as <code>source-url</code> and <code>source-revision</code>.
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

### <a id='testing-pipeline-more-info'></a> More information

For information about the ClusterRunTemplate that pairs with the Runnable, read
[tekton-source-pipelinerun](ootb-cluster-run-template-reference.hbs.md#tekton-source)

For information about the Tekton Pipeline that the user must create, read the [OOTB Supply Chain
Testing documentation of the Pipeline](ootb-supply-chain-testing.hbs.md)

## <a id='source-scanner'></a> source-scanner-template

### <a id='source-scanner-purpose'></a> Purpose
Scans the source code for vulnerabilities.

### <a id='source-scanner-used'></a> Used by

- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan) in the source-scanner step.

This is used as the `source-scanner` resource.

### <a id='source-scanner-creates'></a> Creates

[SourceScan](../scst-scan/overview.hbs.md)

### <a id='source-scanner-params'></a> Parameters

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

### <a id='source-scanner-more-info'></a> More information

For information about how to set up the Workload namespace with the ScanPolicy and
ScanTemplate required for this resource, see [Out of the Box Supply Chain with Testing and
Scanning](ootb-supply-chain-testing-scanning.hbs.md#developer-namespace).

For information about the SourceScan custom resource, see [SourceScan reference](../scst-scan/scan-crs.hbs.md#sourcescan).

For information about how the artifacts found
during scanning are catalogued, see [Supply Chain Security Tools for Tanzu –
Store](../scst-store/overview.hbs.md).

## <a id='image-provider'></a> image-provider-template

### <a id='image-provider-purpose'></a> Purpose

Fetches a container image of a prebuilt application,
specified in the workload's `.spec.image` field.
This makes the content-addressable name, (e.g. the image name containing the digest)
available to other resources in the supply chain.

### <a id='image-provider-used'></a> Used by

- [Basic-Image-to-URL](ootb-supply-chain-reference.hbs.md#basic-image) in the image-provider step.
- [Testing-Image-to-URL](ootb-supply-chain-reference.hbs.md#testing-image) in the image-provider step.
- [Scanning-Image-Scan-to-URL](ootb-supply-chain-reference.hbs.md#scanning-image) in the image-provider step.
- [Basic-Image-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#basic-package) in the image-provider step.

These are used as the `image-provider` resource.

### <a id='image-provider-creates'></a> Creates

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

### <a id='image-provider-more-info'></a> More information

For information about the ImageRepository resource,
see [ImageRepository reference docs](../source-controller/reference.hbs.md#imagerepository).

For information about prebuilt images,
see [Using a prebuilt image](pre-built-image.hbs.md).

## <a id='kpack'></a> kpack-template

### <a id='kpack-purpose'></a> Purpose

Builds an container image from source code using [cloud native buildpacks](https://buildpacks.io/).

### <a id='kpack-used'></a> Used by

- [Source-to-URL](ootb-supply-chain-reference.hbs.md#source-url) in the image-provider step.
- [Source-Test-to-URL](ootb-supply-chain-reference.hbs.md#source-test) in the image-provider step.
- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan) in the image-provider step.
- [Source-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#source-package) in the image-provider step.

These are used as the `image-provider` resource when the workload parameter `dockerfile` is not defined.

### <a id='kpack-creates'></a> Creates

[Image.kpack.io](https://github.com/pivotal/kpack/blob/main/docs/image.md)

### <a id='kpack-params'></a> Parameters

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
      <code>Image</code> uses these credentials to push built container images to the registry.
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

### <a id='kpack-more-info'></a> More information

For information about the integration with Tanzu Build Service,
see [Tanzu Build Service Integration](tbs.hbs.md).

For information about `live-update`,
see [Developer Conventions](../developer-conventions/about.hbs.md) and [Overview of Tanzu Developer Tools for IntelliJ](../intellij-extension/about.hbs.md).

For information about using Kpack builders with `clusterBuilder`,
see [Builders](https://github.com/pivotal/kpack/blob/main/docs/builders.md).

For information about `buildServiceBindings`,
see [Service Bindings](https://github.com/pivotal/kpack/blob/main/docs/servicebindings.md).

## <a id='kaniko'></a> kaniko-template

### <a id='kaniko-purpose'></a> Purpose

Build an image for source code that includes a Dockerfile.

### <a id='kaniko-used'></a> Used by

- [Source-to-URL](ootb-supply-chain-reference.hbs.md#source-url) in the image-provider step.
- [Source-Test-to-URL](ootb-supply-chain-reference.hbs.md#source-test) in the image-provider step.
- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan) in the image-provider step.
- [Source-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#source-package) in the image-provider step.

These are used as the `image-provider` resource when the workload parameter `dockerfile` is defined.

### <a id='kaniko-creates'></a> Creates

A taskrun.tekton.dev provides configuration to the Tekton Task `kaniko-build` which builds an image with kaniko.

This template uses the [lifecycle: tekton](https://cartographer.sh/docs/v0.6.0/lifecycle/)
flag to create new immutable objects rather than updating the previous object.

### <a id='kaniko-params'></a> Parameters

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

### <a id='kaniko-more-info'></a> More information

For information about how to use Dockerfile-based builds and limits associated with the function, see
[Dockerfile-based builds](dockerfile-based-builds.hbs.md).

For information about `lifecycle:tekton`,
read [Cartographer Lifecycle](https://cartographer.sh/docs/v0.6.0/lifecycle/).

## <a id='image-scanner'></a> image-scanner-template

### <a id='image-scanner-purpose'></a> Purpose

Scans the container image for vulnerabilities,
persists the results in a store,
and prevents the image from moving forward
if CVEs are found which are not compliant with its referenced ScanPolicy.

### <a id='image-scanner-used'></a> Used by

- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan) in the image-scanner step.
- [Scanning-Image-Scan-to-URL](ootb-supply-chain-reference.hbs.md#scanning-image) in the image-scanner step.

### <a id='image-scanner-creates'></a> Creates

ImageScan.scanning.apps.tanzu.vmware.com

### <a id='image-scanner-params'></a> Parameters

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

### <a id='image-scanner-more-info'></a> More information

For information about the ImageScan custom resource,
see [ImageScan reference](../scst-scan/scan-crs.hbs.md#imagescan).

For information about how the artifacts found during scanning are catalogued,
see [Supply Chain Security Tools for Tanzu – Store](../scst-store/overview.hbs.md).

## <a id='convention'></a> convention-template

### <a id='convention-purpose'></a> Purpose

Create the PodTemplateSpec for the Kubernetes configuration (e.g. the knative service or kubernetes deployment)
which are applied to the cluster.

### <a id='convention-used'></a> Used by

- [Source-to-URL](ootb-supply-chain-reference.hbs.md#source-url) in the config-provider step.
- [Basic-Image-to-URL](ootb-supply-chain-reference.hbs.md#basic-image) in the config-provider step.
- [Source-Test-to-URL](ootb-supply-chain-reference.hbs.md#source-test) in the config-provider step.
- [Testing-Image-to-URL](ootb-supply-chain-reference.hbs.md#testing-image) in the config-provider step.
- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan) in the config-provider step.
- [Scanning-Image-Scan-to-URL](ootb-supply-chain-reference.hbs.md#scanning-image) in the config-provider step.
- [Source-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#source-package) in the config-provider step.
- [Basic-Image-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#basic-package) in the config-provider step.

### <a id='convention-creates'></a> Creates

Creates a [PodIntent](../cartographer-conventions/reference/pod-intent.hbs.md) object.
The PodIntent leverages conventions installed on the cluster.
The PodIntent object is responsible for generating a PodTemplateSpec.
The PodTemplateSpec is used in app configs, such as knative services and deployments,
to represent the shape of the pods to run the application in containers.

### <a id='convention-params'></a> Parameters

<table>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>serviceAccount<code></td>
    <td>
      Name of the serviceAccount providing necessary credentials to <code>PodIntent</code>.
      The serviceAccount must be in the same namespace as the Workload.
      The serviceAccount is set as the <code>serviceAccountName</code> in the podtemplatespec.
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

### <a id='convention-more-info'></a> More information

For information about `PodTemplateSpec`, see
[PodTemplateSpec](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-template-v1/#PodTemplateSpec)
in the Kubernetes documentation.

For information about conventions, see
[Cartographer Conventions](../cartographer-conventions/about.hbs.md).

For information about the two convention servers enabled by default in Tanzu
Application Platform installations, see [Developer
Conventions](../developer-conventions/about.hbs.md) and [Spring Boot
conventions](../spring-boot-conventions/about.hbs.md).

## <a id='config'></a> config-template

### <a id='config-purpose'></a> Purpose

For workloads with the label `apps.tanzu.vmware.com/workload-type: web`, define a knative service.

### <a id='config-used'></a> Used by

- [Source-to-URL](ootb-supply-chain-reference.hbs.md#source-url) in the app-config step.
- [Basic-Image-to-URL](ootb-supply-chain-reference.hbs.md#basic-image) in the app-config step.
- [Source-Test-to-URL](ootb-supply-chain-reference.hbs.md#source-test) in the app-config step.
- [Testing-Image-to-URL](ootb-supply-chain-reference.hbs.md#testing-image) in the app-config step.
- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan) in the app-config step.
- [Scanning-Image-Scan-to-URL](ootb-supply-chain-reference.hbs.md#scanning-image) in the app-config step.

### <a id='config-creates'></a> Creates

A ConfigMap, in which the data field has a key `delivery.yaml` whose value is the definition of a knative service.

### <a id='config-params'></a> Parameters

None

### <a id='config-more-info'></a> More information

See [workload types](../workloads/workload-types.hbs.md) for more details about the
three different types of workloads.

## <a id='worker'></a> worker-template

### <a id='worker-purpose'></a> Purpose

For workloads with the label `apps.tanzu.vmware.com/workload-type: worker`, define a Kubernetes Deployment.

### <a id='worker-used'></a> Used by

- [Source-to-URL](ootb-supply-chain-reference.hbs.md#source-url) in the app-config step.
- [Basic-Image-to-URL](ootb-supply-chain-reference.hbs.md#basic-image) in the app-config step.
- [Source-Test-to-URL](ootb-supply-chain-reference.hbs.md#source-test) in the app-config step.
- [Testing-Image-to-URL](ootb-supply-chain-reference.hbs.md#testing-image) in the app-config step.
- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan) in the app-config step.
- [Scanning-Image-Scan-to-URL](ootb-supply-chain-reference.hbs.md#scanning-image) in the app-config step.

### <a id='worker-creates'></a> Creates

A ConfigMap, in which the data field has a key `delivery.yaml` whose value is the definition of a Kubernetes Deployment.

### <a id='worker-params'></a> Parameters

None

### <a id='worker-more-info'></a> More information

For information about the three different types of workloads, see [workload
types](../workloads/workload-types.hbs.md).

## <a id='server'></a> server-template

### <a id='server-purpose'></a> Purpose

For workloads with the label `apps.tanzu.vmware.com/workload-type: server`,
define a Kubernetes Deployment and a Kubernetes Service.

### <a id='server-used'></a> Used by

- [Source-to-URL](ootb-supply-chain-reference.hbs.md#source-url) in the app-config step.
- [Basic-Image-to-URL](ootb-supply-chain-reference.hbs.md#basic-image) in the app-config step.
- [Source-Test-to-URL](ootb-supply-chain-reference.hbs.md#source-test) in the app-config step.
- [Testing-Image-to-URL](ootb-supply-chain-reference.hbs.md#testing-image) in the app-config step.
- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan) in the app-config step.
- [Scanning-Image-Scan-to-URL](ootb-supply-chain-reference.hbs.md#scanning-image) in the app-config step.
- [Source-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#source-package) in the app-config step.
- [Basic-Image-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#basic-package) in the app-config step.

### <a id='server-creates'></a> Creates

A ConfigMap, in which the data field has a key `delivery.yaml` whose value is the definitions of a Kubernetes
Deployment and a Kubernetes Service to expose the pods.

### <a id='server-params'></a> Parameters

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

### <a id='server-more-info'></a> More information

For information about the three different types of workloads, see [workload
types](../workloads/workload-types.hbs.md).

For information about the ports parameter, see [server-specific Workload
parameters](../workloads/server.hbs.md#params).

## <a id='service-bindings'></a> service-bindings

### <a id='service-bindings-purpose'></a> Purpose

Adds [ServiceBindings](../service-bindings/about.hbs.md)
to the set of Kubernetes configuration files.

### <a id='service-bindings-used'></a> Used by

- [Source-to-URL](ootb-supply-chain-reference.hbs.md#source-url) in the service-bindings step.
- [Basic-Image-to-URL](ootb-supply-chain-reference.hbs.md#basic-image) in the service-bindings step.
- [Source-Test-to-URL](ootb-supply-chain-reference.hbs.md#source-test) in the service-bindings step.
- [Testing-Image-to-URL](ootb-supply-chain-reference.hbs.md#testing-image) in the service-bindings step.
- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan) in the service-bindings step.
- [Scanning-Image-Scan-to-URL](ootb-supply-chain-reference.hbs.md#scanning-image) in the service-bindings step.
- [Source-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#source-package) in the service-bindings step.
- [Basic-Image-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#basic-package) in the service-bindings step.

### <a id='service-bindings-creates'></a> Creates

A ConfigMap. This template consumes input of multiple deployment YAML files and
enriches the input with ResourceClaims and ServiceBindings if the workload contains serviceClaims.

### <a id='service-bindings-params'></a> Parameters

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

### <a id='service-bindings-more-info'></a> More information

For an example of using `--service-ref`, see the [Tanzu CLI Command Reference](https://docs.vmware.com/en/VMware-Tanzu-CLI/1.1/tanzu-cli/command-ref.html) documentation.


For an overview of the function, see
[Consume services on Tanzu Application Platform](../getting-started/consume-services.hbs.md).

## <a id='api-descriptors'></a> api-descriptors

### <a id='api-descriptors-purpose'></a> Purpose

The `api-descriptor` resource takes care of adding an
[APIDescriptor](../api-auto-registration/key-concepts.hbs.md) to the set of
Kubernetes objects to deploy such that API auto registration takes place.

### <a id='api-descriptors-used'></a> Used by

- [Source-to-URL](ootb-supply-chain-reference.hbs.md#source-url) in the api-descriptors step.
- [Basic-Image-to-URL](ootb-supply-chain-reference.hbs.md#basic-image) in the api-descriptors step.
- [Source-Test-to-URL](ootb-supply-chain-reference.hbs.md#source-test) in the api-descriptors step.
- [Testing-Image-to-URL](ootb-supply-chain-reference.hbs.md#testing-image) in the api-descriptors step.
- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan) in the api-descriptors step.
- [Scanning-Image-Scan-to-URL](ootb-supply-chain-reference.hbs.md#scanning-image) in the api-descriptors step.
- [Source-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#source-package) in the api-descriptors step.
- [Basic-Image-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#basic-package) in the api-descriptors step.

### <a id='api-descriptors-creates'></a> Creates

A ConfigMap. This template consumes input of multiple YAML files and
enriches the input with an APIDescriptor if
the workload has a label `apis.apps.tanzu.vmware.com/register-api` == to `true`.

### <a id='api-descriptors-params'></a> Parameters

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

### <a id='api-descriptors-more-info'></a> More information

For information about API auto registration, see [Use API Auto Registration](../api-auto-registration/usage.hbs.md).

## <a id='config-writer'></a> config-writer-template

### <a id='config-writer-purpose'></a> Purpose

Persist in an external system, such as a registry or git repository, the
Kubernetes configuration passed to the template.

### <a id='config-writer-used'></a> Used by

- [Source-to-URL](ootb-supply-chain-reference.hbs.md#source-url) in the config-writer step.
- [Basic-Image-to-URL](ootb-supply-chain-reference.hbs.md#basic-image) in the config-writer step.
- [Source-Test-to-URL](ootb-supply-chain-reference.hbs.md#source-test) in the config-writer step.
- [Testing-Image-to-URL](ootb-supply-chain-reference.hbs.md#testing-image) in the config-writer step.
- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan) in the config-writer step.
- [Scanning-Image-Scan-to-URL](ootb-supply-chain-reference.hbs.md#scanning-image) in the config-writer step.

### <a id='config-writer-creates'></a> Creates

A runnable which creates a Tekton TaskRun that refers either to
the Tekton Task `git-writer` or the Tekton Task `image-writer`.

### <a id='config-writer-params'></a> Parameters

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

### <a id='config-writer-more-info'></a> More information

For information about operating this template, see [Gitops vs RegistryOps](gitops-vs-regops.hbs.md)
and the [config-writer-and-pull-requester-template](#config-writer-and-pull-requester-template).

## <a id='config-writer-pr'></a> config-writer-and-pull-requester-template

### <a id='config-writer-pr-purpose'></a> Purpose

Persist the passed in Kubernetes configuration to a branch in a repository and open a pull request to another branch.
This process allows for manual review of configuration before deployment to a cluster.

### <a id='config-writer-pr-used'></a> Used by

- [Source-to-URL](ootb-supply-chain-reference.hbs.md#source-url) in the config-writer step.
- [Basic-Image-to-URL](ootb-supply-chain-reference.hbs.md#basic-image) in the config-writer step.
- [Source-Test-to-URL](ootb-supply-chain-reference.hbs.md#source-test) in the config-writer step.
- [Testing-Image-to-URL](ootb-supply-chain-reference.hbs.md#testing-image) in the config-writer step.
- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan) in the config-writer step.
- [Scanning-Image-Scan-to-URL](ootb-supply-chain-reference.hbs.md#scanning-image) in the config-writer step.

### <a id='config-writer-pr-creates'></a> Creates

A Tekton TaskRun refers to the Tekton Task `commit-and-pr`.

### <a id='config-writer-pr-params'></a> Parameters

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
    <td><code>ca_cert_data<code></td>
    <td>
      The string contents of the ssl certificate of the git server
    </td>
    <td>
      <pre>
      - name: ca_cert_data
        value:
          -----BEGIN CERTIFICATE-----
          MIIFXzCCA0egAwIBAgIJAJYm37SFocjlMA0GCSqGSIb3DQEBDQUAMEY...
          -----END CERTIFICATE-----
      </pre>
    </td>
  </tr>

</table>

### <a id='config-writer-pr-more-info'></a> More information

For information about the operation of this template, see [Gitops vs RegistryOps](gitops-vs-regops.hbs.md)
and the [config-writer-template](#config-writer-template).

## <a id='deliverable'></a> deliverable-template

### <a id='deliverable-purpose'></a> Purpose

Create a deliverable which
[pairs with a Delivery](https://cartographer.sh/docs/v0.6.0/architecture/#clusterdelivery)
to deploy Kubernetes configuration on the cluster.

### <a id='deliverable-used'></a> Used by

- [Source-to-URL](ootb-supply-chain-reference.hbs.md#source-url) in the deliverable step.
- [Basic-Image-to-URL](ootb-supply-chain-reference.hbs.md#basic-image) in the deliverable step.
- [Source-Test-to-URL](ootb-supply-chain-reference.hbs.md#source-test) in the deliverable step.
- [Testing-Image-to-URL](ootb-supply-chain-reference.hbs.md#testing-image) in the deliverable step.
- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan) in the deliverable step.
- [Scanning-Image-Scan-to-URL](ootb-supply-chain-reference.hbs.md#scanning-image) in the deliverable step.

### <a id='deliverable-creates'></a> Creates

A [Deliverable](https://cartographer.sh/docs/v0.6.0/reference/deliverable/#deliverable)
preconfigured with reference to a repository or registry from which to fetch Kubernetes configuration.

### <a id='deliverable-params'></a> Parameters

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

### <a id='deliverable-more-info'></a> More information

For information about the ClusterDelivery shipped with `ootb-delivery-basic`,
see [Out of the Box Delivery Basic](ootb-delivery-basic.hbs.md).

## <a id='external-deliverable'></a> external-deliverable-template

### <a id='external-deliverable-purpose'></a> Purpose

Create a definition of a deliverable which a user can manually applied to
an external kubernetes cluster. When a properly configured Delivery is installed on that
external cluster, the Deliverable will
[pair with the Delivery](https://cartographer.sh/docs/v0.6.0/architecture/#clusterdelivery)
to deploy Kubernetes configuration on the cluster. For example, the [OOTB Delivery](ootb-delivery-basic.hbs.md).

### <a id='external-deliverable-used'></a> Used by

- [Source-to-URL](ootb-supply-chain-reference.hbs.md#source-url) in the deliverable step.
- [Basic-Image-to-URL](ootb-supply-chain-reference.hbs.md#basic-image) in the deliverable step.
- [Source-Test-to-URL](ootb-supply-chain-reference.hbs.md#source-test) in the deliverable step.
- [Testing-Image-to-URL](ootb-supply-chain-reference.hbs.md#testing-image) in the deliverable step.
- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan) in the deliverable step.
- [Scanning-Image-Scan-to-URL](ootb-supply-chain-reference.hbs.md#scanning-image) in the deliverable step.

### <a id='external-deliverable-creates'></a> Creates

A configmap in which the `.data` field has a key `deliverable` for which the value is the YAML definition
of a [Deliverable](https://cartographer.sh/docs/v0.6.0/reference/deliverable/#deliverable).

### <a id='external-deliverable-params'></a> Parameters

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

### <a id='external-deliverable-more-info'></a> More information

For information about the ClusterDelivery shipped with `ootb-delivery-basic`,
see [Out of the Box Delivery Basic](ootb-delivery-basic.hbs.md).

For information about using the Deliverable object in a multicluster
environment, see [Getting started with multicluster Tanzu Application
Platform](../multicluster/getting-started.hbs.md).

## <a id='delivery-source'></a> delivery-source-template

### <a id='delivery-source-purpose'></a> Purpose

Continuously fetches Kubernetes configuration files from a Git repository
or container image registry and makes them available on the cluster.

### <a id='delivery-source-used'></a> Used by

- [Delivery-Basic](ootb-delivery-reference.hbs.md#delivery-basic)

### <a id='delivery-source-creates'></a> Creates

The source-template creates one of three objects, either:
- GitRepository. Created if the deliverable has `.spec.source.git` defined.
- ImageRepository. Created if the deliverable has `.spec.source.image` defined.

#### <a id='delivery-source-git-repo'></a> GitRepository

`GitRepository` makes source code from a particular commit available as a tarball in the
cluster. Other resources in the supply chain can then access that code.

##### <a id='delivery-source-params'></a> Parameters

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
    </td>
    <td>
      <pre>
      - name: gitImplementation
        value: go-git
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

##### <a id='delivery-source-more-info'></a> More information

For an example using the Tanzu CLI to create a Workload using GitHub as the provider of source code,
see [Create a workload from GitHub repository](../cli-plugins/apps/tutorials/create-update-workload.hbs.md).

For information about GitRepository objects, see
[GitRepository](https://fluxcd.io/flux/components/source/gitrepositories/).

#### <a id='delivery-source-image-repo'></a> ImageRepository

`ImageRepository` makes the contents of a container image available as a tarball on the cluster.

##### <a id='image-repo-params'></a> Parameters

<table>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>serviceAccount<code></td>
    <td>
      Name of the service account, providing credentials to <code>ImageRepository</code> for fetching container images.
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

##### <a id='image-repo-more-info'></a> More information

For information about the ImageRepository resource, see [ImageRepository reference
docs](../source-controller/reference.hbs.md#imagerepository).

## <a id='app-deploy'></a> app-deploy

### <a id='app-deploy-purpose'></a> Purpose
Applies Kubernetes configuration to the cluster.

### <a id='app-deploy-used'></a> Used by

- [Delivery-Basic](ootb-delivery-reference.hbs.md#delivery-basic)

### <a id='app-deploy-creates'></a> Creates

A [kapp App](https://carvel.dev/kapp-controller/docs/v0.41.0/app-overview/).

### <a id='app-deploy-params'></a> Parameters

<table>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>serviceAccount<code></td>
    <td>
      Name of the service account providing the necessary privileges for <code>App</code> to apply
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

### <a id='app-deploy-more info'></a> More information

For details about RBAC and how `kapp-controller` makes use of the ServiceAccount provided through the Deliverable's
`serviceAccount` parameter,
see [kapp-controller's Security Model](https://carvel.dev/kapp-controller/docs/v0.41.0/security-model/).

## <a id='carvel'></a> carvel-package (experimental)

### <a id='carvel-purpose'></a> Purpose

Bundles Kubernetes configuration into a Carvel Package.

### <a id='carvel-used'></a> Used by

- [Source-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#source-package) in the carvel-package step.
- [Basic-Image-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#basic-package) in the carvel-package step.

### <a id='carvel-creates'></a> Creates

A taskrun.tekton.dev which provides configuration to the `carvel-package` Tekton Task which bundles Kubernetes
configuration into a Carvel Package.

This template uses the [lifecycle: tekton](https://cartographer.sh/docs/v0.6.0/lifecycle/)
flag to create new immutable objects rather than updating the previous object.

### <a id='carvel-params'></a> Parameters

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

  <tr>
    <td><code>carvel_package_parameters<code></td>
    <td>
      Specifies the custom Carvel Package parameters
    </td>
    <td>
      <pre>
      - name: carvel_package_parameters
        value: |
        - selector:
            matchLabels:
              apps.tanzu.vmware.com/workload-type: server
          schema: |
            #@data/values-schema
            ---
            #@schema/title "Workload name"
            #@schema/example "tanzu-java-web-app"
            #@schema/validation min_len=1
            workload_name: ""

            #@schema/title "Replicas"
            replicas: 1

            #@schema/title "Port"
            port: 8080

            #@schema/title "Hostname"
            #@schema/example "app.tanzu.vmware.com"
            hostname: ""

            #@schema/title "Cluster Issuer"
            cluster_issuer: "tap-ingress-selfsigned"

            #@schema/nullable
            http_route:
                #@schema/default [{"protocol": "https", "name": "default-gateway"}]
                gateways:
                - protocol: ""
                  name: ""
          overlays: |
            #@ load("@ytt:overlay", "overlay")
            #@ load("@ytt:data", "data")

            #@overlay/match by=overlay.subset({"apiVersion":"apps/v1", "kind": "Deployment"})
            ---
            spec:
              #@overlay/match missing_ok=True
              replicas: #@ data.values.replicas

            #@ if data.values.http_route != None:
            ---
            apiVersion: gateway.networking.k8s.io/v1beta1
            kind: HTTPRoute
            metadata:
              name: #@ data.values.workload_name + "-route"
            spec:
              parentRefs:
              #@ for/end gateway in data.values.http_route.gateways:
              - group: gateway.networking.k8s.io
                kind: Gateway
                name: #@ gateway.name
                sectionName: #@ gateway.protocol + "-" + data.values.workload_name
              rules:
              - backendRefs:
                - name: #@ data.values.workload_name
                  port: #@ data.values.port
            #@ elif data.values.hostname != "":
            ---
            apiVersion: networking.k8s.io/v1
            kind: Ingress
            metadata:
              name: #@ data.values.workload_name
              annotations:
                cert-manager.io/cluster-issuer:  #@ data.values.cluster_issuer
                ingress.kubernetes.io/force-ssl-redirect: "true"
                kubernetes.io/ingress.class: contour
                kapp.k14s.io/change-rule: "upsert after upserting Services"
              labels:
                app.kubernetes.io/component: "run"
                carto.run/workload-name:  #@ data.values.workload_name
            spec:
              tls:
                - secretName: #@ data.values.workload_name
                  hosts:
                  - #@ data.values.hostname
              rules:
              - host: #@ data.values.hostname
                http:
                  paths:
                  - pathType: Prefix
                    path: /
                    backend:
                      service:
                        name: #@ data.values.workload_name
                        port:
                          number: #@ data.values.port
            #@ end
        - selector:
            matchLabels:
              apps.tanzu.vmware.com/workload-type: web
          schema: |
            #@data/values-schema
            ---
            #@schema/validation min_len=1
            workload_name: ""
          overlays: ""
        - selector:
            matchLabels:
              apps.tanzu.vmware.com/workload-type: worker
          schema: |
            #@data/values-schema
            ---
            #@schema/validation min_len=1
            workload_name: ""
            replicas: 1
          overlays: |
            #@ load("@ytt:overlay", "overlay")
            #@ load("@ytt:data", "data")
            #@overlay/match by=overlay.subset({"apiVersion":"apps/v1", "kind": "Deployment"})
            ---
            spec:
              #@overlay/match missing_ok=True
              replicas: #@ data.values.replicas
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>carvel_package_openapiv3_enabled<code></td>
    <td>
      Specifies whether the Carvel Package should include a generated OpenAPIv3 specification
    </td>
    <td>
      <pre>
      - name: carvel_package_openapiv3_enabled
        value: true
      </pre>
    </td>
  </tr>
</table>

### <a id='carvel-more-info'></a> More information

To read more about `lifecycle:tekton`,
read [Cartographer Lifecycle](https://cartographer.sh/docs/v0.6.0/lifecycle/).

## <a id='package-config-writer'></a> package-config-writer-template (experimental)

### <a id='package-config-writer-purpose'></a> Purpose

Persist in an external git repository the Carvel Package Kubernetes configuration passed to the template.

### <a id='package-config-writer-used'></a> Used by

- [Source-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#source-package) in the config-writer step.
- [Basic-Image-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#basic-package) in the config-writer step.

### <a id='package-config-writer-creates'></a> Creates

A runnable which creates a Tekton TaskRun that refers either to the Tekton Task `git-writer`.

### <a id='package-config-writer-params'></a> Parameters

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

### <a id='package-config-writer-more-info'></a> More information

See [Gitops vs RegistryOps](gitops-vs-regops.hbs.md) for more information about the operation of this template
and of the [package-config-writer-and-pull-requester-template (experimental)](#package-config-writer-and-pull-requester-template-experimental).

## <a id='package-config-writer-pr'></a> package-config-writer-and-pull-requester-template (experimental)

### <a id='package-config-writer-pr-purpose'></a> Purpose
Persist the passed in Carvel Package Kubernetes configuration to a branch in a repository and open a pull request to another branch.
(This process allows for manual review of configuration before deployment to a cluster)

### <a id='package-config-writer-pr-used'></a> Used by

- [Source-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#source-package) in the config-writer step.
- [Basic-Image-to-URL-Package (experimental)](ootb-supply-chain-reference.hbs.md#basic-package) in the config-writer step.

### <a id='package-config-writer-pr-creates'></a> Creates

A Tekton TaskRun which refers to the Tekton Task `commit-and-pr`.

### <a id='package-config-writer-pr-params'></a> Parameters

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

  <tr>
    <td><code>ca_cert_data<code></td>
    <td>
      The string contents of the ssl certificate of the git server
    </td>
    <td>
      <pre>
      - name: ca_cert_data
        value:
          -----BEGIN CERTIFICATE-----
          MIIFXzCCA0egAwIBAgIJAJYm37SFocjlMA0GCSqGSIb3DQEBDQUAMEY...
          -----END CERTIFICATE-----
      </pre>
    </td>
  </tr>

</table>

### <a id='package-config-writer-pr-more-info'></a> More information

See [Gitops vs RegistryOps](gitops-vs-regops.hbs.md) for more information about the operation of this template
and of the [package-config-writer-template (experimental)](#package-config-writer-template-experimental).

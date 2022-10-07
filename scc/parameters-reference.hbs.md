# Parameters reference

The supply chains and templates provided by the Out of the Box packages contain
a series of parameters that customize their behavior. Here you'll find a list
of all the parameters (`workload.spec.params`) that can be configured in
Workload objects to affect their behavior, broken down by the resource in the
supply chain where they're utilized.


> **Note:** this page documents the parameters according to the most complete
> supply chain (`ootb-supply-chain-testing-scanning`) as the other supply
> chains are subsets of this.


```
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


For details about the supply chains themselves, see their corresponding
documentation:

- [Out of the Box Supply Chain Basic](scc/ootb-supply-chain-basic.hbs.md)
- [Out of the Box Supply Chain Testing](scc/ootb-supply-chain-testing.hbs.md)
- [Out of the Box Supply Chain Testing Scanning](scc/ootb-supply-chain-testing-scanning.hbs.md)


## source provider

The `source-provider` resource in the supply chain is responsible for creating
objects that will fetch either source code or pre-compiled java applications
depending how the Workload is configured (see [Building from
Source](scc/building-from-source.hbs.md)).


### GitRepository

Used when fetching source code from git repositories, it makes available to
further resources in the supply chain the contents of the git repository as a
tarball available inside the cluster.

Parameters:

<table>
  <tr>
    <th>parameter name</th>
    <th>meaning</th>
    <th>example</th>
  </tr>

  <tr>
    <td><code>gitImplementation<code></td>
    <td>
      Underlying library that should be used for fetching the source code.
      Either <code>libggit2</code> (required for Azure DevOps) or
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
      Name of the secret in the same namespace as the `Workload` to use for
      providing credentials for fetching source code from the git repository.
      See ([Git authentication](scc/git-auth)) for details.
    </td>
    <td>
      <pre>
      - name: gitops_ssh_secret
        value: git-credentials
      </pre>
    </td>
  </tr>
</table>

> **Note:** it's typically not necessary to change the default git
> implementation, but some providers (Azure DevOps, for instance) require the
> use of `libgit2` due to the server-side implementation providing support
> solely for [git's v2 protocol](https://git-scm.com/docs/protocol-v2). See
> [git implementation](https://fluxcd.io/flux/components/source/gitrepositories/#git-implementation)
> for a breakdown of the features supported by each implementation.


See [Create a workload from GitHub
repository](cli-plugins/apps/create-workload.hbs.md#-create-a-workload-from-github-repository)
for an example of how to create a Workload that makes use of a GitHub
repository as the provider of source code, and
[GitRepository](https://fluxcd.io/flux/components/source/gitrepositories/) for
reference documentation on GitRepository objects.


### ImageRepository

Used when fetching source code from container images (see [Create a workload
from local source code](cli-plugins/apps/create-workload.hbs.md#-create-a-workload-from-local-source-code)),
it makes available to further resources in the supply chain the contents of the
container image as a tarball that can be fetched liked any other source
provider (git or maven).

Parameters:

<table>
  <tr>
    <th>parameter name</th>
    <th>meaning</th>
    <th>example</th>
  </tr>

  <tr>
    <td><code>serviceAccount<code></td>
    <td>
      name of the serviceaccount (in the same namespace as the Workload) to use
      for providing the necessary credentials to `ImageRepository` for fetching
      the container images.
    </td>
    <td>
      <pre>
      - name: serviceAccount
        value: default
      </pre>
    </td>
  </tr>

</table>

See [ImageRepository reference
docs](source-controller/reference.hbs.md#imagerepository) for details about the
custom resource and [Create a workload from local source
code](cli-plugins/apps/create-workload.hbs.md#-create-a-workload-from-local-source-code)
for an example of how to make use of it leveraging the Tanzu CLI.


### MavenArtifact

Used when carrying pre-built Java artifacts, it makes the artifact available to
further resources in the supply chain as a tarball which can then be wrapped as
a container image for further deployment.

Differently from `git` and `image`, its configuration is solely driven by
parameters in the Workload.

Parameters:

<table>
  <tr>
    <th>parameter name</th>
    <th>meaning</th>
    <th>example</th>
  </tr>

  <tr>
    <td><code>maven<code></td>
    <td>
      pointers to the maven artifact to fetch and polling interval.
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

See [MavenArtifact reference
docs](source-controller/reference.hbs.md#mavenartifact) for details about the
custom resource, and [Create a Workload from Maven repository
artifact](cli-plugins/apps/create-workload.hbs.md#workload-maven) for an
example of how to make use of it with the `tanzu apps workload` CLI plugin.


## source-tester

The `source-tester` resource (part of `ootb-supply-chain-testing` as well as
`ootb-supply-chain-testing-scanning`) is responsible for instantiating a Tekton
[PipelineRun](https://tekton.dev/docs/pipelines/pipelineruns/) object that
invokes the execution of a Tekton Pipeline (in the same namespace as the
Workload) whenever its inputs (for instance, the source code revision to be
tested) change.

Under the hood, a [Runnable](https://cartographer.sh/docs/v0.4.0/reference/runnable/) 
object is instantiated to ensure that there's always a run for a particular set
of inputs, with parameters being passed from the Workload down to Runnable's
Pipeline selection mechanism (via `testing_pipeline_matching_labels`) and the
execution of the PipelineRuns (via `testing_pipeline_params`).

Parameters:

<table>
  <tr>
    <th>parameter name</th>
    <th>meaning</th>
    <th>example</th>
  </tr>

  <tr>
    <td><code>testing_pipeline_matching_labels<code></td>
    <td>
      set of labels to use when searching for Tekton Pipeline objects in the
      same namespace as the Workload. By default, a Pipeline labelled as
      `apps.tanzu.vmware.com/pipeline: test` will be selected, but with the use
      of this parameter, it's possible to override such behavior.
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
      set of extra parameters (i.e., aside from `source-url` and
      `source-revision`) to pass to the Tekton Pipeline. Note that the Tekton Pipeline
      <b>must</b> declare both the required parameters `source-url` and
      `source-revision` as well the extra ones declared here.
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


See [Out of the Box Supply Chain with
Testing](scc/ootb-supply-chain-testing.hbs.md) for details on how to setup the
Workload namespace for testing with Tekton, and [Out of the Box Supply Chain
with Testing on Jenkins](scc/ootb-supply-chain-testing-with-jenkins.hbs.md) for
an example on how to make use of the parameters to customize this resource to
test using a Jenkins cluster.


## source-scanner

The `source-scanner` resource (included solely in
`ootb-supply-chain-testing-scanning`) takes care of scanning the source code
that's been successfully tested by pointing a
[SourceScan](scst-scan/scan-crs.hbs.md#sourcescan) object at the same source
code as the tests.

Its behavior, both in terms of [CVEs evaluation](scst-scan/policies.hbs.md) as
well as [scanner to use](scst-scan/available-scanners.hbs.md), can be
customized with the parameters.

Parameters:

<table>
  <tr>
    <th>parameter name</th>
    <th>meaning</th>
    <th>example</th>
  </tr>

  <tr>
    <td><code>scanning_source_template<code></td>
    <td>
      Name of the ScanTemplate object in the same namespace as the Workload to
      make use of for running the scans against the source code.
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
      make use of when evaluating the scan results of a source scan.
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
Scanning](scc/ootb-supply-chain-testing-scanning.hbs.md) for details on how to
setup the Workload namespace with the ScanPolicy and ScanTemplate required for
this resource, and [SourceScan reference](scst-scan/scan-crs.hbs.md#sourcescan)
for details about the SourceScan custom resource.

Additionally, check out [Supply Chain Security Tools for Tanzu –
Store](scst-store/overview.hbs.md) for details on how the artifacts found
during scanning are catalogued.


## image-provider

The `image-provider` in the supply chains provides to further resources a
container image carrying the application already built.

Depending on how the Workload is configured, i.e., if using [pre-built
images](scc/pre-built-image.hbs.md) or [building from
source](scc/building-from-source.hbs.md), different semantics apply:

- pre-built: an `ImageRepository` object is created aiming at providing a
  reference to the latest image found matching the name as specified in
  `workload.spec.image`

- building from source: an image builder object is created (either Kpack's
  `Image` or a `Runnable` for creating Tekton TaskRuns for building images from
  Dockerfiles)


### Kpack Image

The Kpack Image object (see [About Tanzu Build
Service](tanzu-build-service/tbs-about.hbs.md)) provides means for building a
container image out of source code (or pre-built Java artifact), making such
container image available to further resources in the supply chain via a
content addressable image reference that's carried all the way to the final
deployment objects unchanged.

Parameters:

<table>
  <tr>
    <th>parameter name</th>
    <th>meaning</th>
    <th>example</th>
  </tr>

  <tr>
    <td><code>serviceAccount<code></td>
    <td>
      name of the serviceaccount (in the same namespace as the Workload) to use
      for providing the necessary credentials to `Image` for pushing the
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
    <td><code>clusterBuilder<code></td>
    <td>
      name of the Kpack cluster builder to make use of in the Kpack Image
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
      definition of a list of service bindings to make use at build time (e.g.,
      useful for providing credentials for fetching dependencies from
      repositories that require credentials).
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
      enable the use of Tilt's live-update functionality.
    </td>
    <td>
      <pre>
      - name: live-update
        value: "true"
      </pre>
    </td>
  </tr>

</table>


See [Tanzu Build Service (TBS) Integration](scc/tbs.hbs.md) for more details on
the integration with Tanzu Build Service.

See [Developer Conventions](developer-conventions/about.hbs.md) and [About
IntelliJ extension](intellij-extension/about.hbs.md) for details on
`live-update`.

See [Builders](https://github.com/pivotal/kpack/blob/main/docs/builders.md) for
details on the use of Kpack builders with `clusterBuilder`.

See [Service
Bindings](https://github.com/pivotal/kpack/blob/main/docs/servicebindings.md)
documentation for details on `buildServiceBindings`.


### Runnable (TaskRuns for Dockerfile-based builds)

In order to perform Dockerfile-based builds, the supply chains (all of them)
instantiate a Runnable object that, in face of changes to its set of inputs
(for instance, a new source code revision), takes care of instantiating Tekton
TaskRun objects to invoke the execution of
[kaniko](https://github.com/GoogleContainerTools/kaniko) builds.

Parameters:

<table>
  <tr>
    <th>parameter name</th>
    <th>meaning</th>
    <th>example</th>
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
      list of flags to pass directly to Kaniko (such as providing arguments,
      and so on to a build)
    </td>
    <td><pre>- --build-arg=FOO=BAR</pre></td>
  </tr>
</table>

See [Dockerfile-based builds](scc/dockerfile-based-builds.hbs.md) for more
information on how to make use of it as well as limitations associated with the
functionality.

### Pre-built image (ImageRepository)

For those applications that already have their container images built outside
the supply chains (i.e., providing an image reference under
`workload.spec.image`), an `ImageRepository` object is created to keep track of
any images pushed under such name, making the content-addressable name (i.e.,
the image name containing the digest) available for further resources in the
supply chain.

Parameters:

<table>
  <tr>
    <th>parameter name</th>
    <th>meaning</th>
    <th>example</th>
  </tr>

  <tr>
    <td><code>serviceAccount<code></td>
    <td>
      name of the serviceaccount (in the same namespace as the Workload) to use
      for providing the necessary credentials to `ImageRepository` for fetching
      the container images.
    </td>
    <td>
      <pre>
      - name: serviceAccount
        value: default
      </pre>
    </td>
  </tr>
</table>


See [ImageRepository reference
docs](source-controller/reference.hbs.md#imagerepository) for details on the
ImageRepository resource and [Using a prebuilt
image](scc/pre-built-image.hbs.md) for information regarding the functionality
as a whole.

## image-scanner

Similarly to `source-scanner`, the `image-scanner` resource (part of only
`ootb-supply-chain-testing-scanning`) is responsible for scanning a container
image (either build via the supply chain or outside - prebuilt) and not only
persisting the results in the store, but also gating the image from moving
forward in case the CVEs found are not compliant with the ScanPolicy referenced
by the ImageScan object create for doing so.

Parameters:

<table>
  <tr>
    <th>parameter name</th>
    <th>meaning</th>
    <th>example</th>
  </tr>

  <tr>
    <td><code>scanning_image_template<code></td>
    <td>
      Name of the ScanTemplate object in the same namespace as the Workload to
      make use of for running the scans against a container image.
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
      Name of the ScanPolicy object in the same namespace as the Workload to
      make use of when evaluating the scan results of an image scan.
    </td>
    <td>
      <pre>
      - name: scanning_image_policy
        value: allowlist-policy
      </pre>
    </td>
  </tr>
</table>

See [ImageScan reference](scst-scan/scan-crs.hbs.md#imagescan) for details
about the ImageScan custom resource.

Additionally, check out [Supply Chain Security Tools for Tanzu –
Store](scst-store/overview.hbs.md) for details on how the artifacts found
during scanning are catalogued.


## config-provider

The `config-provider` resource in the supply chains is responsible for
generating a
[PodTemplateSpec](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-template-v1/#PodTemplateSpec)
to be used further along in app configs (knative serivices / deployments) to
represent the desired shape of the pods that get instantiated to run the
application in containers.

It manages a [PodIntent](cartographer-conventions/reference/pod-intent.hbs.md)
object that represents the intention of having such PodTemplateSpec enhanced
with conventions installed in the cluster whose final representation is then
passed forward to other resources to form the final deployment configuration.

Parameters:

<table>
  <tr>
    <th>parameter name</th>
    <th>meaning</th>
    <th>example</th>
  </tr>

  <tr>
    <td><code>serviceAccount<code></td>
    <td>
      name of the serviceaccount (in the same namespace as the Workload) to use
      for providing the necessary credentials to `PodIntent` for fetching
      the container image to inspect the metadata to pass to convention
      servers as well as the serviceAccountName to be set in the
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
    <td><code>annotations<code></td>
    <td>
     extra set of annotations to pass down to the PodTemplateSpec.
    </td>
    <td>
      <pre>
      - name: annotations
        value:
          name: my-application
          version: 1.2.3
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

See [Cartographer Conventions](cartographer-conventions/about.hbs.md) to know
more about the controller behind `PodIntent`.

Additionally, check out [Developer
Conventions](developer-conventions/about.hbs.md) as well as [Spring Boot
Conventions](spring-boot-conventions/about.hbs.md) for more details on the two
convention servers enabled by default in TAP installations.


## app-config

The `app-config` resource is responsible for preparing a ConfigMap with the
Kubernetes configuration that will be used for instantiating an application in
the form of a particular workload type in a cluster.

The resource is configured in the supply chain in such a way to allow, by
default, three types of workloads with the selection of which workload type to
apply based on the labels set in the Workload object created by the developer:

- `apps.tanzu.vmware.com/workload-type: web`
- `apps.tanzu.vmware.com/workload-type: worker`
- `apps.tanzu.vmware.com/workload-type: server`

Currently, only the `server` workload type has configurable parameters as shown
below:

<table>
  <tr>
    <th>parameter name</th>
    <th>meaning</th>
    <th>example</th>
  </tr>

  <tr>
    <td><code>ports<code></td>
    <td>
      set of network ports to expose from the application to the kubernetes
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


See [workload types](workloads/workload-types.hbs.md) for more details on the
three different types of workloads, and [`server`-specific Workload
paramters](workloads/server.hbs.md#-server-specific-workload-parameters) for a
more detailed overview of the ports parameter.

## service-bindings

The `service-bindings` resource adds
[ServiceBindings](service-bindings/about.hbs.md) to the set of Kubernetes
configuration files to promote for deployment.

Parameters:

<table>
  <tr>
    <th>parameter name</th>
    <th>meaning</th>
    <th>example</th>
  </tr>

  <tr>
    <td><code>annotations<code></td>
    <td>
     extra set of annotations to pass down to the ServiceBinding and
     ResourceClaim objects.
    </td>
    <td>
      <pre>
      - name: annotations
        value:
          name: my-application
          version: 1.2.3
          team: store
      </pre>
    </td>
  </tr>
</table>


See [use of `--service-ref` in Tanzu
CLI](cli-plugins/apps/command-reference/commands-details/workload_create_update_apply.hbs.md#apply-service-ref)
for an example and [Consume services on
TAP](getting-started/consume-services.hbs.md) for an overview of the
functionality.

## api-descriptors

The `api-descriptor` resource takes care of adding an
[APIDescriptor](api-auto-registration/key-concepts.hbs.md) to the set of
Kubernetes objects to deploy such that API auto registration takes place.

Parameters:

<table>
  <tr>
    <th>parameter name</th>
    <th>meaning</th>
    <th>example</th>
  </tr>

  <tr>
    <td><code>annotations<code></td>
    <td>
     extra set of annotations to pass down to the APIDescriptor object.
    </td>
    <td>
      <pre>
      - name: annotations
        value:
          name: my-application
          version: 1.2.3
          team: store
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>api_descriptor<code></td>
    <td>
     information used to fill the desired state of the APIDescriptor object
    (its spec).
    </td>
    <td>
      <pre>
      - name: api_descriptor
        value:
          type: openapi
          location:
            baseURL: http://petclinic-hard-coded.my-apps.tapdemo.vmware.com/
            path: "/v3/api-docs"
          owner: team-petclinic
          system: pet-clinics
          description: "example"
      </pre>
    </td>
  </tr>
</table>


> **Note:** it's required that the Workload include the
> `apis.apps.tanzu.vmware.com/register-api: "true"` label in order to activate
> this functionality.

See [Use API Auto Registration](api-auto-registration/usage.hbs.md) for more
details about API auto registration.


## config-writer (git or registry)

The `config-writer` resource is responsible for performing the last mile of the
supply chain: persisting in an external system (registry or git repository) the
Kubernetes configuration generated throughout the supply chain.

It can do so in three distinct manners:

- publishing the configuration to a container image registry
- publishing the configuration to a git repository
  - solely via the push of a commit, or
  - pushing a commit _and_ opening a pull request.

Details about the different modes of operation can be found in [Gitops vs
RegistryOps](scc/gitops-vs-regops.hbs.md) with the parameters documented in
place.

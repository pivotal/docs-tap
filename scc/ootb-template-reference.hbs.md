# Template Reference

The OOTB Template package includes:
- [Cartographer Templates](https://cartographer.sh/docs/v0.6.0/architecture/#templates)
- [Cartographer ClusterRunTemplates](https://cartographer.sh/docs/v0.6.0/runnable/architecture/#clusterruntemplate)
- [ClusterRoles](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-and-clusterrole)
- [openshift SecurityContextConstraints](https://docs.openshift.com/container-platform/3.11/admin_guide/manage_scc.html)
- [Tekton ClusterTasks](https://tekton.dev/docs/pipelines/tasks/#overview)

## source-template

### Purpose
Creates an object to fetch source code and make that code available
to other objects in the supply chain. More details can be read in [Building from
Source](building-from-source.hbs.md).

### Kind
ClusterSourceTemplate.carto.run

### Used By

- [Source-to-URL](ootb-supply-chain-reference.hbs.md#source-to-url)
- [Source-Test-to-URL](ootb-supply-chain-reference.hbs.md#source-test-to-url)
- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan-to-url)

### Creates

The source-template creates one of three objects, either:
- GitRepository. Created if the workload has `.spec.source.git` defined.
- MavenArtifact. Created if the template is provided a value for the param `maven`
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

##### More Information

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
> (The similarly named `--service-account` flag sets a different value:
> the `spec.serviceAccountName` key in the Workload object.)

##### More Information

For information about the ImageRepository resource, see [ImageRepository reference
docs](../source-controller/reference.hbs.md#imagerepository).

For information about how to use the Tanzu CLI to create a workload leveraging ImageRepository refer to
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
      Specifies the maven repository from which to fetch
    </td>
    <td>
      <pre>
      - name: maven_repository_url
        value: https://repo1.maven.org/maven2/
      </pre>
    </td>
    <td><code>maven_repository_secret_name<code></td>
    <td>
      Specifies the secret containing credentials necessary to fetch from the maven repository.
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

##### More Information

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

### Kind
ClusterSourceTemplate.carto.run

### Used by

- [Source-Test-to-URL](ootb-supply-chain-reference.hbs.md#source-test-to-url)
- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan-to-url)

### Creates

`testing-pipeline`creates a [Runnable](https://cartographer.sh/docs/v0.4.0/reference/runnable/)
object. This Runnable provides inputs to the
[ClusterRunTemplate](https://cartographer.sh/docs/v0.4.0/reference/runnable/#clusterruntemplate)
named [tekton-source-pipelinerun](#tekton-source-pipelinerun).

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
      To this set of parameters, the template always adds the source url
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

### More Information

For more information on the ClusterRunTemplate that pairs with the Runnable, read
[tekton-source-pipelinerun](#tekton-source-pipelinerun)

For information about the Tekton Pipeline that must be created by the user, read the [OOTB Supply Chain
Testing documentation of the Pipeline](ootb-supply-chain-testing.hbs.md#a-idtekton-pipelinea-tektonpipeline)

## tekton-source-pipelinerun

### Purpose
Tests source code.

### Kind
ClusterRunTemplate.carto.run

### Used By
- [testing-pipeline](#testing-pipeline)

### Creates
This ClusterRunTemplate creates a [Tekton
PipelineRun](https://tekton.dev/docs/pipelines/pipelineruns/).
Pipeline runs are immutable, so when the inputs from the Runnable change, a new pipelineRun is created.

### Inputs
<table>
  <tr>
    <th>Input name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>tekton-params<code></td>
    <td>
      Set of parameters to pass to the Tekton Pipeline.
    </td>
    <td>
      <pre>
      - name: source-url
        value: https://github.com/vmware-tanzu/cartographer.git
      - name: source-revision
        value: e4a53f49a92fc913d26f8cc23d59102a51a5e635
      - name: verbose
        value: true
      - name: foo
        value: bar
      </pre>
    </td>
  </tr>

</table>

### More Information

For more information about the runnable created in the OOTB Testing and OOTB Testing and Scanning,
read [testing-pipeline](#testing-pipeline).

For information about the Tekton Pipeline that must be created by the user, read the [OOTB Supply Chain
Testing documentation of the Pipeline](ootb-supply-chain-testing.hbs.md#a-idtekton-pipelinea-tektonpipeline).

## source-scanner-template

### Purpose
Scans the source code for vulnerabilities.

### Kind
ClusterSourceTemplate.carto.run

### Used by

- [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan-to-url)

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

### More Information

See [Out of the Box Supply Chain with Testing and
Scanning](ootb-supply-chain-testing-scanning.hbs.md#a-iddeveloper-namespacea-developer-namespace)
for details about how to set up the Workload namespace with the ScanPolicy and
ScanTemplate required for this resource.

Read [SourceScan reference](../scst-scan/scan-crs.hbs.md#sourcescan)
for details about the SourceScan custom resource.

For information about how the artifacts found
during scanning are catalogued, see [Supply Chain Security Tools for Tanzu –
Store](../scst-store/overview.hbs.md).

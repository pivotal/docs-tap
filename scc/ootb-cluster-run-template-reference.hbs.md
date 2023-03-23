# ClusterRunTemplate reference

All the objects referenced in this topic are [Cartographer
ClusterRunTemplates](https://cartographer.sh/docs/v0.6.0/reference/runnable/#clusterruntemplate)
packaged in [Out of the Box Templates](ootb-templates.hbs.md). Their purpose,
the one or more objects they create, the supply chains that include them and the
parameters they use are detailed in this topic.

## <a id='tekton-source'></a> tekton-source-pipelinerun

### <a id='source-pipelinerun-purpose'></a> Purpose

Tests source code.

### <a id='pipelinerun-used'></a> Used by

- [testing-pipeline](ootb-template-reference.hbs.md#testing-pipeline)

### <a id='pipelinerun-creates'></a> Creates

This ClusterRunTemplate creates a [Tekton PipelineRun](https://tekton.dev/docs/pipelines/pipelineruns/) referring to
the user's specified Tekton Pipeline.

### <a id='pipelinerun-creates'></a> Inputs

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
      `
      - name: source-url
        value: https://github.com/vmware-tanzu/cartographer.git
      - name: source-revision
        value: e4a53f49a92fc913d26f8cc23d59102a51a5e635
      - name: verbose
        value: true
      - name: foo
        value: bar
      `
    </td>
  </tr>

</table>

### <a id='pipelinerun-more-info'></a> More information

For information about the runnable created in the OOTB Testing and OOTB Testing and Scanning,
see [testing-pipeline](#testing-pipeline).

For information about the Tekton Pipeline that the user must create, see [Tekton/Pipeline](ootb-supply-chain-testing.hbs.md#tekton-pipeline).

## <a id='taskrun'></a> tekton-taskrun

### <a id='taskrun-purpose'></a> Purpose

Generic template for creating a Tekton TaskRun

### <a id='taskrun-used'></a> Used by

- [config-writer-template](ootb-template-reference.hbs.md#config-writer)

### <a id='taskrun-creates'></a>Creates

A Tekton TaskRun.

### <a id='taskrun-inputs'></a> Inputs

<table>
  <tr>
    <th>Input name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>serviceAccount<code></td>
    <td>
      Service Account with permissions necessary for the Tekton Task
    </td>
    <td>
        `default`
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>taskRef<code></td>
    <td>
      Reference to the Tekton Task to which the TaskRun provides parameters
    </td>
    <td>
        `kind: ClusterTask
        name: git-writer`
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>params<code></td>
    <td>
      Parameters which are provided to the Tekton Task
    </td>
    <td>
        `- name: git_branch
          value: main
        - name: git_user_name
          value: "Some Name" `
    </td>
  </tr>

</table>

## <a id='commit-pr'></a> commit-and-pr-pipelinerun

### <a id='commit-pr-purpose'></a> Purpose

Commit configuration to a Git repository and open a pull request for review.

### <a id='commit-pr-used'></a> Used by

- [config-writer-and-pull-requester-template](ootb-template-reference.hbs.md#config-writer-pr)

### <a id='commit-pr-creates'></a> Creates

Creates a Tekton TaskRun referring to the `commit-and-pr` Tekton Task.

### <a id='commit-pr-inputs'></a> Inputs

<table>
  <tr>
    <th>Input name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>serviceAccount<code></td>
    <td>
      Service Account with credentials for the Git repository.
    </td>
    <td>
        `default`
    </td>
  </tr>

  <tr>
    <td><code>git_server_kind<code></td>
    <td>
      Type of Git provider
    </td>
    <td>
        `github`
    </td>
  </tr>

  <tr>
    <td><code>git_server_address<code></td>
    <td>
      Server URL
    </td>
    <td>
        `https://github.com`
    </td>
  </tr>

  <tr>
    <td><code>repository_owner<code></td>
    <td>
      Owner/Organization in which the repository resides
    </td>
    <td>
        `vmware-tanzu`
    </td>
  </tr>

  <tr>
    <td><code>repository_name<code></td>
    <td>
      Name of the repository
    </td>
    <td>
        `cartographer`
    </td>
  </tr>

  <tr>
    <td><code>commit_branch<code></td>
    <td>
      Name of the commit branch. Recommended value is an empty string.
    </td>
    <td>
       ` "" `
    </td>
  </tr>

  <tr>
    <td><code>pull_request_title<code></td>
    <td>
      Title of the PR to be opened
    </td>
    <td>
        ` "Update" `
    </td>
  </tr>

  <tr>
    <td><code>pull_request_body<code></td>
    <td>
      Body of the PR to be opened
    </td>
    <td>
        ` "Ready for review" `
    </td>
  </tr>

  <tr>
    <td><code>base_branch<code></td>
    <td>
      Branch into which the PR is merged
    </td>
    <td>
        `main`
    </td>
  </tr>

  <tr>
    <td><code>git_user_name<code></td>
    <td>
      User name associated with the commit
    </td>
    <td>
        `Waciuma Rasheed`
    </td>
  </tr>

  <tr>
    <td><code>git_user_email<code></td>
    <td>
      User email associated with the commit
    </td>
    <td>
        `Sam@todd.com`
    </td>
  </tr>

  <tr>
    <td><code>git_commit_message<code></td>
    <td>
      Message on commit
    </td>
    <td>
        ` "App update" `
    </td>
  </tr>

  <tr>
    <td><code>git_files<code></td>
    <td>
      Base64 encoded JSON file with where keys equal the filename and the value is the file contents.
    </td>
    <td>
        ` "eyJkZWxpdmVyeS55bWwiOiJhcGlWZXJzaW9uOiBzZXJ2aW5nLmtuYXRpdmUuZGV2L3YxXG5raW5kOiBTZXJ2aWNlXG4ifQ==" `
    </td>
  </tr>

  <tr>
    <td><code>sub_path<code></td>
    <td>repository in which to write the files
    </td>
    <td>
        ` "." `
    </td>
  </tr>

</table>

### <a id='commit-pr-more-info'></a> More information

For information about the template creating the related runnable,
see [config-writer-and-pull-requester-template](ootb-template-reference.hbs.md#config-writer-pr).

For information about using gitops, see [GitOps versus RegistryOps](gitops-vs-regops.hbs.md).

## kaniko-runtemplate

### Purpose

Build images from source code which has a dockerfile.

### Used By

- [kaniko-template](ootb-template-reference.hbs.md#kaniko-template)

### Creates

Creates a TaskRun referring to the kaniko-build Tekton ClusterTask.

### Inputs

<table>
  <tr>
    <th>Input name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>serviceAccount<code></td>
    <td>
      Service Account with credentials for the container image registry in which the built image is placed.
    </td>
    <td>
      <pre>
        default
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>params<code></td>
    <td>
      Set of parameters to pass to the Tekton Task.
    </td>
    <td>
      <pre>
        - name: foo
          value: bar
      </pre>
    </td>
  </tr>

</table>

### More Information

For information about the template creating the associated Runnable,
see [kaniko-template](ootb-template-reference.hbs.md#kaniko-template).

For information about how to use Dockerfile-based builds and limits associated with the function, see
[Dockerfile-based builds](dockerfile-based-builds.hbs.md).

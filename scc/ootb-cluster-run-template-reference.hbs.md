# ClusterRunTemplate Reference

All the objects referenced here are [Cartographer ClusterRunTemplates](https://cartographer.sh/docs/v0.6.0/reference/runnable/#clusterruntemplate)
packaged in [Out of the Box Templates](ootb-templates.hbs.md).
Their purpose, the object(s) they create, the supply chains that include them and
the parameters they leverage are detailed below.

## tekton-source-pipelinerun

### Purpose
Tests source code.

### Used By
- [testing-pipeline](ootb-template-reference.hbs.md#testing-pipeline)

### Creates
This ClusterRunTemplate creates a [Tekton PipelineRun](https://tekton.dev/docs/pipelines/pipelineruns/) referring to
the user's specified Tekton Pipeline.

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

## tekton-taskrun

### Purpose
Generic template for creating a Tekton Taskrun

### Used By
- [config-writer-template](ootb-template-reference.hbs.md#config-writer-template)

### Creates
A Tekton TaskRun.

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
      Service Account with permissions necessary for the Tekton Task
    </td>
    <td>
      <pre>
        default
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>taskRef<code></td>
    <td>
      Reference to the Tekton Task to which the TaskRun will provide parameters
    </td>
    <td>
      <pre>
        kind: ClusterTask
        name: git-writer
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>params<code></td>
    <td>
      Params which will be provided to the Tekton Task
    </td>
    <td>
      <pre>
        - name: git_branch
          value: main
        - name: git_user_name
          value: "Some Name"
      </pre>
    </td>
  </tr>

</table>

## commit-and-pr-pipelinerun

### Purpose
Commit configuration to a git repository and open a pull request for review.

### Used By
- [config-writer-and-pull-requester-template](ootb-template-reference.hbs.md#config-writer-and-pull-requester-template)

### Creates
Creates a Tekton TaskRun referring to the `commit-and-pr` Tekton Task.

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
      Service Account with credentials for the git repository.
    </td>
    <td>
      <pre>
        default
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>git_server_kind<code></td>
    <td>
      Type of git provider
    </td>
    <td>
      <pre>
        github
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>git_server_address<code></td>
    <td>
      Server URL
    </td>
    <td>
      <pre>
        https://github.com
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>repository_owner<code></td>
    <td>
      Owner/Organization in which the repository resides
    </td>
    <td>
      <pre>
        vmware-tanzu
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>repository_name<code></td>
    <td>
      Name of the repository
    </td>
    <td>
      <pre>
        cartographer
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>commit_branch<code></td>
    <td>
      Name of the commit branch. Recommended value is an empty string.
    </td>
    <td>
      <pre>
        ""
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>pull_request_title<code></td>
    <td>
      Title of the PR to be opened
    </td>
    <td>
      <pre>
        "Update"
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>pull_request_body<code></td>
    <td>
      Body of the PR to be opened
    </td>
    <td>
      <pre>
        "Ready for review"
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>base_branch<code></td>
    <td>
      Branch into which the PR will be merged
    </td>
    <td>
      <pre>
        main
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>git_user_name<code></td>
    <td>
      Username associated with the commit
    </td>
    <td>
      <pre>
        Waciuma Rasheed
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>git_user_email<code></td>
    <td>
      User email associated with the commit
    </td>
    <td>
      <pre>
        Sam@todd.com
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>git_commit_message<code></td>
    <td>
      Message on commit
    </td>
    <td>
      <pre>
        "App update"
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>git_files<code></td>
    <td>
      Base64 encoded json file with where keys equal the file name and the value is the file contents.
    </td>
    <td>
      <pre>
        "eyJkZWxpdmVyeS55bWwiOiJhcGlWZXJzaW9uOiBzZXJ2aW5nLmtuYXRpdmUuZGV2L3YxXG5raW5kOiBTZXJ2aWNlXG4ifQ=="
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>sub_path<code></td>
    <td>
      The directory location in the repo in which to write the files
    </td>
    <td>
      <pre>
        "."
      </pre>
    </td>
  </tr>

</table>

### More Information

For more information about the template creating the related Runnable,
see [config-writer-and-pull-requester-template](ootb-template-reference.hbs.md#config-writer-and-pull-requester-template)

For more information about the gitops flow, see [GitOps versus RegistryOps](gitops-vs-regops.hbs.md).

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
      Service Account with credentials for the image registry in which the built image will be placed.
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

For more information about the template creating the associated Runnable,
see [kaniko-template](ootb-template-reference.hbs.md#kaniko-template)

For information about how to use Dockerfile-based builds and limits associated with the function, see
[Dockerfile-based builds](dockerfile-based-builds.hbs.md).

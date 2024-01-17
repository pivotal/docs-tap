# ClusterRunTemplate reference for Supply Chain Choreographer

This topic lists the objects you can use with Supply Chain Choreographer.
All the objects referenced in this topic are [Cartographer
ClusterRunTemplates](https://cartographer.sh/docs/v0.6.0/reference/runnable/#clusterruntemplate)
packaged in [Out of the Box Templates](ootb-templates.hbs.md). This topic
describes the one or more objects they create, the supply chains that include
them, and the parameters they use.

## <a id='tekton-source'></a> tekton-source-pipelinerun

### <a id='source-pipelinerun-purpose'></a> Purpose

Tests source code.

### <a id='pipelinerun-used'></a> Used by

- [testing-pipeline](ootb-template-reference.hbs.md#testing-pipeline)

### <a id='pipelinerun-creates'></a> Creates

This ClusterRunTemplate creates a [Tekton
PipelineRun](https://tekton.dev/docs/pipelines/pipelineruns/) referring to the
user's Tekton Pipeline.

### <a id='pipelinerun-creates'></a> Inputs

<table>
<thead>
  <tr>
    <th>Input name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr></thead>
<body>
  <tr>
    <td><code>tekton-params<code></td>
    <td>
      Set of parameters to pass to the Tekton Pipeline
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
</body>
</table>

### <a id='pipelinerun-more-info'></a> More information

For information about the runnable created in the OOTB Testing and OOTB Testing
and Scanning, see [testing-pipeline](#testing-pipeline).

For information about the Tekton Pipeline that the user must create, see [Tekton/Pipeline](ootb-supply-chain-testing.hbs.md#tekton-pipeline).

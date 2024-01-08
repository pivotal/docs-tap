# Component API

Components:

1. Specify the work to do for the stage
    * as a Tekton PipelineRun (*line 44*)
2. Specify the configuration in a workload that is required for the component to operate
    * as partial Schema (*line 53*)
3. Optionally specify small tasks used to check for depedency changes, such as new source, base images
    * as Tekton TaskRuns (*line 29*)
4. Are used to specify the work to be done in a [**SupplyChain**](./supplychain.hbs.md) stage

```yaml=
apiVersion: supply-chain.tanzu.vmware.com/v1alpha1
kind: Component
metadata:
  name: source-1.0.0
spec:
  description: Monitors a git repository
  config:
    - path: spec.source.git
      schema:
        type: object
        description: |
          Fill this object in if you want your source to come from git.
          The tag, commit and branch fields are mutually exclusive, 
          use only one.
        properties:
          tag:
            description: A git tag ref to watch for new source
            type: string
          commit:
            description: A git commit sha to use
            type: string
          branch:
            description: A git branch ref to watch for new source
            type: string
          url:
            description: The url to the git source repository
            type: string
        required:
          - url
  resumptions:
    - name: check-source
      trigger:
        runAfter: 60s
      taskRef:
        name: check-source
      params:
        - name: git-branch
          value: $(workload.spec.source.git.branch)
        - name: git-url
          value: $(workload.spec.source.git.url)
        - name: git-commit
          value: $(workload.spec.source.git.commit)
        - name: git-tag
          value: $(workload.spec.source.git.tag)
  pipelineRun:
    pipelineRef:
      name: source
    params:
      - name: git-url
        value: $(workload.spec.source.git.url)
      - name: sha
        value: $(resumptions.check-source.results.sha)
    workspaces:
      - name: shared-data
        volumeClaimTemplate:
          spec:
            accessModes:
              - ReadWriteOnce
            resources:
              requests:
                storage: 1Gi
  outputs:
    - name: source
      type: source
```

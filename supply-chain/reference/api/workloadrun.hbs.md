# WorkloadRun API
{{> 'partials/supply-chain/beta-banner' }}

```yaml
apiVersion: <defined in supply chain>/v1alpha1
kind: <defined in supply chain>
metadata:
  generateName: <workload-name>-run-
  labels:
    supply-chain.apps.tanzu.vmware.com/workload-generation: "1"
    supply-chain.apps.tanzu.vmware.com/workload-group: <workload-group>
    supply-chain.apps.tanzu.vmware.com/workload-name: <workload-name>
  ownerReferences:
    - apiVersion: <workload-apiversion>
      controller: true
      kind: <workload-kind>
      name: <workload-name>
spec:
  stages: [ ]
  workload: { <workload-resource> }
status:
  conditions:
    - type: StagesSucceeded
      reason: Succeeded
      status: "True"
      message: Run was successful
    - type: Succeeded
      reason: Succeeded
      status: "True"
      message: ""
  observedGeneration: 1
  workloadRun:
    apiVersion: <defined in supply chain>/v1alpha1
    kind: <defined in supply chain>
    metadata:
      generateName: <workload-name>-run-
      labels:
        supply-chain.apps.tanzu.vmware.com/workload-generation: "1"
        supply-chain.apps.tanzu.vmware.com/workload-group: <workload-group>
        supply-chain.apps.tanzu.vmware.com/workload-name: <workload-name>
      ownerReferences:
        - apiVersion: <workload-apiversion>
          controller: true
          kind: <workload-kind>
          name: <workload-name>
    spec:
      stages:
        - componentRef:
            name: source-1.0.0
          name: source
          resumptions:
            - name: control
              key: gjmjkasdhh42shkx2jqtiunhjrudv1irvbvvaldauem6uugs
              resultDigest: suy5avkukenkk64cktlwtstousgjn4k5rigavcu3dwjma3mm
              started: "2024-02-02T00:30:31Z"
              completed: "2024-02-02T00:30:34Z"
              passed: true
              message: |
                complete
              results:
                - name: message
                  value: |
                    complete
                - name: value
                  value: |
                    r0-value-second-time-around
          pipeline:
            started: "2024-02-02T00:30:35Z"
            completed: "2024-02-02T00:30:38Z"
            passed: true
            message: 'Tasks Completed: 1 (Failed: 0, Cancelled 0), Skipped: 0'
      workload: { <workload-resource> }
```

[//]: # (TODO: details about sections of the record.)

## Conditions

There are three conditions in a WorkloadRun:

1. PipelinesSucceeded
2. ResumptionsSucceeded
3. Succeeded (Top Level)

### PipelinesSucceeded

| Status  | Reason         | Message                                 |                                                                                                                                               |
|---------|----------------|-----------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------|
| Unknown | Running        | \<processing details>                   | The pipeline is still running.                                                                                                                |
| True    | Succeeded      | \<processing details>                   | The pipeline completed successfully.                                                                                                          |
| False   | Failed         | \<processing details and error message> | The pipeline failed, and it's likely that the developer can remedy any issues by following the guidance in the message.                       | 
| False   | PlatformFailed | \<processing details and error message> | The pipeline failed, and it's unlikely the problem can be remedied with changes to the workload or developer provided input (such as source). |

`Message` contains processing information and error messages produced in the pipeline. This information must be
specifically appended to the Tekton result named `message`

### ResumptionsSucceeded

| Status  | Reason         | Message                                 |                                                                                                                                           |
|---------|----------------|-----------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------|
| Unknown | Running        | \<processing details>                   | The task is still running.                                                                                                                |
| True    | Succeeded      | \<processing details>                   | The task completed successfully.                                                                                                          |
| False   | Failed         | \<processing details and error message> | The task failed, and it's likely that the developer can remedy any issues by following the guidance in the message.                       | 
| False   | PlatformFailed | \<processing details and error message> | The task failed, and it's unlikely the problem can be remedied with changes to the workload or developer provided input (such as source). |

`Message` contains processing information and error messages produced in the taskRun. This information must be
specifically appended to the Tekton result named `message`

### Type: Succeeded

| Status  | Reason         | Message                                 |                                                                                                                                                                                          |
|---------|----------------|-----------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Unknown | Running        | \<processing details>                   | The component is still running.                                                                                                                                                          |
| True    | Succeeded      | \<processing details>                   | The component completed successfully.                                                                                                                                                    |
| False   | Failed         | \<processing details and error message> | The component failed in either the Resumptions or the Pipeline, and it's likely that the developer can remedy any issues by following the guidance in the message.                       | 
| False   | PlatformFailed | \<processing details and error message> | The component failed in either the Resumptions or the Pipeline, and it's unlikely the problem can be remedied with changes to the workload or developer provided input (such as source). |

`Message` contains processing information and error messages produced in the resumptions and pipeline. This information
must be
specifically appended to the Tekton result named `message`

The Succeeded condition reflects whichever is the least-desirable condition
from [PipelinesSucceeded](#pipelinessucceeded) or
[ResumptionsSuceeded](#resumptionssucceeded).

Least desirable to most desirable state is `False` &#2192; `Unknown` &#2192; `True`

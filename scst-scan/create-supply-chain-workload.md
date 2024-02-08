# Create Workload from SupplyChain

This topic covers how to create and apply a workload from a Tanzu Supply Chain, how to observe a workload, and how to verify the scanning performed in a workload.

## <a id="overview"></a> Overview

* [Create and apply workload](./create-supply-chain-workload.md#create-and-apply-workload)
* [Observe workload](./create-supply-chain-workload.md#observe-workload)
* [Verify workload performed scanning by checking scan results](./create-supply-chain-workload.md#verify-workload-performed-scanning-by-checking-scan-results)

### <a id="create-apply-workload-from-supply-chain"></a> Create and apply workload

This sections covers how to create a workload from an existing [supply chain](./create-supply-chain-with-app-scanning.md).

* Use tanzu cartographer plugin to create workload from supply chain:
```
$ tanzu cartographer workload generate
? Select the supply chain:   [Use arrows to move, type to filter]
> SCANNER-supply-chain-1.0.0 (11h)
  trivy-supply-chain-1.0.0 (3d)
kind: Sample
apiVersion: sample.com/v1alpha1
metadata:
  name: example-sample
spec:
  registry:
    ...
  scanning:
    ...
```
Here the user can create a supply chain workload from the:
* [Trivy Supply Chain](./create-supply-chain-with-app-scanning.md#create-supply-chain-with-scst---scan-20-and-trivy-supply-chain-component)
* [Supply Chain with Custom Scanner Component](./create-supply-chain-with-app-scanning.md#create-supply-chain-with-scst---scan-20-and-the-custom-scanning-component)

This will render a sample workload yaml that the user can configure and put in a `workload.yaml`.

* Apply workload:
```
kubectl apply -f workload.yaml -n DEV-NAMESPACE
```


### <a id="observe-workload"></a> Observe workload

* Tanzu cartographer to see workload is running:
```
$ tanzu cartographer workload list
NAME                           NAMESPACE                   SUPPLY CHAIN                LATEST RUN                                  READY        AGE   MESSAGE                                     PROGRESS
Sample/golang-app-robin-test   grype-app-scanning-catalog  sample-supply-chain-1.0.0   SampleRun/golang-app-robin-test-run-ccmrq   Running      2m4s  waiting for stage buildpack-build & 1 more  ##-
```

* Trace workload progress:

Install kubectl tree [plugin](https://github.com/ahmetb/kubectl-tree)
```
$ kubectl tree Sample golang-app-robin-test -n grype-app-scanning-catalog
NAMESPACE                   NAME                                                                              READY  REASON              AGE
grype-app-scanning-catalog  Sample/golang-app-robin-test                                                      -                          3m54s
grype-app-scanning-catalog  └─SampleRun/golang-app-robin-test-run-ccmrq                                       -                          3m54s
grype-app-scanning-catalog    ├─Stage/stage-0-source-git-provider-8q9p7                                       -                          3m54s
grype-app-scanning-catalog    │ ├─PipelineRun/stage-0-source-git-provider-hf4vg                               -                          3m48s
grype-app-scanning-catalog    │ │ ├─PersistentVolumeClaim/pvc-90b3db07c1                                      -                          3m48s
grype-app-scanning-catalog    │ │ ├─ResolutionRequest/cluster-c81c49ea72e49e86fec8e327d42443d0                -                          3m48s
grype-app-scanning-catalog    │ │ ├─TaskRun/stage-0-source-git-provider-hf4vg-fetch                           -                          3m48s
grype-app-scanning-catalog    │ │ │ └─Pod/stage-0-source-git-provider-hf4vg-fetch-pod                         False  PodCompleted        3m48s
grype-app-scanning-catalog    │ │ ├─TaskRun/stage-0-source-git-provider-hf4vg-store                           -                          2m53s
grype-app-scanning-catalog    │ │ │ └─Pod/stage-0-source-git-provider-hf4vg-store-pod                         False  PodCompleted        2m53s
grype-app-scanning-catalog    │ │ └─TaskRun/stage-0-source-git-provider-hf4vg-strip-git                       -                          3m26s
grype-app-scanning-catalog    │ │   └─Pod/stage-0-source-git-provider-hf4vg-strip-git-pod                     False  PodCompleted        3m26s
grype-app-scanning-catalog    │ ├─Resumption/resumption-vug542hf4ei2tjdp1jy6i3mk4hvcfvh23nwrgnjdbkx31krn      True   Ready               3m54s
grype-app-scanning-catalog    │ │ └─TaskRun/resumption-task-rvfgd                                             -                          3m54s
grype-app-scanning-catalog    │ │   ├─Pod/resumption-task-rvfgd-pod                                           False  PodCompleted        3m54s
grype-app-scanning-catalog    │ │   └─ResolutionRequest/cluster-8cafe4c5abee46a1c9963153b6aeebf0              -                          3m54s
grype-app-scanning-catalog    │ └─TaskRun/resumption-task-rvfgd                                               -                          3m54s
grype-app-scanning-catalog    │   ├─Pod/resumption-task-rvfgd-pod                                             False  PodCompleted        3m54s
grype-app-scanning-catalog    │   └─ResolutionRequest/cluster-8cafe4c5abee46a1c9963153b6aeebf0                -                          3m54s
grype-app-scanning-catalog    ├─Stage/stage-1-buildpack-build-8qvkq                                           -                          2m18s
grype-app-scanning-catalog    │ ├─PipelineRun/stage-1-buildpack-build-r7gcd                                   -                          2m12s
grype-app-scanning-catalog    │ │ ├─CustomRun/stage-1-buildpack-build-r7gcd-build                             -                          2m6s
grype-app-scanning-catalog    │ │ │ └─ManagedResource/stage-1-buildpack-build-r7gcd-build-mr-7fstx            -                          2m6s
grype-app-scanning-catalog    │ │ │   └─Build/golang-app-robin-test-jdwj6                                     -                          2m6s
grype-app-scanning-catalog    │ │ │     └─Pod/golang-app-robin-test-jdwj6-build-pod                           False  PodCompleted        2m5s
grype-app-scanning-catalog    │ │ ├─ResolutionRequest/cluster-8e9116d4ec4928a400a3b60e80eb1295                -                          2m12s
grype-app-scanning-catalog    │ │ ├─TaskRun/stage-1-buildpack-build-r7gcd-calculate-digest                    -                          71s
grype-app-scanning-catalog    │ │ │ └─Pod/stage-1-buildpack-build-r7gcd-calculate-digest-pod                  False  PodCompleted        71s
grype-app-scanning-catalog    │ │ └─TaskRun/stage-1-buildpack-build-r7gcd-prepare-build                       -                          2m12s
grype-app-scanning-catalog    │ │   └─Pod/stage-1-buildpack-build-r7gcd-prepare-build-pod                     False  PodCompleted        2m12s
grype-app-scanning-catalog    │ ├─Resumption/resumption-3g5h5qotjkxu2d5c2pmp6mxv4ns5pkls13vwab5wv3fg543h      True   Ready               2m18s
grype-app-scanning-catalog    │ │ └─TaskRun/resumption-task-499fk                                             -                          2m18s
grype-app-scanning-catalog    │ │   ├─Pod/resumption-task-499fk-pod                                           False  PodCompleted        2m18s
grype-app-scanning-catalog    │ │   └─ResolutionRequest/cluster-9f31100f32fba78553ef691245146126              -                          2m18s
grype-app-scanning-catalog    │ └─TaskRun/resumption-task-499fk                                               -                          2m18s
grype-app-scanning-catalog    │   ├─Pod/resumption-task-499fk-pod                                             False  PodCompleted        2m18s
grype-app-scanning-catalog    │   └─ResolutionRequest/cluster-9f31100f32fba78553ef691245146126                -                          2m18s
grype-app-scanning-catalog    └─Stage/stage-2-grype-image-scan-wslkz                                          -                          64s
grype-app-scanning-catalog      └─PipelineRun/stage-2-grype-image-scan-7789q                                  -                          64s
grype-app-scanning-catalog        ├─CustomRun/stage-2-grype-image-scan-7789q-scan                             -                          58s
grype-app-scanning-catalog        │ └─ManagedResource/stage-2-grype-image-scan-7789q-scan-mr-xqc84            -                          58s
grype-app-scanning-catalog        │   └─ImageVulnerabilityScan/golang-app-robin-test-bbrpz                    -                          58s
grype-app-scanning-catalog        │     └─PipelineRun/golang-app-robin-test-bbrpz-sqsrp                       -                          58s
grype-app-scanning-catalog        │       ├─PersistentVolumeClaim/pvc-160c7d4c76                              -                          58s
grype-app-scanning-catalog        │       ├─TaskRun/golang-app-robin-test-bbrpz-sqsrp-scan-task               -                          39s
grype-app-scanning-catalog        │       │ └─Pod/golang-app-robin-test-bbrpz-sqsrp-scan-task-pod             False  ContainersNotReady  39s
grype-app-scanning-catalog        │       └─TaskRun/golang-app-robin-test-bbrpz-sqsrp-workspace-setup-task    -                          58s
grype-app-scanning-catalog        │         └─Pod/golang-app-robin-test-bbrpz-sqsrp-workspace-setup-task-pod  False  PodCompleted        58s
grype-app-scanning-catalog        ├─ResolutionRequest/cluster-ed022311336c4f218d4065723b853bfc                -                          64s
grype-app-scanning-catalog        └─TaskRun/stage-2-grype-image-scan-7789q-prepare                            -                          64s
grype-app-scanning-catalog          └─Pod/stage-2-grype-image-scan-7789q-prepare-pod                          False  PodCompleted        64s
```

### <a id="verify-workload-scanning"></a>Verify workload performed scanning by checking scan results

* Get the ivs name by looking for the IVS in the namespace it was created in:
```
kubectl get ivs -n DEV-NAMESPACE
NAMESPACE                    NAME                          SUCCEEDED   REASON      AGE
DEV-NAMESPACE    golang-app-robin-test-bbrpz   True        Succeeded   4m52s
```

* Follow this [verify app-scanning page](./verify-app-scanning.hbs.md#retrieve-scan-results) to see how to retrieve scan results by using the IVS name found in the previous step.
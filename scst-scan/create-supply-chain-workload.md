# Create Workload from SupplyChain

This topic tells how to create a workload from a Tanzu Supply Chain and apply it.

## Overview

* Create and apply workload
* Apply workload
* Observe workload
* Verify workload performed scanning by checking scan results

### Create workload from Supply Chain

* Use tanzu cartographer plugin to create workload from supply chain:
```
$ tanzu cartographer workload generate
? Select the supply chain:   [Use arrows to move, type to filter]
> sample-supply-chain-1.0.0 (11h)
  trivy-supply-chain-1.0.0 (3d)
kind: Sample
apiVersion: sample.com/v1alpha1
metadata:
  name: example-sample
spec:
  # Kpack build specification
  build:
    # Configure workload to use a non-default builder or clusterbuilder
    builder:
      # builder kind
      kind: "clusterbuilder"
      # builder name
      name: "tiny-jammy"
    # cache options
    cache:
      # cache image to use
      image: "myregistry.com/some-repository/my-cache"
    env:
    - name: ""
      value: ""
    # Service account to use
    serviceAccountName: ""
  # Configuration for the registry to use
  registry:
    # The name of the repository
    # Required
    repository: "my-repository"
    # The name of the registry server, e.g. docker.io
    # Required
    server: "docker.io"
  # Image Scanning configuration
  scanning:
    active-keychains:
    - name: ""
    service-account-publisher: ""
    service-account-scanner: ""
    workspace:
      bindings:
        # ConfigMap represents a configMap that should populate this workspace.
      - configMap:
          # items if unspecified, each key-value pair in the Data field of the referenced ConfigMap will be projected into the volume as a file whose name is the key and content is the value. If specified, the listed keys will be projected into the specified paths, and unlisted keys will not be present. If a key is specified which is not present in the ConfigMap, the volume setup will error unless it is marked optional. Paths must be relative and may not contain the '..' path or start with '..'.
          items:
            # key is the key to project.
          - key: ""
            # mode is Optional: mode bits used to set permissions on this file. Must be an octal value between 0000 and 0777 or a decimal value between 0 and 511. YAML accepts both octal and decimal values, JSON requires decimal values for mode bits. If not specified, the volume defaultMode will be used. This might be in conflict with other options that affect the file mode, like fsGroup, and the result can be other mode bits set.
            mode:
            # path is the relative path of the file to map the key to. May not be an absolute path. May not contain the path element '..'. May not start with the string '..'.
            path: ""
          # Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
          name: ""
          # optional specify whether the ConfigMap or its keys must be defined
          optional:
          # defaultMode is optional: mode bits used to set permissions on created files by default. Must be an octal value between 0000 and 0777 or a decimal value between 0 and 511. YAML accepts both octal and decimal values, JSON requires decimal values for mode bits. Defaults to 0644. Directories within the path are not affected by this setting. This might be in conflict with other options that affect the file mode, like fsGroup, and the result can be other mode bits set.
          defaultMode:
        # Represents an empty directory for a pod. Empty directory volumes support ownership management and SELinux relabeling.
        emptyDir:
          # medium represents what type of storage medium should back this directory. The default is "" which means to use the node's default medium. Must be an empty string (default) or Memory. More info: https://kubernetes.io/docs/concepts/storage/volumes#emptydir
          medium: ""
          # sizeLimit is the total amount of local storage required for this EmptyDir volume. The size limit is also applicable for memory medium. The maximum usage on memory medium EmptyDir would be the minimum value between the SizeLimit specified here and the sum of memory limits of all containers in a pod. The default is nil which means that the limit is undefined. More info: https://kubernetes.io/docs/concepts/storage/volumes#emptydir
          sizeLimit:
        # Name is the name of the workspace populated by the volume.
        name: ""
        # Secret represents a secret that should populate this workspace.
        secret:
          # secretName is the name of the secret in the pod's namespace to use. More info: https://kubernetes.io/docs/concepts/storage/volumes#secret
          secretName: ""
          # defaultMode is Optional: mode bits used to set permissions on created files by default. Must be an octal value between 0000 and 0777 or a decimal value between 0 and 511. YAML accepts both octal and decimal values, JSON requires decimal values for mode bits. Defaults to 0644. Directories within the path are not affected by this setting. This might be in conflict with other options that affect the file mode, like fsGroup, and the result can be other mode bits set.
          defaultMode:
          # items If unspecified, each key-value pair in the Data field of the referenced Secret will be projected into the volume as a file whose name is the key and content is the value. If specified, the listed keys will be projected into the specified paths, and unlisted keys will not be present. If a key is specified which is not present in the Secret, the volume setup will error unless it is marked optional. Paths must be relative and may not contain the '..' path or start with '..'.
          items:
            # mode is Optional: mode bits used to set permissions on this file. Must be an octal value between 0000 and 0777 or a decimal value between 0 and 511. YAML accepts both octal and decimal values, JSON requires decimal values for mode bits. If not specified, the volume defaultMode will be used. This might be in conflict with other options that affect the file mode, like fsGroup, and the result can be other mode bits set.
          - mode:
            # path is the relative path of the file to map the key to. May not be an absolute path. May not contain the path element '..'. May not start with the string '..'.
            path: ""
            # key is the key to project.
            key: ""
          # optional field specify whether the Secret or its keys must be defined
          optional:
      size: ""
  source:
    # The sub path in the bundle to locate source code
    subPath: "sub-dir"
    # Fill this object in if you want your source to come from git.
    # The tag, commit and branch fields are mutually exclusive, use only one.
    # Required
    git:
      # A git branch ref to watch for new source
      branch: "main"
      # A git commit sha to use
      commit: ""
      # A git tag ref to watch for new source
      tag: "v1.0.0"
      # The url to the git source repository
      # Required
      url: "https://github.com/acme/my-workload.git"
```
Here the user can create a supply chain using the:
* Trivy Supply Chain Component created in the previous page.
* Custom Scanner Component created in the previous page.

This will render a sample workload yaml that the user can configure that we will put in `workload.yaml`.

Apply workload
```
kubectl apply -f workload.yaml -n DEV-NAMESPACE
```


### Observe workload

* Tanzu cartographer to see workload is running:
```
$ tanzu cartographer workload list
NAME                           NAMESPACE                   SUPPLY CHAIN                LATEST RUN                                  READY        AGE   MESSAGE                                     PROGRESS
Sample/golang-app-robin-test   grype-app-scanning-catalog  sample-supply-chain-1.0.0   SampleRun/golang-app-robin-test-run-ccmrq   Running      2m4s  waiting for stage buildpack-build & 1 more  ##-
```

* Trace workload progress:
See here to get kubectl tree plugin (https://github.com/ahmetb/kubectl-tree)
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


#### Verify workload performed scanning by checking scan results

* Get the ivs name by looking for the IVS in the namespace it was created in:
```
lrobin@lrobin6MD6R supply-chain % k get ivs -A
NAMESPACE                    NAME                          SUCCEEDED   REASON      AGE
grype-app-scanning-catalog   golang-app-robin-test-bbrpz   True        Succeeded   4m52s
```

* Follow this [verify app-scanning page](./verify-app-scanning.hbs.md#retrieve-scan-results) to see how to retrieve scan results by using the IVS name found in the previous step.
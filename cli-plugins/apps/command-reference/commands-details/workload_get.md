# tanzu apps workload get

`tanzu apps workload get` is a command used to retrieve information and status about a workload.

You can view workload details at anytime in the process. Some details, such as the status of the workload, the source of the workload application, the supply chain which took care of the workload, the supply chain resources which interact with the workload, if there is/was any issue while deploying the workload and finally which *Pods* the workload generates and the knative services related to the workload, if the supply chain is using knative.

## Default view

There are multiple sections in workload get command output. Following data is displayed

- Name of the workload and its status.
- Display source information of workload.
- If the workload was matched with a supply chain, the information of its name and the status is displayed.
- Information and status of the individual steps that's defined in the supply chain for workload.
- Any issue with the workload, the name and corresponding message.
- Workload related resource information and status like services claims, related pods, knative services.

At the very end of the command output, a hint to follow up commands is also displayed.

```bash
tanzu apps workload get rmq-sample-app
---
# rmq-sample-app: Ready
---
Source
type:     git
url:      https://github.com/jhvhs/rabbitmq-sample
branch:   main

Supply Chain
name:          source-to-url
last update:   94s
ready:         True

RESOURCE          READY   TIME
source-provider   True    3m51s
deliverable       True    3m55s
image-builder     True    101s
config-provider   True    94s
app-config        True    94s
config-writer     True    94s

Issues
No issues reported.

Services
CLAIM   NAME                         KIND              API VERSION
rmq     example-rabbitmq-cluster-1   RabbitmqCluster   rabbitmq.com/v1beta1

Pods
NAME                                               STATUS      RESTARTS   AGE
rmq-sample-app-00001-deployment-78fc86b47c-r5jws   Running     0          45s
rmq-sample-app-build-1-build-pod                   Succeeded   0          3m50s
rmq-sample-app-config-writer-pbshl-pod             Succeeded   0          94s

Knative Services
NAME             READY   URL
rmq-sample-app   Ready   http://rmq-sample-app.default.example.com

To see logs: "tanzu apps workload tail rmq-sample-app"
```

### `--export`

Exports the submitted workload in `yaml` format. This flag can also be used with `--output` flag. With export, the output is shortened because some fields are removed.

```bash
tanzu apps workload get pet-clinic --export

---
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
labels:
    apps.tanzu.vmware.com/workload-type: web
    autoscaling.knative.dev/min-scale: "1"
name: pet-clinic
namespace: default
spec:
source:
    git:
    ref:
        tag: tap-1.2
    url: https://github.com/sample-accelerators/spring-petclinic
```

### `--output`/`-o`

Configures how the workload is being shown, it supports the values `yaml`, `yml` and `json`, where `yaml` and `yml` are equal. It shows the actual workload in the cluster.
+ `yaml/yml`
    ```yaml
    tanzu apps workload get pet-clinic -o yaml]
    ---
    apiVersion: carto.run/v1alpha1
    kind: Workload
    metadata:
    creationTimestamp: "2022-06-03T18:10:59Z"
    generation: 1
    labels:
        apps.tanzu.vmware.com/workload-type: web
        autoscaling.knative.dev/min-scale: "1"
    ...
    spec:
    source:
        git:
        ref:
            tag: tap-1.1
        url: https://github.com/sample-accelerators/spring-petclinic
    status:
        conditions:
        - lastTransitionTime: "2022-06-03T18:10:59Z"
            message: ""
            reason: Ready
            status: "True"
            type: SupplyChainReady
        - lastTransitionTime: "2022-06-03T18:14:18Z"
            message: ""
            reason: ResourceSubmissionComplete
            status: "True"
            type: ResourcesSubmitted
        - lastTransitionTime: "2022-06-03T18:14:18Z"
            message: ""
            reason: Ready
            status: "True"
            type: Ready
        observedGeneration: 1
        resources:
        ...
        supplyChainRef:
            kind: ClusterSupplyChain
            name: source-to-url
            ...
    ```

+ `json`
    ```json
    tanzu apps workload get pet-clinic -o json
    {
        "kind": "Workload",
        "apiVersion": "carto.run/v1alpha1",
        "metadata": {
            "name": "pet-clinic",
            "namespace": "default",
            "uid": "937679ca-9c72-4e23-bfef-6334e6c003a7",
            "resourceVersion": "111637840",
            "generation": 1,
            "creationTimestamp": "2022-06-03T18:10:59Z",
            "labels": {
                "apps.tanzu.vmware.com/workload-type": "web",
                "autoscaling.knative.dev/min-scale": "1"
            },
    ...
    }
    "spec": {
            "source": {
                "git": {
                    "url": "https://github.com/sample-accelerators/spring-petclinic",
                    "ref": {
                        "tag": "tap-1.1"
                    }
                }
            }
        },
        "status": {
            "observedGeneration": 1,
            "conditions": [
                {
                    "type": "SupplyChainReady",
                    "status": "True",
                    "lastTransitionTime": "2022-06-03T18:10:59Z",
                    "reason": "Ready",
                    "message": ""
                },
                {
                    "type": "ResourcesSubmitted",
                    "status": "True",
                    "lastTransitionTime": "2022-06-03T18:14:18Z",
                    "reason": "ResourceSubmissionComplete",
                    "message": ""
                },
                {
                    "type": "Ready",
                    "status": "True",
                    "lastTransitionTime": "2022-06-03T18:14:18Z",
                    "reason": "Ready",
                    "message": ""
                }
            ],
            "supplyChainRef": {
                "kind": "ClusterSupplyChain",
                "name": "source-to-url"
            },
            "resources": [
                {
                    "name": "source-provider",
                    "stampedRef": {
                        "kind": "GitRepository",
                        "namespace": "default",
                        "name": "pet-clinic",
                        ...
                    }
                }
            ]
            ...
        }
        ...
    }
    ```

### `--namespace`/`-n`

Specifies the namespace where the workload was deployed

```bash
tanzu apps workload get pet-clinic -n development

---
# pet-clinic: Ready
---
Source
type:   git
url:    https://github.com/sample-accelerators/spring-petclinic
tag:    tap-1.2

Supply Chain
name:          source-to-url
last update:   10d
ready:         True

RESOURCE          READY   TIME
source-provider
deliverable
image-builder
config-provider
app-config
config-writer

Issues
No issues reported.

Pods
NAME                                           STATUS      RESTARTS   AGE
pet-clinic-00001-deployment-6445565f7b-ts8l5   Running     0          102s
pet-clinic-build-1-build-pod                   Succeeded   0          102s
pet-clinic-config-writer-8c9zv-pod             Succeeded   0          2m7s
Knative Services
NAME         READY   URL
pet-clinic   Ready   http://pet-clinic.default.apps.34.133.168.14.nip.io

To see logs: "tanzu apps workload tail pet-clinic"
```

# tanzu apps workload get

`tanzu apps workload get` is a command used to retrieve information and status about a workload.

You can view workload details at whenever. Some details are:

 - Workload name and type.
 - The source of the workload application.
 - The supply chain which took care of the workload.
 - The supply chain resources which interact with the workload. It also has the output of the resource stamped out by the supply chain  
 - The delivery workflow that the application follows.
 - If there is any issue while deploying the workload and finally which *pods* the workload generates and the knative services related to the workload.
 - if the supply chain is using knative.

## Default view

There are multiple sections in workload get command output. Following data is displayed:

- Name of the workload and its status.
- Display source information of workload.
- If the workload was matched with a supply chain, the information of its name and the status is displayed.
- Information and status of the individual steps that's defined in the supply chain for workload.
- Any issue with the workload: the name and corresponding message.
- Workload related resource information and status like services claims, related pods, knative services.

At the very end of the command output, a hint to follow up commands is also displayed.

```bash
tanzu apps workload get rmq-sample-app
📡 Overview
   name:   rmq-sample-app
   type:   web

💾 Source
   type:     git
   url:      https://github.com/jhvhs/rabbitmq-sample
   branch:   main

📦 Supply Chain
   name:   source-to-url

   RESOURCE          READY   HEALTHY   TIME   OUTPUT
   source-provider   True    True      27h    GitRepository/rmq-sample-app
   image-builder     True    True      22h    Image/rmq-sample-app
   config-provider   True    True      56d    PodIntent/rmq-sample-app
   app-config        True    True      56d    ConfigMap/rmq-sample-app
   config-writer     True    True      22h    Runnable/rmq-sample-app-config-writer

🚚 Delivery
   name:   delivery-basic

   RESOURCE          READY   HEALTHY   TIME   OUTPUT
   source-provider   True    True      56d    ImageRepository/rmq-sample-app-delivery
   deployer          True    True      22h    App/rmq-sample-app

💬 Messages
   No messages found.

🔁 Services
   CLAIM   NAME                         KIND              API VERSION
   rmq     example-rabbitmq-cluster-1   RabbitmqCluster   rabbitmq.com/v1beta1

🛶 Pods
   NAME                                     READY   STATUS      RESTARTS   AGE
   rmq-sample-app-build-1-build-pod         0/1     Completed   0          56d
   rmq-sample-app-build-2-build-pod         0/1     Completed   0          46d
   rmq-sample-app-build-3-build-pod         0/1     Completed   0          45d
   rmq-sample-app-config-writer-54mwk-pod   0/1     Completed   0          6d12h
   rmq-sample-app-config-writer-74qvp-pod   0/1     Completed   0          6d16h
   rmq-sample-app-config-writer-78r5w-pod   0/1     Completed   0          45d
   rmq-sample-app-config-writer-9xs5f-pod   0/1     Completed   0          46d

🚢 Knative Services
   NAME             READY   URL
   rmq-sample-app   Ready   http://rmq-sample-app.default.127.0.0.1.nip.io

To see logs: "tanzu apps workload tail rmq-sample-app"

```

### <a id="get-export"></a> `--export`

Exports the submitted workload in `yaml` format. This flag can also be used with `--output` flag. With export, the output is shortened because some fields are removed.

```bash
tanzu apps workload get tanzu-java-web-app --export

---
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
labels:
    apps.tanzu.vmware.com/workload-type: web
    autoscaling.knative.dev/min-scale: "1"
name: tanzu-java-web-app
namespace: default
spec:
source:
    git:
    ref:
        tag: tap-1.3
    url: https://github.com/vmware-tanzu/application-accelerator-samples/tanzu-java-web-app
```

### <a id="get-output"></a> `--output`/`-o`

Configures how the workload is being shown. This supports the values `yaml`, `yml` and `json`, where `yaml` and `yml` are equal. It shows the actual workload in the cluster.

+ `yaml/yml`
    ```yaml
    tanzu apps workload get tanzu-java-web-app -o yaml]
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
            tag: tap-1.3
        url: https://github.com/vmware-tanzu/application-accelerator-samples/tanzu-java-web-app
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
    tanzu apps workload get tanzu-java-web-app -o json
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
                    "url": "https://github.com/vmware-tanzu/application-accelerator-samples/tanzu-java-web-app",
                    "ref": {
                        "tag": "tap-1.3"
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
                        "name": "tanzu-java-web-app",
                        ...
                    }
                }
            ]
            ...
        }
        ...
    }
    ```

### <a id="get-namespace"></a> `--namespace`/`-n`

Specifies the namespace where the workload is deployed.

```bash
tanzu apps workload get spring-pet-clinic -n development

📡 Overview
   name:   spring-pet-clinic
   type:   web

💾 Source
   type:     git
   url:      https://github.com/sample-accelerators/spring-petclinic
   branch:   accelerator

📦 Supply Chain
   name:   source-to-url

   RESOURCE          READY   HEALTHY   TIME   OUTPUT
   source-provider   True    True      27h    GitRepository/spring-pet-clinic
   image-builder     True    True      22h    Image/spring-pet-clinic
   config-provider   True    True      60d    PodIntent/spring-pet-clinic
   app-config        True    True      60d    ConfigMap/spring-pet-clinic
   config-writer     True    True      22h    Runnable/spring-pet-clinic-config-writer

🚚 Delivery
   name:   delivery-basic

   RESOURCE          READY   HEALTHY   TIME   OUTPUT
   source-provider   True    True      60d    ImageRepository/spring-pet-clinic-delivery
   deployer          True    True      22h    App/spring-pet-clinic

💬 Messages
   No messages found.

🛶 Pods
   NAME                                        READY   STATUS      RESTARTS   AGE
   spring-pet-clinic-build-11-build-pod        0/1     Completed   0          6d12h
   spring-pet-clinic-build-12-build-pod        0/1     Completed   0          22h
   spring-pet-clinic-build-3-build-pod         0/1     Completed   0          60d
   spring-pet-clinic-config-writer-655rb-pod   0/1     Completed   0          21d
   spring-pet-clinic-config-writer-7h8bn-pod   0/1     Completed   0          6d12h
   spring-pet-clinic-config-writer-7xr6m-pod   0/1     Completed   0          60d
   spring-pet-clinic-config-writer-g9gp8-pod   0/1     Completed   0          45d

🚢 Knative Services
   NAME                READY   URL
   spring-pet-clinic   Ready   http://spring-pet-clinic.default.127.0.0.1.nip.io

To see logs: "tanzu apps workload tail spring-pet-clinic"

```

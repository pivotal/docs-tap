# tanzu apps workload get

This topic tells you how to use the `tanzu apps workload get` command to
retrieve information and status about a workload.

Some of the workload details in the command output are as follows:

- Workload name, type, and namespace.
- The source code used to build the workload or the pre-built OCI image.
- The supply chain that processed the workload.
- The specific resources within the supply chain that interacted with the workload, and the stamped
  out resources associated with each of those interactions.
- The delivery workflow that the application follows.
- Any issues associated with deploying the workload.
- The *pods* the workload generates.
- And when applicable, the Knative services related to the workload.

## Default view

There are multiple sections in the workload get command output. The following data is displayed:

- Name of the workload and its status.
- Displays source information of workload.
- If the workload was matched with a supply chain, the information of its name and the status is displayed.
- Information and status of the individual steps that is defined in the supply chain for the workload.
- Any issue with the workload: the name and corresponding message.
- Workload related resource information and status like services claims, related pods, knative services.

At the very end of the command output, a hint to follow up commands is also displayed.

>**Note** The `Supply Chain` and `Delivery` sections are included in the command output depending on
whether those resources are present on the target cluster. For example, if the target includes only build components, there would be no `Delivery` resources available and therefore the `Delivery` section would not be included in the command output.

```console
tanzu apps workload get rmq-sample-app
📡 Overview
   name:        rmq-sample-app
   type:        web
   namespace:   default

💾 Source
   type:     git
   url:      https://github.com/jhvhs/rabbitmq-sample
   branch:   main

📦 Supply Chain
   name:   source-to-url

   NAME               READY   HEALTHY   UPDATED   RESOURCE
   source-provider    True    True      7d11h     gitrepositories.source.toolkit.fluxcd.io/rmq-sample-app
   image-provider     True    True      2d18h     images.kpack.io/rmq-sample-app
   config-provider    True    True      7d11h     podintents.conventions.carto.run/rmq-sample-app
   app-config         True    True      7d11h     configmaps/rmq-sample-app
   service-bindings   True    True      7d11h     configmaps/rmq-sample-app-with-claims
   api-descriptors    True    True      7d11h     configmaps/rmq-sample-app-with-api-descriptors
   config-writer      True    True      2d18h     runnables.carto.run/rmq-sample-app-config-writer

🚚 Delivery
   name:   delivery-basic

   NAME              READY     HEALTHY   UPDATED   RESOURCE
   source-provider   True      True      7d11h     imagerepositories.source.apps.tanzu.vmware.com/rmq-sample-app-delivery
   deployer          True      True      6m25s     apps.kappctrl.k14s.io/rmq-sample-app

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

To see logs: "tanzu apps workload tail rmq-sample-app --timestamp --since 1h"

```

### <a id="get-export"></a> `--export`

Exports the submitted workload in `yaml` format. This flag can also be used with the `--output`
flag. The output is shortened because some text boxes are removed.

```console
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
      url: https://github.com/vmware-tanzu/application-accelerator-samples
    subPath: tanzu-java-web-app
```

### <a id="get-output"></a> `--output`/`-o`

Configures how the workload is shown. This supports the values `yaml`, `yml`, and `json`,
where `yaml` and `yml` are equal. It shows the actual workload in the cluster.

- `yaml/yml`

    ```console
    tanzu apps workload get tanzu-java-web-app -o yaml
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
            url: https://github.com/vmware-tanzu/application-accelerator-samples
        subPath: tanzu-java-web-app
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

- `json`

    ```console
    tanzu apps workload get tanzu-java-web-app -o json
    {
        "kind": "Workload",
        "apiVersion": "carto.run/v1alpha1",
        "metadata": {
            "name": "tanzu-java-web-app",
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
                    "url": "https://github.com/vmware-tanzu/application-accelerator-samples",
                    "ref": {
                        "tag": "tap-1.3"
                    }
                },
                "subPath": "tanzu-java-web-app"
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

```console
tanzu apps workload get tanzu-java-web-app -n development

📡 Overview
   name:        tanzu-java-web-app
   type:        web
   namespace:   development

💾 Source
   type:     git
   url:      https://github.com/vmware-tanzu/application-accelerator-samples
   sub-path: tanzu-java-web-app
   tag:      tap-1.3

📦 Supply Chain
   name:   source-to-url

   NAME               READY   HEALTHY   UPDATED   RESOURCE
   source-provider    True    True      31m       gitrepositories.source.toolkit.fluxcd.io/tanzu-java-web-app
   image-provider     True    True      30m       images.kpack.io/tanzu-java-web-app
   config-provider    True    True      30m       podintents.conventions.carto.run/tanzu-java-web-app
   app-config         True    True      30m       configmaps/tanzu-java-web-app
   service-bindings   True    True      30m       configmaps/tanzu-java-web-app-with-claims
   api-descriptors    True    True      30m       configmaps/tanzu-java-web-app-with-api-descriptors
   config-writer      True    True      30m       runnables.carto.run/tanzu-java-web-app-config-writer

🚚 Delivery
   name:   delivery-basic

   NAME              READY   HEALTHY   UPDATED   RESOURCE
   source-provider   True    True      30m       imagerepositories.source.apps.tanzu.vmware.com/tanzu-java-web-app-delivery
   deployer          True    True      30m       apps.kappctrl.k14s.io/tanzu-java-web-app

💬 Messages
   No messages found.

🛶 Pods
   NAME                                        READY   STATUS      RESTARTS   AGE
   tanzu-java-web-app-build-11-build-pod       0/1     Completed   0          6d12h
   tanzu-java-web-app-build-12-build-pod       0/1     Completed   0          22h
   tanzu-java-web-app-build-3-build-pod        0/1     Completed   0          60d
   tanzu-java-web-app-config-writer-655rb-pod  0/1     Completed   0          21d
   tanzu-java-web-app-config-writer-7h8bn-pod  0/1     Completed   0          6d12h
   tanzu-java-web-app-config-writer-7xr6m-pod  0/1     Completed   0          60d
   tanzu-java-web-app-config-writer-g9gp8-pod  0/1     Completed   0          45d

🚢 Knative Services
   NAME                READY   URL
   tanzu-java-web-app  Ready   http://tanzu-java-web-app.default.127.0.0.1.nip.io

To see logs: "tanzu apps workload tail tanzu-java-web-app --namespace development --timestamp --since 1h"

```

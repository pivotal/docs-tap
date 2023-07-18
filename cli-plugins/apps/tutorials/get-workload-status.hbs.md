# Get Workload Status

This topic tells you about Apps CLI plug-in commands you can use to get information about the status
of a workload.

## tanzu apps workload list

The `tanzu apps workload list` command gets a list of the workloads present in the cluster, either in the current namespace, in another namespace, or all namespaces.

Filter the list result by the `--namespace`, `--type` or `--app` flags.
The `--output` flag supports the `yaml` and `json` formats.

### --all-namespaces, -A flag

Show workloads in all namespaces in the cluster.

```console
tanzu apps workload list -A

NAMESPACE   TYPE   NAME                  APP                  READY                         AGE
default     web    nginx4                <empty>              Ready                         7d9h
default     web    rmq-sample-app        <empty>              Ready                         179m
default     web    spring-pet-clinic     <empty>              Unknown                       3h1m
default     web    tanzu-java-web-app    tanzu-java-web-app   Ready                         40m
nginx-ns    web    nginx2                <empty>              TemplateRejectedByAPIServer   8d
```

### --app flag

Filter workloads by application. Shows workloads for the application specified in the command.

```console
tanzu apps workload list --app spring-petclinic

NAME                TYPE   READY     AGE
spring-petclinic2   web    Unknown   29d
spring-petclinic3   web    Ready     29d
```

### --namespace, -n flag

Filter workloads by namespace. Lists all the workloads present in the specified namespace.

```console
tanzu apps workload list --namespace my-namespace

NAME   TYPE   APP       READY                         AGE
app1   web    <empty>   TemplateRejectedByAPIServer   8d
app2   web    <empty>   Ready                         8d
app3   web    <empty>   Unknown                       8d
```

### --output, -o flag

List all workloads in the specified namespace in `yaml`, `yml` or `json` format.

- yaml/yaml

    ```console
    # shorthand for --output is -o
    # alternatives are
    # tanzu apps workload list -o yaml / -o json
    # tanzu apps workload list -oyaml / -ojson
    tanzu apps workload list --output yaml
    ```

    ```yaml
    ---
    - apiVersion: carto.run/v1alpha1
    kind: Workload
    metadata:
        creationTimestamp: "2022-05-17T22:06:49Z"
        generation: 1
        labels:
        app.kubernetes.io/part-of: tanzu-java-web-app
        apps.tanzu.vmware.com/workload-type: web
        managedFields:
        ...
        ...
        manager: cartographer
        operation: Update
        time: "2022-05-17T22:06:52Z"
    name: tanzu-java-web-app2
    namespace: default
    resourceVersion: "6071972"
    uid: 7fbcd40d-4eb3-41dc-a1db-657b64148708
    spec:
        source:
            git:
                ref:
                  tag: tap-1.3
                url: https://github.com/vmware-tanzu/application-accelerator-samples
            subPath: tanzu-java-web-app
    ...
    ...
    ---
    - apiVersion: carto.run/v1alpha1
    kind: Workload
    metadata:
        creationTimestamp: "2022-05-17T22:06:49Z"
        generation: 1
        labels:
        app.kubernetes.io/part-of: tanzu-java-web-app
        apps.tanzu.vmware.com/workload-type: web
        managedFields:
        ...
        ...
        manager: cartographer
        operation: Update
        time: "2022-05-17T22:06:52Z"
    name: tanzu-java-web-app
    namespace: default
    resourceVersion: "6071972"
    uid: 7fbcd40d-4eb3-41dc-a1db-657b64148708
    spec:
        source:
            git:
                ref:
                  tag: tap-1.3
                url: https://github.com/vmware-tanzu/application-accelerator-samples
            subPath: tanzu-java-web-app
    ...
    ...
    ```

- json

    ```console
    tanzu apps workload list --output json
    ```

    ```json
    [
        {
            "kind": "Workload",
            "apiVersion": "carto.run/v1alpha1",
            "metadata": {
                "name": "tanzu-java-web-app2",
                "namespace": "default",
                "uid": "7fbcd40d-4eb3-41dc-a1db-657b64148708",
                "resourceVersion": "6071972",
                "generation": 1,
                "creationTimestamp": "2022-05-17T22:06:49Z",
                "labels": {
                    "app.kubernetes.io/part-of": "tanzu-java-web-app",
                    "apps.tanzu.vmware.com/workload-type": "web"
                },
            ...
            }
        ...
        },
        {
            "kind": "Workload",
            "apiVersion": "carto.run/v1alpha1",
            "metadata": {
                "name": "tanzu-java-web-app",
                "namespace": "default",
                "uid": "7fbcd40d-4eb3-41dc-a1db-657b64148708",
                "resourceVersion": "6071972",
                "generation": 1,
                "creationTimestamp": "2022-05-17T22:06:49Z",
                "labels": {
                    "app.kubernetes.io/part-of": "tanzu-java-web-app",
                    "apps.tanzu.vmware.com/workload-type": "web"
                },
            ...
            }
        ...
        },
    ...
    ...
    ]
    ```

## tanzu apps workload get

The `tanzu apps workload get` command provides detailed information and status about a workload.
Filter workloads with the `--namespace` flag, which specifies the namespace where the workload
is deployed.

There are multiple sections in the workload get command output. The following data is displayed:

- Name of the workload and its status.
- Displays source information of workload.
- If the workload was matched with a supply chain, the name of the supply chain is provided.
- A table providing the name, status, health, and resulting resource for each step defined in the 
supply chain or delivery for the workload.
- If there are any issues, such as errors or status messages associated with any of the steps defined
by the supply chain or delivery for the workload, the name and corresponding message are included in
the `Messages` section.
- Workload related resource information and status like services claims, related pods, and
Knative services.

At the very end of the command output, a hint to follow up commands is also displayed.

>**Note** The `Supply Chain` and `Delivery` sections are included in the command output depending on
whether those resources are present on the target cluster, for example, if the target includes only build
components, there is no `Delivery` resources available and therefore the `Delivery` section
is not included in the command output.

```console
# --namespace flag shorthand is -n
# An alternative way to use this command is 
# tanzu apps workload get tanzu-java-web-app -n development
tanzu apps workload get tanzu-java-web-app --namespace development

📡 Overview
   name:        tanzu-java-web-app
   type:        web
   namespace:   development

💾 Source
   type:       git
   url:        https://github.com/vmware-tanzu/application-accelerator-samples
   tag:        tap-1.6.0
   sub-path:   tanzu-java-web-app
   revision:   tap-1.6.0/bb9e655b33e39b242b6e5d9e218578e75c1d833c

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

## tanzu apps workload tail

`tanzu apps workload tail` checks the runtime logs of a workload. The workload can be filtered
by the namespace it was created on by using the `--namespace` flag, and the workload logs
can also be filtered by a specific `--component`. 

Use the `--since` flag to retrieve logs within a specific time-frame and display them with their `--timestamp`.

```console
tanzu apps workload tail tanzu-java-web-app -n development --since 1h --component build --timestamp

tanzu-java-web-app-build-1-build-pod[prepare] 2023-06-15T10:45:13.236584161-05:00 Build reason(s): CONFIG
tanzu-java-web-app-build-1-build-pod[prepare] 2023-06-15T10:45:13.237805020-05:00 CONFIG:
tanzu-java-web-app-build-1-build-pod[prepare] 2023-06-15T10:45:13.237847016-05:00       + env:
tanzu-java-web-app-build-1-build-pod[prepare] 2023-06-15T10:45:13.237853995-05:00       + - name: BP_OCI_SOURCE
tanzu-java-web-app-build-1-build-pod[prepare] 2023-06-15T10:45:13.237857982-05:00       +   value: tap-1.6.0/bb9e655b33e39b242b6e5d9e218578e75c1d833c
tanzu-java-web-app-build-1-build-pod[prepare] 2023-06-15T10:45:13.237861706-05:00       resources: {}
tanzu-java-web-app-build-1-build-pod[prepare] 2023-06-15T10:45:13.237864954-05:00       - source: {}
tanzu-java-web-app-build-1-build-pod[prepare] 2023-06-15T10:45:13.237868502-05:00       + source:
tanzu-java-web-app-build-1-build-pod[prepare] 2023-06-15T10:45:13.237871941-05:00       +   blob:
tanzu-java-web-app-build-1-build-pod[prepare] 2023-06-15T10:45:13.237875932-05:00       +     url: http://fluxcd-source-controller.flux-system.svc.cluster.local./gitrepository/default/tanzu-java-web-app/bb9e655b33e39b242b6e5d9e218578e75c1d833c.tar.gz
tanzu-java-web-app-build-1-build-pod[prepare] 2023-06-15T10:45:13.237880878-05:00       +   subPath: tanzu-java-web-app
tanzu-java-web-app-build-1-build-pod[prepare] 2023-06-15T10:45:13.237884317-05:00 Loading registry credentials from service account secrets
tanzu-java-web-app-build-1-build-pod[prepare] 2023-06-15T10:45:13.238417749-05:00 Loading secret for "gcr.io" from secret "registry-credentials" at location "/var/build-secrets/registry-credentials"
tanzu-java-web-app-build-1-build-pod[prepare] 2023-06-15T10:45:13.238437378-05:00 Loading secret for "https://gcr.io/" from secret "registry-credentials" at location "/var/build-secrets/registry-credentials"
...
```

### tail a workload while creating or applying a workload

You can tail a workload directly as part of the `tanzu apps workload create` or
`tanzu apps workload apply` commands by providing the `--tail` flag and you can display timestamps for
each log entry by including the `--tail-timestamp` flag.

```console
tanzu apps workload apply tanzu-java-web-app --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --git-tag tap-1.6.0 --sub-path tanzu-java-web-app --tail --tail-timestamp
🔎  Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  labels:
      6 + |    apps.tanzu.vmware.com/workload-type: web
      7 + |  name: tanzu-java-web-app
      8 + |  namespace: default
      9 + |spec:
     10 + |  source:
     11 + |    git:
     12 + |      ref:
     13 + |        tag: tap-1.6.0
     14 + |      url: https://github.com/vmware-tanzu/application-accelerator-samples
     15 + |    subPath: tanzu-java-web-app
❓ Do you want to create this workload? [yN]: y
👍 Created workload "tanzu-java-web-app"

To see logs:   "tanzu apps workload tail tanzu-java-web-app --timestamp --since 1h"
To get status: "tanzu apps workload get tanzu-java-web-app"

Waiting for workload "tanzu-java-web-app" to become ready...
+ tanzu-java-web-app-build-1-build-pod › prepare
tanzu-java-web-app-build-1-build-pod[prepare] 2023-06-15T11:28:12.746812119-05:00 Build reason(s): CONFIG
tanzu-java-web-app-build-1-build-pod[prepare] 2023-06-15T11:28:12.747149910-05:00 CONFIG:
tanzu-java-web-app-build-1-build-pod[prepare] 2023-06-15T11:28:12.747186215-05:00       + env:
tanzu-java-web-app-build-1-build-pod[prepare] 2023-06-15T11:28:12.747194864-05:00       + - name: BP_OCI_SOURCE
tanzu-java-web-app-build-1-build-pod[prepare] 2023-06-15T11:28:12.747201214-05:00       +   value: tap-1.6.0/bb9e655b33e39b242b6e5d9e218578e75c1d833c
tanzu-java-web-app-build-1-build-pod[prepare] 2023-06-15T11:28:12.747206421-05:00       resources: {}
tanzu-java-web-app-build-1-build-pod[prepare] 2023-06-15T11:28:12.747211761-05:00       - source: {}
tanzu-java-web-app-build-1-build-pod[prepare] 2023-06-15T11:28:12.747217114-05:00       + source:
tanzu-java-web-app-build-1-build-pod[prepare] 2023-06-15T11:28:12.747222613-05:00       +   blob:
tanzu-java-web-app-build-1-build-pod[prepare] 2023-06-15T11:28:12.747228733-05:00       +     url: http://fluxcd-source-controller.flux-system.svc.cluster.local./gitrepository/default/tanzu-java-web-app/bb9e655b33e39b242b6e5d9e218578e75c1d833c.tar.gz
tanzu-java-web-app-build-1-build-pod[prepare] 2023-06-15T11:28:12.747235497-05:00       +   subPath: tanzu-java-web-app
tanzu-java-web-app-build-1-build-pod[prepare] 2023-06-15T11:28:12.747240321-05:00 Loading registry credentials from service account secrets
tanzu-java-web-app-build-1-build-pod[prepare] 2023-06-15T11:28:12.747402066-05:00 Loading secret for "gcr.io" from secret "registry-credentials" at location "/var/build-secrets/registry-credentials"
tanzu-java-web-app-build-1-build-pod[prepare] 2023-06-15T11:28:12.747417620-05:00 Loading secret for "https://gcr.io/" from secret "registry-credentials" at location "/var/build-secrets/registry-credentials"
...
```

## --export flag

A clean workload definition export can be committed to GitHub or applied to a
different environment without having to make significant edits because the export only includes 
the fields specified by the developer who created it.

By default, the `--export` flag is configured to display the workload in `yaml` format. However, 
the behavior can be modified by combining it with the `--output` flag, which accepts `yaml`, `yml`, 
and `json` as values.

For example, if a workload is created with:

```console
tanzu apps workload apply tanzu-where-for-dinner --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --git-branch main --sub-path where-for-dinner
```

When querying the workload with `--export`, the default export format in `yaml` is as follows:

```console
# with yaml format
tanzu apps workload get tanzu-where-for-dinner --export
```

```yaml
---
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  labels:
    apps.tanzu.vmware.com/workload-type: web
  name: tanzu-where-for-dinner
  namespace: default
spec:
  source:
    git:
      ref:
        branch: main
      url: https://github.com/vmware-tanzu/application-accelerator-samples
    subPath: where-for-dinner
```

```console
# with json format
# shorthand for --output flag is -o
# an alternative for this command would be
# tanzu apps workload get rmq-sample-app --export -ojson
tanzu apps workload get rmq-sample-app --export --output json
```

```json
{
    "apiVersion": "carto.run/v1alpha1",
    "kind": "Workload",
    "metadata": {
        "labels": {
            "apps.tanzu.vmware.com/workload-type": "web"
        },
        "name": "rmq-sample-app",
        "namespace": "default"
    },
    "spec": {
        "serviceClaims": [
            {
                "name": "rmq",
                "ref": {
                    "apiVersion": "rabbitmq.com/v1beta1",
                    "kind": "RabbitmqCluster",
                    "name": "example-rabbitmq-cluster-1"
                }
            }
        ],
        "source": {
            "git": {
                "ref": {
                    "branch": "main"
                },
                "url": "https://github.com/jhvhs/rabbitmq-sample"
            }
        }
    }
}
```

## --output flag with `tanzu apps workload get` command

Use the `--output` flag with `tanzu apps workload get` to retrieve a workload with all the cluster-specifics.

```console
# with json format
tanzu apps workload get rmq-sample-app --output json # can also be used as tanzu apps workload get rmq-sample-app -ojson
```

```json
{
    "kind": "Workload",
    "apiVersion": "carto.run/v1alpha1",
    "metadata": {
        "name": "rmq-sample-app",
        "namespace": "default",
        "uid": "3619ff6d-9e73-473a-9112-891a6d8aee9e",
        "resourceVersion": "11657434",
        "generation": 2,
        "creationTimestamp": "2022-11-28T05:10:32Z",
        "labels": {
            "apps.tanzu.vmware.com/workload-type": "web"
        },
     ...
    },
    ...
        "status": {
        "observedGeneration": 2,
        "conditions": [
            {
                "type": "SupplyChainReady",
                "status": "True",
                "lastTransitionTime": "2022-11-28T05:10:32Z",
                "reason": "Ready",
                "message": ""
            },
            ...
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
                    "name": "rmq-sample-app",
                    "apiVersion": "source.toolkit.fluxcd.io/v1beta1",
                    "resource": "gitrepositories.source.toolkit.fluxcd.io"
                },
                "templateRef": {
                    "kind": "ClusterSourceTemplate",
                    "name": "source-template",
                    "apiVersion": "carto.run/v1alpha1"
                },
            ...
            }
        ...
        ]
        ...
    }
    ...
}
```

```console
## with yaml format
tanzu apps workload get rmq-sample-app --output yaml # can also be used as tanzu apps workload get rmq-sample-app -oyaml
```

```yaml
---
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  creationTimestamp: "2022-11-28T05:10:32Z"
  generation: 2
  labels:
    apps.tanzu.vmware.com/workload-type: web
  ...
  name: rmq-sample-app
  namespace: default
  resourceVersion: "11657434"
  uid: 3619ff6d-9e73-473a-9112-891a6d8aee9e
spec:
  serviceClaims:
  - name: rmq
    ref:
      apiVersion: rabbitmq.com/v1beta1
      kind: RabbitmqCluster
      name: example-rabbitmq-cluster-1
  source:
    git:
      ref:
        branch: main
      url: https://github.com/jhvhs/rabbitmq-sample
status:
  conditions:
  - lastTransitionTime: "2022-11-28T05:10:32Z"
    message: ""
    reason: Ready
    status: "True"
    type: SupplyChainReady
  ...
  observedGeneration: 2
  resources:
  ...
    name: source-provider
    outputs:
    - digest: sha256:97b2cb779b4ea31339595cd204a3fec0053805eeacbbd6d6dd23af7d3000a6ae
      lastTransitionTime: "2022-11-28T05:16:01Z"
      name: url
      preview: |
        http://fluxcd-source-controller.flux-system.svc.cluster.local./gitrepository/default/rmq-sample-app/73c6311eefbf724fee9ad6f4524fa24ec842ff34.tar.gz
    - digest: sha256:e7884b071fe1bbb2551d42a171043d061a7591e744705572136e689c2a154b7a
      lastTransitionTime: "2022-11-28T05:16:01Z"
      name: revision
      preview: |
        HEAD/73c6311eefbf724fee9ad6f4524fa24ec842ff34
      ...
```

## --output flag with `tanzu apps workload apply` command

Use this flag to retrieve the workload in the `yaml`, `yml`, or
`json` format after it is applied. When combined with the `--yes` flag, all prompts are bypassed,
and only the workload definition is returned. Additionally, use the `--wait` or `--tail` flags,
to retrieve the workload with its current status.

```console
tanzu apps workload create tanzu-where-for-dinner --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --git-branch main --sub-path where-for-dinner -oyaml
🔎 Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  labels:
      6 + |    apps.tanzu.vmware.com/workload-type: web
      7 + |  name: tanzu-where-for-dinner
      8 + |  namespace: default
      9 + |spec:
     10 + |  source:
     11 + |    git:
     12 + |      ref:
     13 + |        branch: main
     14 + |      url: https://github.com/vmware-tanzu/application-accelerator-samples
     15 + |    subPath: where-for-dinner
❓ Do you want to create this workload? [yN]: y
👍 Created workload "tanzu-where-for-dinner"

To see logs:   "tanzu apps workload tail tanzu-where-for-dinner --timestamp --since 1h"
To get status: "tanzu apps workload get tanzu-where-for-dinner"

---
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  creationTimestamp: "2023-07-06T17:22:34Z"
  generation: 1
  labels:
    apps.tanzu.vmware.com/workload-type: web
  name: tanzu-where-for-dinner
  namespace: default
  resourceVersion: "249375192"
  uid: 8a8132e5-9ee4-41f3-af92-9578ea1efb01
spec:
  source:
    git:
      ref:
        branch: main
      url: https://github.com/vmware-tanzu/application-accelerator-samples
    subPath: where-for-dinner
status:
  supplyChainRef: {}
```

Using `--yes` flag with the command

```console
tanzu apps workload create tanzu-where-for-dinner --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --git-branch main --sub-path where-for-dinner -ojson -y
{
    "apiVersion": "carto.run/v1alpha1",
    "kind": "Workload",
    "metadata": {
        "creationTimestamp": "2023-07-06T18:03:07Z",
        "generation": 1,
        "labels": {
            "apps.tanzu.vmware.com/workload-type": "web"
        },
        "name": "tanzu-where-for-dinner",
        "namespace": "default",
        "resourceVersion": "249455362",
        "uid": "06a9793b-6747-4f9e-8455-6f5b342c3631"
    }
    "spec": {
        "source": {
            "git": {
                "ref": {
                    "branch": "main"
                },
                "url": "https://github.com/vmware-tanzu/application-accelerator-samples"
            },
            "subPath": "where-for-dinner"
        }
    },
    "status": {
        "supplyChainRef": {}
    }
}
```

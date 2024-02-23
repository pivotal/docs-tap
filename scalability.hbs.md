# Scale workloads 

This topic describes the best practices required to build and deploy workloads at scale.

## Sample application reference

The following sections describe the configuration of the different-size applications used to derive scalability best practices.

### Small

This is the simplest configuration and consists of the following services and workloads:

- API Gateway workload
- Search workload with in-memory database
- Search processor workload
- Availability workload with in-memory database
- UI workload
- 3 Node RabbitMQ cluster

### Medium

This includes all of the services of the small-size application and the following services and workloads:

- Notify workload
- Persistent Database, MySQL or Postgres

### Large

This includes all of the services of the medium size application and the following services and workloads:

- Crawler Service
- Redis

## Application Configuration

The following section describes the application configuration used to derive the
scalability best practices.

**Supply chains used:**

- Out of the Box Supply Chain with Testing and Scanning (Build+Run)
- Out of the Box Supply Chain Basic +  Out of the Box Supply Chain with Testing (Iterate)

**Workload type**: `web`, `server` + `worker`

**Kubernetes Distribution**: Azure Kubernetes Service

**Number of applications deployed concurrently**: 50&ndash;55

|  | **CPU** |**Memory Range**| **Workload CRs in Iterate** |**Workload CRs in Build+Run**|**Workload Transactions per second**|
|:--- |:--- |:--- |:--- |:--- |:--- |
|**Small** | 500m - 700m |3-5&nbsp;GB| 4 |5| 4 |
|**Medium** | 700m - 1000m |4-6&nbsp;GB| NA |6|4 |
|**Large** | 1000m - 1500m |6-8&nbsp;GB| NA |7|4 |

## Scale configuration for workload deployments

This section describes cluster sizes for deploying a 1K workload.

Node configuration: 4 vCPUs, 16&nbsp;GB RAM, 120&nbsp;GB Disk size

|**Cluster Type / Workload Details** |**Shared Iterate Cluster** | **Build Cluster** |**Run Cluster 1** |**Run Cluster 2**| **Run Cluster 3** |
|:--- |:--- |:--- |:--- |:---|:--- |:--- |
|**No. of Namespaces** |300| 333 | 333 | 333 | 333 |
|**Small** | 300 | 233 | 233 | 233 | 233 |
|**Medium** | | 83 | 83 | 83 | 83 |
|**Large** | | 17 | 17 | 17 | 17 |
|**No. of Nodes** |90 | 60 | 135 | 135 | 135 |

## Best Practices

The following table describes the resource limit changes that are required for components to support the scale configuration described in the previous table.

|**Controller/Pod**|**CPU Requests/Limits**|**Memory Requests/Limits**|**Other changes**|**Build** | **Run** | **Iterate** |**Changes made in**|
|:------|:------|:--------|:-------|:------|:------|:-----|:------|:--------|:-------|
 AMR Observer | 200&nbsp;m/1000&nbsp;m | 2&nbsp;Gi/**3&nbsp;Gi** |n/a| Yes | Yes | No | `tap-values.yaml` |
| Build Service/kpack controller | 20&nbsp;m/100&nbsp;m | **1&nbsp;Gi/2&nbsp;Gi** |n/a| Yes | No | Yes | `tap-values.yaml` |
| Scanning/scan-link | 200&nbsp;m/500&nbsp;m | **1&nbsp;Gi/3&nbsp;Gi**| "SCAN_JOB_TTL_SECONDS_AFTER_FINISHED" - 10800*| Yes | No | No | `tap-values.yaml` |
| Cartographer| **3000&nbsp;m/4000&nbsp;m** | **10&nbsp;Gi/10&nbsp;Gi** | In `tap-values.yaml`, change `concurrency` to 25. | Yes| Partial (only CPU) | Yes  | `tap-values.yaml` |
| Cartographer conventions| 100&nbsp;m/100&nbsp;m | 20&nbsp;Mi/**1.8&nbsp;Gi**  | n/a | Yes | Yes | Yes | `tap-values.yaml` |
| Namespace Provisioner | 100&nbsp;m/500&nbsp;m | **500&nbsp;Mi/2&nbsp;Gi** |n/a | Yes | Yes | Yes | `tap-values.yaml` |
| Cnrs/knative-controller  | 100&nbsp;m/1000&nbsp;m | **512&nbsp;Mi/2&nbsp;Gi** |n/a | No | Yes | Yes | `tap-values.yaml` |
| Cnrs/net-contour | 40&nbsp;m/400&nbsp;m | **512&nbsp;Mi/2&nbsp;Gi** | In `tap-values.yaml`, change Contour envoy workload type from `Daemonset` to `Deployment`.| No | Yes | Yes | `tap-values.yaml` |
| Cnrs/activator | 300&nbsp;m/1000&nbsp;m | **5&nbsp;Gi/5&nbsp;Gi** | n/a | No | Yes | No | `tap-values.yaml` |
| Cnrs/autoscaler  | 100&nbsp;m/1000&nbsp;m | **2&nbsp;Gi/2&nbsp;Gi** | n/a | No | Yes | No | `tap-values.yaml` |
| tap-telemetry/tap-telemetry-informer | 100&nbsp;m/1000&nbsp;m | 100&nbsp;m/**2&nbsp;Gi** | n/a| Yes| No | Yes| `tap-values.yaml` |
| appsso/controller | 20&nbsp;m/500&nbsp;m | 100&nbsp;Mi/**1&nbsp;Gi** | n/a | No | Yes | Yes | `tap-values.yaml` |

- CPU is measured in millicores. m = millicore. 1000 millicores = 1 vCPU.
- Memory is measured in Mebibyte and Gibibyte. Mi = Mebibyte. Gi = Gibibyte
- In the CPU Requests/Limits column and the Memory Requests/Limits, the changed values are bolded.
Non-bolded values are the default ones set during a Tanzu Application Platform installation.
- In the CPU Requests/Limits column, some of the request and limits values are set equally so that
the pod is allocated in a node where the requested limit is available.

\* Only when there is an issue with scan pods getting deleted before Cartographer can process it

## Example resource limit changes

The following section provides examples of the changes required to the default limits to achieve scalability:

### Cartographer

The default Cartographer concurrency limits are:

```console
cartographer:
  cartographer:
    concurrency:
      max_workloads: 2
      max_deliveries: 2
      max_runnables: 2
```

Edit `values.yaml` to scale Cartographer concurrency limits. Configure the node with 4 vCPUs,
16&nbsp;GB RAM, and 120&nbsp;GB disk size:

```console
cartographer:
  cartographer:
    concurrency:
      max_workloads: 25
      max_deliveries: 25
      max_runnables: 25
```

The default resource limits are:

```console
resources:
  limits:
    cpu: 1
    memory: 1Gi
  requests:
    cpu: 500m
    memory: 512Mi
```

Edit `values.yaml` to scale resource limit:

```console
# build-cluster
cartographer:
  cartographer:
    resources:
      limits:
        cpu: 4
        memory: 10Gi
      requests:
        cpu: 3
        memory: 10Gi

# run-cluster
cartographer:
  cartographer:
    resources:
      limits:
        cpu: 4
        memory: 2Gi
      requests:
        cpu: 3
        memory: 1G
```

### Cartographer-conventions

The default resource limits are:

```console
resources:
  limits:
    cpu: 100m
    memory: 256Mi
  requests:
    cpu: 100m
    memory: 20Mi
```

Edit `values.yaml` to scale resource limit:

```console
cartographer:
  conventions:
    resources:
      limits:
        memory: 1.8Gi
```

### Scan-link-controller

The default resource limits are:

```console
resources:
  limits:
    cpu: 250m
    memory: 256Mi
  requests:
    cpu: 100m
    memory: 128Mi
```

Edit `values.yaml` to scale resource limit:

```console
scanning:
  resources:
    limits:
      cpu: 500m
      memory: 3Gi
    requests:
      cpu: 200m
      memory: 1Gi
```

### AMR Observer

The default resource limits are:

```console
resources:
  limits:
    cpu:     500m
    memory:  512Mi
  requests:
    cpu:      100m
    memory:   256Mi
```

Edit `values.yaml` to scale resource limits:

```console
amr:
  observer:
    app_limit_cpu: 1000m
    app_limit_memory: 3Gi
    app_req_cpu: 200m
    app_req_memory: 2Gi
```

### kpack-controller in build service

The default resource limits are:

```console
resources:
  limits:
    memory: 1Gi
  requests:
    cpu: 20m
    memory: 1Gi
```

Edit `values.yaml` to scale resource limits:

```console
buildservice:
  controller:
    resources:
      limits:
         memory: 2Gi
         cpu: 100m
      requests:
         memory: 1Gi
         cpu: 20m
```

### Namespace Provisioner

The default resource limits are:

```console
resources:
  limits:
    cpu: 500m
    memory: 100Mi
  requests:
    cpu: 100m
    memory: 20Mi
```

Edit `values.yaml` to scale resource limits:

```console
namespace_provisioner:
  controller_resources:
    resources:
      limits:
        cpu: 500m
        memory: 2Gi
      requests:
        cpu: 100m
        memory: 500Mi
```

### CNRS Knative Serving

The default resource limits are:

```console
resources:
  limits:
    cpu: 1
    memory: 1000Mi
  requests:
    cpu: 100m
    memory: 100Mi
```

Edit `values.yaml` to scale resource limits:

```console
cnrs:
  resource_management:
  - name: "controller"
    limits:
      cpu: 1000m
      memory: 2Gi
    requests:
      cpu: 100m
      memory: 512Mi
```

### net-contour controller

Change deployment type from Daemonset to Deployment.

```console
contour:
  envoy:
    workload:
      type: Deployment
      replicas: 3
```

The default resource limits are:

```console
resources:
  limits:
    cpu: 400m
    memory: 400Mi
  requests:
    cpu: 40m
    memory: 40Mi
```

Edit `values.yaml` to scale resource limits:

```console
cnrs:
  resource_management:
  - name: "net-contour-controller"
    limits:
      cpu: 400m
      memory: 2Gi
    requests:
      cpu: 40m
      memory: 512Mi
```

### Autoscaler

The default resource limits are:

```console
resources:
  limits:
    cpu: 1
    memory: 1000Mi
  requests:
    cpu: 100m
    memory: 100Mi
```

Edit `values.yaml` to scale resource limits:

```console
cnrs:
  resource_management:
  - name: "autoscaler"
    limits:
      cpu: 1000m
      memory: 2Gi
    requests:
      cpu: 100m
      memory: 2Gi
```

### Activator

The default resource limits are:

```console
resources:
  limits:
    cpu: 1
    memory: 600Mi
  requests:
    cpu: 300m
    memory: 60Mi
```

Edit `values.yaml` to scale resource limits:

```console
cnrs:
  resource_management:
  - name: "activator"
    limits:
      cpu: 1000m
      memory: 5Gi
    requests:
      cpu: 300m
      memory: 5Gi
```

### Tap Telemetry

The default resource limits are:

```console
resources:
  limits:
    cpu: 1
    memory: 1000Mi
  requests:
    cpu: 100m
    memory: 100Mi
```

Edit `values.yaml` to scale resource limits:

```console
tap_telemetry:
  limit_memory: 2Gi
```

### AppSSO

The default resource requests and limits are:

```console
resources:
  requests:
    cpu: 20m
    memory: 100Mi
  limits:
    cpu: 500m
    memory: 500Mi
```

Edit `values.yaml` to scale resource limits:

```console
appsso:
  resources:
    limits:
      memory: 1Gi
```

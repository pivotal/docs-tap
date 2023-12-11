# Knative Serving resource management

This topic tells you how to configure the memory and CPU allocation of resources in the `knative-serving` namespace.

## <a id='overview'></a> Overview

By default, Knative deployments are allocated a predefined amount of CPU and
memory. These default allocations support general use cases, but you might
adjust the allocations for the following reasons:

- **Performance Optimization**: Customize resource allocations to help fine-tune 
  the load for specific workloads to improve response times and throughput.
- **Cost Efficiency**: Customize resources to avoid over-provisioning or
  under-provisioning and verify efficient resource use.
- **Improved Stability**: Control resource allocation to prevent any deployment
  from consuming excessive resources and increase the stability of the entire
  cluster.

You can tailor the memory and CPU of Knative system controllers by using the CNRs `resource_management` config option.

## <a id='update-resources'></a> Configuring memory and cpu requests and limits for Knative Serving resources

To configure the memory and CPU allocation for the deployments in the `knative-serving` namespace, you must specify the `resource_management` config option on CNRs. You can only configure the following deployments:

- `activator`
- `autoscaler`
- `autoscaler-hpa`
- `controller`
- `net-certmanager-controller`
- `net-certmanager-webhook`
- `net-contour-controller`
- `webhook`
- `net-istio-controller`
- `net-istio-webhook`

### <a id='resource-mgmt-example'></a> Example: updating the activator deployment

The following example shows how to adjust the CPU and memory requests and limits by using the `resource_management` option of the Knative `activator` deployment. By default, the `activator` deployment has the following resources:

```yaml
resources:
    requests:
        cpu: 300m
        memory: 60Mi
    limits:
        cpu: 1000m
        memory: 600Mi
```

Specify the following resources to the activator pod:

```yaml
cnrs:
  resource_management:
    - name: NAME
      requests:
        memory: MEMORY
        cpu: CPU
      limits:
        memory: MEMORY
        cpu: CPU
```

Where:

- `NAME` represents the name of the deployment you want to configure.
- `requests` specifies the amount of resources that are allocated to the pods of this deployment:
    - `MEMORY` is how many megabytes of memory you want to request.
    - `CPU` is how many CPU cores, 100 millicpu units, you want to request.
- `limits` sets the maximum amount of resources that the pods can use:
    - `MEMORY` is the limit of how many megabytes of memory that the pods can use.
    - `CPU` is the limit of how many CPU cores, 100 millicpu units, pods can use.

> **Note** You can provide any of the resource units supported by Kubernetes as explained in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#resource-units-in-kubernetes).

After updating CNRs, get the deployment information to confirm the `activator` deployment updated:

```console
kubectl get deployment activator -n knative-serving -o=jsonpath='{.spec.template.spec.containers[?(@.name=="activator")].resources}'

{"limits":{"cpu":"1","memory":"1000Mi"},"requests":{"cpu":"100m","memory":"100Mi"}}
```

All fields, such as the request and limits of CPUs, and the memory's request and limits, are optional, except for the deployment's name, causing it to use the default values specified for these deployments.

For example, to change only the limit and the memory's request of the Knative `controller`, you can provide the following configuration to `resource_management`:

```yaml
cnrs:
  resource_management:
    - name: "controller"
      requests:
        memory: "130M"
      limits:
        cpu: "0.5"
```

# Knative Serving Resource Management

This topic tells you how to configure the memory and CPU allocation of resources in the `knative-serving` namespace.

## <a id='overview'></a> Overview

By default, Knative Deployments are allocated a predefined amount of CPU and memory. These default allocations cater to general use cases, but there can be scenarios where adjustments can provide benefits:

* *Performance Optimization*: Customizing resource allocations can help in fine-tuning the load for specific workloads, potentially leading to better response times and throughput.
* *Cost Efficiency*: Over-provisioning resources can result in unnecessary costs, especially in large-scale deployments. Conversely, under-provisioning can cause potential disruptions or degrade performance. Tailoring the allocations ensures efficient resource utilization.
* *Improved Stability*: In environments with various workloads, controlling resource allocation can prevent any single deployment from consuming excessive resources, thereby safeguarding the stability of the entire cluster.

To address these scenarios, CNRs provides the config option `resource_management` so that administrators may tailor the memory and CPU of Knative system controllers to fit their needs.

## <a id='update-resources'></a> Configuring Memory and CPU Requests and Limits for Knative Serving Resources

To configure the memory and CPU allocation for the deployments in the knative-serving namespace, you will need specify the `resource_management` config option available on CNRs. Note that only the following deployments can be configured:

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

### <a id='resource-mgmt-example'></a> Example: Updating the Activator Deployment

To give you an idea of how to use the `resource_management` option, let's take the example where we adjust the CPU and memory requests and limits of the Knative `activator` deployment. By default, the `activator` Deployment is deployed with the following resources:

```console
resources:
    requests:
        cpu: 300m
        memory: 60Mi
    limits:
        cpu: 1000m
        memory: 600Mi
```

Let's configure CNRs to specify the following resources to the activator pod:

```console
cnrs:
  resource_management:
    - name: "activator"
      requests:
        memory: "100Mi"
        cpu: "100m"
      limits:
        memory: "1000Mi"
        cpu: "1"
```

In the example above:

- name: Represents the name of the deployment you want to configure. In this case, it's `activator`.
- requests: Specifies the amount of resources that should be allocated to the pods of this deployment:
    - memory: "100Mi" represents a request of 100 Megabytes of memory.
    - cpu: "100m" means a request of 0.1 CPU core (100 milliCPU units).
- limits: Sets the maximum amount of resources that the pods can use:
    - memory: "1000Mi" represents a limit of 1 Gigabyte of memory.
    - cpu: "1" indicates a limit of 1 full CPU core.

> **Note** It is possible to provide *any* of the resource units supported by Kubernetes as explained in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#resource-units-in-kubernetes).

After updating CNR, get the Deployment information to confirm the `activator` Deployment has been updated:
```yaml
kubectl get deployment activator -n knative-serving -o=jsonpath='{.spec.template.spec.containers[?(@.name=="activator")].resources}'

{"limits":{"cpu":"1","memory":"1000Mi"},"requests":{"cpu":"100m","memory":"100Mi"}}
```

It's worth mentioning that even though in the example above we updated all possible fields (i.e. CPU's request **and** limits and memory's request and limits), any of those fields are optional and can be ommited (except for the deployment's name), causing it to use the default value specified for these deployments.

For example, if you wanted to change only the CPU's limit and the memory's request of the Knative `controller`, you could provide the following configuration to `resource_management`:

```console
cnrs:
  resource_management:
    - name: "controller"
      requests:
        memory: "130M"
      limits:
        cpu: "0.5"
```
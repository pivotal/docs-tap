# TCP workloads (Beta feature)

The `tcp` workload type allows you to deploy traditional network applications on Tanzu Application Platform. Using an application workload specification, you can build and deploy application source code to a manually-scaled Kubernetes deployment which exposes an in-cluster Service endpoint. Environment-specific LoadBalancer Services or Ingress resources may be used to expose these applications outside the cluster if needed.

The `tcp` workload is a good match for traditional applications (including HTTP applications) which store state locally, run background tasks outside of requests, provide multiple network ports or non-HTTP protocols, or are not otherwise a good match for the `web` workload type. The following section will describe how to create and install a supply chain for the `tcp` workload type. Applications using the `tcp` workload type:

* Do not natively autoscale, but can be used with the Kubernetes Horizontal Pod Autoscaler
* By default are exposed only within the cluster using a `ClusterIP` Service
* Use health checks if defined by a convention
* Use a rolling update pattern by default

> **Important:** The functionality of beta features has been tested, but performance has not.
> Features enter the beta stage for customers to gain early access to them and give feedback on their
> design and behavior.
> Beta features might undergo changes based on that feedback before leaving beta.
> VMware discourages running beta features in production.
> VMware doesn't guarantee that any beta feature can be upgraded in the future.

When creating a workload with `tanzu apps workload create`, you can use the `--type=tcp` argument to select the `tcp` workload type. You can also use the `apps.tanzu.vmware.com/workload-type:tcp` annotation in the YAML workload description to support this deployment type.

## Creating a `tcp` SupplyChain

### <a id="prereqs"></a>Prerequisites

Before using `tcp` workloads on Tanzu Application Platform, complete the following prerequisites:

* Complete all steps described in [Installing Tanzu Application Platform](../install-intro.md).
* [Set up developer namespaces to use installed packages](../install-components.html#setup).

### <a id="templates"></a>Create Supply Chain Templates

The `tcp` supply chain replaces the `config-template` from the existing OOTB supply chain with two new templates:

* The `deployment-and-service-template` defines Kubernetes Deployment and Service objects representing the workload, instead of a Knative Service.
* The `apply-bindings` template extends the `deployment-and-service-template` with requested ServiceBindings and ResourceClaims.

Apply the following YAML manifests with `kubectl apply -f $FILE`:

```yaml
apiVersion: carto.run/v1alpha1
kind: ClusterConfigTemplate
metadata:
  name: deployment-and-service-template
spec:
  configPath: .data
  ytt: |
    #@ load("@ytt:data", "data")
    #@ load("@ytt:yaml", "yaml")

    #@ def merge_labels(fixed_values):
    #@   labels = {}
    #@   if hasattr(data.values.workload.metadata, "labels"):
    #@     labels.update(data.values.workload.metadata.labels)
    #@   end
    #@   labels.update(fixed_values)
    #@   return labels
    #@ end

    #@ def delivery():
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: #@ data.values.workload.metadata.name
      annotations:
        kapp.k14s.io/update-strategy: "fallback-on-replace"
      labels: #@ merge_labels({ "app.kubernetes.io/component": "run", "carto.run/workload-name": data.values.workload.metadata.name })
    spec:
      selector:
        matchLabels: #@ data.values.config.metadata.labels
      template: #@ data.values.config
    #@ end

    #@ def merge_ports(ports_spec, containers):
    #@   ports = {}
    #@   for c in containers:
    #@     for p in getattr(c, "ports", []):
    #@       ports[p.containerPort] = {"targetPort": p.containerPort, "port": p.containerPort, "name": getattr(p, "name", str(p.containerPort))}
    #@     end
    #@   end
    #@   for p in ports_spec:
    #@     ports[p.port] = {"targetPort": getattr(p, "containerPort", p.port), "port": p.port, "name": getattr(p, "name", str(p.port))}
    #@   end
    #@   return ports.values()
    #@ end


    #@ def services():
    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: #@ data.values.workload.metadata.name
      labels: #@ merge_labels({ "app.kubernetes.io/component": "run", "carto.run/workload-name": data.values.workload.metadata.name })
    spec:
      selector: #@ data.values.config.metadata.labels
      ports:
      #@ declared_ports = {}
      #@ if "ports" in data.values.params:
      #@   declared_ports = data.values.params.ports
      #@ end
      #@ for p in merge_ports(declared_ports, data.values.config.spec.containers):
      - #@ p
      #@ end
    #@ end

    ---
    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: #@ data.values.workload.metadata.name + "-base"
      labels: #@ merge_labels({ "app.kubernetes.io/component": "config" })
    data:
      delivery.yml: #@ yaml.encode(delivery())
      service.yaml: #@ yaml.encode(services())
---
apiVersion: carto.run/v1alpha1
kind: ClusterConfigTemplate
metadata:
  name: apply-bindings
spec:
  configPath: .data
  ytt: |
    #@ load("@ytt:data", "data")
    #@ load("@ytt:yaml", "yaml")
    #@ load("@ytt:json", "json")
    #@ load("@ytt:struct", "struct")

    #@ def get_claims_extension():
    #@   claims_extension_key = "serviceclaims.supplychain.apps.x-tanzu.vmware.com/extensions"
    #@   if not hasattr(data.values.workload.metadata, "annotations") or not hasattr(data.values.workload.metadata.annotations, claims_extension_key):
    #@     return None
    #@   end
    #@
    #@   extension = json.decode(data.values.workload.metadata.annotations[claims_extension_key])
    #@
    #@   spec_extension = extension.get('spec')
    #@   if spec_extension == None:
    #@     return None
    #@   end
    #@
    #@   return spec_extension.get('serviceClaims')
    #@ end

    #@ def merge_claims_extension(claim, claims_extension):
    #@   if claims_extension == None:
    #@     return claim.ref
    #@   end
    #@   extension = claims_extension.get(claim.name)
    #@   if extension == None:
    #@      return claim.ref
    #@   end
    #@   extension.update(claim.ref)
    #@   return extension
    #@ end

    #@ def param(key):
    #@   if not key in data.values.params:
    #@     return None
    #@   end
    #@   return data.values.params[key]
    #@ end

    #@ def merge_labels(fixed_values):
    #@   labels = {}
    #@   if hasattr(data.values.workload.metadata, "labels"):
    #@     labels.update(data.values.workload.metadata.labels)
    #@   end
    #@   labels.update(fixed_values)
    #@   return labels
    #@ end

    #@ def merge_annotations(fixed_values):
    #@   annotations = {}
    #@   if hasattr(data.values.workload.metadata, "annotations"):
    #@     # DEPRECATED: remove in a future release
    #@     annotations.update(data.values.workload.metadata.annotations)
    #@   end
    #@   if type(param("annotations")) == "dict" or type(param("annotations")) == "struct":
    #@     annotations.update(param("annotations"))
    #@   end
    #@   annotations.update(fixed_values)
    #@   return annotations
    #@ end

    #@ def claims():
    #@ claims_extension = get_claims_extension()
    #@ workload = struct.encode(yaml.decode(data.values.configs.app_def.config["delivery.yml"]))
    #@ for s in data.values.workload.spec.serviceClaims:
    #@ if claims_extension == None or claims_extension.get(s.name) == None:
    ---
    apiVersion: servicebinding.io/v1alpha3
    kind: ServiceBinding
    metadata:
      name: #@ data.values.workload.metadata.name + '-' + s.name
      annotations: #@ merge_annotations({})
      labels: #@ merge_labels({ "app.kubernetes.io/component": "run", "carto.run/workload-name": data.values.workload.metadata.name })
    spec:
      name: #@ s.name
      service: #@ s.ref
      workload:
        apiVersion: #@ workload.apiVersion
        kind: #@ workload.kind
        name: #@ workload.metadata.name
    #@ else:
    ---
    apiVersion: services.apps.tanzu.vmware.com/v1alpha1
    kind: ResourceClaim
    metadata:
      name: #@ data.values.workload.metadata.name + '-' + s.name
      annotations: #@ merge_annotations({})
      labels: #@ merge_labels({ "app.kubernetes.io/component": "run", "carto.run/workload-name": data.values.workload.metadata.name })
    spec:
      ref: #@ merge_claims_extension(s, claims_extension)
    ---
    apiVersion: servicebinding.io/v1alpha3
    kind: ServiceBinding
    metadata:
      name: #@ data.values.workload.metadata.name + '-' + s.name
      annotations: #@ merge_annotations({})
      labels: #@ merge_labels({ "app.kubernetes.io/component": "run", "carto.run/workload-name": data.values.workload.metadata.name })
    spec:
      name: #@ s.name
      service:
        apiVersion: services.apps.tanzu.vmware.com/v1alpha1
        kind: ResourceClaim
        name: #@ data.values.workload.metadata.name + '-' + s.name
      workload:
        apiVersion: #@ workload.apiVersion
        kind: #@ workload.kind
        name: #@ workload.metadata.name
    #@ end
    #@ end
    #@ end

    #@ def add_claims():
    #@ if hasattr(data.values.workload.spec, "serviceClaims") and len(data.values.workload.spec.serviceClaims):
    #@   new_data = struct.decode(data.values.configs.app_def.config)
    #@   new_data.update({"serviceclaims.yml":yaml.encode(claims())})
    #@   return new_data
    #@ else:
    #@   return struct.decode(data.values.configs.app_def.config)
    #@ end
    #@ end

    ---
    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: #@ data.values.workload.metadata.name + "-claims"
      labels: #@ merge_labels({ "app.kubernetes.io/component": "config" })
    data: #@ add_claims()
```

### <a id="rbac"></a>Add RBAC Permissions

Because the `tcp` workload deployment will create different resources, you will need to extend the `deliverable` ClusterRole. Use `kubectl apply -f $FILE` to apply the following additional role to the cluster, which will be added to the permissions for the `deliverable` role:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: additional-k8s-deliverable
  labels:
    apps.tanzu.vmware.com/aggregate-to-deliverable: "true"
rules:
- apiGroups: [""]
  resources: ["services"]
  verbs: ["get", "list", "watch", "create", "patch", "update", "delete", "deletecollection"]
- apiGroups: ["apps"]
  resources: ["deployments"]
  verbs: ["get", "list", "watch", "create", "patch", "update", "delete", "deletecollection"]
```

### <a id="supplychain"></a>Define the ClusterSupplyChain

When defining the ClusterSupplyChain, you will need to substitute in various values from your `tap-values` file, particularly the `registry` values (marked as `$REGISTRY_SERVER` and `$REGISTRY_REPO`):

```yaml
apiVersion: carto.run/v1alpha1
kind: ClusterSupplyChain
metadata:
  name: tcp
spec:
  params:
  - default: main
    name: gitops_branch
  - default: supplychain
    name: gitops_user_name
  - default: supplychain
    name: gitops_user_email
  - default: supplychain@cluster.local
    name: gitops_commit_message
  - default: git-ssh
    name: gitops_ssh_secret
  - default:
    - containerPort: 8080
      port: 8080
      name: http
    name: ports
  resources:
  - name: source-provider
    params:
    - name: serviceAccount
      value: default
    - name: gitImplementation
      value: go-git
    templateRef:
      kind: ClusterSourceTemplate
      name: source-template
  - name: deliverable
    params:
    - name: registry
      value:
        repository: $REGISTRY_REPO
        server: $REGISTRY_SERVER
    templateRef:
      kind: ClusterTemplate
      name: deliverable-template
  - name: image-builder
    params:
    - name: serviceAccount
      value: default
    - name: clusterBuilder
      value: default
    - name: registry
      value:
        repository: $REGISTRY_REPO
        server: $REGISTRY_SERVER
    sources:
    - name: source
      resource: source-provider
    templateRef:
      kind: ClusterImageTemplate
      name: kpack-template
  - images:
    - name: image
      resource: image-builder
    name: config-provider
    params:
    - name: serviceAccount
      value: default
    templateRef:
      kind: ClusterConfigTemplate
      name: convention-template
  - configs:
    - name: config
      resource: config-provider
    name: app-config
    templateRef:
      kind: ClusterConfigTemplate
      name: deployment-and-service-template
  - configs:
    - name: app_def
      resource: app-config
    name: apply-bindings
    templateRef:
      kind: ClusterConfigTemplate
      name: apply-bindings
  - configs:
    - name: config
      resource: apply-bindings
    name: config-writer
    params:
    - name: serviceAccount
      value: default
    - name: registry
      value:
        repository: $REGISTRY_REPO
        server: $REGISTRY_SERVER
    templateRef:
      kind: ClusterTemplate
      name: config-writer-template
  selector:
    apps.tanzu.vmware.com/workload-type: tcp
```

After substituting the `$REGISTRY_SERVER` and `$REGISTRY_REPO` values, apply the resulting file to the cluster with `kubectl apply -f $FILE`

## <a id="using"></a>Using the `tcp` Workload Type

Revisiting the [getting started example of using service toolkit claims](../getting-started.md#stk-bind), the `spring-sensors-consumer-web` workload is a good match for the `tcp` workload type, because it runs continuously to extract information from a RabbitMQ queue and stores the resulting data locally in-memory and presents it via a web UI.

If you have followed the services toolkit example, you can update the `spring-sensors-consumer-web` to use the `tcp` supply chain by changing the workload type:

```sh
tanzu apps workload update spring-sensors-consumer-web --type tcp
```

This will show the change in the workload label, and prompt you to accept the change. Once the workload completes the new deployment, you'll notice a few differences:

* The workload no longer advertises a URL. It's available within the cluster as `spring-sensors-consumer-web` within the namespace, but you need to use `kubectl port-forward service/spring-sensors-consumer-web 8080` to access the web service on port 8080.

  You can also set up a [Kubernetes Ingress rule](https://kubernetes.io/docs/concepts/services-networking/ingress/) to direct traffic from outside the cluster to the workload. Using an Ingress rule, you can specify that specific hostnames or paths should be routed to the application.

* The workload no longer autoscales based on request traffic. For the `spring-sensors-consumer-web` workload, this means that it will never spawn a second instance which consumes part of the request queue. It also will not scale down to zero instances.

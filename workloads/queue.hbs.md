# Using queue workloads (Beta)

This topic describes how to create and install a supply chain for the `queue` workload type.

## <a id="overview"></a>Overview

The `queue` workload type allows you to deploy applications that run continuously
without network input on Tanzu Application Platform.
Using an application workload specification, you can build and deploy application
source code to a manually-scaled Kubernetes deployment with no network exposure.

The `queue` workload is a good match for applications that manage their own work
by reading from a queue or a background scheduled time source, and don't expose
any network interfaces.

Applications using the `queue` workload type have the following features:

* Do not natively autoscale, but can be used with the Kubernetes Horizontal Pod Autoscaler
* Do not expose any network services
* Use health checks if defined by a convention
* Use a rolling update pattern by default

When creating a workload with `tanzu apps workload create`, you can use the
`--type=queue` argument to select the `queue` workload type.
For more information, see [Use the `queue` Workload Type](#using) later in this topic.
You can also use the `apps.tanzu.vmware.com/workload-type:queue` annotation in the
YAML workload description to support this deployment type.

> **Important:** Beta features have been tested for functionality, but not performance.
> Features enter the beta stage so that customers can gain early access, and give
> feedback on the design and behavior.
> Beta features might undergo changes based on this feedback before the end of the beta stage.
> VMware discourages running beta features in production.
> VMware cannot guarantee that you can upgrade any beta feature in the future.

## <a id="prereqs"></a> Prerequisites

Before using `queue` workloads on Tanzu Application Platform, you must:

* Follow all instructions in [Installing Tanzu Application Platform](../install-intro.md).
* Follow all instructions in [Set up developer namespaces to use installed packages](../install-online/set-up-namespaces.hbs.md).

## <a id="create-queue"></a> Create a `queue` SupplyChain

This section describes how to create a supply chain for the `queue` workload type.

### <a id="templates"></a> Create supply chain templates

The `queue` supply chain replaces the `config-template` from the existing
Out of the Box (OOTB) supply chain with two new templates:

* The `deployment-template` defines Kubernetes Deployment and Service objects that
represent the workload, instead of a Knative Service.

* The `apply-bindings` template extends the `deployment-and-service-template` with
requested ServiceBindings and ResourceClaims.

To create supply chain templates:

1. Create a file using the following YAML manifests:

    ```yaml
    apiVersion: carto.run/v1alpha1
    kind: ClusterConfigTemplate
    metadata:
      name: deployment-template
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

        ---
        apiVersion: v1
        kind: ConfigMap
        metadata:
          name: #@ data.values.workload.metadata.name + "-base"
          labels: #@ merge_labels({ "app.kubernetes.io/component": "config" })
        data:
          delivery.yml: #@ yaml.encode(delivery())
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

1. Apply the YAML file by running the command:

    ```console
    kubectl apply -f FILENAME
    ```

    Where `FILENAME` is the name of the file you created in the previous step.

### <a id="rbac"></a> Add RBAC permissions

Because the `queue` workload deployment creates different resources, you must
extend the `deliverable` ClusterRole.

To add the additional role to the cluster:

1. Create a file using the following YAML:

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

1. Apply the YAML file by running the command:

    ```console
    kubectl apply -f FILENAME
    ```

    Where `FILENAME` is the name of the file you created in the previous step.

### <a id="supplychain"></a> Define the ClusterSupplyChain

To define the ClusterSupplyChain:

1. Create a file using the following YAML and substitute in your `registry` values
from your `tap-values.yaml` file:

    ```yaml
    apiVersion: carto.run/v1alpha1
    kind: ClusterSupplyChain
    metadata:
      name: queue
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
      - default: DEFAULT-GIT-SECRET
        name: gitops_ssh_secret
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
            repository: REGISTRY-REPO
            server: REGISTRY-SERVER
            # Add the following key if you have set ca_cert_data in tap-values.yaml
            - name: ca_cert_data
              value: CERT-AS-STRING
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
            repository: REGISTRY-REPO
            server: REGISTRY-SERVER
            # Add the following key if you have set ca_cert_data in tap-values.yaml
            - name: ca_cert_data
              value: CERT-AS-STRING
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
          name: deployment-template
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
            repository: REGISTRY-REPO
            server: REGISTRY-SERVER
            # Add the following key if you have set ca_cert_data in tap-values.yaml
            - name: ca_cert_data
              value: CERT-AS-STRING
        templateRef:
          kind: ClusterTemplate
          name: config-writer-template
      selector:
        apps.tanzu.vmware.com/workload-type: queue
    ```

    Where:

    * `DEFAULT-GIT-SECRET` is the value from `gitops.ssh_secret` in your
      `tap-values.yaml` file, or `""` to deactivate SSH authentication.
    * `REGISTRY-SERVER` is the registry server from your `tap-values.yaml` file.
    * `REGISTRY-REPO` is the registry repository from your `tap-values.yaml` file.
    * `CERT-AS-STRING` is the value you added to `tap-values.yaml` file.
      Only add this if you set `ca_cert_data` in your `tap-values.yaml` file.

1. Apply the YAML file by running the command:

    ```console
    kubectl apply -f FILENAME
    ```

    Where `FILENAME` is the name of the file you created in the previous step.


## <a id="using"></a> Use the `queue` workload type

The `spring-sensors-producer` workload in the getting started example
[using Service Toolkit claims](../getting-started/consume-services.md#stk-bind)
is a good match for the `queue` workload type.
This is because it runs continuously without a UI to report sensor information to a RabbitMQ topic.

If you have followed the Services Toolkit example, you can update the `spring-sensors-producer`
to use the `queue` supply chain by changing the workload type by running:

```console
tanzu apps workload update spring-sensors-producer --type=queue
```

This shows a diff in the workload label, and prompts you to accept the change.
After the workload completes the new deployment, you'll notice a few differences:

* The workload no longer has a URL. Because the workload does not present a web UI,
this more closely matches the original application intent.

* The workload no longer autoscales based on request traffic. For the `spring-sensors-producer`
workload, this means that it does not scale down to zero instances when there is no request traffic.

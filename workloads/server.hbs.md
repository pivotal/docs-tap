# Use server workloads

This topic tells you how to use the `server` workload type in Tanzu Application Platform
(commonly known as TAP).

## <a id="overview"></a> Overview

The `server` workload type allows you to deploy traditional network applications on
Tanzu Application Platform.

Using an application workload specification, you can build and deploy application source code to a
manually-scaled Kubernetes deployment which exposes an in-cluster Service endpoint. If required, you
can use environment-specific LoadBalancer Services or Ingress resources to expose these applications
outside the cluster.

The `server` workload is suitable for traditional applications, including HTTP applications,
which have the following characteristics:

- Store state locally
- Run background tasks outside of requests
- Provide multiple network ports or non-HTTP protocols
- Are not a good match for the `web` workload type

An application using the `server` workload type has the following features:

- Does not natively autoscale, but you can use these applications with the Kubernetes Horizontal Pod
  Autoscaler.
- By default, is exposed only within the cluster using a `ClusterIP` service.
- Uses health checks if defined by a convention.
- Uses a rolling update pattern by default.

When creating a workload with the `tanzu apps workload create` command, you can use the
`--type=server` argument to select the `server` workload type.
For more information, see [Use the server Workload Type](#using) later in this topic.
You can also use the `apps.tanzu.vmware.com/workload-type:server` annotation in the
YAML workload description to support this deployment type.

## <a id="using"></a> Use the `server` workload type

The `spring-sensors-consumer-web` workload in
[Bind an application workload to the service instance](../getting-started/consume-services.hbs.md#stk-bind)
in the Get started guide is a good match for the `server` workload type.

This is because it runs continuously to extract information from a RabbitMQ queue, and stores the
resulting data locally in memory and presents it through a web UI.

In the Services Toolkit example in
[Bind an application workload to the service instance](../getting-started/consume-services.hbs.md#stk-bind),
you can update the `spring-sensors-consumer-web` workload to use the `server` supply chain by
changing the workload:

```console
tanzu apps workload apply spring-sensors-consumer-web --type=server
```

This shows the change in the workload label and prompts you to accept the change.
After the workload finishes the new deployment, there are a few differences:

- The workload no longer exposes a URL. It's available within the cluster as
  `spring-sensors-consumer-web` within the namespace, but you must use
  `kubectl port-forward service/spring-sensors-consumer-web 8080` to access the web service on port
  8080.

  You can set up a Kubernetes Ingress rule to direct traffic from outside the cluster to the workload.
  Use an Ingress rule to specify that specific host names or paths must be routed to the application.
  For more information about Ingress rules, see the
  [Kubernetes documentation](https://kubernetes.io/docs/concepts/services-networking/ingress/)

- The workload no longer autoscales based on request traffic. For the `spring-sensors-consumer-web`
  workload, this means that it never spawns a second instance that consumes part of the request
  queue. Also, it does not scale down to zero instances.

## <a id="params"></a> `server`-specific workload parameters

In addition to the common supply chain parameters, `server` workloads can expose one or more network
ports from the application to the Kubernetes cluster by using the `ports` parameter.
This parameter is a list of port objects, similar to a Kubernetes service specification.

If you do not configure the `ports` parameter, the applied container conventions in the cluster
establishes the set of exposed ports.

The following configuration exposes two ports on the Kubernetes cluster under the `my-app` host name:

```yaml
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  name: my-app
  labels:
    apps.tanzu.vmware.com/workload-type: server
spec:
  params:
  - name: ports
    value:
    - containerPort: 2025
      name: smtp
      port: 25
    - port: 8080
  ...
```

This snippet configures:

- One service on port 25, which is redirected to port 2025 on the application
- One service on port 8080, which is routed to port 8080 on the application

You can set the `ports` parameter from the `tanzu apps workload create` command as
`--param-yaml 'ports=[{"port": 8080}]'`.

The following values are valid within the `ports` argument:

| Field           | Value                                                                                  |
|-----------------|----------------------------------------------------------------------------------------|
| `port`          | The port on which the application is exposed to the rest of the cluster                |
| `containerPort` | The port on which the application listens for requests. Defaults to `port` if not set. |
| `name`          | A human-readable name for the port. Defaults to `port` if not set.                     |

## <a id="exposing-server-workloads"></a> Expose `server` workloads outside the cluster

This section tells you how to expose `server` workloads outside the cluster.

### <a id="manual-config"></a> Manual configuration for HTTP workloads

Expose HTTP `server` workloads by creating an Ingress resource and using cert-manager to provision
TLS-signed certificates.

1. Use the `spring-sensors-consumer-web` workload as an example from
   [Bind an application workload to the service instance](../getting-started/consume-services.hbs.md#stk-bind).
   Create the following `Ingress`:

   ```console
   apiVersion: networking.k8s.io/v1
   kind: Ingress
   metadata:
     name: spring-sensors-consumer-web
     namespace: DEVELOPER-NAMESPACE
     annotations:
       cert-manager.io/cluster-issuer: tap-ingress-selfsigned
       ingress.kubernetes.io/force-ssl-redirect: "true"
       kubernetes.io/ingress.class: contour
       kubernetes.io/tls-acme: "true"
   spec:
     tls:
       - secretName: spring-sensors-consumer-web
         hosts:
           - "spring-sensors-consumer-web.INGRESS-DOMAIN"
     rules:
       - host: "spring-sensors-consumer-web.INGRESS-DOMAIN"
         http:
           paths:
             - pathType: Prefix
               path: /
               backend:
                 service:
                   name: spring-sensors-consumer-web
                   port:
                     number: 8080
   ```

   - Replace `DEVELOPER-NAMESPACE` with your developer namespace
   - Replace `INGRESS-DOMAIN` with the domain name defined in `tap-values.yaml` during the installation
   - Set the annotation `cert-manager.io/cluster-issuer` to the `shared.ingress_issuer` value
     configured during installation or leave it as `tap-ingress-selfsigned` to use the default one
   - Update the port exposed by your `Service` resource, in the previous snippet it is set to `8080`

1. Access the `server` workload with https:

   ```console
   curl -k https://spring-sensors-consumer-web.INGRESS-DOMAIN
   ```

### <a id="expose-server-workloads"></a> Define a workload type that exposes `server` workloads outside the cluster

Tanzu Application Platform allows you to create new workload types. You start by adding an `Ingress`
resource to the `server-template` `ClusterConfigTemplate` when this new type of workload is created.

1. Delete the `Ingress` resource previously created.

1. Install the `yq` CLI on your local machine.

1. Save the existing `server-template` in a local file by running:

   ```console
   kubectl get ClusterConfigTemplate server-template -o yaml > secure-server-template.yaml
   ```

1. Extract the `.spec.ytt` field from this file and create another file by running:

   ```console
   yq eval '.spec.ytt' secure-server-template.yaml > spec-ytt.yaml
   ```

1. In the next step, you add the `Ingress` resource snippet to `spec-ytt.yaml`. This step provides a
   sample `Ingress` resource snippet. Make the following edits before adding the `Ingress` resource
   snippet to `spec-ytt.yaml`:

   - Replace `INGRESS-DOMAIN` with the Ingress domain you set during the installation.
   - Set the annotation `cert-manager.io/cluster-issuer` to the `shared.ingress_issuer` value
     configured during installation or leave it as `tap-ingress-selfsigned` to use the default one.
   - This configuration is based on your workload service running on port `8080`.

    The `Ingress` resource snippet looks like this:

    ```yaml
    ---
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: #@ data.values.workload.metadata.name
      annotations:
        cert-manager.io/cluster-issuer: tap-ingress-selfsigned
        ingress.kubernetes.io/force-ssl-redirect: "true"
        kubernetes.io/ingress.class: contour
        kubernetes.io/tls-acme: "true"
        kapp.k14s.io/change-rule: "upsert after upserting Services"
      labels: #@ merge_labels({ "app.kubernetes.io/component": "run", "carto.run/workload-name": data.values.workload.metadata.name })
    spec:
      tls:
        - secretName: #@ data.values.workload.metadata.name
          hosts:
            - #@ data.values.workload.metadata.name + ".INGRESS-DOMAIN"
      rules:
        - host: #@ data.values.workload.metadata.name + ".INGRESS-DOMAIN"
          http:
            paths:
              - pathType: Prefix
                path: /
                backend:
                  service:
                    name: #@ data.values.workload.metadata.name
                    port:
                      number: 8080
    ```

1. Add the `Ingress` resource snippet to the `spec-ytt.yaml` file and save. Look for the `Service`
   resource, and insert the snippet before the last `#@ end`. For example:

    ```yaml

    # THE TOP OF THE FILE IS NOT SHOWN

    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: #@ data.values.workload.metadata.name
      labels: #@ merge_labels({ "app.kubernetes.io/component": "run", "carto.run/workload-name": data.values.workload.metadata.name })
    spec:
      selector: #@ data.values.config.metadata.labels
      ports:
      #@ hasattr(data.values.params, "ports") and len(data.values.params.ports) or assert.fail("one or more ports param must be provided.")
      #@ declared_ports = {}
      #@ if "ports" in data.values.params:
      #@   declared_ports = data.values.params.ports
      #@ else:
      #@   declared_ports = struct.encode([{ "containerPort": 8080, "port": 8080, "name":   "http"}])
      #@ end
      #@ for p in merge_ports(declared_ports, data.values.config.spec.containers):
      - #@ p
      #@ end

    # NEW INGRESS RESOURCE
    ---
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: #@ data.values.workload.metadata.name
      annotations:
        cert-manager.io/cluster-issuer: tap-ingress-selfsigned
        ingress.kubernetes.io/force-ssl-redirect: "true"
        kubernetes.io/ingress.class: contour
        kubernetes.io/tls-acme: "true"
        kapp.k14s.io/change-rule: "upsert after upserting Services"
      labels: #@ merge_labels({ "app.kubernetes.io/component": "run", "carto.run/workload-name": data.values.workload.metadata.name })
    spec:
      tls:
        - secretName: #@ data.values.workload.metadata.name
          hosts:
            - #@ data.values.workload.metadata.name + ".INGRESS-DOMAIN"
      rules:
        - host: #@ data.values.workload.metadata.name + ".INGRESS-DOMAIN"
          http:
            paths:
              - pathType: Prefix
                path: /
                backend:
                  service:
                    name: #@ data.values.workload.metadata.name
                    port:
                      number: 8080
    # END NEW INGRESS RESOURCE

    #@ end

    ---
    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: #@ data.values.workload.metadata.name + "-server"
      labels: #@ merge_labels({ "app.kubernetes.io/component": "config" })
    data:
      delivery.yml: #@ yaml.encode(delivery())
    ```

1. Add the snippet to the `.spec.ytt` property in `secure-server-template.yaml`:

   ```console
   SPEC_YTT=$(cat spec-ytt.yaml) yq eval -i '.spec.ytt |= strenv(SPEC_YTT)' secure-server-template.yaml
   ```

1. Change the name of the `ClusterConfigTemplate` to `secure-server-template` by running:

   ```console
   yq eval -i '.metadata.name = "secure-server-template"' secure-server-template.yaml
   ```

1. Create the new `ClusterConfigTemplate` by running:

   ```console
   kubectl apply -f secure-server-template.yaml
   ```

1. Verify the new `ClusterConfigTemplate` is in the cluster by running:

   ```console
   kubectl get ClusterConfigTemplate
   ```

   Expected output:

   ```console
   kubectl get ClusterConfigTemplate
   NAME                     AGE
   api-descriptors          82m
   config-template          82m
   convention-template      82m
   secure-server-template   22s
   server-template          82m
   service-bindings         82m
   worker-template          82m
   ```

1. Add the new workload type to the `tap-values.yaml`. The new workload type is named `secure-server`
   and the `cluster_config_template_name` is `secure-server-template`.

    ```yaml
    ootb_supply_chain_basic:
      supported_workloads:
        - type: web
          cluster_config_template_name: config-template
        - type: server
          cluster_config_template_name: server-template
        - type: worker
          cluster_config_template_name: worker-template
        - type: secure-server
          cluster_config_template_name: secure-server-template
    ```

1. Update your Tanzu Application Platform installation as follows:

   ```console
   tanzu package installed update tap -p tap.tanzu.vmware.com --values-file "/path/to/your/config/tap-values.yaml"  -n tap-install
   ```

1. Give privileges to the `deliverable` role to manage `Ingress` resources:

   ```console
   cat <<EOF | kubectl apply -f -
   apiVersion: rbac.authorization.k8s.io/v1
   kind: ClusterRole
   metadata:
     name: deliverable-with-ingress
     labels:
       apps.tanzu.vmware.com/aggregate-to-deliverable: "true"
   rules:
   - apiGroups:
     - networking.k8s.io
     resources:
     - ingresses
     verbs:
     - get
     - list
     - watch
     - create
     - patch
     - update
     - delete
     - deletecollection
   EOF
   ```

1. Update the workload type to `secure-server`:

   > **Note** If you created the `Ingress` resource manually in the previous section, delete it
   > before this.

   ```console
   tanzu apps workload apply spring-sensors-consumer-web --type=secure-server
   ```

1. After the process finishes, you see the resources Deployment, Service, and Ingress by running:

   ```console
   kubectl get ingress,svc,deploy -l carto.run/workload-name=spring-sensors-consumer-web
   ```

   Expected output:

   ```console
   kubectl get ingress,svc,deploy -l carto.run/workload-name=tanzu-java-web-app-js
   NAME                                                    CLASS    HOSTS                                          ADDRESS          PORTS     AGE
   ingress.networking.k8s.io/spring-sensors-consumer-web   <none>   spring-sensors-consumer-web.INGRESS-DOMAIN   34.111.111.111   80, 443   37s

   NAME                                  TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
   service/spring-sensors-consumer-web   ClusterIP   10.32.15.194   <none>        8080/TCP   36m

   NAME                                          READY   UP-TO-DATE   AVAILABLE   AGE
   deployment.apps/spring-sensors-consumer-web   1/1     1            1           37s

   ```

1. Access your `secure-server` workload with HTTPS by running:

   ```console
   curl -k https://spring-sensors-consumer-web.INGRESS-DOMAIN
   ```

# Use server workloads

This topic describes how to use the `server` workload type.

## <a id="overview"></a>Overview

The `server` workload type allows you to deploy traditional network applications on
Tanzu Application Platform.
Using an application workload specification, you can build and deploy application
source code to a manually-scaled Kubernetes deployment which exposes an in-cluster Service endpoint.
If required, you can use environment-specific LoadBalancer Services or Ingress resources to
expose these applications outside the cluster.

The `server` workload is a good match for traditional applications, including HTTP applications,
which have the following implementation:

* Store state locally
* Run background tasks outside of requests
* Provide multiple network ports or non-HTTP protocols
* Are not a good match for the `web` workload type

An application using the `server` workload type has the following features:

* Does not natively autoscale, but you can use these applications with the Kubernetes Horizontal Pod Autoscaler.
* By default, is exposed only within the cluster using a `ClusterIP` service
* Uses health checks if defined by a convention
* Uses a rolling update pattern by default

When creating a workload with `tanzu apps workload create`, you can use the
`--type=server` argument to select the `server` workload type.
For more information, see [Use the `server` Workload Type](#using) later in this topic.
You can also use the `apps.tanzu.vmware.com/workload-type:server` annotation in the
YAML workload description to support this deployment type.

## <a id="using"></a> Use the `server` workload type

The `spring-sensors-consumer-web` workload in the getting started example
[using Service Toolkit claims](../getting-started/consume-services.md#stk-bind)
is a good match for the `server` workload type.
This is because it runs continuously to extract information from a RabbitMQ queue,
and stores the resulting data locally in-memory and presents it through a web UI.

If you have followed the Services Toolkit example, you can update the `spring-sensors-consumer-web`
to use the `server` supply chain by changing the workload type by running:

```console
tanzu apps workload apply spring-sensors-consumer-web --type=server
```

This shows the change in the workload label, and prompts you to accept the change.
After the workload completes the new deployment, there are a few differences:

- The workload no longer advertises a URL. It's available within the cluster as
`spring-sensors-consumer-web` within the namespace, but you must use
`kubectl port-forward service/spring-sensors-consumer-web 8080` to access the web service on port 8080.

    You can also set up a Kubernetes ingress rule to direct traffic from outside the cluster to the workload.
    Using an ingress rule, you can specify that specific host names or paths must be routed to the application.
    For more information about ingress rules, see the [Kubernetes documentation](https://kubernetes.io/docs/concepts/services-networking/ingress/)

- The workload no longer autoscales based on request traffic.
For the `spring-sensors-consumer-web` workload, this means that it never spawns
a second instance that consumes part of the request queue.
Also, it does not scale down to zero instances.

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

- One service on port 25, which is redirected to port 2025 on the application.
- One service on port 8080, which is routed to port 8080 on the application.

You can set the `ports` parameter from the `tanzu apps workload create` command line as `--param-yaml 'ports=[{"port": 8080}]'`.

The following values are valid within the `ports` argument:

| field | value |
|-------|-------|
| `port` | The port on which the application is exposed to the rest of the cluster |
| `containerPort` | The port on which the application listens for requests. Defaults to `port` if not set. |
| `name` | A human-readable name for the port. Defaults to `port` if not set. |


## <a id="params"></a> Securing `server` workloads

### Manual configuration for HTTP workloads
For http `server` workloads you can expose them by creating an Ingress resource and using cert-manager to provision TLS signed certificates. Taking the `spring-sensors-consumer-web`
workload as an example, create the following `Ingress`:

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: spring-sensors-consumer-web
  namespace: <YOUR-DEVELOPER-NAMESPACE>
  annotations:
    cert-manager.io/cluster-issuer: tap-ingress-selfsigned
    ingress.kubernetes.io/force-ssl-redirect: "true"
    kubernetes.io/ingress.class: contour
    kubernetes.io/tls-acme: "true"
spec:
  tls:
    - secretName: spring-sensors-consumer-web
      hosts:
        - "spring-sensors-consumer-web.<INGRESS-DOMAIN>"
  rules:
    - host: "spring-sensors-consumer-web.<INGRESS-DOMAIN>"
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

Replace the `<YOUR-DEVELOPER-NAMESPACE>` with your developer namespace and `<INGRESS-DOMAIN>` with the domain name defined
in `tap-values.yaml` during the installation. Also, set the annotation `cert-manager.io/cluster-issuer` to the `shared.ingress_issuer` value
configured during installation or leave it as `tap-ingress-selfsigned` to use the default one. Make sure to update the port exposed by
your `Service` resource, in the previous snippet it is set to `8080`. 

Your `server` workload can be accessed with https like so:
```console
curl -k https://spring-sensors-consumer-web.<INGRESS-DOMAIN>
```


### Creating a new workload type that will secure _server_ workloads by default

>**Note** Make sure you delete the `Ingress` resource previously created.

TAP allows to create new workload types. Start by taking the existing `server-template` `ClusterConfigTemplate` and modify
it to add an `Ingress` resource when this new type of workload is created.

>**Note** This procedure assumes you have `yq` cli installed in your computer. 

1. Save the existing `server-template` in a local file:
```console
kubectl get ClusterConfigTemplate server-template -oyaml > secure-server-template.yaml
```
2. Extract `.spec.ytt` field from this file and create another file
```console
yq '.spec.ytt' secure-server-template.yaml > spec-ytt.yaml
```
3. Edit `spec-ytt.yaml` to add the `Ingress` resource.
   1. The `Ingress` resource snippet looks like this:
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
        - #@ data.values.workload.metadata.name + ".<INGRESS-DOMAIN>"
  rules:
    - host: #@ data.values.workload.metadata.name + ".<INGRESS-DOMAIN>"
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
  Additional steps:

    - Replace `INGRESS-DOMAIN` to the ingress domain you set during the installation.
    - Set the annotation `cert-manager.io/cluster-issuer` to the `ingress_issuer` set during installation or leave as `tap-ingress-selfsigned` to use the default one.
    - This configuration assumes that your workload service is running on port `8080`
  
  2. Add the above snippet to the `spec-ytt.yaml` file. Look for the `Service` resource, 
     scroll down right before the last `#@ end` and insert it in there. It should look like this: 

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
        - #@ data.values.workload.metadata.name + ".<INGRESS-DOMAIN>"
  rules:
    - host: #@ data.values.workload.metadata.name + ".<INGRESS-DOMAIN>"
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
  3. Save the file `spec-ytt.yaml`.

4. Add the above to the `.spec.ytt` property in `secure-server-template.yaml`

```console
SPEC_YTT=$(cat spec-ytt.yaml) yq -i '.spec.ytt |= strenv(SPEC_YTT)' secure-server-template.yaml
```

5. Change the name of the `ClusterConfigTemplate` to `secure-server-template`
```console
yq -i '.metadata.name = "secure-server-template"' secure-server-template.yaml
```

6. Create the new `ClusterConfigTemplate`
```console
kubectl apply -f secure-server-template.yaml
```

7. Check the new `ClusterConfigTemplate` is in the cluster
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

8. Add the new workload type to the `tap-values.yaml`. The new workload type is named `secure-server` and the `cluster_config_template_name` is `secure-server-template`.
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

9. Update your TAP installation like so:
```console
tanzu package installed update tap -p tap.tanzu.vmware.com --values-file "/path/to/your/config/tap-values.yaml"  -n tap-install
```

10. Give privileges to the `deliverable` role to manage `Ingress` resources:
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

11. Update the workload type to `secure-server`
>**Note** If you created the `Ingress` resource manually in the previous section, make sure to delete it before this.
```console
tanzu apps workload apply spring-sensors-consumer-web --type=secure-server
```

11. Once the process finishes you should see these resources: Deployment, Service and Ingress.
```console
kubectl get ingress,svc,deploy -l carto.run/workload-name=spring-sensors-consumer-web
```
Expected output:
```console
kubectl get ingress,svc,deploy -l carto.run/workload-name=tanzu-java-web-app-js 
NAME                                                    CLASS    HOSTS                                          ADDRESS          PORTS     AGE
ingress.networking.k8s.io/spring-sensors-consumer-web   <none>   spring-sensors-consumer-web.<INGRESS-DOMAIN>   34.111.111.111   80, 443   37s

NAME                                  TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
service/spring-sensors-consumer-web   ClusterIP   10.32.15.194   <none>        8080/TCP   36m

NAME                                          READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/spring-sensors-consumer-web   1/1     1            1           37s

```

Your `secure-server` workload can be accessed with https like so:
```console
curl -k https://spring-sensors-consumer-web.<INGRESS-DOMAIN>
```

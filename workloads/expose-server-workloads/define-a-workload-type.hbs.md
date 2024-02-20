# Define a workload type that exposes server workloads outside the cluster

Tanzu Application Platform (commonly known as TAP) allows you to create new workload types. You
start by adding an `Ingress` resource to the `server-template` `ClusterConfigTemplate` when this new
type of workload is created.

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
   tanzu package installed update tap -p tap.tanzu.vmware.com --values-file \
   "/path/to/your/config/tap-values.yaml"  -n tap-install
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

1. After the process finishes, verify that the resources Deployment, Service, and Ingress appear by
   running:

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
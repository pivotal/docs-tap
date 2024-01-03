# Using external observability tools

This topic provides information about how to generate metrics for your applications in order to enable observability
with external tools.

## <a id="prometheus"></a> Prometheus

[Prometheus](https://prometheus.io/) is an open-source monitoring tool that is supported by client libraries for a wide 
range of programming languages and frameworks. 

Using those client libraries in your applications, you can easily create metrics in a 
standardized format on an HTTP endpoint that can be consumed (scraped) by Prometheus and other observability tools. 

There is a convention to enable auto discovery of pods in Kubernetes that expose Prometheus metrics. 
It comprises several annotations on the pods that tell Prometheus whether to look for metrics or not and where the 
metrics endpoint is.

The pod annotations would look like this for a Spring Boot workload:

```yaml
annotations:
  prometheus.io/scrape: 'true'
  prometheus.io/path: '/actuator/prometheus'
  prometheus.io/port: '8081'
```

We will explain the setup of the following observability tools that use those annotations:

* [Install Prometheus](#install-prometheus)
* [Install Datadog](#datadog)

## <a id="install-prometheus"></a> Install Prometheus

There are multiple ways to install Prometheus on your cluster:

* [Prometheus Operator](#prometheus-operator)
* [kube-prometheus-stack Helm chart](#kube-prometheus-stack)
* [Prometheus Helm chart](#helm-chart)

### <a id="prometheus-operator"></a> Install Prometheus Operator

The Prometheus Operator offers a simplified way to use custom resources to deploy and configure Prometheus, Alertmanager and
related monitoring components.

Install the Prometheus Operator bundle:

```console
LATEST=$(curl -s https://api.github.com/repos/prometheus-operator/prometheus-operator/releases/latest | jq -cr .tag_name)
curl -sL https://github.com/prometheus-operator/prometheus-operator/releases/download/${LATEST}/bundle.yaml | kubectl create -f -
```

For RBAC based environments you have to create the RBAC rules for the Prometheus service account: 

```console
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: prometheus
EOF
```
```console
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: prometheus
rules:
- apiGroups: [""]
  resources:
  - nodes
  - nodes/metrics
  - services
  - endpoints
  - pods
  verbs: ["get", "list", "watch"]
- apiGroups: [""]
  resources:
  - configmaps
  verbs: ["get"]
- apiGroups:
  - networking.k8s.io
  resources:
  - ingresses
  verbs: ["get", "list", "watch"]
- nonResourceURLs: ["/metrics"]
  verbs: ["get"]
EOF
```
```console
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: prometheus
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: prometheus
subjects:
- kind: ServiceAccount
  name: prometheus
  namespace: default
EOF
```

Next, we have to create a configuration for a Prometheus scraping job that will monitor all pods that have the special 
Prometheus annotations.

> The prometheus operator does not support annotation-based discovery of services out-of-the-box, using the PodMonitor 
> or ServiceMonitor CRD in its place as they provide far more configuration options. 
> 
> That's why we configure a custom scrape job configuration for the annotations to work.

Create a file `prometheus-scrape-config.yaml` with the following content:

```yaml
# Example scrape config for pods
#
# The relabeling allows the actual pod scrape endpoint to be configured via the
# following annotations:
#
# * `prometheus.io/scrape`: Only scrape pods that have a value of `true`,
# except if `prometheus.io/scrape-slow` is set to `true` as well.
# * `prometheus.io/scheme`: If the metrics endpoint is secured then you will need
# to set this to `https` & most likely set the `tls_config` of the scrape config.
# * `prometheus.io/path`: If the metrics path is not `/metrics` override this.
# * `prometheus.io/port`: Scrape the pod on the indicated port instead of the default of `9102`.
- job_name: 'kubernetes-pods'
  honor_labels: true

  kubernetes_sd_configs:
    - role: pod

  relabel_configs:
    - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
      action: keep
      regex: true
    - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape_slow]
      action: drop
      regex: true
    - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scheme]
      action: replace
      regex: (https?)
      target_label: __scheme__
    - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
      action: replace
      target_label: __metrics_path__
      regex: (.+)
    - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_port, __meta_kubernetes_pod_ip]
      action: replace
      regex: (\d+);(([A-Fa-f0-9]{1,4}::?){1,7}[A-Fa-f0-9]{1,4})
      replacement: '[$2]:$1'
      target_label: __address__
    - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_port, __meta_kubernetes_pod_ip]
      action: replace
      regex: (\d+);((([0-9]+?)(\.|$)){4})
      replacement: $2:$1
      target_label: __address__
    - action: labelmap
      regex: __meta_kubernetes_pod_annotation_prometheus_io_param_(.+)
      replacement: __param_$1
    - action: labelmap
      regex: __meta_kubernetes_pod_label_(.+)
    - source_labels: [__meta_kubernetes_namespace]
      action: replace
      target_label: namespace
    - source_labels: [__meta_kubernetes_pod_name]
      action: replace
      target_label: pod
    - source_labels: [__meta_kubernetes_pod_phase]
      regex: Pending|Succeeded|Failed|Completed
      action: drop
    - source_labels: [__meta_kubernetes_pod_node_name]
      action: replace
      target_label: node
```

Now create a secret from that file:

```console
kubectl create secret generic additional-scrape-configs --from-file=prometheus-scrape-config.yaml 
```

Finally, we create a Prometheus resource that uses this secret.

Prometheus Operator will pick up the configuration and create a scrape job from it that is run regularly from the
created Prometheus instance.

```console
cat <<EOF | kubectl apply -f -
apiVersion: monitoring.coreos.com/v1
kind: Prometheus
metadata:
  name: prometheus
spec:
  serviceAccountName: prometheus
  podMonitorSelector: {}
  additionalScrapeConfigs:
    name: additional-scrape-configs
    key: prometheus-scrape-config.yaml
  resources:
    requests:
      memory: 400Mi
  enableAdminAPI: false
EOF
```

If you want to access the Prometheus web interface, you have to expose the port `9090` of the Prometheus server pod
outside the cluster using a Kubernetes service or forward the port to your machine using `kubectl`.

For further information about Prometheus Operator refer to the [Prometheus Operator README](https://github.com/prometheus-operator/prometheus-operator/blob/main/README.md).

#### <a id="troubleshooting"></a> Troubleshooting

**Where can I see the scrape config that has been picked up by Prometheus?**

```console
kubectl get secret prometheus-prometheus -ojson | jq -r '.data["prometheus.yaml.gz"]' | base64 -d | gunzip
```

### <a id="kube-prometheus-stack"></a> Install kube-prometheus-stack Helm chart

This is a Helm chart by the Prometheus community which sets up a complete cluster monitoring stack including Prometheus 
Operator, high availability, Node Exporter, Grafana dashboards and more.

To install, add Helm repository:

```console
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

As there is no pre-defined scrape job configuration, you have to create the configuration secret from the file 
`prometheus-scrape-config.yaml` first (like described in [Install Prometheus Operator](#prometheus-operator)) 
and then use it as a configuration on the Helm install command.

Finally, install kube-prometheus-stack:

```console
helm upgrade kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --set prometheus.prometheusSpec.additionalScrapeConfigsSecret.name=additional-scrape-configs \
  --set prometheus.prometheusSpec.additionalScrapeConfigsSecret.key=prometheus-scrape-config.yaml \
  --set prometheus.prometheusSpec.additionalScrapeConfigsSecret.enabled=true
```

Also refer to [kube-prometheus-stack README](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
for further information.

#### <a id="troubleshooting"></a> Troubleshooting

**Where can I see the scrape config that has been picked up by Prometheus?**

```console
kubectl get secret prometheus-kube-prometheus-stack-prometheus -ojson | jq -r '.data["prometheus.yaml.gz"]' | base64 -d | gunzip
```

### <a id="helm-chart"></a> Install Prometheus Helm chart

This is a Helm chart by the Prometheus community that installs Prometheus on your Kubernetes cluster, including
Alert Manager, kube-state-metrics, Node Exporter and Push Gateway.

To install, add Helm repository:

```console
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

Then, install Prometheus:

```console
helm install prometheus prometheus-community/prometheus
```

The Helm chart automatically installs scraping job configuration for pods and services with the Prometheus scraping
annotations and also for metrics about the Kubernetes cluster. 

It also installs the Alert Manager.

**Advantage**: A lot of scrape job configurations are already pre-configured, including for services and pods with the 
Prometheus annotations.

Also refer to [Prometheus Helm chart README](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus).

## <a id="datadog"></a> Install Datadog

If you are using Datadog you can also use it to scrape the Prometheus endpoints without having to install Prometheus
itself. You can use the **Datadog Agent** to forward the metrics to the Datadog servers.

First, install the Datadog Agent with HELM:

```console
helm repo add datadog https://helm.datadoghq.com
helm install datadog-operator datadog/datadog-operator
```

Next, generate anew API key in Datadog for the Agent that needs to push metrics to Datadog.
This is done in the Datadog UI under `Profile/Organization Settings/API Keys`.

Now, create a secret for Datadog API key:

```console
kubectl create secret generic datadog-secret --from-literal api-key=<api-key>
```

Finally, install Datadog Agent (replace `site` value with your Datadog host name):

```console
cat <<EOF | kubectl apply -f -
apiVersion: datadoghq.com/v2alpha1
kind: DatadogAgent
metadata:
  name: datadog
spec:
  global:
    clusterName: shepherd-tap
    site: datadoghq.eu
    credentials:
      apiSecret:
        secretName: datadog-secret
        keyName: api-key
  features:
    prometheusScrape: 
      enabled: true
      enableServiceEndpoints: true
EOF
```

Datadog is able to automatically collect Prometheus metrics from pods when they are annotated with the default
Prometheus annotations as described above.

## <a id="enable-spring-boot-workloads"></a> Enable Spring Boot workloads

In order to enable Spring Boot workloads to create Prometheus metrics you have to add the following dependencies to your
`pom.xml` (if using Maven):

```xml
<dependencies>
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-actuator</artifactId>
    </dependency>
    <dependency>
      <groupId>io.micrometer</groupId>
      <artifactId>micrometer-registry-prometheus</artifactId>
      <scope>runtime</scope>
    </dependency>
</dependencies>
```

This will create default metrics for the JVM, HTTP traffic and more. 

When Spring Boot workloads are deployed on TAP,
Spring Boot Conventions will make sure the actuator endpoints are exposed and with them also the Prometheus metrics
endpoint. 

To tell Prometheus where it can find this endpoint on a pod you need to add the annotations to your `workload.yaml` 
according to your configuration and deploy the changes:

```yaml
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  name: spring-petclinic
  annotations:
    prometheus.io/scrape: 'true'
    prometheus.io/path: '/actuator/prometheus'
    prometheus.io/port: '8081'
    # ...
```

For further information about the Spring Boot Prometheus integration, refer to the 
[Spring Boot Reference Documentation](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#actuator.metrics.export.prometheus).

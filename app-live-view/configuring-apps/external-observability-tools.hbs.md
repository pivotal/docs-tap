# Using external observability tools

This topic provides information about how to generate metrics for your applications in order to enable observability
with external tools.

## <a id="prometheus-metrics"></a> Prometheus metrics

[Prometheus](https://prometheus.io/) is an open-source monitoring tool that defines a simple text-based metrics format that 
is supported by client libraries for a wide range of programming languages and frameworks. 

By integrating these client libraries into your applications, you can effortlessly generate metrics in the Prometheus format. 
These metrics are accessible via an HTTP endpoint, enabling Prometheus and other observability tools to conveniently 
consume (scrape) them. 

For Kubernetes, there's an established convention that facilitates the automatic discovery of pods exposing Prometheus metrics.
This involves incorporating specific annotations on the pods exposing information for path and port of the metrics endpoint.

Prometheus and other observability tools like Datadog are able to discover annotated pods and collect the metrics from the endpoint.

In the following we will explain the setup of Prometheus on your cluster and the integration of an existing Datadog installation.

* [Install Prometheus](#install-prometheus)
* [Install Datadog Agent](#install-datadog-agent)

## <a id="install-prometheus"></a> Install Prometheus

There are multiple ways to install Prometheus on your cluster:

* [Prometheus Operator](#prometheus-operator)
* [kube-prometheus-stack Helm chart](#kube-prometheus-stack)
* [Prometheus Helm chart](#prometheus-helm-chart)

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
---
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
---
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

Next, you have to configure a Prometheus scraping job. This job will be designed to monitor all pods that are marked 
with the designated Prometheus annotations.

> The Prometheus Operator, by default, does not support annotation-based discovery of services. 
> Therefore, to enable the functionality of these annotations, it's necessary to set up a custom scrape job configuration.

Create a file `prometheus-scrape-config.yaml` with the following content:

```yaml
# Example scrape config for pods
#
# The relabeling allows the actual pod scrape endpoint to be configured via the
# following annotations:
#
# * `prometheus.io/scrape`: Only scrape pods that have a value of `true`.
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

Now, proceed to generate a secret using that file:

```console
kubectl create secret generic additional-scrape-configs --from-file=prometheus-scrape-config.yaml 
```

Finally, create a Prometheus resource that uses this secret.

The Prometheus Operator will automatically detect the configuration and generate a scrape job from it. This job will be 
executed regularly by the Prometheus instance that will be set up.

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

To access the Prometheus web interface, you need to make the port `9090` of the Prometheus server pod accessible outside 
the cluster via a Kubernetes service or ingress. For development purposed you can forward the port to 
your local machine using the `kubectl` command.

For further information on the Prometheus Operator, including details on how to persist your metrics or activate alerting 
features, please consult the 
[Prometheus Operator documentation](https://prometheus-operator.dev/docs/prologue/introduction/).

#### <a id="troubleshooting"></a> Troubleshooting

**Where can I see the scrape config that has been picked up by the Prometheus instance?**

```console
kubectl get secret prometheus-prometheus -ojson | jq -r '.data["prometheus.yaml.gz"]' | base64 -d | gunzip
```

### <a id="kube-prometheus-stack"></a> Install kube-prometheus-stack Helm chart

This Helm chart, developed by the Prometheus community, establishes a comprehensive cluster monitoring stack. It includes 
the Prometheus Operator, cluster monitoring, ensures high availability, and integrates Node Exporter, Grafana dashboards, 
among other features.

To install, add the Helm repository:

```console
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```
Since there isn't a pre-defined scrape job configuration to support annotation-based discovery of services, 
you must first create the configuration secret `additional-scrape-configs` from the 
`prometheus-scrape-config.yaml` file (as described in the [Install Prometheus Operator](#prometheus-operator) section).

Once this is done, you can then utilize it as a parameter in the Helm installation command:

```console
helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --set prometheus.prometheusSpec.additionalScrapeConfigsSecret.name=additional-scrape-configs \
  --set prometheus.prometheusSpec.additionalScrapeConfigsSecret.key=prometheus-scrape-config.yaml \
  --set prometheus.prometheusSpec.additionalScrapeConfigsSecret.enabled=true
```

The Helm chart also sets up various scraping jobs for metrics related to the Kubernetes cluster.

Also refer to [kube-prometheus-stack Helm chart README](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
for further information.

#### <a id="troubleshooting"></a> Troubleshooting

**Where can I see the scrape config that has been picked up by the Prometheus instance?**

```console
kubectl get secret prometheus-kube-prometheus-stack-prometheus -ojson | jq -r '.data["prometheus.yaml.gz"]' | base64 -d | gunzip
```

### <a id="prometheus-helm-chart"></a> Install Prometheus Helm chart

This Helm chart, provided by the Prometheus community, facilitates the installation of Prometheus on your Kubernetes cluster. 
It includes key components such as Alert Manager, kube-state-metrics, Node Exporter, and Push Gateway.

To install, add the Helm repository:

```console
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

Finally, install the Prometheus Helm chart:

```console
helm upgrade --install prometheus prometheus-community/prometheus
```

The Helm chart seamlessly installs scraping job configurations for pods and services tagged with Prometheus scraping annotations
and also sets up scraping for metrics related to the Kubernetes cluster.

Also refer to [Prometheus Helm chart README](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus).

## <a id="install-datadog-agent"></a> Install Datadog Agent

If you are using Datadog you can also use it to scrape the Prometheus endpoints without having to install Prometheus
itself. You can use the Datadog Agent to forward the metrics to the Datadog servers.

To install, add the Helm repository:

```console
helm repo add datadog https://helm.datadoghq.com
helm repo update
```

Then, install the Datadog Agent Helm chart:

```console
helm upgrade --install datadog-operator datadog/datadog-operator
```

Next, generate a new API key in Datadog for the Agent that needs to push metrics to Datadog.
This can be accomplished through the Datadog user interface, under `Profile/Organization Settings/API Keys`.

Now, create a secret for the Datadog API key:

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

Datadog is designed to automatically gather Prometheus metrics from pods that are annotated with the default Prometheus 
annotations, as previously described.

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

When deploying Spring Boot workloads on Tanzu Application Platform (TAP), the Spring Boot Conventions ensure that actuator 
endpoints are exposed. Along with these endpoints, the Prometheus metrics endpoint is also made accessible.

To guide Prometheus to the location of this endpoint on a pod, you need to include specific annotations in your `workload.yaml` file. 
These annotations should align with your configuration. After adding these annotations, deploy the changes:

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

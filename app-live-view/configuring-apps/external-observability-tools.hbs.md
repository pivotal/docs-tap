# Use external observability tools

<!-- can I mention App Live View in the title? -->
This topic tells you how to generate metrics for your Tanzu Application Platform (commonly known as TAP)
applications to enable observability with external tools.

## <a id="prometheus-metrics"></a> About Prometheus metrics

[Prometheus](https://prometheus.io/) is an open-source monitoring tool that defines a simple text-based
metrics format with client libraries for a wide range of programming languages and frameworks.

By integrating these client libraries into your applications, you can effortlessly generate metrics
in the Prometheus format.
These metrics are accessible through an HTTP endpoint, enabling Prometheus and other observability
tools to conveniently consume (scrape) them.

For Kubernetes, there is an established convention that facilitates the automatic discovery of pods
exposing Prometheus metrics.
This involves incorporating specific annotations on the pods exposing information for path and port of the metrics endpoint.

Prometheus and other observability tools like Datadog can discover annotated pods and collect the metrics from the endpoint.

This topic explains how to set up Prometheus on your cluster and integrate an existing Datadog installation.
<!-- Could this say "or integrate an existing Datadog installation? -->
<!-- You can use either Prometheus or Datadog, right? -->

## <a id="install-prometheus"></a> Use Prometheus as your observability tool

There are multiple ways to install Prometheus on your cluster:

- Use the Prometheus Operator
- Use the kube-prometheus-stack Helm chart
- Use the Prometheus Helm chart

Prometheus Operator
: The Prometheus Operator offers a simplified way to use custom resources to deploy and configure
  Prometheus, Alertmanager and related monitoring components.

  To install using the Prometheus Operator:

  1. Install the Prometheus Operator bundle by running:

      ```console
      LATEST=$(curl -s https://api.github.com/repos/prometheus-operator/prometheus-operator/releases/latest | jq -cr .tag_name)
      curl -sL https://github.com/prometheus-operator/prometheus-operator/releases/download/${LATEST}/bundle.yaml | kubectl create -f -
      ```

  1. For RBAC based environments, create the RBAC rules for the Prometheus service account by running:

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

  1. Configure a Prometheus scraping job. This job must monitor all pods that are marked with the
     designated Prometheus annotations.

      > **Note** The Prometheus Operator does not support annotation-based discovery of services by default.
      > To enable these annotations, you must set up a custom scrape job configuration.

      1. Create a file named `prometheus-scrape-config.yaml` with the following content:

          ```yaml
          # Example scrape config for pods
          #
          # The relabeling allows the actual pod scrape endpoint to be configured through the
          # following annotations:
          #
          # * `prometheus.io/scrape`: Only scrape pods that have a value of `true`.
          # * `prometheus.io/scheme`: If the metrics endpoint is secured then you must
          # set this to `https` and most likely set the `tls_config` of the scrape config.
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

      1. Generate a secret using the file you just created by running:

          ```console
          kubectl create secret generic additional-scrape-configs --from-file=prometheus-scrape-config.yaml
          ```

      1. Create a Prometheus resource that uses this secret by running:

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

          The Prometheus Operator automatically detects the configuration and generates a scrape job
          from it. This job is executed regularly by the Prometheus instance that is set up.

  1. To access the Prometheus web interface, you must make the port `9090` of the Prometheus server pod
    accessible outside the cluster through a Kubernetes service or ingress.
    For development purposes, you can forward the port to your local machine using kubectl.

  1. To see the scrape configuration that the Prometheus instance has picked up, run:

      ```console
      kubectl get secret prometheus-prometheus -ojson | jq -r '.data["prometheus.yaml.gz"]' | base64 -d | gunzip
      ```

  For more information about the Prometheus Operator, including how to persist your metrics or activate
  alerting features, see the
  [Prometheus Operator documentation](https://prometheus-operator.dev/docs/prologue/introduction/).

kube-prometheus-stack Helm chart
: The Prometheus community has developed the `kube-prometheus-stack` Helm chart, which establishes a
  comprehensive cluster monitoring stack.
  The Helm chart sets up various scraping jobs for metrics related to the Kubernetes cluster.

  These are some of its features:

  - Includes the Prometheus Operator
  - Includes cluster monitoring
  - Ensures high availability
  - Integrates Node Exporter Grafana dashboards

  For more information, see the [kube-prometheus-stack Helm chart README](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) in GitHub.

  To install the `kube-prometheus-stack` Helm chart:

  1. Add the Helm repository by running:

      ```console
      helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
      helm repo update
      ```

  1. Because there isn't a predefined scrape job configuration to support annotation-based discovery
    of services, you must create the configuration secret `additional-scrape-configs` from the
    `prometheus-scrape-config.yaml` file as described in the Prometheus Operator installation method.
    <!-- do you also have to create prometheus-scrape-config.yaml or is this provided for you? -->
    <!-- probably include the full steps because it might be difficult to link to another tab. -->

  1. Install the `kube-prometheus-stack` Helm chart by running:

      ```console
      helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
        --set prometheus.prometheusSpec.additionalScrapeConfigsSecret.name=additional-scrape-configs \
        --set prometheus.prometheusSpec.additionalScrapeConfigsSecret.key=prometheus-scrape-config.yaml \
        --set prometheus.prometheusSpec.additionalScrapeConfigsSecret.enabled=true
      ```

  1. To see the scrape configuration that the Prometheus instance has picked up, run:

      ```console
      kubectl get secret prometheus-kube-prometheus-stack-prometheus -ojson | jq -r '.data["prometheus.yaml.gz"]' | base64 -d | gunzip
      ```

Prometheus Helm chart
: The Prometheus community provides the Prometheus Helm chart to install Prometheus on your
  Kubernetes cluster.
  The Helm chart installs scraping job configurations for pods and services tagged with Prometheus
  scraping annotations and sets up scraping for metrics related to the Kubernetes cluster.
  It includes key components such as Alert Manager, kube-state-metrics, Node Exporter, and Push Gateway.

  For more information, see the [Prometheus Helm chart README](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus) in GitHub.

  To install the Prometheus Helm chart:

  1. Add the Helm repository by running:

      ```console
      helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
      helm repo update
      ```

  1. Install the Prometheus Helm chart by running:

      ```console
      helm upgrade --install prometheus prometheus-community/prometheus
      ```

## <a id="install-datadog-agent"></a> Use Datadog as your observability tool

If you use Datadog, you can use it to scrape the Prometheus endpoints without having to install
Prometheus itself.
Datadog automatically gathers Prometheus metrics from pods that are annotated with the default Prometheus
annotations. The Datadog Agent forwards the metrics to the Datadog servers.

To use Datadog as your observability tool:

1. Add the Helm repository by running:

    ```console
    helm repo add datadog https://helm.datadoghq.com
    helm repo update
    ```

1. Install the Datadog Agent Helm chart by running:

    ```console
    helm upgrade --install datadog-operator datadog/datadog-operator
    ```

  > **Note** There is a Known Issue with Datadog Cluster Agent on AKS cluster. Please refer to the [Known issue: Datadog agent cannot reconcile webhook on AKS](#known-issue-datadog-agent-cannot-reconcile-webhook-on-aks) section below.

1. Generate a new API key in Datadog for the Agent that wil push metrics to Datadog.
   You do this in the Datadog UI, under `Profile/Organization Settings/API Keys`.

1. Create a secret for the Datadog API key by running:

    ```console
    kubectl create secret generic datadog-secret --from-literal api-key=API-KEY
    ```

    Where `API-KEY` is the API you generated in the previous step.

1. Install the Datadog Agent by running:

    ```console
    cat <<EOF | kubectl apply -f -
    apiVersion: datadoghq.com/v2alpha1
    kind: DatadogAgent
    metadata:
      name: datadog
    spec:
      global:
        clusterName: YOUR-CLUSTER-NAME
        site: DATADOG-HOST-NAME
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
    <!-- is api-key a placeholder variable? -->

    Where:

    - `YOUR-CLUSTER-NAME` is the name of your cluster as you want to see it in Datadog.
    - `DATADOG-HOST-NAME` is your Datadog host name, for example, `datadoghq.eu`.


  #### <a id="known-issue-datadog-agent-cannot-reconcile-webhook-on-aks"></a> Known issue: Datadog agent cannot reconcile webhook on AKS
  Issue Description:
  The Datadog Cluster Agent encounters an issue where it cannot reconcile the webhook, leading to an Error state. This is particularly observed on Azure Kubernetes Service (AKS).

  Workaround:
  To address this issue on AKS, you can apply the following workaround:

  1. Create a Custom `values.yaml` file

  1. Set `clusterAgent.admissionController` to `false` and set the envar `DD_ADMISSION_CONTROLLER_ADD_AKS_SELECTORS` to `true` in the custom values.yaml as shown below:

  ```console
  clusterAgent:
  admissionController:
    enabled: false
  env:
    - name: "DD_ADMISSION_CONTROLLER_ADD_AKS_SELECTORS"
      value: "true"
  ```

  1. Install Datadog Agent Helm chart with Custom Values:

  ```console
  helm upgrade --install datadog-operator datadog/datadog-operator -f values.yaml
  ```

  > **Note**: This workaround disables the admission controller, which may have implications on certain functionalities. Please consult Datadog documentation or support for additional guidance based on your specific use case.

## <a id="enable-sb-workloads"></a> Enable metric collection on Spring Boot workloads

To enable Spring Boot workloads to create Prometheus metrics, if using Maven, add the following
dependencies to your `pom.xml`:

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

This creates default metrics for the JVM, HTTP traffic, and more.
For a list of supported metrics, see the [Spring Boot documentation](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#actuator.metrics.supported).

When deploying Spring Boot workloads on Tanzu Application Platform, the Spring Boot conventions ensure
that actuator endpoints are exposed. The Prometheus metrics endpoint is also made accessible.

For Prometheus to find this endpoint on a pod, you must include specific annotations in your
`workload.yaml` file.
These annotations must align with your configuration. After adding these annotations, deploy the changes:

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

For more information about the Spring Boot Prometheus integration, see the
[Spring Boot Reference Documentation](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#actuator.metrics.export.prometheus).

#  Configuring Observability for Eventing

This topic tells you how to configure observability for Eventing.

## Overview

You can set up integrations with third-party observability tools to use logging, metrics, and tracing with Eventing. These observability integrations allow you to monitor and collect detailed metrics from your clusters on Eventing. You can collect logs and metrics for all workloads running on a cluster. This includes Eventing components or any apps running on Eventing.
The integrations in this topic are recommended by VMware, however you can use any Kubernetes compatible logging, metrics, and tracing platforms to monitor your cluster workload.

## Logging

You can collect and forward logs for all workloads on a cluster, including Eventing components or any apps running on Eventing. You can use any logging platform that is compatible with Kubernetes to collect and forward logs for Eventing workloads.
VMware recommends using Fluent Bit to collect logs and then forward logs to vRealize. The following sections describe configuring logging for Eventing with Fluent Bit and vRealize as an example.

### Configure Logging with Fluent Bit

You can use Fluent Bit to collect logs for all workloads on a cluster, including Eventing components or any apps running on Eventing. For more information about using Fluent Bit logs, see [Fluent Bit Kubernetes Logging](https://docs.fluentbit.io/manual/installation/kubernetes).

Fluent Bit lets you collect logs from Kubernetes containers, add Kubernetes metadata to these logs,
and forward logs to third-party log storage services.
For more information about collecting logs,
see [Logging](https://knative.dev/docs/install/collecting-logs/)
in the Knative documentation.

If you are using Tanzu Mission Control (TMC), vSphere 7.0 with Tanzu, or Tanzu Kubernetes Cluster to manage your cloud native environment, you must set up a role binding that grants required permissions to Fluent Bit containers in order to configure logging with any integration. Then, you can follow the instructions in the Fluent Bit documentation to complete the logging configuration. For more information about configuring Fluent Bit logging, see [Installation](https://docs.fluentbit.io/manual/installation/kubernetes#installation) in the Fluent Bit documentation.

To configure logging with Fluent Bit for your Eventing environment:

1. VMware recommends that you add any integrations to the `ConfigMap` in both your Knative Serving and Knative Eventing namespaces. Follow the logging configuration steps in the Fluent Bit documentation to create the `Namespace`, `ServiceAccount`, `Role`, `RoleBinding`, and `ConfigMap`. To view these steps, see [Installation](https://docs.fluentbit.io/manual/installation/kubernetes#installation) in the Fluent Bit documentation.

1. If you are using TMC, vSphere with Tanzu, or Tanzu Kubernetes Cluster
   to manage your cloud native environment, create a role binding in the Kubernetes namespace
   where your integration will be deployed to grant permission for privileged Fluent Bit containers.
   For information about creating a role binding on a Tanzu platform,
   see [Add a Role Binding](https://docs.vmware.com/en/VMware-Tanzu-Mission-Control/services/tanzumc-using/GUID-DBC3FF6D-F206-4047-8F21-ED8154A7537D.html).
   For information about viewing your Kubernetes namespaces,
   see [Viewing Namespaces](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/#viewing-namespaces).
   Create the following role binding:
    ```
    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      name: fluentbit-psp-rolebinding
      namespace: FLUENTBIT-NAMESPACE
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name:  PRIVILEGED-CLUSTERROLE
    subjects:
    - kind: ServiceAccount
      name: FLUENTBIT-SERVICEACCOUNT
      namespace: FLUENTBIT-NAMESPACE
    ```
    Where:

      - `FLUENTBIT-NAMESPACE` is your Fluent Bit namespace.
      - `PRIVILEGED-CLUSTERROLE` is the name of your privileged cluster role.
      - `FLUENTBIT-SERVICEACCOUNT` is your Fluent Bit service account.

1. To verify that you have configured logging successfully, run the following to access logs through your web browser:
    ```
    kubectl port-forward --namespace logging service/log-collector 8080:80
    ```

    For more information about accessing Fluent Bit logs, see [Logging](https://knative.dev/docs/install/collecting-logs/) in the Knative documentation.

### Forward Logs to vRealize

After you configure log collection, you can forward logs to log management services. vRealize Log Insight is one service you can use with Eventing. vRealize Log Insight is a scalable log management solution that provides log management, dashboards, analytics, and third-party extensibility for infrastructure and apps.
For more information about vRealize Log Insight, see the [VMware vRealize Log Insight Documentation](https://docs.vmware.com/en/vRealize-Log-Insight/index.html).

To forward logs from your Eventing environment to vRealize, you can use a new or existing instance of Tanzu Kubernetes Cluster.
For information about how to configure log forwarding to vRealize from Tanzu Kubernetes Cluster,
see the [Configure Log forwarding from VMware Tanzu Kubernetes Cluster to vRealize Log Insight Cloud](https://blogs.vmware.com/management/2020/06/configure-log-forwarding-from-vmware-tanzu-kubernetes-cluster-to-vrealize-log-insight-cloud.html) blog.

## Metrics

Eventing integrates with Prometheus and VMware Aria Operations for Applications (formerly known as Tanzu Observability by Wavefront) to collect metrics on components or apps.
For more information about integrating with Prometheus, see [Overview](https://prometheus.io/docs/introduction/overview/) in the Prometheus documentation
and [Kubernetes Integration](https://docs.wavefront.com/kubernetes.html) in the Wavefront documentation.

You can configure Prometheus endpoints on Eventing components in order to be able to collect metrics on your components or apps.
For information on annotations required to collect metrics on apps, see [Per-Pod Prometheus Annotations](https://www.weave.works/docs/cloud/latest/tasks/monitor/configuration-k8s/#per-pod-prometheus-annotations).

You can use annotation based discovery with Prometheus to define which Kubernetes objects in your Eventing environment to add metadata and collect metrics in a more automated way.
For more information about using annotation based discovery, see [Annotation based discovery](https://github.com/wavefrontHQ/wavefront-collector-for-kubernetes/blob/6d1cf432d0ef2de4840e96c2b74950451b6bde2f/docs/discovery.md#annotation-based-discovery) in GitHub.

You can then use the Wavefront Collector for Kubernetes collector to dynamically discover and scrape pods with the `prometheus.io/scrape` annotation prefix.
For information about the Kubernetes collector, see [Wavefront Collector for Kubernetes](https://github.com/wavefrontHQ/wavefront-collector-for-kubernetes) in GitHub.

>**Note** All Eventing related metrics are emitted with the prefix `tanzu.vmware.com/cloud-native-runtimes.*`.

## Tracing

Tracing is a method for understanding the performance of specific code paths in apps as they handle requests.
You can configure tracing to collect performance metrics for your apps or Eventing components.
You can trace which aspects of Eventing and workloads running on Eventing are performing poorly.

### Configuring Tracing

You can configure tracing for your applications on Eventing.
To do this, you configure tracing for both Knative Serving and Eventing by editing the ConfigMap `config-tracing` for your Knative namespaces.

VMware recommends that you add any integrations in both your Serving and Eventing namespaces.
For information on how to enable request traces in each component, see the following Knative documentation:

- Serving. See [Accessing request traces](https://knative.dev/docs/serving/accessing-traces/).
- Eventing. See [Accessing CloudEvent traces](https://knative.dev/docs/eventing/accessing-traces/).

### Forwarding Trace Data to an Observability Platform or Data Visualization Tool

You can use the OpenTelemetry integration to forward trace data to a data visualization tool that can ingest data in Zipkin format.
For more information about using Zipkin for tracing, see the [Zipkin](https://zipkin.io/) documentation.

VMWare recommends integration with VMware Aria Operations for Applications (formerly known as Tanzu Observability by Wavefront).
For information about forwarding trace data, see [Send OpenTelemetry Data to Tanzu Observability](https://docs.wavefront.com/opentelemetry_overview.html).

### Sending Trace Data to VMware Aria Operations for Applications

You can send trace data to an observability and analytics platform such as VMware Aria Operations for Applications to view and monitor your trace data in dashboards.
VMware Aria Operations for Applications offers several deployment options. During development, a single proxy is often sufficient for all data sources.
See [Proxy Deployment Options](https://docs.wavefront.com/proxies.html#proxy-deployment-options) for more information on other deployment options.

Follow the steps below to configure Eventing to send traces to the Wavefront proxy and then, configure the Wavefront proxy to consume Zipkin spans.

1. Deploy the Wavefront Proxy.
   For more information about Wavefront proxies, see [Install and Manage Wavefront Proxies](https://docs.wavefront.com/proxies_installing.html).

2. Configure the namespace where the Wavefront Proxy was deployed with proper credentials to its image registry.

   The example below utilizes the Namespace Provisioner package to automatically configure namespaces labeled with: `apps.tanzu.vmware.com/tap-ns`.

   ```sh
   export WF_NAMESPACE=default
   kubectl label namespace ${WF_NAMESPACE} apps.tanzu.vmware.com/tap-ns=""

   export WF_REGISTRY_HOSTNAME=projects.registry.vmware.com
   export WF_REGISTRY_USERNAME=<your-password>
   export WF_REGISTRY_PASSWORD=<your-username>
   tanzu secret registry add registry-credentials \
     --username ${WF_REGISTRY_USERNAME} --password ${WF_REGISTRY_PASSWORD} \
     --server ${WF_REGISTRY_HOSTNAME} \
     --export-to-all-namespaces --yes --namespace tap-install
   ```

   Where:
   `WF_NAMESPACE` is the namespace where you deployed the Wavefront Proxy.
   `WF_REGISTRY_HOSTNAME` is the image registry where the Wavefront Proxy image is located.
   `WF_REGISTRY_USERNAME` is your username to access the image registry to pull the Wavefront Proxy image.
   `WF_REGISTRY_PASSWORD` is your password to access the image registry to pull the Wavefront Proxy image.

   For more information on how to set up developer namespaces, see [Provision developer Namespace](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.6/tap/namespace-provisioner-provision-developer-ns.html).

3. Configure the Wavefront Proxy to allow Zipkin/Istio traces.

   You can uncomment the lines indicated in the yaml file for the Wavefront Deployment to enable consumption of Zipkin traces.
   You should edit the Wavefront Deployment to set the `WAVEFRONT_PROXY_ARGS` environment variable to the value `--traceZipkinListenerPorts 9411`.
   Also, edit the Wavefront Deployment to expose the containerPort `9411`.

4. Confirm that the Wavefront Proxy is running and working.

   First, check if pods are running. For further information on how to test a proxy, see [Test a Proxy](https://docs.wavefront.com/proxies_installing.html#test-a-proxy).
   ```sh
   kubectl get pods -n ${WF_NAMESPACE}
   ```

   Where:
   `WF_NAMESPACE` is the namespace where you deployed the Wavefront Proxy.

5. Edit the Serving ConfigMap `config-tracing` to enable the Zipkin tracing integration.

   You can configure Eventing to send traces to the Wavefront proxy by editing the `zipkin-endpoint` property in the ConfigMap to point to the Wavefront proxy URL.
   You can configure the Wavefront proxy to consume Zipkin spans by listening to port `9411`.

   >**Note** There are two ways of editing a Knative ConfigMap on Eventing. Depending on your installation, you may
   be able to edit the ConfigMap directly on the cluster or via overlays. Check the following documentation on how to edit ConfigMaps using overlays: [Configuring Eventing](customizing-cnrs.md)

   The snippet below is an example of a Kubernetes secret containing a ytt overlay with the suggested changes to the ConfigMap `config-tracing`.

   ```yaml
   apiVersion: v1
   kind: Secret
   metadata:
     name: cnrs-patch
   stringData:
     patch.yaml: |
       #@ load("@ytt:overlay", "overlay")
       #@overlay/match by=overlay.subset({"kind":"ConfigMap","metadata":{"name":"config-tracing","namespace":"knative-serving"}})
       ---
       data:
         #@overlay/match missing_ok=True
         backend: "zipkin"
         #@overlay/match missing_ok=True
         zipkin-endpoint: "http://wavefront-proxy.default.svc.cluster.local:9411/api/v2/spans"
   ```

   Once you follow the steps in the [Customizing Eventing](customizing-cnrs.md) documentation to configure your installation to use the above overlay,
   you can check the ConfigMap on the cluster to confirm that the changes were applied.

   ```sh
   kubectl get configmap config-tracing --namespace knative-serving --output yaml
   ```

   The ConfigMap should then look like this:
   
   ```yaml
   apiVersion: v1
   kind: ConfigMap
   metadata:
    name: config-tracing
   data:
    _example: |
       ...
    backend: "zipkin"
    zipkin-endpoint: "http://wavefront-proxy.default.svc.cluster.local:9411/api/v2/spans"
   ```

Other resources:

- [OpenTelemetry Integration](https://docs.wavefront.com/opentelemetry.html#opentelemetry-integration)
- [Wavefront Proxies](https://docs.wavefront.com/proxies.html#proxy-deployment-options)
- [Deploy a Wavefront Proxy in Kubernetes (Manual Install)](https://docs.wavefront.com/kubernetes.html#kubernetes-manual-install)
- [Managing API Tokens on Wavefront](https://docs.wavefront.com/wavefront_api.html#managing-api-tokens)
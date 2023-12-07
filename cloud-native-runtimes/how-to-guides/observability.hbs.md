# Configuring observability for Cloud Native Runtimes

This topic tells you how to configure observability for Cloud Native Runtimes, commonly known as CNRs.

## <a id='overview'></a> Overview

You can set up integrations with third-party observability tools to use logging,
metrics, and tracing with Cloud Native Runtimes. These observability
integrations allow you to monitor and collect detailed metrics from your
clusters on Cloud Native Runtimes. You can collect logs and metrics for all
workloads running on a cluster. This includes Cloud Native Runtimes components
or any apps running on Cloud Native Runtimes. The integrations in this topic are
recommended by VMware, however you can use any Kubernetes-compatible logging,
metrics, and tracing platforms to monitor your cluster workload.

## <a id='logging'></a> Logging

You can collect and forward logs for all workloads on a cluster, including Cloud
Native Runtimes components and any apps running on Cloud Native Runtimes. You can
use any logging platform that is compatible with Kubernetes to collect and
forward logs for Cloud Native Runtimes workloads. VMware recommends using Fluent
Bit to collect logs and forward logs to vRealize. The following sections
describe configuring logging for Cloud Native Runtimes with Fluent Bit and
vRealize as an example.

### <a id='config-fluentbit'></a> Configure Logging with Fluent Bit

You can use Fluent Bit to collect logs for all workloads on a cluster, including
Cloud Native Runtimes components or any apps running on Cloud Native Runtimes.
For more information about using Fluent Bit logs, see [Fluent Bit Kubernetes
Logging](https://docs.fluentbit.io/manual/installation/kubernetes).

Fluent Bit lets you collect logs from Kubernetes containers, add Kubernetes metadata to these logs,
and forward logs to third-party log storage services.
For more information about collecting logs,
see the [Knative documentation](https://knative.dev/docs/install/collecting-logs/).

If you are using Tanzu Mission Control (TMC), vSphere 7.0 with Tanzu, or Tanzu
Kubernetes Cluster to manage your cloud-native environment, you must set up a
role binding that grants required permissions to Fluent Bit containers to
configure logging with any integration. Then, follow the instructions in the
Fluent Bit documentation to complete the logging configuration. For more
information about configuring Fluent Bit logging, see the [Fluent Bit
documentation](https://docs.fluentbit.io/manual/installation/kubernetes#installation).

To configure logging with Fluent Bit for your Cloud Native Runtimes environment:

1. VMware recommends that you add any integrations to the `ConfigMap` in your Knative Serving namespace. Follow the logging configuration steps in the Fluent Bit documentation to create the `Namespace`, `ServiceAccount`, `Role`, `RoleBinding`, and `ConfigMap`. To view these steps, see the [Fluent Bit documentation](https://docs.fluentbit.io/manual/installation/kubernetes#installation).

2. If you are using TMC, vSphere with Tanzu, or Tanzu Kubernetes Cluster
   to manage your cloud-native environment, create a role binding in the Kubernetes namespace
   where your integration is deployed to grant permission for privileged Fluent Bit containers.
   For information about creating a role binding on a Tanzu platform,
   see [Add a Role Binding](https://docs.vmware.com/en/VMware-Tanzu-Mission-Control/services/tanzumc-using/GUID-DBC3FF6D-F206-4047-8F21-ED8154A7537D.html).
   For information about viewing your Kubernetes namespaces,
   see the [Kubernetes documentation](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/#viewing-namespaces).

   Create the following role binding:

    ```console
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

3. To verify that you configured logging successfully, run the following to access logs through your web browser:

    ```console
    kubectl port-forward --namespace logging service/log-collector 8080:80
    ```

    For more information about accessing Fluent Bit logs, see the [Knative documentation](https://knative.dev/docs/install/collecting-logs/).

### <a id='forward'></a> Forward Logs to vRealize

After you configure log collection, you can forward logs to log management
services. vRealize Log Insight is one service you can use with Cloud Native
Runtimes. vRealize Log Insight is a scalable log management solution that
provides log management, dashboards, analytics, and third-party extensibility
for infrastructure and apps. For more information about vRealize Log Insight,
see the [VMware vRealize Log Insight
Documentation](https://docs.vmware.com/en/vRealize-Log-Insight/index.html).

To forward logs from your Cloud Native Runtimes environment to vRealize, you can
use a new or existing instance of Tanzu Kubernetes Cluster. For information
about how to configure log forwarding to vRealize from Tanzu Kubernetes Cluster,
see the [Configure Log forwarding from VMware Tanzu Kubernetes Cluster to
vRealize Log Insight
Cloud](https://blogs.vmware.com/management/2020/06/configure-log-forwarding-from-vmware-tanzu-kubernetes-cluster-to-vrealize-log-insight-cloud.html)
blog.

## <a id='metrics'></a> Metrics

Cloud Native Runtimes integrates with Prometheus and VMware Aria Operations for
Applications (formerly known as Tanzu Observability by Wavefront) to collect
metrics on components or apps. For more information about integrating with
Prometheus, see the [Prometheus documentation](https://prometheus.io/docs/introduction/overview/) and the [Wavefront
documentation](https://docs.wavefront.com/kubernetes.html).

You can configure Prometheus endpoints on Cloud Native Runtimes components to
collect metrics on your components or apps. For information about annotations
required to collect metrics on apps, see the [Prometheus documentation](https://www.weave.works/docs/cloud/latest/tasks/monitor/configuration-k8s/#per-pod-prometheus-annotations).

You can use annotation based discovery with Prometheus to define which
Kubernetes objects in your Cloud Native Runtimes environment to add metadata and
collect metrics in a more automated way. For more information about using
annotation based discovery, see the [VMware Aria Operations for Applications documentation](https://github.com/wavefrontHQ/wavefront-collector-for-kubernetes/blob/6d1cf432d0ef2de4840e96c2b74950451b6bde2f/docs/discovery.md#annotation-based-discovery)
in GitHub.

You can then use the Wavefront Collector for Kubernetes collector to dynamically
discover and scrape pods with the `prometheus.io/scrape` annotation prefix. For
information about the Kubernetes collector, see the [VMware Aria Operations for Applications documentation](https://github.com/wavefrontHQ/wavefront-collector-for-kubernetes)
in GitHub.

>**Note** All Cloud Native Runtimes related metrics have the prefix `tanzu.vmware.com/cloud-native-runtimes.*`.

## <a id='tracing'></a> Tracing

Tracing is a method for understanding the performance of specific code paths in apps as they handle requests.
You can configure tracing to collect performance metrics for your apps or Cloud Native Runtimes components.
You can trace which aspects of Cloud Native Runtimes and workloads running on Cloud Native Runtimes are performing poorly.

### <a id='config-tracing'></a> Configuring Tracing

You can configure tracing for your applications on Cloud Native Runtimes.
You configure tracing for Knative Serving by editing the ConfigMap `config-tracing` for your Knative namespaces.

VMware recommends that you add any integrations in your Serving namespaces.
For information about how to enable request traces in each component, see the [Knative documentation](https://knative.dev/docs/serving/accessing-traces/).

### <a id='forward-trace'></a> Forwarding trace data to an observability platform or data visualization tool

You can use the OpenTelemetry integration to forward trace data to a data visualization tool that can ingest data in Zipkin format.
For more information about using Zipkin for tracing, see the [Zipkin](https://zipkin.io/) documentation.

VMware recommends integrating with VMware Aria Operations for Applications (formerly known as Tanzu Observability by Wavefront).
For information about forwarding trace data, see the [VMware Aria Operations for Applications documentation](https://docs.wavefront.com/opentelemetry_overview.html).

### <a id='send-trace'></a> Sending trace data to VMware Aria Operations for Applications

You can send trace data to an observability and analytics platform such as
VMware Aria Operations for Applications to view and monitor your trace data in
dashboards. VMware Aria Operations for Applications offers several deployment
options. During development, a single proxy is often sufficient for all data
sources. For
more information about other deployment options, see the [VMware Aria Operations for Applications documentation](https://docs.wavefront.com/proxies.html#proxy-deployment-options).

To configure Cloud Native Runtimes to send traces to the Wavefront proxy and
then, configure the Wavefront proxy to consume Zipkin spans:

1. Deploy the Wavefront Proxy.
   For more information about Wavefront proxies, see [Install and Manage Wavefront Proxies](https://docs.wavefront.com/proxies_installing.html).

2. Configure the namespace where the Wavefront Proxy was deployed with proper credentials to its container image registry.

   The following example uses the Namespace Provisioner package to automatically configure namespaces labeled with `apps.tanzu.vmware.com/tap-ns`.

   ```console
   export WF_NAMESPACE=default
   kubectl label namespace ${WF_NAMESPACE} apps.tanzu.vmware.com/tap-ns=""

   export WF_REGISTRY_HOSTNAME=HOSTNAME
   export WF_REGISTRY_USERNAME=USERNAME
   export WF_REGISTRY_PASSWORD=PASSWORD
   tanzu secret registry add registry-credentials \
     --username ${WF_REGISTRY_USERNAME} --password ${WF_REGISTRY_PASSWORD} \
     --server ${WF_REGISTRY_HOSTNAME} \
     --export-to-all-namespaces --yes --namespace tap-install
   ```

   Where:

   - `WF_NAMESPACE` is the namespace where you deployed the Wavefront Proxy.
   - `HOSTNAME` is the image registry where the Wavefront Proxy image is located.
   - `USERNAME` is your user name to access the image registry to pull the Wavefront Proxy image.
   - `PASSWORD` is your password to access the image registry to pull the Wavefront Proxy image.

   For more information about how to set up developer namespaces, see [Provision developer namespaces](../../namespace-provisioner/provision-developer-ns.hbs.md).
   [Provision developer namespaces](../../namespace-provisioner/provision-developer-ns.hbs.md).

3. Configure the Wavefront Proxy to allow Zipkin/Istio traces.

   You can uncomment the lines indicated in the YAML file for the Wavefront Deployment to enable consumption of Zipkin traces.
   Edit the Wavefront Deployment to set the `WAVEFRONT_PROXY_ARGS` environment variable to the value `--traceZipkinListenerPorts 9411`.
   Also, edit the Wavefront Deployment to expose the containerPort `9411`.

4. Confirm that the Wavefront Proxy is running and working.

   Verify that pods are running. For more information about how to test a proxy, see the [VMware Aria Operations for Applications documentation](https://docs.wavefront.com/proxies_installing.html#test-a-proxy).

   ```console
   kubectl get pods -n ${WF_NAMESPACE}
   ```

   Where `WF_NAMESPACE` is the namespace where you deployed the Wavefront Proxy.

5. Edit the Serving ConfigMap `config-tracing` to enable the Zipkin tracing integration.

   You can configure Cloud Native Runtimes to send traces to the Wavefront proxy by editing the `zipkin-endpoint` property in the ConfigMap to point to the Wavefront proxy URL.
   You can configure the Wavefront proxy to consume Zipkin spans by listening to port `9411`.

   >**Note** There are two ways of editing a Knative ConfigMap on Cloud Native Runtimes. Depending on your installation, you can edit the ConfigMap directly on the cluster or by using overlays. For information about how to edit ConfigMaps using overlays, see [Configuring Cloud Native Runtimes](./customizing-cnrs.hbs.md).

   The following example of a Kubernetes secret contains a ytt overlay with the suggested changes to the ConfigMap `config-tracing`:

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

   After you follow the steps in [Customizing Cloud Native Runtimes](./customizing-cnrs.hbs.md) to configure your installation to use an overlay,
   you can examine the ConfigMap on the cluster to confirm that the changes were applied.

   ```console
   kubectl get configmap config-tracing --namespace knative-serving --output yaml
   ```

   The ConfigMap looks like this example:

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

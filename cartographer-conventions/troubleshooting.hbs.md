# Troubleshoot Cartographer Conventions

This topic describes how you can troubleshoot Cartographer Conventions.

## <a id="no-server-in-cluster"></a> No server in the cluster

### Symptoms

+ When a `PodIntent` is submitted, no `convention` is applied.

### Cause

When there are no `convention servers` ([ClusterPodConvention](reference/cluster-pod-convention.md)) deployed in the cluster or none of the existing convention servers applied any conventions, the `PodIntent` is not being mutated.

### Solution

Deploy a `convention server` ([ClusterPodConvention](reference/cluster-pod-convention.md)) in the cluster.


## <a id="wrong-certificates-config"></a>Server with wrong certificates configured

### Symptoms

+ When a `PodIntent` is submitted, the `conventions` are not applied.
+ The `convention-controller` [logs](#gathering-logs) report an error `failed to get CABundle` as follows:

    ```console
    {
    "level": "error",
    "ts": 1638222343.6839523,
    "logger": "controllers.PodIntent.PodIntent.ResolveConventions",
    "msg": "failed to get CABundle",
    "ClusterPodConvention": "base-convention",
    "error": "unable to find valid certificaterequests for certificate \"convention-template/webhook-certificate\"",
    "stacktrace": "reflect.Value.Call\n\treflect/value.go:339\ngithub.com/vmware-labs/reconciler-runtime/reconcilers.(*SyncReconciler).sync\n\tgithub.com/vmware-labs/reconciler-runtime@v0.3.0/reconcilers/reconcilers.go:287\ngithub.com/vmware-labs/reconciler-runtime/reconcilers.(*SyncReconciler).Reconcile\n\tgithub.com/vmware-labs/reconciler-runtime@v0.3.0/reconcilers/reconcilers.go:276\ngithub.com/vmware-labs/reconciler-runtime/reconcilers.Sequence.Reconcile\n\tgithub.com/vmware-labs/reconciler-runtime@v0.3.0/reconcilers/reconcilers.go:815\ngithub.com/vmware-labs/reconciler-runtime/reconcilers.(*ParentReconciler).reconcile\n\tgithub.com/vmware-labs/reconciler-runtime@v0.3.0/reconcilers/reconcilers.go:146\ngithub.com/vmware-labs/reconciler-runtime/reconcilers.(*ParentReconciler).Reconcile\n\tgithub.com/vmware-labs/reconciler-runtime@v0.3.0/reconcilers/reconcilers.go:120\nsigs.k8s.io/controller-runtime/pkg/internal/controller.(*Controller).Reconcile\n\tsigs.k8s.io/controller-runtime@v0.10.3/pkg/internal/controller/controller.go:114\nsigs.k8s.io/controller-runtime/pkg/internal/controller.(*Controller).reconcileHandler\n\tsigs.k8s.io/controller-runtime@v0.10.3/pkg/internal/controller/controller.go:311\nsigs.k8s.io/controller-runtime/pkg/internal/controller.(*Controller).processNextWorkItem\n\tsigs.k8s.io/controller-runtime@v0.10.3/pkg/internal/controller/controller.go:266\nsigs.k8s.io/controller-runtime/pkg/internal/controller.(*Controller).Start.func2.2\n\tsigs.k8s.io/controller-runtime@v0.10.3/pkg/internal/controller/controller.go:227"
    ```

### Cause

`convention server` ([ClusterPodConvention](reference/cluster-pod-convention.md)) is configured with
the wrong certificates. The `convention-controller` cannot figure out the CA Bundle to perform the
request to the server.

### Solution

Ensure that the `convention server` ([ClusterPodConvention](reference/cluster-pod-convention.md)) is configured with the correct certificates. To do so, verify the value of annotation `conventions.carto.run/inject-ca-from` which must be set to the used Certificate.

> **Important** Do not set annotation `conventions.carto.run/inject-ca-from` if no certificate is used.

## <a id="server-fails"></a>Server fails when processing a request

### Symptoms

+ When a `PodIntent` is submitted, the `convention` is not applied.
+ The `convention-controller` [logs](#gathering-logs) reports `failed to apply convention` error like this.

    ```json
    {"level":"error","ts":1638205387.8813763,"logger":"controllers.PodIntent.PodIntent.ApplyConventions","msg":"failed to apply convention","Convention":{"Name":"base-convention","Selectors":null,"Priority":"Normal","ClientConfig":{"service":{"namespace":"convention-template","name":"webhook","port":443},"caBundle":"..."}},"error":"Post \"https://webhook.convention-template.svc:443/?timeout=30s\": EOF","stacktrace":"reflect.Value.call\n\treflect/value.go:543\nreflect.Value.Call\n\treflect/value.go:339\ngithub.com/vmware-labs/reconciler-runtime/reconcilers.(*SyncReconciler).sync\n\tgithub.com/vmware-labs/reconciler-runtime@v0.3.0/reconcilers/reconcilers.go:287\ngithub.com/vmware-labs/reconciler-runtime/reconcilers.(*SyncReconciler).Reconcile\n\tgithub.com/vmware-labs/reconciler-runtime@v0.3.0/reconcilers/reconcilers.go:276\ngithub.com/vmware-labs/reconciler-runtime/reconcilers.Sequence.Reconcile\n\tgithub.com/vmware-labs/reconciler-runtime@v0.3.0/reconcilers/reconcilers.go:815\ngithub.com/vmware-labs/reconciler-runtime/reconcilers.(*ParentReconciler).reconcile\n\tgithub.com/vmware-labs/reconciler-runtime@v0.3.0/reconcilers/reconcilers.go:146\ngithub.com/vmware-labs/reconciler-runtime/reconcilers.(*ParentReconciler).Reconcile\n\tgithub.com/vmware-labs/reconciler-runtime@v0.3.0/reconcilers/reconcilers.go:120\nsigs.k8s.io/controller-runtime/pkg/internal/controller.(*Controller).Reconcile\n\tsigs.k8s.io/controller-runtime@v0.10.0/pkg/internal/controller/controller.go:114\nsigs.k8s.io/controller-runtime/pkg/internal/controller.(*Controller).reconcileHandler\n\tsigs.k8s.io/controller-runtime@v0.10.0/pkg/internal/controller/controller.go:311\nsigs.k8s.io/controller-runtime/pkg/internal/controller.(*Controller).processNextWorkItem\n\tsigs.k8s.io/controller-runtime@v0.10.0/pkg/internal/controller/controller.go:266\nsigs.k8s.io/controller-runtime/pkg/internal/controller.(*Controller).Start.func2.2\n\tsigs.k8s.io/controller-runtime@v0.10.0/pkg/internal/controller/controller.go:227"}
    ```

+ When a `PodIntent` status message is updated with `failed to apply convention from source base-convention: Post "https://webhook.convention-template.svc:443/?timeout=30s": EOF`.

### Cause

An unmanaged error occurs in the `convention server` when processing a request.

### Solution

1. Inspect the `convention server` logs to identify the cause of the error:

   1. To retrieve the `convention server` logs:

      ```console
      kubectl -n convention-template logs deployment/webhook
      ```

      Where:

         + The convention server was deployed as a `Deployment`
         + `webhook` is the name of the convention server `Deployment`.
         + `convention-template` is the namespace where the convention server is deployed.

1. Identify the error and deploy a fixed version of `convention server`.

   + The new deployment is not applied to the existing `PodIntent`s. It is only applied to the new `PodIntent`s.
   + To apply new deployment to exiting `PodIntent`, you must update the `PodIntent`, so the reconciler applies if it matches the criteria.

## <a id="server-not-secure"></a>Connection refused due to unsecured connection

### Symptoms

+ When a `PodIntent` is submitted, the `convention` is not applied.
+ The `convention-controller` [logs](#gathering-logs) reports a connection refused error as follows:

    ```console
    {"level":"error","ts":1638202791.5734537,"logger":"controllers.PodIntent.PodIntent.ApplyConventions","msg":"failed to apply convention","Convention":{"Name":"base-convention","Selectors":null,"Priority":"Normal","ClientConfig":{"service":{"namespace":"convention-template","name":"webhook","port":443},"caBundle":"..."}},"error":"Post \"https://webhook.convention-template.svc:443/?timeout=30s\": dial tcp 10.56.13.206:443: connect: connection refused","stacktrace":"reflect.Value.call\n\treflect/value.go:543\nreflect.Value.Call\n\treflect/value.go:339\ngithub.com/vmware-labs/reconciler-runtime/reconcilers.(*SyncReconciler).sync\n\tgithub.com/vmware-labs/reconciler-runtime@v0.3.0/reconcilers/reconcilers.go:287\ngithub.com/vmware-labs/reconciler-runtime/reconcilers.(*SyncReconciler).Reconcile\n\tgithub.com/vmware-labs/reconciler-runtime@v0.3.0/reconcilers/reconcilers.go:276\ngithub.com/vmware-labs/reconciler-runtime/reconcilers.Sequence.Reconcile\n\tgithub.com/vmware-labs/reconciler-runtime@v0.3.0/reconcilers/reconcilers.go:815\ngithub.com/vmware-labs/reconciler-runtime/reconcilers.(*ParentReconciler).reconcile\n\tgithub.com/vmware-labs/reconciler-runtime@v0.3.0/reconcilers/reconcilers.go:146\ngithub.com/vmware-labs/reconciler-runtime/reconcilers.(*ParentReconciler).Reconcile\n\tgithub.com/vmware-labs/reconciler-runtime@v0.3.0/reconcilers/reconcilers.go:120\nsigs.k8s.io/controller-runtime/pkg/internal/controller.(*Controller).Reconcile\n\tsigs.k8s.io/controller-runtime@v0.10.0/pkg/internal/controller/controller.go:114\nsigs.k8s.io/controller-runtime/pkg/internal/controller.(*Controller).reconcileHandler\n\tsigs.k8s.io/controller-runtime@v0.10.0/pkg/internal/controller/controller.go:311\nsigs.k8s.io/controller-runtime/pkg/internal/controller.(*Controller).processNextWorkItem\n\tsigs.k8s.io/controller-runtime@v0.10.0/pkg/internal/controller/controller.go:266\nsigs.k8s.io/controller-runtime/pkg/internal/controller.(*Controller).Start.func2.2\n\tsigs.k8s.io/controller-runtime@v0.10.0/pkg/internal/controller/controller.go:227"}
    ```

+ The `convention server` fails to start due to `server gave HTTP response to HTTPS client`:

  + When checking the `convention server` events by running:

    ```console
    kubectl -n convention-template describe pod webhook-594d75d69b-4w4s8
    ```

    Where:

    + The convention server was deployed as a `Deployment`
    + `webhook-594d75d69b-4w4s8` is the name of the `convention server` Pod.
    + `convention-template` is the namespace where the convention server is deployed.

    For example:

    ```console
    Name:         webhook-594d75d69b-4w4s8
    Namespace:    convention-template
    ...
    Containers:
      webhook:
    ...
    Events:
    Type     Reason     Age                   From               Message
    ----     ------     ----                  ----               -------
    Normal   Scheduled  14m                   default-scheduler  Successfully assigned convention-template/webhook-594d75d69b-4w4s8 to pool
    Normal   Pulling    14m                   kubelet            Pulling image "awesome-repo/awesome-user/awesome-convention-..."
    Normal   Pulled     14m                   kubelet            Successfully pulled image "awesome-repo/awesome-user/awesome-convention..." in 1.06032653s
    Normal   Created    13m (x2 over 14m)     kubelet            Created container webhook
    Normal   Started    13m (x2 over 14m)     kubelet            Started container webhook
    Warning  Unhealthy  13m (x9 over 14m)     kubelet            Readiness probe failed: Get "https://10.52.2.74:8443/healthz": http: server gave HTTP response to HTTPS client
    Warning  Unhealthy  13m (x6 over 14m)     kubelet            Liveness probe failed: Get "https://10.52.2.74:8443/healthz": http: server gave HTTP response to HTTPS client
    Normal   Pulled     9m13s (x6 over 13m)   kubelet            Container image "awesome-repo/awesome-user/awesome-convention" already present on machine
    Warning  BackOff    4m22s (x32 over 11m)  kubelet            Back-off restarting failed container
    ```

### Cause

When a `convention server` is provided without using Transport Layer Security (TLS) but the `Deployment` is configured to use TLS, Kubernetes fails to deploy the `Pod` because of the `liveness probe`.

### Solution

1. Deploy a `convention server` with TLS enabled.
1. Create `ClusterPodConvention` resource for the convention server with annotation `conventions.carto.run/inject-ca-from` as a pointer to the deployed `Certificate` resource.

## <a id="ca-not-propagated"></a>Self-signed certificate authority (CA) not propagated to the Convention Service

### Symptoms

The self-signed certificate authority (CA) for a registry is not propagated to the Convention Service.

### Cause

When you provide the self-signed certificate authority (CA) for a registry through `convention-controller.ca_cert_data`, it cannot be propagated to the Convention Service.

### Solution

Define the CA by using the available `.shared.ca_cert_data` top-level key to supply the CA to the Convention Service.

## <a id="no-pull-secrets-configured"></a> No imagePullSecrets configured

### Symptoms

When a PodIntent is submitted:

- No convention is applied.
- You see an `unauthorized to access repository` or `fetching metadata for Images failed` error when you inspect the workload.

### Cause

The errors are seen when a `workload` is created in a developer namespace where `imagePullSecrets` are not defined on the `default` serviceAccount or on the preferred serviceAccount.

### Solution 

Add the `imagePullSecrets` name to the default serviceAccount or the preferred serviceAccount.

For example:

```yaml
kind: ServiceAccount
metadata:
  name: default
  namespace: my-workload-namespace
imagePullSecrets:
  - name: registry-credentials # ensure this secret is defined
secrets:
- name: registry-credentials
``` 

## <a id="oom-killed"></a> `OOMKilled` convention controller 

### Symptoms

While processing workloads with large SBOM, the Cartographer Convention controller manager pod can 
fail with the status `CrashLoopBackOff` or `OOMKilled`. 

To work around this problem you can increase the memory limit to `512Mi` to fix the pod crash.

For example:

```console
NAME                                                          READY   STATUS             RESTARTS          AGE
cartographer-controller-6996774647-bs98l                      1/1     Running            0                 6d7h
cartographer-conventions-controller-manager-ff4cdf59d-5nzl5   0/1     CrashLoopBackOff   1292 (109s ago)   5d3h
```

The following is an example controller pod status:

```yaml
containerStatuses:
  - containerID: containerd://b7b7159a9e00ef726944d642a1b649108bba610b34d8d10f9b5270ea25d3db94
    image: sha256:9827e8e5b30d47c9373a1907dc5e7e15a76d2a4581e803eb6f2cb24e3a9ea62e
    imageID: my.image.registry.com/tanzu-application-platform/tap-packages@sha256:3cd1ae92f534ff935fbaf992b8308aa3dac3d1b6cbc8cf8a856451c8c92540f66
    lastState:
      terminated:
        containerID: containerd://b7b7159a9e00ef726944d642a1b649108bba610b34d8d10f9b5270ea25d3db94
        exitCode: 137
        finishedAt: "2023-11-06T21:02:56Z"
        reason: OOMKilled
        startedAt: "2023-11-06T21:02:10Z"
    name: manager
``` 

### Cause

This error usually occurs when a `workload` image, built by the supply chain, contains a large SBOM.
The default resource limit set during installation might not be large enough to process the 
pod conventions which can lead to the controller pod crashing. 

### Solution

To increase the Cartographer Convention controller manager memory limit by using a ytt overlay, see one of the following procedures:

- To increase the memory limit for convention server, see [Increase the memory limit for convention server](#increase-server).
- To increase the memory limit for convention webhook servers, such as app-live-view-conventions, spring-boot-webhook, and developer-conventions/webhook, see [Increase the memory limit for convention webhook servers](#increase-webhook).

#### <a id='increase-server'></a> Increase the memory limit for convention server

To increase the memory limit:

1. Create a `Secret` with the following ytt overlay:

  ```yaml
  apiVersion: v1
  kind: Secret
  metadata:
    name: patch-cartographer-convention-controller
    namespace: tap-install
  stringData:
    patch-conventions-controller.yaml: |
      #@ load("@ytt:overlay", "overlay")
      
      #@overlay/match by=overlay.subset({"kind":"Deployment", "metadata":{"name":"cartographer-conventions-controller-manager", "namespace": "cartographer-system"}}), expects="0+"
      ---
      spec:
        template:
          spec:
            containers:
              #@overlay/match by=overlay.subset({"name": "manager"})
              - name: manager
                resources:
                  limits:
                    cpu: 100m
                    memory: 512Mi
  ```

1. Update the Tanzu Application Platform values YAML file to include a `package_overlays` field:

  ```yaml
  package_overlays:
  - name: cartographer
    secrets:
    - name: patch-cartographer-convention-controller
  ```

1. Update Tanzu Application Platform by running:

  ```console
  tanzu package installed update tap -p tap.tanzu.vmware.com -v 1.7.0  --values-file tap-values.yaml -n tap-install
  ```

For information about the package customization, see [Customize your package installation](../../docs-tap/customize-package-installation.hbs.md).

#### <a id='increase-webhook'></a> Increase the memory limit for convention webhook servers

You might need to increase the memory limit for the convention webhook servers. 

- app-live-view-conventions
- spring-boot-webhook
- developer-conventions/webhook

Use this procedure to increase the memory limit for the following Convention servers:

1. Create a `Secret` with the following ytt overlay.

  ```yaml
  apiVersion: v1
  kind: Secret
  metadata:
    name: patch-app-live-view-conventions
    namespace: tap-install
  stringData:
    patch-conventions-controller.yaml: |
      #@ load("@ytt:overlay", "overlay")

      #@overlay/match by=overlay.subset({"kind":"Deployment", "metadata":{"name":"appliveview-webhook", "namespace": "app-live-view-conventions"}})
      ---
      spec:
        template:
          spec:
            containers:
              #@overlay/match by=overlay.subset({"name": "webhook"})
              - name: webhook
                resources:
                  limits:
                    memory: 512Mi
  ---
  apiVersion: v1
  kind: Secret
  metadata:
    name: patch-spring-boot-conventions
    namespace: tap-install
  stringData:
    patch-conventions-controller.yaml: |
      #@ load("@ytt:overlay", "overlay")

      #@overlay/match by=overlay.subset({"kind":"Deployment", "metadata":{"name":"spring-boot-webhook", "namespace": "spring-boot-convention"}})
      ---
      spec:
        template:
          spec:
            containers:
              #@overlay/match by=overlay.subset({"name": "webhook"})
              - name: webhook
                resources:
                  limits:
                    memory: 512Mi
  ---
  apiVersion: v1
  kind: Secret
  metadata:
    name: patch-developer-conventions
    namespace: tap-install
  stringData:
    patch-conventions-controller.yaml: |
      #@ load("@ytt:overlay", "overlay")

      #@overlay/match by=overlay.subset({"kind":"Deployment", "metadata":{"name":"webhook", "namespace": "developer-conventions"}})
      ---
      spec:
        template:
          spec:
            containers:
              #@overlay/match by=overlay.subset({"name": "webhook"})
              - name: webhook
                resources:
                  limits:
                    memory: 512Mi
  ```

1. Update the Tanzu Application Platform values YAML file to include a `package_overlays` field:

  ```yaml
  package_overlays:
  - name: appliveview-conventions
    secrets:
    - name: patch-app-live-view-conventions
  - name: spring-boot-conventions
    secrets:
    - name: patch-spring-boot-conventions
  - name: developer-conventions
    secrets:
    - name: patch-developer-conventions
  ```

1. Update Tanzu Application Platform by running:

  ```console
  tanzu package installed update tap -p tap.tanzu.vmware.com -v 1.7.0  --values-file tap-values.yaml -n tap-install
  ```

For information about the package customization, see [Customize your package installation](../../docs-tap/customize-package-installation.hbs.md).
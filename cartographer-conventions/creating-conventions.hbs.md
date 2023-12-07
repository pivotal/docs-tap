# Create conventions with Cartographer Conventions

This topic describes how you can create and deploy custom conventions to the Tanzu Application Platform by using Cartographer Conventions.

## <a id='intro'></a>Introduction

Tanzu Application Platform helps developers transform their code
into containerized workloads with a URL.
The Supply Chain Choreographer for Tanzu manages this transformation.
For more information, see [Supply Chain Choreographer](../scc/about.html).

[Cartographer Conventions](about.md) is a key component of the supply chain
compositions the choreographer calls into action.
Cartographer Conventions enables people in operational roles to efficiently apply
their expertise. They can specify the runtime best practices, policies, and
conventions of their organization to workloads as they are created on the platform.
The power of this component becomes evident when the conventions of an organization
are applied consistently, at scale, and without hindering the velocity of application developers.

Opinions and policies vary from organization to organization. Cartographer
Convention supports the creation of custom conventions to meet the unique operational needs
and requirements of an organization.

Before jumping into the details of creating a custom convention, you can view two
distinct components of Cartographer Conventions:

- [Convention controller](#convention-controller)
- [Convention server](#convention-server)

### <a id='convention-server'></a>Convention server

The convention server is the component that applies a convention already defined
on the server. For a golang example of creating a convention server to add
Spring Boot conventions, see
[spring-convention-server](https://github.com/vmware-tanzu/cartographer-conventions/tree/main/samples/spring-convention-server)
in GitHub. The resource that structures the request body of the
request and response from the server is the
[PodConventionContext](./reference/pod-convention-context.hbs.md).

The `PodConventionContext` is a
[webhooks.conventions.carto.run/v1alpha1](https://github.com/vmware-tanzu/cartographer-conventions/blob/main/webhook/api/v1alpha1/podconventioncontext_types.go)
type that defines the structure used to communicate internally by the webhook
convention server. It ***does not exist*** on the Kubernetes API Server.

`PodConventionContext` is  a wrapper for two types:

- `PodConventionContextSpec` which acts as a wrapper for a `PodTemplateSpec` and a list of `ImageConfigs` provided in the request body of the server.
- `PodConventionContextStatus` which is a status type used to represent the current status of the context retrieved by the request.

For information about an example `PodConventionContext`, see [PodConventionContext](https://github.com/vmware-tanzu/cartographer-conventions/blob/main/docs/podconventioncontext-sample.yaml) in GitHub.
For information about a Convention server and the structure of these types, see [OpenAPI Spec](https://github.com/vmware-tanzu/cartographer-conventions/blob/main/api/openapi-spec/conventions-server.yaml) in GitHub.

#### <a id='role-of-the-convention-server'></a>How the convention server works

Each convention server can host one or more conventions.
The application of each convention by a convention server are controlled conditionally.
The conditional criteria governing the application of a convention is customizable and are based
on the evaluation of a custom Kubernetes resource called [PodIntent](reference/pod-intent.md).
PodIntent is the vehicle by which Cartographer Conventions as a whole delivers its value.

A PodIntent is created, or updated if already existing, when a workload is run by using a Tanzu Application Platform supply chain.
The custom resource includes both the PodTemplateSpec and the OCI image metadata associated with a workload. See the [Kubernetes documentation](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-template-v1/#PodTemplateSpec).
The conditional criteria for a convention are based on any property or value found in the PodTemplateSpec or the Open Containers Initiative (OCI) image metadata available in the PodIntent.

If a convention's criteria are met, the convention server enriches the PodTemplateSpec
in the PodIntent. The convention server also updates the `status` section of the PodIntent
with the name of the convention that's applied.
You can figure out after the fact which conventions were applied to the workload.

To provide flexibility in how conventions are organized, you can deploy multiple convention servers. Each server can contain a convention or set of conventions focused on a
specific class of runtime modifications, on a specific language framework, and so on. How
the conventions are organized, grouped, and deployed is up to you and the needs of
your organization.

Convention servers deployed to the cluster does not take action unless triggered to
do so by the second component of Cartographer Conventions, the [Convention service's controller](#convention-controller).

### <a id='convention-controller'></a>Convention controller

The convention controller is the orchestrator of one or many convention servers deployed to the cluster. There are resources available on the `conventions.carto.run/v1aplha1` API that allow the controller to carry out its functions. These resources include:

  -  [ClusterPodConvention](./reference/cluster-pod-convention.hbs.md)
    `ClusterPodConvention` is a  resource type that allows the conventions author to register a webhook server with the controller using its `spec.webhook` field.

      ```yaml
      ...
      spec:
        selectorTarget: PodTemplateSpec # optional field with options, defaults to PodTemplateSpec
        selectors: # optional, defaults to match all workloads
        - <metav1.LabelSelector>
        webhook:
          certificate:
            name: sample-cert
            namespace: sample-conventions
          clientConfig:
            <admissionregistrationv1.WebhookClientConfig>
      ```

  - [PodIntent](./reference/pod-intent.hbs.md)

    `PodIntent` is a `conventions.carto.run/v1alpha1` resource type that
      is continuously reconciled and applies decorations to a workload
      `PodTemplateSpec` exposing the enriched `PodTemplateSpec` on its status.
      Whenever the status of the `PodIntent` is updated, no side effects are
      caused on the cluster.

  As key types defined on the `conventions.carto.run` API, the ClusterPodConvention` and `PodIntent` resources are both present on the
  Kubernetes API Server and are queried using
  `clusterpodconventions.conventions.carto.run` for the former and `podintents.conventions.carto.run` for the later.

#### <a id='role-of-the-controller'></a>How the convention services's controller works

When the Supply Chain Choreographer creates or updates a PodIntent for a workload, the convention
controller retrieves the OCI image metadata from the repository
containing the workload's images and sets it in the PodIntent.

The convention controller then uses a webhook architecture to pass the PodIntent to each convention
server deployed to the cluster. The controller orchestrates the processing of the PodIntent by
the convention servers sequentially, based on the `priority` value that's set on the convention server.
For more information, see [ClusterPodConvention](reference/cluster-pod-convention.html).

After all convention servers are finished processing a PodIntent for a workload,
the convention controller updates the PodIntent with the latest version of the PodTemplateSpec and sets
`PodIntent.status.conditions[].status=True` where `PodIntent.status.conditions[].type=Ready`.
This status change signals the Supply Chain Choreographer that Cartographer Conventions is finished with its work.
The status change also executes whatever steps are waiting in the supply chain.

## <a id='get-started'></a>Getting started

With this high-level understanding of Cartographer Conventions components, you can create and deploy a custom convention.

>**Note** This topic covers developing conventions using [GOLANG](https://golang.org/), but this is done using other languages by following the specifications.

### <a id='prereqs'></a>Prerequisites

The following prerequisites must be met before a convention is developed and deployed:

+ The Kubernetes command line interface tool (kubectl) CLI is installed. For more information, see the [Kubernetes documentation](https://kubernetes.io/docs/tasks/tools/).
+ Tanzu Application Platform prerequisites are installed. For more information, see [Prerequisites](../prerequisites.md)
+ Tanzu Application Platform components are installed. For more information, see the [Installing the Tanzu CLI](../install-tanzu-cli.md).
+ The default supply chain is installed. Download Supply Chain Security Tools for VMware Tanzu from [Tanzu Network](https://network.tanzu.vmware.com/products/supply-chain-security-tools/).
+ Your kubeconfig context is set to the Tanzu Application Platform-enabled cluster:

    ```console
    kubectl config use-context CONTEXT_NAME
    ```

+ You use GitHub to install the ko CLI. See the [google/ko](https://github.com/google/ko) GitHub repository. These instructions use `ko` to build an image. If there is an existing image or build process, `ko` is optional.)

## <a id='define-conv-criteria'></a> Define convention criteria

The `server.go` file contains the configuration for the server and the logic the server applies when a workload matches the defined criteria.
For example, adding a Prometheus sidecar to web applications, or adding a `workload-type=spring-boot` label to any workload that has metadata, indicating it is a Spring Boot app.

>**Important** For this example, the package `model` defines [resource types](./reference/convention-resources.md).

1. <a id='convention-1'></a> The example `server.go` configures the `ConventionHandler` to ingest the webhook requests from the convention controller. See [PodConventionContext](./reference/pod-convention-context.md). Here the handler must only deal with the existing [PodTemplateSpec](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-template-v1/#PodTemplateSpec) and [ImageConfig](./reference/image-config.md).

   ```go
   ...
   import (
      corev1 "k8s.io/api/core/v1"
   )
   ...
   func ConventionHandler(template *corev1.PodTemplateSpec, images []model.ImageConfig) ([]string, error) {
       // Create custom conventions
   }
   ...
   ```

     Where:

     + `template` is the predefined `PodTemplateSpec` that the convention edits. For more information about `PodTemplateSpec`, see the [Kubernetes documentation](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-template-v1/#PodTemplateSpec).
     + `images` are the [ImageConfig](./reference/image-config.md) used as reference to make decisions in the conventions. In this example, the type was created within the `model` package.

2. <a id='server-2'></a>The example `server.go` also configures the convention server to listen for requests:

    ```go
    ...
    import (
        "context"
        "fmt"
        "log"
        "net/http"
        "os"
        ...
    )
    ...
    func main() {
        ctx := context.Background()
        port := os.Getenv("PORT")
        if port == "" {
            port = "9000"
        }
        http.HandleFunc("/", webhook.ServerHandler(convention.ConventionHandler))
        log.Fatal(webhook.NewConventionServer(ctx, fmt.Sprintf(":%s", port)))
    }
    ...
    ```

    Where:

    + `PORT` is a possible environment variable, for this example, defined in the [Deployment](#install-deployment).
    + `ServerHandler` is the *handler* function called when any request comes to the server.
    + `NewConventionServer` is the function in charge of configuring and creating the *http webhook* server.
    + `port` is the calculated port of the server to listen for requests. It must match the [Deployment](#install-deployment) if the `PORT` variable is not defined in it.
    + The `path` or pattern (default to `/`) is the convention server's default path. If it is changed, it must be changed in the [ClusterPodConvention](#install-convention).

>**Note** The *Server Handler*, `func ConventionHandler(...)`, and the configure or start web server, `func NewConventionServer(...)`, is defined in the convention controller in the `webhook` package, but you can use a custom one.

1. Creating the *Server Handler*, which handles the request from the convention controller with the [PodConventionContext](./reference/pod-convention-context.md) serialized to JSON.

    ```go
    package webhook
    ...
    func ServerHandler(conventionHandler func(template *corev1.PodTemplateSpec, images []model.ImageConfig) ([]string, error)) http.HandlerFunc {
        return func(w http.ResponseWriter, r *http.Request) {
            ...
            // Check request method
            ...
            // Decode the PodConventionContext
            podConventionContext := &model.PodConventionContext{}
            err = json.Unmarshal(body, &podConventionContext)
            if err != nil {
                w.WriteHeader(http.StatusBadRequest)
                return
            }
            // Validate the PodTemplateSpec and ImageConfig
            ...
            // Apply the conventions
            pts := podConventionContext.Spec.Template.DeepCopy()
            appliedConventions, err := conventionHandler(pts, podConventionContext.Spec.Images)
            if err != nil {
                w.WriteHeader(http.StatusInternalServerError)
                return
            }
            // Update the applied conventions and status with the new PodTemplateSpec
            podConventionContext.Status.AppliedConventions = appliedConventions
            podConventionContext.Status.Template = *pts
            // Return the updated PodConventionContext
            w.Header().Set("Content-Type", "application/json")
            w.WriteHeader(http.StatusOK)
            json.NewEncoder(w).Encode(podConventionContext)
        }
    }
    ...
    ```

1. Configure and start the web server by defining the `NewConventionServer` function, which starts the server with the defined port and current context. The server uses the `.crt` and `.key` files to handle *TLS* traffic.

    ```go
    package webhook
    ...
    // Watch handles the security by certificates.
    type certWatcher struct {
        CrtFile string
        KeyFile string

        m       sync.Mutex
        keyPair *tls.Certificate
    }
    func (w *certWatcher) Load() error {
        // Creates a X509KeyPair from PEM encoded client certificate and private key.
        ...
    }
    func (w *certWatcher) GetCertificate() *tls.Certificate {
        w.m.Lock()
        defer w.m.Unlock()

        return w.keyPair
    }
    ...
    func NewConventionServer(ctx context.Context, addr string) error {
        // Define a health check endpoint to readiness and liveness probes.
        http.HandleFunc("/healthz", func(w http.ResponseWriter, r *http.Request) {
            w.WriteHeader(http.StatusOK)
        })

        if err := watcher.Load(); err != nil {
            return err
        }
        // Defines the server with the TLS configuration.
        server := &http.Server{
            Addr: addr,
            TLSConfig: &tls.Config{
                GetCertificate: func(_ *tls.ClientHelloInfo) (*tls.Certificate, error) {
                    cert := watcher.GetCertificate()
                    return cert, nil
                },
                PreferServerCipherSuites: true,
                MinVersion:               tls.VersionTLS13,
            },
            BaseContext: func(_ net.Listener) context.Context {
                return ctx
            },
        }
        go func() {
            <-ctx.Done()
            server.Close()
        }()

        return server.ListenAndServeTLS("", "")
    }
    ```

## <a id='define-conv-behavior'></a> Define the convention behavior

Any property or value within the PodTemplateSpec or OCI image metadata associated with a workload defines the criteria for applying conventions. See [PodTemplateSpec](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-template-v1/#PodTemplateSpec) in the Kubernetes documentation. The following are a few examples.

### <a id='match-crit-labels-annot'></a> Matching criteria by labels or annotations

The `conventions.carto.run/v1alpha1` API allows convention authors to use the `selectorTarget` field which complements the `ClusterPodConvention` matchers to specify whether to consider labels on either one of the following available options:

+ PodTemplateSpec

    ```yaml
      ...
      template:
        metadata:
          labels:
            awesome-label: awesome-value
          annotations:
            awesome-annotation: awesome-value
      ...
    ```

+ PodIntent

    ```yaml
        ...
        kind: PodIntent
        metadata:
          name: test-pod
          labels:
            environment: production
            ...
    ```

The `selectorTarget` field is configured on the ClusterPodConvention as follows:

```yaml
...
spec:
  selectorTarget: PodIntent # optional, defaults to PodTemplateSpec
  selectors: # optional, defaults to match all workloads
  - <metav1.LabelSelector>
  webhook:
    certificate:
      name: sample-cert
      namespace: sample-conventions
    clientConfig:
      <admissionregistrationv1.WebhookClientConfig>
```

If you do not provide a value for this optional field while using the `conventions.carto.run/v1alpha1` API,
the default value is set to `PodTemplateSpec` without the conventions author explicitly doing so. 

### <a id='match-criteria-env-var'></a> Matching criteria by environment variables

When using environment variables to define whether the convention is applicable, it must be present in the [PodTemplateSpec](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-template-v1/#PodTemplateSpec), [spec](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#PodSpec), [containers](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#Container), and [env](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#environment-variables) to validate the value.

+ PodTemplateSpec

    ```yaml
    ...
    template:
      spec:
        containers:
          - name: awesome-container
            env:
    ...
    ```

+ Handler

    ```go
    package convention
    ...
    func conventionHandler(template *corev1.PodTemplateSpec, images []model.ImageConfig) ([]string, error) {
        if len(template.Spec.Containers[0].Env) == 0 {
            template.Spec.Containers[0].Env = append(template.Spec.Containers[0].Env, corev1.EnvVar{
                Name: "MY_AWESOME_VAR",
                Value: "MY_AWESOME_VALUE",
            })
            return []string{"awesome-envs-convention"}, nil
        }
        return []string{}, nil
        ...
    }
    ```

### <a id='match-crit-img-metadata'></a>Matching criteria by image metadata

For each image contained within the PodTemplateSpec, the convention controller fetches the OCI image metadata and known [bill of materials (BOMs)](reference/bom.md), providing it to the convention server as [ImageConfig](./reference/image-config.md). This metadata is introspected to make decisions about how to configure the PodTemplateSpec.

## <a id='install'></a> Configure and install the convention server

The `server.yaml` defines the Kubernetes components that enable the convention server in the cluster. The next definitions are within the file.

1. <a id='install-namespace'></a>A `namespace` is created for the convention server components and has the required objects to run the server. It's used in the [ClusterPodConvention](#install-convention) section to indicate to the controller where the server is.

    ```yaml
    ...
    ---
    apiVersion: v1
    kind: Namespace
    metadata:
      name: awesome-convention
    ---
    ...
    ```

2. <a id='install-cm'></a>(Optional) A certificate manager `Issuer` is created to issue the> certificate needed for TLS communication.

    ```yaml
    ...
    ---
    # The following manifests contain a self-signed issuer CR and a certificate CR.
    # More document can be found at https://docs.cert-manager.io
    apiVersion: cert-manager.io/v1
    kind: Issuer
    metadata:
      name: awesome-selfsigned-issuer
      namespace: awesome-convention
    spec:
      selfSigned: {}
    ---
    ...
    ```

3. <a id='install-cert'></a>(Optional) A self-signed `Certificate` is created.

    ```yaml
    ...
    ---
    apiVersion: cert-manager.io/v1
    kind: Certificate
    metadata:
      name: awesome-webhook-cert
      namespace: awesome-convention
    spec:
      subject:
        organizations:
        - vmware
        organizationalUnits:
        - tanzu
      commonName: awesome-webhook.awesome-convention.svc
      dnsNames:
      - awesome-webhook.awesome-convention.svc
      - awesome-webhook.awesome-convention.svc.cluster.local
      issuerRef:
        kind: Issuer
        name: awesome-selfsigned-issuer
      secretName: awesome-webhook-cert
      revisionHistoryLimit: 10
    ---
    ...
    ```

4. <a id='install-deployment'></a>A Kubernetes `Deployment` is created to run the webhook from. The [Service](#install-service) uses the container port defined by the `Deployment` to expose the server.

    ```yaml
    ...
    ---
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: awesome-webhook
      namespace: awesome-convention
    spec:
      replicas: 1
      selector:
        matchLabels:
        app: awesome-webhook
      template:
        metadata:
          labels:
            app: awesome-webhook
        spec:
          containers:
          - name: webhook
            # Set the prebuilt image of the convention or use ko to build an image from code.
            # see https://github.com/google/ko
            image: ko://awesome-repo/awesome-user/awesome-convention
          env:
          - name: PORT
            value: "8443"
          ports:
          - containerPort: 8443
            name: webhook
          livenessProbe:
            httpGet:
              scheme: HTTPS
              port: webhook
              path: /healthz
          readinessProbe:
            httpGet:
              scheme: HTTPS
              port: webhook
              path: /healthz
          volumeMounts:
          - name: certs
            mountPath: /config/certs
            readOnly: true
        volumes:
        - name: certs
          secret:
            defaultMode: 420
            secretName: awesome-webhook-cert
    ---
    ...
    ```

5. <a id='install-service'></a>A Kubernetes `Service` to expose the convention deployment is created. For this example, the exposed port is the default `443`. If you change the port, the [ClusterPodConvention](#install-convention) must be updated.

    ```yaml
    ...
    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: awesome-webhook
      namespace: awesome-convention
      labels:
        app: awesome-webhook
    spec:
      selector:
        app: awesome-webhook
      ports:
        - protocol: TCP
          port: 443
          targetPort: webhook
    ---
    ...
    ```

6. <a id='install-convention'></a>The [ClusterPodConvention](./reference/cluster-pod-convention.md) adds the convention to the cluster to make it available for the convention controller:
    >**Important** The `annotations` block is only needed if you use a self-signed certificate. See the [cert-manager documentation](https://cert-manager.io/docs/).

    ```yaml
    ...
    ---
    apiVersion: conventions.carto.run/v1alpha1
    kind: ClusterPodConvention
    metadata:
      name: awesome-convention
      annotations:
        conventions.carto.run/inject-ca-from: "awesome-convention/awesome-webhook-cert"
    spec:
      webhook:
        clientConfig:
          service:
            name: awesome-webhook
            namespace: awesome-convention
            # path: "/" # default
            # port: 443 # default
    ```

## <a id="deploy-convention-server"></a> Deploy a convention server

To deploy a convention server:

1. Build and install the convention.

    - To build and deploy the convention, use the [ko tool](https://github.com/google/ko) on GitHub. It compiles your Go code into a Docker image and pushes it to the registry `KO_DOCKER_REGISTRY`.

        ```console
        ko apply -f dist/server.yaml
        ```

    - If a different tool builds the image, the configuration is also applied by using either kubectl or `kapp`, setting the correct image in the [Deployment](#install-convention) descriptor.

       kubectl

        ```console
        kubectl apply -f server.yaml
        ```

       kapp

        ```console
        kapp deploy -y -a awesome-convention -f server.yaml
        ```

2. Verify the convention server.
To verify the status of the convention server, confirm the running convention pods:

    + If the server is running, `kubectl get all -n awesome-convention` returns output such as:

        ```text
        NAME                                       READY   STATUS    RESTARTS   AGE
        pod/awesome-webhook-1234567890-12345       1/1     Running   0          8h

        NAME                          TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE
        service/awesome-webhook       ClusterIP   10.56.12.49   <none>        443/TCP   28h

        NAME                                  READY   UP-TO-DATE   AVAILABLE   AGE
        deployment.apps/awesome-webhook       1/1     1            1           28h

        NAME                                             DESIRED   CURRENT   READY   AGE
        replicaset.apps/awesome-webhook-1234563213       0         0         0       23h
        replicaset.apps/awesome-webhook-5b79d5cb59       0         0         0       28h
        replicaset.apps/awesome-webhook-5bf557c9f8       1         1         1       20h
        replicaset.apps/awesome-webhook-77c647c987       0         0         0       23h
        replicaset.apps/awesome-webhook-79d9c6f74c       0         0         0       23h
        replicaset.apps/awesome-webhook-7d9d667b8d       0         0         0       9h
        replicaset.apps/awesome-webhook-8668664d75       0         0         0       23h
        replicaset.apps/awesome-webhook-9b6957476        0         0         0       24h
        ```

    + To verify that the conventions are applied, ensure that the `PodIntent` of a workload that matches the convention criteria:

        ```console
        kubectl -o yaml get podintents.conventions.apps.tanzu.vmware.co awesome-app
        ```

        ```yaml
        apiVersion: conventions.carto.run/v1alpha1
        kind: PodIntent
        metadata:
          creationTimestamp: "2021-10-07T13:30:00Z"
          generation: 1
          labels:
            app.kubernetes.io/component: intent
            carto.run/cluster-supply-chain-name: awesome-supply-chain
            carto.run/cluster-template-name: convention-template
            carto.run/component-name: config-provider
            carto.run/template-kind: ClusterConfigTemplate
            carto.run/workload-name: awesome-app
            carto.run/workload-namespace: default
          name: awesome-app
          namespace: default
        ownerReferences:
        - apiVersion: carto.run/v1alpha1
          blockOwnerDeletion: true
          controller: true
          kind: Workload
          name: awesome-app
          uid: "********"
        resourceVersion: "********"
        uid: "********"
        spec:
        imagePullSecrets:
          - name: registry-credentials
            serviceAccountName: default
            template:
              metadata:
                annotations:
                  developer.conventions/target-containers: workload
                labels:
                  app.kubernetes.io/component: run
                  app.kubernetes.io/part-of: awesome-app
                  carto.run/workload-name: awesome-app
              spec:
                containers:
                - image: awesome-repo.com/awesome-project/awesome-app@sha256:********
                  name: workload
                  resources: {}
                  securityContext:
                  runAsUser: 1000
        status:
          conditions:
          - lastTransitionTime: "2021-10-07T13:30:00Z"
            status: "True"
            type: ConventionsApplied
          - lastTransitionTime: "2021-10-07T13:30:00Z"
            status: "True"
            type: Ready
        observedGeneration: 1
        template:
          metadata:
            annotations:
              awesome-annotation: awesome-value
              conventions.carto.run/applied-conventions: |-
                awesome-label-convention
                awesome-annotation-convention
                awesome-envs-convention
                awesome-image-convention
                developer.conventions/target-containers: workload
            labels:
              awesome-label: awesome-value
              app.kubernetes.io/component: run
              app.kubernetes.io/part-of: awesome-app
              carto.run/workload-name: awesome-app
              conventions.carto.run/framework: go
          spec:
            containers:
            - env:
              - name: MY_AWESOME_VAR
                value: "MY_AWESOME_VALUE"
              image: awesome-repo.com/awesome-project/awesome-app@sha256:********
              name: workload
              ports:
                - containerPort: 8080
                  protocol: TCP
              resources: {}
              securityContext:
                runAsUser: 1000
        ```

## <a id='next-steps'></a> Next Steps

Keep Exploring:

+ Try to use different matching criteria for the conventions or enhance the supply chain with multiple conventions.

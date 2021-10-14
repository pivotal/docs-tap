# <a id='Creating'></a> Creating a Convention Server

This document describes how to create a convention server with example conventions. The convention server is a component of the [Convention Service](about.md). 

## <a id='prereqs'></a>Before you begin

+ Kubectl has been installed [guide](https://kubernetes.io/docs/tasks/tools/)
+ Tanzu Application Platform components have been installed on a k8s cluster [guide](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/0.1/tap-0-1/GUID-install.html)
+ The [default supply chain](https://network.tanzu.vmware.com/products/default-supply-chain/) is installed
+ Your kubeconfig context has been set to the prepared cluster `kubectl config use-context CONTEXT_NAME`


## <a id='conventionservice'></a> About the convention servers

The Tanzu Application Platform beta includes tools that enable developers to quickly begin building and testing applications regardless of their familiarity with Kubernetes. Developers can turn source code into a workload running in a container with a URL in minutes. The Convention service ensures those workloads adhere to the operational standards of an organization. A convention server can contain one or many conventions. 

## <a id='gettingstarted'></a> Getting started 

With the convention controller installed, a convention can be defined.

The current version of the convention controller supports `webhook` conventions, then it will run as a webserver.

_NOTE: this example covers developing conventions with [GOLANG](https://golang.org/) but it can be done in other languages by following the specs._

The webserver convention consumes the [PodTemplateSpec](https://v1-18.docs.kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#podtemplatespec-v1-core) and the collection of ImageConfig in `JSON` format and produces a collection of `string` with the name, or description of the applied conventions or `error` if something went wrong 


1. <a id='create-1'></a>Start defining the ConventionHandler for the `webhook` request from the *convention controller*

    ```go
    ...
    import (
        "github.com/vmware-tanzu/convention-controller/webhook"
        corev1 "k8s.io/api/core/v1"
    ) 
    ...
    func conventionHandler(template *corev1.PodTemplateSpec, images []webhook.ImageConfig) ([]string, error) {
        // DO COOL STUFF
    }
    ...
    ```
    
     Where:

     + `template` is the predefined [PodTemplateSpec](https://v1-18.docs.kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#podtemplatespec-v1-core) that the convention is going to modify
     + `images` are the images defined within the given workload

2. <a id='create-2'></a>Set the server to listen the request
    ```go
    ...
    import (
        "context"
        "fmt"
        "log"
        "net/http"
        "os"

    )
    ...
    func main() {
        ctx := context.Background()
        port := os.Getenv("PORT")
        if port == "" {
            port = "9000"
        }
        http.HandleFunc("/", webhook.ConventionHandler(conventionHandler))
        log.Fatal(webhook.NewConventionServer(ctx, fmt.Sprintf(":%s", port)))
    }
    ...
    ```

    Where:

    + `PORT` is a possible environment variable
    + `conventionHandler` is the *handler* defined in [last step](#create-1)     

## <a id='targeting'></a> Define the convention behavior

Once the convention has been defined, you can specify the attributes that determine if a convention is applied to a workload. Any property or value within the `PodTemplateSpec` or OCI image metadata associated with a [workload](../scc/reference.md#workload) can be used to define the criteria for applying conventions. The following are a few examples. 

### By Labels or Annotations:

When using labels or annotations to define whether a convention should be applied, the server will check the [PodTemplateSpec](https://v1-18.docs.kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#podtemplatespec-v1-core) of workloads. 
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

   + Handler

        ```go
        ...
        func conventionHandler(template *corev1.PodTemplateSpec, images []webhook.ImageConfig) ([]string, error) {
            c:= []string{}
            // This convention will be appled if a specific label is present
            if lv, le := template.Labels["awesome-label"]; le && lv == "awesome-value" {
                // DO COOl STUFF
                c = append(c, "awesome-label-convention")
            }
            // This convention will be appled if a specific annotation is present
            if av, ae := template.Annotations["awesome-annotation"]; ae && av == "awesome-value" {
                // DO COOl STUFF
                c = append(c, "awesome-annotation-convention")
            }
            
            return c, nil
        }
        ...
        ```
    
 Where:
 + `conventionHandler` is the *handler*
 + `awesome-label` is the **label** that we want to validate
 + `awesome-annotation` is the **annotation** that we want to validate
 + `awesome-value` is the value that must have the **label**/**annotation**

### <a id='EnvironmentVariables'></a>By Environment variables

When using environment variables to define whether the convention is applicable or not, it should be present in the [PodTemplateSpec](https://v1-18.docs.kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#podtemplatespec-v1-core).[spec](https://v1-18.docs.kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#podspec-v1-core).[containers](https://v1-18.docs.kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#container-v1-core)[*].[env](https://v1-18.docs.kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#envvar-v1-core). and we can validate the value.

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
        ...
        func conventionHandler(template *corev1.PodTemplateSpec, images []webhook.ImageConfig) ([]string, error) {
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

### <a id='ImageMetadata'></a>By Image metadata
The convention controller should be used with [OCI Image](https://github.com/opencontainers/image-spec) so it can be used to get metadate information. The ImageConfig is an struct that contains the configuration of an image, similar to the output of `docker inspect hello-world`.

## <a id='install'></a> Configure and install the new convention server

Once the convention has been written, define the following components in `server.yaml`. 

1. **Create the `namespace` for the new convention server to operate from**
    
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
2. **Create the cert manager [`Issuer`](https://cert-manager.io/docs/concepts/issuer/), which is used to issue the cert needed for TLS communication.**

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
3. **Create the certificate [`Certificate`](https://cert-manager.io/docs/concepts/certificate/)**
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

4. **Create the `Deployment` for the convention. This is where the webhook will run from.**
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
            # Set the prebuilt image of the convention or use ko to build an image from code
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

5. **Create the `Service` to expose the convention deployment.**
    ```yaml
    ...
    ---
    apiVersion: v1
    kind: Service
    metadata:
    name: awesome-webhook
    namespace: awesome-convention
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
6. **Create the ClusterPodConvention to add the new convention to the convention service** 

    ```yaml
    ...
    ---
    apiVersion: conventions.apps.tanzu.vmware.com/v1alpha1
    kind: ClusterPodConvention
    metadata:
    name: awesome-convention
    annotations:
        conventions.apps.tanzu.vmware.com/inject-ca-from: "awesome-convention/awesome-webhook-cert"
    spec:
    webhook:
        clientConfig:
        service:
            name: awesome-webhook
            namespace: awesome-convention
    ```

7. **Build and install the convention**

    + If the convention needs to be built and deployed, use the [ko](https://github.com/google/ko) tool to do so
    
        ```bash
        ko apply -f server.yaml
        ```

    + If you are using a previously built image, apply the configuration using either 
    
       kubectl
        ```bash
        kubectl apply -f server.yaml
        ```
       kapp
        ```bash
        kapp deploy -a awesome-convention -f server.yaml 
        ```

8. **Verify the convention server is running by checking for the convention pods**
    
    + Running `kubectl get all -n awesome-app` should return something like ...
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

    + Verify the conventions are being applied by checking the PodIntent for a workload that matches the convention criteria.
        ```bash
        kubectl -o yaml get podintents.conventions.apps.tanzu.vmware.co awesome-app
        ```

        ```yaml
        apiVersion: conventions.apps.tanzu.vmware.com/v1alpha1
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
                conventions.apps.tanzu.vmware.com/applied-conventions: |-
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
                conventions.apps.tanzu.vmware.com/framework: go
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

Keep exploring:

* Try to use different matching criteria for the conventions or enhance the supply chain with multiple conventions



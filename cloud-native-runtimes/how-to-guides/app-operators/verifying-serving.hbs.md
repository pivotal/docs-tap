# Verify Knative Serving for Cloud Native Runtimes

This topic tells you how to verify that Knative Serving was installed for Cloud Native Runtimes, commonly known as CNR.

## About Verifying Knative Serving

To verify that Knative Serving was installed, create an example Knative service
and test it.

The following procedure shows you how to create an example Knative service using the Cloud Native Runtimes sample app,
`hello-yeti`.
This sample is custom built for Cloud Native Runtimes and is stored in the VMware Harbor registry.

> **Note** If you do not have access to the Harbor registry,
you can use the [Hello World - Go](https://knative.dev/docs/serving/samples/hello-world/helloworld-go/)
sample app in the Knative documentation.

## Prerequisites

Before you verify Knative Serving, you must have a namespace where you want to deploy Knative services. This namespace is referred to as `${WORKLOAD_NAMESPACE}` in this tutorial. See [Verifying Your Installation](./verify-installation.hbs.md).

## <a id='test-knative-serving-1'></a> Test Knative Serving

To create an example Knative service and use it to test Knative Serving:

1. If you are verifying on Tanzu Mission Control or vSphere 7.0 with Tanzu, then create a role binding
   in the `${WORKLOAD_NAMESPACE}` namespace. Run:
    
    ```console
    kubectl apply -n "${WORKLOAD_NAMESPACE}" -f - << EOF
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      name: ${WORKLOAD_NAMESPACE}-psp
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: cnr-restricted
    subjects:
    - kind: Group
      name: system:serviceaccounts:${WORKLOAD_NAMESPACE}
    EOF
    ```

2. Deploy the sample app using the `kn` CLI. Run:
    
    ```console
    kn service create hello-yeti -n ${WORKLOAD_NAMESPACE} \
      --image projects.registry.vmware.com/tanzu_serverless/hello-yeti@sha256:17d640edc48776cfc604a14fbabf1b4f88443acc580052eef3a753751ee31652 --env TARGET='hello-yeti'
    ```
   If you are verifying on Tanzu Mission Control or vSphere 7.0 with Tanzu, add `--user 1001` to the command above to run it as a non-root user.

3. Run one of these commands to retrieve the external address for your ingress, depending on your IaaS:

    |           ||
    |-----------|--------------------------------------------------------------------------------------------------------------------------------------------|
    | **IaaS:** | <ul><li>Tanzu Kubernetes Grid on AWS</li><li>Tanzu Mission Control on AWS</li><li>Amazon Elastic Kubernetes Service</li></ul>              |
    | **Run:**      | ```export EXTERNAL_ADDRESS=$(kubectl get service envoy -n tanzu-system-ingress -ojsonpath="{.status.loadBalancer.ingress[0].hostname}")``` |

    |       ||
    |-------|--------------------------------------------------------------------------------------------------------------------------------------------|
    | **IaaS:** | <ul><li>vSphere 7.0 on Tanzu</li><li>Tanzu Kubernetes Grid on vSphere/Azure/GCP</li><li>Tanzu Kubernetes Grid Integrated Edition</li><li>Tanzu Mission Control on vSphere</li><li>Azure Kubernetes Service</li><li>Google Kubernetes Engine</li></ul>              |
    | **Run:**  | ```export EXTERNAL_ADDRESS=$(kubectl get service envoy -n tanzu-system-ingress -ojsonpath="{.status.loadBalancer.ingress[0].ip}")``` |

    |       ||
    |-------|--------------------------------------------------------------------------------------------------------------------------------------------|
    | **IaaS:** | <ul><li>Docker desktop</li><li>Minikube</li></ul>              |
    | **Run:**  | ```export EXTERNAL_ADDRESS='localhost:8080'```<br/>And set up port-forwarding in a separate terminal:<br/> ```kubectl -n tanzu<!--฿ The brand is |Tanzu|. ฿-->-system-ingress port-forward svc/envoy 8080:80```|

4. Connect to the app.
   Verify the URL for the knative service.

   Run:

    ```console
   kn service list -n ${WORKLOAD_NAMESPACE}
   ```

   The result is something like this:
   
   ```console
   NAME           URL                                                          LATEST               AGE   CONDITIONS   READY   REASON
   hello-yeti     https://hello-yeti.${WORKLOAD_NAMESPACE}.svc.cluster.local   hello-yeti-00001     6s    3 OK / 3     True
   ```
   
   Now, take the host name from the URL and set it in an environment variable `KSERVICE_HOSTNAME` like so:
    
    ```console
    export KSERVICE_HOSTNAME="hello-yeti.${WORKLOAD_NAMESPACE}.svc.cluster.local"
    ```
   
   Then, connect to the app:
   
   ```console
   curl https://${KSERVICE_HOSTNAME} -k --resolve ${KSERVICE_HOSTNAME}:443:${EXTERNAL_ADDRESS}
   ```

   > **Note** If you configured DNS locally by using `/etc/hosts` or externally, the `--resolve` flag is omitted, 
   > or you can use a web browser.

    On success, you see a reply from our mascot, Carl the Yeti.

## Delete the Example Knative Service

After verifying your serving installation, delete the example Knative service and unset the environment variable:

1. Run:
    
    ```console
    kn service delete hello-yeti -n ${WORKLOAD_NAMESPACE}
    unset EXTERNAL_ADDRESS
    unset KSERVICE_HOSTNAME
    ```

2. If you created port forwarding in step 3, terminate that process.

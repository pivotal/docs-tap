# Verify Your Installation

This topic tells you how to verify your Cloud Native Runtimes, commonly known as CNRs, installation.
You can verify that your Cloud Native Runtimes installation was successful by testing Knative Serving.

## <a id='prerecs'></a> Prerequisites

1. Create a namespace and environment variable where you want to create Knative services. Run:
   >**Note** This step covers configuring a namespace to run Knative services.
   >If you rely on a SupplyChain to deploy Knative services into your cluster,
   >skip this step because namespace configuration is covered when
   >developer namespaces are set up to use installed packages. 
   >For more information, see [Set up developer namespaces to use your installed packages](../../../install-online/set-up-namespaces.hbs.md). 
   >Otherwise, you must complete the following steps for each namespace where you create Knative services.

    ```console
    export WORKLOAD_NAMESPACE='cnr-demo'
    kubectl create namespace ${WORKLOAD_NAMESPACE}
    ```

2. Configure a namespace to use Cloud Native Runtimes. If you relocated images to another registry during Tanzu Application Platform installation, you must grant service accounts that run Knative services using Cloud Native Runtimes access to the image pull secrets. This includes the `default` service account in a namespace, which is created automatically but not associated with any image pull secrets. Without these credentials, attempts to start a service fail with a timeout and the pods report that they are unable to pull the `queue-proxy` image.

    1. Create an image pull secret in the namespace that Knative services run and fill it from the `tap-registry` secret mentioned in [Add the Tanzu Application Platform package repository](../../../install-online/profile.hbs.md#add-tap-repo). Run the following commands to create an empty secret and annotate it as a target of the secretgen controller:

        ```console
        kubectl create secret generic pull-secret --from-literal=.dockerconfigjson={} --type=kubernetes.io/dockerconfigjson -n ${WORKLOAD_NAMESPACE}

        kubectl annotate secret pull-secret secretgen.carvel.dev/image-pull-secret="" -n ${WORKLOAD_NAMESPACE}
        ```

    2. After you create a `pull-secret` secret in the same namespace as the service account,
    run the following command to add the secret to the service account:

        ```console
        kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "pull-secret"}]}' -n ${WORKLOAD_NAMESPACE}
        ```

    3. Verify that a service account is correctly configured by running:

        ```console
        kubectl describe serviceaccount default -n ${WORKLOAD_NAMESPACE}
        ```

        For example:

        ```console
        kubectl describe sa default -n cnr-demo
        Name:                default
        Namespace:           cnr-demo
        Labels:              <none>
        Annotations:         <none>
        Image pull secrets:  pull-secret
        Mountable secrets:   default-token-xh6p4
        Tokens:              default-token-xh6p4
        Events:              <none>
        ```

        The service account has access to the `pull-secret` image pull secret.

Verify that `STATUS` is `Reconcile succeeded`.

## <a id='verify-serving'></a> Verify Knative Serving installation

To verify the installation of Knative Serving

1. Create a namespace and environment variable for the test. Run:

    ```console
    export WORKLOAD_NAMESPACE='cnr-demo'
    kubectl create namespace ${WORKLOAD_NAMESPACE}
    ```

2. Test Knative Serving by creating a test service. See [Verifying Knative Serving](./verifying-serving.hbs.md).

3. Delete the namespace that you created for the demo. Run:

    ```console
    kubectl delete namespaces ${WORKLOAD_NAMESPACE}
    unset WORKLOAD_NAMESPACE
    ```

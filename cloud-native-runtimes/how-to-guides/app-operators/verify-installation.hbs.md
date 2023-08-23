# Verifying Your Installation

This topic tells you how to verify your Cloud Native Runtimes, commonly known as CNR, installation.
You can verify that your Cloud Native Runtimes installation was successful by testing Knative Serving.

## Prerequisites

1. Create a namespace and environment variable where you want to create Knative services. Run:
   >**Note:** This step covers configuring a namespace to run Knative services.
   >If you rely on a SupplyChain to deploy Knative services into your cluster,
   >skip this step because namespace configuration is covered in
   >[Set up developer namespaces to use installed packages](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.5/tap/install-online-set-up-namespaces.html).
   >Otherwise, you must complete the following steps for each namespace where you create Knative services.

    ```
    export WORKLOAD_NAMESPACE='cnr-demo'
    kubectl create namespace ${WORKLOAD_NAMESPACE}
    ```

1. Configure a namespace to use Cloud Native Runtimes. If during the Tanzu Application Platform installation you relocated images to another registry, you must grant service accounts that run Knative services using Cloud Native Runtimes access to the image pull secrets. This includes the `default` service account in a namespace, which is created automatically but not associated with any image pull secrets. Without these credentials, attempts to start a service fail with a timeout and the pods report that they are unable to pull the `queue-proxy` image.

    1. Create an image pull secret in the namespace Knative services will run and fill it from the `tap-registry` secret mentioned in [Add the Tanzu Application Platform package repository](https://docs.vmware.com/en/Tanzu-Application-Platform/1.6/tap/install-intro.html).  Run the following commands to create an empty secret and annotate it as a target of the secretgen controller:

        ```
        kubectl create secret generic pull-secret --from-literal=.dockerconfigjson={} --type=kubernetes.io/dockerconfigjson -n ${WORKLOAD_NAMESPACE}

        kubectl annotate secret pull-secret secretgen.carvel.dev/image-pull-secret="" -n ${WORKLOAD_NAMESPACE}
        ```

    1. After you create a `pull-secret` secret in the same namespace as the service account,
    run the following command to add the secret to the service account:

        ```
        kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "pull-secret"}]}' -n ${WORKLOAD_NAMESPACE}
        ```

    1. Verify that a service account is correctly configured by running:

        ```
        kubectl describe serviceaccount default -n ${WORKLOAD_NAMESPACE}
        ```

        For example:

        ```
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

## Verify Installation of Knative Serving

To verify the installation of Knative Serving

1. Create a namespace and environment variable for the test. Run:

    ```sh
    export WORKLOAD_NAMESPACE='cnr-demo'
    kubectl create namespace ${WORKLOAD_NAMESPACE}
    ```

2. Verify installation of the components that you intend to use:

    | To test…         | Create…                              | For instructions, see…                                  |
    | -----------------|--------------------------------------|---------------------------------------------------------|
    | Knative Serving  | a test service                       | [Verifying Knative Serving](./verifying-serving.hbs.md)     |

3. Delete the namespace that you created for the demo. Run:

    ```sh
    kubectl delete namespaces ${WORKLOAD_NAMESPACE}
    unset WORKLOAD_NAMESPACE
    ```

# Verify Knative Eventing

This topic tells you how to verify that Knative Eventing was successfully installed with the Eventing for TAP package.

## About Verifying Knative Eventing

You can verify Knative Eventing by setting up a broker, creating a producer, and creating a consumer.
If your installation was successful, you can create a test eventing workflow and see that the events appear in the logs.

You can use either an in-memory broker or a RabbitMQ broker to verify Knative Eventing:

- **RabbitMQ broker**: Using a RabbitMQ broker to verify Knative Eventing is a scalable and reliable way to verify your installation. Verifying with RabbitMQ uses methods similar to production environments.

- **In-memory broker**: Using an in-memory broker is a fast and lightweight way to verify that the basic elements of Knative Eventing are installed. An in-memory broker is not meant for production environments or for use with apps that you intend to take to production.

## Prerequisites

Before you verify Knative Eventing, you must:

* Have a namespace where you want to deploy your Knative resources. This namespace will be referred as `${WORKLOAD_NAMESPACE}` in this tutorial. See step 1 of [Verifying Eventing Installation](verify-installation.hbs.md) for more information.

* Create the following role binding in the `${WORKLOAD_NAMESPACE}` namespace. Run:
    ```sh
    cat <<EOF | kubectl apply -f -
    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      name: ${WORKLOAD_NAMESPACE}-psp
      namespace: ${WORKLOAD_NAMESPACE}
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: eventing-restricted
    subjects:
    - kind: Group
      name: system:serviceaccounts:${WORKLOAD_NAMESPACE}
    EOF
    ```

## Prepare the RabbitMQ Environment

If you are using a RabbitMQ broker to verify Knative Eventing, follow the procedure in this section.
If you are verifying with the in-memory broker, skip to [Verify Knative Eventing](#verify).

To prepare the RabbitMQ environment before verifying Knative Eventing:

1. Set up the RabbitMQ integration as described in [Configuring Eventing with RabbitMQ](rabbitmq.md).

2. On the Kubernetes cluster where Eventing is installed,
   deploy a RabbitMQ cluster using the RabbitMQ Cluster Operator by running:
    ```sh
    cat <<EOF | kubectl apply -f -
    apiVersion: rabbitmq.com/v1beta1
    kind: RabbitmqCluster
    metadata:
      name: my-rabbitmq
      namespace: ${WORKLOAD_NAMESPACE}
    spec:
      replicas: 1
      override:
        statefulSet:
          spec:
            template:
              spec:
                securityContext: {}
                containers:
                - name: rabbitmq
                  env:
                   - name: ERL_MAX_PORTS
                     value: "4096"
                initContainers:
                - name: setup-container
                  securityContext:
                    runAsUser: 999
                    runAsGroup: 999
    EOF
    ```
  > **Note:** The `override` section can be omitted if your cluster allows containers to run as `root`.

3. Create a RabbitmqBrokerConfig
    ```sh
    cat <<EOF | kubectl apply -f -
    apiVersion: eventing.knative.dev/v1alpha1
    kind: RabbitmqBrokerConfig
    metadata:
       name: default-config
       namespace: ${WORKLOAD_NAMESPACE}
    spec:
      rabbitmqClusterReference:
         name: my-rabbitmq
         namespace: ${WORKLOAD_NAMESPACE}
      queueType: quorum
    EOF
    ```

## <a id="verify"></a> Verify Knative Eventing

To verify installation of Knative Eventing create and test a broker, procedure, and consumer
in the `${WORKLOAD_NAMESPACE}` namespace:

1. Create a broker.

    For the RabbitMQ broker. Run:
    ```sh
    cat <<EOF | kubectl apply -f -
    apiVersion: eventing.knative.dev/v1
    kind: Broker
    metadata:
      name: default
      namespace: ${WORKLOAD_NAMESPACE}
      annotations:
        eventing.knative.dev/broker.class: RabbitMQBroker
    spec:
      config:
        apiVersion: eventing.knative.dev/v1alpha1
        kind: RabbitmqBrokerConfig
        name: default-config
        namespace: ${WORKLOAD_NAMESPACE}
    EOF
    ```

    For the in-memory broker. Run:
    ```sh
    cat <<EOF | kubectl create -f -
    apiVersion: eventing.knative.dev/v1
    kind: Broker
    metadata:
      name: default
      namespace: ${WORKLOAD_NAMESPACE}
    EOF
    ```

2. Create a consumer for the events. Run:
    ```sh
    cat <<EOF | kubectl create -f -
    ---
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      labels:
        app: event-display
      name: event-display
      namespace: ${WORKLOAD_NAMESPACE}
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: event-display
      template:
        metadata:
          labels:
            app: event-display
        spec:
          containers:
            - name: user-container
              image: gcr.io/knative-releases/knative.dev/eventing-contrib/cmd/event_display
              ports:
              - containerPort: 8080
                name: user-port
                protocol: TCP
    ---
    apiVersion: v1
    kind: Service
    metadata:
      labels:
        app: event-display
      name: event-display-service
      namespace: ${WORKLOAD_NAMESPACE}
    spec:
      ports:
        - port: 80
          protocol: TCP
          targetPort: 8080
      selector:
        app: event-display
    EOF
    ```

3. Create a trigger. Run:
    ```sh
    cat <<EOF | kubectl apply -f -
    apiVersion: eventing.knative.dev/v1
    kind: Trigger
    metadata:
      name: event-display
      namespace: ${WORKLOAD_NAMESPACE}
    spec:
      broker: default
      subscriber:
        ref:
         apiVersion: v1
         kind: Service
         name: event-display-service
         namespace: ${WORKLOAD_NAMESPACE}
    EOF
    ```

4. Create a producer. This will send a message every minute. Run:
    ```sh
    cat <<EOF | kubectl create -f -
    apiVersion: sources.knative.dev/v1
    kind: PingSource
    metadata:
      name: test-ping-source
      namespace: ${WORKLOAD_NAMESPACE}
    spec:
      schedule: "*/1 * * * *"
      data: '{"message": "Hello Eventing!"}'
      sink:
        ref:
          apiVersion: eventing.knative.dev/v1
          kind: Broker
          name: default
          namespace: ${WORKLOAD_NAMESPACE}
    EOF
    ```

5. Verify that the event appears in your consumer logs. Run:
    ```sh
    kubectl logs deploy/event-display -n ${WORKLOAD_NAMESPACE} --since=10m --tail=50 -f
    ```

## <a id="cluster-default-rabbitmq"></a> Setup RabbitMQ Broker as the default in the cluster (optional)

Eventing provides a `config-br-defaults` ConfigMap that contains the configuration setting that govern default
Broker creation.

This example configuration will set RabbitMQ as the default broker on the cluster:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: config-br-defaults
  namespace: knative-eventing
  labels:
    eventing.knative.dev/release: devel
data:
  default-br-config: |
    clusterDefault:
      brokerClass: RabbitMQBroker
      apiVersion: eventing.knative.dev/v1alpha1
      kind: RabbitmqBrokerConfig
      name: default-config
      namespace: ${WORKLOAD_NAMESPACE} # This should be the name of your namespace.
      delivery:
        retry: 3
        backoffDelay: PT0.2S
        backoffPolicy: exponential
```

To achieve this you can:

1. Run:
   ```shell
   kubectl patch -n knative-eventing cm config-br-defaults --type merge --patch '{"data": {"default-br-config": "clusterDefault:\n      brokerClass: RabbitMQBroker\n      apiVersion: eventing.knative.dev/v1alpha1\n      kind: RabbitmqBrokerConfig\n      name: default-config\n      namespace: '"${WORKLOAD_NAMESPACE}"'\n      delivery:\n        retry: 3\n        backoffDelay: PT0.2S\n        backoffPolicy: exponential\n"}}'
   ```

2. Check that the ConfigMap looks as intended.
   ```shell
   kubectl get -n knative-eventing cm config-br-defaults -oyaml
   ```

3. Now, to create a RabbitMQ broker you can run:
   ```sh
   cat <<EOF | kubectl create -f -
   apiVersion: eventing.knative.dev/v1
   kind: Broker
   metadata:
     name: broker-using-defaults
     namespace: ${WORKLOAD_NAMESPACE}
   EOF
   ```

   Eventing will automatically set the brokerClass to `RabbitMQBroker` and it will set up the `spec.config` to `RabbitmqBrokerConfig` with name `default-config`.

## <a id="namespace-default-rabbitmq"></a> Setup RabbitMQ Broker as the default in a namespace (optional)

You can also use the `config-br-defaults` ConfigMap to set up the default broker configuration for a given namespace.

Let us suppose you want to have the MTChannelBroker as the default for the cluster and the RabbitMQ Broker as the default for your workload namespace.

To do this, we want that our `config-br-defaults` ConfigMap looks like this:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: config-br-defaults
  namespace: knative-eventing
  labels:
    eventing.knative.dev/release: devel
data:
  default-br-config: |
     clusterDefault:
       brokerClass: MTChannelBasedBroker
       apiVersion: v1
       kind: ConfigMap
       name: config-br-default-channel
       namespace: knative-eventing
       delivery:
         retry: 10
         backoffDelay: PT0.2S
         backoffPolicy: exponential
     namespaceDefaults:
       ${WORKLOAD_NAMESPACE}: # This should be the name of your namespace.
         brokerClass: RabbitMQBroker
         apiVersion: eventing.knative.dev/v1alpha1
         kind: RabbitmqBrokerConfig
         name: default-config
         namespace: ${WORKLOAD_NAMESPACE} # This should be the name of your namespace.
         delivery:
           retry: 3
           backoffDelay: PT0.2S
           backoffPolicy: exponential
```

To achieve this you can:

1. Run:
   ```shell
   kubectl patch -n knative-eventing cm config-br-defaults --type merge --patch '{"data": {"default-br-config": "clusterDefault:\n  brokerClass: MTChannelBasedBroker\n  apiVersion: v1\n  kind: ConfigMap\n  name: config-br-default-channel\n  namespace: knative-eventing\n  delivery:\n    retry: 10\n    backoffDelay: PT0.2S\n    backoffPolicy: exponential\nnamespaceDefaults:\n  '"${WORKLOAD_NAMESPACE}"':\n    brokerClass: RabbitMQBroker\n    apiVersion: eventing.knative.dev/v1alpha1\n    kind: RabbitmqBrokerConfig\n    name: default-config\n    namespace: '"${WORKLOAD_NAMESPACE}"'\n    delivery:\n      retry: 3\n      backoffDelay: PT0.2S\n      backoffPolicy: exponential\n"}}'
   ```

2. Check that the ConfigMap looks as intended.
   ```shell
   kubectl get -n knative-eventing cm config-br-defaults -o yaml
   ```

3. With this configuration when you create a Broker in the `default` namespace it will be a MTChannelBasedBroker.
   ```sh
   cat <<EOF | kubectl create -f -
   apiVersion: eventing.knative.dev/v1
   kind: Broker
   metadata:
     name: broker-in-default-ns
     namespace: default
   EOF
   ```

4. Check the type of this broker like so:
   ```shell
   kubectl get -n default broker broker-in-default-ns -o yaml
   ```

   It will show something like this:
   ```yaml
   apiVersion: eventing.knative.dev/v1
   kind: Broker
   metadata:
     annotations:
       eventing.knative.dev/broker.class: MTChannelBasedBroker
     name: broker-in-default-ns
     namespace: default
   spec:
     config:
       apiVersion: v1
       kind: ConfigMap
       name: config-br-default-channel
       namespace: knative-eventing
     delivery:
       backoffDelay: PT0.2S
       backoffPolicy: exponential
       retry: 10
   ```

   Notice the `eventing.knative.dev/broker.class: MTChannelBasedBroker` annotation.

5. Now try to create a Broker in the ${WORKLOAD_NAMESPACE}.
   ```sh
   cat <<EOF | kubectl create -f -
   apiVersion: eventing.knative.dev/v1
   kind: Broker
   metadata:
     name: broker-in-workload-ns
     namespace: ${WORKLOAD_NAMESPACE}
   EOF
   ```

6. Check the type of this broker like so:
   ```shell
   kubectl get -n ${WORKLOAD_NAMESPACE} broker broker-in-workload-ns -o yaml
   ```
   It will show something like this:

   ```yaml
   apiVersion: eventing.knative.dev/v1
   kind: Broker
   metadata:
     annotations:
       eventing.knative.dev/broker.class: RabbitMQBroker
     name: broker-in-workload-ns
     namespace: ${WORKLOAD_NAMESPACE}
   spec:
     config:
       apiVersion: eventing.knative.dev/v1alpha1
       kind: RabbitmqBrokerConfig
       name: default-config
       namespace: ${WORKLOAD_NAMESPACE}
     delivery:
       backoffDelay: PT0.2S
       backoffPolicy: exponential
       retry: 3
   ```

   Notice the `eventing.knative.dev/broker.class: RabbitMQBroker` annotation.

## Delete the Eventing Resources

After verifying your Eventing installation, clean up by deleting the resources used for the test:

1. Delete the eventing resources:
    ```sh
    kubectl delete pingsource/test-ping-source -n ${WORKLOAD_NAMESPACE}
    kubectl delete trigger/event-display -n ${WORKLOAD_NAMESPACE}
    kubectl delete service/event-display-service -n ${WORKLOAD_NAMESPACE}
    kubectl delete deploy/event-display -n ${WORKLOAD_NAMESPACE}
    kubectl delete broker/default -n ${WORKLOAD_NAMESPACE}
    ```

2. If you followed [Setup RabbitMQ Broker as the default in the cluster (optional)](#cluster-default-rabbitmq),
   delete the broker like so:
    ```sh
    kubectl delete broker/broker-using-defaults -n ${WORKLOAD_NAMESPACE}
    ```

3. If you followed [Setup RabbitMQ Broker as the default in a namespace (optional)](#namespace-default-rabbitmq),
   delete the brokers like so:
    ```sh
    kubectl delete broker/broker-in-default-ns -n default
    kubectl delete broker/broker-in-workload-ns -n ${WORKLOAD_NAMESPACE}
    ```

4. If you created a RabbitMQ cluster:
    ```sh
    kubectl delete rabbitmqbrokerconfig/default-config -n ${WORKLOAD_NAMESPACE}
    kubectl delete rabbitmqcluster/my-rabbitmq -n ${WORKLOAD_NAMESPACE}
    ```

5. Delete the role binding:
    ```sh
    kubectl delete rolebinding/${WORKLOAD_NAMESPACE}-psp -n ${WORKLOAD_NAMESPACE}
    ```

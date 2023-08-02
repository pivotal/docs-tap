# Existing RabbitMQ

If you have an existing RabbitMQ cluster, you can use it instead of creating a
new one or using the RabbitMQ cluster Operator.

You can specify how the Knative RabbitMQ resources can talk with your cluster by following the steps below.

> **Note:** This instance must be reachable from the Tanzu Cluster.

## Create a namespace

For this example context, let's create a demo namespace for the resources we need.

```sh
kubectl create ns external-cluster-sample
```

## Create the RabbitMQ credentials Secret

```sh
kubectl apply -f - << EOF
apiVersion: v1
kind: Secret
metadata:
  name: rabbitmq-secret-credentials
  namespace: external-cluster-sample
# This is just a sample, don't use it this way in production
stringData:
  username: YOUR_EXTERNAL_RABBITMQ_USERNAME
  password: YOUR_EXTERNAL_RABBITMQ_PASSWORD
  uri: YOUR_EXTERNAL_RABBITMQ_URI:HTTP_PORT # https://example.com:12345, example.com:12345, rabbitmqc.namespace:15672
  port: AMQP_PORT # 5672 default
EOF
```

## Eventing RabbitMQ Broker Setup

This is the configuration required for creating Brokers that use the external RabbitMQ cluster.

### Create the RabbitMQ Broker Config

```sh
kubectl apply -f - << EOF
apiVersion: eventing.knative.dev/v1alpha1
kind: RabbitmqBrokerConfig
metadata:
  name: default-config
  namespace: external-cluster-sample
spec:
  rabbitmqClusterReference:
    namespace: external-cluster-sample
    name: rabbitmq-secret-credentials
  queueType: quorum
EOF
```

### Create the RabbitMQ Broker

```sh
kubectl apply -f - << EOF
apiVersion: eventing.knative.dev/v1
kind: Broker
metadata:
  name: default
  namespace: external-cluster-sample
  annotations:
    eventing.knative.dev/broker.class: RabbitMQBroker
spec:
  config:
    apiVersion: eventing.knative.dev/v1alpha1
    kind: RabbitmqBrokerConfig
    name: default-config
  delivery:
    deadLetterSink:
      ...
EOF
```

Then wait for the Broker to become ready, which might take a few seconds.

```sh
kubectl -n external-cluster-sample get brokers
NAME      URL                                                                   AGE     READY   REASON
default   http://default-broker-ingress.external-cluster-sample.svc.cluster.local   2m39s   True
```

## Eventing RabbitMQ Source Setup

This is the configuration required for creating Sources that use the external RabbitMQ Cluster.

### Create the RabbitMQ Source

Using the same external cluster credentials secret as before, run:

```sh
kubectl apply -f - << EOF
apiVersion: sources.knative.dev/v1alpha1
kind: RabbitmqSource
metadata:
  name: rabbitmq-source
  namespace: external-cluster-sample
spec:
  rabbitmqClusterReference:
    namespace: external-cluster-sample
    connectionSecret: rabbitmq-secret-credentials
  rabbitmqResourcesConfig:
    ...
EOF
```

### Cleanup

```sh
kubectl delete ns external-cluster-sample
```

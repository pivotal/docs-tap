# Verifying TriggerMesh Sources

This topic tells you how to verify that TriggerMesh sources installed 
successfully for Eventing.

## Overview

TriggerMesh allows you to consume events from your cloud services 
(e.g., AWS, Azure, GCP) and send them to workloads running in your cluster.
For general information about TriggerMesh,
see [TriggerMesh](https://github.com/triggermesh/triggermesh) in GitHub.

Eventing includes an installation of the Triggermesh controller, CRDs, and sources. 
You can find the controller in the `triggermesh` namespace.

The procedure below shows you how to test your TriggerMesh sources
using the example of an event source for your platform of choice.

## Prerequisites

Before you verify TriggerMesh's installation with these examples, you must have:

* For AWS sources: an AWS service account, and an AWS CodeCommit repository with push and pull access

* For GCP sources: a GCP service account, a Pub/Sub topic and subscriptionID

* For Azure sources: an Azure AD tenant ID, and an Azure Event Hub instance

* Have a namespace where you want to deploy Knative services. This namespace will be referred as `${WORKLOAD_NAMESPACE}` in this tutorial. See step 1 of [Verifying Your Installation](verify-installation.md) for more information.

## Verify TriggerMesh AWS Sources

To verify TriggerMesh AWS sources (SAWS) with AWS CodeCommit:

1. Create a broker:
    ```sh
    kubectl apply -f - << EOF
    apiVersion: eventing.knative.dev/v1
    kind: Broker
    metadata:
      name: broker
      namespace: ${WORKLOAD_NAMESPACE}
    EOF
    ```

1. Create a trigger:
    ```sh
    kubectl apply -f - << EOF
    ---
    apiVersion: eventing.knative.dev/v1
    kind: Trigger
    metadata:
      name: trigger
      namespace: ${WORKLOAD_NAMESPACE}
    spec:
      broker: broker
      subscriber:
        ref:
         apiVersion: serving.knative.dev/v1
         kind: Service
         name: consumer
         namespace: ${WORKLOAD_NAMESPACE}
    EOF
    ```

1. Create a consumer:
    ```sh
    kubectl apply -f - << EOF
    ---
    apiVersion: serving.knative.dev/v1
    kind: Service
    metadata:
      name: consumer
      namespace: ${WORKLOAD_NAMESPACE}
    spec:
      template:
        spec:
          containers:
            - image: gcr.io/knative-releases/knative.dev/eventing-contrib/cmd/event_display
    EOF
    ```

1. Add an AWS service account secret:
    ```sh
    kubectl -n ${WORKLOAD_NAMESPACE} create secret generic awscreds \
    --from-literal=aws_access_key_id=${AWS_ACCESS_KEY_ID} \
    --from-literal=aws_secret_access_key=${AWS_SECRET_ACCESS_KEY}
    ```

    Where:

    + `AWS_ACCESS_KEY_ID` is the AWS access key ID for your AWS service account.
    + `AWS_SECRET_ACCESS_KEY` is your AWS access key for your AWS service account.

1. Create the AWSCodeCommitSource:
    ```sh
    kubectl apply -f - << EOF
    apiVersion: sources.triggermesh.io/v1alpha1
    kind: AWSCodeCommitSource
    metadata:
      name: source
      namespace: ${WORKLOAD_NAMESPACE}
    spec:
      arn: ARN
      branch: BRANCH

      eventTypes:
        - push
        - pull_request

      credentials:
        accessKeyID:
          valueFromSecret:
            name: awscreds
            key: aws_access_key_id
        secretAccessKey:
          valueFromSecret:
            name: awscreds
            key: aws_secret_access_key

      sink:
        ref:
          apiVersion: eventing.knative.dev/v1
          kind: Broker
          name: broker
          namespace: ${WORKLOAD_NAMESPACE}
    EOF
    ```
    Where:

    + `ARN` is Amazon Resource Name (ARN) of your CodeCommit repository.
       For example, `arn:aws:codecommit:eu-central-1:123456789012:triggermeshtest`.
    + `BRANCH` is the branch of your CodeCommit repository that you want the trigger to watch.
      For example, `main`.

1. Patch the `awscodecommitsource-adapter` service account to pull images from the private registry using the `tap-registry` secret, created during the TAP installation. Note that the `awscodecommitsource-adapter` service account was created on the previous step during the creation of `AWSCodeCommitSource`.
    ```sh
    kubectl patch serviceaccount -n ${WORKLOAD_NAMESPACE} awscodecommitsource-adapter -p '{"imagePullSecrets": [{"name": "tap-registry"}]}'
    ```

    > Note: It may be necessary to delete the current `awscodecommitsource-source` **Pod** so a new pod is created with the new `imagePullSecrets`.

1. Create an event by pushing a commit to your CodeCommit repository.

1. Watch the consumer logs to see that the event appears after a minute:
    ```sh
    kubectl logs -l serving.knative.dev/service=consumer -c user-container -n ${WORKLOAD_NAMESPACE} --since=10m --tail=50
    ```

## Verify TriggerMesh GCP Sources

To verify TriggerMesh GCP sources with a Google Cloud PubSub source:

1. Create a broker:
    ```sh
    kubectl apply -f - << EOF
    apiVersion: eventing.knative.dev/v1
    kind: Broker
    metadata:
      name: broker
      namespace: ${WORKLOAD_NAMESPACE}
    EOF
    ```

1. Create a trigger:
    ```sh
    kubectl apply -f - << EOF
    ---
    apiVersion: eventing.knative.dev/v1
    kind: Trigger
    metadata:
      name: trigger
      namespace: ${WORKLOAD_NAMESPACE}
    spec:
      broker: broker
      subscriber:
        ref:
         apiVersion: serving.knative.dev/v1
         kind: Service
         name: consumer
         namespace: ${WORKLOAD_NAMESPACE}
    EOF
    ```

1. Create a consumer:
    ```sh
    kubectl apply -f - << EOF
    ---
    apiVersion: serving.knative.dev/v1
    kind: Service
    metadata:
      name: consumer
      namespace: ${WORKLOAD_NAMESPACE}
    spec:
      template:
        spec:
          containers:
            - image: gcr.io/knative-releases/knative.dev/eventing-contrib/cmd/event_display
    EOF
    ```

1. Add a GCP service account and Pub/Sub information:
    ```sh
    export GCP_TOPIC='your-topic' \
    export GCP_SUBSCRIPTION_ID='your-subscription' \
    export GCP_SERVICE_ACCOUNT_KEY='your-path-to-key'
    ```

    Where:

    + `GCP_TOPIC` is the name of your Google Cloud Pub/Sub topic.
    + `GCP_SUBSCRIPTION_ID` is the name of your Google Cloud Subscription.
    + `GCP_SERVICE_ACCOUNT_KEY` is your Google Cloud service account with permissions to the Pub/Sub topic and subscription. You can download this from your Google Cloud IAM section.

1. Create the Google Cloud PubSub Source:
  ```sh
  kubectl apply -f - << EOF
  apiVersion: sources.triggermesh.io/v1alpha1
  kind: GoogleCloudPubSubSource
  metadata:
    name: source
    namespace: ${WORKLOAD_NAMESPACE}
  spec:
    topic: ${GCP_TOPIC}
    subscriptionID: ${GCP_SUBSCRIPTION_ID}
    serviceAccountKey:
      value: >-
        ${GCP_SERVICE_ACCOUNT_KEY}

    sink:
      ref:
        apiVersion: eventing.knative.dev/v1
        kind: Broker
        name: default
            namespace: ${WORKLOAD_NAMESPACE}
  EOF
  ```

## Verify TriggerMesh Azure Sources

To verify TriggerMesh Azure sources with an [Azure Service Bus](https://docs.triggermesh.io/1.25/sources/azureservicebus/) source:

1. Create a broker:
    ```sh
    kubectl apply -f - << EOF
    apiVersion: eventing.knative.dev/v1
    kind: Broker
    metadata:
      name: broker
      namespace: ${WORKLOAD_NAMESPACE}
    EOF
    ```

1. Create a trigger:
    ```sh
    kubectl apply -f - << EOF
    ---
    apiVersion: eventing.knative.dev/v1
    kind: Trigger
    metadata:
      name: trigger
      namespace: ${WORKLOAD_NAMESPACE}
    spec:
      broker: broker
      subscriber:
        ref:
         apiVersion: serving.knative.dev/v1
         kind: Service
         name: consumer
         namespace: ${WORKLOAD_NAMESPACE}
    EOF
    ```

1. Create a consumer:
    ```sh
    kubectl apply -f - << EOF
    ---
    apiVersion: serving.knative.dev/v1
    kind: Service
    metadata:
      name: consumer
      namespace: ${WORKLOAD_NAMESPACE}
    spec:
      template:
        spec:
          containers:
            - image: gcr.io/knative-releases/knative.dev/eventing-contrib/cmd/event_display
    EOF
    ```

1. Replace the fields with your credentials, then create the Azure Service Bus source:
  ```sh
  kubectl apply -f - << EOF
  apiVersion: sources.triggermesh.io/v1alpha1
  kind: AzureServiceBusSource
  metadata:
    name: sample
  spec:
    topicID: /subscriptions/TENANT_ID/resourceGroups/MyGroup/providers/Microsoft.ServiceBus/namespaces/MyNamespace/topics/MyTopic
    auth:
      servicePrincipal:
        tenantID:
          value: TENANT_ID
        clientID:
          value: CLIENT_ID
        clientSecret:
          value: CLIENT_SECRET
    sink:
      ref:
        apiVersion: eventing.knative.dev/v1
        kind: Broker
        name: default
            namespace: ${WORKLOAD_NAMESPACE}
  EOF
  ```
  Where:

    + `TENANT_ID` is your Azure Tenant ID in the form of 00000000-0000-0000-0000-000000000000.
    + `CLIENT_ID` is your Azure Client ID.
    + `CLIENT_SECRET` is your Azure Client ID's corresponding secret.

# Configuring Eventing with RabbitMQ for Eventing

This topic tells you how to use RabbitMQ as an event source to react to messages sent to a RabbitMQ exchange or as an event broker to distribute events within your app for Eventing.

## Overview

The integration allows you to create:

- **A RabbitMQ broker**: A Knative Eventing broker backed by RabbitMQ. This broker uses RabbitMQ exchanges
  to store CloudEvents that are then routed from one component to another.
- **A RabbitMQ source:** An event source that translates external messages on a RabbitMQ exchange to CloudEvents,
  which can then be used with Knative Serving or Knative Eventing over HTTP.

## Install VMware Tanzu RabbitMQ for Kubernetes

Before you can use or test RabbitMQ eventing on Eventing, you need to install VMWare Tanzu RabbitMQ for Kubernetes. Follow below steps to complete the installation:

1. [Accept End User License Agreement](https://docs.vmware.com/en/VMware-RabbitMQ-for-Kubernetes/1.4/rmq/GUID-installation.html#accept-the-end-user-license-agreements)

2. [Prerequisites](https://docs.vmware.com/en/VMware-RabbitMQ-for-Kubernetes/1.4/rmq/GUID-installation.html):
   This step installs kapp-controller and secretgen-controller.
   Skip this step if kapp-controller and secretgen-controller are already installed on your cluster.

3. Prepare for the Installation

   - [Provide imagePullSecrets](https://docs.vmware.com/en/VMware-RabbitMQ-for-Kubernetes/1.4/rmq/GUID-installation.html#provide-imagepullsecrets)
   - [Install the PackageRepository](https://docs.vmware.com/en/VMware-RabbitMQ-for-Kubernetes/1.4/rmq/GUID-installation.html#install-the-packagerepository)
   - [Create a Service Account](https://docs.vmware.com/en/VMware-RabbitMQ-for-Kubernetes/1.4/rmq/GUID-installation.html#create-a-serviceaccount)
   - [Install Cert-Manager ](https://docs.vmware.com/en/VMware-RabbitMQ-for-Kubernetes/1.4/rmq/GUID-installation.html#install-cert-manager): Skip this step if cert-manager is already installed on your cluster.

4. [Install the Tanzu RabbitMQ Package ](https://docs.vmware.com/en/VMware-RabbitMQ-for-Kubernetes/1.4/rmq/GUID-installation.html#install-the-vmware-rabbitmq-package): This step will install the Tanzu RabbitMQ Cluster Operator, Message Topology Operator, and Standby Replication Operator on your cluster.

## Next Steps

After completing these installations, you can:

- Verify your Knative Eventing installation using an example RabbitMQ broker.
  For instructions, see [Verify Knative Eventing](verifying-eventing.md).

- [Bring your own RabbitMQ Cluster](rabbitmq-external-cluster.md): Plug in an existing RabbitMQ instance and start using it with the Tanzu and Knative Eventing resources.

- Create a broker, producer, and a consumer to use RabbitMQ and Knative Eventing with your own app.

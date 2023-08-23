# Configuring Cloud Native Runtimes with Avi Vantage

This topic tells you how to configure Cloud Native Runtimes, commonly known as CNR, with Avi Vantage.

## Overview

You can configure Cloud Native Runtimes to integrate with Avi Vantage. Avi
Vantage is a multi-cloud platform that delivers features such as load balancing,
security, and container ingress services. The Avi Controller provides a control
plane while the Avi Service Engines provide a data plane. Once set up, the Avi
Service Engines forward incoming traffic to your Kubernetes cluster's Envoy
pods, which are created and managed by Contour.

For information about Avi Vantage,
see [Avi Documentation](https://avinetworks.com/docs/).

## Integrate Avi Vantage with Cloud Native Runtimes

This procedure assumes that you have already installed Cloud Native Runtimes.

If you have not already installed Cloud Native Runtimes, see [Installing Cloud Native Runtimes](./app-operators/install.hbs.md).
If you already have a Contour installation on your cluster, see [Installing Cloud Native Runtimes with an Existing Contour Installation](./contour.hbs.md).

To configure Cloud Native Runtimes with Avi Vantage, do the following:

1. Deploy the Avi Controller on any Avi supported infrastructure providers.
For a list of Avi supported providers, see [Avi Installation Guides](https://avinetworks.com/docs/20.1/installation-guides-landing-page/).
For more information about deploying an Avi Controller, see [Install Avi Kubernetes Operator](https://avinetworks.com/docs/ako/1.2/ako-installation/) in the Avi Vantage documentation.

1. Deploy the Avi Kubernetes Operator to your Kubernetes cluster where Cloud Native Runtimes is hosted. See [Install AKO for Kubernetes](https://avinetworks.com/docs/ako/1.4/ako-installation/#install-ako-for-kubernetes) in the Avi Vantage documentation.

1. Connect to a test app and verify that it is reachable. Run:
   ```
   "curl -H KNATIVE-SERVICE-DOMAIN" ENVOY-IP
   ```
   Where:

      - `KNATIVE-SERVICE-DOMAIN` is the name of your domain.
      - `ENVOY-IP` is the IP address of your Envoy instance.

   For more information about deploy a sample application and connect to the application,
  see [Test Knative Serving](./app-operators/verifying-serving.hbs.md#test-knative-serving-1).

1. (Optional) Create a DNS record that will configure your KService URL to point to the Avi Service Engines, and resolve to the external IP of the Envoy. You can create a DNS record on any platform that supports DNS services. Refer to the documentation for your DNS service platform for more information.

   To get the KService URL, run:
   ```
   kn route describe APP-NAME | grep "URL"
   ```

   To get Envoy's external IP, follow step 3 in [Test Knative Serving](./app-operators/verifying-serving.hbs.md#test-knative-serving-1)
   in _Verifying your Serving Installation_.

## <a id='avi-cnr-routing'></a> About Routing with Avi Vantage and Cloud Native Runtimes

The following diagram shows how Avi Vantage integrates with Cloud Native Runtimes:

![This diagram illustrates the workflow described in the text below.](../images/avi-cnr-integration.jpg)

When Contour creates a Kubernetes LoadBalancer service for Envoy, the Avi Kubernetes Operator (AKO) sees the new LoadBalancer service.
Then Avi Controller creates a Virtual Service. For information about LoadBalancer services, see
[Type LoadBalancer](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer) in the Kubernetes documentation.

For each Envoy service, Avi Controller creates a corresponding Virtual Service.
See [Virtual Services](https://avinetworks.com/docs/latest/architectural-overview/applications/virtual-services/) in the Avi Vantage documentation.

After Avi Controller creates a Virtual Service, the Controller configures the Avi Service Engines to forward traffic to the Envoy pods. The Envoy pods route traffic based on incoming requests, including traffic splitting and path based routing.

The Avi Controller provides Envoy with an external IP address so that apps are reachable by the app developer.

> **Note:** Avi does not interact directly with any Cloud Native Runtimes resources. Avi Vantage forwards all incoming traffic to Envoy.

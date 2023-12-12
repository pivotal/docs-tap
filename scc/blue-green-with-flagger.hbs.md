# Use blue-green deployment with Flagger for Supply Chain Choreographer (beta)

This topic tells you how to use blue-green deployment with Packages and PackageInstalls using Flagger for Supply Chain Choreographer (beta).

## <a id="overview"></a> Overview

Blue-green deployment is an application delivery model that lets you gradually transfer
user traffic from one version of your app to a later version while both are
running in production.

## <a id="prerecs"></a> Prerequisites

To use blue-green deployment, you must complete the following prerequisites:

- Complete the prerequisites in [Configure and deploy to multiple environments with custom parameters](./config-deploy-multi-env.hbs.md).
- Configure Carvel for your supply chain. See [Carvel Package Supply Chains (beta)](./carvel-package-supply-chain.hbs.md).
- Configure a GitOps tool to deploy the package. See [Deploy Package and PackageInstall using Flux CD Kustomization](./delivery-with-flux.hbs.md)
  or [ArgoCD](./delivery-with-argo.hbs.md).

## <a id="get-deployment"></a> Deployment name

To get the name of the deployment you want to use:

1. Identify the name of the deployment and service that are part of the PackageInstall:

  ```console
  kubectl get deployment --namespace=prod
  ```

  This displays a list of all the deployments and services in the current
  Kubernetes namespace, with their current names. For example:

  ```console
  NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
  hello-app-00001-deployment   1/1     1            1           103
  ```

## <a id="flagger-canary"></a> Flagger Canary resource

Create a canary custom resource using the [Flagger instructions](https://docs.flagger.app/tutorials/kubernetes-blue-green#bootstrap) using
the deployment name from the earlier step.

Flagger creates three ClusterIP services: `hello-app.dev.tap-primary`, `hello-app.dev.tap-canary`, `hello-app.dev.tap`. It also creates a shadow deployment named `app-primar`y that represents the blue version. When a new
version is detected, Flagger scales up the green version and runs the conformance
tests, the tests target the `hello-app.dev.tap-canary` ClusterIP service to reach
the green version. If the conformance tests are passing, Flagger starts the load
tests and validate them with custom Prometheus queries. If the load test
analysis is successful, Flagger promotes the new version to
`hello-app.dev.tap-primary` and scales down the green version. Flagger extends a
canary analysis through [custom metrics](https://docs.flagger.app/usage/metrics)
and [webhooks](https://docs.flagger.app/usage/webhooks) for running load tests,
acceptance tests, or any other custom validation.

Flagger includes a [load generation
tool](https://docs.flagger.app/usage/webhooks#load-testing) to ensure that the
canary version of an application has enough traffic to generate metrics for
analysis. Without an HPA (Horizontal Pod Autoscaler), Flagger does not dynamically scale up or down the new
version based on traffic weight. This implies that the number of pods for the
new version remains constant throughout deployment. Consequently, performance
issues like high latency, errors, or timeouts can arise if the new version
receives more traffic than it can handle. This situation can also impact the
metrics and webhooks that Flagger uses to validate the new version, potentially
leading to a rollback or promotion delay.

Workloads of type `Web` use Knative, which has its own [custom
autoscaler](https://knative.dev/docs/serving/autoscaling/autoscaler-types/) and
doesn't use HPA by default, however you can configure the Knative to use it.
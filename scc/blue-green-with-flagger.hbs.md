# Use blue-green deployment with Flagger for Supply Chain Choreographer (beta)

Blue-green deployment is an application delivery model that lets you gradually transfer
user traffic from one version of your app to a later version while both are
running in production. This topic outlines how to use blue-green
deployment with Packages and PackageInstalls using [Flagger](https://flagger.app).

## <a id="prerecs"></a> Prerequisites

To use blue-green deployment, you must complete the following prerequisites:

- Complete the prerequisites in [Configure and deploy to multiple environments with custom parameters](./config-deploy-multi-env.hbs.md).
- Configure Carvel for your supply chain. See [Carvel Package Supply Chains (beta)](./carvel-package-supply-chain.hbs.md).
- Configure a gitops tool to deploy the package, [Deploy Package and PackageInstall using Flux CD Kustomization](./delivery-with-flux.hbs.md)
  or [ArgoCD](./delivery-with-argo.hbs.md).

## <a id="get-deployment"></a> Deployment name

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

## Flagger Canary resource

Create a canary custom resource using the [Flagger instructions](https://docs.flagger.app/tutorials/kubernetes-blue-green#bootstrap) using
the deployment name from the previous step

 - Flagger will create three ClusterIP services (hello-app.dev.tap-primary,hello-app.dev.tap-canary, hello-app.dev.tap) and a shadow deployment named app-primary that represents the blue version
 - When a new version is detected, Flagger would scale up the green version and run the conformance tests, the tests should target the hello-app.dev.tap-canary ClusterIP service to reach the green version.
 - If the conformance tests are passing, Flagger would start the load tests and validate them with custom Prometheus queries.
 - If the load test analysis is successful, Flagger will promote the new version to hello-app.dev.tap-primary and scale down the green version.

## Notes

1. Flagger helps extend a canary analysis through [custom metrics](https://docs.flagger.app/usage/metrics) and [webhooks](https://docs.flagger.app/usage/webhooks)
    for running load tests, acceptance tests, or any other custom validation.

1. Flagger also includes a [load generation tool](https://docs.flagger.app/usage/webhooks#load-testing) to ensure that the canary version of
   an application has enough traffic to generate metrics for analysis.

1. Without an HPA, Flagger will not dynamically scale up or down the new version based on traffic weight. This implies that the number of pods for
   the new version will remain constant throughout the deployment process. Consequently, performance issues like high latency, errors, or timeouts
   could arise if the new version receives more traffic than it can handle. This situation could also impact the metrics and webhooks that Flagger
   uses to validate the new version, potentially leading to a rollback or promotion delay.

1. Workloads of type "Web" use knative which has its own [custom autoscaler](https://knative.dev/docs/serving/autoscaling/autoscaler-types/) and
   doesn't use HPA by default, but can be configured to use it.
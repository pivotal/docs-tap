# Starter Supply Chains

This topic provides recipes for authoring useful, minimal `SupplyChains` to get started with.

## Build and Deploy an application

This Supply Chain builds and deploys an application from source.

It performs the following actions:

- Pull application source from Git
- Build a container image using Buildpacks
- Generate a runtime definition with the image
- Generate a Kubernetes Deployment and Service
- Generate a Carvel package to make the application deployable
- Deploy the application

1. Ensure that you have first initialized a working directory using [tanzu supplychain init](../../reference/supplychain-cli/tanzu_supplychain_init.hbs.md).

1. Run the following command to generate the supply chain.

```console
tanzu supplychain generate \
  --kind WebApp \
  --description "Build and deploy an application from Git" \
  --component source-git-provider-1.0.0 \
  --component buildpack-build-1.0.0 \
  --component conventions-1.0.0 \
  --component app-config-web-1.0.0 \
  --component carvel-package-1.0.0 \
  --component deployer-1.0.0
```

> **Note** To deploy other workload types, replace the ``app-config-web-1.0.0`` component with other options such as `app-config-server-1.0.0 `or `app-config-worker-1.0.0`.

## Build an application and store the artifact in Git

This Supply Chain builds a Carvel package from application source and stores it in a Git repository for deployment to a runtime environment.

It performs the following actions:

- Pull application source from Git
- Build a container image using Buildpacks
- Generate a runtime definition with the image
- Generate a Knative service
- Generate a Carvel package to make the application deployable
- Create a PR against a Git repository with the Carvel package contents

1. Ensure you have first initialized a working directory using [tanzu supplychain init](../../reference/supplychain-cli/tanzu_supplychain_init.hbs.md).
1. Run the following command to generate the supply chain.

```console
tanzu supplychain generate \
  --kind CarvelPackage \
  --description "Build an application from source and store the Carvel package in Git" \
  --component source-git-provider-1.0.0 \
  --component buildpack-build-1.0.0 \
  --component conventions-1.0.0 \
  --component app-config-web-1.0.0 \
  --component carvel-package-1.0.0 \
  --component git-writer-pr-1.0.0
```

> **Note** To write directly to a Git repository without creating a PR, replace the `git-writer-pr-1.0.0` component with `git-writer-1.0.0`.

## Deploy an application package from Git

This Supply Chain deploys a Carvel package from a Git repository.

It performs the following actions:

- Pull application package from Git
- Translate the Carvel package to a deployable package
- Deploy the application

1. Ensure you have first initialized a working directory using [tanzu supplychain init](../../reference/supplychain-cli/tanzu_supplychain_init.hbs.md).
1. Run the following command to generate the supply chain.

```console
tanzu supplychain generate \
  --kind PackageDeploy \
  --description "Deploy a Carvel package from Git" \
  --component source-git-provider-1.0.0 \
  --component source-package-translator-1.0.0 \
  --component deployer-1.0.0
```

## Coming from Supply Chain Choreographer

The recipes in this topic are analogous to OOTB Supply Chains and Profile experiences in Supply Chain Choreographer. Use this mapping to help decide which recipe you should start with. These recipes
do not provide exact parity with OOTB Supply Chains.

- Iterate Profile: Use [Build and Deploy an application](#build-and-deploy-an-application).
- Supply Chain Basic: Use [Build an application and store the artifact in Git](#build-an-application-and-store-the-artifact-in-git).
- Delivery Basic: Use [Deploy an application package from Git](#deploy-an-application-package-from-git).

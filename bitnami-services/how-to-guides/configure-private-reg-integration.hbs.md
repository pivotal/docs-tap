# Configure Private Registry and VMware Application Catalog ("VAC") Integration for Bitnami Services

## About

This document describes how to integrate [Bitnami Services](../about.hbs.md) with private registries. You can follow these same steps to configure integration with VMware Application Catalog ("VAC"). Configuration can either be applied globally to all services, or on a per-service basis.

## Pre-requisites

* You must have to hand your Helm Chart repository URL in the format `oci://<REPOSITORY>/charts`
* You must also have a suitable set of credentials for access to the private registry
* See [Obtain credentials for VMware Application Catalog ("VAC") Integration](./obtain-credentials-for-vac-integration.hbs.md) for steps to obtain both of these if you are looking to configure VAC integration

## Step 1: Create Secrets

The first step is to create two Kubernetes `Secrets`, one with credentials to pull Helm charts and the other with credentials to pull images. The examples below put these in the `default` namespace, but you can choose to place them in whatever namespace you prefer.

```console
$ kubectl create secret generic vac-chart-pull \
  -n default \
  --from-literal=username='<username>' \
  --from-literal=password='<token>'
```

```console
$ kubectl create secret docker-registry vac-container-pull \
  -n default \
  --docker-server='<the-hostname-part-of-your-registry-url>' \
  --docker-username='<username>' --docker-password='<token>'
```

## Step 2 Option A - Apply configuration to all Bitnami services

This option configures private registry integration for all of the Bitnami services. See the step below if you'd instead like to apply configuration on a per-service basis.

Add the following to your `tap-values.yaml` file:

```yaml
bitnami_services:
  globals:
    helm_chart:
      repo: oci://<REPOSITORY>/charts # update this
      chart_pull_secret_ref:
        name: vac-chart-pull
        namespace: default
      container_pull_secret_ref:
        name: vac-container-pull
        namespace: default
```

And then update Tanzu Application Platform by running:

```console
tanzu package installed update tap -p tap.tanzu.vmware.com --values-file tap-values.yaml -n tap-install
```

## Step 2 Option B - Apply configuration to one specific Bitnami service

Add the following to your `tap-values.yaml` file:

```yaml
bitnami_services:
  mysql: # choose from 'mysql', 'postgresql', 'rabbitmq' and 'redis'
    helm_chart:
      repo: oci://<REPOSITORY>/charts # update this
      chart_pull_secret_ref:
        name: vac-chart-pull
        namespace: default
      container_pull_secret_ref:
        name: vac-container-pull
        namespace: default
```

And then update Tanzu Application Platform by running:

```console
tanzu package installed update tap -p tap.tanzu.vmware.com --values-file tap-values.yaml -n tap-install
```

## Known issue

As of TAP 1.5.0 there is a known issue that occurrs if you try to configure private registry integration for the Bitnami services after having already created a claim for one or more of the Bitnami services using the default configuration. The issue is that the updated private registry configuration does not appear to take effect. This is due to caching behaviour in the system which is not currently accounted for during configuration updates. There is a temporary workaround to this issue, which is to simply delete the `provider-helm-*` pods in the `crossplane-system` namespace and wait for new pods to come back online after having applied updated registry configuration.

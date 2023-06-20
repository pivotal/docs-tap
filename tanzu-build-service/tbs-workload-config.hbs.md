# Configure Tanzu Build Service properties on a workload

This topic tells you how to configure your workload with Tanzu Build Service properties.

## Overview

Tanzu Build Service builds registry images from source code for Tanzu Application Platform.
You can configure these build configurations by using a workload.

Tanzu Build Service is only applicable to the build process.
Configurations, such as environment variables and service bindings, might require
a different process for runtime.

## <a id="service-bindings"></a> Configure build-time service bindings

You can configure build-time service bindings for Tanzu Build Service.

Tanzu Build Service supports using the Service Binding Specification for Kubernetes for application builds.
For more information, see the [service binding specification for Kubernetes](https://github.com/k8s-service-bindings/spec)
in GitHub.

Service binding configuration is specific to the buildpack that is used to build the app.
For more information about configuring buildpack service bindings for the buildpack you are using,
see the [VMware Tanzu Buildpacks documentation](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-index.html).

To configure a service binding for a Tanzu Application Platform workload, follow these steps:

1. Create a YAML file named `service-binding-secret.yaml` for a secret as follows:

    ```yaml
    apiVersion: v1
    kind: Secret
    metadata:
      name: settings-xml
      namespace: DEVELOPER-NAMESPACE
    type: service.binding/maven
    stringData:
      type: maven
      provider: sample
      settings.xml: |
      MY-SETTINGS
    ```

    Where:
    - `DEVELOPER-NAMESPACE` is the namespace where workloads are created.
    - `MY-SETTINGS` is the contents of your service bindings file.

1. Apply the YAML file by running:

    ```console
    kubectl apply -f service-binding-secret.yaml
    ```

1. Create the workload with `buildServiceBindings` configured by running:

    ```console
    tanzu apps workload create WORKLOAD-NAME \
      --param-yaml buildServiceBindings='[{"name": "settings-xml", "kind": "Secret"}]' \
      ...
    ```

    Where `WORKLOAD-NAME` is the name of the workload you want to configure.

## <a id="env-vars"></a> Configure environment variables

If you have build-time environment variable dependencies, you can set environment variables
that are available at build-time.

You can also configure buildpacks with environment variables.
Buildpack configuration depends on the specific buildpack being used.
For more information about configuring environment variables for the buildpack you are using,
see the [VMware Tanzu Buildpacks documentation](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-index.html).

For example:

```console
tanzu apps workload create WORKLOAD-NAME \
  --build-env "ENV_NAME=ENV_VALUE" \
  --build-env "BP_MAVEN_BUILD_ARGUMENTS=-Dmaven.test.skip=true"
```

Where `WORKLOAD-NAME` is the name of the workload you want to configure.

## <a id="service-account"></a> Configure the service account

Using the Tanzu CLI, you can configure the service account used during builds.
This service account is the one configured for the developer namespace.
If unset, `default` is used.

To configure the service account used during builds, run:

```console
tanzu apps workload create WORKLOAD-NAME \
  --param serviceAccount=SERVICE-ACCOUNT-NAME \
```

Where:

- `WORKLOAD-NAME` is the name of the workload you want to configure.
- `SERVICE-ACCOUNT-NAME` is the name of the service account you want to use during builds.

## <a id="cluster-builder"></a> Configure the cluster builder

To configure the ClusterBuilder used during builds:

1. View the available ClusterBuilds by running:

    ```console
    kubectl get clusterbuilder
    ```

1. Set the ClusterBuilder used during builds by running:

    ```console
    tanzu apps workload create WORKLOAD-NAME \
      --param clusterBuilder=CLUSTER-BUILDER-NAME \
    ```

    Where:

    - `WORKLOAD-NAME` is the name of the workload you want to configure.
    - `CLUSTER-BUILDER-NAME` is the ClusterBuilder you want to use.

## <a id="registry"></a> Configure the workload container image registry

Using the Tanzu CLI, you can configure the registry where workload images are saved.
The service account used for this workload must have read and write access to this registry location.

To configure the registry where workload images are saved, run:

```console
tanzu apps workload create WORKLOAD-NAME \
  --param-yaml registry={"server": SERVER-NAME, "repository": REPO-NAME}
```

Where:

- `SERVER-NAME` is the host name of the registry server. Examples:
  - Harbor has the form `"my-harbor.io"`.
  - Docker Hub has the form `"index.docker.io"`.
  - Google Cloud Registry has the form `"gcr.io"`.
- `REPO-NAME` is where workload images are stored in the registry.
Images are written to `SERVER-NAME/REPO-NAME/workload-name`. Examples:
  - Harbor has the form `"my-project/supply-chain"`.
  - Docker Hub has the form `"my-dockerhub-user"`.
  - Google Cloud Registry has the form `"my-project/supply-chain"`.

## <a id='custom-cert-single-workload'></a> Configure custom CA certificates for a single workload using service bindings

If the language family buildpack you are using includes the Paketo CA certificates buildpack,
you can use a service binding to provide custom certificates during the build and run process.
For more information about language family buildpacks, see the
[Tanzu Buildpacks documentation](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-index.html).

To create a service binding to provide custom CA certificates for a workload:

1. Create a YAML file named `service-binding-ca-cert.yaml` for a secret as follows:

    ```yaml
    apiVersion: v1
    kind: Secret
    metadata:
      name: my-ca-certs
    data:
      type: ca-certificates
      provider: sample
      CA-CERT-FILENAME: |
        -----BEGIN CERTIFICATE-----
        ...
        -----END CERTIFICATE-----
    ```

    Where `CA-CERT-FILENAME` is the name of your PEM encoded CA certificate file. For example, `arbitrary-file-name.pem`.

1. Apply the YAML file by running:

    ```console
    kubectl apply -f service-binding-ca-cert.yaml
    ```

1. To build with the custom certificate, create the workload with `--param-yaml buildServiceBindings` flag:

    ```console
    tanzu apps workload create WORKLOAD-NAME \
      --param-yaml buildServiceBindings='[{"apiVersion": "v1", "kind": "Secret", "name": "my-ca-certs"}]' \
      ...
    ```

    Where `WORKLOAD-NAME` is the name of the workload you want to create.

1. To deploy with the custom certificate, create the workload with the `--service-ref` flag:

    ```console
    tanzu apps workload create WORKLOAD-NAME \
      --service-ref my-ca-certs=v1:Secret:my-ca-certs \
      ...
    ```

    Where `WORKLOAD-NAME` is the name of the workload you want to create.

## <a id="custom-certs-all-workloads"></a> Using custom CA certificates for all workloads

To provide custom CA certificates to the build process for all workloads, see the
optional step to add the `ca_cert_data` key [Install the Tanzu Build Service package](install-tbs.md#tbs-tcli-install).

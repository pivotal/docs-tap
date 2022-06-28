---
title: Tanzu Build Service Workload Config
owner: Build Service Team
---

## <a id="workload"></a> Configuring TBS Properties on a Workload

Tanzu Build Service builds registry images from source code for TAP and these build configurations can be
customized through a workload.

It is important to note that TBS is only concerned with the build process. Configurations (such as env vars and service bindings) may
require a different process for runtime.

### <a id="service-bindings"></a> Build-Time Service Bindings

This topic discusses how to configure build-time service bindings for TAP/TBS.

TAP/TBS supports using [Service Binding Specification for Kubernetes](https://github.com/k8s-service-bindings/spec) for app builds.

Service binding configuration is specific to the buildpack that is used to build the app. For documentation on buildpack service bindings
configuration, see [Buildpacks](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/index.html).

To configure a service binding for a TAP workload, follow these steps:

1. Create a yaml file for a Secret. ex `service-binding-secret.yaml`:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: settings-xml
  namespace: <developer-namespace>
type: service.binding/maven
stringData:
  type: maven
  provider: sample
  settings.xml: |
	<my-settings>
```

2. Apply the config with `kubectl apply -f service-binding-secret.yaml`

3. Create the workload with `buildServiceBindings` configured:

```console
tanzu apps workload create <workload-name> \
  --param-yaml buildServiceBindings='[{"name": "settings-xml", "kind": "Secret"}]' \
  ...
```

### <a id="workload-configurations"></a> Workload Configurations

Some TBS configurations for workloads can be configured inline while creating the workload.

#### <a id="env-vars"></a> Environment Variables

If you have build-time environment variable dependencies you can set env vars that will be available at build-time.

Buildpacks can also be configured with environment variables. Buildpack configuration depends on the specific buildpack being used.
For documentation on buildpacks, see [Buildpacks](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/index.html).

```console
tanzu apps workload create <workload-name> \
 --build-env "ENV_NAME=ENV_VALUE" \
 --build-env "BP_MAVEN_BUILD_ARGUMENTS=-Dmaven.test.skip=true"
```

#### <a id="service-account"></a> Service Account

This can be used to set the service account used during builds. This service account is the one configured for the
developer namespace. If unset, `default` will be used.

```console
tanzu apps workload create <workload-name> \
  --param serviceAccount=<service-account-name> \
```

#### <a id="cluster-builder"></a> Cluster Builder

This can be used to set the ClusterBuilder used during builds. You can view the available ClusterBuilds by running
`kubectl get clusterbuilder`.

```console
tanzu apps workload create <workload-name> \
  --param clusterBuilder=<cluster-builder-name> \
```

#### <a id="registry"></a> Registry

The registry where workload images are saved can be configured with the `tanzu` cli. The service account used
for this workload must have read and write access to this registry location.

```console
tanzu apps workload create <workload-name> \
  --param-yaml registry={"server": <SERVER-NAME>, "repository": <REPO-NAME>}
```

Where:

- `SERVER-NAME` is the hostname of the registry server. Examples:
    * Harbor has the form `server: "my-harbor.io"`
    * Dockerhub has the form `server: "index.docker.io"`
    * Google Cloud Registry has the form `server: "gcr.io"`
- `REPO-NAME` is where workload images are stored in the registry.
  Images are written to `SERVER-NAME/REPO-NAME/workload-name`. Examples:
    * Harbor has the form `repository: "my-project/supply-chain"`
    * Dockerhub has the form `repository: "my-dockerhub-user"`
    * Google Cloud Registry has the form `repository: "my-project/supply-chain"`

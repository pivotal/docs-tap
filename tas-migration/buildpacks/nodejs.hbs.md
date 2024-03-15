# Migrate to the Node.js Cloud Native Buildpack

This topic tells you how to migrate your Node.js app from using a Cloud Foundry buildpack for Tanzu Application Service
(commonly known as TAS for VMs) to using a Cloud Native Buildpack for Tanzu Application Platform (commonly known as TAP).

## <a id="versions"></a> Install a specific Node Engine version

The following table compares how Tanzu Application Service and Tanzu Application Platform handle
installing specific versions.

| Feature                                                                | Tanzu Application Service | Tanzu Application Platform |
| ---------------------------------------------------------------------- | ------------------------- | -------------------------- |
| Detects version from `package.json `</br>Detects version from `.nvmrc` | ✅                        | ✅                         |
| Detects version from `.node-version`                                   | ❌                        | ✅                         |
| Override app-based version detection                                   | ❌                        | Use `$BP_NODE_VERSION`     |

### <a id="override-version-tas"></a> Tanzu Application Service: Override version detection

Specifying the version to install is not supported.

### <a id="override-version-tap"></a> Tanzu Application Platform: Override version detection

In Tanzu Application Platform, users can set the `$BP_NODE_VERSION` environment variable to specify
which version of the Node Engine to installed.

Example `spec` section from a `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: BP_NODE_VERSION
       value: "20.*.*"
```

## <a id="heap-memory"></a> Heap memory optimization

The following table compares how to configure heap memory optimization in Tanzu Application Service
and Tanzu Application Platform.

| Feature                         | Tanzu Application Service   | Tanzu Application Platform          |
| ------------------------------- | --------------------------- | ----------------------------------- |
| Enable Heap Memory Optimization | Use `$OPTIMIZE_MEMORY=true` | Use `$BP_NODE_OPTIMIZE_MEMORY=true` |

## <a id="npm-config"></a> Provide npm configuration files

The following table compares how to provide npm configuration files in Tanzu Application Service and
Tanzu Application Platform.

| Feature                                      | Tanzu Application Service | Tanzu Application Platform                        |
| -------------------------------------------- | ------------------------- | ------------------------------------------------- |
| Provide a `.npmrc` with the app              | ✅                        | ✅                                                |
| Provide a `.npmrc` by using service bindings | ❌ Not supported          | Use a binding of type npmrc containing `.npmrc` |

### <a id="npm-config-secret"></a> Configure npm settings with sensitive data

In Tanzu Application Platform, if your npm configuration contains sensitive data, you can provide the npm
configuration to the build without explicitly including the file in the application directory.

To provide your npm configuration file without including it in the directory:

1. Create the service binding as a secret. For example:

    ```yaml
    ---
    apiVersion: v1
    kind: Secret
    metadata:
      name: npmrc-binding
      namespace: my-apps
    type: service.binding/npmrc
    stringData:
      type: npmrc
      .npmrc: |
        registry=https://registry.npmjs.org/
        loglevel=warn
        save-exact=true
    ```

1. Use the binding in the `workload.yaml`. For example:

    ```yaml
    ---
    kind: Workload
    apiVersion: carto.run/v1alpha1
    metadata:
    name: nodejs-app
    spec:
    # ...
      params:
      - name: buildServiceBindings
        value:
          - name: npmrc-binding
            kind: Secret
            apiVersion: v1
    ```

For more information about service bindings, see
[Configure Tanzu Build Service properties on a workload](../../tanzu-build-service/tbs-workload-config.hbs.md).

## <a id="yarn-config"></a> Provide yarn configuration files

The following table compares how to provide yarn configuration files in Tanzu Application Service and
Tanzu Application Platform.

| Feature                                       | Tanzu Application Service | Tanzu Application Platform                        |
| --------------------------------------------- | ------------------------- | ------------------------------------------------- |
| Provide a `.yarnrc` with the app              | ✅                        | ✅                                                |
| Provide a `.yarnrc` by using service bindings | ❌ Not supported          | Use a binding of type yarnrc containing `.yarnrc` |

### <a id="yarn-config-secret"></a> Configure yarn settings with sensitive data

In Tanzu Application Platform, if your yarn configuration contains sensitive data, you can provide the yarn
configuration to the build without explicitly including the file in the application directory.

To provide your yarn configuration file without including it in the directory:

1. Create the service binding as a secret. For example:

    ```yaml
    ---
    apiVersion: v1
    kind: Secret
    metadata:
      name: yarnrc-binding
      namespace: my-apps
    type: service.binding/yarnrc
    stringData:
      type: yarnrc
      .yarnrc: |
        registry "https://registry.yarnpkg.com"
        flat "true"
    ```

1. Use the binding in the workload. For example:

    ```yaml
    ---
    kind: Workload
    apiVersion: carto.run/v1alpha1
    metadata:
    name: nodejs-app
    spec:
    # ...
      params:
      - name: buildServiceBindings
        value:
          - name: yarnc-binding
            kind: Secret
            apiVersion: v1
    ```

For more information about service bindings, see
[Configure Tanzu Build Service properties on a workload](../../tanzu-build-service/tbs-workload-config.hbs.md).

## <a id="front-end-apps"></a> Build and serve a front end framework app

The Tanzu Application Platform Node.js buildpack is designed exclusively for building back end server
node applications.
If your app is using a front end framework that generates static content from JavaScript source code,
such as React, Vue, Angular, you must use the Tanzu Application Platform Web Servers buildpack instead of
the Tanzu Application Platform Node.js buildpack.

To build a front end app, set the environment variable `$BP_NODE_RUN_SCRIPTS` to instruct the
Tanzu Application Platform Web Servers buildpack to run a specific npm or yarn script event during the build.
For popular frameworks such as Angular and React, this is generally the build script.

Example `spec` section from a `workload.yaml`:

```yaml
---
spec:
  build:
    env:
  - name: BP_NODE_RUN_SCRIPTS
    value: build
  - name: BP_WEB_SERVER
    value: nginx
  - name: BP_WEB_SERVER_ROOT
    value: build
```

For more information about using the Tanzu Application Platform Web Server buildpack, see
[Use the Tanzu Web Servers Buildpack](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-web-servers-web-servers-buildpack.html)
in the Tanzu Buildpacks documentation.

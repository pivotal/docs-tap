# Migrate to the Node.js Cloud Native Buildpack

This topic tells you how to migrate your Node.js app from using a Cloud Foundry buildpack for Tanzu Application Service
(commonly known as TAS for VMs) to using a Cloud Native Buildpack for Tanzu Application Platform (commonly known as TAP).

<!-- do users do all these sections in order or do they choose the section for their use case -->

## Install a specific Node Engine version

| Feature                                                                     | TAS | TAP                      |
| --------------------------------------------------------------------------- | --- | ------------------------ |
| Detects version from package.json </br>Detects version from .nvmrc          | ✅  | ✅                       |
| Detects version from .node-version                                          | ❌  | ✅                       |
| Override app-based version detection (see Using environment variable below) | ❌  | Using `$BP_NODE_VERSION` |

### Using environment variable

In TAP, users can set the $`BP_NODE_VERSION` environment variable to specify which version of the
Node Engine should be installed.

Here’s an excerpt from the spec section of a sample `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: BP_NODE_VERSION
       value: "20.*.*"
```

## Heap Memory Optimization

| Feature                         | TAS                           | TAP                                   |
| ------------------------------- | ----------------------------- | ------------------------------------- |
| Enable Heap Memory Optimization | Using `$OPTIMIZE_MEMORY=true` | Using `$BP_NODE_OPTIMIZE_MEMORY=true` |

## Provide npm Configurations

| Feature                               | TAS              | TAP                                               |
| ------------------------------------- | ---------------- | ------------------------------------------------- |
| Provide a .npmrc with the app         | ✅               | ✅                                                |
| Provide a .npmrc via service bindings | ❌ Not supported | Using a binding of type npmrc containing `.npmrc` |

In TAP, if your npm config contains sensitive data, you can provide npm config to the build without
explicitly including the file in the application directory.

Create the service binding as a secret like this example:

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

Use the binding in the workload like this example:

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

For more details about service bindings, see TAP documentation https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.7/tap/tanzu-build-service-tbs-workload-config.html

## Provide yarn Configurations

| Feature                                | TAS              | TAP                                                 |
| -------------------------------------- | ---------------- | --------------------------------------------------- |
| Provide a .yarnrc with the app         | ✅               | ✅                                                  |
| Provide a .yarnrc via service bindings | ❌ Not supported | Using a binding of type yarnrc containing `.yarnrc` |

In TAP, if your yarn config contains sensitive data, you can provide yarn config to the build without
explicitly including the file in the application directory.

Create the service binding as a secret like this example:

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

Use the binding in the workload like this example:

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

For more details about service bindings, see TAP documentation https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.7/tap/tanzu-build-service-tbs-workload-config.html

## Build and Serve a Frontend Framework App

If your app is using a frontend framework that generates static content from JavaScript source code,
for example, React, Vue, Angular, you have to use the TAP Web Servers buildpack, not the TAP Node.js
buildpack.
The TAP Node.js buildpack is designed exclusively for building backend server node applications.

Building frontend apps are accomplished by setting `$BP_NODE_RUN_SCRIPTS` to instruct the TAP Web Servers
buildpack to run a specific npm/yarn script event during the build.
For popular frameworks like Angular and React, this is generally the build script.

Here’s an excerpt from the spec section of a sample `workload.yaml`:

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

For more details about how to use the TAP Web Server buildpack, see its documentation
https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-web-servers-web-servers-buildpack.html

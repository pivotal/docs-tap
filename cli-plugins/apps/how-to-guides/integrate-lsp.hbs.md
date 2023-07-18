# Integrate with Local Source Proxy

This topic tells you how to integrate the Apps CLI plug-in with Local Source Proxy.

You can configure workloads to push local source code to a registry that is predefined using
the Local Source Proxy component.

For more information about Local Source Proxy, see [Overview of Local Source Proxy](../../../local-source-proxy/about.hbs.md) and [Create a workload from Local Source](../tutorials/create-update-workload.hbs.md#create-a-workload-from-local-source).

## Check Local Source Proxy health

To check the installation and health of Local Source Proxy and determine if failures originate from
the Local Source Proxy or the upstream registry, run:

```console
tanzu apps local-source-proxy health`
```

This returns an overview of the health of the Local Source Proxy. This information is obtained
directly from the Local Source Proxy and provides a status code and message.

Use the `--output` flag to specify one of the following formats: `yaml`, `yml`, and `json`. The default
format is `yaml`.

The API is called at the `/health` endpoint, and there are five possible outputs
based on the response received:

- All checks pass. Format is `yaml`.

  ```yaml
  user_has_permission: true
  reachable: true
  upstream_authenticated: true
  overall_health: true
  message: "All health checks passed"
  ```

- You do not have permission to list the service. The possible reason is a 403 error from the
Kubernetes API Server. Format is `yaml`.

  ```yaml
  user_has_permission: false
  reachable: false
  upstream_authenticated: false
  overall_health: false
  message: "The current user does not have permission to access the local source proxy"
  ```

- You can list the services, but it's not there. The possible reason is a 404 error from the Kubernetes
API Server. Format is [Source-Controller](../../../source-controller/about.hbs.md)

  ```yaml
  user_has_permission: true
  reachable: false
  upstream_authenticated: false
  overall_health: false
  message: "Local source proxy is not installed on the cluster"
  ```

- `/health` from Local Source Proxy returns a 5xx. Format is `yaml`.

  ```yaml
  user_has_permission: true
  reachable: true
  upstream_authenticated: false
  overall_health: false
  message: "Local source proxy is not healthy. Error: <error>"
  ```

- `/health` from upstream returns a non-2xx, 4xx, 5xx. `/health` from Local Source Proxy will still
  be 2xx. Format is `yaml`.

  ```yaml
  user_has_permission: true
  reachable: true
  upstream_authenticated: false
  overall_health: false
  message: "Local source proxy was unable to authenticate against the target registry. Error: <error>"
  ```

- All checks pass. Format is `json`.

  ```json
  {
    "user_has_permission": true
    "reachable": true
    "upstream_authenticated": true
    "overall_health": true
    "message": ""
  }
  ```

## Update the local source code for workloads

To create a workload from local source code, there are two options available:

1. Use Local Source Proxy, which automatically defaults to a predefined registry.
2. Use the `--source-image` flag to specify a registry. You must be authenticated to access
the registry.

To distinguish whether a workload was created with the Local Source Proxy or the `--source-image`
flag, check if the workload contains the `local-source-proxy.apps.tanzu.vmware.com` annotation.
This annotation indicates the method used to create the workload. 

For more information, see [Create a workload from Local Source](../tutorials/create-update-workload.hbs.md#create-a-workload-from-local-source).

### Use the `--source-image` flag

After a workload is created using the `--source-image` flag, it is not possible to update it
to use Local Source Proxy.
However, you do not need to repeatedly specify the `--source-image` flag during
subsequent updates, as it is retrieved from the existing workload specification within the cluster.
If you do want to change the registry or storage location for the source code, specify the `--source-image` flag again with a new value.

```console
# create a workload using source image
# inside the local source code folder
tanzu apps workload apply java-web-app --local-path . -s my-registry.io/my-project/java-app                                   
The files and/or directories listed in the .tanzuignore file are being excluded from the uploaded source code.
Publishing source in "." to "my-registry.io/my-project/java-app"...
📥 Published source

🔎 Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  labels:
      6 + |    apps.tanzu.vmware.com/workload-type: web
      7 + |  name: java-web-app
      8 + |  namespace: default
      9 + |spec:
     10 + |  source:
     11 + |    image: my-registry.io/my-project/java-app:latest@sha256:447db92e289dbe3a6969521917496ff2b6b0a1d6fbff1beec3af726430ce8493
❓ Do you want to create this workload? [yN]: y
👍 Created workload "java-web-app"

To see logs:   "tanzu apps workload tail java-web-app --timestamp --since 1h"
To get status: "tanzu apps workload get java-web-app"

# update the workload and check the source image is not changed to use Local Source Proxy
tanzu apps workload apply java-web-app --label hello=world
🔎 Update workload:
...
  3,  3   |kind: Workload
  4,  4   |metadata:
  5,  5   |  labels:
  6,  6   |    apps.tanzu.vmware.com/workload-type: web
      7 + |    hello: world
  7,  8   |  name: java-web-app
  8,  9   |  namespace: default
  9, 10   |spec:
 10, 11   |  source:
...
❓ Really update the workload "java-web-app"? [yN]:
```

### Switch from Local Source Proxy to `--source-image` flag

If a workload was initially created using the Local Source Proxy, it can be updated to use the
`--source-image` flag. The workload transitions to use the specified source image. As a result, the annotation that establishes the connection between the workload and the Local Source Proxy
is removed.

```console
# inside the folder that contains the local source code
tanzu apps workload apply java-web-app --local-path .                                              
The files and/or directories listed in the .tanzuignore file are being excluded from the uploaded source code.
Publishing source in "." to "local-source-proxy.tap-local-source-system.svc.cluster.local/source:default-java-web-app"...
📥 Published source

🔎 Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  annotations:
      6 + |    local-source-proxy.apps.tanzu.vmware.com: my-registry.io/my-project/source:default-java-web-app@sha256:447db92e289dbe3a6969521917496ff2b6b0a1d6fbff1beec3af726430ce8493
      7 + |  labels:
      8 + |    apps.tanzu.vmware.com/workload-type: web
      9 + |  name: java-web-app
     10 + |  namespace: default
     11 + |spec:
     12 + |  source:
     13 + |    image: my-registry.io/my-project/source:default-java-web-app@sha256:447db92e289dbe3a6969521917496ff2b6b0a1d6fbff1beec3af726430ce8493
❓ Do you want to create this workload? [yN]: y
👍 Created workload "java-web-app"

To see logs:   "tanzu apps workload tail java-web-app --timestamp --since 1h"
To get status: "tanzu apps workload get java-web-app"

# update to use a source image and see how the Local Source Proxy annotation is removed
# and the `spec.source.image` field also changes
tanzu apps workload apply java-web-app --local-path . -s my-registry.io/my-project/java-web-app                      
The files and/or directories listed in the .tanzuignore file are being excluded from the uploaded source code.
Publishing source in "." to "gcr.io/tanzu-framework-playground/java-web-app"...
37.58 kB / 37.16 kB [---------------------------------------------------------------------------------------------------------------------------------------------] 101.14% 31.94 kB p/s
📥 Published source

🔎 Update workload:
  1,  1   |---
  2,  2   |apiVersion: carto.run/v1alpha1
  3,  3   |kind: Workload
  4,  4   |metadata:
  5     - |  annotations:
  6     - |    local-source-proxy.apps.tanzu.vmware.com: my-registry.io/my-project/source:default-java-web-app@sha256:447db92e289dbe3a6969521917496ff2b6b0a1d6fbff1beec3af726430ce8493
  7,  5   |  labels:
  8,  6   |    apps.tanzu.vmware.com/workload-type: web
  9,  7   |  name: java-web-app
 10,  8   |  namespace: default
 11,  9   |spec:
 12, 10   |  source:
 13     - |    image: my-registry.io/my-project/source:default-java-web-app@sha256:447db92e289dbe3a6969521917496ff2b6b0a1d6fbff1beec3af726430ce8493
     11 + |    image: my-registry.io/my-project/java-web-app:latest@sha256:447db92e289dbe3a6969521917496ff2b6b0a1d6fbff1beec3af726430ce8493
❓ Really update the workload "java-web-app"? [yN]: 
```

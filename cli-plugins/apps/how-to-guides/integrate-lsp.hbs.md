# Integrate with Local Source Proxy

<!-- Mention the create with Local Source section from tutorials -->

There's a method for creating and updating workloads to push local source code to a registry 
specified by utilizing the [Local Source Proxy package](/local-source-proxy/about.hbs.md)
bundled with TAP.

The installation and health of this package can be checked with the 
`tanzu apps local-source-proxy health` command.

## Local Source Proxy Integration Health

The `tanzu apps local-source-proxy health` command provides a user-friendly overview of the overall
health of the Local Source Proxy. This information is obtained directly from the Local Source Proxy 
itself. By using this command, users can examine the response body, which includes the status code 
and message. This helps to identify and distinguish whether any failures originate from the 
Local Source Proxy or the upstream registry. The command supports multiple output formats, 
including `yaml` (default), `yml`, and `json`, which can be specified using the `--output` flag.

When executing this command, the API is called at the `/health` endpoint, and the CLI output can fall
into one of five possible scenarios based on the response received:

- When all checks pass (`--output/-o yaml`)

  ```yaml
  user_has_permission: true
  reachable: true
  upstream_authenticated: true
  overall_health: true
  message: "All health checks passed"
  ```

- When user does not have permission to list the service - Maybe: 403 from the Kube API Server

  ```yaml
  user_has_permission: false
  reachable: false
  upstream_authenticated: false
  overall_health: false
  message: "The current user does not have permission to access the local source proxy"
  ```

- When user can list the services, but its not there - Maybe: 404 from the Kube API Server

  ```yaml
  user_has_permission: true
  reachable: false
  upstream_authenticated: false
  overall_health: false
  message: "Local source proxy is not installed on the cluster"
  ```

- if `/health` from Local Source Proxy returns a 5xx

  ```yaml
  user_has_permission: true
  reachable: true
  upstream_authenticated: false
  overall_health: false
  message: "Local source proxy is not healthy. Error: <error>"
  ```

- if `/health` from upstream returns a non-2xx, 4xx, 5xx. `/health` from Local Source Proxy will still
  be 2xx

  ```yaml
  user_has_permission: true
  reachable: true
  upstream_authenticated: false
  overall_health: false
  message: "Local source proxy was unable to authenticate against the target registry. Error: <error>"
  ```

- When all checks pass (`--output/-o json`)

  ```json
  {
    "user_has_permission": true
    "reachable": true
    "upstream_authenticated": true
    "overall_health": true
    "message": ""
  }
  ```

## Update Local Source workloads

To create a workload from local source code, there are two options available. The first is utilizing
the Local Source Proxy, which automatically defaults to a predefined registry. The second is using 
the `--source-image` flag to specify a desired registry. In the case of the latter, users must be 
authenticated to access the registry.

To distinguish whether a workload was created with the Local Source Proxy or a source image, users 
can check if the workload contains the `local-source-proxy.apps.tanzu.vmware.com` annotation. 
This annotation serves as an indicator of the method used to create the workload, providing clarity 
on whether it originated from the Local Source Proxy or a specified source image.
<!-- Point to Create workload from local source in Tutorials section -->

Once workloads have been created using a source image, it is not possible to update them to utilize 
the Local Source Proxy. However, users are not required to repeatedly specify the source image during
subsequent updates, as it will be retrieved from the existing workload specification within the cluster.
Nevertheless, users do have the option to specify the `--source-image` flag again with a new value if
they wish to modify the registry or storage location for the source code.

```bash
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

Conversely, in the case of a workload that was initially created using the Local Source Proxy, if it
is subsequently updated with a command that employs the `--source-image` flag, the workload will
transition to utilizing the specified source image. As a result, the annotation that establishes
the connection between the workload and the Local Source Proxy will be removed.

```bash
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

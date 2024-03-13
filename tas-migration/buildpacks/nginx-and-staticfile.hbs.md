# Migrate NGINX & Staticfile buildpack

The TAP Web Servers Buildpack provides the functionalities corresponding to the TAS NGINX buildpack and TAS Staticfile Buildpack. See more details below on migration

<!-- do users do all these sections in order or do they choose the section for their use case -->

## Install a specific NGINX version

| Feature                                                                                                 | TAS                  | TAP                       |
| ------------------------------------------------------------------------------------------------------- | -------------------- | ------------------------- |
| Override app-based version detection (see Migration from `buildpack.yml` to environment variable below) | Using `builpack.yml` | Using `$BP_NGINX_VERSION` |

### Migration from buildpack.yml to environment variable

TAS buildpacks allows user to specify an NGINX version (or a version line i.e. mainline or stable)
using a buildpack.yml, for example:

```yaml
nginx:
  version: mainline
```

In TAP, set the `$BP_NGINX_VERSION` environment variable to specify which version (or version line)
should be installed.

Here’s the spec section from a sample `workload.yaml`:

```yaml
spec:
  build:
    env:
    - name: BP_NGINX_VERSION
       value: mainline
```

## Templating the nginx config

The TAP Web Servers buildpack supports templating in the `nginx.conf` file just like in TAS, such as
`\{{port}}`, `\{{env "YOUR-VARIABLE"}}`, `\{{module "module_name"}}`.

The template `\{{nameservers}}` isn’t supported as it was intended just for the Cloud Foundry platform.

## Static Web apps

The TAP Web Servers buildpack can automatically generate an `nginx.conf` for your app when built with
the environment $BP_WEB_SERVER=nginx. This is useful for apps that run in TAS using the Staticfile Buildpack.
It is possible to configure the generated `nginx.conf` in combination with other environment variables
with like:

- `$BP_WEB_SERVER_ROOT`
- `$BP_WEB_SERVER_LOCATION_PATH`
- `$BP_WEB_SERVER_ENABLE_PUSH_STATE`
- `$BP_WEB_SERVER_FORCE_HTTPS`
- `$BP_NGINX_STUB_STATUS_PORT`

See more details about their exact use in the [Paketo documentation for NGINX](https://paketo.io/docs/howto/web-servers/#automatically-generate-an-nginxconf).

Example workload `spec`:

```yaml
---
spec:
  build:
    env:
    - name: BP_WEB_SERVER
      value: nginx
    - name: BP_WEB_SERVER_ROOT
      value: build
    - name: BP_WEB_SERVER_ENABLE_PUSH_STATE
      value: "true"
```

## Set up Basic Authentication

| Feature                 | TAS                       | TAP                                                       |
| ----------------------- | ------------------------- | --------------------------------------------------------- |
| Provide HTTP Basic Auth | Using a `Staticfile.auth` | Using a binding of type `htpasswd` containing `.htpasswd` |

Instead of a file at the root of the app in TAP Staticfile buildpack applications, you would provide
basic authentication credentials via a service binding with the TAP Web Servers buildpack.

Create the service binding as a secret like this example:

```yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: basic-auth-config
  namespace: my-apps
type: service.binding/htpasswd
stringData:
  type: htpasswd
  .htpasswd: |
    user1:$foooo.oooo
    user2:$baaaaaaa.ar
```

Use the binding in the workload like this example:

```yaml
---
kind: Workload
apiVersion: carto.run/v1alpha1
metadata:
name: nginx-app
spec:
# ...
  params:
  - name: buildServiceBindings
    value:
      - name: basic-auth-config
        kind: Secret
        apiVersion: v1
```

For more details about service bindings, please see TAP documentation https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.7/tap/tanzu-build-service-tbs-workload-config.html

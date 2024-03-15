# Migrate from the NGINX and Staticfile CF buildpack to the Web Server Cloud Native Buildpack

This topic tells you how to migrate your NGINX or Staticfile app from using a Cloud Foundry buildpack
for Tanzu Application Service (commonly known as TAS for VMs) to using a Cloud Native Buildpack for
Tanzu Application Platform (commonly known as TAP).

The Tanzu Application Platform Web Server buildpack provides the capability corresponding to the
Tanzu Application Service NGINX buildpack and Tanzu Application Service Staticfile Buildpack.

## <a id="versions"></a> Install a specific NGINX version

The following table compares how Tanzu Application Service and Tanzu Application Platform handle
installing specific versions.

| Feature                               | Tanzu Application Service | Tanzu Application Platform |
| ------------------------------------- | ------------------------- | -------------------------- |
| Override app-based version detection. | Using `builpack.yml`      | Using `$BP_NGINX_VERSION`  |

### <a id="override-version-tas"></a> Tanzu Application Service: Override version detection

Tanzu Application Service buildpacks allows you to specify an NGINX version or version line,
such as mainline or stable, using a `buildpack.yml` file.

Example `buildpack.yml`:

```yaml
nginx:
  version: mainline
```

### <a id="override-version-tap"></a> Tanzu Application Platform: Override version detection

In Tanzu Application Platform, set the `$BP_NGINX_VERSION` environment variable to specify which
version or version line to install.

Example `spec` section from a `workload.yaml`:

```yaml
spec:
  build:
    env:
    - name: BP_NGINX_VERSION
       value: mainline
```
## <a id="templating"></a> Templating in the NGINX configuration file

The Tanzu Application Platform Web Servers buildpack supports templating in the `nginx.conf` file,
such as `\{{port}}`, `\{{env "YOUR-VARIABLE"}}`, `\{{module "module_name"}}`, similar to Tanzu Application Service.

Tanzu Application Platform does not support the template `\{{nameservers}}` because it was intended
only for the Cloud Foundry platform.

## <a id="static-apps"></a> Static web apps

The Tanzu Application Platform Web Server buildpack can automatically generate an `nginx.conf` for
your app when built with the environment `$BP_WEB_SERVER=nginx`.
This is useful for apps that run in Tanzu Application Service using the Staticfile Buildpack.

You can configure the generated `nginx.conf` in combination with other environment variables, for example:

- `$BP_WEB_SERVER_ROOT`
- `$BP_WEB_SERVER_LOCATION_PATH`
- `$BP_WEB_SERVER_ENABLE_PUSH_STATE`
- `$BP_WEB_SERVER_FORCE_HTTPS`
- `$BP_NGINX_STUB_STATUS_PORT`

For more information about how to use these environment variables, see the
[Paketo documentation for NGINX](https://paketo.io/docs/howto/web-servers/#automatically-generate-an-nginxconf).

Example `spec` section from a `workload.yaml`:

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

## <a id="basic-auth"></a> Configure basic authentication

The following table compares how you set up basic authentication in Tanzu Application Service and
Tanzu Application Platform.

| Feature                           | Tanzu Application Service | Tanzu Application Platform                              |
| --------------------------------- | ------------------------- | ------------------------------------------------------- |
| Provide HTTP basic authentication | Use a `Staticfile.auth`   | Use a binding of type `htpasswd` containing `.htpasswd` |

### <a id="basic-auth-tas"></a> Tanzu Application Service: Set up basic authentication

In Tanzu Application Service Staticfile buildpack applications you use a file at the root of the app.

### <a id="basic-auth-tap"></a> Tanzu Application Platform: Set up basic authentication

For the Tanzu Application Platform Web Server buildpack you provide basic authentication credentials
by using a service binding as follows:

1. Create the service binding as a secret. For example:

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

1. Use the binding in the `workload.yaml`. For example:

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

For more information about service bindings, see
[Configure Tanzu Build Service properties on a workload](../../tanzu-build-service/tbs-workload-config.hbs.md).

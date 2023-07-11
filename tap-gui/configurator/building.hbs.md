# Build your Customized Tanzu Developer Portal with Configurator

This topic tells you how to build your customized Tanzu Developer Portal
(formerly named Tanzu Application Platform GUI) with Configurator.

## <a id="prereqs"></a> Prerequisites

Meet the following prerequisites:

- Ensure that Configurator has a running and operating Tanzu Application Platform instance to build
  the customized portal and run the resulting customized image. You can use a `full` profile for
  everything or you can use a `build` profile for customizing the portal and a `view` profile for
  running the customized portal. For more information, see
  [Components and installation profiles for Tanzu Application Platform](../../about-package-profiles.hbs.md).

- Ensure that your instance of Tanzu Application Platform has a working supplychain that can build
  the Tanzu Developer Portal bundle. It doesn't need to be able to deliver it because currently
  an overlay is used to place the built image on the cluster where the pre-built Tanzu Developer
  Portal resides.

- Ensure that your developer namespace has access to both:

  - Your installation registry where the source Tanzu Application bundles are located
  - Your build registry where your built images are staged

  Verify that you have a working Tanzu Application Platform installation and you
  can build a sample application, such as `Tanzu-Java-Web-App` in
  [Generate an application with Application Accelerator](../../getting-started/generate-first-app.hbs.md).

- Ensure that your extra plug-ins are in an npm registry. This registry can be your own private
  registry or a plug-in registry if you intend to use a third-party or community plug-in.

> **Important** Tanzu Application Platform plug-ins cannot be removed from customized portals.
> However, if you decide you want to hide them, you can use the
> [runtime configuration](concepts.hbs.md#runtime) options in your `tap-values.yaml` file.

## <a id="prep-config-file"></a> Prepare your Configurator configuration file

To prepare your Configurator configuration file:

1. Create a new file called `tpb-config.yaml` by using the following template:

    ```yaml
    app:
      plugins:
        - name: 'NPM-PLUGIN-FRONTEND'
          version: 'NPM-PLUGIN-FRONTEND-VERSION'
    backend:
      plugins:
        - name: 'NPM-PLUGIN-BACKEND'
          version: 'NPM-PLUGIN-BACKEND-VERSION'
    ```

    Where:

    - `NPM-PLUGIN-FRONTEND` is the npm registry and module name of the front-end plug-in
    - `NPM-PLUGIN-FRONTEND-VERSION` is the version of your desired front-end plug-in that exists in
      the npm registry
    - `NPM-PLUGIN-BACKEND` is the npm registry and module name of the back-end plug-in that you want
    - `NPM-PLUGIN-BACKEND-VERSION` is the version of your desired back-end plug-in that exists in the
      npm registry

    The following example adds the sample `hello-world` plug-in and the `plugin-gitlab-loblaw` plug-in that are
    available in the internal package's registry:

    ```yaml
    app:
      plugins:
        - name: '@tpb/plugin-hello-world'
        - name: '@tpb/plugin-gitlab-loblaw'
          version: '^0.0.18'
    backend:
      plugins:
        - name: '@tpb/plugin-hello-world-backend'
    ```

2. Encode the file in base64, to later embed `tpb-config.yaml` in the workload definition file, by
   running:

   ```console
   base64 -i tdp-config.yaml
   ```

## <a id="prep-def-file"></a> Prepare your Configurator workload definition file

Create a file called `tdp-workload.yaml` with the following content:

```yaml
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  name: tdp-configurator
  namespace: DEVELOPER-NAMESPACE
  labels:
    apps.tanzu.vmware.com/workload-type: web
    app.kubernetes.io/part-of: tdp-configurator
spec:
  build:
    env:
      - name: BP_NODE_RUN_SCRIPTS
        value: 'set-app-config,set-tpb-config,portal:pack'
      - name: TPB_CONFIG
        value: /tmp/tpb-config.yaml
      - name: TPB_CONFIG_STRING
        value:
        ENCODED-TDP-CONFIG-VALUE

  source:
    image: TDP-IMAGE-LOCATION
    subPath: builder
```

Where:

- `DEVELOPER-NAMESPACE` is an appropriately configured developer namespace on the cluster
- `ENCODED-TDP-CONFIG-VALUE` is the base64-encoded value that you encoded earlier
- `TDP-IMAGE-LOCATION` is the location of the Configurator image in the image
  registry from which you installed Tanzu Application Platform

> **Important** Depending on which supply chain you're using or how you've configured it, you might
> need to add extra sections to your workload definition file to accommodate activities such as
> testing.

For example:

```yaml
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  name: tdp-configurator
  namespace: default
  labels:
    apps.tanzu.vmware.com/workload-type: web
    app.kubernetes.io/part-of: tdp-configurator
spec:
  build:
    env:
      - name: BP_NODE_RUN_SCRIPTS
        value: 'set-app-config,set-tpb-config,portal:pack'
      - name: TPB_CONFIG
        value: /tmp/tpb-config.yaml
      - name: TPB_CONFIG_STRING
        value:
        YXBwOgogIHBsdWdpbnM6CiAgICAtIG5hbWU6ICdAdHBiL3BsdWdpbi1oZWxsby13b3JsZCcKYmFja2VuZDoKICBwbHVnaW5zOgogI
        CAgLSBuYW1lOiAnQHRwYi9wbHVnaW4taGVsbG8td29ybGQtYmFja2VuZCcK
  source:
    image: TDP-IMAGE-LOCATION
    subPath: builder
```

## <a id="submit-your-workload"></a> Submit your workload

Submit the workload definition file you created earlier by running:

```console
tanzu apps workload create -f tdp-workload.yaml
```

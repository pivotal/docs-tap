# Build your Customized Tanzu Developer Portal with Configurator (beta)

This topic tells you how to build your customized Tanzu Developer Portal
(formerly named Tanzu Application Platform GUI) with Configurator.

> **Caution** The Configurator tool is in beta. Do not use it in a production environment.

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

- Ensure that your extra plug-ins are in the [npmjs.com](https://www.npmjs.com/) registry.

- Ensure that [Carvel tools](https://carvel.dev/) is installed on your workstation.
  `imgpkg`, in particular, must be installed to perform some of the build steps.

- Ensure that the [yq tool](https://github.com/mikefarah/yq/#install) is installed.

- Ensure that the [Docker](https://docs.docker.com/engine/install/) CLI is installed and that you've
  logged into your registry.

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

    The following example adds the sample `hello-world` plug-in, which is available in the internal
    package's registry:

    ```yaml
    app:
      plugins:
        - name: '@tpb/plugin-hello-world'
          version: '^1.6.0-release-1.6.x.1'
    backend:
      plugins:
        - name: '@tpb/plugin-hello-world-backend'
          version: '^1.6.0-release-1.6.x.1'
    ```

2. Encode the file in base64, to later embed `tpb-config.yaml` in the workload definition file, by
   running:

   ```console
   base64 -i tpb-config.yaml
   ```

## <a id="prep-ident-image"></a> Identify your Configurator foundation image

To build a customized Tanzu Developer Portal, you must identify the image that contains the
foundation that is ready to pass through the supplychain. Depending on how you installed things, this
could either be on `registry.tanzu.vmware.com` or on the local image registry (`imgpkg`) that you
moved the installation packages to.

## <a id="prep-ident-image"></a> Identify your Configurator image

To build a customized Tanzu Developer Portal, you must identify the Configurator image to pass
through the supply chain. Depending on your choices during installation, this is on either
`registry.tanzu.vmware.com` or the local image registry (`imgpkg`) that you moved the installation
packages to.

Using imgpkg v0.39.0 or earlier
: If using imgpkg v0.39.0 or earlier:

  1. Using the `imgpkg` tool, retrieve the image location by running:

     ```console
     imgpkg describe -b $(kubectl get -n tap-install $(kubectl get package -n tap-install \
     --field-selector spec.refName=tpb.tanzu.vmware.com -o name) -o \
     jsonpath="{.spec.template.spec.fetch[0].imgpkgBundle.image}") -o yaml --tty=true | grep -A 1 \
     "kbld.carvel.dev/id:[[:blank:]]*[^[:blank:]]*configurator" | grep "image:" | sed 's/[[:blank:]]*image:[[:blank:]]*//g'
     ```

     Output similar to the following appears:

     ```console
     IMAGE-REGISTRY/tap-packages@sha256:bea2f5bec5c5102e2a69a4c5047fae3d51f29741911cf5bb588893aa4e03ca27
     ```

  2. Record this value to later use it in place of the `TDP-IMAGE-LOCATION` placeholder in the
     workload definition.

Using imgpkg v0.40.0 or later
: If using imgpkg v0.40.0 or later:

  1. Using the `imgpkg` tool, download the bundle by running:

     ```console
     imgpkg pull -b $(kubectl get -n tap-install $(kubectl get package -n tap-install \
     --field-selector spec.refName=tpb.tanzu.vmware.com -o name) -o \
     jsonpath="{.spec.template.spec.fetch[0].imgpkgBundle.image}") -o bundle
     ```

  2. Retrieve the image location by running:

     ```console
     cat bundle/.imgpkg/images.yml | grep -A 1 "kbld.carvel.dev/id:[[:blank:]]*[^[:blank:]]*configurator" | \
     grep "image:" | sed 's/[[:blank:]]*image:[[:blank:]]*//g'
     ```

     Output similar to the following appears:

     ```console
     IMAGE-REGISTRY/tap-packages@sha256:bea2f5bec5c5102e2a69a4c5047fae3d51f29741911cf5bb588893aa4e03ca27
     ```

  3. Record this value to later use it in place of the `TDP-IMAGE-LOCATION` placeholder in the
     workload definition.

   ```console
   imgpkg pull -b ${OUTPUT_IMAGE} -o tpb-package
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
        value: 'set-tpb-config,portal:pack'
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
        value: 'set-tpb-config,portal:pack'
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

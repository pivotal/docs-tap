# Build your customized Tanzu Developer Portal with Configurator

This topic tells you how to build your customized Tanzu Developer Portal with Configurator.

## <a id="prereqs"></a> Prerequisites

Ensure that the following is true:

- Configurator has a running and operating Tanzu Application Platform instance to build the
  customized portal and run the resulting customized image. You can use a `full` profile for
  everything or you can use a `build` profile for customizing the portal and a `view` profile for
  running the customized portal. For more information, see
  [Components and installation profiles for Tanzu Application Platform](../../about-package-profiles.hbs.md).

- Your instance of Tanzu Application Platform has a working supply chain that can build the Tanzu
  Developer Portal bundle. It doesn't need to be able to deliver it because currently an overlay is
  used to place the built image on the cluster where the pre-built Tanzu Developer Portal resides.

- Your developer namespace has access to both:

  - Your installation registry where the source Tanzu Application bundles are located
  - Your build registry where your built images are staged

- You have a working Tanzu Application Platform installation and you can build a sample application,
  such as `Tanzu-Java-Web-App` in
  [Generate an application with Application Accelerator](../../getting-started/generate-first-app.hbs.md).

- Your extra plug-ins are in the [npmjs.com](https://www.npmjs.com/) registry or a private registry.

- [Carvel tools](https://carvel.dev/) is installed on your workstation. `imgpkg`, in particular,
  must be installed to perform some of the build steps.

- The [yq tool](https://github.com/mikefarah/yq/#install) is installed.

- The [Docker](https://docs.docker.com/engine/install/) CLI is installed and you are logged into
  your registry.

> **Important** Tanzu Application Platform plug-ins cannot be removed from customized portals.
> However, if you decide you want to hide them, you can use the
> [runtime configuration](concepts.hbs.md#runtime) options in your `tap-values.yaml` file.

## <a id="prep-config-file"></a> Prepare your Configurator configuration file

To prepare your Configurator configuration file:

1. Create a new file called `tdp-config.yaml` by using the following template:

    ```yaml
    app:
      plugins:
        - name: "NPM-PLUGIN-FRONTEND"
          version: "NPM-PLUGIN-FRONTEND-VERSION"
    backend:
      plugins:
        - name: "NPM-PLUGIN-BACKEND"
          version: "NPM-PLUGIN-BACKEND-VERSION"
    ```

   Where:

   - `NPM-PLUGIN-FRONTEND` is the npm registry and module name of the front-end plug-in
   - `NPM-PLUGIN-FRONTEND-VERSION` is the version of your desired front-end plug-in that exists in
     the npm registry
   - `NPM-PLUGIN-BACKEND` is the npm registry and module name of the back-end plug-in that you want
   - `NPM-PLUGIN-BACKEND-VERSION` is the version of your desired back-end plug-in that exists in the
     npm registry

   The following example adds the sample `techinsights` plug-in. The plug-in wrapper is available
   in the [VMware NPM repository](https://www.npmjs.com/search?q=vmware-tanzu):

    ```yaml
    app:
      plugins:
        - name: "@vmware-tanzu/tdp-plugin-techinsights"
          version: "0.0.2"

    backend:
      plugins:
        - name: "@vmware-tanzu/tdp-plugin-techinsights-backend"
          version: "0.0.2"
    ```

1. If you plan to add plug-ins that exist in a private registry,
   [configure the Configurator with a private registry](private-registries.hbs.md).

1. Encode the file in Base64, to later embed `tdp-config.yaml` in the workload definition file, by
   running:

   ```console
   base64 -i tdp-config.yaml
   ```

   If no plug-ins are specified in your `tdp-config.yaml` file, the following plug-ins are present
   by default:

   - Runtime Resources Visibility
   - Application Live View
   - Application Accelerator
   - API Documentation
   - Supply Chain Choreographer
   - Security Analysis
   - DORA Metrics

## <a id="prep-ident-image"></a> Identify your Configurator image

To build a customized Tanzu Developer Portal, you must identify the Configurator image to pass
through the supply chain. Depending on your choices during installation, this is on either
`registry.tanzu.vmware.com` or the local image registry (`imgpkg`) that you moved the installation
packages to.

1. Using the `imgpkg` tool, retrieve the image location by running:

   ```console
   imgpkg describe -b $(kubectl get -n tap-install $(kubectl get package -n tap-install \
   --field-selector spec.refName=tpb.tanzu.vmware.com -o name) -o \
   jsonpath="{.spec.template.spec.fetch[0].imgpkgBundle.image}") -o yaml --tty=true | grep -A 1 \
   "kbld.carvel.dev/id: harbor-repo.vmware.com/esback/configurator" | grep "image: " | sed 's/\simage: //g'
   ```

   Output similar to the following appears:

   ```console
   IMAGE-REGISTRY/tap-packages@sha256:bea2f5bec5c5102e2a69a4c5047fae3d51f29741911cf5bb588893aa4e03ca27
   ```

2. Record this value to later use it in place of the `TDP-IMAGE-LOCATION` placeholder in the
   workload definition.

## Choose a method for customization

Now it's time to pass your workload through a supply chain. There are two options that you can
pursue in order to build your custom portal:

- [Use an existing supply chain](#method-1-use-an-existing-supply-chain)
- [Use a custom supply chain](#method-2-use-a-custom-supply-chain)

Use an existing supply chain
: To use an existing supply chain to build your custom portal:

  1. Create a file called `tdp-workload.yaml` with the following content:

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
          value: 'set-tdp-config,portal:pack'
        - name: TDP_CONFIG
          value: /tmp/tdp-config.yaml
        - name: TDP_CONFIG_STRING
          value: ENCODED-TDP-CONFIG-VALUE

    source:
      image: TDP-IMAGE-LOCATION
      subPath: builder
  ```

  Where:

  - `DEVELOPER-NAMESPACE` is an appropriately configured developer namespace on the cluster.
  - `ENCODED-TDP-CONFIG-VALUE` is the Base64-encoded value that you encoded earlier.
  - `TDP-IMAGE-LOCATION` is the location of the Configurator image in the image registry from which
    you installed Tanzu Application Platform. You discovered this location earlier when you
    [identified your Configurator image](#prep-ident-image).

  > **Important** Depending on which supply chain you're using or how you configured it, you might
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
          value: "set-tdp-config,portal:pack"
        - name: TDP_CONFIG
          value: /tmp/tdp-config.yaml
        - name: TDP_CONFIG_STRING
          value: YXBwOgogIHBsdWdpbnM6CiAgICAtIG5hbWU6ICdAdm13YXJlLXRhbnp1L3RkcC1wbHVnaW4tdGVjaGluc2lnaHRzJwogICAgICB2ZXJzaW9uOiAnMC4wLjInCgpiYWNrZW5kOgogIHBsdWdpbnM6IAogICAgLSBuYW1lOiAnQHZtd2FyZS10YW56dS90ZHAtcGx1Z2luLXRlY2hpbnNpZ2h0cy1iYWNrZW5kJwogICAgICB2ZXJzaW9uOiAnMC4wLjIn
    source:
      image: TDP-IMAGE-LOCATION
      subPath: builder
  ```

  The `TDP_CONFIG_STRING` value can be decoded as the earlier example that includes the Tech Insights
  front-end and back-end plug-ins.

  `TDP-IMAGE-LOCATION` is the location of your Configurator image identified in earlier steps.

  1. Submit your workload definition file you created earlier by running:

  ```console
  tanzu apps workload create -f tdp-workload.yaml
  ```

  After the job completes the Image Provider stage of your supply chain, you're ready to move on to
  [running your customized Tanzu Deveoper Portal instance](running.hbs.md)

  > **Note** The supply chain does not need to go beyond the image-provider stage. After an image is
  > built, you can proceed to [Run your Customized Tanzu Developer Portal](running.hbs.md).

Use a custom supply chain
: To create a custom supply chain for `workload-type`: `tdp` that encompasses just the steps necessary
  to build the customized image.

  1. Create a file called `tdp-sc.yaml` with the following content:

    ```yaml
    apiVersion: carto.run/v1alpha1
    kind: ClusterSupplyChain
    metadata:
      name: tdp-configurator
    spec:
      resources:
      - name: source-provider
        params:
        - default: default
          name: serviceAccount
        - default: TDP-IMAGE-LOCATION
          name: tdp_configurator_bundle
        templateRef:
          kind: ClusterSourceTemplate
          name: tdp-source-template
      - name: image-provider
        params:
        - default: default
          name: serviceAccount
        - name: registry
          default:
            ca_cert_data: ""
            repository: IMAGE-REPOSITORY
            server: REGISTRY-HOSTNAME
        - default: default
          name: clusterBuilder
        sources:
        - name: source
          resource: source-provider
        templateRef:
          kind: ClusterImageTemplate
          name: tdp-kpack-template

      selectorMatchExpressions:
      - key: apps.tanzu.vmware.com/workload-type
        operator: In
        values:
        - tdp
    ---
    apiVersion: carto.run/v1alpha1
    kind: ClusterImageTemplate
    metadata:
      name: tdp-kpack-template
    spec:
      healthRule:
        multiMatch:
          healthy:
            matchConditions:
            - status: "True"
              type: BuilderReady
            - status: "True"
              type: Ready
          unhealthy:
            matchConditions:
            - status: "False"
              type: BuilderReady
            - status: "False"
              type: Ready
      imagePath: .status.latestImage
      lifecycle: mutable
      params:
      - default: default
        name: serviceAccount
      - default: default
        name: clusterBuilder
      - name: registry
        default: {}
      ytt: |
        #@ load("@ytt:data", "data")
        #@ load("@ytt:regexp", "regexp")

        #@ def merge_labels(fixed_values):
        #@   labels = {}
        #@   if hasattr(data.values.workload.metadata, "labels"):
        #@     exclusions = ["kapp.k14s.io/app", "kapp.k14s.io/association"]
        #@     for k,v in dict(data.values.workload.metadata.labels).items():
        #@       if k not in exclusions:
        #@         labels[k] = v
        #@       end
        #@     end
        #@   end
        #@   labels.update(fixed_values)
        #@   return labels
        #@ end

        #@ def image():
        #@   return "/".join([
        #@    data.values.params.registry.server,
        #@    data.values.params.registry.repository,
        #@    "-".join([
        #@      data.values.workload.metadata.name,
        #@      data.values.workload.metadata.namespace,
        #@    ])
        #@   ])
        #@ end

        #@ bp_node_run_scripts = "set-tpb-config,portal:pack"
        #@ tpb_config = "/tmp/tpb-config.yaml"

        #@ for env in data.values.workload.spec.build.env:
        #@   if env.name == "TPB_CONFIG_STRING":
        #@     tpb_config_string = env.value
        #@   end
        #@   if env.name == "BP_NODE_RUN_SCRIPTS":
        #@     bp_node_run_scripts = env.value
        #@   end
        #@   if env.name == "TPB_CONFIG":
        #@     tpb_config = env.value
        #@   end
        #@ end

        apiVersion: kpack.io/v1alpha2
        kind: Image
        metadata:
          name: #@ data.values.workload.metadata.name
          labels: #@ merge_labels({ "app.kubernetes.io/component": "build" })
        spec:
          tag: #@ image()
          serviceAccountName: #@ data.values.params.serviceAccount
          builder:
            kind: ClusterBuilder
            name: #@ data.values.params.clusterBuilder
          source:
            blob:
              url: #@ data.values.source.url
            subPath: builder
          build:
            env:
            - name: BP_OCI_SOURCE
              value: #@ data.values.source.revision
            #@  if regexp.match("^([a-zA-Z0-9\/_-]+)(\@sha1:)?[0-9a-f]{40}$", data.values.source.revision):
            - name: BP_OCI_REVISION
              value: #@ data.values.source.revision
            #@ end
            - name: BP_NODE_RUN_SCRIPTS
              value: #@ bp_node_run_scripts
            - name: TPB_CONFIG
              value: #@ tpb_config
            - name: TPB_CONFIG_STRING
              value: #@ tpb_config_string

    ---
    apiVersion: carto.run/v1alpha1
    kind: ClusterSourceTemplate
    metadata:
      name: tdp-source-template
    spec:
      healthRule:
        singleConditionType: Ready
      lifecycle: mutable
      params:
      - default: default
        name: serviceAccount
      revisionPath: .status.artifact.revision
      urlPath: .status.artifact.url
      ytt: |
        #@ load("@ytt:data", "data")

        #@ def merge_labels(fixed_values):
        #@   labels = {}
        #@   if hasattr(data.values.workload.metadata, "labels"):
        #@     exclusions = ["kapp.k14s.io/app", "kapp.k14s.io/association"]
        #@     for k,v in dict(data.values.workload.metadata.labels).items():
        #@       if k not in exclusions:
        #@         labels[k] = v
        #@       end
        #@     end
        #@   end
        #@   labels.update(fixed_values)
        #@   return labels
        #@ end

        ---
        apiVersion: source.apps.tanzu.vmware.com/v1alpha1
        kind: ImageRepository
        metadata:
          name: #@ data.values.workload.metadata.name
          labels: #@ merge_labels({ "app.kubernetes.io/component": "source" })
        spec:
          serviceAccountName: #@ data.values.params.serviceAccount
          interval: 10m0s
          #@ if hasattr(data.values.workload.spec, "source") and hasattr(data.values.workload.spec.source, "image"):
          image: #@ data.values.workload.spec.source.image
          #@ else:
          image: #@ data.values.params.tdp_configurator_bundle
          #@ end
    ```

   Where:

   - `TDP-IMAGE-LOCATION` is the location of the Configurator image in the image registry from which
     you installed Tanzu Application Platform. You discovered this location earlier when you
     [identified your Configurator image](#prep-ident-image).
   - `REGISTRY-HOSTNAME` is the name of the container registry that your developer namespace has been
     configured to push artifacts to.
   - `IMAGE-REPOSITORY` is the name of the repository (folder) on the `REGISTRY-HOSTNAME` that you want
     the built artifacts to be pushed to.

1. Submit the custom supply chain file you created earlier by running:

   ```console
   tanzu apps workload create -f tdp-sc.yaml
   ```

1. Create a file called `tdp-workload.yaml` with the following content:

    ```yaml
    apiVersion: carto.run/v1alpha1
    kind: Workload
    metadata:
      name: tdp-configurator-1-sc
      namespace: DEVELOPER-NAMESPACE
      labels:
        apps.tanzu.vmware.com/workload-type: tdp
        app.kubernetes.io/part-of: tdp-configurator-1-custom
    spec:
      build:
        env:
          - name: TPB_CONFIG_STRING
            value: ENCODED-TDP-CONFIG-VALUE
    ```

   Where:

   - `DEVELOPER-NAMESPACE` is an appropriately configured developer namespace on the cluster.
   - `ENCODED-TDP-CONFIG-VALUE` is the Base64-encoded value that you encoded earlier.

1. Submit the workload definition file you created earlier by running:

   ```console
   tanzu apps workload create -f tdp-workload.yaml
   ```

After the job completes the Image Provider stage of your supply chain,
[run your customized Tanzu Developer Portal instance](running.hbs.md).
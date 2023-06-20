<h1>Building your Customized Tanzu Developer Portal with the Configurator</h1>

<h2>Prerequisites</h2>

1. Tanzu Developer Portal Configurator requires a running and operating Tanzu Application Platform instance both to build the customized portal, as well as to run the resulting customized image. You can use a `full` profile for everything or you can use a `build` profile for the customization process and a `view` profile for running the customized portal.

2. Your instance of Tanzu Application Platform must have a working supplychain that can build the Tanzu Developer Portal bundle. However, it doesn't need to be able to deliver it as currently we're using an overlay to place the built image on the cluster where the pre-built Tanzu Developer Portal resides.

3. You must have access to an installation registry (where the source Tanzu APplication bundles are located) as well as a build registry (where your built images are staged). If you've got a working Tanzu Application Platform installation and can build a sample application (like Tanzu-Java-Web-App in the Getting Started tutorial), you likely have everything you need.

4. You'll need your additional plugins to be located on an NPM registry. This can either be your own private one or a plugin one if you intend to use a 3rd party / community plugin.

>**Important**: Tanzu Application Platform plugins can not be removed from the customized portals. However, if you decide you want to hide them, you can use the [runtime configuration](./concepts.md#runtime) options in your `tap-values.yaml`


<h2> Preparing your Tanzu Developer Portal Configurator Configuration File</h2>

1. Create a new file called tdp-config.yaml using the template below:

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

- `NPM-PLUGIN-FRONTEND` is the NPM registry and module name of your desired front-end plugin.
- `NPM-PLUGIN-FRONTEND-VERSION` is version of your desired front-end plugin that exists on the NPM registry.
- `NPM-PLUGIN-BACKEND` is the NPM registry and module name of your desired back-end plugin.
- `NPM-PLUGIN-BACKEND-VERSION` is version of your desired back-end plugin that exists on the NPM registry.

For example, the below would add the sample Hello World plugin that is available on the internal package's registry:

```yaml
app:
  plugins:
    - name: '@tpb/plugin-hello-world'
backend:
  plugins:
    - name: '@tpb/plugin-hello-world-backend'
```

2. <a id="encode"></a>You'll need to `base64` encode the above file to embed it in the below workload definition file. You can do this with the following command:

```bash
base64 -i tdp-config.yaml
```


<h2>Preparing your Tanzu Developer Portal Configurator Workload Definition File</h2>

1. <a id="workload"></a>Create a file called `tdp-workload.yaml` with the following contents:

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

- `DEVELOPER-NAMESPACE` is an appropriately configured developer namespace on the cluster.
- `ENCODED-TDP-CONFIG-VALUE` is the `base64` encoded value performed in the [previous step](#encode).
- `TDP-IMAGE-LOCATION` is the location of the Tanzu Developer Portal Configurator image on the image registry you installed Tanzu Application Platform from.

>**Important**: Image references for the default included Tanzu Developer Portal Configurator images by default are as follows:
>| 1. 

>**Important**: Depending on which supply chain you're using or how you've configured it, you may need to add additional sections to your workload definition file to accomadate things like testing.

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
<h2>Submitting Your Workload</h2>

You can submit the workload definition file you created in the [previous step](#workload) using the command:

```bash
tanzu apps workload create -f tdp-workload.yaml
```


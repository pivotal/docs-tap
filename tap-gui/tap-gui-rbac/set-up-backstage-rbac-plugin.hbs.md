# Set up the Backstage role-based access control plug-in for Tanzu Developer Portal

This section provides an overview of the Backstage role-based access control plug-in (RBAC) plug-in
and demonstrates how to enable it in Tanzu Developer Portal. For more information on the plug-in,
refer to [Backstage official website](https://backstage.spotify.com/marketplace/spotify/plugin/rbac/),
[documentation]((https://www.npmjs.com/package/@spotify/backstage-plugin-rbac)) for the plug-in
frontend and [documentation](https://www.npmjs.com/package/@spotify/backstage-plugin-rbac-backend)
for the plug-in backend.

## <a id='rbac-overview'></a> Overview of the RBAC Plugin

The Backstage RBAC plug-in works with the [permission framework](set-up-tap-gui-prmssn-frmwrk.hbs.md)
to enable support for role-based access control for Tanzu Application Platform operators.

## <a id='install-rbac'></a> Installing the RBAC Plugin

To create a customized Tanzu Developer Portal with the RBAC plug-in, follow the steps in
[building a customized Tanzu Developer Portal with Configurator](../configurator/building.hbs.md)
modifying the steps to be like so:

1. Create a `tdp-config.yaml` file with the following structure:

    ```yaml
    app:
      plugins:
        - name: "@vmware-tanzu/tdp-plugin-rbac"
          version: "2.0.0"

    backend:
      plugins:
        - name: "@vmware-tanzu/tdp-plugin-rbac-backend"
          version: "2.0.0"
        - name: "@vmware-tanzu/tdp-plugin-permission-backend"
          version: "2.0.0"
    ```

    > **IMPORTANT** If you are installing additional plug-ins, `@vmware-tanzu/tdp-plugin-rbac-backend`
    > must still come before `@vmware-tanzu/tdp-plugin-permission-backend` in the `backend.plugins`
    > section in `tdp-config.yaml`.

2. Encode the `tdp-config.yaml` file in Base64 by running:

    ```shell
    base64 -i tdp-config.yaml
    ```

3. In your `tdp-workload.yaml` file, replace `ENCODED-TDP-CONFIG-VALUE` with the result of the
   Base64-encoded value from the prior step. Here is an example of what the `tdp-workload.yaml` file
   can look like:

    ```yaml
    apiVersion: carto.run/v1alpha1
    kind: Workload
    metadata:
      name: tdp-configurator
      labels:
        apps.tanzu.vmware.com/workload-type: web
        app.kubernetes.io/part-of: tdp-configurator
    spec:
      build:
        env:
          - name: BP_NODE_RUN_SCRIPTS
            value: "set-tdp-config,portal:pack"
          - name: TPB_CONFIG
            value: /tmp/tdp-config.yaml
          - name: TPB_CONFIG_STRING
            value: YXBwOgogIHBsdWdpbnM6CiAgICAtIG5hbWU6ICJAdm13YXJlLXRhbnp1L3RkcC1wbHVnaW4tcmJhYyIKICAgICAgdmVyc2lvbjogIjIuMC4wIgoKYmFja2VuZDoKICBwbHVnaW5zOgogICAgLSBuYW1lOiAiQHZtd2FyZS10YW56dS90ZHAtcGx1Z2luLXJiYWMtYmFja2VuZCIKICAgICAgdmVyc2lvbjogIjIuMC4wIgogICAgLSBuYW1lOiAiQHZtd2FyZS10YW56dS90ZHAtcGx1Z2luLXBlcm1pc3Npb24tYmFja2VuZCIKICAgICAgdmVyc2lvbjogIjIuMC4wIgo=
      source:
        image: TDP-IMAGE-LOCATION
        subPath: builder
    ```

    Where `TDP-IMAGE-LOCATION` is the location of the Configurator image.

4. Apply the `tdp-workload.yaml` file as a workload by running:

    ```shell
    tanzu apps workload apply -f tdp-workload.yaml -n DEVELOPER-NAMESPACE
    ```

    Where `DEVELOPER-NAMESPACE` is the Kubernetes namespace you have created to run your workloads.
    An example command to create such a namespace is:

    ```shell
    kubectl create ns my-apps
    ```

5. Once the workload has gone through the `image-provider` stage in the supply chain, following the
   steps in [running a customized Tanzu Developer Portal](../configurator/running.hbs.md) to
   retrieve the location of the customized Tanzu Developer Portal image that the workload produces
   as well as to overlay the customized image onto the currently running instance of Tanzu Developer
   Portal.

## <a id='enable-rbac'></a> Enabling the RBAC Plugin

To enable the RBAC plug-in, first ensure the permission framework is enabled in the
`tap_gui.app_config` section of your `tap-values.yaml`. Then, add the plug-ins which use permissions
and entity references for users and groups who should be permitted to configure RBAC as well as the
license key to use the RBAC plug-in:

```yaml
permission:
  enabled: true
  permissionedPlugins:
    - PLUGIN-NAME
  rbac:
    authorizedUsers:
      - group:NAMESPACE/NAME
      - user:NAMESPACE/NAME
spotify:
  licenseKey: SPOTIFY-LICENSE-KEY
```

Where:

- `PLUGIN-NAME` is a plug-in that includes permissions. At the moment, the Catalog plug-in is the only
  first-party Backstage plug-in that includes permissions.
- `NAMESPACE` is usually `default` unless defined otherwise in the definition file.
- `NAME` is the name of the group or user.
- `SPOTIFY-LICENSE-KEY` is the license key you received from Spotify.

The `tap-gui` section in `tap-values.yaml` should then look something like so:

```yaml
tap_gui:
  app_config:
    ... # other Tanzu Developer Portal app configuration
    permission:
      enabled: true
      permissionedPlugins:
        - PLUGIN-NAME
      rbac:
        authorizedUsers:
          - group:NAMESPACE/NAME
          - user:NAMESPACE/NAME
    spotify:
      licenseKey: SPOTIFY-LICENSE-KEY
```

Along with the overlay from [running a customized Tanzu Developer Portal](../configurator/running.hbs.md),
the `tap-values.yaml` file should have the `tap_gui` section and `package_overlays` section like so:

```yaml
tap_gui:
  app_config:
    ... # other Tanzu Developer Portal app configuration
    permission:
      enabled: true
      permissionedPlugins:
        - PLUGIN-NAME
      rbac:
        authorizedUsers:
          - group:NAMESPACE/NAME
          - user:NAMESPACE/NAME
    spotify:
      licenseKey: SPOTIFY-LICENSE-KEY

package_overlays:
- name: tap-gui
  secrets:
  - name: tdp-app-image-overlay-secret
```

After updating the `tap-values.yaml` file, reinstall Tanzu Developer Portal package by following the
steps in [Upgrade Tanzu Application Platform](../../upgrading.hbs.md); this command should be run
with the `TAP_VERSION` you are using:

```shell
tanzu package installed update tap -p tap.tanzu.vmware.com -v ${TAP_VERSION}  --values-file tap-values.yaml --namespace tap-install
```

When you open Tanzu Developer Portal in your browser, you should now see the `RBAC` tab in the sidebar.

![Backstage-RBAC-Plugin](../images/backstage-rbac-plugin.png)

## <a id='extra'></a> Extra

If you would like to identify a user who is logged in using an authentication provider as a user who
is also authorized to author RBAC policies, your `tap_gui` section in `tdp-values.yaml` may look
like below as an example that's using Google authentication:

```yaml
tap_gui:
  app_config:
    auth:
      providers:
        google: # https://backstage.io/docs/auth/google/provider/
          clientId: GOOGLE-CLIENT-ID
          clientSecret: GOOGLE-CLIENT-SECRET
    permission:
      enabled: true
      permissionedPlugins:
      - catalog
      rbac:
        authorizedUsers:
        - group:default/admins
        - user:default/USER-GOOGLE-EMAIL
    spotify:
      licenseKey: SPOTIFY-LICENSE-KEY
```

Where:

- `GOOGLE-CLIENT-ID` and `GOOGLE-CLIENT-SECRET` are credentials provided after setting up Google
  authentication following [instructions from Backstage documentation](https://backstage.io/docs/auth/google/provider/)
- `USER-GOOGLE-EMAIL` is the Google account being used to log in to Tanzu Developer Portal
- `SPOTIFY-LICENSE-KEY` is the license key provided by Spotify

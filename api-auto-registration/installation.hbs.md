# Install API Auto Registration

This topic describes how you can install API Auto Registration from the Tanzu Application Platform package repository.

> **Note** Follow the steps in this topic if you do not want to use a profile to install API Auto Registration. For more information about profiles, see [Components and installation profiles](../about-package-profiles.hbs.md).

## <a id='prereqs'></a>Tanzu Application Platform prerequisites

Before installing API Auto Registration, complete all prerequisites to install Tanzu Application Platform.
See [Tanzu Application Platform Prerequisites](../prerequisites.md).

## <a id='prereqs'></a> Using with TLS

Starting in Tanzu Application Platform v1.4, TLS is turned on by default for several components.
API Auto Registration automatically trusts the CA for the shared `ingress_issuer` when using the default ClusterIssuer `tap-ingress-selfsigned`.
This change means that a `Certificate` is automatically generated using this issuer.

If you do not want a `Certificate` to generate automatically, you can set the `auto_generate_cert` flag to `false` in the values file.
To replace the default with a custom ingress issuer, see [Security and compliance](../security-and-compliance/about.hbs.md).
Whenever you do not use the default ClusterIssuer `tap-ingress-selfsigned`, do not automatically generate certificates,
or use other custom CAs, you must manually set the certificate. See [Troubleshooting](../api-auto-registration/troubleshooting.hbs.md#set-ca-crt).

## <a id='install'></a>Install

To install the API Auto Registration package:

1. List version information for the package by running:

    ```console
    tanzu package available list apis.apps.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list apis.apps.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for apis.apps.tanzu.vmware.com...
      NAME                                     VERSION  RELEASED-AT
      apis.apps.tanzu.vmware.com  0.1.0        2022-08-30 19:00:00 -0500 -05
      apis.apps.tanzu.vmware.com  0.2.0        2022-11-24 12:20:00 -0500 -05
    ```

1. (Optional) Gather values schema.

    Display values schema of the package:

    ```console
    tanzu package available get apis.apps.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed in the earlier step.

    For example:

    ```console
    tanzu package available get apis.apps.tanzu.vmware.com/0.2.2 --values-schema --namespace tap-install

    Retrieving package details for apis.apps.tanzu.vmware.com/0.2.2...
    KEY                        DEFAULT                                       TYPE     DESCRIPTION
    ca_cert_data                                                             string   Optional: PEM-encoded certificate data for the controller to trust TLS.
    ingress_issuer                                                           string   Optional: Name of the default cluster issuer used to generate certificates
    auto_generate_cert         true                                          boolean  Flag that indicates if a cert-manager certificate should be generated using the ingress_issuer. Only applies if the ingress_issuer is specified
    connections with a custom CA
    cluster_name               dev                                           string   Name of the cluster used for setting the API entity lifecycle in TAP GUI. The value should be unique for each run cluster.
    sync_period                5m                                            string   Time period used for reconciling an APIDescriptor.
    tap_gui_url                http://server.tap-gui.svc.cluster.local:7000  string   FQDN URL for TAP GUI.
    replicas                   1                                             integer  Number of controller replicas to deploy.
    resources.limits.cpu       500m                                          string   CPU limit of the controller.
    resources.limits.memory    500Mi                                         string   Memory limit of the controller.
    resources.requests.cpu     20m                                           string   CPU request of the controller.
    resources.requests.memory  100Mi                                         string   Memory request of the controller.
    logging_profile            production                                    string   Logging profile for controller. If set to development, use console logging with full stack traces, else use JSON logging.
    ```

2. Locate the Tanzu Developer Portal (formerly Tanzu Application Platform GUI) URL.

    When running on a full profile Tanzu Application Platform cluster, the default value of Tanzu Developer Portal URL is sufficient. You can edit this to match the externally available FQDN of Tanzu Developer Portal to display the entity URL in the externally accessible APIDescriptor status.

    When installed in a run cluster or with a profile where Tanzu Developer Portal is not installed in the same cluster, you must set the `tap_gui_url` parameters correctly for successful entity registration with Tanzu Developer Portal.

    You can locate the `tap_gui_url` by going to the view cluster with the Tanzu Developer Portal you want to register the entity with:

    ```console
    kubectl get secret tap-values -n tap-install -o jsonpath="{.data['tap-values\.yaml']}" | base64 -d | yq '.tap_gui.app_config.app.baseUrl'
    ```

3. (Optional) VMware recommends creating `api-auto-registration-values.yaml`.

    To overwrite the default values when installing the package, create a `api-auto-registration-values.yaml` file:

    ```yaml
    tap_gui_url: https://tap-gui.view-cluster.com
    cluster_name: staging-us-east
    ca_cert_data:  |
        -----BEGIN CERTIFICATE-----
        MIIFXzCCA0egAwIBAgIJAJYm37SFocjlMA0GCSqGSIb3DQEBDQUAMEY...
        -----END CERTIFICATE-----
    sync_period: 2m
    ```

4. Install the package using the Tanzu CLI:

    ```console
    tanzu package install api-auto-registration
    --package-name apis.apps.tanzu.vmware.com
    --namespace tap-install
    --version $VERSION
    --values-file api-auto-registration-values.yaml
    ```

5. Verify the package installation by running:

    ```console
    tanzu package installed get api-auto-registration -n tap-install
    ```

    Verify that `STATUS` is `Reconcile succeeded`:

    ```console
    kubectl get pods -n api-auto-registration
    ```

6. Verify that applying an APIDescriptor resource to your cluster causes the `STATUS` showing `Ready`:

    ```console
    kubectl apply -f - <<EOF
    apiVersion: apis.apps.tanzu.vmware.com/v1alpha1
    kind: APIDescriptor
    metadata:
      name: sample-api-descriptor-with-absolute-url
    spec:
      type: openapi
      description: A sample APIDescriptor to validate package installation successful
      system: test-installation
      owner: test-installation
      location:
        path: "/api/v3/openapi.json"
        baseURL:
          url: https://petstore3.swagger.io
    EOF
    ```

    Verify that the APIDescriptor status shows `Ready`:

    ```console
    kubectl get apidescriptors
    NAME                                       STATUS
    sample-api-descriptor-with-absolute-url    Ready

    kubectl get apidescriptors -owide
    NAME                                       STATUS    TAP GUI ENTITY URL     API SPEC URL
    sample-api-descriptor-with-absolute-url    Ready     <url-to-the-entity>    <url-to-the-api-spec>
    ```

    If the status does not show `Ready`, you can inspect the reason with the detailed message shown by running:

    ```console
    kubectl get apidescriptor sample-api-descriptor-with-absolute-url -o jsonpath='{.status.conditions[?(@.type=="Ready")].message}'
    ```

    Verify that the entity is created in your Tanzu Developer Portal:
    `TAP-GUI-URL/catalog/default/api/sample-api-descriptor-with-absolute-url`

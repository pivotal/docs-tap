# Install API Auto Registration

This document describes how to install API Auto Registration from the Tanzu Application Platform package repository.

>**Note:** Use the instructions on this page if you do not want to use the full or run profile to install packages.
The "full" and "run" profiles includes API Auto Registsration by default.
For more information about profiles, see [About Tanzu Application Platform components and profiles](../about-package-profiles.md).

## <a id='prereqs'></a>Prerequisites

Before installing API Auto Registration:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).

## <a id='install'></a>Install

To install API Auto Registration:

1. List version information for the package by running:

    ```console
    tanzu package available list apis.apps.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list apis.apps.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for apis.apps.tanzu.vmware.com...
      NAME                                     VERSION  RELEASED-AT
      apis.apps.tanzu.vmware.com  0.0.6        2022-08-23 19:00:00 -0500 -05
      apis.apps.tanzu.vmware.com  0.1.0        2022-08-30 19:00:00 -0500 -05
    ```

1. (Optional) Gather values schema:

    List version information for the package by running:

    ```console
    tanzu package available list apis.apps.tanzu.vmware.com --namespace tap-install
    ```

    Display values schema of the package:

    ```console
    tanzu package available get apis.apps.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed in step 1.

    For example:

    ```console
    tanzu package available get apis.apps.tanzu.vmware.com/0.1.0 --values-schema --namespace tap-install

    Retrieving package details for apis.apps.tanzu.vmware.com/0.1.0... 
    KEY                        DEFAULT                                       TYPE     DESCRIPTION
    replicas                   1                                             integer  Number of controller replicas to deploy
    resources.limits.cpu       500m                                          string   CPU limit of the controller
    resources.limits.memory    500Mi                                         string   Memory limit of the controller
    resources.requests.cpu     20m                                           string   CPU request of the controller
    resources.requests.memory  100Mi                                         string   Memory request of the controller
    tap_gui_url                http://server.tap-gui.svc.cluster.local:7000  string   FQDN URL for TAP GUI
    ca_cert_data                                                             string   Optional: PEM-encoded certificate data for the controller to trust TLS connections with a custom CA
    cluster_name               dev                                           string   Name of the cluster that will be used for setting the API entity lifecycle in TAP GUI. The value should be unique for each run cluster.
    logging_profile            production                                    string   Logging profile for controller. If set to development, use console logging with full stack traces, else use JSON logging
    ```

1. Locate the TAP GUI url

    When running on a full profile tap cluster, the default value of TAP GUI url should be sufficient.

    When installed in a run cluster or without a profile where TAP GUI is not installed in the same cluster, you will need to set the `tap_gui_url` parameters correctly for successful entity registration with TAP GUI.

    You can locate the `tap_gui_url` by going to the view cluster with the TAP GUI you want to register the entity with and executing the following commands

    ```console
    kubectl get secret tap-values -n tap-install -o jsonpath="{.data['tap-values\.yaml']}" | base64 -d | yq '.tap_gui.app_config.app.baseUrl'
    ``` 

1. (Optional) Create `api-auto-registration-values.yaml`

    If you'd like to overwrite the default values when installing the package, create a `api-auto-registration-values.yaml` file that looks like this:

    ```yaml
    tap_gui_url: https://tap-gui.view-cluster.com
    cluster_name: staging-us-east
    ca_cert_data:  |
        -----BEGIN CERTIFICATE-----
        MIICpTCCAYUCBgkqhkiG9w0BBQ0wMzAbBgkqhkiG9w0BBQwwDgQIYg9x6gkCAggA
        ...
        9TlA7A4FFpQqbhAuAVH6KQ8WMZIrVxJSQ03c9lKVkI62wQ==
        -----END CERTIFICATE-----
    ```

1. Install the package using the Tanzu CLI
    
    ```console
    tanzu package install api-auto-registration 
    --package-name apis.apps.tanzu.vmware.com
    --namespace tap-install
    --version $VERSION
    --values-file api-auto-registration-values.yaml
    ``` 

1. Verify the package installation by running:

    ```console
    tanzu package installed get api-auto-registration -n tap-install
    ```

    Verify that `STATUS` is `Reconcile succeeded`:

    ```console
    kubectl get pods -n api-auto-registration
    ```

    Verify that `STATUS` is `Running`.

    Apply a simple APIDescriptor resource to your cluster:

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

    Verify that all status conditions are resolved to `TRUE` when describing the resource:

    ```console
    kubectl describe apidescriptor sample-api-descriptor-with-absolute-url
    ```

    Verify that the entity is created successfully in your TAP GUI: `<TAP_GUI_URL>/catalog/default/api/sample-api-descriptor-with-absolute-url`
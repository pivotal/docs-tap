# Configure API Auto Registration

This topic describes configuration options for API Auto Registration.

## <a id='update-values'></a>Update install values for api-auto-registration package

You can view the values available for the package by finding the available
package version and finding the corresponding schema. After you select the
values that you want to update, update them either by updating the `tap` package
or by updating the `api-auto-registration` package if you installed it on it's
own.

1. Find the version of the available package:

    ```console
    tanzu package available list apis.apps.tanzu.vmware.com -n tap-install

    / Retrieving package versions for apis.apps.tanzu.vmware.com...
    NAME                        VERSION  RELEASED-AT
    apis.apps.tanzu.vmware.com  0.2.6    2023-03-21 13:47:14 -0400 EDT
    ```

2. Explore the values available:

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

3. Create `api-auto-registration-values.yaml` if you installed API Auto Registration package on its own, or update the tap-values.yaml if you used a package to install.

    A `api-auto-registration-values.yaml` file might contain the following:

    ```yaml
    tap_gui_url: https://tap-gui.view-cluster.com
    cluster_name: staging-us-east
    ca_cert_data:  |
        -----BEGIN CERTIFICATE-----
        MIIFXzCCA0egAwIBAgIJAJYm37SFocjlMA0GCSqGSIb3DQEBDQUAMEY...
        -----END CERTIFICATE-----
    ```

    A `tap-values.yaml` file might contain the following, in addition to other values.  See the [Full Profile sample](#full-profile).

    ```yaml
    shared:
        ingress_domain: "INGRESS-DOMAIN"
        ingress_issuer: # Optional, can denote a cert-manager.io/v1/ClusterIssuer of your choice. Defaults to "tap-ingress-selfsigned".
        ca_cert_data: | # To be passed if using custom certificates.
            -----BEGIN CERTIFICATE-----
            MIIFXzCCA0egAwIBAgIJAJYm37SFocjlMA0GCSqGSIb3DQEBDQUAMEY...
            -----END CERTIFICATE-----
    api_auto_registration:
        tap_gui_url: https://tap-gui.view-cluster.com
        cluster_name: staging-us-east
    ```

4. If you installed the API Auto Registration package on its own, not as part of Tanzu Application
   Platform, update the package using the Tanzu CLI:

    ```console
    tanzu package installed update api-auto-registration
    --package-name apis.apps.tanzu.vmware.com
    --namespace tap-install
    --version $VERSION
    --values-file api-auto-registration-values.yaml
    ```

5. If you installed API Auto Registration as part of Tanzu Application Platform, see [Upgrading Tanzu Application Platform](../upgrading.hbs.md).

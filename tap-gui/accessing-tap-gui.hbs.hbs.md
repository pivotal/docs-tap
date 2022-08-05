# Accessing Tanzu Application Platform GUI

Use one of the following methods to access Tanzu Application Platform GUI:

* Access with the LoadBalancer method (default)
* Access with the shared Ingress method

## <a id="lb-method"></a> Access with the LoadBalancer method (default)

1. Verify that you specified the `service_type` for Tanzu Application Platform GUI in
`tap-values.yaml`, as in this example:

    ```yaml
    tap_gui:
      service_type: LoadBalancer
    ```

1. Obtain the external IP address of your LoadBalancer by running:

    ```console
    kubectl get svc -n tap-gui
    ```

1. Access Tanzu Application Platform GUI by using the external IP address with the default port of 7000.
It has the following form:

    ```text
    http://EXTERNAL-IP:7000
    ```

    Where `EXTERNAL-IP` is the external IP address of your LoadBalancer.

## <a id="ingress-method"></a> Access with the shared Ingress method

The Ingress method of access for Tanzu Application GUI uses the shared `tanzu-system-ingress` instance
of Contour that is installed as part of the Profile installation.

1. The Ingress method of access requires that you have a DNS host name that you can point at the
External IP address of the `envoy` service that the shared `tanzu-system-ingress` uses.
Retrieve this IP address by running:

    ```console
    kubectl get service envoy -n tanzu-system-ingress
    ```

    This returns a value similar to this example:

    ```console
    $ kubectl get service envoy -n tanzu-system-ingress
    NAME    TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)                      AGE
    envoy   LoadBalancer   10.0.242.171   40.118.168.232   80:31389/TCP,443:31780/TCP   27h
    ```

    The IP address in the `EXTERNAL-IP` field is the one that you point a DNS host record to.
    Tanzu Application Platform GUI prepends `tap-gui` to your provided subdomain.
    This makes the final host name `tap-gui.YOUR-SUBDOMAIN`.
    You use this host name in the appropriate fields in the `tap-values.yaml` file mentioned later.

1. Specify parameters in `tap-values.yaml` related to Ingress. For example:

    ```yaml
    shared:
      ingress_domain: "example.com"

    tap_gui:
      service_type: ClusterIP
    ```

1. Update your other host names in the `tap_gui` section of your `tap-values.yaml` with the new host
name. For example:

    ```yaml
    shared:
      ingress_domain: "example.com"

    tap_gui:
      service_type: ClusterIP
    # Existing tap-values.yaml above
      app_config:
        app:
          baseUrl: http://tap-gui.example.com # No port needed with Ingress
        integrations:
          github: # Other are integrations available
            - host: github.com
              token: GITHUB-TOKEN
        catalog:
          locations:
            - type: url
              target: https://GIT-CATALOG-URL/catalog-info.yaml
        backend:
          baseUrl: http://tap-gui.example.com # No port needed with Ingress
          cors:
            origin: http://tap-gui.example.com # No port needed with Ingress
    ```

    This snippet is from a values file in the
    [Configure Tanzu Application Platform GUI section](../install.html#configure-tap-gui) of the
    Profiles installation topic. The new host names are populated based on the example host name
    `tap-gui.example.com`.

1. Update your package installation with your changed `tap-values.yaml` file by running:

    ```console
    tanzu package installed update tap --package-name tap.tanzu.vmware.com --version VERSION-NUMBER \
    --values-file tap-values.yaml -n tap-install
    ```

    Where `VERSION-NUMBER` is your Tanzu Application Platform version. For example, `{{ vars.tap_version }}`.

1. Use a web browser to access Tanzu Application Platform GUI at the host name that you provided.

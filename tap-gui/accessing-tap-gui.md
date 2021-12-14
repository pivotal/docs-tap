# Accessing Tanzu Application Platform GUI

To access Tanzu Application Platform GUI, you have a choice
1. Use the default LoadBalancer method
2. Use a shared Ingress method

## <a id="lb-method"></a> LoadBalancer Method

Make sure that you've specified the `service_type` for Tanzu Application Platform GUI in your `tap-values.yml` file:

```yaml
tap_gui:
  service_type: LoadBalancer
```


Follow these steps:

1. Obtain the external IP of your LoadBalancer by running:

    ```
    kubectl get svc -n tap-gui
    ```

1. Access Tanzu Application Platform GUI by using the external IP with the default port of 7000.
It has the following form:

    ```
    http://EXTERNAL-IP:7000
    ```

## <a id="ingress-method"></a> Ingress Method

The `Ingress` method of access for Tanzu Application GUI can use the shared `tanzu-system-ingress` instance of Contour that is installed as part of the Profile installation.

1. In order for the `Ingress` method of access to work, you'll need a DNS hostname that you can point at the External IP of the `envoy` service that the shared `tanzu-system-ingress` uses. You can retrieve this IP using the following:

```bash
kubectl get service envoy -n tanzu-system-ingress
```

This would return a value similar to the following:

```bash
kubectl get service envoy -n tanzu-system-ingress
NAME    TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)                      AGE
envoy   LoadBalancer   10.0.242.171   40.118.168.232   80:31389/TCP,443:31780/TCP   27h
```

The IP address in the EXTERNAL-IP field is the one that you will point a DNS host record at. Tanzu Application Platform GUI automatically will prepend `tap-gui` to your provided subdomain below. This means the final hostname would be `tap-gui.example.com`. You'll need to use this hostname in the appropriate fields in the `tap-values.yml` below.

2. You'll need to specify a couple parameters in your `tap-values.yaml` related to Ingress in order for it to work.

```yaml
tap_gui:
  service_type: ClusterIP
  ingressEnabled: "true"
  ingressDomain: 'example.com' # This would result in the hostname tap-gui.example.com

```

3. You'll also want to update your other hostnames in the `tap_gui` section of your `tap-values.yml` with the new hostname. Below is the values file from the [Configure Tanzu Application Platform GUI section](../install.md) of the Profiles installation with the new hostnames populated based on the example hostname `tap-gui.example.com`:

```yaml
tap_gui:
  service_type: ClusterIP
  ingressEnabled: "true"
  ingressDomain: 'example.com' # This would result in the hostname tap-gui.example.com
    # Existing tap-values.yml above  
    app_config:
    app:
        baseUrl: http://tap-gui.example.com # No port needed with ingress
    integrations:
        github: # Other integrations available see NOTE below
        - host: github.com
            token: GITHUB-TOKEN
    catalog:
        locations:
        - type: url
            target: https://GIT-CATALOG-URL/catalog-info.yaml
    backend:
        baseUrl: http://tap-gui.example.com # No port needed with ingress
        cors:
            origin: http://tap-gui.example.com # No port needed with ingress
```

4. Finally, update your package installation with your changed values file using a command similar to:

```bash
tanzu package installed update  tap --package-name tap.tanzu.vmware.com --version 0.4.0 --values-file tap-values-file.yml -n tap-install
```

5. Now you should be able toa access your Tanzu Application Platform GUI via a web browser at the hostname you provided above.
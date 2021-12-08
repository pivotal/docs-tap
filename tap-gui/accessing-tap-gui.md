# Accessing Tanzu Application Platform GUI

This topic covers how to access Tanzu Application Platform GUI.

## <a id="lb-method"></a> Use the default LoadBalancer method

The default method is to use LoadBalancer. To do so, follow these steps.

1. Obtain the external IP of your LoadBalancer by running:

    ```
    kubectl get svc -n tap-gui
    ```

1. Access Tanzu Application Platform GUI by using the external IP with the default port of 7000.
It has the following form:

    ```
    http://EXTERNAL-IP:7000
    ```

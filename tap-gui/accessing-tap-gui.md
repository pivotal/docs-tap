# Accessing Tanzu Application Platform GUI

To access Tanzu Application Platform GUI, use the default LoadBalancer method.

## <a id="lb-method"></a> LoadBalancer method

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

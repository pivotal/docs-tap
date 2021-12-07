# Accessing Tanzu Application Platform GUI

## <a id="lb-method"></a> LoadBalancer Method (Default)

To use the default LoadBalancer method, follow these steps.

1. Obtain the `External IP` of your LoadBalancer by running:

   ```
   kubectl get svc -n tap-gui
   ```
   
1. Access the Tanzu Application Platform GUI by using the external IP with the default port of 7000:

    ```
    http://EXTERNAL-IP:7000
    ```

## Accessing teh Tanzu Application Platform GUI
### LoadBalancer Method (Default)
1. Obtain the `External IP` of your LoadBalancer by running:
   ```
   kubectl get svc -n tap-gui
   ```
1. To access the Tanzu Application Platform GUI, use the `EXTERNAL-IP` with the default port of 7000:
    ```
    http://EXTERNAL-IP:7000
    ```
# Supply Chain Security Tools - Scan 2.0 Observability

This topic guides you through observing Supply Chain Security Tools (SCST) - Scan 2.0. This helps you understand each step of scanning.

## <a id="steps"></a> Scanning Steps

This section describes each of the scanning steps and corresponding observability methods.

- To watch the status of the scanning custom resources and child resources:

    ```console
    kubectl get -l imagevulnerabilityscan pipelinerun,taskrun,pod
    kubectl get imagevulnerabilityscan
    ```

- View the status, reason, and urls:

    ```console
    kubectl get imagevulnerabilityscan -o wide
    ```

- View the complete status and events of scanning custom resources:

    ```console
    kubectl describe imagevulnerabilityscan IMAGE-VULNERABILITY-SCAN-NAME
    ```

    Where `IMAGE-VULNERABILITY-SCAN-NAME` is the name of an ImageVulnerabilityScan resource you want to inspect.

- List the child resources of a scan:

    ```console
    kubectl get -l imagevulnerabilityscan=$NAME pipelinerun,taskrun,pod
    ```

- Get the logs of the controller:

    ```console
    kubectl logs -f deployment/app-scanning-controller-manager -n app-scanning-system -c manager
    ```
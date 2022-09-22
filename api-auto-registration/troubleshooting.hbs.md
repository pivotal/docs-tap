# Troubleshooting

Here are some handy commands for debugging or troubleshooting the APIDescriptor CR.

1. Find the status of the APIDescriptor CR.
    ```console
    kubectl get apidescriptor <api-apidescriptor-name> -o jsonpath='{.status.conditions}'
    ```
2. Read logs from the `api-auto-registration` controller.
    ```console
    kubectl -n api-auo-registration logs deployment.apps/api-auto-registration-controller
    ```
3. Patch a APIDescriptor that is stuck in Deleting mode.

   This might happen if the controller package is uninstalled before you clean up the APIDescriptor resources. 
   You could reinstall the package and delete all the APIDescriptor resources first, or run the following command for each stuck APIDescriptor resource.

    ```console
    kubectl patch apidescriptor <api-apidescriptor-name> -p '{"metadata":{"finalizers":null}}' --type=merge
    ```
    Please note that if you manually remove the finalizers from the APIDescriptor resources, you may end up with stale API entities within TAP GUI that you will need to manually unregister.

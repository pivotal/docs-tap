# Troubleshoot API Auto Registration

## Debug API Auto Registration

This topic includes commands for debugging or troubleshooting the APIDescriptor CR.

1. Get the details of APIDescriptor CR.

    ```console
    kubectl get apidescriptor <api-apidescriptor-name> -owide
    ```

2. Find the status of the APIDescriptor CR.

    ```console
    kubectl get apidescriptor <api-apidescriptor-name> -o jsonpath='{.status.conditions}'
    ```

3. Read logs from the `api-auto-registration` controller.
   
    ```console
    kubectl -n api-auo-registration logs deployment.apps/api-auto-registration-controller
    ```

4. Patch an APIDescriptor that is stuck in Deleting mode.

   This might happen if the controller package is uninstalled before you clean up the APIDescriptor resources.
   You can reinstall the package and delete all the APIDescriptor resources first, or run the following command for each stuck APIDescriptor resource.

    ```console
    kubectl patch apidescriptor <api-apidescriptor-name> -p '{"metadata":{"finalizers":null}}' --type=merge
    ```

    >**Note** If you manually remove the finalizers from the APIDescriptor resources, you can have stale API entities within Tanzu Application Platform GUI that you must manually deregister.

5. If using OpenAPI v2 specifications with `schema.$ref`, the specifications fail validation due to a known issue.
To pass the validation, you can convert the specifications to OpenAPI v3 by pasting your specifications into https://editor.swagger.io/ and selecting "Edit > Convert to OpenAPI 3".

## APIDescriptor CRD issues

This topic includes issues users might find and how to solve them.

### APIDescriptor CRD shows message of `connection refused` but service is up and running

In Tanzu Application Platform v1.4 and later, if your workloads use ClusterIssuer for the TLS configuration or your API specifications location URL is secured using a custom CA,
you might encounter the following message.

Your APIDescription CRD shows a status and message similar to:

```console
    Message:               Get "https://spring-petclinic.example.com/v3/api-docs": dial tcp 12.34.56.78:443: connect: connection refused
    Reason:                FailedToRetrieve
    Status:                False
    Type:                  APISpecResolved
    Last Transition Time:  2022-11-28T09:59:13Z
```

To solve this issue, either:

- Configure `ca_cert_data` following the instructions in [Configure CA Cert Data](#set-ca-crt).
- Deactivate TLS by setting `shared.ingress_issuer: ""`. VMware discourages this method.

#### <a id="obtain-pem"></a> Obtain PEM encoded crt

1. Obtain the PEM Encoded crt file for your ClusterIssuer or TLS setup . You use this to update the `api-auto-registration` package.
 
2. If you installed the API Auto Registration package through predefined profiles, you must update the `tap-values.yaml` and update the Tanzu Application Platform installation.
   Place the PEM encoded certificate into the `shared.ca_cert_data` key of the values file. See [Install your Tanzu Application Platform profile](../install.hbs.md#install-profile).
   Run the following command to update the package.

2. Pause the meta package's reconciliation. This prevents Tanzu Application Platform from reverting to the original values. 

3. If you installed the API Auto Registration package as standalone, you must update the `api-auto-registration-values.yaml` and then update the package.
   Place the PEM encoded certificate into the `ca_cert_data` key of the values file. See [Install API Auto Registration](installation.hbs.md).
   Run the following command to update the package.

   ```console
   tanzu package installed update api-auto-registration --version <API_AUTO_REGISTRATION_VERSION> --namespace tap-install --values-file api-auto-registration-values.yaml
   ```

   You can find the available api-auto-registration versions by running:
   
   ```console
   tanzu package available list -n tap-install | grep 'API Auto Registration'
   ```

### APIDescriptor CRD shows message of `x509: certificate signed by unknown authority` but service is running

Your APIDescription CRD shows a status and message similar to:

```console
    Message:               Put "https://tap-gui.tap.my-cluster.tapdemo.vmware.com/api/catalog/immediate/entities": x509: certificate signed by unknown authority
    Reason:                Error
    Status:                False
    Type:                  Ready
    Last Transition Time:  2022-11-28T09:59:13Z
```

This is the same issue as `connection refused` described earlier.

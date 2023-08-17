# Troubleshoot API Auto Registration

This topic contains ways that you can troubleshoot API Auto Registration.

## Debug API Auto Registration

This section includes commands for debugging or troubleshooting the APIDescriptor CR.

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
    kubectl -n api-auto-registration logs deployment.apps/api-auto-registration-controller
    ```

4. Patch an APIDescriptor that is stuck in Deleting mode.

   This might happen if the controller package is uninstalled before you clean up the APIDescriptor resources.
   You can reinstall the package and delete all the APIDescriptor resources first, or run the following command for each stuck APIDescriptor resource.

    ```console
    kubectl patch apidescriptor <api-apidescriptor-name> -p '{"metadata":{"finalizers":null}}' --type=merge
    ```

    > **Note** If you manually remove the finalizers from the APIDescriptor resources, you can have
    > stale API entities within Tanzu Developer Portal (formerly called Tanzu Application Platform GUI)
    > that you must manually deregister.

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

This might be due to your workloads using a custom Ingress issuer. To solve this issue, either:

- Configure `ca_cert_data` following the instructions in [Configure CA Cert Data](#set-ca-crt).
- Deactivate TLS by setting `shared.ingress_issuer: ""`. VMware discourages this method.

#### <a id="set-ca-crt"></a> Configure CA Cert Data

1. Obtain the PEM Encoded crt file for your ClusterIssuer or TLS setup . You use this to update the `api-auto-registration` package.

2. If you installed the API Auto Registration package through predefined profiles, you must update the `tap-values.yaml` and update the Tanzu Application Platform installation.
   Place the PEM encoded certificate into the `shared.ca_cert_data` key of the values file. See [Install your Tanzu Application Platform profile](../install-online/profile.hbs.md#install-profile).
   Run the following command to update the package.

   ```console
   tanzu package installed update tap -p tap.tanzu.vmware.com -v TAP-VERSION  --values-file tap-values.yaml -n tap-install
   ```

    Where `TAP-VERSION` is the version of Tanzu Application Platform installed.

3. If you installed the API Auto Registration package as standalone, you must update the `api-auto-registration-values.yaml` and then update the package.
   Place the PEM encoded certificate into the `ca_cert_data` key of the values file. See [Install API Auto Registration](installation.hbs.md).
   Run the following command to update the package.

   ```console
   tanzu package installed update api-auto-registration --version API-AUTO-REGISTRATION-VERSION --namespace tap-install --values-file api-auto-registration-values.yaml
   ```

    Where `API-AUTO-REGISTRATION-VERSION` is the version of API Auto Registration installed.

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

# Troubleshoot API Auto Registration

This topic contains ways that you can troubleshoot API Auto Registration.

## <a id='debug'></a> Debug API Auto Registration

This section includes commands for debugging or troubleshooting the APIDescriptor CR.

1. Get the details of CRs.

    ```console
    kubectl get apidescriptor NAME -n NAMESPACE -owide
    kubectl get curatedapidescriptor NAME -n NAMESPACE -owide
    ```

    Where:

    - `NAME` is the name of the CR you want to debug.
    - `NAMESPACE` is the namespace associated with the CR you want to debug.

1. Find the status of the CRs.

    ```console
    kubectl get apidescriptor NAME -n NAMESPACE -o jsonpath='{.status.conditions}'
    kubectl get curatedapidescriptor NAME -n NAMESPACE -o jsonpath='{.status.conditions}'
    ```

    Where:

    - `NAME` is the name of the CR you want to debug.
    - `NAMESPACE` is the namespace associated with the CR you want to debug.

1. Find the generated SpringCloudGatewayRouteConfig (commonly known as SCGRC) and SpringCloudGatewayMapping (commonly known as SCGM) resource associated with a specific APIDescriptor CR from curation.

    The generated Spring Cloud Gateway (commonly known as SCG) resources are placed in the same namespace as the CuratedAPIDescriptor,
    and the generated name has a prefix with the name of the CuratedAPIDescriptor.
    To see which APIDescriptor the resource was generated for,
    you can list generated SCG resources with additional labels by running:

    ```console
    kubectl get scgrc -A -L apis.apps.tanzu.vmware.com/api-descriptor-name -L apis.apps.tanzu.vmware.com/api-descriptor-namespace
    kubectl get scgm -A -L apis.apps.tanzu.vmware.com/api-descriptor-name -L apis.apps.tanzu.vmware.com/api-descriptor-namespace
    ```

    Sample output:

    ```console
    NAMESPACE      NAME                AGE   API-DESCRIPTOR-NAME   API-DESCRIPTOR-NAMESPACE
    api-curation   petstore-4a8d2a4f   49s   turtle-api            turtle-ns
    api-curation   petstore-ce551c65   49s   cat-api               cat-ns
    api-curation   petstore-d0243a39   49s   dog-api               dog-ns
    ```

2. Read logs from the `api-auto-registration` controller.

    ```console
    kubectl -n api-auto-registration logs deployment.apps/api-auto-registration-controller
    ```

3. Patch an APIDescriptor that is stuck in Deleting mode.

   This might happen if the controller package is uninstalled before you clean up the APIDescriptor resources.
   You can reinstall the package and delete all the APIDescriptor resources first,
   or run for each stuck APIDescriptor resource.

    ```console
    kubectl patch apidescriptor API-DESCRIPTOR-NAME -p '{"metadata":{"finalizers":null}}' --type=merge
    ```

    Where `API-DESCRIPTOR-NAME` is the name of the API descriptor you want to patch.

    > **Note** If you manually remove the finalizers from the APIDescriptor resources, you can have
    > stale API entities within Tanzu Developer Portal that you must manually deregister.

4. Fix a `CuratedAPIDescriptor` that does not match with a SCG.

    This might happen if the `groupId` and version of the `CuratedAPIDescriptor` does not match any available `SpringCloudGateway` resource.
    You can remove the `"apis.apps.tanzu.vmware.com/route-provider": "spring-cloud-gateway"` annotation from your `CuratedAPIDescriptor` to skip SCG matching, or ensure that you have a matching SCG applied to the cluster.

### <a id='api-connection-refused'></a> APIDescriptor CRD shows message of `connection refused` but service is up and running

In Tanzu Application Platform v1.4 and later, if your workloads use ClusterIssuer for the TLS configuration
 or your API specifications location URL is secured using a custom CA,
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
- Deactivate TLS by setting `shared.ingress_issuer: ""`. VMware discourages this method. Deactivating TLS reduces your ability to test plug-in capability and iterate quickly.

#### <a id="set-ca-crt"></a> Configure CA Cert Data

1. Obtain the PEM Encoded crt file for your ClusterIssuer or TLS setup.
   You use this to update the `api-auto-registration` package.

2. If you installed the API Auto Registration package through predefined profiles,
   you must update the `tap-values.yaml` and update the Tanzu Application Platform installation.
   Place the PEM encoded certificate into the `shared.ca_cert_data` key of the values file.
   See [Install your Tanzu Application Platform profile](../install-online/profile.hbs.md#install-profile).
   Run to update the package:

   ```console
   tanzu package installed update tap -p tap.tanzu.vmware.com -v TAP-VERSION  --values-file tap-values.yaml -n tap-install
   ```

    Where `TAP-VERSION` is the version of Tanzu Application Platform installed.

3. If you installed the API Auto Registration package as standalone,
   you must update the `api-auto-registration-values.yaml` and then update the package.
   Place the PEM encoded certificate into the `ca_cert_data` key of the values file.
   Run to update the package.

   ```console
   tanzu package installed update api-auto-registration --version API-AUTO-REGISTRATION-VERSION --namespace tap-install --values-file api-auto-registration-values.yaml
   ```

    Where `API-AUTO-REGISTRATION-VERSION` is the version of API Auto Registration installed.

   You can find the available api-auto-registration versions by running:

   ```console
   tanzu package available list -n tap-install | grep 'API Auto Registration'
   ```

### <a id='cert-signed-unknown'></a> APIDescriptor status shows `x509: certificate signed by unknown authority` but service is running

Your APIDescription CR shows a status and message similar to:

```console
    Message:               Put "https://tap-gui.tap.my-cluster.tapdemo.vmware.com/api/catalog/immediate/entities": x509: certificate signed by unknown authority
    Reason:                Error
    Status:                False
    Type:                  Ready
    Last Transition Time:  2022-11-28T09:59:13Z
```

This is the same issue as `connection refused` described earlier.

### <a id='conflict-groupid-version'></a> Unexpected content in generated specification

This issue happens when there are two or more `CuratedAPIDescriptor` with conflicting `groupId` and `version`.

If you create two `CuratedAPIDescriptor`s with the same `groupId` and `version` combination,
both reconcile without an error.
However, the following undesired behaviors can signal conflict:

- The `/openapi?groupId&version` endpoint returns more than one API specification.
- If you add both specifications to API portal, for example, `/openapi?groupId&version`,
only one of them shows up in the API portal UI with a warning indicating that there is a conflict.
- If you add the route provider annotation for both of the `CuratedAPIDescriptor`s to use SCG,
the generated API specification includes API routes from both `CuratedAPIDescriptor`s.

You can see the `groupId` and `version` information from all `CuratedAPIDescriptor`s to find conflicts by running:

  ```console
  $ kubectl get curatedapidescriptors -A

  NAMESPACE           NAME         GROUPID            VERSION   STATUS   CURATED API SPEC URL
  my-apps             petstore     test-api-group     1.2.3     Ready    http://AAR-CONTROLLER-FQDN/openapi/my-apps/petstore
  default             mystery      test-api-group     1.2.3     Ready    http://AAR-CONTROLLER-FQDN/openapi/default/mystery
  ```

### <a id='unsupported-openapi-version'></a> Unsupported OpenAPI version

API Auto Registration only supports OpenAPI v3.0 and v2.0, formerly known as Swagger.

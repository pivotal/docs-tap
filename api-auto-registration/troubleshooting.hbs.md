# Troubleshoot API Auto Registration

This topic contains ways that you can troubleshoot API Auto Registration.

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
    kubectl -n api-auto-registration logs deployment.apps/api-auto-registration-controller
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

Your APIDescription CRD shows a status and message similar to:

```console
    Message:               Get "https://spring-petclinic.example.com/v3/api-docs": dial tcp 12.34.56.78:443: connect: connection refused
    Reason:                FailedToRetrieve
    Status:                False
    Type:                  APISpecResolved
    Last Transition Time:  2022-11-28T09:59:13Z
```

You can access "https://spring-petclinic.example.com/v3/api-docs", and you are
using Tanzu Application Platform v1.4.x, you might encounter a problem with TLS
configuration. Workloads might be using ClusterIssuer for their TLS
configuration, but API Auto Registration does not support it. To solve this
issue, you can either deactivate TLS by setting `shared.ingress_issuer: ""`, or
inform `shared.ca_cert_data` key as mentioned in [our installation
guide](installation.md).  You can obtain the PEM Encoded crt file using the following steps:

1. Create a Certificate object where the issuerRef refers to the ClusterIssuer referenced
in the `shared.ingress_issuer` field.

    ```console
    # create the cert
    cat <<EOF | kubectl apply -f -
    apiVersion: cert-manager.io/v1
    kind: Certificate
    metadata:
      name: ca-extractor
      namespace: default
    spec:
      dnsNames:
      - tap.example.com
      issuerRef:
        group: cert-manager.io
        kind: ClusterIssuer
        name: tap-ingress-selfsigned
      secretName: ca-extractor
    EOF
    ```

2. Extract the CA certificate data from the secret that is generated in the
previous command. The name of the secret is found in the `secretName:
ca-extractor` field. The following command extracts a PEM encoded CA certificate
and stores it in the file `ca.crt`.

  ```console
  kubectl get secret -n default ca-extractor -ojsonpath="{.data.ca\.crt}" | base64 -d > ca.crt
  ```

1. After you have the certificate data, you can delete both the certificate and
   the secret that you generated in Step 1.

  ```console
  kubectl delete certificate -n default ca-extractor
  kubectl delete secret -n default ca-extractor
  ```

4. Get the PEM encoded certificate that was stored in a file:

  ```console
  cat ca.crt
  ```

After you obtain the certificate you must update the `api-auto-registration` installation to use it:
 
1. Place the PEM encoded certificate into the `ca_cert_data` key of a values file. See [Install API Auto Registration](installation.hbs.md).

2. Pause the meta package's reconciliation. This prevents Tanzu Application Platform from reverting to the original values. 

  ```console
  kctrl package installed pause --yes --namespace tap-install --package-install tap
  ```

1. Update the `api-auto-registration` installation to use the values file from the first step.

  ```console
  tanzu package installed update api-auto-registration --version <VERSION> --namespace tap-install --values-file <VALUES-FILE>
  ```

  Where:

  - `VALUES-FILE` is name of values file
  - `VERSION` is the api-auto-registration version. For example, `0.2.1`.

You can find the available api-auto-registration volumes by running:

  ```console
  tanzu package available list -n tap-install | grep 'API Auto Registration'
  ```

1. Unpause the meta package's reconciliation

  ```console
  ctrl package installed kick --yes --namespace tap-install --package-install tap
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

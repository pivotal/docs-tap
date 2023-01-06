# Troubleshoot API Auto Registration

## How to debug API Auto Registration

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

Your APIDescription CRD shows a status and message similar to:

```
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
guide](installation.md).  You can obtain the PEM Encoded crt file using the steps below:

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

2. Extract the CA cert data from the secret that is generated as part of the previous command.
The name of the secret can be found in the `secretName: ca-extractor` field. The command below
will extract PEM encoded CA certificate and store it in the file `ca.crt`

```console
kubectl get secret -n default ca-extractor -ojsonpath="{.data.ca\.crt}" | base64 -d > ca.crt
```

3. Now that you have the cert data you can delete both the certificate and the secret that were 
generated from step 1.

```console
kubectl delete certificate -n default ca-extractor
kubectl delete secret -n default ca-extractor
```

4. Get the PEM encoded cert that was stored in a file

```console
cat ca.crt
```

5. Place the PEM encoded cert into `shared.ca_cert_data` key as mentioned 
in [our installation guide](installation.md).


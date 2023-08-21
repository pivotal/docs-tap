# Configure Cloud Native Runtimes to use a custom Issuer or ClusterIssuer

The ability to opt out of the shared ingress issuer and use a custom Issuer or ClusterIssuer for Cloud Native Runtimes
provides greater flexibility, security, isolation, and integration with existing infrastructure, allowing you to tailor
the TLS configurations to your specific needs and requirements.

We will explain in the following example how to opt out of the shared ingress issuer and use Let's Encrypt with the
HTTP01 challenge type. The HTTP01 challenge requires that your load balancer be reachable from the internet by using HTTP.
With the HTTP01 challenge type, a certificate is provisioned for each service.

To configure Cloud Native Runtimes to use a custom Issuer or ClusterIssuer with the HTTP01 challenge, follow these steps:

## <a id="config-custom-issuer"></a> Configure a custom issuer

You have the flexibility to replace Tanzu Application Platform's default ingress issuer with any other `certificate authority`
that is [compliant with cert-manager ClusterIssuer](https://cert-manager.io/docs/configuration/).
For more information on how to replace the default ingress issuer, see
[Replacing the default ingress issuer](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.6/tap/security-and-compliance-tls-and-certificates-ingress-issuer.html#replacing-the-default-ingress-issuer-4)
documentation.

1. Create a custom Issuer or ClusterIssuer with the Certificate Authority (CA) that you want and configurations.
   Here's an example YAML configuration for a custom ClusterIssuer using Let's Encrypt with the HTTP01 challenge:

   ```yaml
   apiVersion: cert-manager.io/v1
   kind: ClusterIssuer
   metadata:
      name: letsencrypt-http01-issuer
   spec:
      acme:
         email: YOUR-EMAIL
         server: https://acme-v02.api.letsencrypt.org/directory
         privateKeySecretRef:
           name: letsencrypt-http01-issuer-account-key
         solvers:
           - http01:
               ingress:
                 class: contour
   ```

   Where `YOUR-EMAIL` is your email address.
   
   Make sure to specify the ingress class you are using in your Tanzu Application Platform cluster, which is `contour`.

2. Save the configuration above in a file called `issuer-letsencrypt-http01.yaml`.

   >**Note** If you want to test this feature, you might want to set `spec.acme.server` to https://acme-staging-v02.api.letsencrypt.org/directory.
   >This is the staging url, which generates self-signed certs. It is useful for testing without worrying about hitting quotas for your actual domain.

3. Apply the Issuer or ClusterIssuer configuration to your cluster:

   ```sh
   kubectl apply -f issuer-letsencrypt-http01.yaml
   ```

## <a id="use-custom-issuer"></a> Configure Cloud Native Runtimes to use the custom issuer

1. Configure Cloud Native Runtimes to use the custom Issuer or ClusterIssuer for issuing certificates by updating your
   `tap-values.yaml` file with the following snippet of yaml.

   ```yaml
   cnrs:
       ingress_issuer: "letsencrypt-http01-issuer"
   ```

2. Update Tanzu Application Platform

   To update the Tanzu Application Platform installation with the changes to the values file, run:

   ```sh
   tanzu package installed update tap -p tap.tanzu.vmware.com -v ${TAP_VERSION} --values-file tap-values.yaml -n tap-install
   ```

## <a id="verify-certificate"></a> Verify the issuance of certificates

Verify that your ClusterIssuer was created and properly issuing certificates:

```sh
kubectl get clusterissuer letsencrypt-http01-issuer
```

You can confirm the status of the certificate by running the command below. You should see the certificate in a `Ready` state.

```sh
kubectl get certificate -n DEVELOPER-NAMESPACE
```

Additionally, you can access your workload using the domain you specified with `curl` or a web browser, and verify that it is using
a TLS certificate issued by the custom Issuer or ClusterIssuer. 

```sh
tanzu apps workload get WORKLOAD-NAME --namespace DEVELOPER-NAMESPACE
kubectl get ksvc WORKLOAD-NAME -n DEVELOPER-NAMESPACE -o jsonpath='{.status.url}'
```

For details on how to troubleshoot failures related to the certificate,
visit [cert-manager's Troubleshooting guide](https://cert-manager.io/docs/troubleshooting).

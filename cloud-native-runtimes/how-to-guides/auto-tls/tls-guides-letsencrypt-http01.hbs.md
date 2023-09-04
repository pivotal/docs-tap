# Configure Cloud Native Runtimes to use a custom Issuer or ClusterIssuer

This topic tells you how to configure Cloud Native Runtimes to use a custom Issuer or ClusterIssuer.

## <a id="overview"></a> Overview

The ability to opt out of the shared ingress issuer and use a custom Issuer or ClusterIssuer for Cloud Native Runtimes
provides greater flexibility, security, isolation, and integration with existing infrastructure, allowing you to tailor
the TLS configurations to your specific needs and requirements.

The following example explains how to opt out of the shared ingress issuer and use Let's Encrypt with the
HTTP01 challenge type. The HTTP01 challenge requires that your load balancer is reachable from the Internet by using HTTP.
With the HTTP01 challenge type, a certificate is provisioned for each service.

## <a id="config-custom-issuer"></a> Configure a custom issuer

You have the flexibility to replace Tanzu Application Platform's default ingress issuer with any other `certificate authority`
that is compliant with cert-manager ClusterIssuer. For more information, see the 
[cert-manager documentation](https://cert-manager.io/docs/configuration/).
For information about how to replace the default ingress issuer, see
[Replacing the default ingress issuer](../../../security-and-compliance/tls-and-certificates/ingress/issuer.hbs.md).

To configure Cloud Native Runtimes to use a custom Issuer or ClusterIssuer with the HTTP01 challenge:

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
   
   Specify the ingress class you are using in your Tanzu Application Platform cluster, which is `contour`.

2. Save the configuration from the previous step in a file called `issuer-letsencrypt-http01.yaml`.

   >**Note** To test this feature, you can set `spec.acme.server` to `https://acme-staging-v02.api.letsencrypt.org/directory`.
   >This is the staging URL, which generates self-signed certificates. It is useful for testing without worrying about hitting quotas for your actual domain.

3. Apply the Issuer or ClusterIssuer configuration to your cluster:

   ```console
   kubectl apply -f issuer-letsencrypt-http01.yaml
   ```

## <a id="use-custom-issuer"></a> Configure Cloud Native Runtimes to use a custom issuer

To configure Cloud Native Runtimes to use a custom issuer:

1. Configure Cloud Native Runtimes to use a custom Issuer or ClusterIssuer for issuing certificates by updating your
   `tap-values.yaml` file with the following snippet of YAML.

   ```yaml
   cnrs:
       ingress_issuer: "letsencrypt-http01-issuer"
   ```

2. Update Tanzu Application Platform.

   To update the Tanzu Application Platform installation with the changes to the values file, run:

   ```console
   tanzu package installed update tap -p tap.tanzu.vmware.com -v ${TAP_VERSION} --values-file tap-values.yaml -n tap-install
   ```

## <a id="verify-certificate"></a> Verify the issuance of certificates

To verify your certificate:

1. Verify that your ClusterIssuer was created and properly issuing certificates, by running:

   ```console
   kubectl get clusterissuer letsencrypt-http01-issuer
   ```

1. Confirm the status of the certificate by running the following command. You see the certificate in a `Ready` state.

   ```console
   kubectl get certificate -n DEVELOPER-NAMESPACE
   ```

   You see the certificate in a `Ready` state.

   Where `DEVELOPER-NAMESPACE` is the namespace that you want to use.

1. You can access your workload using the domain you specified with `curl` or a web browser, and verify that it is using
a TLS certificate issued by the custom Issuer or ClusterIssuer. 

   ```sh
   tanzu apps workload get WORKLOAD-NAME --namespace DEVELOPER-NAMESPACE
   kubectl get ksvc WORKLOAD-NAME -n DEVELOPER-NAMESPACE -o jsonpath='{.status.url}'
   ```

   Where:

   - `DEVELOPER-NAMESPACE` is the namespace that you want to use.
   - `WORKLOAD-NAME` is the name of the workload you want to use.

For information about how to troubleshoot failures related to the certificate,
see the [cert-manager documentation](https://cert-manager.io/docs/troubleshooting).

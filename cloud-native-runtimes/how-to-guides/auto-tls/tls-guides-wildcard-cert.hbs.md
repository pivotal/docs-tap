# Use wildcard certificates with Cloud Native Runtimes

This section describes how to configure, use, and verify wildcard certificates with Cloud Native Runtimes.

Cloud Native Runtimes uses the cert-manager package by default to automate the process of obtaining,
managing, and renewing TLS certificates for your services.

cert-manager is a Kubernetes-native component that works with different `certificate authorities` (CAs) like Let's Encrypt and others,
to manage certificates within your Kubernetes cluster. As part of Tanzu Application Platform predefined profile installation,
cert-manager package is deployed to the cluster.

## <a id="config-wildcard-issuer"></a> Configure an issuer for wildcard certificates

Any other `cert-manager.io/v1/ClusterIssuer` can replace Tanzu Application Platform’s default ingress issuer.
This topic uses Let's Encrypt as an example of how to set up a custom ingress issuer that issues wildcard certificates.

The Let's Encrypt documentation states that the DNS01 challenge is required to validate wildcard domains.
This topic provides instructions for configuring Cloud Native Runtimes to use wildcard certificates with the DNS01 challenge only.

To configure an issuer for wildcard certificates:

1. Create a cert-manager custom Issuer or ClusterIssuer for the DNS01 challenge.

  You must create a custom Issuer or ClusterIssuer with the DNS01 solver configured for your specific DNS provider.
  For more information about supported DNS01 providers, see the [cert-manager documentation](https://cert-manager.io/docs/configuration/acme/dns01/#supported-dns01-providers)
  for instructions for configuring cert-manager for all the supported DNS providers.

  The following example uses Let’s Encrypt and Google Cloud DNS:

    ```yaml
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
      name: letsencrypt-dns-wildcard
    spec:
      acme:
        server: https://acme-v02.api.letsencrypt.org/directory
        # This will register an issuer with LetsEncrypt.
        email: YOUR-EMAIL
        privateKeySecretRef:
          # Set privateKeySecretRef to any unused secret name.
          name: letsencrypt-dns-wildcard-account-key
        solvers:
        - dns01:
            cloudDNS:
              # Set this to your GCP project id
              project: PROJECT-ID
              # This is the secret used to access the service account
              serviceAccountSecretRef:
                name: cloud-dns-key
                key: key.json
    ```

  Where: 

  - `YOUR-EMAIL` is the email associated with your DNS provider.
  - `PROJECT-ID` is the ID of the GCP project.

1. Save the configuration from the previous step in a file called `issuer-wildcard.yaml`.

  When using cert-manager to obtain wildcard certificates, you typically must provide credentials, especially when using the DNS01 challenge.
  The DNS01 challenge requires cert-manager to create and delete DNS records for domain validation during the certificate issuance process.
  To perform these actions, cert-manager needs access to your DNS provider's API, which requires authentication using API keys, access tokens,
  or other credentials. See [Supported DNS01 providers](https://cert-manager.io/docs/configuration/acme/dns01/#supported-dns01-providers) in the cert-manager documentation.

  >**Note** To test this feature, you can set `spec.acme.server` to `https://acme-staging-v02.api.letsencrypt.org/directory`.
  > This is the staging URL, which generates self-signed certificates. It is useful for testing without worrying about hitting quotas for your actual domain.

1. Apply the file you saved in the previous section to your cluster:

  ```sh
  kubectl apply -f issuer-wildcard.yaml
  ```

## <a id="use-wildcard-issuer"></a> Configure Cloud Native Runtimes to use wildcard certificates

To use wildcard certificates:

1. Configure Cloud Native Runtimes to use the custom Issuer or ClusterIssuer and indicate in which namespaces to create wildcard certificates.

  >**Note** If no value is passed to `cnrs.namespace_selector`, only per service certificates are generated instead of wildcard certificates.

  You achieve this by adding the following YAML to your `tap-values.yaml` file.

  ```yaml
  cnrs:
      ingress_issuer: "letsencrypt-dns-wildcard"
      namespace_selector:
        matchExpressions:
        - key: apps.tanzu.vmware.com/tap-ns
          operator: Exists
  ```

  This configuration tells Cloud Native Runtimes which custom Issuer or ClusterIssuer is used for issuing the wildcard certificate.
  When a Knative Service is created or updated with this configuration, Cloud Native Runtimes requests and uses the wildcard certificate
  from the specified custom Issuer or ClusterIssuer.

  In Cloud Native Runtimes, the per-namespace certificate manager operates by using the namespace labels to verify which
  namespaces require a certificate to be generated. This example specifies that only namespaces labeled with
  `apps.tanzu.vmware.com/tap-ns` have corresponding wildcard certificates created for them.

  If you are using the suggested namespace selector, label your developer namespace with `apps.tanzu.vmware.com/tap-ns`.
  Run:

  ```console
  kubectl label namespace DEV-NAMESPACE "apps.tanzu.vmware.com/tap-ns"
  ```

  To remove a label from a namespace, run:

  ```console
  kubectl label namespace DEV-NAMESPACE "apps.tanzu.vmware.com/tap-ns"- --overwrite
  ```

1. Update Tanzu Application Platform.

  To update the Tanzu Application Platform installation with the changes to the values file, run:

  ```console
  tanzu package installed update tap -p tap.tanzu.vmware.com -v ${TAP_VERSION} --values-file tap-values.yaml -n tap-install
  ```

## <a id="verify-wildcard"></a> Verify the issuance of wildcard certificates

Verify that your ClusterIssuer was created and properly issuing certificates.

1. To verify your ClusterIssuer, run:

  ```console
  kubectl get clusterissuer letsencrypt-dns-wildcard
  ```

1. Confirm the status of the certificate by running the following command. You see the certificate in a `Ready` state.

  ```console
  kubectl get certificate -n DEVELOPER-NAMESPACE
  ```

  You see the certificate in a `Ready` state.

  Where `DEVELOPER-NAMESPACE` is the namespace you want to use.

1. You can access your workload using the domain you specified with `curl` or a web browser, and verify that it is using
a TLS certificate issued by the custom Issuer or ClusterIssuer.

  ```console
  tanzu apps workload get WORKLOAD-NAME --namespace DEVELOPER-NAMESPACE
  kubectl get ksvc WORKLOAD-NAME -n DEVELOPER-NAMESPACE -o jsonpath='{.status.url}'
  ```

  Where:

  - `DEVELOPER-NAMESPACE` is the namespace you want to use.
  - `WORKLOAD-NAME` is the name of the workload you want to use.

For details about how to troubleshoot failures related to the certificate,
see the [cert-manager documentation](https://cert-manager.io/docs/troubleshooting).
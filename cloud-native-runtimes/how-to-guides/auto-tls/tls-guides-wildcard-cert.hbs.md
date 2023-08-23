# Use wildcard certificates with Cloud Native Runtimes

This section describes how to configure, use and verify wildcard certificates with Cloud Native Runtimes.

Cloud Native Runtimes utilizes the cert-manager package by default to automate the process of obtaining, 
managing, and renewing TLS certificates for your services.

Cert-manager is a Kubernetes-native component that works with different `certificate authorities` (CAs) like Let's Encrypt and others,
to manage certificates within your Kubernetes cluster. As part of Tanzu Application Platform predefined profile installation,
cert-manager package is deployed to the cluster.

## <a id="config-wildcard-issuer"></a> Configure an issuer for wildcard certificates

Any other `cert-manager.io/v1/ClusterIssuer` can replace Tanzu Application Platform’s default ingress issuer.
This topic uses Let's Encrypt as an example of how to set up a custom ingress issuer that issues wildcard certificates.

The Let's Encrypt documentation states that the DNS01 challenge is required to validate wildcard domains.
This topic provides instructions for configuring Cloud Native Runtimes to use wildcard certificates with the DNS01 challenge only.

1. Create a cert-manager custom Issuer or ClusterIssuer for the DNS01 challenge.

  You must create a custom Issuer or ClusterIssuer with the DNS01 solver configured for your specific DNS provider.
  Visit cert-manager's documentation on [Supported DNS01 providers](https://cert-manager.io/docs/configuration/acme/dns01/#supported-dns01-providers)
  for instructions on configuring cert-manager for all the supported DNS providers.

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
              project: PROJECT_ID
              # This is the secret used to access the service account
              serviceAccountSecretRef:
                name: cloud-dns-key
                key: key.json
    ```

  Where `YOUR-EMAIL` is the email associated with your DNS provider.
  
  Where `PROJECT_ID` is the ID of the GCP project.

2. Save the configuration above in a file called `issuer-wildcard.yaml`.

  When using cert-manager to obtain wildcard certificates, you typically must provide credentials, especially when using the DNS01 challenge.
  The DNS01 challenge requires cert-manager to create and delete DNS records for domain validation during the certificate issuance process.
  To perform these actions, cert-manager needs access to your DNS provider's API, which requires authentication using API keys, access tokens,
  or other credentials. See [Supported DNS01 providers](https://cert-manager.io/docs/configuration/acme/dns01/#supported-dns01-providers) in the cert-manager documentation.

  >**Note** If you want to test this feature, you might want to set `spec.acme.server` to https://acme-staging-v02.api.letsencrypt.org/directory.
  > This is the staging url, which generates self-signed certs. It is useful for testing without worrying about hitting quotas for your actual domain.

3. Apply the file you saved in the previous section to your cluster:

  ```sh
  kubectl apply -f issuer-wildcard.yaml`
  ```

## <a id="use-wildcard-issuer"></a> Configure Cloud Native Runtimes to use wildcard certificates

To use wildcard certificates:

1. Configure Cloud Native Runtimes to use the custom Issuer or ClusterIssuer and indicate in which namespaces to create wildcard certificates

  >**Note** If no value is passed to `cnrs.namespace_selector`, only per service certificates are generated instead of wildcard certificates.

  You achieve this by add the snippet below to your `tap-values.yaml` file.

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
  You can so by running the following command:

  ```sh
  kubectl label namespace DEV-NAMESPACE "apps.tanzu.vmware.com/tap-ns"
  ```

  To remove a label from a namespace, run the following command:

  ```sh
  kubectl label namespace DEV-NAMESPACE "apps.tanzu.vmware.com/tap-ns"- --overwrite
  ```

2. Update Tanzu Application Platform.

  To update the Tanzu Application Platform installation with the changes to the values file, run:

  ```sh
  tanzu package installed update tap -p tap.tanzu.vmware.com -v ${TAP_VERSION} --values-file tap-values.yaml -n tap-install
  ```

## <a id="verify-wildcard"></a> Verify the issuance of wildcard certificates

Verify that your ClusterIssuer was created and properly issuing certificates:

```sh
kubectl get clusterissuer letsencrypt-dns-wildcard
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
# Use your existing TLS Certificate for Cloud Native Runtimes

This topic tells you how to use your existing TLS Certificate for Cloud Native Runtimes, commonly known as CNRs.

## <a id='overview'></a> Overview

Configure secure HTTPS connections to enable your web workloads and routes to stop external TLS connections
using an existing certificate.

You have the flexibility to provide your own TLS certificate to Cloud Native Runtimes
_instead of_ relying on the shared ingress issuer for your Knative workloads. To use the feature explained in this topic,
you must configure Cloud Native Runtimes to bypass the cert-manager certificate issuer. For example, if you have set `cnrs.contour.default_tls_secret` in your `tap-values.yaml`,
set the `cnrs.ingress_issuer` configuration to an empty value. For detailed instructions on how to opt out and deactivate the automatic TLS feature, see [Opt out from any ingress issuer and deactivate automatic TLS feature](./auto-tls/tls-guides-deactivate-autotls.hbs.md).

## <a id='prereqs'></a> Prerequisites

To configure TLS for Cloud Native Runtimes, you must first configure a Service Domain. For more information, see [Configuring External DNS with CNRs](./external_dns.hbs.md).

## <a id='config'></a> Configure TLS

To configure your TLS certificate for the created Knative Services, follow the steps:

1. Create a Kubernetes secret to hold your TLS Certificate:

    ```console
    kubectl create -n DEVELOPER-NAMESPACE secret tls SECRET_NAME \
      --key key.pem \
      --cert cert.pem
    ```

1. Create a delegation. To do so, create a `tlscertdelegation.yaml` file:

    ```yaml
      apiVersion: projectcontour.io/v1
      kind: TLSCertificateDelegation
      metadata:
        name: default-delegation
        namespace: DEVELOPER-NAMESPACE
      spec:
        delegations:
          - secretName: SECRET-NAME
            targetNamespaces:
              - "DEVELOPER-NAMESPACE"
    ```

    Where `SECRET-NAME` is the name of the Kubernetes secret you created earlier.

1. Apply the YAML file by running:

    ```console
    kubectl apply -f tlscertdelegation.yaml
    ```

1. Include the following configuration in your `tap-values.yaml` file under Cloud Native Runtimes section and redeploy:

    ```yaml
    cnrs:
      contour:
        default_tls_secret: "DEVELOPER-NAMESPACE/SECRET-NAME"
    ```

    Where `SECRET-NAME` is the name of the Kubernetes secret you created earlier.

    Where `DEVELOPER-NAMESPACE` is the name of the namespace where the secret was created.

1. Update Tanzu Application Platform.

    To update the Tanzu Application Platform installation with the changes to the values file, run:

    ```console
    tanzu package installed update tap -p tap.tanzu.vmware.com -v ${TAP_VERSION} --values-file tap-values.yaml -n tap-install
    ```

    This edits the Knative `config-contour` ConfigMap to use `default_tls_secret` as the default TLS certificate.

    Your web workloads' URLs use the scheme `https` by default when this secret is provided.

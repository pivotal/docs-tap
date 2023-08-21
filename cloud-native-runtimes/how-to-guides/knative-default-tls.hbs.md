# Use your existing TLS Certificate for Cloud Native Runtimes

This topic tells you how to use your existing TLS Certificate for Cloud Native Runtimes, commonly known as CNR.

## Overview

Configure secure HTTPS connections to enable your web workloads and routes to terminate external TLS connections
using an existing certificate.

>**Note** It is important to note that you have the flexibility to provide your own TLS certificate to Cloud Native Runtimes
_instead of_ relying on the shared ingress issuer for your Knative workloads. To utilize the feature explained in this document,
you must configure Cloud Native Runtimes to bypass the cert-manager certificate issuer. For instance, if you have set `cnrs.contour.default_tls_secret` in your tap-values.yaml file,
you should set the `cnrs.ingress_issuer` configuration to an empty value. For detailed instructions on how to opt out and deactivate the automatic TLS feature,
please refer to the documentation: [Opt out from any ingress issuer and deactivate automatic TLS feature](./auto-tls/tls-guides-deactivate-autotls.hbs.md).

## <a id='prereqs'></a> Prerequisites

In order to configure TLS for Cloud Native Runtimes, you must first configure a Service Domain. For more information, see [Configuring External DNS with CNR](./external_dns.hbs.md).

To configure your TLS certificate for the created Knative Services, follow the steps:

* Create a Kubernetes Secret to hold your TLS Certificate
    ```sh
    kubectl create -n DEVELOPER-NAMESPACE secret tls SECRET_NAME \
      --key key.pem \
      --cert cert.pem
    ```

* Create a delegation. To do so, create a `tlscertdelegation.yaml` file with following contents
    ```yaml
      apiVersion: projectcontour.io/v1
      kind: TLSCertificateDelegation
      metadata:
        name: default-delegation
        namespace: DEVELOPER-NAMESPACE
      spec:
        delegations:
          - secretName: SECRET_NAME
            targetNamespaces:
              - "DEVELOPER-NAMESPACE"
    ```
    
    Where `SECRET_NAME` is the name of the Kubernetes secret you created in the step above.

* Apply the above yaml file by running below command:
    ```sh
    kubectl apply -f tlscertdelegation.yaml
    ```

* Include the following configuration in your `tap-values.yml` file under Cloud Native Runtimes section and redeploy:

    ```yaml
    cnrs:
      contour:
        default_tls_secret: "DEVELOPER-NAMESPACE/SECRET_NAME"
    ```
    Where `SECRET_NAME` is the name of the Kubernetes secret you created in the previous step.
    
    Where `DEVELOPER-NAMESPACE` is the name of the namespace where the secret was created in the previous step.


* Update Tanzu Application Platform

    To update the Tanzu Application Platform installation with the changes to the values file, run:

    ```sh
    tanzu package installed update tap -p tap.tanzu.vmware.com -v ${TAP_VERSION} --values-file tap-values.yaml -n tap-install
    ```

    This will modify the Knative `config-contour` ConfigMap to use `default_tls_secret` as the default TLS certificate.

    Your web workloads' URLs will use the scheme `https` by default when this secret is provided.

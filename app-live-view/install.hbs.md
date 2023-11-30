# Install Application Live View

This topic tells you how to install Application Live View from the Tanzu Application Platform
(commonly known as TAP) package repository.

## <a id='overview'></a>Overview

Application Live View includes four packages you can install. The following table lists these packages
and shows the Tanzu Application Platform profiles each package is included in.

<table>
<thead>
<tr>
<th>Package</th>
<th>Profiles</th>
<th>Details</th>
</tr>
</thead>
<tbody>
<tr>
<td>Application Live View APIServer <br>(<code>apiserver.appliveview.tanzu.vmware.com</code>)</td>
<td>Full, Iterate, Run</td>
<td>Installed in the <code>appliveview-tokens-system</code> namespace</td>
</tr>
<tr>
<td>Application Live View back end <br>(<code>backend.appliveview.tanzu.vmware.com</code>)</td>
<td>Full, View</td>
<td>Installed with Tanzu Developer Portal in the <code>app-live-view</code> namespace</td>
</tr>
<tr>
<td>Application Live View connector <br>(<code>connector.appliveview.tanzu.vmware.com</code>)</td>
<td>Full, Iterate, Run</td>
<td>Installed as a DaemonSet in the <code>app-live-view-connector</code> namespace</td>
</tr>
<tr>
<td>Application Live View conventions <br>(<code>conventions.appliveview.tanzu.vmware.com</code>)</td>
<td>Full, Iterate, Build</td>
<td>Installed in the <code>app-live-view-conventions</code> namespace</td>
</tr>
</tbody>
</table>

For more information about these packages, see
[Application Live View internal architecture](architecture.hbs.md).

>**Note** Follow the steps in this topic if you do not want to use a profile to
>install Application Live View. For more information about profiles, see [About
>Tanzu Application Platform components and
>profiles](../about-package-profiles.hbs.md).

## <a id='prereqs'></a>Prerequisites

Before installing Application Live View, complete all prerequisites to install
Tanzu Application Platform. For more information, see
[Prerequisites](../prerequisites.md).

In addition, install Cartographer Conventions, which is bundled with Supply
Chain Choreographer as of the v0.5.3 release. To install, see [Installing Supply
Chain Choreographer](../scc/install-scc.md). For more information, see
[Cartographer Conventions](../cartographer-conventions/about.md).

## <a id='install-app-live-view'></a> Install Application Live View

You can install Application Live View in single cluster or multicluster
environment:

- `Single cluster`: All Application Live View components are deployed in a
  single cluster. The user can access Application Live View plug-in information
  of the applications across all the namespaces in the Kubernetes cluster. This
  is the default mode of Application Live View.

- `Multicluster`: In a multicluster environment, the Application Live View
  back end component is installed only once in a single cluster and exposes a
  RSocket registration for the other clusters using Tanzu shared ingress. Each
  cluster continues to install the connector as a DaemonSet. The connectors are
  configured to connect to the central instance of the Application Live View
  back end.

The improved security and access control secures the
communication between the Application Live View components. For more
information, see [Configure security and access control in Application Live
View](./improved-security-and-access-control.hbs.md).

## <a id='install-app-live-view-back-end'></a> Install Application Live View back end

To install Application Live View back end:

1. List version information for the package by running:

    ```console
    tanzu package available list backend.appliveview.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list backend.appliveview.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for backend.appliveview.tanzu.vmware.com...
      NAME                                  VERSION        RELEASED-AT
      backend.appliveview.tanzu.vmware.com  1.5.1          2023-03-29T00:00:00Z
    ```

1. (Optional) Change the default installation settings by running:

    ```console
    tanzu package available get backend.appliveview.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed. For example,
    `1.5.1`.

    For example:

    ```console
    $ tanzu package available get backend.appliveview.tanzu.vmware.com/1.5.1 --values-schema --namespace tap-install
      KEY                      DEFAULT          TYPE        DESCRIPTION
      tls.namespace            <nil>            string      The targeted namespace for secret consumption by the HTTPProxy.

      tls.secretName           <nil>            string      The name of secret for consumption by the HTTPProxy.

      ingressDomain            tap.example.com  string      Domain to be used by the HTTPProxy ingress object. The "appliveview"
                                                            subdomain will be prepended to the value provided. For example:
                                                            "example.com" would become "appliveview.example.com".
      ingressEnabled           false            boolean     Flag for whether or not to create an HTTPProxy for ingress.

      ingress_issuer                            string      Cluster issuer to be used in App Live View Backend.
      kubernetes_distribution                   string      Kubernetes distribution that this package is being installed on. Accepted
                                                            values: ['''',''openshift'']
      kubernetes_version                        string      Optional: The Kubernetes Version. Valid values are '1.24.*', or ''

      server.tls.crt                            string      TLS cert file
      server.tls.enabled       false            boolean     Flag to enable tls on backend
      server.tls.key                            string      TLS key file
    ```

    For more information about values schema options, see the properties listed
    earlier.

1. Create the file `app-live-view-backend-values.yaml` using the following information:

    Single-cluster environment
    : For a single-cluster environment, the Application Live View back end is
    exposed through the Kubernetes cluster service. By default, ingress is
    deactivated for back end.

        ```yaml
          ingressEnabled: false
        ```

    Multicluster environment
    : For a multicluster environment, set the flag `ingressEnabled` to true for
    the Application Live View back end to be exposed on the ingress domain.

        ```yaml
          ingressEnabled: true
        ```

    Profile installation with shared.ingress_domain key set
    : If you are using a Tanzu Application Platform profile installation and the
    top-level key `shared.ingress_domain` is set in the `tap-values.yaml`, the
    back end is automatically exposed through the shared ingress.

        To override the shared ingress for Application Live View in a multicluster environment,
        use the following values:

        ```yaml
          ingressEnabled: true
          ingressDomain: ${INGRESS-DOMAIN}
        ```

        Where `INGRESS-DOMAIN` is the top-level domain you use for the
        `tanzu-shared-ingress` service’s external IP address. The `appliveview`
        subdomain is prepended to the value provided.

1. Enable or disable TLS in your `app-live-view-backend-values.yaml` file:

    Enable TLS with self-signed certificate
    : To enable TLS for Application Live View back end using a self-signed certificate:

        1. Create the `app-live-view` namespace and the TLS secret for the domain.
        You must do this before installing the Tanzu Application Platform packages in the
        cluster so that the HTTPProxy is updated with the TLS secret. To create a
        TLS secret, run:

            ```console
            kubectl create -n app-live-view secret tls alv-cert --cert=CERT-FILE --key=KEY-FILE
            ```

            Where:

            - `SECRET-NAME` is the name you want for the TLS secret for the domain, for example, `alv-cert`.
            - `CERT-FILE` is a .crt file that contains the PEM encoded server certificate.
            - `KEY-FILE`  is a .key file that contains the PEM encoded server private key.

        2. Provide the following properties in your `app-live-view-backend-values.yaml`:

            ```yaml
            tls:
              namespace: "NAMESPACE"
              secretName: "SECRET-NAME"
            ```

            Where:

            - `NAMESPACE` is the targeted namespace of TLS secret for the domain.
            - `SECRET-NAME` is the name of TLS secret for the domain.

            You can edit the values to suit your project needs or leave the default
            values as is.

        3. Set the `ingressEnabled` key to `true`.

            When `ingressEnabled` is `true`, the HTTPProxy object is created in the cluster.

        4. Verify the HTTPProxy object with the TLS secret by running:

            ```console
            kubectl get httpproxy -A
            ```

            Expected output:

            ```console
            NAMESPACE            NAME                                                              FQDN                                                             TLS SECRET               STATUS   STATUS DESCRIPTION
            app-live-view        appliveview                                                       appliveview.192.168.42.55.nip.io                                 app-live-view/alv-cert   valid    Valid HTTPProxy
            ```

    Enable TLS using ClusterIssuer
    : To enable TLS for Application Live View back end using ClusterIssuer:

        1. Set the `ingressEnabled` key to `true` for TLS to be enabled on Application Live View
           back end using ClusterIssuer. This key is set to `false` by default.

          TLS is then automatically enabled on Application Live View back end using the shared ClusterIssuer.
          The `appliveview-cert` certificate is generated by default and its issuerRef points to the `.ingress_issuer` value.
          The `ingress_issuer` key consumes the value `shared.ingress_issuer` from `tap-values.yaml` by
          default if you don't specify the `ingress_issuer` in `tap-values.yaml`.

          When `ingressEnabled` is `true`, HTTPProxy object is created in the cluster and also
          `appliveview-cert` certificate is generated by default in the `app_live_view` namespace.
          Here, the secretName `appliveview-cert` stores this certificate.

        1. To verify the HTTPProxy object with the secret, run:

            ```console
            kubectl get httpproxy -A
            ```

            Expected output:

            ```console
            NAMESPACE            NAME                                                              FQDN                                                             TLS SECRET               STATUS   STATUS DESCRIPTION
            app-live-view        appliveview                                                       appliveview.192.168.42.55.nip.io                                 appliveview-cert   valid    Valid HTTPProxy
            ```

        1. To verify the Application Live View pages in a multicluster setup, set the appropriate connector
           configuration in your run cluster as listed in [Install Application Live View connector](#install-alv-connector)
           later in this topic.

    Disable TLS
    : By default, Tanzu Application Platform installs and uses a self-signed CA as its ingress issuer
      for all components by default.
      The `ingress_issuer` key consumes the value `shared.ingress_issuer` from `tap-values.yaml` by
      default if you don't specify the `ingress_issuer` in `tap-values.yaml`. This will automatically enable TLS validation on Application Live View back end.

      To disable TLS validation on Application Live View back end do one of the following:

      - While VMware does not recommend it, you can deactivate the ingress issuer by setting `
        shared.ingress_issuer: ""` in `tap-values.yaml`

          ```yaml
              shared:
                ingress_issuer: ""
          ```

      - Set the `ingress_issuer: ""` in `app-live-view-backend-values.yaml`

          ```yaml
            ingressEnabled: true
            ingress_issuer: ""
          ```

1. Install the Application Live View back end package by running:

    ```console
    tanzu package install appliveview -p backend.appliveview.tanzu.vmware.com -v VERSION-NUMBER -n tap-install -f app-live-view-backend-values.yaml
    ```

    Where `VERSION-NUMBER` is the version of the package listed.

    For example:

    ```console
    $ tanzu package install appliveview -p backend.appliveview.tanzu.vmware.com -v 1.5.1 -n tap-install -f app-live-view-backend-values.yaml
    - Installing package 'backend.appliveview.tanzu.vmware.com'
    | Getting namespace 'tap-install'
    | Getting package metadata for 'backend.appliveview.tanzu.vmware.com'
    | Creating service account 'appliveview-tap-install-sa'
    | Creating cluster admin role 'appliveview-tap-install-cluster-role'
    | Creating cluster role binding 'appliveview-tap-install-cluster-rolebinding'
    | Creating package resource
    | Package install status: Reconciling

    Added installed package 'appliveview' in namespace 'tap-install'
    ```

    The Application Live View back end component is deployed in `app-live-view`
    namespace by default.

1. Verify the Application Live View back end package installation by running:

    ```console
    tanzu package installed get appliveview -n tap-install
    ```

    For example:

    ```console
    tanzu package installed get appliveview -n tap-install
    \ Retrieving installation details for appliveview...
    NAME:                    appliveview
    PACKAGE-NAME:            backend.appliveview.tanzu.vmware.com
    PACKAGE-VERSION:         1.5.1
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`.

## <a id='install-alv-connector'></a> Install Application Live View connector

To install Application Live View connector:

1. List version information for the package by running:

    ```console
    tanzu package available list connector.appliveview.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list connector.appliveview.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for connector.appliveview.tanzu.vmware.com...
      NAME                                    VERSION        RELEASED-AT
      connector.appliveview.tanzu.vmware.com  1.5.1          2023-03-29T00:00:00Z
    ```

1. (Optional) Change the default installation settings by running:

    ```console
    tanzu package available get connector.appliveview.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed. For example,
    `1.5.1`.

    For example:

    ```console
    $ tanzu package available get connector.appliveview.tanzu.vmware.com/1.5.1 --values-schema --namespace tap-install
      KEY                                   DEFAULT             TYPE        DESCRIPTION
      backend.caCertData                      cert-in-pem-format  string    CA Cert Data for ingress domain
      backend.host                            <nil>               string    Domain to be used to reach the application live view backend. Prepend
                                                                            "appliveview" subdomain to the value if you are using shared ingress. For
                                                                            example: "example.com" would become "appliveview.example.com".
      backend.ingressEnabled                  false               boolean   Flag for the connector to connect to ingress on backend

      backend.port                            <nil>               number    Port to reach the application live view backend
      backend.sslDeactivated                  false               boolean   Flag for whether or not to deactivate ssl
      backend.sslDisabled                     false               boolean   The key sslDisabled has been deprecated in TAP 1.4.0 and will be removed in TAP
                                                                            1.X+Y.0 of TAP, please migrate to the key sslDeactivated
      connector.namespace_scoped.enabled      false               boolean   Flag for the connector to run in namespace scope
      connector.namespace_scoped.namespace    default             string    Namespace to deploy connector
      kubernetes_distribution                                     string    Kubernetes distribution that this package is being installed on. Accepted
                                                                            values: ['''',''openshift'']
      kubernetes_version                                          string    Optional: The Kubernetes Version. Valid values are '1.24.*', or ''

      activateAppLiveViewSecureAccessControl                      boolean   Optional: Configuration required to enable Secure Access Connection between App
                                                                            Live View components
      activateSensitiveOperations                                 boolean   Optional: Configuration to allow connector to execute sensitive operations on a
                                                                            running application
    ```

    For more information about values schema options, see the properties listed
    earlier.

1. Create `app-live-view-connector-values.yaml` using the following details:

    - For a single-cluster environment, the Application Live View connector connects
    to the `cluster-local` Application Live View back end to register the
    applications.

        By default, ingress is deactivated for connector.

    - For a multicluster environment, set the flag `ingressEnabled` to `true` for
    the Application Live View connector to connect to the Application Live View
    back end by using the ingress domain.

        ```yaml
        backend:
          ingressEnabled: true
        ```

    - If you are using a Tanzu Application Platform profile installation and the
    top-level key `shared.ingress_domain` is set in the `tap-values.yml`, the
    Application Live View connector and Application Live View back end are configured to
    communicate through ingress. The Application Live View connector then uses
    the `shared.ingress_domain` to reach the back end.

        To override the shared ingress for Application Live View in a multicluster environment,
        use the following values:

        ```yaml
        backend:
          host: appliveview.INGRESS-DOMAIN
        ```

        Where `INGRESS-DOMAIN` is the top-level domain the Application Live View
        back end exposes by using `tanzu-shared-ingress` for the connectors in other
        clusters to reach the Application Live View back end. Prepend the
        `appliveview` subdomain to the provided value.

    - The `backend.sslDeactivated` is set to `false` by default. You can set the CA certificate for
    the ingress domain in the `backend.caCertData` key for SSL validation. For example:

        ```yaml
        backend:
        caCertData: |-
          -----BEGIN CERTIFICATE-----
          MIIGMzCCBBugAwIBAgIJALHHzQjxM6wMMA0GCSqGSIb3DQEBDQUAMGcxCzAJBgNV
          BAgMAk1OMRQwEgYDVQQHDAtNaW5uZWFwb2xpczEPMA0GA1UECgwGVk13YXJlMRMw
          -----END CERTIFICATE-----
        ```

    - To enable TLS using ClusterIssuer, set the following connector configuration in the run cluster:

        ```yaml
        backend:
        ingressEnabled: true
        sslDeactivated: false
        host: appliveview.INGRESS-DOMAIN
        caCertData: |-
          -----BEGIN CERTIFICATE-----
          MIIGMzCCBBugAwIBAgIJALHHzQjxM6wMMA0GCSqGSIb3DQEBDQUAMGcxCzAJBgNV
          BAgMAk1OMRQwEgYDVQQHDAtNaW5uZWFwb2xpczEPMA0GA1UECgwGVk13YXJlMRMw
          -----END CERTIFICATE-----
        ```

        Where `caCertData` is the certificate retrieved from the HTTPProxy secret exposed by the
        Application Live View back end in view cluster.
        The `host` is the backend host in the view cluster.

        To retrieve the certificate from the HTTPProxy secret, run the following command in the view cluster:

        ```console
        kubectl get secret appliveview-cert -n app-live-view -o yaml |  yq '.data."ca.crt"' | base64 -d
        ```

    - If TLS is not enabled for the `INGRESS-DOMAIN` in the Application Live View
    back end, set the `backend.sslDeactivated` to `true`.

        ```yaml
        backend:
          sslDeactivated: true
        ```

        >**Note** The `sslDisabled` key is deprecated and has been renamed to
        >`sslDeactivated`.

        You can edit the values to suit your project needs or leave the default
        values as is.

        Using the HTTP proxy either on 80 or 443 based on SSL config exposes the
        back end service running on port 7000. The connector connects to the back
        end on port 80/443 by default. Therefore, you are not required to explicitly
        configure the `port` field.

1. Install the Application Live View connector package by running:

    ```console
    tanzu package install appliveview-connector -p connector.appliveview.tanzu.vmware.com -v VERSION-NUMBER -n tap-install -f app-live-view-connector-values.yaml
    ```

    Where `VERSION-NUMBER` is the version of the package listed. For example,
    `1.5.1`.

    For example:

    ```console
    $ tanzu package install appliveview-connector -p connector.appliveview.tanzu.vmware.com -v 1.5.1 -n tap-install -f app-live-view-connector-values.yaml
    | Installing package 'connector.appliveview.tanzu.vmware.com'
    | Getting namespace 'tap-install'
    | Getting package metadata for 'connector.appliveview.tanzu.vmware.com'
    | Creating service account 'appliveview-connector-tap-install-sa'
    | Creating cluster admin role 'appliveview-connector-tap-install-cluster-role'
    | Creating cluster role binding 'appliveview-connector-tap-install-cluster-rolebinding'
    - Creating package resource
    / Package install status: Reconciling

    Added installed package 'appliveview-connector' in namespace 'tap-install'
    ```

    Each cluster installs the connector as a DaemonSet. The connector is
    configured to connect to the central instance of the back end. The
    Application Live View connector component is deployed in
    `app-live-view-connector` namespace by default.

1. Verify the `Application Live View connector` package installation by running:

    ```console
    tanzu package installed get appliveview-connector -n tap-install
    ```

    For example:

    ```console
    tanzu package installed get appliveview-connector -n tap-install                                                                              5s
    | Retrieving installation details for appliveview-connector...
    NAME:                    appliveview-connector
    PACKAGE-NAME:            connector.appliveview.tanzu.vmware.com
    PACKAGE-VERSION:         1.5.1
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`.

## <a id='install-alv-conventions'></a> Install Application Live View conventions

To install Application Live View conventions:

1. List version information for the package by running:

    ```console
    tanzu package available list conventions.appliveview.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list conventions.appliveview.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for conventions.appliveview.tanzu.vmware.com...
      NAME                                      VERSION        RELEASED-AT
      conventions.appliveview.tanzu.vmware.com  1.5.1          2023-03-29T00:00:00Z
    ```

1. (Optional) Change the default installation settings by running:

    ```console
    tanzu package available get conventions.appliveview.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed. For example,
    `1.5.1`.

    For example:

    ```console
    $ tanzu package available get conventions.appliveview.tanzu.vmware.com/1.5.1 --values-schema --namespace tap-install
      KEY                               DEFAULT             TYPE     DESCRIPTION
      kubernetes_distribution                               string  Kubernetes distribution that this package is installed on. Accepted values: ['''',''openshift''].
      kubernetes_version                                    string  Optional: The Kubernetes Version. Valid values are '1.24.*', or ''.
    ```

    For more information about values schema options, see the properties listed
    earlier.

1. Install the Application Live View conventions package by running:

    ```console
    tanzu package install appliveview-conventions -p conventions.appliveview.tanzu.vmware.com -v VERSION-NUMBER -n tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed. For example,
    `1.5.1`.

    For example:

    ```console
    $ tanzu package install appliveview-conventions -p conventions.appliveview.tanzu.vmware.com -v 1.5.1 -n tap-install
    - Installing package 'conventions.appliveview.tanzu.vmware.com'
    | Getting namespace 'tap-install'
    | Getting package metadata for 'conventions.appliveview.tanzu.vmware.com'
    | Creating service account 'appliveview-conventions-tap-install-sa'
    | Creating cluster admin role 'appliveview-conventions-tap-install-cluster-role'
    | Creating cluster role binding 'appliveview-conventions-tap-install-cluster-rolebinding'
    - Creating package resource
    \ Package install status: Reconciling

    Added installed package 'appliveview-conventions' in namespace 'tap-install'
    ```

1. Verify the package install for Application Live View conventions package by
   running:

    ```console
    tanzu package installed get appliveview-conventions -n tap-install
    ```

    For example:

    ```console
    tanzu package installed get appliveview-conventions -n tap-install
    | Retrieving installation details for appliveview-conventions...
    NAME:                    appliveview-conventions
    PACKAGE-NAME:            conventions.appliveview.tanzu.vmware.com
    PACKAGE-VERSION:         1.5.1
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:

    ```

    Verify that `STATUS` is `Reconcile succeeded`.

## <a id='install-alv-apiserver'></a> Install Application Live View APIServer

To install Application Live View APIServer:

1. List version information for the package by running:

    ```console
    tanzu package available list apiserver.appliveview.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list apiserver.appliveview.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for apiserver.appliveview.tanzu.vmware.com...
      NAME                                    VERSION       RELEASED-AT
      apiserver.appliveview.tanzu.vmware.com  1.5.1         2023-03-29T00:00:00Z
    ```

1. (Optional) Change the default installation settings by running:

    ```console
    tanzu package available get apiserver.appliveview.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed. For example,
    `1.5.1`.

    For example:

    ```console
    $ tanzu package available get apiserver.appliveview.tanzu.vmware.com/1.5.1 --values-schema --namespace tap-install
      KEY                               DEFAULT             TYPE     DESCRIPTION
      kubernetes_distribution                               string  Kubernetes distribution that this package is installed on. Accepted values: ['''',''openshift''].
      kubernetes_version                                    string  Optional: The Kubernetes Version. Valid values are '1.24.*', or ''.
    ```

    For more information about values schema options, see the properties listed
    earlier.

1. Install the Application Live View APIServer package by running:

    ```console
    tanzu package install appliveview-apiserver -p apiserver.appliveview.tanzu.vmware.com -v VERSION-NUMBER -n tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed. For example,
    `1.5.1`.

    For example:

    ```console
    $ tanzu package install appliveview-apiserver -p apiserver.appliveview.tanzu.vmware.com -v 1.5.1 -n tap-install
    - Installing package 'apiserver.appliveview.tanzu.vmware.com'
    | Getting namespace 'tap-install'
    | Getting package metadata for 'apiserver.appliveview.tanzu.vmware.com'
    - Creating package resource
    \ Package install status: Reconciling

    Added installed package 'appliveview-apiserver' in namespace 'tap-install'
    ```

1. Verify the package install for Application Live View APIServer package by
   running:

    ```console
    tanzu package installed get appliveview-apiserver -n tap-install
    ```

    For example:

    ```console
    tanzu package installed get appliveview-apiserver -n tap-install
    | Retrieving installation details for appliveview-apiserver...
    NAME:                    appliveview-apiserver
    PACKAGE-NAME:            apiserver.appliveview.tanzu.vmware.com
    PACKAGE-VERSION:         1.5.1
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`.

The Application Live View UI plug-in is part of Tanzu Developer Portal.
To access the Application Live View UI, see [Application Live View in Tanzu
Application Platform GUI](../tap-gui/plugins/app-live-view.md).

## <a id='sslDisabled'></a> Deprecate the sslDisabled key

The `appliveview_connector.backend.sslDisabled` key has been replaced by
`appliveview_connector.backend.sslDeactivated`.

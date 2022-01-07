# Installing cert-manager and contour packages using Tanzu CLI

This document describes how to install cert-manager package and contour package from the Tanzu Application Platform package repository using `tanzu cli` in Tanzu Kubernetes Grid (TKG) and Tanzu Community Edition (TCE) distributions.

* **cert-manager**:

    1. List version information for the package by running:

        ```
        tanzu package available list cert-manager.tanzu.vmware.com -n tap-install
        ```

        For example:

        ```
        $ tanzu package available list cert-manager.tanzu.vmware.com -n tap-install
        / Retrieving package versions for cert-manager.tanzu.vmware.com...
          NAME                           VERSION      RELEASED-AT
          cert-manager.tanzu.vmware.com  1.5.3+tap.1  2021-08-23T17:22:51Z
        ```

    2. Install the package by running:

        ```
        tanzu package install cert-manager -p cert-manager.tanzu.vmware.com -v VERSION-NUMBER -n tap-install
        ```

        Where:

        - `VERSION-NUMBER` is the version of the package listed in step 1.

        For example:

        ```
        tanzu package install cert-manager -p cert-manager.tanzu.vmware.com -v 1.5.3+tap.1 -n tap-install
        \ Installing package 'cert-manager.tanzu.vmware.com'
        | Getting package metadata for 'cert-manager.tanzu.vmware.com'
        | Creating service account 'cert-manager-tap-install-sa'
        | Creating cluster admin role 'cert-manager-tap-install-cluster-role'
        | Creating cluster role binding 'cert-manager-tap-install-cluster-rolebinding'
        | Creating package resource
        - Waiting for 'PackageInstall' reconciliation for 'cert-manager'
        | 'PackageInstall' resource install status: Reconciling

         Added installed package 'cert-manager'
        ```

    3. Verify the package install by running:

        ```
        tanzu package installed get cert-manager -n tap-install
        ```

        For example:

        ```
        $ tanzu package installed get cert-manager -n tap-install
        / Retrieving installation details for cert-manager...
        NAME:                    cert-manager
        PACKAGE-NAME:            cert-manager.tanzu.vmware.com
        PACKAGE-VERSION:         1.5.3+tap.1
        STATUS:                  Reconcile succeeded
        CONDITIONS:              [{ReconcileSucceeded True  }]
        USEFUL-ERROR-MESSAGE:
        ```

        Verify that `STATUS` is `Reconcile succeeded`

        ```
        kubectl get deployment cert-manager -n cert-manager
        ```

        For example:

        ```
        $ kubectl get deploy cert-manager -n cert-manager
        NAME           READY   UP-TO-DATE   AVAILABLE   AGE
        cert-manager   1/1     1            1           2m18s
        ```

        Verify that `STATUS` is `Running`

* **Contour**:
  
    1. List version information for the package by running:

        ```
        tanzu package available list contour.tanzu.vmware.com -n tap-install
        ```

        For example:

        ```
        $  tanzu package available list contour.tanzu.vmware.com -n tap-install
        - Retrieving package versions for contour.tanzu.vmware.com...
          NAME                      VERSION       RELEASED-AT
          contour.tanzu.vmware.com  1.18.2+tap.1  2021-10-05T00:00:00Z
        ```

    1. (Optional) Make changes to the default installation settings:

        1. Gather values schema by running:

            ```
            tanzu package available get contour.tanzu.vmware.com/1.18.2+tap.1 --values-schema -n tap-install
            ````

            For example:

            ```
            $ tanzu package available get contour.tanzu.vmware.com/1.18.2+tap.1 --values-schema -n tap-install
            | Retrieving package details for contour.tanzu.vmware.com/1.18.2+tap.1...
              KEY                                  DEFAULT               TYPE     DESCRIPTION

              certificates.duration                8760h                 string   If using cert-manager, how long the certificates should be valid for. If useCertManager is false, this field is ignored.
              certificates.renewBefore             360h                  string   If using cert-manager, how long before expiration the certificates should be renewed. If useCertManager is false, this field is ignored.
              contour.configFileContents           <nil>                 object   The YAML contents of the Contour config file. See https://projectcontour.io/docs/v1.18.2/configuration/#configuration-file for more information.
              contour.logLevel                     info                  string   The Contour log level. Valid options are info and debug.

              contour.replicas                     2                     integer  How many Contour pod replicas to have.

              contour.useProxyProtocol             false                 boolean  Whether to enable PROXY protocol for all Envoy listeners.

              envoy.hostPorts.enable               true                  boolean  Whether to enable host ports. If false, http and https are ignored.

              envoy.hostPorts.http                 80                    integer  If enable == true, the host port number to expose Envoy's HTTP listener on.

              envoy.hostPorts.https                443                   integer  If enable == true, the host port number to expose Envoy's HTTPS listener on.

              envoy.logLevel                       info                  string   The Envoy log level.

              envoy.service.annotations            <nil>                 object   Annotations to set on the Envoy service.

              envoy.service.aws.LBType             classic               string   AWS loadbalancer type.

              envoy.service.externalTrafficPolicy  Cluster               string   The external traffic policy for the Envoy service.

              envoy.service.nodePorts.http         <nil>                 integer  If type == NodePort, the node port number to expose Envoy's HTTP listener on. If not specified, a node port will be auto-assigned by Kubernetes.
              envoy.service.nodePorts.https        <nil>                 integer  If type == NodePort, the node port number to expose Envoy's HTTPS listener on. If not specified, a node port will be auto-assigned by Kubernetes.
              envoy.service.type                   NodePort              string   The type of Kubernetes service to provision for Envoy.

              envoy.terminationGracePeriodSeconds  300                   integer  The termination grace period, in seconds, for the Envoy pods.

              envoy.hostNetwork                    false                 boolean  Whether to enable host networking for the Envoy pods.

              infrastructure_provider              vsphere               string   The infrastructur in which to deploy Contour and Envoy. example:- vsphere, aws
              namespace                            tanzu-system-ingress  string   The namespace in which to deploy Contour and Envoy.
            ```

        1. Create a `contour-values.yaml` using the following sample as a guide:

            Sample `contour-values.yaml` for installation in a public cloud or TKG cluster with `LoadBalancer` services:

            ```
            contour:
              service:
                type: LoadBalancer
            ```

            >**Note:** the LoadBalancer type is appropriate for most installations, but local clusters
              such as `kind` or `minikube` can fail to complete the package install if LoadBalancer
              services are not supported.

            >**Note:** Contour provides an Ingress implementation by default. If you have another Ingress
            implementation in your cluster, you must explicitly specify an
            [IngressClass](https://kubernetes.io/docs/concepts/services-networking/ingress/#ingress-class)
            to select a particular implementation.

            >**Note:** [Cloud Native Runtimes](#install-cnr) programs Contour HTTPRoutes are based on the
            installed namespace. The default installation of CNR uses a single Contour to provide
            internet-visible services. You can install a second Contour instance with service type
            `ClusterIP` if you want to expose some services to only the local cluster. The second instance
            must be installed in a separate namespace. You must set the CNR value `ingress.internal.namespace` to
            point to this namespace.

    1. Install the package by running:

        ```
        tanzu package install contour -p contour.tanzu.vmware.com -v 1.18.2+tap.1 -n tap-install -f contour-values.yaml
        ```

        For example:

        ```
        $ tanzu package install contour -p contour.tanzu.vmware.com -v 1.18.2+tap.1 -n tap-install -f contour-values.yaml
        - Installing package 'contour.tanzu.vmware.com'
        | Getting package metadata for 'contour.tanzu.vmware.com'
        | Creating service account 'contour-tap-install-sa'
        | Creating cluster admin role 'contour-tap-install-cluster-role'
        | Creating cluster role binding 'contour-tap-install-cluster-rolebinding'
        - Creating package resource
        - Package install status: Reconciling

        Added installed package 'contour' in namespace 'tap-install'
        ```

    1. Verify the package install by running:

        ```
        tanzu package installed get contour -n tap-install
        ```

        For example:

        ```
        $ tanzu package installed get contour -n tap-install
        / Retrieving installation details for contour...
        NAME:                    contour
        PACKAGE-NAME:            contour.tanzu.vmware.com
        PACKAGE-VERSION:         1.18.2+tap.1
        STATUS:                  Reconcile succeeded
        CONDITIONS:              [{ReconcileSucceeded True  }]
        USEFUL-ERROR-MESSAGE:
        ```

        Verify that `STATUS` is `Reconcile succeeded`

    1. Verify the installation:

        ```
        kubectl get po -n tanzu-system-ingress
        ```

        For example:

        ```
        $  kubectl get po -n tanzu-system-ingress
        NAME                       READY   STATUS    RESTARTS   AGE
        contour-857d46c845-4r6c5   1/1     Running   1          18d
        contour-857d46c845-p6bbq   1/1     Running   1          18d
        envoy-mxkjk                2/2     Running   2          18d
        envoy-qlg8l                2/2     Running   2          18d
        ```

        Ensure that all Pods are `Running` with all containers ready.

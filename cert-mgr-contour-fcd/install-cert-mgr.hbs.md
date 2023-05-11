# Install cert-manager, Contour

This document tells you how to install cert-manager, Contour, and FluxCD Source Controller
from the Tanzu Application Platform (commonly known as TAP) package repository.

>**Note** Follow the steps in this topic if you do not want to use a profile to install cert-manager, contour, and FluxCD Source Controller.
For more information about profiles, see [Components and installation profiles](../about-package-profiles.md).

## <a id='cnr-prereqs'></a>Prerequisites

Before installing cert-manager, Contour, and FluxCD Source Controller:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).

## <a id='install-cert-mgr'></a>Install cert-manager

To install cert-manager from the Tanzu Application Platform package repository:

1. List version information for the package by running:

      ```console
      tanzu package available list cert-manager.tanzu.vmware.com -n tap-install
      ```

      For example:

      ```console
      $ tanzu package available list cert-manager.tanzu.vmware.com -n tap-install
      / Retrieving package versions for cert-manager.tanzu.vmware.com...
        NAME                           VERSION      RELEASED-AT
        cert-manager.tanzu.vmware.com  1.5.3+tap.1  2021-08-23T17:22:51Z
      ```

2. Create a file named `cert-manager-rbac.yaml` using the following sample and apply the configuration.


      ```yaml
      apiVersion: rbac.authorization.k8s.io/v1
      kind: ClusterRole
      metadata:
        name: cert-manager-tap-install-cluster-admin-role
      rules:
      - apiGroups:
        - '*'
        resources:
        - '*'
        verbs:
        - '*'
      ---
      apiVersion: rbac.authorization.k8s.io/v1
      kind: ClusterRoleBinding
      metadata:
        name: cert-manager-tap-install-cluster-admin-role-binding
      roleRef:
        apiGroup: rbac.authorization.k8s.io
        kind: ClusterRole
        name: cert-manager-tap-install-cluster-admin-role
      subjects:
      - kind: ServiceAccount
        name: cert-manager-tap-install-sa
        namespace: tap-install
      ---
      apiVersion: v1
      kind: ServiceAccount
      metadata:
        name: cert-manager-tap-install-sa
        namespace: tap-install
      ```

      For example:

      ```console
      kubectl apply -f cert-manager-rbac.yaml
      ```

3. Create a file named `cert-manager-install.yaml` using the following sample and apply the configuration.


      ```yaml
      apiVersion: packaging.carvel.dev/v1alpha1
      kind: PackageInstall
      metadata:
        name: cert-manager
        namespace: tap-install
      spec:
        serviceAccountName: cert-manager-tap-install-sa
        packageRef:
          refName: cert-manager.tanzu.vmware.com
          versionSelection:
            constraints: "VERSION-NUMBER"
            prereleases: {}
      ```

      Where:

      - `VERSION-NUMBER` is the version of the package listed in step 1.


      For example:

      ```console
      kubectl apply -f cert-manager-install.yaml
      ```

4. Verify the package install by running:

      ```console
      tanzu package installed get cert-manager -n tap-install
      ```

      For example:

      ```console
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

      ```console
      kubectl get deployment cert-manager -n cert-manager
      ```

      For example:

      ```console
      $ kubectl get deploy cert-manager -n cert-manager
      NAME           READY   UP-TO-DATE   AVAILABLE   AGE
      cert-manager   1/1     1            1           2m18s
      ```

      Verify that `STATUS` is `Running`

## <a id='install-contour'></a>Install Contour

To install Contour from the Tanzu Application Platform package repository:

1. List version information for the package by running:

    ```console
    tanzu package available list contour.tanzu.vmware.com -n tap-install
    ```

    For example:

    ```console
    $  tanzu package available list contour.tanzu.vmware.com -n tap-install
    - Retrieving package versions for contour.tanzu.vmware.com...
      NAME                      VERSION       RELEASED-AT
      contour.tanzu.vmware.com  1.22.0+tap.5  2022-09-05 20:00:00 -0400 EDT
    ```

2. Create a file named `contour-rbac.yaml` using the following sample and apply the configuration.

    ```yaml
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
      name: contour-tap-install-cluster-admin-role
    rules:
    - apiGroups:
      - '*'
      resources:
      - '*'
      verbs:
      - '*'
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: contour-tap-install-cluster-admin-role-binding
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: contour-tap-install-cluster-admin-role
    subjects:
    - kind: ServiceAccount
      name: contour-tap-install-sa
      namespace: tap-install
    ---
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: contour-tap-install-sa
      namespace: tap-install
    ```

3. Apply the configuration by running:

    ```console
    kubectl apply -f contour-rbac.yaml
    ```

4. Create a file named `contour-install.yaml` by using the following sample and apply the configuration:

    >**Note** The following configuration installs the Contour package with default options.
    To make changes to the default installation settings, go to the next step.

    ```yaml
    apiVersion: packaging.carvel.dev/v1alpha1
    kind: PackageInstall
    metadata:
      name: contour
      namespace: tap-install
    spec:
      serviceAccountName: contour-tap-install-sa
      packageRef:
        refName: contour.tanzu.vmware.com
        versionSelection:
          constraints: "VERSION-NUMBER"
          prereleases: {}
    ```
    Where `VERSION-NUMBER` is the version of the package listed in step 1.

5. (Optional) Make changes to the default installation settings:

    1. Gather values schema by running:

        ```console
        tanzu package available get contour.tanzu.vmware.com/1.22.0+tap.5 --values-schema -n tap-install
        ```

        For example:

        ```console
        $ tanzu package available get contour.tanzu.vmware.com/1.22.0+tap.5 --values-schema -n tap-install

          KEY                                  DEFAULT               TYPE     DESCRIPTION
          contour.configFileContents           <nil>                 object   The YAML contents of the Contour config file. See https://projectcontour.io/docs/v1.22.0/configuration/#configuration-file for more information.
          contour.logLevel                     info                  string   The Contour log level. Valid options are 'info' and 'debug'.
          contour.replicas                     2                     integer  How many Contour pod replicas to have.
          contour.useProxyProtocol             false                 boolean  Whether to enable PROXY protocol for all Envoy listeners.
          envoy.hostPorts.enable               false                 boolean  Whether to enable host ports. If false, http and https are ignored.
          envoy.hostPorts.http                 80                    integer  If enable == true, the host port number to expose Envoy's HTTP listener on.
          envoy.hostPorts.https                443                   integer  If enable == true, the host port number to expose Envoy's HTTPS listener on.
          envoy.logLevel                       info                  string   The Envoy log level.
          envoy.service.annotations            <nil>                 object   Annotations to set on the Envoy service.
          envoy.service.aws.LBType             classic               string   The type of AWS load balancer to provision. Options are 'classic' and 'nlb'.
          envoy.service.externalTrafficPolicy  <nil>                 string   The external traffic policy for the Envoy service.
          envoy.service.loadBalancerIP         <nil>                 string   The desired load balancer IP for the Envoy service. If type is not 'LoadBalancer', this field is ignored. It is up to the cloud provider whether to honor this request. If not specified, then load balancer IP will be assigned by the cloud provider.
          envoy.service.nodePorts.http         <nil>                 integer  If type == NodePort, the node port number to expose Envoy's HTTP listener on. If not specified, a node port will be auto-assigned by Kubernetes.
          envoy.service.nodePorts.https        <nil>                 integer  If type == NodePort, the node port number to expose Envoy's HTTPS listener on. If not specified, a node port will be auto-assigned by Kubernetes.
          envoy.service.type                   LoadBalancer          string   The type of Kubernetes service to provision for Envoy.
          envoy.terminationGracePeriodSeconds  300                   integer  The termination grace period, in seconds, for the Envoy pods.
          envoy.hostNetwork                    false                 boolean  Whether to enable host networking for the Envoy pods.
          infrastructure_provider              vsphere               string   The underlying infrastructure provider. Valid values are `vsphere`, `aws` and `azure`.
          kubernetes_distribution              <nil>                 string   Kubernetes distribution that this package is being installed on. Accepted values: ['','openshift']
          namespace                            tanzu-system-ingress  string   The namespace in which to deploy Contour and Envoy.
          certificates.duration                8760h                 string   If using cert-manager, how long the certificates should be valid for. If useCertManager is false, this field is ignored.
          certificates.renewBefore             360h                  string   If using cert-manager, how long before expiration the certificates should be renewed. If useCertManager is false, this field is ignored.
          certificates.useCertManager          false                 boolean  Whether to use cert-manager to provision TLS certificates for securing communication between Contour and Envoy. If false, the upstream Contour certgen job will be used to provision certificates. If true, the cert-manager addon must be installed in the cluster.
        ```

    2. Create a `contour-install.yaml` file using the following sample as a guide.
        This sample is for installation in an AWS public cloud with `LoadBalancer` services:

        ```yaml
        apiVersion: packaging.carvel.dev/v1alpha1
        kind: PackageInstall
        metadata:
          name: contour
          namespace: tap-install
        spec:
          serviceAccountName: contour-tap-install-sa
          packageRef:
            refName: contour.tanzu.vmware.com
            versionSelection:
              constraints: 1.22.0+tap.5
              prereleases: {}
          values:
          - secretRef:
              name: contour-values
        ---
        apiVersion: v1
        kind: Secret
        metadata:
          name: contour-values
          namespace: tap-install
        stringData:
          values.yaml: |
            envoy:
              service:
                type: LoadBalancer
            infrastructure_provider: aws
        ```

        The LoadBalancer type is appropriate for most installations, but local
        clusters such as `kind` or `minikube` can fail to complete the package
        install if LoadBalancer services are not supported.

        For local clusters, you can configure `contour.evnoy.service.type` to be
        `NodePort`. If your local cluster is set up with extra port mappings on
        the nodes, you might also need configure `envoy.service.nodePorts.http`
        and `envoy.service.nodePorts.https` to match the port mappings from your
        local machine into one of the nodes of your local cluster. This pattern
        is seen when using the [Learning Center on
        Kind](../learning-center/local-install-guides/deploying-to-kind.html).

        Contour provides an Ingress implementation by default. If you have another Ingress
        implementation in your cluster, you must explicitly specify an
        [IngressClass](https://kubernetes.io/docs/concepts/services-networking/ingress/#ingress-class)
        to select a particular implementation.

        [Cloud Native Runtimes](#install-cnr) programs Contour HTTPRoutes are based on the
        installed namespace. The default installation of CNR uses a single Contour to provide
        internet-visible services. You can install a second Contour instance with service type
        `ClusterIP` if you want to expose some services to only the local cluster.
        The second instance must be installed in a separate namespace.
        You must set the CNR value `ingress.internal.namespace` to point to this namespace.

6. Install the package by running:

    ```console
    kubectl apply -f contour-install.yaml
    ```


7. Verify the package install by running:

    ```console
    tanzu package installed get contour -n tap-install
    ```

    For example:

    ```console
    $ tanzu package installed get contour -n tap-install
    / Retrieving installation details for contour...
    NAME:                    contour
    PACKAGE-NAME:            contour.tanzu.vmware.com
    PACKAGE-VERSION:         1.22.0+tap.5
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`

8. Verify the installation by running:

    ```console
    kubectl get po -n tanzu-system-ingress
    ```

    For example:

    ```console
    $  kubectl get po -n tanzu-system-ingress
    NAME                       READY   STATUS    RESTARTS   AGE
    contour-857d46c845-4r6c5   1/1     Running   1          18d
    contour-857d46c845-p6bbq   1/1     Running   1          18d
    envoy-mxkjk                2/2     Running   2          18d
    envoy-qlg8l                2/2     Running   2          18d
    ```

    Ensure that all pods are `Running` with all containers ready.

# Install Contour

This topic tells you how to install Contour from the Tanzu Application Platform (commonly known as TAP) package repository.

>**Note** Follow the steps in this topic if you do not want to use a profile to install Contour.
For more information about profiles, see [Components and installation profiles](../../about-package-profiles.hbs.md).

To install Contour from the Tanzu Application Platform package repository without a profile:

1. [Install cert-manager](../../cert-manager/install.hbs.md).

1. List version information for the package by running:

    ```console
    tanzu package available list contour.tanzu.vmware.com -n tap-install
    ```

    For example:

    ```console
    $  tanzu package available list contour.tanzu.vmware.com -n tap-install
      NAME                      VERSION       RELEASED-AT
      contour.tanzu.vmware.com  1.24.4        2023-05-22 19:00:00 -0500 -05
    ```

2. Create a file named `contour-rbac.yaml` by using the following sample and apply the configuration:

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

    Where `VERSION-NUMBER` is the version of the package listed earlier.

5. (Optional) Make changes to the default installation settings:

    1. Gather values schema by running:

        ```console
        tanzu package available get contour.tanzu.vmware.com/1.24.4 --values-schema -n tap-install
        ```

        For example:

        ```console
        $ tanzu package available get contour.tanzu.vmware.com/1.24.4 --values-schema -n tap-install

          KEY                                                       DEFAULT                   TYPE     DESCRIPTION
          kubernetes_distribution                                                             string   The distribution of Kubernetes, used to determine if distribution-specific
                                                                                                       configurations need to be applied. Options are empty and openshift. If running
                                                                                                       on an OpenShift cluster, this must be set to openshift. When set to openshift,
                                                                                                       a Role and RoleBinding are created to associate Contour's controllers with the
                                                                                                       appropriate OpenShift Security Context Constraint resource.
          kubernetes_version                                        0.0.0                     string   The version of Kubernetes being used, for enabling version-specific behaviors.
                                                                                                       Accept any valid major.minor.patch version of Kubernetes. This field is
                                                                                                       optional. Currently only has effect when kubernetes_distribution is set to
                                                                                                       openshift.
          namespace                                                 tanzu-system-ingress      string   The namespace in which to deploy Contour and Envoy.
          registry_secret_names                                     [contour-reg-creds]       array    The names of the placeholder secrets that will contain registry credentials to
                                                                                                       pull the Contour and Envoy images.
          certificates.duration                                     8760h                     string   How long the certificates should be valid for.
          certificates.renewBefore                                  360h                      string   How long before expiration the certificates should be renewed.
          contour.pspNames                                          vmware-system-restricted  string   Pod security policy names to apply to Contour.
          contour.replicas                                          2                         integer  How many Contour pod replicas to have.
          contour.resources.contour.requests.memory                                           string   Memory request to apply to the contour container.
          contour.resources.contour.requests.cpu                                              string   CPU request to apply to the contour container.
          contour.resources.contour.limits.cpu                                                string   CPU limit to apply to the contour container.
          contour.resources.contour.limits.memory                                             string   Memory limit to apply to the contour container.
          contour.useProxyProtocol                                  false                     boolean  Whether to enable PROXY protocol for all Envoy listeners.
          contour.configFileContents                                <nil>                     <nil>    The YAML contents of the Contour config file. See
                                                                                                       https://projectcontour.io/docs/1.24/configuration/#configuration-file for more
                                                                                                       information.
          contour.logLevel                                          info                      string   The Contour log level. Valid options are 'info' and 'debug'.
          envoy.pspNames                                                                      string   Pod security policy names to apply to Envoy.
          envoy.service.externalTrafficPolicy                                                 string   The external traffic policy for the Envoy service. If type is 'ClusterIP', this
                                                                                                       field is ignored. Otherwise, defaults to 'Cluster' for vsphere and 'Local' for
                                                                                                       others.
          envoy.service.loadBalancerIP                                                        string   The desired load balancer IP. If type is not 'LoadBalancer', this field is
                                                                                                       ignored. It is up to the cloud provider whether to honor this request. If not
                                                                                                       specified, then load balancer IP will be assigned by the cloud provider.
          envoy.service.nodePorts.http                              0                         integer  The node port number to expose Envoy's HTTP listener on. If not specified, a
                                                                                                       node port will be auto-assigned by Kubernetes.
          envoy.service.nodePorts.https                             0                         integer  The node port number to expose Envoy's HTTPS listener on. If not specified, a
                                                                                                       node port will be auto-assigned by Kubernetes.
          envoy.service.type                                                                  string   The type of Kubernetes service to provision for Envoy. Valid values are
                                                                                                       'LoadBalancer', 'NodePort', and 'ClusterIP'. If not specified, will default to
                                                                                                       'NodePort' for vsphere and 'LoadBalancer' for others.
          envoy.service.annotations                                 <nil>                     <nil>    Annotations to set on the Envoy service.
          envoy.service.aws.LBType                                  classic                   string   The type of AWS load balancer to provision. Options are 'classic' and 'nlb'.
          envoy.service.disableWait                                 false                     boolean  This setting is no longer supported and is included in the schema for backwards
                                                                                                       compatibility only.
          envoy.terminationGracePeriodSeconds                       300                       integer  The termination grace period, in seconds, for the Envoy pods.
          envoy.workload.replicas                                   2                         integer  The number of Envoy replicas to deploy when 'type' is set to 'Deployment'. If
                                                                                                       not specified, it will default to '2'.
          envoy.workload.resources.envoy.limits.cpu                                           string   CPU limit to apply to the envoy container.
          envoy.workload.resources.envoy.limits.memory                                        string   Memory limit to apply to the envoy container.
          envoy.workload.resources.envoy.requests.cpu                                         string   CPU request to apply to the envoy container.
          envoy.workload.resources.envoy.requests.memory                                      string   Memory request to apply to the envoy container.
          envoy.workload.resources.shutdownManager.limits.cpu                                 string   CPU limit to apply to the shutdown-manager container.
          envoy.workload.resources.shutdownManager.limits.memory                              string   Memory limit to apply to the shutdown-manager container.
          envoy.workload.resources.shutdownManager.requests.cpu                               string   CPU request to apply to the shutdown-manager container.
          envoy.workload.resources.shutdownManager.requests.memory                            string   Memory request to apply to the shutdown-manager container.
          envoy.workload.type                                       DaemonSet                 string   The type of Kubernetes workload Envoy is deployed as. Options are 'Deployment'
                                                                                                       or 'DaemonSet'. If not specified, will default to 'DaemonSet'.
          envoy.hostNetwork                                         false                     boolean  Whether to enable host networking for the Envoy pods.
          envoy.hostPorts.https                                     443                       integer  If enable == true, the host port number to expose Envoy's HTTPS listener on.
          envoy.hostPorts.enable                                    true                      boolean  Whether to enable host ports. If false, http & https are ignored.
          envoy.hostPorts.http                                      80                        integer  If enable == true, the host port number to expose Envoy's HTTP listener on.
          envoy.logLevel                                            info                      string   The Envoy log level.
          infrastructure_provider                                   vsphere                   string   The underlying infrastructure provider. Options are vsphere, aws, and azure.
                                                                                               This field is not required, but enables better validation and defaulting if
                                                                                               provided.
        ```

    2. Create a `contour-install.yaml` file by using the following sample as a guide:

        >**Note** This sample is for installation in an AWS public cloud with `LoadBalancer` services.

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
              constraints: 1.24.4
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
        clusters such as `kind` can fail to complete the package
        install if LoadBalancer services are not supported.

        For local clusters, you can configure `contour.evnoy.service.type` to be
        `NodePort`. If your local cluster is set up with extra port mappings on
        the nodes, you might also need configure `envoy.service.nodePorts.http`
        and `envoy.service.nodePorts.https` to match the port mappings from your
        local machine into one of the nodes of your local cluster.

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

    NAME:                    contour
    PACKAGE-NAME:            contour.tanzu.vmware.com
    PACKAGE-VERSION:         1.24.4
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
    contour-689789679f-cl8cg   1/1     Running   0          6d16h
    contour-689789679f-g2xjn   1/1     Running   0          6d16h
    envoy-2blkl                2/2     Running   0          6d16h
    envoy-2rjtb                2/2     Running   0          6d16h
    envoy-9sljz                2/2     Running   0          6d16h
    envoy-cv5fc                2/2     Running   0          6d16h
    envoy-gvtlf                2/2     Running   0          6d16h
    envoy-qtrxd                2/2     Running   0          6d16h
    ```

    Ensure that all pods are `Running` with all containers ready.

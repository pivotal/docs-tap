# Installing individual packages

This document describes how to install individual Tanzu Application Platform packages
from the Tanzu Application Platform package repository.

Use the instructions on this page if you do not want to use a profile to install packages
or if you want to install additional packages after installing a profile.

Before installing the packages, ensure that you have completed the prerequisites, configured
and verified the cluster, accepted the EULA, and installed the Tanzu CLI with any required plug-ins.
For information, see [Installing part I: Prerequisites, EULA, and CLI](install-general.md).

+ [Install cert-manager, Contour, and FluxCD source controller](#install-prereqs)
+ [Install Cloud Native Runtimes](#install-cnr)
+ [Install Convention Service](#install-con-serv)
+ [Install Source Controller](#install-src-ctrl)
+ [Install Application Accelerator](#install-app-acc)
+ [Install Tanzu Build Service](#install-tbs)
+ [Install Supply Chain Choreographer](#install-scc)
+ [Install Out of the Box Delivery Basic](#install-ootb-del-basic)
+ [Install Out of the Box Templates](#install-ootb-templates)
+ [Install Out of The Box Supply Chain Basic](#install-ootb-sc-basic)
+ [Install Out of The Box Supply Chain with Testing](#inst-ootb-sc-testing)
+ [Install Out of The Box Supply Chain with Testing and Scanning](#inst-ootb-sc-test-scan)
+ [Install Developer Conventions](#inst-dev-convs)
+ [Install Spring Boot Conventions](#install-spring-boot-conv)
+ [Install Application Live View](#install-app-live-view)
+ [Install Tanzu Application Platform GUI](#install-tap-gui)
+ [Install Learning Center for Tanzu Application Platform](#install-learning-center)
+ [Install Service Bindings](#install-service-bindings)
+ [Install Supply Chain Security Tools - Store](#install-scst-store)
+ [Install Supply Chain Security Tools - Sign](#install-scst-sign)
+ [Install Supply Chain Security Tools - Scan](#install-scst-scan)
+ [Install API portal](#install-api-portal)
+ [Install Services Toolkit](#install-services-toolkit)
+ [Install Tekton](#install-tekton)


## <a id='install-prereqs'></a> Install cert-manager, contour and FluxCD Source Controller

cert_manager, contour and FluxCD Source Controller are installed as part of all profiles.
If you do not want to use a profile, install them manually.

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

  2. Create a `cert-manager-rbac.yml` using below sample and Apply the config.


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

        ```
        kubectl apply -f cert-manager-rbac.yml
        ```

  3. Create a `cert-manager-install.yml` using below sample and Apply the config.


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

        Where
        - `VERSION-NUMBER` is the version of the package listed in step 1.


        For example:

        ```
        kubectl apply -f cert-manager-rbac.yml
        ```

  4. Verify the package install by running:

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

* **contour**:

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

    2. Create a `contour-rbac.yml` using the below sample and apply the configuration.
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

        ```
        kubectl apply -f contour-rbac.yml
        ```

    4. Create a `contour-install.yml` using the sample below and apply the configuration.
       The following configuration installs the contour package with default options.
       If you want to make changes to the default installation settings, go to the next step.

        ```yaml
        apiVersion: packaging.carvel.dev/v1alpha1
        kind: PackageInstall
        metadata:
          name: contour
          namespace: tap-install
        spec:
          serviceAccountName: tap-install-sa
          packageRef:
            refName: contour.tanzu.vmware.com
            versionSelection:
              constraints: "VERSION-NUMBER"
              prereleases: {}
        ```
        Where `VERSION-NUMBER` is the version of the package listed in step 1.

    5. (Optional) Make changes to the default installation settings:

        1. Gather values schema by running:

            ```
            tanzu package available get contour.tanzu.vmware.com/1.18.2+tap.1 --values-schema -n tap-install
            ````

            For example:

            ```console
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
                  constraints: 1.18.2+tap.1
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

            The LoadBalancer type is appropriate for most installations, but local clusters
            such as `kind` or `minikube` can fail to complete the package install if LoadBalancer
            services are not supported.

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

        ```
        kubectl apply -f contour-install.yaml
        ```


    7. Verify the package install by running:

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

    8. Verify the installation by running:

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

        Ensure that all pods are `Running` with all containers ready.


* **FluxCD source-controller**:

    1. List version information for the package by running:

        ```
        tanzu package available list fluxcd.source.controller.tanzu.vmware.com -n tap-install
        ```

        For example:

        ```
        $ tanzu package available list fluxcd.source.controller.tanzu.vmware.com -n tap-install
            \ Retrieving package versions for fluxcd.source.controller.tanzu.vmware.com...
              NAME                                       VERSION  RELEASED-AT
              fluxcd.source.controller.tanzu.vmware.com  0.16.0   2021-10-27 19:00:00 -0500 -05
        ```

    2. Install the package by running:

        ```
        tanzu package install fluxcd-source-controller -p fluxcd.source.controller.tanzu.vmware.com -v VERSION-NUMBER -n tap-install
        ```

        Where:

        - `VERSION-NUMBER` is the version of the package listed in step 1.

        For example:

        ```
        tanzu package install fluxcd-source-controller -p fluxcd.source.controller.tanzu.vmware.com -v 0.16.0 -n tap-install
        \ Installing package 'fluxcd.source.controller.tanzu.vmware.com'
        | Getting package metadata for 'fluxcd.source.controller.tanzu.vmware.com'
        | Creating service account 'fluxcd-source-controller-tap-install-sa'
        | Creating cluster admin role 'fluxcd-source-controller-tap-install-cluster-role'
        | Creating cluster role binding 'fluxcd-source-controller-tap-install-cluster-rolebinding'
        | Creating package resource
        - Waiting for 'PackageInstall' reconciliation for 'fluxcd-source-controller'
        | 'PackageInstall' resource install status: Reconciling

         Added installed package 'fluxcd-source-controller'
        ```

    3. Verify the package install by running:

        ```
        tanzu package installed get fluxcd-source-controller -n tap-install
        ```

        For example:

        ```
        tanzu package installed get fluxcd-source-controller -n tap-install
        \ Retrieving installation details for fluxcd-source-controller...
        NAME:                    fluxcd-source-controller
        PACKAGE-NAME:            fluxcd.source.controller.tanzu.vmware.com
        PACKAGE-VERSION:         0.16.0
        STATUS:                  Reconcile succeeded
        CONDITIONS:              [{ReconcileSucceeded True  }]
        USEFUL-ERROR-MESSAGE:
        ```

        Verify that `STATUS` is `Reconcile succeeded`

        ```
        kubectl get pods -n flux-system
        ```

        For example:

        ```
        $ kubectl get pods -n flux-system
        NAME                                 READY   STATUS    RESTARTS   AGE
        source-controller-69859f545d-ll8fj   1/1     Running   0          3m38s
        ```

        Verify that `STATUS` is `Running`

## <a id='install-cnr'></a> Install Cloud Native Runtimes

To install Cloud Native Runtimes:

1. List version information for the package by running:

    ```
    tanzu package available list cnrs.tanzu.vmware.com --namespace tap-install
    ```

     For example:

    ```
    $ tanzu package available list cnrs.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for cnrs.tanzu.vmware.com...
      NAME                   VERSION  RELEASED-AT
      cnrs.tanzu.vmware.com  1.0.3    2021-10-20T00:00:00Z
    ```

1. (Optional) Make changes to the default installation settings:

    1. Gather values schema.

        ```
        tanzu package available get cnrs.tanzu.vmware.com/1.0.3 --values-schema -n tap-install
        ```

        For example:

        ```
        $ tanzu package available get cnrs.tanzu.vmware.com/1.0.3 --values-schema -n tap-install
        | Retrieving package details for cnrs.tanzu.vmware.com/1.0.3...
          KEY                         DEFAULT  TYPE             DESCRIPTION
          ingress.external.namespace  <nil>    string   Optional: Only valid if a Contour instance already present in the cluster. Specify a namespace where an existing Contour is installed on your cluster (for external services) if you want CNR to use your Contour instance.
          ingress.internal.namespace  <nil>    string   Optional: Only valid if a Contour instance already present in the cluster. Specify a namespace where an existing Contour is installed on your cluster (for internal services) if you want CNR to use your Contour instance.
          ingress.reuse_crds          false    boolean  Optional: Only valid if a Contour instance already present in the cluster. Set to "true" if you want CNR to re-use the cluster's existing Contour CRDs.
          local_dns.domain            <nil>    string   Optional: Set a custom domain for CoreDNS. Only applicable when "local_dns.enable" is set to "true", "provider" is set to "local" and running on Kind.
          local_dns.enable            false    boolean  Optional: Only for when "provider" is set to "local" and running on Kind. Set to true to enable local DNS.
          pdb.enable                  true     boolean  Optional: Set to true to enable Pod Disruption Budget. If provider local is set to "local", the PDB will be disabled automatically.
          provider                    <nil>    string   Optional: Kubernetes cluster provider. To be specified if deploying CNR on a local Kubernetes cluster provider.
        ```

    1. Create a `cnr-values.yaml` using the following sample as a guide:

        Sample `cnr-values.yaml` for Cloud Native Runtimes:


        ```
        ---
        # if deploying on a local cluster such as Kind. Otherwise, you can remove this field
        provider: local
        ```

        >**Note:** For most installations, you can leave the `cnr-values.yaml` empty, and use the default values.

        If you are running on a single-node cluster, such as kind or minikube, set the `provider: local`
        option. This option reduces resource requirements by using a HostPort service instead of a
        LoadBalancer and reduces the number of replicas.

        Cloud Native Runtimes reuses the existing `tanzu-system-ingress` Contour installation for
        external and internal access when installed in the `dev` or `full` profile.
        If you want to use a separate Contour installation for system-internal traffic, set
        `cnrs.ingress.internal.namespace` to the empty string (`""`).

        For more information about using Cloud Native Runtimes with kind, see the
        [Cloud Native Runtimes documentation](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/1.0/tanzu-cloud-native-runtimes-1-0/GUID-local-dns.html#config-cluster).
        If you are running on a multi-node cluster, do not set `provider`.

        If your environment has Contour packages, Contour might conflict with the Cloud Native Runtimes installation.

        For information about how to prevent conflicts, see [Installing Cloud Native Runtimes for Tanzu with an Existing Contour Installation](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/1.0/tanzu-cloud-native-runtimes-1-0/GUID-contour.html) in the Cloud Native Runtimes documentation.
        Specify values for `ingress.reuse_crds`,
        `ingress.external.namespace`, and `ingress.internal.namespace` in the `cnr-values.yaml` file.

1. Install the package by running:

    ```
    tanzu package install cloud-native-runtimes -p cnrs.tanzu.vmware.com -v 1.0.3 -n tap-install -f cnr-values.yaml --poll-timeout 30m
    ```

    For example:

    ```
    $ tanzu package install cloud-native-runtimes -p cnrs.tanzu.vmware.com -v 1.0.3 -n tap-install -f cnr-values.yaml --poll-timeout 30m
    - Installing package 'cnrs.tanzu.vmware.com'
    | Getting package metadata for 'cnrs.tanzu.vmware.com'
    | Creating service account 'cloud-native-runtimes-tap-install-sa'
    | Creating cluster admin role 'cloud-native-runtimes-tap-install-cluster-role'
    | Creating cluster role binding 'cloud-native-runtimes-tap-install-cluster-rolebinding'
    - Creating package resource
    - Package install status: Reconciling

     Added installed package 'cloud-native-runtimes' in namespace 'tap-install'
    ```

    Use an empty file for `cnr-values.yaml` if you want the default installation configuration. Otherwise, see the previous step to learn more about setting installation configuration values.

1. Verify the package install by running:

    ```
    tanzu package installed get cloud-native-runtimes -n tap-install
    ```

    For example:

    ```
    tanzu package installed get cloud-native-runtimes -n tap-install
    | Retrieving installation details for cc...
    NAME:                    cloud-native-runtimes
    PACKAGE-NAME:            cnrs.tanzu.vmware.com
    PACKAGE-VERSION:         1.0.3
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`

1. Configure a namespace to use Cloud Native Runtimes:

   >**Note:** This step covers configuring a namespace to run Knative services.
   >If you rely on a SupplyChain to deploy Knative services into your cluster,
   >then skip this step because namespace configuration is covered in
   >[Set up developer namespaces to use installed packages](#setup).
   >Otherwise, you must complete the following steps for each namespace where you create Knative services.

   Service accounts that run workloads using Cloud Native Runtimes need access to the image pull secrets for the Tanzu package.
   This includes the `default` service account in a namespace, which is created automatically but not associated with any image pull secrets.
   Without these credentials, attempts to start a service fail with a timeout and the Pods report that they are unable to pull the `queue-proxy` image.

    1. Create an image pull secret in the current namespace and fill it from the `tap-registry`
    secret mentioned in
       [Add the Tanzu Application Platform package repository](install.md#add-package-repositories).
       Run the following commands to create an empty secret and annotate it as a target of the secretgen
       controller:

        ```
        kubectl create secret generic pull-secret --from-literal=.dockerconfigjson={} --type=kubernetes.io/dockerconfigjson
        kubectl annotate secret pull-secret secretgen.carvel.dev/image-pull-secret=""
        ```

    1. After you create a `pull-secret` secret in the same namespace as the service account,
    run the following command to add the secret to the service account:

        ```
        kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "pull-secret"}]}'
        ```

    1. Verify that a service account is correctly configured by running:

        ```
        kubectl describe serviceaccount default
        ```

        For example:

        ```
        kubectl describe sa default
        Name:                default
        Namespace:           default
        Labels:              <none>
        Annotations:         <none>
        Image pull secrets:  pull-secret
        Mountable secrets:   default-token-xh6p4
        Tokens:              default-token-xh6p4
        Events:              <none>
        ```

        >**Note:** The service account has access to the `pull-secret` image pull secret.

To learn more about using Cloud Native Runtimes,
see [Verify your Installation](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/1.0/tanzu-cloud-native-runtimes-1-0/GUID-verify-installation.html)
in the Cloud Native Runtimes documentation.

## <a id='install-con-serv'></a> Install Convention Service

Convention Service allows app operators to enrich Pod Template Specs with operational knowledge
based on specific conventions they define.

Convention Service includes the following components:

+ Convention Controller: Provides metadata to the Convention Server.
Implements the update requests from Convention Server.
+ Convention Server: Receives and evaluates metadata associated with a workload from Convention
Controller. Requests updates to the Pod Template Spec associated with that workload.
There can be one or more Convention Servers for a single Convention Controller instance.

In the following procedure, you install Convention Controller.

You install Convention Servers as part of separate installation procedures.
For example, you install an `app-live-view` Convention Server as part of the `app-live-view`
installation.

 **Prerequisite**: Cert-manager installed on the cluster. See [Install Prerequisites](#install-prereqs).

To install Convention Controller:

1. List version information for the package by running:
    ```
    tanzu package available list controller.conventions.apps.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```
    $ tanzu package available list controller.conventions.apps.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for controller.conventions.apps.tanzu.vmware.com...
      NAME                                          VERSION  RELEASED-AT
      controller.conventions.apps.tanzu.vmware.com  0.4.2    2021-09-16T00:00:00Z
    ```

2. (Optional) Make changes to the default installation settings by running:

    ```
    tanzu package available get controller.conventions.apps.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed in step 1.

    For example:

    ```
    $ tanzu package available get controller.conventions.apps.tanzu.vmware.com/0.4.2 --values-schema --namespace tap-install
    ```

    For more information about values schema options, see the individual product documentation.


1. Install the package by running:

    ```
    tanzu package install convention-controller -p controller.conventions.apps.tanzu.vmware.com -v 0.4.2 -n tap-install
    ```

    For example:
    ```
    tanzu package install convention-controller -p controller.conventions.apps.tanzu.vmware.com -v 0.4.2 -n tap-install
    / Installing package 'controller.conventions.apps.tanzu.vmware.com'
    | Getting namespace 'tap-install'
    - Getting package metadata for 'controller.conventions.apps.tanzu.vmware.com'
    | Creating service account 'convention-controller-tap-install-sa'
    | Creating cluster admin role 'convention-controller-tap-install-cluster-role'
    | Creating cluster role binding 'convention-controller-tap-install-cluster-rolebinding'
    \ Creating package resource
    | Package install status: Reconciling
    Added installed package 'convention-controller' in namespace 'tap-install'
    ```

1. Verify the package install by running:

    ```
    tanzu package installed get convention-controller -n tap-install
    ```

    For example:

    ```
    tanzu package installed get convention-controller -n tap-install
    Retrieving installation details for convention-controller...
    NAME:                    convention-controller
    PACKAGE-NAME:            controller.conventions.apps.tanzu.vmware.com
    PACKAGE-VERSION:         0.4.2
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`

    ```
    kubectl get pods -n conventions-system
    ```

    For example:

    ```
    $ kubectl get pods -n conventions-system
    NAME                                             READY   STATUS    RESTARTS   AGE
    conventions-controller-manager-596c65f75-j9dmn   1/1     Running   0          72s
    ```

    Verify that `STATUS` is `Running`


## <a id='install-src-ctrl'></a> Install Source Controller

Use the following procedure to install Source Controller.

**Prerequisite**: Cert-manager installed on the cluster.

To install Source Controller:

1. List version information for the package by running:

    ```
    tanzu package available list controller.source.apps.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```
    $ tanzu package available list controller.source.apps.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for controller.source.apps.tanzu.vmware.com...
      NAME                                     VERSION  RELEASED-AT
      controller.source.apps.tanzu.vmware.com  0.2.0    2021-09-16T00:00:00Z
    ```

1. (Optional) Make changes to the default installation settings by running:

    ```
    tanzu package available get controller.source.apps.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed in step 1 above.

    For example:

    ```
    $ tanzu package available get controller.source.apps.tanzu.vmware.com/0.2.0 --values-schema --namespace tap-install
    ```

    For more information about values schema options, see the individual product documentation.


1. Install the package. Run:

    ```
    tanzu package install source-controller -p controller.source.apps.tanzu.vmware.com -v 0.2.0 -n tap-install
    ```

    For example:
    ```
    tanzu package install source-controller -p controller.source.apps.tanzu.vmware.com -v 0.2.0 -n tap-install
    / Installing package 'controller.source.apps.tanzu.vmware.com'
    | Getting namespace 'tap-install'
    - Getting package metadata for 'controller.source.apps.tanzu.vmware.com'
    | Creating service account 'source-controller-tap-install-sa'
    | Creating cluster admin role 'source-controller-tap-install-cluster-role'
    | Creating cluster role binding 'source-controller-tap-install-cluster-rolebinding'
    \ Creating package resource
    | Package install status: Reconciling

     Added installed package 'source-controller' in namespace 'tap-install'
    ```

1. Verify the package install by running:

    ```
    tanzu package installed get source-controller -n tap-install
    ```

    For example:
    ```
    tanzu package installed get source-controller -n tap-install
    Retrieving installation details for sourcer-controller...
    NAME:                    sourcer-controller
    PACKAGE-NAME:            controller.source.apps.tanzu.vmware.com
    PACKAGE-VERSION:         0.2.0
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`

    ```
    kubectl get pods -n source-system
    ```

    For example:

    ```
    $ kubectl get pods -n source-system
    NAME                                        READY   STATUS    RESTARTS   AGE
    source-controller-manager-f68dc7bb6-4lrn6   1/1     Running   0          45h
    ```

    Verify that `STATUS` is `Running`

## <a id='install-app-acc'></a> Install Application Accelerator

When you install the Application Accelerator,
you can configure the following optional properties:

| Property | Default | Description |
| --- | --- | --- |
| registry.secret_ref | registry.tanzu.vmware.com | The secret used for accessing the registry where the App-Accelerator images are located |
| server.service_type | LoadBalancer | The service type for the acc-ui-server service including, LoadBalancer, NodePort, or ClusterIP |
| server.watched_namespace | accelerator-system | The namespace the server watches for accelerator resources |
| server.engine_invocation_url | http://acc-engine.accelerator-system.svc.cluster.local/invocations | The URL to use for invoking the accelerator engine |
| engine.service_type | ClusterIP | The service type for the acc-engine service including, LoadBalancer, NodePort, or ClusterIP |
| engine.max_direct_memory_size | 32M | The maximum size for the Java -XX:MaxDirectMemorySize setting |
| samples.include | True | Whether to include the bundled sample Accelerators in the installation |
| ingress.include | False | Whether to include the ingress configuration in the installation |
| domain | tap.example.com | Top level domain to use for ingress configuration |
| tls.secretName | tls | The name of the secret |
| tls.namespace | tanzu-system-ingress | The namespace for the secret |

VMware recommends that you do not override the defaults for `registry.secret_ref`,
`server.engine_invocation_url`, or `engine.service_type`.
These properties are only used to configure non-standard installations.

### <a id='app-acc-prereqs'></a> Prerequisites

Before you install Application Accelerator, you must have:

- Flux SourceController installed on the cluster.
See [Install cert-manager and FluxCD source controller](#install-prereqs).

-  Source Controller installed on the cluster.
See [Install Source Controller](#install-src-ctrl).

### <a id='app-acc-procedure'></a> Procedure

To install Application Accelerator:

1. List version information for the package by running:

    ```
    tanzu package available list accelerator.apps.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```
    $ tanzu package available list accelerator.apps.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for accelerator.apps.tanzu.vmware.com...
      NAME                               VERSION  RELEASED-AT
      accelerator.apps.tanzu.vmware.com  0.5.1    2021-12-02T00:00:00Z
    ```

1. (Optional) To make changes to the default installation settings, run:

    ```
    tanzu package available get accelerator.apps.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed in step 1 above.

    For example:

    ```
    $ tanzu package available get accelerator.apps.tanzu.vmware.com/0.5.1 --values-schema --namespace tap-install
    ```

    For more information about values schema options, see the individual product documentation.


1. Create an `app-accelerator-values.yaml` using the following example code:

    ```
    server:
      service_type: "LoadBalancer"
      watched_namespace: "accelerator-system"
    samples:
      include: true
    ```

    Edit the values if needed or leave the default values.

    >**Note:** For clusters that do not support the `LoadBalancer` service type, override the default
    >value for `server.service_type`.

1. Install the package by running:

    ```
    tanzu package install app-accelerator -p accelerator.apps.tanzu.vmware.com -v 1.0.0 -n tap-install -f app-accelerator-values.yaml
    ```

    For example:

    ```
    $ tanzu package install app-accelerator -p accelerator.apps.tanzu.vmware.com -v 1.0.0 -n tap-install -f app-accelerator-values.yaml
    - Installing package 'accelerator.apps.tanzu.vmware.com'
    | Getting package metadata for 'accelerator.apps.tanzu.vmware.com'
    | Creating service account 'app-accelerator-tap-install-sa'
    | Creating cluster admin role 'app-accelerator-tap-install-cluster-role'
    | Creating cluster role binding 'app-accelerator-tap-install-cluster-rolebinding'
    | Creating secret 'app-accelerator-tap-install-values'
    - Creating package resource
    - Package install status: Reconciling

     Added installed package 'app-accelerator' in namespace 'tap-install'
    ```

1. Verify the package install by running:

    ```
    tanzu package installed get app-accelerator -n tap-install
    ```

    For example:

    ```
    $ tanzu package installed get app-accelerator -n tap-install
    | Retrieving installation details for cc...
    NAME:                    app-accelerator
    PACKAGE-NAME:            accelerator.apps.tanzu.vmware.com
    PACKAGE-VERSION:         1.0.0
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`

1. To see the IP address for the Application Accelerator API when the `server.service_type` is set to `LoadBalancer`, run the following command:

    ```
    kubectl get service -n accelerator-system
    ```

    This lists an external IP address for use with the `--server-url` Tanzu CLI flag for the Accelerator plug-in `generate` command.

## <a id='install-tbs'></a> Install Tanzu Build Service

This section provides a quick-start guide for installing Tanzu Build Service as part of Tanzu Application Platform using the Tanzu CLI.

>**Note:** This procedure might not include some configurations required for your specific environment.
>For more advanced details on installing Tanzu Build Service, see
>[Installing Tanzu Build Service](https://docs.vmware.com/en/VMware-Tanzu-Build-Service/index.html).


### <a id='tbs-prereqs'></a> Prerequisites

* You have access to a Docker registry that Tanzu Build Service can use to create builder images.
Approximately 10&nbsp;GB of registry space is required when using the full descriptor.
* Your Docker registry is accessible with username and password credentials.


### <a id='tbs-tcli-install'></a> Install Tanzu Build Service using the Tanzu CLI

To install Tanzu Build Service using the Tanzu CLI:

1. List version information for the package by running:

    ```
    tanzu package available list buildservice.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```
    $ tanzu package available list buildservice.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for buildservice.tanzu.vmware.com...
      NAME                           VERSION  RELEASED-AT
      buildservice.tanzu.vmware.com  1.4.2    2021-12-17T00:00:00Z
    ```

1. (Optional) To make changes to the default installation settings, run:

    ```
    tanzu package available get buildservice.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed in step 1 above.

    For example:

    ```
    $ tanzu package available get buildservice.tanzu.vmware.com/1.4.2 --values-schema --namespace tap-install
    ```

    For more information about values schema options, see the individual product documentation.


1. Gather the values schema by running:

    ```
    tanzu package available get buildservice.tanzu.vmware.com/1.4.2 --values-schema --namespace tap-install
    ```

    For example:

    ```
    $ tanzu package available get buildservice.tanzu.vmware.com/1.4.2 --values-schema --namespace tap-install
    | Retrieving package details for buildservice.tanzu.vmware.com/1.4.2...
      KEY                                  DEFAULT  TYPE    DESCRIPTION
      kp_default_repository                <nil>    string  Docker repository used for builder images and dependencies
      kp_default_repository_password       <nil>    string  Username for kp_default_repository
      kp_default_repository_username       <nil>    string  Password for kp_default_repository
      tanzunet_username                    <nil>    string  Optional: Tanzunet registry username required for dependency import at install.
      tanzunet_password                    <nil>    string  Optional: Tanzunet registry password required for dependency import at install.
      descriptor_name                      <nil>    string  Name of descriptor to import (required for dependency updater feature)
      descriptor_version                   <nil>    string  Optional: Version of descriptor to use during install. This will override the version installed by default.
      enable_automatic_dependency_updates  <nil>    bool    Optional: Allow automatic import of new dependency updates from Tanzunet
      ca_cert_data                         <nil>    string  Optional: TBS registry ca certificate
      http_proxy                           <nil>    string  Optional: the HTTP proxy to use for network traffic.
      https_proxy                          <nil>    string  Optional: the HTTPS proxy to use for network traffic.
      no_proxy                             <nil>    string  Optional: A comma-separated list of hostnames, IP addresses, or IP ranges in CIDR format that should not use a proxy.
    ```

1. Create a `tbs-values.yaml` file.

    ```
    ---
    kp_default_repository: REPOSITORY
    kp_default_repository_username: REGISTRY-USERNAME
    kp_default_repository_password: REGISTRY-PASSWORD
    tanzunet_username: TANZUNET-USERNAME
    tanzunet_password: TANZUNET-PASSWORD
    descriptor_name: DESCRIPTOR-NAME
    enable_automatic_dependency_updates: true
    ```
    Where:

    - `REPOSITORY` is the fully qualified path to the TBS repository.
    This path must be writable. For example:

        * Docker Hub: `my-dockerhub-account/build-service`
        * Google Container Registry: `gcr.io/my-project/build-service`
        * Artifactory: `artifactory.com/my-project/build-service`
        * Harbor: `harbor.io/my-project/build-service`

    - `REGISTRY-USERNAME` and `REGISTRY-PASSWORD` are the user name and password for the registry. The install requires a `kp_default_repository_username` and `kp_default_repository_password` to write to the repository location.
    - `TANZUNET-USERNAME` and `TANZUNET-PASSWORD` are the email address and password that you use to log in to Tanzu Network. The Tanzu Network credentials allow for configuration of the Dependencies Updater. This resource accesses and installs the build dependencies (buildpacks and stacks) Tanzu Build Service needs on your cluster. It also keeps these dependencies up to date as new versions are released on Tanzu Network.
    - `DESCRIPTOR-NAME` is the name of the descriptor to import automatically. Current available options at time of release:
        - `tap-1.0.0-full` contains all dependencies and is for production use.
        - `tap-1.0.0-lite` smaller footprint used for speeding up installs. Requires Internet access on the cluster.

    >**Note:** Using the `tbs-values.yaml` configuration,
    >`enable_automatic_dependency_updates: false` can be used to pause the automatic update of
    >Build Service dependencies.

1. Install the package by running:

    ```
    tanzu package install tbs -p buildservice.tanzu.vmware.com -v 1.4.2 -n tap-install -f tbs-values.yaml --poll-timeout 30m
    ```

    For example:

    ```
    $ tanzu package install tbs -p buildservice.tanzu.vmware.com -v 1.4.2 -n tap-install -f tbs-values.yaml --poll-timeout 30m
    | Installing package 'buildservice.tanzu.vmware.com'
    | Getting namespace 'tap-install'
    | Getting package metadata for 'buildservice.tanzu.vmware.com'
    | Creating service account 'tbs-tap-install-sa'
    | Creating cluster admin role 'tbs-tap-install-cluster-role'
    | Creating cluster role binding 'tbs-tap-install-cluster-rolebinding'
    | Creating secret 'tbs-tap-install-values'
    - Creating package resource
    - Package install status: Reconciling

     Added installed package 'tbs' in namespace 'tap-install'
    ```

    >**Note:** Installing the `buildservice.tanzu.vmware.com` package with Tanzu Network credentials
    >automatically relocates buildpack dependencies to your cluster. This install process can take
    >some time and the `--poll-timeout` flag increases the timeout duration.
    >Using the `lite` descriptor speeds this up significantly.
    >If the command times out, periodically run the installation verification step provided in the
    >following optional step. Image relocation continues in the background.

1. (Optional) Verify the clusterbuilders created by the Tanzu Build Service install by running:

    ```
    tanzu package installed get tbs -n tap-install
    ```

## <a id='install-scc'></a> Install Supply Chain Choreographer

Supply Chain Choreographer provides the custom resource definitions that the supply chain uses.
Each pre-approved supply chain creates a paved road to production and orchestrates supply chain resources. You can test, build, scan, and deploy. Developers can focus on delivering value to
users. App Operators can have peace of mind that all code in production has passed
through an approved workflow.

For example, Supply Chain Choreographer passes the results of fetching source code to the component
that knows how to build a container image from of it and then passes the container image
to a component that knows how to deploy the image.

1. Install v0.1.0 of the `cartographer.tanzu.vmware.com` package, naming the installation `cartographer`.

    ```
    tanzu package install cartographer \
      --namespace tap-install \
      --package-name cartographer.tanzu.vmware.com \
      --version 0.1.0
    ```

    Example output:

    ```
    | Installing package 'cartographer.tanzu.vmware.com'
    | Getting namespace 'tap-install'
    | Getting package metadata for 'cartographer.tanzu.vmware.com'
    | Creating service account 'cartographer-tap-install-sa'
    | Creating cluster admin role 'cartographer-tap-install-cluster-role'
    | Creating cluster role binding 'cartographer-tap-install-cluster-rolebinding'
    - Creating package resource
    \ Package install status: Reconciling

    Added installed package 'cartographer' in namespace 'tap-install'
    ```


## <a id='install-ootb-del-basic'></a> Install Out of the Box Delivery Basic

The Out of the Box Delivery Basic package is used by all the Out of the Box Supply Chains
to deliver the objects that have been produced by them to a Kubernetes environment.


### <a id='ootb-del-basic-prereqs'></a> Prerequisites

- Cartographer


### <a id='inst-ootb-del-basic-proc'></a> Install

To install Out of the Box Delivery Basic:

1. Familiarize yourself with the set of values of the package that can be
   configured by running:

    ```
    tanzu package available get ootb-delivery-basic.tanzu.vmware.com/0.5.1 \
      --values-schema \
      -n tap-install
    ```

    For example:

    ```
    KEY                  DEFAULT  TYPE    DESCRIPTION
    service_account      default  string  Name of the service account in the
                                          namespace where the Deliverable is
                                          submitted to.
    ```

1. Create a file named `ootb-delivery-basic-values.yaml` that specifies the
   corresponding values to the properties you want to change.

   For example, the contents of the file might look like this:

    ```
    service_account: default
    ```

1. With the configuration ready, install the package by running:


    ```
    tanzu package install ootb-delivery-basic \
      --package-name ootb-delivery-basic.tanzu.vmware.com \
      --version 0.5.1 \
      --namespace tap-install \
      --values-file ootb-delivery-basic-values.yaml
    ```

    Example output:

    ```
    \ Installing package 'ootb-delivery-basic.tanzu.vmware.com'
    | Getting package metadata for 'ootb-delivery-basic.tanzu.vmware.com'
    | Creating service account 'ootb-delivery-basic-tap-install-sa'
    | Creating cluster admin role 'ootb-delivery-basic-tap-install-cluster-role'
    | Creating cluster role binding 'ootb-delivery-basic-tap-install-cluster-rolebinding'
    | Creating secret 'ootb-delivery-basic-tap-install-values'
    | Creating package resource
    - Waiting for 'PackageInstall' reconciliation for 'ootb-delivery-basic'
    / 'PackageInstall' resource install status: Reconciling

     Added installed package 'ootb-delivery-basic' in namespace 'tap-install'
    ```

## <a id='install-ootb-templates'></a> Install Out of the Box templates

The Out of the Box Templates package is used by all the Out of the Box Supply
Chains to provide the templates that are used by the Supply Chains to create
the objects that drive source code all the way to a deployed application in a
cluster.


### <a id='ootb-template-prereqs'></a> Prerequisites

- Tekton
- Cartographer


### <a id='inst-ootb-templ-proc'></a> Install

As this package has no extra configurations to be provided, all it takes to
install it is the following command:

```
tanzu package install ootb-templates \
  --package-name ootb-templates.tanzu.vmware.com \
  --version 0.5.1 \
  --namespace tap-install
```
```
\ Installing package 'ootb-templates.tanzu.vmware.com'
| Getting package metadata for 'ootb-templates.tanzu.vmware.com'
| Creating service account 'ootb-templates-tap-install-sa'
| Creating cluster admin role 'ootb-templates-tap-install-cluster-role'
| Creating cluster role binding 'ootb-templates-tap-install-cluster-rolebinding'
| Creating package resource
/ Waiting for 'PackageInstall' reconciliation for 'ootb-templates'
/ 'PackageInstall' resource install status: Reconciling


 Added installed package 'ootb-templates' in namespace 'tap-install'
```


## <a id='install-ootb-sc-basic'></a> Install Out of The Box Supply Chain Basic

The Out of the Box Supply Chain Basic package provides the most basic
ClusterSupplyChain that brings an application from source code to a deployed
instance of it running in a Kubernetes environment.


### <a id='ootb-sc-basic-prereqs'></a> Prerequisite

Cartographer


### <a id='inst-ootb-sc-basic-proc'></a> Install

1. Familiarize yourself with the set of values of the package that can be
   configured by running:

    ```
    tanzu package available get ootb-supply-chain-basic.tanzu.vmware.com/0.5.1 \
      --values-schema \
      -n tap-install
    ```

    For example:

    ```
    KEY                       DESCRIPTION

    registry.repository       Name of the repository in the image registry server where
                              the application images from he workloould be pushed to
                              (required).

    registry.server           Name of the registry server where application images should
                              be pushed to (required).



    gitops.username           Default user name to be used for the commits produced by the
                              supply chain.

    gitops.branch             Default branch to use for pushing Kubernetes configuration files
                              produced by the supply chain.

    gitops.commit_message     Default git commit message to write when publishing Kubernetes
                              configuration files produces by the supply chain to git.

    gitops.email              Default user email to be used for the commits produced by the
                              supply chain.

    gitops.repository_prefix  Default prefix to be used for forming Git SSH URLs for pushing
                              Kubernetes configuration produced by the supply chain.

    gitops.ssh_secret         Name of the default Secret containing SSH credentials to lookup
                              in the developer namespace for the supply chain to fetch source
                              code from and push configuration to.



    cluster_builder           Name of the Tanzu Build Service (TBS) ClusterBuilder to
                              use by default on image objects managed by the supply chain.

    service_account           Name of the service account in the namespace where the Workload
                              is submitted to utilize for providing registry credentials to
                              Tanzu Build Service (TBS) Image objects as well as deploying the
                              application.
    ```

1. Create a file named `ootb-supply-chain-basic-values.yaml` that specifies the
   corresponding values to the properties you want to change. For example:

    ```
    registry:
      server: REGISTRY-SERVER
      repository: REGISTRY-REPOSITORY

    gitops:
      repository_prefix: git@github.com:vmware-tanzu/
      branch: main
      user_name: supplychain
      user_email: supplychain
      commit_message: supplychain@cluster.local
      ssh_secret: git-ssh

    cluster_builder: default
    service_account: default
    ```

1. With the configuration ready, install the package by running:

    ```
    tanzu package install ootb-supply-chain-basic \
      --package-name ootb-supply-chain-basic.tanzu.vmware.com \
      --version 0.5.1 \
      --namespace tap-install \
      --values-file ootb-supply-chain-basic-values.yaml
    ```

    Example output:

    ```
    \ Installing package 'ootb-supply-chain-basic.tanzu.vmware.com'
    | Getting package metadata for 'ootb-supply-chain-basic.tanzu.vmware.com'
    | Creating service account 'ootb-supply-chain-basic-tap-install-sa'
    | Creating cluster admin role 'ootb-supply-chain-basic-tap-install-cluster-role'
    | Creating cluster role binding 'ootb-supply-chain-basic-tap-install-cluster-rolebinding'
    | Creating secret 'ootb-supply-chain-basic-tap-install-values'
    | Creating package resource
    - Waiting for 'PackageInstall' reconciliation for 'ootb-supply-chain-basic'
    / 'PackageInstall' resource install status: Reconciling


     Added installed package 'ootb-supply-chain-basic' in namespace 'tap-install'
    ```

## <a id='inst-ootb-sc-testing'></a> Install Out of The Box Supply Chain with Testing

The Out of the Box Supply Chain with Testing package provides a
ClusterSupplyChain that brings an application from source code to a deployed
instance of it running in a Kubernetes environment running developer-provided
tests in the form of Tekton/Pipeline objects to validate the source code before
building container images.


### <a id='ootb-sc-test-prereqs'></a> Prerequisites

You must have installed:

- Cartographer
- Out of The Box Delivery Basic (`ootb-delivery-basic.tanzu.vmware.com`)
- Out of The Box Templates (`ootb-templates.tanzu.vmware.com`)


### <a id='inst-ootb-sc-test-proc'></a> Install

Install by following these steps:

1. Ensure you do not have Out of The Box Supply Chain With Testing and Scanning
(`ootb-supply-chain-testing-scanning.tanzu.vmware.com`) installed:

    1. Run the following command:

        ```
        tanzu package installed list --namespace tap-install
        ```

    1. Verify `ootb-supply-chain-testing-scanning` is in the output:

        ```
        NAME                                PACKAGE-NAME
        ootb-delivery-basic                 ootb-delivery-basic.tanzu.vmware.com
        ootb-supply-chain-basic             ootb-supply-chain-basic.tanzu.vmware.com
        ootb-templates                      ootb-templates.tanzu.vmware.com
        ```

    1. If you see `ootb-supply-chain-testing-scanning` in the list, uninstall it by running:

        ```
        tanzu package installed delete ootb-supply-chain-testing-scanning --namespace tap-install
        ```

        Example output:

        ```
        Deleting installed package 'ootb-supply-chain-testing-scanning' in namespace 'tap-install'.
        Are you sure? [y/N]: y

        | Uninstalling package 'ootb-supply-chain-testing-scanning' from namespace 'tap-install'
        \ Getting package install for 'ootb-supply-chain-testing-scanning'
        - Deleting package install 'ootb-supply-chain-testing-scanning' from namespace 'tap-install'
        | Deleting admin role 'ootb-supply-chain-testing-scanning-tap-install-cluster-role'
        | Deleting role binding 'ootb-supply-chain-testing-scanning-tap-install-cluster-rolebinding'
        | Deleting secret 'ootb-supply-chain-testing-scanning-tap-install-values'
        | Deleting service account 'ootb-supply-chain-testing-scanning-tap-install-sa'

         Uninstalled package 'ootb-supply-chain-testing-scanning' from namespace 'tap-install'
        ```

1. Check the values of the package that can be configured by running:

    ```
    KEY                       DESCRIPTION

    registry.repository       Name of the repository in the image registry server where
                              the application images from he workloould be pushed to
                              (required).

    registry.server           Name of the registry server where application images should
                              be pushed to (required).



    gitops.username           Default user name to be used for the commits produced by the
                              supply chain.

    gitops.branch             Default branch to use for pushing Kubernetes configuration files
                              produced by the supply chain.

    gitops.commit_message     Default git commit message to write when publishing Kubernetes
                              configuration files produces by the supply chain to git.

    gitops.email              Default user email to be used for the commits produced by the
                              supply chain.

    gitops.repository_prefix  Default prefix to be used for forming Git SSH URLs for pushing
                              Kubernetes configuration produced by the supply chain.

    gitops.ssh_secret         Name of the default Secret containing SSH credentials to lookup
                              in the developer namespace for the supply chain to fetch source
                              code from and push configuration to.



    cluster_builder           Name of the Tanzu Build Service (TBS) ClusterBuilder to
                              use by default on image objects managed by the supply chain.

    service_account           Name of the service account in the namespace where the Workload
                              is submitted to utilize for providing registry credentials to
                              Tanzu Build Service (TBS) Image objects as well as deploying the
                              application.
    ```

1. Create a file named `ootb-supply-chain-testing-values.yaml` that specifies the
   corresponding values to the properties you want to change. For example:

    ```
    registry:
      server: REGISTRY-SERVER
      repository: REGISTRY-REPOSITORY

    gitops:
      repository_prefix: git@github.com:vmware-tanzu/
      branch: main
      user_name: supplychain
      user_email: supplychain
      commit_message: supplychain@cluster.local
      ssh_secret: git-ssh

    cluster_builder: default
    service_account: default
    ```

    >**Note:** it's **required** that the `gitops.repository_prefix` field ends
    > with a `/`.


1. With the configuration ready, install the package by running:

    ```
    tanzu package install ootb-supply-chain-testing \
      --package-name ootb-supply-chain-testing.tanzu.vmware.com \
      --version 0.5.1 \
      --namespace tap-install \
      --values-file ootb-supply-chain-testing-values.yaml
    ```

    Example output:

    ```
    \ Installing package 'ootb-supply-chain-testing.tanzu.vmware.com'
    | Getting package metadata for 'ootb-supply-chain-testing.tanzu.vmware.com'
    | Creating service account 'ootb-supply-chain-testing-tap-install-sa'
    | Creating cluster admin role 'ootb-supply-chain-testing-tap-install-cluster-role'
    | Creating cluster role binding 'ootb-supply-chain-testing-tap-install-cluster-rolebinding'
    | Creating secret 'ootb-supply-chain-testing-tap-install-values'
    | Creating package resource
    - Waiting for 'PackageInstall' reconciliation for 'ootb-supply-chain-testing'
    \ 'PackageInstall' resource install status: Reconciling

    Added installed package 'ootb-supply-chain-testing' in namespace 'tap-install'
    ```


## <a id='inst-ootb-sc-test-scan'></a> Install Out of The Box Supply Chain with Testing and Scanning

The Out of the Box Supply Chain with Testing and Scanning package provides a
ClusterSupplyChain that brings an application from source code to a deployed
instance of it running in a Kubernetes environment performing validations not
only in terms of running application tests, but also scanning the source code
and image for vulnerabilities.


### <a id='ootb-sc-test-scan-prereqs'></a> Prerequisites

- Cartographer
- Out of The Box Delivery Basic (`ootb-delivery-basic.tanzu.vmware.com`)
- Out of The Box Templates (`ootb-templates.tanzu.vmware.com`)


### <a id='ins-ootb-sc-test-scan-pro'></a> Install

1. Ensure you do not have Out of The Box Supply Chain With Testing
(`ootb-supply-chain-testing.tanzu.vmware.com`) installed:

    1. Run the following command:

        ```
        tanzu package installed list --namespace tap-install
        ```

    1. Verify `ootb-supply-chain-testing` is in the output:

        ```
        NAME                                PACKAGE-NAME
        ootb-delivery-basic                 ootb-delivery-basic.tanzu.vmware.com
        ootb-supply-chain-basic             ootb-supply-chain-basic.tanzu.vmware.com
        ootb-templates                      ootb-templates.tanzu.vmware.com
        ```

    1. If you see `ootb-supply-chain-testing` in the list, uninstall it by running:

        ```
        tanzu package installed delete ootb-supply-chain-testing --namespace tap-install
        ```

        Example output:

        ```
        Deleting installed package 'ootb-supply-chain-testing' in namespace 'tap-install'.
        Are you sure? [y/N]: y

        | Uninstalling package 'ootb-supply-chain-testing' from namespace 'tap-install'
        \ Getting package install for 'ootb-supply-chain-testing'
        - Deleting package install 'ootb-supply-chain-testing' from namespace 'tap-install'
        | Deleting admin role 'ootb-supply-chain-testing-tap-install-cluster-role'
        | Deleting role binding 'ootb-supply-chain-testing-tap-install-cluster-rolebinding'
        | Deleting secret 'ootb-supply-chain-testing-tap-install-values'
        | Deleting service account 'ootb-supply-chain-testing-tap-install-sa'

         Uninstalled package 'ootb-supply-chain-testing' from namespace 'tap-install'
        ```

1. Check the values of the package that can be configured by running:

    ```
    tanzu package available get ootb-supply-chain-testing-scanning.tanzu.vmware.com/0.5.1 \
      --values-schema \
      -n tap-install
    ```

    For example:

    ```
    KEY                       DESCRIPTION

    registry.repository       Name of the repository in the image registry server where
                              the application images from he workloould be pushed to
                              (required).

    registry.server           Name of the registry server where application images should
                              be pushed to (required).


    gitops.username           Default user name to be used for the commits produced by the
                              supply chain.

    gitops.branch             Default branch to use for pushing Kubernetes configuration files
                              produced by the supply chain.

    gitops.commit_message     Default git commit message to write when publishing Kubernetes
                              configuration files produces by the supply chain to git.

    gitops.email              Default user email to be used for the commits produced by the
                              supply chain.

    gitops.repository_prefix  Default prefix to be used for forming Git SSH URLs for pushing
                              Kubernetes configuration produced by the supply chain.

    gitops.ssh_secret         Name of the default Secret containing SSH credentials to lookup
                              for the supply chain to push configuration to.


    cluster_builder           Name of the Tanzu Build Service (TBS) ClusterBuilder to
                              use by default on image objects managed by the supply chain.

    service_account           Name of the service account in the namespace where the Workload
                              is submitted to utilize for providing registry credentials to
                              Tanzu Build Service (TBS) Image objects as well as deploying the
                              application.

    cluster_builder           Name of the Tanzu Build Service (TBS) ClusterBuilder to use by
                              default on image objects managed by the supply chain.
    ```

1. Create a file named `ootb-supply-chain-testing-scanning-values.yaml` that specifies
   the corresponding values to the properties you want to change. For example:

    ```
    registry:
      server: REGISTRY-SERVER
      repository: REGISTRY-REPOSITORY

    gitops:
      repository_prefix: git@github.com:vmware-tanzu/
      branch: main
      user_name: supplychain
      user_email: supplychain
      commit_message: supplychain@cluster.local
      ssh_secret: git-ssh

    cluster_builder: default
    service_account: default
    ```

    >**Note:** The `gitops.repository_prefix` field must end with `/`.

1. With the configuration ready, install the package by running:


    ```
    tanzu package install ootb-supply-chain-testing-scanning \
      --package-name ootb-supply-chain-testing-scanning.tanzu.vmware.com \
      --version 0.5.1 \
      --namespace tap-install \
      --values-file ootb-supply-chain-testing-scanning-values.yaml
    ```

    Example output:

    ```
    \ Installing package 'ootb-supply-chain-testing-scanning.tanzu.vmware.com'
    | Getting package metadata for 'ootb-supply-chain-testing-scanning.tanzu.vmware.com'
    | Creating service account 'ootb-supply-chain-testing-scanning-tap-install-sa'
    | Creating cluster admin role 'ootb-supply-chain-testing-scanning-tap-install-cluster-role'
    | Creating cluster role binding 'ootb-supply-chain-testing-scanning-tap-install-cluster-rolebinding'
    | Creating secret 'ootb-supply-chain-testing-scanning-tap-install-values'
    | Creating package resource
    - Waiting for 'PackageInstall' reconciliation for 'ootb-supply-chain-testing-scanning'
    \ 'PackageInstall' resource install status: Reconciling

    Added installed package 'ootb-supply-chain-testing-scanning' in namespace 'tap-install'
    ```


## <a id='inst-dev-convs'></a> Install Developer Conventions

To install Developer Conventions:

1. Ensure Convention Service is installed on the cluster. For more information, see the earlier
[Install Convention Service](#install-con-serv) section.

1. Get the exact name and version information for the Developer Conventions package to be installed
by running:

    ```
    tanzu package available list developer-conventions.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```
    $ tanzu package available list developer-conventions.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for developer-conventions.tanzu.vmware.com
      NAME                                    VERSION        RELEASED-AT
      developer-conventions.tanzu.vmware.com  0.3.0          2021-10-19T00:00:00Z
    ```

1. Install the package by running:

    ```
    tanzu package install developer-conventions \
      --package-name developer-conventions.tanzu.vmware.com \
      --version 0.3.0 \
      --namespace tap-install
    ```

1. Verify the package install by running:

    ```
    tanzu package installed get developer-conventions --namespace tap-install
    ```

    For example:

    ```
    tanzu package installed get developer-conventions -n tap-install
    | Retrieving installation details for developer-conventions...
    NAME:                    developer-conventions
    PACKAGE-NAME:            developer-conventions.tanzu.vmware.com
    PACKAGE-VERSION:         0.3.0
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`


## <a id='install-spring-boot-conv'></a> Install Spring Boot Conventions

To install Spring Boot conventions:

1. Ensure Convention Service is installed on the cluster. For more information, see the earlier
[Install Convention Service](#install-prereqs) section.

1. Get the exact name and version information for the Spring Boot conventions package to be installed by running:

    ```
    tanzu package available list spring-boot-conventions.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```
    $ tanzu package available list spring-boot-conventions.tanzu.vmware.com --namespace tap-install
    / Retrieving package versions for spring-boot-conventions.tanzu.vmware.com...
      NAME                                       VERSION   RELEASED-AT
      ...
      spring-boot-conventions.tanzu.vmware.com   0.1.2     2021-10-28T00:00:00Z
      ...
    ```

1. Install the package by running:

    ```
    tanzu package install spring-boot-conventions \
      --package-name spring-boot-conventions.tanzu.vmware.com \
      --version 0.1.2 \
      --namespace tap-install
    ```

1. Verify the package install by running:

    ```
    tanzu package installed get spring-boot-conventions --namespace tap-install
    ```

    For example:

    ```
    tanzu package installed get spring-boot-conventions -n tap-install
    | Retrieving installation details for spring-boot-conventions...
    NAME:                    spring-boot-conventions
    PACKAGE-NAME:            spring-boot-conventions.tanzu.vmware.com
    PACKAGE-VERSION:         0.1.2
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`


## <a id="install-app-live-view"></a>Install Application Live View

Application Live View installs two packages for `full` and `dev` profiles.

Application Live View Package (`run.appliveview.tanzu.vmware.com`) contains Application Live View
back-end and connector components.

Application Live View Conventions Package (`build.appliveview.tanzu.vmware.com`) contains
Application Live View Convention Service only.

1. List version information for both packages by running:

    ```
    tanzu package available list run.appliveview.tanzu.vmware.com --namespace tap-install
    tanzu package available list build.appliveview.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```
    $ tanzu package available list run.appliveview.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for run.appliveview.tanzu.vmware.com...
      NAME                              VERSION        RELEASED-AT
      run.appliveview.tanzu.vmware.com  1.0.1          2021-12-17T00:00:00Z

    $ tanzu package available list build.appliveview.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for build.appliveview.tanzu.vmware.com...
      NAME                                VERSION        RELEASED-AT
      build.appliveview.tanzu.vmware.com  1.0.1          2021-12-17T00:00:00Z
    ```

1. Create `app-live-view-values.yaml` with the following details:

    ```
    ---
    ```
    >**Note:** The `app-live-view-values.yaml` section does not have any values schema for both
    >packages, therefore it is empty.

    The Application Live View back-end and connector are deployed in `app-live-view` namespace by default. The connector is deployed as a `DaemonSet`. There is one connector instance per node in the Kubernetes cluster. This instance observes all the apps running on that node.
    The Application Live View Convention Server is deployed in the `alv-convention` namespace by default. The convention server enhances PodIntents with metadata including labels, annotations, or application properties.

1. Install the Application Live View package by running:

    ```
    tanzu package install appliveview -p run.appliveview.tanzu.vmware.com -v 1.0.1 -n tap-install -f app-live-view-values.yaml
    ```

    For example:

    ```
    $ tanzu package install appliveview -p run.appliveview.tanzu.vmware.com -v 1.0.1 -n tap-install -f app-live-view-values.yaml
    - Installing package 'run.appliveview.tanzu.vmware.com'
    | Getting package metadata for 'run.appliveview.tanzu.vmware.com'
    | Creating service account 'app-live-view-tap-install-sa'
    | Creating cluster admin role 'app-live-view-tap-install-cluster-role'
    | Creating cluster role binding 'app-live-view-tap-install-cluster-role binding'
    | Creating secret 'app-live-view-tap-install-values'
    - Creating package resource
    - Package install status: Reconciling

     Added installed package 'appliveview' in namespace 'tap-install'
    ```

1. Install the Application Live View conventions package by running:

    ```
    tanzu package install appliveview-conventions -p build.appliveview.tanzu.vmware.com -v 1.0.1 -n tap-install -f app-live-view-values.yaml
    ```

    For example:

    ```
    $ tanzu package install appliveview-conventions -p build.appliveview.tanzu.vmware.com -v 1.0.1 -n tap-install -f app-live-view-values.yaml
    - Installing package 'build.appliveview.tanzu.vmware.com'
    | Getting package metadata for 'build.appliveview.tanzu.vmware.com'
    | Creating service account 'app-live-view-tap-install-sa'
    | Creating cluster admin role 'app-live-view-tap-install-cluster-role'
    | Creating cluster role binding 'app-live-view-tap-install-cluster-role binding'
    | Creating secret 'app-live-view-tap-install-values'
    - Creating package resource
    - Package install status: Reconciling

     Added installed package 'appliveview-conventions' in namespace 'tap-install'
    ```

    For more information about Application Live View,
    see the [Application Live View documentation](https://docs.vmware.com/en/Application-Live-View-for-VMware-Tanzu/1.0/docs/GUID-index.html).

1. Verify the `Application Live View` package installation by running:

    ```
    tanzu package installed get appliveview -n tap-install
    ```

    For example:

    ```
    tanzu package installed get appliveview -n tap-install
    | Retrieving installation details for cc...
    NAME:                    appliveview
    PACKAGE-NAME:            run.appliveview.tanzu.vmware.com
    PACKAGE-VERSION:         1.0.1
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`

1. Verify the package install for `Application Live View Conventions` package by running:

    ```
    tanzu package installed get appliveview-conventions -n tap-install
    ```

    For example:

    ```
    tanzu package installed get appliveview-conventions -n tap-install
    | Retrieving installation details for cc...
    NAME:                    appliveview-conventions
    PACKAGE-NAME:            build.appliveview.tanzu.vmware.com
    PACKAGE-VERSION:         1.0.1
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`

The Application Live View UI plug-in is part of Tanzu Application Platform GUI.
To access the Application Live View UI,
see [Application Live View in Tanzu Application Platform GUI](tap-gui/plugins/app-live-view.html).


## <a id='install-tap-gui'></a> Install Tanzu Application Platform GUI

To install Tanzu Application Platform GUI, see the following sections.

### <a id='tap-gui-prereqs'></a> Prerequisites

- Git repository for Tanzu Application Platform GUI's software catalogs, with a token allowing read access.
  Supported Git infrastructure includes:
    - GitHub
    - GitLab
    - Azure DevOps
- Tanzu Application Platform GUI Blank Catalog from the Tanzu Application section of Tanzu Network
  - To install Tanzu Application Platform GUI catalog, navigate to [Tanzu Network](https://network.tanzu.vmware.com/) and select the Tanzu Application Platform. Under the list of available files to download, there is a folder titled `tap-gui-catalogs`. Inside that folder is a compressed archive titled `Tanzu Application Platform GUI Blank Catalog`. You must extract that catalog to the preceding Git repository of choice. This serves as the configuration location for your Organization's Catalog inside Tanzu Application Platform GUI.
- The Tanzu Application Platform GUI catalog allows for two approaches towards storing catalog information:
    - The default option uses an in-memory database and is suitable for test and development scenarios.
          The in-memory database reads the catalog data from Git URLs that you enter in the `tap-values.yml` file.
          This data is temporary, and any operations that cause the `server` Pod in the `tap-gui` namespace to be re-created
          also cause this data to be rebuilt from the Git location.
          This can cause issues when you manually register entities by using the UI because
          they only exist in the database and are lost when that in-memory database gets rebuilt.
    - For production use-cases, use a PostgreSQL database that exists outside the
          Tanzu Application Platform packaging.
          The PostgreSQL database stores all the catalog data persistently both from the Git locations
          and the UI manual entity registrations. For more information, see
          [Configuring the Tanzu Application Platform GUI database](tap-gui/database.md)

### <a id='tap-gui-install-proc'></a> Procedure

To install Tanzu Application Platform GUI:

1. List version information for the package by running:

    ```
    tanzu package available list tap-gui.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```
    $ tanzu package available list tap-gui.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for tap-gui.tanzu.vmware.com...
      NAME                      VERSION     RELEASED-AT
      tap-gui.tanzu.vmware.com  1.0.1  2022-01-10T13:14:23Z
    ```

2. (Optional) To make changes to the default installation settings, run:

    ```
    tanzu package available get tap-gui.tanzu.vmware.com/1.0.1 --values-schema --namespace tap-install
    ```

    For more information about values schema options, see the individual product documentation.

1. Create `tap-gui-values.yaml` using the following example code, replacing all placeholders
with your relevant values. The meanings of some placeholders are explained in this example:

    ```
    service_type: ClusterIP
    ingressEnabled: "true"
    ingressDomain: "INGRESS-DOMAIN"
    app_config:
      app:
        baseUrl: http://tap-gui.INGRESS-DOMAIN
      catalog:
        locations:
          - type: url
            target: https://GIT-CATALOG-URL/catalog-info.yaml
      backend:
        baseUrl: http://tap-gui.INGRESS-DOMAIN
        cors:
          origin: http://tap-gui.INGRESS-DOMAIN
      ```

    Where:

    - `INGRESS-DOMAIN` is the subdomain for the host name that you point at the `tanzu-shared-ingress`
service's External IP address.
   - `GIT-CATALOG-URL` is the path to the `catalog-info.yaml` catalog definition file from either the included Blank catalog (provided as an additional download named "Blank Tanzu Application Platform GUI Catalog") or a Backstage-compliant catalog that you've already built and posted on the Git infrastructure specified in the Integration section.

1. Install the package by running:

    ```
    tanzu package install tap-gui \
     --package-name tap-gui.tanzu.vmware.com \
     --version 1.0.1 -n tap-install \
     -f tap-gui-values.yaml
    ```

    For example:

    ```
    $ tanzu package install tap-gui -package-name tap-gui.tanzu.vmware.com --version 1.0.1 -n tap-install -f tap-gui-values.yaml
    - Installing package 'tap-gui.tanzu.vmware.com'
    | Getting package metadata for 'tap-gui.tanzu.vmware.com'
    | Creating service account 'tap-gui-default-sa'
    | Creating cluster admin role 'tap-gui-default-cluster-role'
    | Creating cluster role binding 'tap-gui-default-cluster-rolebinding'
    | Creating secret 'tap-gui-default-values'
    - Creating package resource
    - Package install status: Reconciling

     Added installed package 'tap-gui' in namespace 'tap-install'
    ```

1. Verify that the package installed by running:

    ```
    tanzu package installed get tap-gui -n tap-install
    ```

    For example:

    ```
    $ tanzu package installed get tap-gui -n tap-install
    | Retrieving installation details for cc...
    NAME:                    tap-gui
    PACKAGE-NAME:            tap-gui.tanzu.vmware.com
    PACKAGE-VERSION:         1.0.1
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`

1. To access Tanzu Application Platform GUI, use the service you exposed in the `service_type`
field in the values file.


## <a id='install-learning-center'></a> Install Learning Center for Tanzu Application Platform

To install Tanzu Learning Center, see the following sections.

For general information about Learning Center, see [Learning Center](learning-center/about.md).

### <a id='lc-prereqs'></a> Prerequisites

**Required**

- [Tanzu Application Platform Prerequisites](install-general.md#prereqs)

- The cluster must have an ingress router configured. If you have installed the TAP package (full or dev profile), it already deploys a contour ingress controller.

- The operator, when deploying instances of the workshop environments, needs to be able to expose them via an external URL for access. For the custom domain you are using, DNS must have been configured with a wildcard domain to forward all requests for sub-domains of the custom domain to the ingress router of the Kubernetes cluster

- By default, the workshop portal and workshop sessions are accessible over HTTP connections. If you wish to use secure HTTPS connections, you must have access to a wildcard SSL certificate for the domain under which you wish to host the workshops. You cannot use a self-signed certificate.

- Any ingress routes created use the default ingress class if you have multiple ingress class types available and you need to override which is used.

### <a id='install-lc-proc'></a> Procedure to Install Learning Center

To install Learning Center:

1. List version information for the package by running:

    ```
    tanzu package available list learningcenter.tanzu.vmware.com --namespace tap-install
    ```

    Example output:

    ```
     NAME                             VERSION        RELEASED-AT
     learningcenter.tanzu.vmware.com  0.1.0          2021-12-01 08:18:48 -0500 EDT
    ```

1. (Optional) See all the configurable parameters on this package by running:

    **Remember to change the 0.x.x version**
    ```
    tanzu package available get learningcenter.tanzu.vmware.com/0.x.x --values-schema --namespace tap-install
    ```

1. Create a config file named `learning-center-config.yaml`.

1. Add the parameter `ingressDomain` to `learning-center-config.yaml`, as in this example:

    ```
    ingressDomain: YOUR-INGRESS-DOMAIN
    ```

    Where `YOUR-INGRESS-DOMAIN` is the domain name for your Kubernetes cluster.

    When deploying workshop environment instances, the operator must be able to expose the instances
    through an external URL. This access is needed to discover the domain name that can be used as a
    suffix to hostnames for instances.

    For the custom domain you are using, DNS must have been configured with a wildcard domain to
    forward all requests for sub-domains of the custom domain to the ingress router of the
    Kubernetes cluster.

    If you are running Kubernetes on your local machine using a system such as `minikube` and you
    don't have a custom domain name that maps to the IP for the cluster, you can use a `nip.io`
    address.
    For example, if `minikube ip` returns `192.168.64.1`, you can use the `192.168.64.1.nip.io`
    domain.
    You cannot use an address of form `127.0.0.1.nip.io` or `subdomain.localhost`. This will cause a
    failure. Internal services needing to connect to each other will connect to themselves instead
    because the address would resolve to the host loopback address of `127.0.0.1`.

1. Add the `ingressSecret` to `learning-center-config.yaml`, as in this example:

    ```
    ingressSecret:
      certificate: |
        -----BEGIN CERTIFICATE-----
        MIIFLTCCBBWgAwIBAgaSAys/V2NCTG9uXa9aAiYt7WJ3MA0GCSqGaIb3DQEBCwUA
                                        ...
        dHa6Ly9yMy5vamxlbmNyLm9yZzAiBggrBgEFBQawAoYWaHR0cDoaL3IzLmkubGVu
        -----END CERTIFICATE-----
      privateKey: |
        -----BEGIN PRIVATE KEY-----
        MIIEvQIBADAaBgkqhkiG9waBAQEFAASCBKcwggSjAgEAAoIBAaCx4nyc2xwaVOzf
                                        ...
        IY/9SatMcJZivH3F1a7SXL98PawPIOSR7986P7rLFHzNjaQQ0DWTaXBRt+oUDxpN
        -----END PRIVATE KEY-----
    ```

    If you already have a TLS secret, follow these steps **before deploying any workshop**:
    - Create the `learningcenter` namespace manually or the one you defined
    - Copy the tls secret to the `learningcenter` namespace or the one you
    defined and use the `secretName` property as in this example:

    ```
    ingressSecret:
     secretName: workshops.example.com-tls
    ```

    By default, the workshop portal and workshop sessions are accessible over HTTP connections.

    To use secure HTTPS connections, you must have access to a wildcard SSL certificate for the
    domain under which you want to host the workshops. You cannot use a self-signed certificate.

    Wildcard certificates can be created using letsencrypt <https://letsencrypt.org/>_.
    After you have the certificate, you can define the `certificate` and `privateKey` properties
    under the `ingressSecret` property to specify the certificate on the configuration yaml.

1. Any ingress routes created use the default ingress class.
If you have multiple ingress class types available, and you need to override which is used, define
the `ingressClass` property in `learning-center-config.yaml` **before deploying any workshop**:

    ```
    ingressClass: contour
    ```

1. Install Learning Center Operator by running:

    **Remember to change the 0.x.x version**
    ```
    tanzu package install learning-center --package-name learningcenter.tanzu.vmware.com --version 0.x.x -f learning-center-config.yaml
    ```

    The command above will create a default namespace in your Kubernetes cluster called `learningcenter`,
    and the operator, along with any required namespaced resources, is created in it.
    A set of custom resource definitions and a global cluster role binding are also created.

    You can check that the operator deployed successfully by running:

    ```
    kubectl get all -n learningcenter
    ```

    The pod for the operator should be marked as running.

## <a id='install-portal-proc'></a> Procedure to install the Self-Guided Tour Training Portal and Workshop

To install the Self-Guided Tour Training Portal and Workshop:

1. Make sure you have the workshop package installed by running:

    ```
    tanzu package available list workshops.learningcenter.tanzu.vmware.com --namespace tap-install
    ```

1. Install the Learning Center Training Portal with the Self-Guided Tour Workshop by running:

    **Remember to change the 0.x.x version**
    ```
    tanzu package install learning-center-workshop --package-name workshops.learningcenter.tanzu.vmware.com --version 0.x.x -n tap-install
    ```

1. Check the Training Portals available in your environment by running:

    ```
    kubectl get trainingportals
    ```

    Example output:

    ```
    NAME                       URL                                           ADMINUSERNAME         ADMINPASSWORD                      STATUS
    learningcenter-tutorials   http://learningcenter-tutorials.example.com   learningcenter        QGBaM4CF01toPiZLW5NrXTcIYSpw2UJK   Running
    ```


## <a id='install-service-bindings'></a> Install Service Bindings

Use the following procedure to install Service Bindings:

1. List version information for the package by running:

    ```
    tanzu package available list service-bindings.labs.vmware.com --namespace tap-install
    ```

    For example:

    ```
    $ tanzu package available list service-bindings.labs.vmware.com --namespace tap-install
    - Retrieving package versions for service-bindings.labs.vmware.com...
      NAME                              VERSION  RELEASED-AT
      service-bindings.labs.vmware.com  0.5.0    2021-09-15T00:00:00Z
    ```

1. Install the package by running:

    ```
    tanzu package install service-bindings -p service-bindings.labs.vmware.com -v 0.5.0 -n tap-install
    ```

    Example output:

    ```
    / Installing package 'service-bindings.labs.vmware.com'
    | Getting namespace 'tap-install'
    - Getting package metadata for 'service-bindings.labs.vmware.com'
    | Creating service account 'service-bindings-tap-install-sa'
    | Creating cluster admin role 'service-bindings-tap-install-cluster-role'
    | Creating cluster role binding 'service-bindings-tap-install-cluster-rolebinding'
    \ Creating package resource
    | Package install status: Reconciling

     Added installed package 'service-bindings' in namespace 'tap-install'
    ```

1. Verify the package install by running:

    ```
    tanzu package installed get service-bindings -n tap-install
    ```

    Example output:

    ```
    - Retrieving installation details for service-bindings...
    NAME:                    service-bindings
    PACKAGE-NAME:            service-bindings.labs.vmware.com
    PACKAGE-VERSION:         0.5.0
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

1.  Run the following command:

    ```
    kubectl get pods -n service-bindings
    ```

    For example:

    ```
    $ kubectl get pods -n service-bindings
    NAME                       READY   STATUS    RESTARTS   AGE
    manager-6d85fffbcd-j4gvs   1/1     Running   0          22s
    ```

    Verify that `STATUS` is `Running`


## <a id='install-scst-store'></a> Install Supply Chain Security Tools - Store

**Prerequisites**

* `cert-manager` installed on the cluster. If you installed TAP profiles, as described in
[Installing part II: Profiles](install.md), then `cert-manager` is already installed. If not, then
follow the instructions in [Install cert-manager](#install-prereqs).

- Before installing, see [Deployment Details and Configuration](scst-store/deployment_details.md) to review what resources will be deployed. For more information, see the [overview](scst-store/overview.md).

To install Supply Chain Security Tools - Store:

1. The deployment assumes the user has set up the Kubernetes cluster to provision persistent volumes on demand. Make sure a default storage class is available in your cluster. Check whether default storage class is set in your cluster by running:

    ```
    kubectl get storageClass
    ```

    For example:

    ```
    $ kubectl get storageClass
    NAME                 PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
    standard (default)   rancher.io/local-path   Delete          WaitForFirstConsumer   false                  7s
    ```

1. List version information for the package by running:

    ```
    tanzu package available list metadata-store.apps.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```
    $ tanzu package available list metadata-store.apps.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for metadata-store.apps.tanzu.vmware.com...
      NAME                         VERSION       RELEASED-AT
      metadata-store.apps.tanzu.vmware.com  1.0.1
    ```

1. (Optional) List out all the available deployment configuration options:

    ```
    tanzu package available get metadata-store.apps.tanzu.vmware.com/1.0.1 --values-schema -n tap-install
    ```

    For example:

    ```
    $ tanzu package available get metadata-store.apps.tanzu.vmware.com/1.0.1 --values-schema -n tap-install
    | Retrieving package details for metadata-store.apps.tanzu.vmware.com/1.0.1...
      KEY                               DEFAULT              TYPE     DESCRIPTION
      app_service_type                  LoadBalancer         string   The type of service to use for the metadata app service. This can be set to 'NodePort' or 'LoadBalancer'.
      auth_proxy_host                   0.0.0.0              string   The binding ip address of the kube-rbac-proxy sidecar
      db_host                           metadata-store-db    string   The address to the postgres database host that the metdata-store app uses to connect. The default is set to metadata-store-db which is the postgres service name. Changing this does not change the postgres service name
      db_replicas                       1                    integer  The number of replicas for the metadata-store-db
      db_sslmode                        verify-full          string   Determines the security connection between API server and Postgres database. This can be set to 'verify-ca' or 'verify-full'
      pg_limit_memory                   4Gi                  string   Memory limit for postgres container in metadata-store-db deployment
      app_req_cpu                       100m                 string   CPU request for metadata-store-app container
      app_limit_memory                  512Mi                string   Memory limit for metadata-store-app container
      app_req_memory                    128Mi                string   Memory request for metadata-store-app container
      auth_proxy_port                   8443                 integer  The external port address of the of the kube-rbac-proxy sidecar
      db_name                           metadata-store       string   The name of the database to use.
      db_port                           5432                 string   The database port to use. This is the port to use when connecting to the database pod.
      api_port                          9443                 integer  The internal port for the metadata app api endpoint. This will be used by the kube-rbac-proxy sidecar.
      app_limit_cpu                     250m                 string   CPU limit for metadata-store-app container
      app_replicas                      1                    integer  The number of replicas for the metadata-store-app
      db_user                           metadata-store-user  string   The database user to create and use for updating and querying. The metadata postgres section create this user. The metadata api server uses this username to connect to the database.
      pg_req_memory                     1Gi                  string   Memory request for postgres container in metadata-store-db deployment
      priority_class_name                                    string   If specified, this value is the name of the desired PriorityClass for the metadata-store-db deployment
      use_cert_manager                  true                 string   Cert manager is required to be installed to use this flag. When true, this creates certificates object to be signed by cert manager for the API server and Postgres database. If false, the certificate object have to be provided by the user.
      api_host                          localhost            string   The internal hostname for the metadata api endpoint. This will be used by the kube-rbac-proxy sidecar.
      db_password                       <auto-generated>     string   The database user password. If not specified, the password will be auto-generated.
      storage_class_name                                     string   The storage class name of the persistent volume used by Postgres database for storing data. The default value will use the default class name defined on the cluster.
      database_request_storage          10Gi                 string   The storage requested of the persistent volume used by Postgres database for storing data.
      add_default_rw_service_account    true                 string   Adds a read-write service account which can be used to obtain access token to use metadata-store CLI
      log_level                         default              string   Sets the log level. This can be set to "minimum", "less", "default", "more", "debug" or "trace". "minimum" currently does not output logs. "less" outputs log configuration options only. "default" and "more" outputs API endpoint access information. "debug" and "trace" outputs extended API endpoint access information(such as body payload) and other debug information.
    ```

1. (Optional) Modify one of the deployment configurations by creating a configuration YAML with the
custom configuration values you want. For example, if your environment does not support `LoadBalancer`,
and you want to use `NodePort`, then create a `metadata-store-values.yaml` and configure the
`app_service_type` property.

    ```
    ---
    app_service_type: "NodePort"
    ```

    See [Deployment Details and Configuration](scst-store/deployment_details.md#configuration) for
    more detailed descriptions of configuration options.

1. Install the package by running:

    ```
    tanzu package install metadata-store \
      --package-name metadata-store.apps.tanzu.vmware.com \
      --version 1.0.1 \
      --namespace tap-install \
      --values-file metadata-store-values.yaml
    ```

    The flag `--values-file` is optional and used only if you want to customize the deployment
    configuration. For example:

    ```
    $ tanzu package install metadata-store \
      --package-name metadata-store.apps.tanzu.vmware.com \
      --version 1.0.1 \
      --namespace tap-install \
      --values-file metadata-store-values.yaml

    - Installing package 'metadata-store.apps.tanzu.vmware.com'
    / Getting namespace 'tap-install'
    - Getting package metadata for 'metadata-store.apps.tanzu.vmware.com'
    / Creating service account 'metadata-store-tap-install-sa'
    / Creating cluster admin role 'metadata-store-tap-install-cluster-role'
    / Creating cluster role binding 'metadata-store-tap-install-cluster-rolebinding'
    / Creating secret 'metadata-store-tap-install-values'
    | Creating package resource
    - Package install status: Reconciling

    Added installed package 'metadata-store' in namespace 'tap-install'
    ```


## <a id='install-scst-sign'></a> Install Supply Chain Security Tools - Sign

>**Caution:** This component rejects Pods if the webhook fails or is incorrectly configured.
>If the webhook is preventing the cluster from functioning,
>see [Supply Chain Security Tools - Sign Known Issues](release-notes.md)
> in the Tanzu Application Plantform release notes for recovery steps.

**Note:** v1alpha1 api version of the ClusterImagePolicy is no longer supported as the group name has been renamed from
`signing.run.tanzu.vmware.com` to `signing.apps.vmware.com`.

### <a id='scst-sign-prereqs'></a> Prerequisites

During configuration for this component, you are asked to provide a cosign public key to use to
validate signed images. An example cosign public key is provided that can validate an image from the
public cosign registry. If you want to provide your own key and images, follow the
[cosign quick start guide](https://github.com/sigstore/cosign#quick-start) in GitHub to
generate your own keys and sign an image.

### <a id='install-scst-sign-proc'></a> Procedure

To install Supply Chain Security Tools - Sign:

1. List version information for the package by running:

    ```
    tanzu package available list image-policy-webhook.signing.apps.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```
    $ tanzu package available list image-policy-webhook.signing.apps.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for image-policy-webhook.signing.apps.tanzu.vmware.com...
      NAME                                               VERSION         RELEASED-AT
      image-policy-webhook.signing.apps.tanzu.vmware.com  1.0.0          2021-12-21 09:00:00 -0500 EST
    ```

1. (Optional) Make changes to the default installation settings by running:

    ```
    tanzu package available get image-policy-webhook.signing.apps.tanzu.vmware.com/1.0.0 --values-schema --namespace tap-install
    ```

    For example:

    ```
    $ tanzu package available get image-policy-webhook.signing.apps.tanzu.vmware.com/1.0.0 --values-schema --namespace tap-install
    | Retrieving package details for image-policy-webhook.signing.apps.tanzu.vmware.com/1.0.0...
      KEY                     DEFAULT  TYPE     DESCRIPTION
      allow_unmatched_images  false    boolean  Feature flag for enabling admission of images that do not match
                                                any patterns in the image policy configuration.
                                                Set to true to allow images that do not match any patterns into
                                                the cluster with a warning.
      quota.pod_number        5        string   The maximum number of Image Policy Webhook Pods allowed to be
                                                created with the priority class system-cluster-critical. This
                                                value must be enclosed in quotes (""). If this value is not
                                                specified then the default value of 5 is used.
      replicas                1        integer  The number of replicas to be created for the Image Policy
                                                Webhook. This value must not be enclosed in quotes. If this
                                                value is not specified then the default value of 1 is used.
    ```

1. Create a file named `scst-sign-values.yaml` and add the settings you want to customize:

    - `allow_unmatched_images`:

        * **For non-production environments**: To warn the user when images
          do not match any pattern in the policy, but still allow them into
          the cluster, set `allow_unmatched_images` to `true`.

            ```
            ---
            allow_unmatched_images: true
            ```

        * **For production environments**: To deny images that match no patterns in the policy set `allow_unmatched_images` to `false`.

            ```
            ---
            allow_unmatched_images: false
            ```

            >**Note**: For a quicker installation process VMware recommends that
            >you set `allow_unmatched_images` to `true` initially.
            >This setting means that the webhook allows unsigned images to
            >run if the image does not match any pattern in the policy.
            >To promote to a production environment VMware recommends that you
            >re-install the webhook with `allow_unmatched_images` set to `false`.

    - `quota.pod_number`:
      This setting is the maximum number of pods that are allowed in the
      `image-policy-system` namespace with the `system-cluster-critical`
      priority class. This priority class is added to the pods to prevent
      preemption of this component's pods in case of node pressure.

      The default value for this property is 5. If your use case requires
      more than 5 pods be deployed of this component, adjust this value to
      allow the number of replicas you intend to deploy.

    - `replicas`:
      These settings controls the default amount of replicas that will get deployed by this
      component. The default value is 1.

        * **For production environments**: VMware recommends you increase the number of replicas to
          3 to ensure availability of the component for better admission performance.

1. Install the package:

    ```
    tanzu package install image-policy-webhook \
      --package-name image-policy-webhook.signing.apps.tanzu.vmware.com \
      --version 1.0.0 \
      --namespace tap-install \
      --values-file scst-sign-values.yaml
    ```

    For example:

    ```
    $ tanzu package install image-policy-webhook \
        --package-name image-policy-webhook.signing.apps.tanzu.vmware.com \
        --version 1.0.0 \
        --namespace tap-install \
        --values-file scst-sign-values.yaml

    | Installing package 'image-policy-webhook.signing.apps.tanzu.vmware.com'
    | Getting namespace 'default'
    | Getting package metadata for 'image-policy-webhook.signing.apps.tanzu.vmware.com'
    | Creating service account 'image-policy-webhook-default-sa'
    | Creating cluster admin role 'image-policy-webhook-default-cluster-role'
    | Creating cluster role binding 'image-policy-webhook-default-cluster-rolebinding'
    | Creating secret 'image-policy-webhook-default-values'
    / Creating package resource
    - Package install status: Reconciling

    Added installed package 'image-policy-webhook' in namespace 'tap-install'
    ```

   After you run the commands above your signing package will be running.

   >**Note:** This component requires extra configuration steps to work properly. See
   >[Configuring Supply Chain Security Tools - Sign](scst-sign/configuring.md)
   >for instructions on how to apply the required configuration.

## <a id='install-scst-scan'></a> Install Supply Chain Security Tools - Scan

**Prerequisite**: [Supply Chain Security Tools - Store](#install-scst-store) must be installed on the cluster for scan results to persist. Supply Chain Security Tools - Scan can be installed without Supply Chain Security Tools - Store already installed. In this case, skip creating a values file. Once Supply Chain Security Tools - Store is installed, the Supply Chain Security Tools - Scan values file must be updated.

The installation for Supply Chain Security Tools – Scan involves installing two packages:
Scan Controller and Grype Scanner.
The Scan Controller enables you to use a scanner. The Grype Scanner is a scanner. Ensure both the Grype Scanner and the Scan Controller are installed.

To install Supply Chain Security Tools - Scan (Scan Controller):

1. List version information for the package by running:

    ```
    tanzu package available list scanning.apps.tanzu.vmware.com --namespace tap-install
    ```

     For example:

    ```
    $ tanzu package available list scanning.apps.tanzu.vmware.com --namespace tap-install
    / Retrieving package versions for scanning.apps.tanzu.vmware.com...
      NAME                             VERSION       RELEASED-AT
      scanning.apps.tanzu.vmware.com   1.0.0
    ```

1. (Optional) Make changes to the default installation settings by running:

    ```
    tanzu package available get scanning.apps.tanzu.vmware.com/1.0.0 --values-schema -n tap-install
    ```

1. Gather the values schema.

1. Install the package with default configuration by running:

    ```
    tanzu package install scan-controller \
      --package-name scanning.apps.tanzu.vmware.com \
      --version 1.0.0 \
      --namespace tap-install
    ```

To install Supply Chain Security Tools - Scan (Grype Scanner):

1. List version information for the package by running:

    ```
    tanzu package available list grype.scanning.apps.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```
    $ tanzu package available list grype.scanning.apps.tanzu.vmware.com --namespace tap-install
    / Retrieving package versions for grype.scanning.apps.tanzu.vmware.com...
      NAME                                  VERSION       RELEASED-AT
      grype.scanning.apps.tanzu.vmware.com  1.0.0
    ```

1. (Optional) Make changes to the default installation settings by running:

    ```
    tanzu package available get grype.scanning.apps.tanzu.vmware.com/1.0.0 --values-schema -n tap-install
    ```

    For example:

    ```
    $ tanzu package available get grype.scanning.apps.tanzu.vmware.com/1.0.0 --values-schema -n tap-install
    | Retrieving package details for grype.scanning.apps.tanzu.vmware.com/1.0.0...
      KEY                        DEFAULT  TYPE    DESCRIPTION
      namespace                  default  string  Deployment namespace for the Scan Templates
      resources.limits.cpu       1000m    <nil>   Limits describes the maximum amount of cpu resources allowed.
      resources.requests.cpu     250m     <nil>   Requests describes the minimum amount of cpu resources required.
      resources.requests.memory  128Mi    <nil>   Requests describes the minimum amount of memory resources required.
      targetImagePullSecret      <EMPTY>  string  Reference to the secret used for pulling images from private registry.
      targetSourceSshSecret      <EMPTY>  string  Reference to the secret containing SSH credentials for cloning private repositories.
    ```

    The `tap-values.yml` file to change the default installation settings looks like this:

    ```
    grype:
      namespace: my-dev-namespace
      targetImagePullSecret: registry-credentials
    ```

    >**Note:** If you want to use a namespace other than the default namespace, then ensure that the
    >namespace exists before you install. If the namespace does not exist, then the Grype Scanner
    >installation fails.

1. The default values are appropriate for this package.
If you want to change from the default values, use the Scan Controller instructions as a guide.

1. Install the package by running:

    ```
    tanzu package install grype-scanner \
      --package-name grype.scanning.apps.tanzu.vmware.com \
      --version 1.0.0 \
      --namespace tap-install
    ```

    For example:

    ```
    $ tanzu package install grype-scanner \
      --package-name grype.scanning.apps.tanzu.vmware.com \
      --version 1.0.0 \
      --namespace tap-install
    / Installing package 'grype.scanning.apps.tanzu.vmware.com'
    | Getting namespace 'tap-install'
    | Getting package metadata for 'grype.scanning.apps.tanzu.vmware.com'
    | Creating service account 'grype-scanner-tap-install-sa'
    | Creating cluster admin role 'grype-scanner-tap-install-cluster-role'
    | Creating cluster role binding 'grype-scanner-tap-install-cluster-rolebinding'
    / Creating package resource
    - Package install status: Reconciling

     Added installed package 'grype-scanner' in namespace 'tap-install'
    ```

## <a id='install-api-portal'></a> Install API portal

To install API portal:

1. Check what versions of API portal are available to install by running:

    ```
    tanzu package available list -n tap-install api-portal.tanzu.vmware.com
    ```

    For example:

    ```
    $ tanzu package available list api-portal.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for api-portal.tanzu.vmware.com...
      NAME                         VERSION  RELEASED-AT
      api-portal.tanzu.vmware.com  1.0.3    2021-10-13T00:00:00Z
    ```

2. (Optional) Make changes to the default installation settings by running:

    ```
    tanzu package available get api-portal.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed in step 1.

    For example:

    ```
    $ tanzu package available get api-portal.tanzu.vmware.com/1.0.3 --values-schema --namespace tap-install
    ```

    For more information about values schema options, see the individual product documentation.

3. Install API portal by running:

    ```
    tanzu package install api-portal -n tap-install -p api-portal.tanzu.vmware.com -v 1.0.3
    ```

    For example:

    ```
    $ tanzu package install api-portal -n tap-install -p api-portal.tanzu.vmware.com -v 1.0.3

    / Installing package 'api-portal.tanzu.vmware.com'
    | Getting namespace 'api-portal'
    | Getting package metadata for 'api-portal.tanzu.vmware.com'
    | Creating service account 'api-portal-api-portal-sa'
    | Creating cluster admin role 'api-portal-api-portal-cluster-role'
    | Creating cluster role binding 'api-portal-api-portal-cluster-rolebinding'
    / Creating package resource
    - Package install status: Reconciling


    Added installed package 'api-portal' in namespace 'tap-install'
    ```

    For more information about API portal, see [API portal for VMware Tanzu](https://docs.pivotal.io/api-portal).


## <a id='install-services-toolkit'></a> Install Services Toolkit

To install Services Toolkit:

1. See what versions of Services Toolkit are available to install by running:

    ```
    tanzu package available list -n tap-install services-toolkit.tanzu.vmware.com
    ```

    For example:

    ```
    $ tanzu package available list -n tap-install services-toolkit.tanzu.vmware.com
    - Retrieving package versions for services-toolkit.tanzu.vmware.com...
      NAME                               VERSION           RELEASED-AT
      services-toolkit.tanzu.vmware.com  0.5.0             2021-10-18T09:45:46Z
    ```

1. Install Services Toolkit by running:

    ```
    tanzu package install services-toolkit -n tap-install -p services-toolkit.tanzu.vmware.com -v 0.5.0
    ```

1. Verify that the package installed by running:

    ```
    tanzu package installed get services-toolkit -n tap-install
    ```

    and checking that the `STATUS` value is `Reconcile succeeded`

    For example:

    ```
    $ tanzu package installed get services-toolkit -n tap-install
    | Retrieving installation details for services-toolkit...
    NAME:                    services-toolkit
    PACKAGE-NAME:            services-toolkit.tanzu.vmware.com
    PACKAGE-VERSION:         0.5.0
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```


## <a id='install-tekton'></a> Install Tekton

To install Tekton:

1. See what versions of Tekton are available to install by running:

    ```
    tanzu package available list -n tap-install tekton.tanzu.vmware.com
    ```

    For example:

    ```
    $ tanzu package available list -n tap-install tekton.tanzu.vmware.com
    \ Retrieving package versions for tekton.tanzu.vmware.com...
      NAME                     VERSION  RELEASED-AT
      tekton.tanzu.vmware.com  0.30.0   2021-11-18 17:05:37Z
    ```

1. Install Tekton by running:

    ```
    tanzu package install tekton -n tap-install -p tekton.tanzu.vmware.com -v 0.30.0
    ```

    For example:

    ```
    $ tanzu package install tekton -n tap-install -p tekton.tanzu.vmware.com -v 0.30.0
    - Installing package 'tekton.tanzu.vmware.com'
    \ Getting package metadata for 'tekton.tanzu.vmware.com'
    / Creating service account 'tekton-tap-install-sa'
    / Creating cluster admin role 'tekton-tap-install-cluster-role'
    / Creating cluster role binding 'tekton-tap-install-cluster-rolebinding'
    / Creating package resource
    - Waiting for 'PackageInstall' reconciliation for 'tekton'
    - 'PackageInstall' resource install status: Reconciling


     Added installed package 'tekton'
    ```

1. Verify that the package installed by running:

    ```
    tanzu package installed get tekton -n tap-install
    ```

    For example:

    ```
    $ tanzu package installed get tekton -n tap-install
    \ Retrieving installation details for tekton...
    NAME:                    tekton
    PACKAGE-NAME:            tekton.tanzu.vmware.com
    PACKAGE-VERSION:         0.30.0
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    STATUS should be `Reconcile succeeded`.

1. Configuring a namespace to use Tekton:

   > **Note:** This step covers configuring a namespace to run Tekton pipelines.
   If you rely on a SupplyChain to create Tekton PipelineRuns in your cluster,
   then skip this step because namespace configuration is covered in
   [Set up developer namespaces to use installed packages](#setup). Otherwise,
   you must complete the following steps for each namespace where you create
   Tekton Pipeline/Tasks.

   Service accounts that run Tekton workloads need access to the image pull
   secrets for the Tanzu package.  This includes the `default` service account
   in a namespace, which is created automatically but not associated with any
   image pull secrets.  Without these credentials, PipelineRuns fail with a
   timeout and the pods report that they cannot pull images.

   Create an image pull secret in the current namespace and fill it from
   [the `tap-registry` secret](install.md#add-package-repositories).  Run the following
   commands to create an empty secret and annotate it as a target of the
   secretgen controller:

   ```
   kubectl create secret generic pull-secret --from-literal=.dockerconfigjson={} --type=kubernetes.io/dockerconfigjson
   kubectl annotate secret pull-secret secretgen.carvel.dev/image-pull-secret=""
   ```

   After you create a `pull-secret` secret in the same namespace as the service account,
   run the following command to add the secret to the service account:

   ```
   kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "pull-secret"}]}'
   ```

    Verify that a service account is correctly configured by running:

   ```
   kubectl describe serviceaccount default
   ```

   For example:

   ```
   kubectl describe sa default
   Name:                default
   Namespace:           default
   Labels:              <none>
   Annotations:         <none>
   Image pull secrets:  pull-secret
   Mountable secrets:   default-token-xh6p4
   Tokens:              default-token-xh6p4
   Events:              <none>
   ```

   > **Note:** The service account has access to the `pull-secret` image pull secret.

For more details on Tekton, see the [Tekton documentation](https://tekton.dev/docs/) and the
[github repository](https://github.com/tektoncd/pipeline).

You can also view the Tekton [tutorial](https://github.com/tektoncd/pipeline/blob/main/docs/tutorial.md) and
[getting started guide](https://tekton.dev/docs/getting-started/).

> **Note:** Windows workloads have been disabled and will error if any Tasks tries to use Windows scripts.

## <a id='verify'></a> Verify the installed packages

Use the following procedure to verify that the packages are installed.

1. List the installed packages by running:

    ```
    tanzu package installed list --namespace tap-install
    ```

    For example:

    ```
    $ tanzu package installed list --namespace tap-install
    \ Retrieving installed packages...
    NAME                     PACKAGE-NAME                                       PACKAGE-VERSION  STATUS
    api-portal               api-portal.tanzu.vmware.com                        1.0.3            Reconcile succeeded
    app-accelerator          accelerator.apps.tanzu.vmware.com                  1.0.0            Reconcile succeeded
    app-live-view            appliveview.tanzu.vmware.com                       1.0.0-build.2    Reconcile succeeded
    cartographer             cartographer.tanzu.vmware.com                      0.1.0            Reconcile succeeded
    cloud-native-runtimes    cnrs.tanzu.vmware.com                              1.0.3            Reconcile succeeded
    convention-controller    controller.conventions.apps.tanzu.vmware.com       0.4.2            Reconcile succeeded
    developer-conventions    developer-conventions.tanzu.vmware.com             0.3.0-build.1    Reconcile succeeded
    grype-scanner            grype.scanning.apps.tanzu.vmware.com               1.0.0            Reconcile succeeded
    image-policy-webhook     image-policy-webhook.signing.apps.tanzu.vmware.com  1.0.0-beta.1     Reconcile succeeded
    metadata-store           metadata-store.apps.tanzu.vmware.com               1.0.1            Reconcile succeeded
    ootb-supply-chain-basic  ootb-supply-chain-basic.tanzu.vmware.com           0.5.1            Reconcile succeeded
    ootb-templates           ootb-templates.tanzu.vmware.com                    0.5.1            Reconcile succeeded
    scan-controller          scanning.apps.tanzu.vmware.com                     1.0.0            Reconcile succeeded
    service-bindings         service-bindings.labs.vmware.com                   0.5.0            Reconcile succeeded
    services-toolkit         services-toolkit.tanzu.vmware.com                  0.5.0            Reconcile succeeded
    source-controller        controller.source.apps.tanzu.vmware.com            0.2.0            Reconcile succeeded
    tap-gui                  tap-gui.tanzu.vmware.com                           0.3.0-rc.4       Reconcile succeeded
    tekton                   tekton.tanzu.vmware.com                            0.30.0           Reconcile succeeded
    tbs                      buildservice.tanzu.vmware.com                      1.4.2            Reconcile succeeded
    ```

## <a id='setup'></a> Set up developer namespaces to use installed packages

To create a `Workload` for your application using the registry credentials specified,
run these commands to add credentials and Role-Based Access Control (RBAC) rules to the namespace
that you plan to create the `Workload` in:

1. Add read/write registry credentials to the developer namespace by running:

    ```
    tanzu secret registry add registry-credentials --server REGISTRY-SERVER --username REGISTRY-USERNAME --password REGISTRY-PASSWORD --namespace YOUR-NAMESPACE
    ```

    Where:

    - `YOUR-NAMESPACE` is the name that you want to use for the developer namespace.
    For example, use `default` for the default namespace.
    - `REGISTRY-SERVER` is the URL of the registry. For Dockerhub, this must be
    `https://index.docker.io/v1/`. Specifically, it must have the leading `https://`, the `v1` path,
    and the trailing `/`. For GCR, this is `gcr.io`.
    Based on the information used in [Installing part II: Profiles](install.md), you can use the
    same registry server as in `ootb_supply_chain_basic` - `registry` - `server`.

    **Note:** If you observe the following issue with the above command:

    ```
    panic: runtime error: invalid memory address or nil pointer dereference
    [signal SIGSEGV: segmentation violation code=0x1 addr=0x128 pc=0x2bcce00]
    ```

    Use `kubectl` to create the secret:

    ```
    kubectl create secret docker-registry registry-credentials --docker-server=REGISTRY-SERVER --docker-username=REGISTRY-USERNAME --docker-password=REGISTRY-PASSWORD -n YOUR-NAMESPACE
    ```

2. Add placeholder read secrets, a service account, and RBAC rules to the developer namespace by running:

    ```
    cat <<EOF | kubectl -n YOUR-NAMESPACE apply -f -

    apiVersion: v1
    kind: Secret
    metadata:
      name: tap-registry
      annotations:
        secretgen.carvel.dev/image-pull-secret: ""
    type: kubernetes.io/dockerconfigjson
    data:
      .dockerconfigjson: e30K

    ---
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: default
    secrets:
      - name: registry-credentials
    imagePullSecrets:
      - name: registry-credentials
      - name: tap-registry

    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: Role
    metadata:
      name: default
    rules:
    - apiGroups: [source.toolkit.fluxcd.io]
      resources: [gitrepositories]
      verbs: ['*']
    - apiGroups: [source.apps.tanzu.vmware.com]
      resources: [imagerepositories]
      verbs: ['*']
    - apiGroups: [carto.run]
      resources: [deliverables, runnables]
      verbs: ['*']
    - apiGroups: [kpack.io]
      resources: [images]
      verbs: ['*']
    - apiGroups: [conventions.apps.tanzu.vmware.com]
      resources: [podintents]
      verbs: ['*']
    - apiGroups: [""]
      resources: ['configmaps']
      verbs: ['*']
    - apiGroups: [""]
      resources: ['pods']
      verbs: ['list']
    - apiGroups: [tekton.dev]
      resources: [taskruns, pipelineruns]
      verbs: ['*']
    - apiGroups: [tekton.dev]
      resources: [pipelines]
      verbs: ['list']
    - apiGroups: [kappctrl.k14s.io]
      resources: [apps]
      verbs: ['*']
    - apiGroups: [serving.knative.dev]
      resources: ['services']
      verbs: ['*']
    - apiGroups: [servicebinding.io]
      resources: ['servicebindings']
      verbs: ['*']
    - apiGroups: [services.apps.tanzu.vmware.com]
      resources: ['resourceclaims']
      verbs: ['*']
    - apiGroups: [scanning.apps.tanzu.vmware.com]
      resources: ['imagescans', 'sourcescans']
      verbs: ['*']

    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      name: default
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: Role
      name: default
    subjects:
      - kind: ServiceAccount
        name: default

    EOF
    ```

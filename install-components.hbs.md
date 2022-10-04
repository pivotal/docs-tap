# Installing individual packages

You can install Tanzu Application Platform through predefined profiles or through individual packages. This page provides links to install instructions for each of the individual packages. For more information about installing through profiles, see [Installing the Tanzu Application Platform Package and Profiles](install.md#about-package-profiles).

Installing individual Tanzu Application Platform packages
is useful if you do not want to use a profile to install packages
or if you want to install additional packages after installing a profile.
Before installing the packages, be sure to complete the prerequisites, configure
and verify the cluster, accept the EULA, and install the Tanzu CLI with any required plug-ins.
For more information, see [Prerequisites](prerequisites.md).


## <a id='individual-package-toc'></a> Install pages for individual Tanzu Application Platform packages

- [Install API portal](api-portal/install-api-portal.md)
- [Install Application Accelerator](application-accelerator/install-app-acc.md)
- [Install Application Live View](tap-gui/plugins/install-application-live-view.md)
- [Install cert-manager, Contour, and FluxCD](cert-mgr-contour-fcd/install-cert-mgr.md)
- [Install Cloud Native Runtimes](cloud-native-runtimes/install-cnrt.md)
- [Install Convention Service](convention-service/install-conv-service.md)
- [Install default roles for Tanzu Application Platform](authn-authz/install.md)
- [Install Developer Conventions](developer-conventions/install-dev-conventions.md)
- [Install Learning Center for Tanzu Application Platform](learning-center/install-learning-center.md)
- [Install Out of the Box Templates](scc/install-ootb-templates.md)
- [Install Out of the Box Supply Chain with Testing](scc/install-ootb-sc-wtest.md)
- [Install Out of the Box Supply Chain with Testing and Scanning](scc/install-ootb-sc-wtest-scan.md)
- [Install Service Bindings](service-bindings/install-service-bindings.md)
- [Install Services Toolkit](services-toolkit/install-services-toolkit.md)
- [Install Source Controller](source-controller/install-source-controller.md)
- [Install Spring Boot Conventions](spring-boot-conventions/install-spring-boot-conventions.md)
- [Install Supply Chain Choreographer](scc/install-scc.md)
- [Install Supply Chain Security Tools - Store](scst-store/install-scst-store.md)
- [Install Supply Chain Security Tools - Sign](scst-sign/install-scst-sign.md)
- [Install Supply Chain Security Tools - Scan](scst-scan/install-scst-scan.md)
- [Install Tanzu Application Platform GUI](tap-gui/install-tap-gui.md)
- [Install Tanzu Build Service](tanzu-build-service/install-tbs.md)
- [Install Tekton](tekton/install-tekton.md)


## <a id='verify'></a> Verify the installed packages

Use the following procedure to verify that the packages are installed.

1. List the installed packages by running:

    ```console
    tanzu package installed list --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package installed list --namespace tap-install
    \ Retrieving installed packages...
    NAME                     PACKAGE-NAME                                       PACKAGE-VERSION  STATUS
    api-portal               api-portal.tanzu.vmware.com                        1.0.3            Reconcile succeeded
    app-accelerator          accelerator.apps.tanzu.vmware.com                  1.0.0            Reconcile succeeded
    app-live-view            appliveview.tanzu.vmware.com                       1.0.2            Reconcile succeeded
    appliveview-conventions  build.appliveview.tanzu.vmware.com                 1.0.2            Reconcile succeeded
    cartographer             cartographer.tanzu.vmware.com                      0.1.0            Reconcile succeeded
    cloud-native-runtimes    cnrs.tanzu.vmware.com                              1.0.3            Reconcile succeeded
    convention-controller    controller.conventions.apps.tanzu.vmware.com       0.4.2            Reconcile succeeded
    developer-conventions    developer-conventions.tanzu.vmware.com             0.3.0-build.1    Reconcile succeeded
    grype-scanner            grype.scanning.apps.tanzu.vmware.com               1.0.0            Reconcile succeeded
    image-policy-webhook     image-policy-webhook.signing.apps.tanzu.vmware.com 1.1.2            Reconcile succeeded
    metadata-store           metadata-store.apps.tanzu.vmware.com               1.0.2            Reconcile succeeded
    ootb-supply-chain-basic  ootb-supply-chain-basic.tanzu.vmware.com           0.5.1            Reconcile succeeded
    ootb-templates           ootb-templates.tanzu.vmware.com                    0.5.1            Reconcile succeeded
    scan-controller          scanning.apps.tanzu.vmware.com                     1.0.0            Reconcile succeeded
    service-bindings         service-bindings.labs.vmware.com                   0.5.0            Reconcile succeeded
    services-toolkit         services-toolkit.tanzu.vmware.com                  0.6.0            Reconcile succeeded
    source-controller        controller.source.apps.tanzu.vmware.com            0.2.0            Reconcile succeeded
    tap-gui                  tap-gui.tanzu.vmware.com                           0.3.0-rc.4       Reconcile succeeded
    tekton-pipelines         tekton.tanzu.vmware.com                            0.30.0           Reconcile succeeded
    tbs                      buildservice.tanzu.vmware.com                      1.5.0            Reconcile succeeded
    ```

## <a id='setup'></a> Set up developer namespaces to use installed packages

You can choose either one of the following two approaches to create a `Workload`
for your application by using the registry credentials specified,
add credentials and Role-Based Access Control (RBAC) rules to the namespace
that you plan to create the `Workload` in:

- [Enable single user access](#single-user-access).
- [Enable additional users access with Kubernetes RBAC](#additional-user-access).

## <a id='single-user-access'></a>Enable single user access

Follow these steps to enable your current user to submit jobs to the Supply Chain:

1. To add read/write registry credentials to the developer namespace, run:

    ```console
    tanzu secret registry add registry-credentials --server REGISTRY-SERVER --username REGISTRY-USERNAME --password REGISTRY-PASSWORD --namespace YOUR-NAMESPACE
    ```

    Where:

    - `YOUR-NAMESPACE` is the name you give to the developer namespace.
    For example, use `default` for the default namespace.
    - `REGISTRY-SERVER` is the URL of the registry. For Docker Hub, this must be
    `https://index.docker.io/v1/`. Specifically, it must have the leading `https://`, the `v1` path,
    and the trailing `/`. For Google Container Registry (GCR), this is `gcr.io`.
    Based on the information used in [Installing the Tanzu Application Platform Package and Profiles](install.hbs.md), you can use the
    same registry server as in `ootb_supply_chain_basic` - `registry` - `server`.
    - `REGISTRY-PASSWORD` is the password of the registry.
    For GCR or Google Artifact Registry, this must be the concatenated version of the JSON key. For example: `"$(cat ~/gcp-key.json)"`.

    If you observe the following issue with the above command:

    ```console
    panic: runtime error: invalid memory address or nil pointer dereference
    [signal SIGSEGV: segmentation violation code=0x1 addr=0x128 pc=0x2bcce00]
    ```

    Use `kubectl` to create the secret:

    ```console
    kubectl create secret docker-registry registry-credentials --docker-server=REGISTRY-SERVER --docker-username=REGISTRY-USERNAME --docker-password=REGISTRY-PASSWORD -n YOUR-NAMESPACE
    ```

    >**Note:** This step is not required if you install Tanzu Application Platform on AWS with EKS and use [IAM Roles for Kubernetes Service Accounts](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html) instead of secrets. You can specify the Role Amazon Resource Name (ARN) in the next step.

1. To add secrets, a service account to execute the supply chain, and RBAC rules to authorize the service account to the developer namespace, run:

    ```console
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
    kind: RoleBinding
    metadata:
      name: default-permit-deliverable
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: deliverable
    subjects:
      - kind: ServiceAccount
        name: default
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      name: default-permit-workload
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: workload
    subjects:
      - kind: ServiceAccount
        name: default
    EOF
    ```

    >**Note:** If you install Tanzu Application Platform on AWS with EKS and use [IAM Roles for Kubernetes Service Accounts](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html), you must annotate the ARN of the IAM Role and remove the `registry-credentials` secret. Your service account entry then looks like the following:

    ```
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: default
      annotations:
        eks.amazonaws.com/role-arn: <Role ARN>
    imagePullSecrets:
      - name: tap-registry
    ```

## <a id='additional-user-access'></a>Enable additional users access with Kubernetes RBAC

Follow these steps to enable additional users by using Kubernetes RBAC to submit jobs to the Supply Chain:

1. [Enable single user access](#single-user-access).

1. Choose either of the following options to give developers namespace-level access and view access to appropriate cluster-level resources:

    - **Option 1:** Use the [Tanzu Application Platform RBAC CLI plug-in (beta)](authn-authz/binding.hbs.md#install).

        To use the `tanzu rbac` plug-in to grant `app-viewer` and `app-editor` roles to an identity provider group, run:

        ```console
        tanzu rbac binding add -g GROUP-FOR-APP-VIEWER -n YOUR-NAMESPACE -r app-viewer
        tanzu rbac binding add -g GROUP-FOR-APP-EDITOR -n YOUR-NAMESPACE -r app-editor
        ```

        Where:

        - `YOUR-NAMESPACE` is the name you give to the developer namespace.
        - `GROUP-FOR-APP-VIEWER` is the user group from the upstream identity provider that requires access to `app-viewer` resources on the current namespace and cluster.
        - `GROUP-FOR-APP-EDITOR` is the user group from the upstream identity provider that requires access to `app-editor` resources on the current namespace and cluster.

        For more information about `tanzu rbac`, see
        [Bind a user or group to a default role](authn-authz/binding.html).

        VMware recommends creating a user group in your identity provider's grouping system for each
        developer namespace and then adding the users accordingly.

        Depending on your identity provider, you might need to take further action to
        federate user groups appropriately with your cluster.
        For an example of how to set up Azure Active Directory (AD) with your cluster, see
        [Integrating Azure Active Directory](authn-authz/azure-ad.html).

    - **Option 2:** Use the native Kubernetes YAML.

        To apply the RBAC policy, run:

        ```console
        cat <<EOF | kubectl -n YOUR-NAMESPACE apply -f -
        apiVersion: rbac.authorization.k8s.io/v1
        kind: RoleBinding
        metadata:
          name: dev-permit-app-viewer
        roleRef:
          apiGroup: rbac.authorization.k8s.io
          kind: ClusterRole
          name: app-viewer
        subjects:
          - kind: Group
            name: GROUP-FOR-APP-VIEWER
            apiGroup: rbac.authorization.k8s.io
        ---
        apiVersion: rbac.authorization.k8s.io/v1
        kind: ClusterRoleBinding
        metadata:
          name: YOUR-NAMESPACE-permit-app-viewer
        roleRef:
          apiGroup: rbac.authorization.k8s.io
          kind: ClusterRole
          name: app-viewer-cluster-access
        subjects:
          - kind: Group
            name: GROUP-FOR-APP-VIEWER
            apiGroup: rbac.authorization.k8s.io
        ---
        apiVersion: rbac.authorization.k8s.io/v1
        kind: RoleBinding
        metadata:
          name: dev-permit-app-editor
        roleRef:
          apiGroup: rbac.authorization.k8s.io
          kind: ClusterRole
          name: app-editor
        subjects:
          - kind: Group
            name: GROUP-FOR-APP-EDITOR
            apiGroup: rbac.authorization.k8s.io
        ---
        apiVersion: rbac.authorization.k8s.io/v1
        kind: ClusterRoleBinding
        metadata:
          name: YOUR-NAMESPACE-permit-app-editor
        roleRef:
          apiGroup: rbac.authorization.k8s.io
          kind: ClusterRole
          name: app-editor-cluster-access
        subjects:
          - kind: Group
            name: GROUP-FOR-APP-EDITOR
            apiGroup: rbac.authorization.k8s.io
        EOF
        ```

        Where:

        - `YOUR-NAMESPACE` is the name you give to the developer namespace.
        - `GROUP-FOR-APP-VIEWER` is the user group from the upstream identity provider that requires access to `app-viewer` resources on the current namespace and cluster.
        - `GROUP-FOR-APP-EDITOR` is the user group from the upstream identity provider that requires access to `app-editor` resources on the current namespace and cluster.

        VMware recommends creating a user group in your identity provider's grouping system for each
        developer namespace and then adding the users accordingly.

        Depending on your identity provider, you might need to take further action to
        federate user groups appropriately with your cluster.
        For an example of how to set up Azure Active Directory (AD) with your cluster, see
        [Integrating Azure Active Directory](authn-authz/azure-ad.html).

        Rather than granting roles directly to individuals, VMware recommends using your identity provider's user groups system to grant access to a group of developers.
        For an example of how to set up Azure AD with your cluster, see
        [Integrating Azure Active Directory](authn-authz/azure-ad.html).

1. (Optional) Log in as a non-admin user, such as a developer, to see the effects of RBAC after the bindings are applied.

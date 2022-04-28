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

To create a `Workload` for your application using the registry credentials specified,
run these commands to add credentials and Role-Based Access Control (RBAC) rules to the namespace
that you plan to create the `Workload` in:

1. Add read/write registry credentials to the developer namespace by running:

    ```console
    tanzu secret registry add registry-credentials --server REGISTRY-SERVER --username REGISTRY-USERNAME --password REGISTRY-PASSWORD --namespace YOUR-NAMESPACE
    ```

    Where:

    - `YOUR-NAMESPACE` is the name that you want to use for the developer namespace.
    For example, use `default` for the default namespace.
    - `REGISTRY-SERVER` is the URL of the registry. For Dockerhub, this must be
    `https://index.docker.io/v1/`. Specifically, it must have the leading `https://`, the `v1` path,
    and the trailing `/`. For GCR, this is `gcr.io`.
    Based on the information used in [Installing the Tanzu Application Platform Package and Profiles](install.md), you can use the
    same registry server as in `ootb_supply_chain_basic` - `registry` - `server`.
    - `REGISTRY-PASSWORD` is the password of the registry. 
    For GCR or Google Artifact Registry, this must be the concatenated version of the JSON key. For example: `"$(cat ~/gcp-key.json)"`.

    **Note:** If you observe the following issue with the above command:

    ```console
    panic: runtime error: invalid memory address or nil pointer dereference
    [signal SIGSEGV: segmentation violation code=0x1 addr=0x128 pc=0x2bcce00]
    ```

    Use `kubectl` to create the secret:

    ```console
    kubectl create secret docker-registry registry-credentials --docker-server=REGISTRY-SERVER --docker-username=REGISTRY-USERNAME --docker-password=REGISTRY-PASSWORD -n YOUR-NAMESPACE
    ```

2. Add secrets, a service account to execute the supply chain, and RBAC rules to authorize the service account to the developer namespace by running:

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

3. Give developers namespace-level access and view access to appropriate cluster-level resources by doing one of the following:
  * Use the `tanzu auth` plug-in to grant `app-viewer` or `app-editor` roles
  * Apply the following RBAC policy:

      ```console
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
          name: "namespace-developers"
          apiGroup: rbac.authorization.k8s.io
      --
      apiVersion: rbac.authorization.k8s.io/v1
      kind: ClusterRoleBinding
      metadata:
        name: namespace-dev-permit-app-viewer
      roleRef:
        apiGroup: rbac.authorization.k8s.io
        kind: ClusterRole
        name: app-viewer-cluster-access
      subjects:
        - kind: Group
          name: "namespace-developers"
          apiGroup: rbac.authorization.k8s.io
      EOF
      ```

      VMware recommends using your identity provider's groups system to grant access to a group of
      developers, rather than granting roles directly to individuals.
      For more information, see the
      [Kubernetes documentation](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#referring-to-subjects).

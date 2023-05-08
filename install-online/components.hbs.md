# Installing individual packages

You can install Tanzu Application Platform through predefined profiles or through individual packages. This page provides links to install instructions for each of the individual packages. For more information about installing through profiles, see [About Tanzu Application Platform components and profiles](../about-package-profiles.hbs.md).

Installing individual Tanzu Application Platform packages
is useful if you do not want to use a profile to install packages
or if you want to install additional packages after installing a profile.
Before installing the packages, be sure to complete the prerequisites, configure
and verify the cluster, accept the EULA, and install the Tanzu CLI with any required plug-ins.
For more information, see [Prerequisites](../prerequisites.hbs.md).


## <a id='individual-package-toc'></a> Install pages for individual Tanzu Application Platform packages

- [Install API portal](../api-portal/install-api-portal.hbs.md)
- [Install Application Accelerator](../application-accelerator/install-app-acc.hbs.md)
- [Install Application Live View](../app-live-view/install.hbs.md)
- [Install Application Single Sign-On](../app-sso/install-appsso.hbs.md)
- [Install cert-manager, Contour, and FluxCD](../cert-mgr-contour-fcd/install-cert-mgr.hbs.md)
- [Install Cloud Native Runtimes](../cloud-native-runtimes/install-cnrt.hbs.md)
- [Install default roles for Tanzu Application Platform](../authn-authz/install.hbs.md)  
- [Install Developer Conventions](../developer-conventions/install-dev-conventions.hbs.md)
- [Install Learning Center for Tanzu Application Platform](../learning-center/install-learning-center.hbs.md)
- [Install Out of the Box Templates](../scc/install-ootb-templates.hbs.md)
- [Install Out of the Box Supply Chain with Testing](../scc/install-ootb-sc-wtest.hbs.md)
- [Install Out of the Box Supply Chain with Testing and Scanning](../scc/install-ootb-sc-wtest-scan.hbs.md)
- [Install Service Bindings](../service-bindings/install-service-bindings.hbs.md)
- [Install Services Toolkit](../services-toolkit/install-services-toolkit.hbs.md)
- [Install Source Controller](../source-controller/install-source-controller.hbs.md)
- [Install Spring Boot Conventions](../spring-boot-conventions/install-spring-boot-conventions.hbs.md)
- [Install Supply Chain Choreographer](../scc/install-scc.hbs.md)
- [Install Supply Chain Security Tools - Store](../scst-store/install-scst-store.hbs.md)
- [Install Supply Chain Security Tools - Policy Controller](../scst-policy/install-scst-policy.hbs.md)
- [Install Supply Chain Security Tools - Scan](../scst-scan/install-scst-scan.hbs.md)
- [Install Tanzu Application Platform GUI](../tap-gui/install-tap-gui.hbs.md)
- [Install Tanzu Build Service](../tanzu-build-service/install-tbs.hbs.md)
- [Install Tekton](../tekton/install-tekton.hbs.md)


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
    convention-controller    controller.conventions.apps.tanzu.vmware.com       0.7.0            Reconcile succeeded
    developer-conventions    developer-conventions.tanzu.vmware.com             0.3.0-build.1    Reconcile succeeded
    grype-scanner            grype.scanning.apps.tanzu.vmware.com               1.0.0            Reconcile succeeded
    image-policy-webhook     image-policy-webhook.signing.apps.tanzu.vmware.com 1.1.2            Reconcile succeeded
    metadata-store           metadata-store.apps.tanzu.vmware.com               1.0.2            Reconcile succeeded
    ootb-supply-chain-basic  ootb-supply-chain-basic.tanzu.vmware.com           0.5.1            Reconcile succeeded
    ootb-templates           ootb-templates.tanzu.vmware.com                    0.5.1            Reconcile succeeded
    scan-controller          scanning.apps.tanzu.vmware.com                     1.0.0            Reconcile succeeded
    service-bindings         service-bindings.labs.vmware.com                   0.5.0            Reconcile succeeded
    services-toolkit         services-toolkit.tanzu.vmware.com                  0.7.1            Reconcile succeeded
    source-controller        controller.source.apps.tanzu.vmware.com            0.2.0            Reconcile succeeded
    sso4k8s-install          sso.apps.tanzu.vmware.com                          1.0.0-beta.2-31  Reconcile succeeded
    tap-gui                  tap-gui.tanzu.vmware.com                           0.3.0-rc.4       Reconcile succeeded
    tekton-pipelines         tekton.tanzu.vmware.com                            0.30.0           Reconcile succeeded
    tbs                      buildservice.tanzu.vmware.com                      1.5.0            Reconcile succeeded
    ```
    
## <a id='next-steps'></a>Next steps

- [Set up developer namespaces to use your installed packages](set-up-namespaces.hbs.md)

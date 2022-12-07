You can install Tanzu Application Platform through predefined profiles or through individual packages. This page provides links to install instructions for each of the individual packages. For more information about installing through profiles, see [About Tanzu Application Platform components and profiles](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/GUID-about-package-profiles.html).

Installing individual Tanzu Application Platform packages
is useful if you do not want to use a profile to install packages
or if you want to install additional packages after installing a profile.
Before installing the packages, be sure to complete the prerequisites, configure
and verify the cluster, accept the EULA, and install the Tanzu CLI with any required plug-ins.
For more information, see [Prerequisites](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/GUID-prerequisites.html).


## <a id='individual-package-toc'></a> Install pages for individual Tanzu Application Platform packages

- [Install API Auto Registration](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/GUID-api-auto-registration-installation.html)
- [Install API portal](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/GUID-api-portal-install-api-portal.html)
- [Install Application Accelerator](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/GUID-application-accelerator-install-app-acc.html)
- [Install Application Live View](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/GUID-app-live-view-install.html)
- [Install Application Single Sign-On](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/GUID-app-sso-platform-operators-installation.html)
- [Install cert-manager](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/GUID-cert-manager-install.html)
- [Install Cloud Native Runtimes](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/GUID-cloud-native-runtimes-install-cnrt.html)
- [Install Contour](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/GUID-contour-install.html)
- [Install default roles for Tanzu Application Platform](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/GUID-authn-authz-install.html)  
- [Install Developer Conventions](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/GUID-developer-conventions-install-dev-conventions.html)
- [Install Eventing](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/GUID-eventing-install-eventing.html)
- [Install FluxCD Source Controller](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/GUID-fluxcd-source-controller-install.html)
- [Install Learning Center for Tanzu Application Platform](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/GUID-learning-center-install-learning-center.html)
- [Install Out of the Box Templates](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/GUID-scc-install-ootb-templates.html)
- [Install Out of the Box Supply Chain with Testing](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/GUID-scc-install-ootb-sc-wtest.html)
- [Install Out of the Box Supply Chain with Testing and Scanning](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/GUID-scc-install-ootb-sc-wtest-scan.html)
- [Install Service Bindings](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/GUID-service-bindings-install-service-bindings.html)
- [Install Services Toolkit](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/GUID-services-toolkit-install-services-toolkit.html)
- [Install Source Controller](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/GUID-source-controller-install-source-controller.html)
- [Install Spring Boot Conventions](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/GUID-spring-boot-conventions-install-spring-boot-conventions.html)
- [Install Supply Chain Choreographer](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/GUID-scc-install-scc.html)
- [Install Supply Chain Security Tools - Store](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/GUID-scst-store-install-scst-store.html)
- [Install Supply Chain Security Tools - Policy Controller](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/GUID-scst-policy-install-scst-policy.html)
- [Install Supply Chain Security Tools - Scan](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/GUID-scst-scan-install-scst-scan.html)
- [Install Tanzu Application Platform GUI](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/GUID-tap-gui-install-tap-gui.html)
- [Install Tanzu Build Service](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/GUID-tanzu-build-service-install-tbs.html)
- [Install Tekton](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/GUID-tekton-install-tekton.html)
- [Install Telemetry](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/GUID-telemetry-install-telemetry.html)


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
    services-toolkit         services-toolkit.tanzu.vmware.com                  0.8.0            Reconcile succeeded
    source-controller        controller.source.apps.tanzu.vmware.com            0.2.0            Reconcile succeeded
    sso4k8s-install          sso.apps.tanzu.vmware.com                          1.0.0-beta.2-31  Reconcile succeeded
    tap-gui                  tap-gui.tanzu.vmware.com                           0.3.0-rc.4       Reconcile succeeded
    tekton-pipelines         tekton.tanzu.vmware.com                            0.30.0           Reconcile succeeded
    tbs                      buildservice.tanzu.vmware.com                      1.5.0            Reconcile succeeded
    ```

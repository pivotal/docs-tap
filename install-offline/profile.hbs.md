# Install Tanzu Application Platform in your air-gapped environment

This topic tells you how to install Tanzu Application Platform (commonly known as TAP)
on your Kubernetes cluster and registry that are air-gapped from external traffic.

Before installing the packages, ensure that you have completed the following tasks:

- Review the [Prerequisites](../prerequisites.html) to ensure that you have set up everything required before beginning the installation.
- [Accept Tanzu Application Platform EULA and install Tanzu CLI](../install-tanzu-cli.html).
- [Deploy Cluster Essentials](https://{{ vars.staging_toggle }}.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/deploy.html). This step is optional if you are using VMware Tanzu Kubernetes Grid cluster.

## <a id='add-tap-package-repo'></a> Relocate images to a registry

To relocate images from the VMware Tanzu Network registry to your air-gapped registry:

1. Set up environment variables for installation use by running:

    ```console
    # Set tanzunet as the source registry to copy the Tanzu Application Platform packages from.
    export IMGPKG_REGISTRY_HOSTNAME_0=registry.tanzu.vmware.com
    export IMGPKG_REGISTRY_USERNAME_0=MY-TANZUNET-USERNAME
    export IMGPKG_REGISTRY_PASSWORD_0=MY-TANZUNET-PASSWORD

    # The user’s registry for copying the Tanzu Application Platform package to.
    export IMGPKG_REGISTRY_HOSTNAME_1=MY-REGISTRY
    export IMGPKG_REGISTRY_USERNAME_1=MY-REGISTRY-USER
    export IMGPKG_REGISTRY_PASSWORD_1=MY-REGISTRY-PASSWORD
    export TAP_VERSION=VERSION-NUMBER
    export REGISTRY_CA_PATH=PATH-TO-CA
    ```

    Where:

    - `MY-REGISTRY` is your air-gapped container registry.
    - `MY-REGISTRY-USER` is the user with write access to `MY-REGISTRY`.
    - `MY-REGISTRY-PASSWORD` is the password for `MY-REGISTRY-USER`.
    - `MY-TANZUNET-USERNAME` is the user with access to the images in the VMware Tanzu Network registry `registry.tanzu.vmware.com`
    - `MY-TANZUNET-PASSWORD` is the password for `MY-TANZUNET-USERNAME`.
    - `VERSION-NUMBER` is your Tanzu Application Platform version. For example, `{{ vars.tap_version }}`

1. Copy the images into a `.tar` file from the VMware Tanzu Network onto an external storage device with the Carvel tool imgpkg by running:

    ```console
    imgpkg copy \
      -b registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:$TAP_VERSION \
      --to-tar tap-packages-$TAP_VERSION.tar \
      --include-non-distributable-layers
    ```

1. Relocate the images with the Carvel tool imgpkg by running:

    ```console
    imgpkg copy \
      --tar tap-packages-$TAP_VERSION.tar \
      --to-repo $IMGPKG_REGISTRY_HOSTNAME_1/tap-packages \
      --include-non-distributable-layers \
      --registry-ca-cert-path $REGISTRY_CA_PATH
    ```

1. Create a namespace called `tap-install` for deploying any component packages by running:

    ```console
    kubectl create ns tap-install
    ```

    This namespace keeps the objects grouped together logically.

1. Create a registry secret by running:

    ```console
    tanzu secret registry add tap-registry \
        --server   $IMGPKG_REGISTRY_HOSTNAME_1 \
        --username $IMGPKG_REGISTRY_USERNAME_1 \
        --password $IMGPKG_REGISTRY_PASSWORD_1 \
        --namespace tap-install \
        --export-to-all-namespaces \
        --yes
    ```
1. Create a secret for accessing the user’s registry by running:

    ```console
    tanzu secret registry add registry-credentials \
        --server   $IMGPKG_REGISTRY_HOSTNAME_1 \
        --username $IMGPKG_REGISTRY_USERNAME_1 \
        --password $IMGPKG_REGISTRY_PASSWORD_1 \
        --namespace tap-install \
        --export-to-all-namespaces \
        --yes
    ```

1. Add the Tanzu Application Platform package repository to the cluster by running:

    ```console
    tanzu package repository add tanzu-tap-repository \
      --url $IMGPKG_REGISTRY_HOSTNAME_1/tap-packages:$TAP_VERSION \
      --namespace tap-install
    ```

    Where `$TAP_VERSION` is the Tanzu Application Platform version environment variable you defined earlier.

1. Get the status of the Tanzu Application Platform package repository, and ensure the status updates to `Reconcile succeeded` by running:

    ```console
    tanzu package repository get tanzu-tap-repository --namespace tap-install
    ```

    > **Note** The `VERSION` and `TAG` numbers differ from the earlier example if you are on
    > Tanzu Application Platform v1.0.2 or earlier.

1. List the available packages by running:

    ```console
    tanzu package available list --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list --namespace tap-install
    / Retrieving available packages...
      NAME                                                 DISPLAY-NAME                                                              SHORT-DESCRIPTION
      accelerator.apps.tanzu.vmware.com                    Application Accelerator for VMware Tanzu                                  Used to create new projects and configurations.
      api-portal.tanzu.vmware.com                          API portal                                                                A unified user interface for API discovery and exploration at scale.
      apis.apps.tanzu.vmware.com                           API Auto Registration for VMware Tanzu                                    A TAP component to automatically register API exposing workloads as API entities
                                                                                                                                     in TAP GUI.
      backend.appliveview.tanzu.vmware.com                 Application Live View for VMware Tanzu                                    App for monitoring and troubleshooting running apps
      buildservice.tanzu.vmware.com                        Tanzu Build Service                                                       Tanzu Build Service enables the building and automation of containerized
                                                                                                                                     software workflows securely and at scale.
      carbonblack.scanning.apps.tanzu.vmware.com           VMware Carbon Black for Supply Chain Security Tools - Scan                Default scan templates using VMware Carbon Black
      cartographer.tanzu.vmware.com                        Cartographer                                                              Kubernetes native Supply Chain Choreographer.
      cnrs.tanzu.vmware.com                                Cloud Native Runtimes                                                     Cloud Native Runtimes is a serverless runtime based on Knative
      connector.appliveview.tanzu.vmware.com               Application Live View Connector for VMware Tanzu                          App for discovering and registering running apps
      controller.conventions.apps.tanzu.vmware.com         Convention Service for VMware Tanzu                                       Convention Service enables app operators to consistently apply desired runtime
                                                                                                                                     configurations to fleets of workloads.
      controller.source.apps.tanzu.vmware.com              Tanzu Source Controller                                                   Tanzu Source Controller enables workload create/update from source code.
      conventions.appliveview.tanzu.vmware.com             Application Live View Conventions for VMware Tanzu                        Application Live View convention server
      developer-conventions.tanzu.vmware.com               Tanzu App Platform Developer Conventions                                  Developer Conventions
      eventing.tanzu.vmware.com                            Eventing                                                                  Eventing is an event-driven architecture platform based on Knative Eventing
      external-secrets.apps.tanzu.vmware.com               External Secrets Operator                                                 External Secrets Operator is a Kubernetes operator that integrates external
                                                                                                                                     secret management systems.
      fluxcd.source.controller.tanzu.vmware.com            Flux Source Controller                                                    The source-controller is a Kubernetes operator, specialised in artifacts
                                                                                                                                     acquisition from external sources such as Git, Helm repositories and S3 buckets.
      grype.scanning.apps.tanzu.vmware.com                 Grype for Supply Chain Security Tools - Scan                              Default scan templates using Anchore Grype
      learningcenter.tanzu.vmware.com                      Learning Center for Tanzu Application Platform                            Guided technical workshops
      metadata-store.apps.tanzu.vmware.com                 Supply Chain Security Tools - Store                                       Post SBoMs and query for image, package, and vulnerability metadata.
      namespace-provisioner.apps.tanzu.vmware.com          Namespace Provisioner                                                     Automatic Provisioning of Developer Namespaces.
      ootb-delivery-basic.tanzu.vmware.com                 Tanzu App Platform Out of The Box Delivery Basic                          Out of The Box Delivery Basic.
      ootb-supply-chain-basic.tanzu.vmware.com             Tanzu App Platform Out of The Box Supply Chain Basic                      Out of The Box Supply Chain Basic.
      ootb-supply-chain-testing-scanning.tanzu.vmware.com  Tanzu App Platform Out of The Box Supply Chain with Testing and Scanning  Out of The Box Supply Chain with Testing and Scanning.
      ootb-supply-chain-testing.tanzu.vmware.com           Tanzu App Platform Out of The Box Supply Chain with Testing               Out of The Box Supply Chain with Testing.
      ootb-templates.tanzu.vmware.com                      Tanzu App Platform Out of The Box Templates                               Out of The Box Templates.
      policy.apps.tanzu.vmware.com                         Supply Chain Security Tools - Policy Controller                           Policy Controller enables defining of a policy to restrict unsigned container
                                                                                                                                     images.
      scanning.apps.tanzu.vmware.com                       Supply Chain Security Tools - Scan                                        Scan for vulnerabilities and enforce policies directly within Kubernetes native
                                                                                                                                     Supply Chains.
      service-bindings.labs.vmware.com                     Service Bindings for Kubernetes                                           Service Bindings for Kubernetes implements the Service Binding Specification.
      services-toolkit.tanzu.vmware.com                    Services Toolkit                                                          The Services Toolkit enables the management, lifecycle, discoverability and
                                                                                                                                     connectivity of Service Resources (databases, message queues, DNS records,
                                                                                                                                     etc.).
      snyk.scanning.apps.tanzu.vmware.com                  Snyk for Supply Chain Security Tools - Scan                               Default scan templates using Snyk
      spring-boot-conventions.tanzu.vmware.com             Tanzu Spring Boot Conventions Server                                      Default Spring Boot convention server.
      sso.apps.tanzu.vmware.com                            AppSSO                                                                    Application Single Sign-On for Tanzu
      tap-auth.tanzu.vmware.com                            Default roles for Tanzu Application Platform                              Default roles for Tanzu Application Platform
      tap-gui.tanzu.vmware.com                             Tanzu Application Platform GUI                                            web app graphical user interface for Tanzu Application Platform
      tap-telemetry.tanzu.vmware.com                       Telemetry Collector for Tanzu Application Platform                        Tanzu Application Plaform Telemetry
      tap.tanzu.vmware.com                                 Tanzu Application Platform                                                Package to install a set of TAP components to get you started based on your use
                                                                                                                                     case.
      tekton.tanzu.vmware.com                              Tekton Pipelines                                                          Tekton Pipelines is a framework for creating CI/CD systems.
      workshops.learningcenter.tanzu.vmware.com            Workshop Building Tutorial                                                Workshop Building Tutorial
    ```

## <a id='air-gap-policy'></a> Prepare Sigstore Stack for air-gapped policy controller

>**Important** This section only applies if the target environment requires support for keyless authorities in `ClusterImagePolicy`. You must set the `policy.tuf_enabled` field to `true` when installing Tanzu Application Platform.
By default, keyless authorities support is deactivated.

By default, the public official Sigstore "The Update Framework (TUF) server" is used.
You can use an alternative Sigstore Stack by setting `policy.tuf_mirror` and `policy.tuf_root`.

The Sigstore Stack consists of:

- [Trillian](https://github.com/google/trillian)
- [Rekor](https://github.com/sigstore/rekor)
- [Fulcio](https://github.com/sigstore/fulcio)
- [Certificate Transparency Log (CTLog)](https://github.com/google/certificate-transparency-go)
- [The Update Framework (TUF)](https://theupdateframework.io/)

For an air-gapped environment, an internally accessible Sigstore Stack is required for keyless authorities.

## <a id='install-profile'></a> Install your Tanzu Application Platform profile

The `tap.tanzu.vmware.com` package installs predefined sets of packages based on your profile settings.
This is done by using the package manager installed by Tanzu Cluster Essentials.

For more information about profiles, see [Components and installation profiles](../about-package-profiles.md).

To prepare to install a profile:

1. List version information for the package by running:

    ```console
    tanzu package available list tap.tanzu.vmware.com --namespace tap-install
    ```

1. Create a `tap-values.yaml` file by using the
[Full Profile sample](#full-profile) as a guide.
These samples have the minimum configuration required to deploy Tanzu Application Platform.
The sample values file contains the necessary defaults for:

    - The meta-package, or parent Tanzu Application Platform package
    - Subordinate packages, or individual child packages

    Keep the values file for future configuration use.

### <a id='full-profile'></a> Full Profile

To install Tanzu Application Platform with Supply Chain Basic,
you must retrieve your cluster’s base64 encoded ca certificate from `$HOME/.kube/config`.
Retrieve the `certificate-authority-data` from the respective cluster section
and input it as `B64_ENCODED_CA` in the `tap-values.yaml`.

The following is the YAML file sample for the full-profile:

```yaml
shared:
  ingress_domain: "INGRESS-DOMAIN"
  image_registry:
    project_path: "SERVER-NAME/REPO-NAME"
    secret:
      name: "KP-DEFAULT-REPO-SECRET"
      namespace: "KP-DEFAULT-REPO-SECRET-NAMESPACE"
  ca_cert_data: |
    -----BEGIN CERTIFICATE-----
    MIIFXzCCA0egAwIBAgIJAJYm37SFocjlMA0GCSqGSIb3DQEBDQUAMEY...
    -----END CERTIFICATE-----
profile: full
ceip_policy_disclosed: true
buildservice:
  kp_default_repository: "KP-DEFAULT-REPO"
  kp_default_repository_secret: # Takes the value from the shared section by default, but can be overridden by setting a different value.
    name: "KP-DEFAULT-REPO-SECRET"
    namespace: "KP-DEFAULT-REPO-SECRET-NAMESPACE"
  exclude_dependencies: true
supply_chain: basic
scanning:
  metadataStore:
    url: ""
contour:
  infrastructure_provider: aws
  envoy:
    service:
      type: LoadBalancer
      annotations:
      # This annotation is for air-gapped AWS only.
          service.kubernetes.io/aws-load-balancer-internal: "true"

ootb_supply_chain_basic:
  registry:
      server: "SERVER-NAME" # Takes the value from the shared section by default, but can be overridden by setting a different value.
      repository: "REPO-NAME" # Takes the value from the shared section by default, but can be overridden by setting a different value.
  gitops:
      ssh_secret: "SSH-SECRET"
  maven:
      repository:
         url: https://MAVEN-URL
         secret_name: "MAVEN-CREDENTIALS"

accelerator:
  ingress:
    include: true
    enable_tls: false
  git_credentials:
    secret_name: git-credentials
    username: GITLAB-USER
    password: GITLAB-PASSWORD

appliveview:
  ingressEnabled: true

appliveview_connector:
  backend:
    ingressEnabled: true
    sslDeactivated: false
    host: appliveview.INGRESS-DOMAIN
    caCertData: |-
      -----BEGIN CERTIFICATE-----
      MIIGMzCCBBugAwIBAgIJALHHzQjxM6wMMA0GCSqGSIb3DQEBDQUAMGcxCzAJBgNV
      BAgMAk1OMRQwEgYDVQQHDAtNaW5uZWFwb2xpczEPMA0GA1UECgwGVk13YXJlMRMw
      -----END CERTIFICATE-----

tap_gui:
  app_config:
    auth:
      allowGuestAccess: true  # This allows unauthenticated users to log in to your portal. If you want to deactivate it, make sure you configure an alternative auth provider.
    kubernetes:
      serviceLocatorMethod:
        type: multiTenant
      clusterLocatorMethods:
        - type: config
          clusters:
            - url: https://${KUBERNETES_SERVICE_HOST}:${KUBERNETES_SERVICE_PORT}
              name: host
              authProvider: serviceAccount
              serviceAccountToken: ${KUBERNETES_SERVICE_ACCOUNT_TOKEN}
              skipTLSVerify: false
              caData: B64_ENCODED_CA
    catalog:
      locations:
        - type: url
          target: https://GIT-CATALOG-URL/catalog-info.yaml
    #Example Integration for custom GitLab:
    integrations:
      gitlab:
        - host: GITLAB-URL
          token: GITLAB-TOKEN
          apiBaseUrl: https://GITLABURL/api/v4/
    backend:
      reading:
        allow:
          - host: GITLAB-URL # Example URL: gitlab.example.com

metadata_store:
  ns_for_export_app_cert: "MY-DEV-NAMESPACE"
  app_service_type: ClusterIP # Defaults to LoadBalancer. If shared.ingress_domain is set earlier, this must be set to ClusterIP.
```

> **Important**
>
> - Tanzu Build Service is installed by default with `lite` depndencies.
> When installing Tanzu Build Service in an air-gapped environment, the lite dependencies are not available because > they require Internet access. You must install the `full` dependencies by setting `exclude_dependencies` to `true`. The existing ClusterStore instances will not be updated if you switch from `lite` dependencies to `full` dependencies after the initial installation completes.
>
> - Installing Grype by using `tap-values.yaml` as follows is
> deprecated in v1.6 and will be removed in v1.8:
>
>    ```yaml
>    grype:
>      namespace: "MY-DEV-NAMESPACE"
>      targetImagePullSecret: "TARGET-REGISTRY-CREDENTIALS-SECRET"
>    ```
>
>    You can install Grype by using Namespace Provisioner instead.

Where:

- `INGRESS-DOMAIN` is the subdomain for the host name that you point at the `tanzu-shared-ingress`
service's External IP address.
- `KP-DEFAULT-REPO` is a writable repository in your registry. Tanzu Build Service dependencies are written to this location. Examples:
    - Harbor has the form `kp_default_repository: "my-harbor.io/my-project/build-service"`.
    - Docker Hub has the form `kp_default_repository: "my-dockerhub-user/build-service"` or `kp_default_repository: "index.docker.io/my-user/build-service"`.
    - Google Cloud Registry has the form `kp_default_repository: "gcr.io/my-project/build-service"`.
- `KP-DEFAULT-REPO-SECRET` is the secret with user credentials that can write to `KP-DEFAULT-REPO`. You can `docker push` to this location with this credential.
    - For Google Cloud Registry, use `kp_default_repository_username: _json_key`.
    - You must create the secret before the installation. For example, you can use the `registry-credentials` secret created earlier.
- `KP-DEFAULT-REPO-SECRET-NAMESPACE` is the namespace where `KP-DEFAULT-REPO-SECRET` is created.
- `SERVER-NAME` is the host name of the registry server. Examples:
    - Harbor has the form `server: "my-harbor.io"`.
    - Docker Hub has the form `server: "index.docker.io"`.
    - Google Cloud Registry has the form `server: "gcr.io"`.
- `REPO-NAME` is where workload images are stored in the registry. If this key is passed through the shared section earlier and AWS ECR registry is used, you must ensure that the `SERVER-NAME/REPO-NAME/buildservice` and `SERVER-NAME/REPO-NAME/workloads` exist. AWS ECR expects the paths to be pre-created.
- Images are written to `SERVER-NAME/REPO-NAME/workload-name`. Examples:
   - Harbor has the form `repository: "my-project/supply-chain"`.
   - Docker Hub has the form `repository: "my-dockerhub-user"`.
   - Google Cloud Registry has the form `repository: "my-project/supply-chain"`.
- `SSH-SECRET` is the secret name for https authentication, certificate authority, and SSH authentication. See [Git authentication](../scc/git-auth.hbs.md) for more information.
- `MAVEN-CREDENTIALS` is the name of [the secret with maven creds](../scc/building-from-source.hbs.md#maven-repository-secret). This secret must be in the developer namespace. You can create it after the fact.
- `GIT-CATALOG-URL` is the path to the `catalog-info.yaml` catalog definition file. You can download either a blank or populated catalog file from the [Tanzu Application Platform product page](https://network.pivotal.io/products/tanzu-application-platform/#/releases/1239018). Otherwise, you can use a Backstage-compliant catalog you've already built and posted on the Git infrastructure.
- `GITLABURL` is the host name of your GitLab instance.
- `GITLAB-USER` is the user name of your GitLab instance.
- `GITLAB-PASSWORD` is the password for the `GITLAB-USER` of your GitLab instance. This can also be the `GITLAB-TOKEN`.
- `GITLAB-TOKEN` is the API token for your GitLab instance.
- `MY-DEV-NAMESPACE` is the name of the developer namespace. SCST - Store exports secrets to the namespace, and SCST - Scan deploys the `ScanTemplates` there. This allows the scanning feature to run in this namespace. If there are multiple developer namespaces, use `ns_for_export_app_cert: "*"` to export the SCST - Store CA certificate to all namespaces. To install Grype in multiple namespaces, use a namespace provisioner. See [Namespace Provisioner](../namespace-provisioner/about.hbs.md).
- `TARGET-REGISTRY-CREDENTIALS-SECRET` is the name of the secret that contains the
credentials to pull an image from the registry for scanning.

>**Note** The `appliveview_connector.backend.sslDisabled` key is deprecated and renamed to `appliveview_connector.backend.sslDeactivated`.

If you use custom CA certificates, you must provide one or more PEM-encoded CA certificates under the `ca_cert_data` key. If you configured `shared.ca_cert_data`, Tanzu Application Platform component packages inherit that value by default.

TLS is enabled by default on Application Live View back end using ClusterIssuer.
Set the `ingressEnabled` key to `true` for TLS to be enabled on Application Live View back end using ClusterIssuer.
This key is set to `false` by default.

The `appliveview-cert` certificate is generated by default and its issuerRef points to the `.ingress_issuer` value.
The `ingress_issuer` key consumes the value `shared.ingress_issuer` from `tap-values.yaml` by default
when you don't specify the `ingress_issuer` in `tap-values.yaml`.

When `ingressEnabled` is `true`, an HTTPProxy object is created in the cluster and
`appliveview-cert` certificate is generated by default in the `app_live_view` namespace.
The secretName `appliveview-cert` stores this certificate.

To verify the HTTPProxy object with the secret, run:

```console
kubectl get httpproxy -A
```

Expected output:

```console
NAMESPACE            NAME                                                              FQDN                                                             TLS SECRET               STATUS   STATUS DESCRIPTION
app-live-view        appliveview                                                       appliveview.192.168.42.55.nip.io                                 appliveview-cert   valid    Valid HTTPProxy
```

The `appliveview_connector.backend.host` key is the back end host in the view cluster.
The `appliveview_connector.backend.caCertData` key is the certificate retrieved from the HTTPProxy
secret exposed by Application Live View back end in the view cluster.
To retrieve this certificate, run the following command in the view cluster:

```console
kubectl get secret appliveview-cert -n app-live-view -o yaml |  yq '.data."ca.crt"' | base64 -d
```

## <a id="install-package"></a>Install your Tanzu Application Platform package

Follow these steps to install the Tanzu Application Platform package:

1. Install the package by running:

    ```console
    tanzu package install tap -p tap.tanzu.vmware.com -v $TAP_VERSION --values-file tap-values.yaml -n tap-install
    ```

    Where `$TAP_VERSION` is the Tanzu Application Platform version environment variable
    you defined earlier.

1. Verify the package install by running:

    ```console
    tanzu package installed get tap -n tap-install
    ```

    This may take 5-10 minutes because it installs several packages on your cluster.

1. Verify that all the necessary packages in the profile are installed by running:

    ```console
    tanzu package installed list -A
    ```

## <a id='next-steps'></a>Next steps

- [Install the Tanzu Build Service dependencies](tbs-offline-install-deps.hbs.md)

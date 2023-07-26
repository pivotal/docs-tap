To view possible configuration settings for a package, run:

```console
tanzu package available get tap.tanzu.vmware.com/$TAP_VERSION --values-schema --namespace tap-install
```

>**Note** The `tap.tanzu.vmware.com` package does not show all configuration settings
> for packages it plans to install. The package only shows top-level keys.
> You can view individual package configuration settings with the same
> `tanzu package available get` command.
> For example, to find the keys for Cloud Native Runtimes, you must first identify
> the version of the package with `tanzu package installed list -n tap-install`,
> which lists all the installed packages versions. Then run the command
> `tanzu package available get -n tap-install cnrs.tanzu.vmware.com/CNRS-VERSION --values-schema`
> by using the package version listed for Cloud Native Runtimes.

```yaml
profile: full

# Shared configurations go under the shared key.
shared:
  ingress_domain: tap.example.com

# ...

# For example, CNRs specific values go under its name.
cnrs:
  provider: local

# For example, App Accelerator specific values go under its name.
accelerator:
  server:
    service_type: "ClusterIP"
```

Shared Keys define values that configure multiple packages.
These keys are defined under the `shared` Top-level Key, as summarized in the following table:

|Shared Key|Description|Optional|
|----|----|----|
|`ca_cert_data`|PEM-encoded certificate data to trust TLS connections with a private CA. This shared key is used by `convention_controller`, `scanning` and the Tanzu `source_controller` (not the Flux CD Source Controller).|Yes|
|`ingress_domain`|Domain name to be used in service routes and host names for instances of Tanzu Application Platform components.|Yes|
|`ingress_issuer`|A `cert-manager.io/v1/ClusterIssuer` for issuing TLS certificates to Tanzu Application Platform components. Default value: `tap-ingress-selfsigned`|Yes|
|`kubernetes_distribution`|Type of Kubernetes infrastructure being used. You can use this shared key in coordination with the `kubernetes_version` key. Supported value: `openshift`.|Yes|
|`kubernetes_version`|Kubernetes version. You can use this shared key independently or in coordination with the `kubernetes_distribution` key. Supported value: `1.24.x`, where `x` stands for the Kubernetes patch version.|Yes|
|`image_registry.project_path`|Project path in the container image registry server used for builder and application images.|Yes|
|`image_registry.username`|User name for the container image registry. Mutually exclusive with `shared.image_registry.secret.name/namespace`|Yes|
|`image_registry.password`|Password for the container image registry. Mutually exclusive with `shared.image_registry.secret.name/namespace`|Yes|
|`secret.name`|Secret name for the container image registry credentials of type `kubernetes.io/dockerconfigjson`. Mutually exclusive with `shared.image_registry.username/password`|Yes|
|`secret.namespace`|Secret namespace for the container image registry credentials. Mutually exclusive with `shared.image_registry.username/password`|Yes|
|`activateAppLiveViewSecureAccessControl`|Enable secure access connection between App Live View components.|Yes|

The following table summarizes the top-level keys used for package-specific configuration within your `tap-values.yaml`.

|Package|Top-level Key|
|----|----|
|See table above.|`shared`|
|API Auto Registration|`api_auto_registration`|
|API portal|`api_portal`|
|Application Accelerator|`accelerator`|
|Application Live View|`appliveview`|
|Application Live View Connector|`appliveview_connector`|
|Application Live View Conventions|`appliveview-conventions`|
|Cartographer|`cartographer`|
|Cloud Native Runtimes|`cnrs`|
|Source Controller|`source_controller`|
|Supply Chain|`supply_chain`|
|Supply Chain Basic|`ootb_supply_chain_basic`|
|Supply Chain Testing|`ootb_supply_chain_testing`|
|Supply Chain Testing Scanning|`ootb_supply_chain_testing_scanning`|
|Supply Chain Security Tools - Scan|`scanning`|
|Supply Chain Security Tools - Scan (Grype Scanner)|`grype`|
|Supply Chain Security Tools - Store|`metadata_store`|
|Build Service|`buildservice`|
|Tanzu Developer Portal|`tap_gui`|
|Learning Center|`learningcenter`|

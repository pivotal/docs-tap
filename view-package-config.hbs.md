# Viewing possible configuration settings for your package

To view possible configuration settings for a package, run:

```console
tanzu package available get tap.tanzu.vmware.com/$TAP_VERSION --values-schema --namespace tap-install
```

>**Note:** The `tap.tanzu.vmware.com` package does not show all configuration settings for packages
>it plans to install. The package only shows top-level keys.
>You can view individual package configuration settings with the same `tanzu package available get` command.
>For example, use `tanzu package available get -n tap-install cnrs.tanzu.vmware.com/$TAP_VERSION --values-schema` for Cloud Native Runtimes.

```yaml
profile: full

# ...

# For example, CNRs specific values go under its name
cnrs:
  provider: local

# For example, App Accelerator specific values go under its name
accelerator:
  server:
    service_type: "ClusterIP"
```

The following table summarizes the top-level keys used for package-specific configuration within your `tap-values.yaml`.

|Package|Top-level Key|
|----|----|
|_see table below_|`shared`|
|API portal|`api_portal`|
|Application Accelerator|`accelerator`|
|Application Live View|`appliveview`|
|Application Live View Connector|`appliveview_connector`|
|Application Live View Conventions|`appliveview-conventions`|
|Cartographer|`cartographer`|
|Cloud Native Runtimes|`cnrs`|
|Convention Controller|`convention_controller`|
|Source Controller|`source_controller`|
|Supply Chain|`supply_chain`|
|Supply Chain Basic|`ootb_supply_chain_basic`|
|Supply Chain Testing|`ootb_supply_chain_testing`|
|Supply Chain Testing Scanning|`ootb_supply_chain_testing_scanning`|
|Supply Chain Security Tools - Scan|`scanning`|
|Supply Chain Security Tools - Scan (Grype Scanner)|`grype`|
|Supply Chain Security Tools - Store|`metadata_store`|
|Image Policy Webhook|`image_policy_webhook`|
|Build Service|`buildservice`|
|Tanzu Application Platform GUI|`tap_gui`|
|Learning Center|`learningcenter`|

Shared Keys define values that configure multiple packages. These keys are defined under the `shared` Top-level Key, as summarized in the following table:

|Shared Key|Used By|Description|
|----|----|----|
|`ca_cert_data`|`convention_controller`, `source_controller`|Optional: PEM Encoded certificate data to trust TLS connections with a private CA.|

For information about package-specific configuration, see [Installing individual packages](install-components.md).

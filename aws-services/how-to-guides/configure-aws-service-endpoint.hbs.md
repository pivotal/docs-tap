# Configure AWS Service Endpoint

This topic describes how to configure the AWS service endpoint used by the Providers included with the AWS Services Package.

## Create a ProviderConfig using `.spec.endpoint`

By default, the AWS Providers will make calls to the default service endpoint for each service in an AWS Region. However it is possible to configure the Providers to make calls to an endpoint of your choosing. This is done through appropriate configuration of a `ProviderConfig` resource, and then configuring the AWS Services Package to use that `ProviderConfig`. For example, you may choose to create a `ProviderConifg` like the following:

```yaml
---
apiVersion: aws.upbound.io/v1beta1
kind: ProviderConfig
metadata:
  name: custom-endpoint
spec:
  endpoint:
    url:
      static: https://my-custom-aws-endpoint.com
      type: Static
# ...
```

Refer to the official Upbound documentation for [the full list of configuration options](https://marketplace.upbound.io/providers/upbound/provider-family-aws/latest/resources/aws.upbound.io/ProviderConfig/v1beta1).

Then, configure the AWS Services Package to make use of this `ProviderConfig` via the Package values, for example:

```yaml
# aws-services-values.yaml
---
postgresql:
  provider_config_ref:
    name: custom-endpoint
# ...
```

And then update the AWS Services Package installation:

```console
tanzu package installed update aws-services -n tap-install --values-file aws-services-values.yaml
```

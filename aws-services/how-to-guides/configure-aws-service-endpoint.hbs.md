# Configure the AWS service endpoint

This topic describes how to configure the service endpoint that the providers included with the
AWS Services package use.

## <a id="overview"></a> Overview

By default, AWS providers make calls to the default service endpoint for each service in an AWS region.
However, you can configure the providers to make calls to an endpoint of your choice.

## <a id="create-providerconfig"></a> Configure the endpoint by using a ProviderConfig resource

To configure the service endpoint through a `ProviderConfig` resource:

1. Update the `ProviderConfig` you created when installing the package. For example:

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

    For the full list of configuration options, see the
    [Upbound documentation](https://marketplace.upbound.io/providers/upbound/provider-family-aws/latest/resources/aws.upbound.io/ProviderConfig/v1beta1).

1. In your `aws-services-values.yaml` file, configure the AWS Services package to use the
   `ProviderConfig` you just configured. For example:

    ```yaml
    # aws-services-values.yaml
    ---
    postgresql:
      provider_config_ref:
        name: custom-endpoint
    # ...
    ```

1. Update the AWS Services package:

    ```console
    tanzu package installed update aws-services -n tap-install --values-file aws-services-values.yaml
    ```

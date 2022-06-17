# Configure image signing and verification in your supply chain

This how-to guide walks you through configuring your supply chain to sign your image builds.

## <a id="you-will"></a>What you will do

  - Configure your supply chain to sign your image builds.
  - Configure an admission control policy to verify image signatures before admitting pods to the cluster.

## <a id="config-sc-to-img-builds"></a>Configure your supply chain to sign your image builds

1. Configure Tanzu Build Service to sign your container image builds by using cosign. See [Managing Image Resources and Builds](https://docs.vmware.com/en/Tanzu-Build-Service/1.6/vmware-tanzu-build-service/GUID-managing-images.html) for instructions.

2. Create a `values.yaml` file, and install the sign supply chain security tools and image policy web-hook. See [Install Supply Chain Security Tools - Sign](../install-components.md#install-scst-sign) for instructions.

3. Configure a `ClusterImagePolicy` resource to verify image signatures when deploying resources. The resource must be named `image-policy`.

    For example:

    ```yaml
    ---
    apiVersion: signing.apps.tanzu.vmware.com/v1beta1
    kind: ClusterImagePolicy
    metadata:
       name: image-policy
    spec:
       verification:
         exclude:
           resources
             namespaces:
             - kube-system
             - test-namespace
             - <TAP system namespaces>
         keys:
         - name: first-key
           publicKey: |
             -----BEGIN PUBLIC KEY-----
             <content ...>
             -----END PUBLIC KEY-----
         images:
         - namePattern: registry.example.org/myproject/*
           keys:
           - name: first-key

    ```

> **Note:** System namespaces specific to your cloud provider might need to be excluded from the policy.

To prevent the Image Policy Webhook from blocking components of Tanzu Application Platform, VMware recommends configuring exclusions for Tanzu Application Platform system namespaces listed in [Create a `ClusterImagePolicy` resource](../scst-sign/configuring.md#create-cip-resource).

When you apply the `ClusterImagePolicy` resource, your cluster requires valid signatures for all images that match the `namePattern:` you define in the configuration. For more information about configuring an image signature policy, see [Configuring Supply Chain Security Tools - Sign](../scst-sign/configuring.md).

## <a id="config-img-next-steps"></a>Next steps

Learn about:

- [Consuming services on Tanzu Application Platform](about-consuming-services.md)

Or learn more about Supply Chain Security Tools:

- [Overview for Supply Chain Security Tools - Sign](../scst-sign/overview.md)
- [Configuring Supply Chain Security Tools - Sign](../scst-sign/configuring.md)
- [Supply Chain Security Tools - Sign known issues](../release-notes.md)

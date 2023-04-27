# Configure image signing and verification in your supply chain

This how-to guide walks you through configuring your supply chain to sign and verify your image builds.

## <a id="you-will"></a>What you will do

- Configure your supply chain to sign your image builds.
- Configure an admission control policy to verify image signatures before admitting pods to the cluster.

## <a id="config-sc-to-img-builds"></a>Configure your supply chain to sign and verify your image builds

1. Use cosign to configure Tanzu Build Service to sign your container image builds. For instructions, see [Configure Tanzu Build Service to sign your image builds](../tanzu-build-service/tbs-image-signing.md).

2. Create a `values.yaml` file, and install the Supply Chain Security Tools - Policy Controller. For instructions, see [Install Supply Chain Security Tools - Policy Controller](../scst-policy/install-scst-policy.md).

3. Create a `ClusterImagePolicy` that passes Tanzu Application Platform images. It is planned for a future release for these to be signed and verifiable, but currently we recommend creating a policy to pass them:

    For example:

    ```console
    kubectl apply -f - -o yaml << EOF
    ---
    apiVersion: policy.sigstore.dev/v1beta1
    kind: ClusterImagePolicy
    metadata:
      name: image-policy-exceptions
    spec:
      images:
      - glob: registry.example.org/myproject/*
      - glob: REPO-NAME*
      authorities:
      - static:
          action: pass
    EOF
    ```

    Where:

    - `REPO-NAME` is the repository in your registry where Tanzu Build Service dependencies are stored. This is the exact same value configured in the `kp_default_repository` inside your `tap-values.yaml` or `tbs-values.yaml` files. Examples:
      - Harbor has the form `"my-harbor.io/my-project/build-service"`.
      - Docker Hub has the form `"my-dockerhub-user/build-service"` or `"index.docker.io/my-user/build-service"`.
      - Google Cloud Registry has the form `"gcr.io/my-project/build-service"`.

    - Add any unsigned image that must run in your namespace to the previous policy.
      For example, if you add a Tekton pipeline that runs a gradle image for testing, you need
      to add `glob: index.docker.io/library/gradle*` to `spec.images.glob` in the preceding code.

    - Replace `registry.example.org/myproject/*` with your target registry for your
      Tanzu Application Platform images. If you did not relocate the Tanzu Application Platform images
      to your own registry during installation, use
      `registry.tanzu.vmware.com/tanzu-application-platform/tap-packages*`.

4. Configure and apply a `ClusterImagePolicy` resource to the cluster to verify image signatures when deploying resources. For instructions, see [Create a ClusterImagePolicy resource](../scst-policy/configuring.md#create-cip-resource).

    For example:

    ```console
    kubectl apply -f - -o yaml << EOF
    ---
    apiVersion: policy.sigstore.dev/v1beta1
    kind: ClusterImagePolicy
    metadata:
      name: example-policy
    spec:
      images:
      - glob: registry.example.org/myproject/*
      authorities:
      - key:
          data: |
            -----BEGIN PUBLIC KEY-----
            <content ...>
            -----END PUBLIC KEY-----
    EOF
    ```

5. Enable the policy controller verification in your namespace by adding the label
`policy.sigstore.dev/include: "true"` to the namespace resource.

    For example:

    ```console
    kubectl label namespace YOUR-NAMESPACE policy.sigstore.dev/include=true
    ```

    Where `YOUR-NAMESPACE` is the name of your secure namespace.

   >**Note** Supply Chain Security Tools - Policy Controller only validates resources in namespaces
   >that have chosen to opt in.

When you apply the `ClusterImagePolicy` resource, your cluster requires valid signatures for all images that match the `spec.images.glob[]` you define in the configuration. For more information about configuring an image policy, see [Configuring Supply Chain Security Tools - Policy](../scst-policy/configuring.md).

## <a id="config-img-next-steps"></a>Next steps

- [Consume services on Tanzu Application Platform](consume-services.md)

Or learn more about Supply Chain Security Tools:

- [Overview for Supply Chain Security Tools - Policy](../scst-policy/overview.md)
- [Configuring Supply Chain Security Tools - Policy](../scst-policy/configuring.md)
- [Supply Chain Security Tools - Policy known issues](../release-notes.md)

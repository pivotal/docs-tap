# Install Supply Chain Security Tools - Sign

Supply Chain Security Tools - Sign is released as an individual Tanzu Application
Platform component and is not included in either the full or light profile.

## <a id='scst-sign-prereqs'></a> Prerequisites

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).
- During configuration for this component, you are asked to provide a cosign public key to use to
validate signed images. An example cosign public key is provided that can validate an image from the
public cosign registry. If you want to provide your own key and images, follow the
[cosign quick start guide](https://github.com/sigstore/cosign#quick-start) in GitHub to
generate your own keys and sign an image.

>**Caution:** This component rejects pods if the webhook fails or is incorrectly configured.
>If the webhook is preventing the cluster from functioning,
>see [Supply Chain Security Tools - Sign Known Issues](../release-notes.md)
> in the Tanzu Application Plantform release notes for recovery steps.

## <a id='install-scst-sign'></a> Install

>**Note:** v1alpha1 api version of the ClusterImagePolicy is no longer supported as the group name has been renamed from
`signing.run.tanzu.vmware.com` to `signing.apps.tanzu.vmware.com`.

To install Supply Chain Security Tools - Sign:

1. List version information for the package by running:

    ```
    tanzu package available list image-policy-webhook.signing.apps.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```
    $ tanzu package available list image-policy-webhook.signing.apps.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for image-policy-webhook.signing.apps.tanzu.vmware.com...
      NAME                                                VERSION        RELEASED-AT
      image-policy-webhook.signing.apps.tanzu.vmware.com  1.1.0          2022-01-24 09:00:00 -0500 EST
    ```

1. (Optional) Make changes to the default installation settings by running:

    ```
    tanzu package available get image-policy-webhook.signing.apps.tanzu.vmware.com/1.1.0 --values-schema --namespace tap-install
    ```

    For example:

    ```
    $ tanzu package available get image-policy-webhook.signing.apps.tanzu.vmware.com/1.1.0 --values-schema --namespace tap-install
    | Retrieving package details for image-policy-webhook.signing.apps.tanzu.vmware.com/1.1.0...
      KEY                     DEFAULT              TYPE     DESCRIPTION
      allow_unmatched_images  false                boolean  Feature flag for enabling admission of images that do not match any patterns in the image policy configuration.
                                                            Set to true to allow images that do not match any patterns into the cluster with a warning.
      deployment_namespace    image-policy-system  string   Deployment namespace specifies the namespace where this component should be deployed to.
                                                            If not specified, "image-policy-system" is assumed.
      limits_cpu              200m                 object   The CPU limit defines a hard ceiling on how much CPU time that
                                                            the Image Policy Webhook controller manager container can use.
                                                            https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-cpu

      limits_memory           256Mi                object   The memory limit defines a hard ceiling on how much memory that
                                                            the Image Policy Webhook controller manager container can use.
                                                            https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-memory

      quota.pod_number        5                    string   The maximum number of Image Policy Webhook Pods allowed to be created with the priority class
                                                            system-cluster-critical. This value must be enclosed in quotes (""). If this value is not
                                                            specified then a default value of 5 is used.
      replicas                1                    integer  The number of replicas to be created for the Image Policy Webhook. This value must not be enclosed
                                                            in quotes. If this value is not specified then a default value of 1 is used.
      requests_cpu            100m                 object   The CPU request defines the minimum CPU time for the Image Policy
                                                            Webhook controller manager. During CPU contention, CPU request is used
                                                            as a weighting where higher CPU requests are allocated more CPU time.
                                                            https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-cpu

      requests_memory         50Mi                 object   The memory request defines the minium memory amount for the Image Policy Webhook controller manager.
                                                            https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-memory
    ```

1. Create a file named `scst-sign-values.yaml` and add the settings you want to customize:

    - `allow_unmatched_images`:

        * **For non-production environments**: To warn the user when images
          do not match any pattern in the policy, but still allow them into
          the cluster, set `allow_unmatched_images` to `true`.

            ```
            ---
            allow_unmatched_images: true
            ```

        * **For production environments**: To deny images that match no patterns in the policy set `allow_unmatched_images` to `false`.

            ```
            ---
            allow_unmatched_images: false
            ```

            >**Note**: For a quicker installation process VMware recommends that
            >you set `allow_unmatched_images` to `true` initially.
            >This setting means that the webhook allows unsigned images to
            >run if the image does not match any pattern in the policy.
            >To promote to a production environment VMware recommends that you
            >re-install the webhook with `allow_unmatched_images` set to `false`.

    - `quota.pod_number`:
      This setting is the maximum number of pods that are allowed in the
      deployment namespace with the `system-cluster-critical`
      priority class. This priority class is added to the pods to prevent
      preemption of this component's pods in case of node pressure.

      The default value for this property is 5. If your use case requires
      more than 5 pods be deployed of this component, adjust this value to
      allow the number of replicas you intend to deploy.

    - `replicas`:
      These settings controls the default amount of replicas that will get deployed by this
      component. The default value is 1.

        * **For production environments**: VMware recommends you increase the number of replicas to
          3 to ensure availability of the component for better admission performance.

    - `deployment_namespace`:
      This setting controls the namespace to which this component is deployed.
      When not specified, the namespace `image-policy-system` is assumed.
      This component creates the specified namespace to deploy required
      resources. Select a namespace that is not used by any
      other components.

    - `limits_cpu`:
      This setting controls the maximum CPU resource allocated to the Image Policy
      Webhook controller. The default value is "200m". More details can be found
      on the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-cpu)

    - `limits_memory`:
      This setting controls the maximum memory resource allocated to the Image Policy
      Webhook controller. The default value is "256Mi". More details can be found
      on the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-memory)

    - `requests_cpu`:
      This setting controls the minimum CPU resource allocated to the Image Policy
      Webhook controller. During CPU contention, this value is used as a weighting
      where higher values allocate more CPU time. The default value is "100m".
      More details can be found on the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-cpu)

    - `requests_memory`:
      This setting controls the minimum memory resource allocated to the Image Policy
      Webhook controller. The default value is "50Mi". More details can be found on
      the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-memory)

1. Install the package:

    ```
    tanzu package install image-policy-webhook \
      --package-name image-policy-webhook.signing.apps.tanzu.vmware.com \
      --version 1.1.0 \
      --namespace tap-install \
      --values-file scst-sign-values.yaml
    ```

    For example:

    ```
    $ tanzu package install image-policy-webhook \
        --package-name image-policy-webhook.signing.apps.tanzu.vmware.com \
        --version 1.1.0 \
        --namespace tap-install \
        --values-file scst-sign-values.yaml

    | Installing package 'image-policy-webhook.signing.apps.tanzu.vmware.com'
    | Getting namespace 'default'
    | Getting package metadata for 'image-policy-webhook.signing.apps.tanzu.vmware.com'
    | Creating service account 'image-policy-webhook-default-sa'
    | Creating cluster admin role 'image-policy-webhook-default-cluster-role'
    | Creating cluster role binding 'image-policy-webhook-default-cluster-rolebinding'
    | Creating secret 'image-policy-webhook-default-values'
    / Creating package resource
    - Package install status: Reconciling

    Added installed package 'image-policy-webhook' in namespace 'tap-install'
    ```

   After you run the commands above your signing package will be running.

   >**Note:** This component requires extra configuration steps to work properly. See
   >[Configuring Supply Chain Security Tools - Sign](configuring.md)
   >for instructions on how to apply the required configuration.


## <a id="configure"></a> Configure

The WebHook deployed by Supply Chain Security Tools - Sign requires extra input
from the operator before it starts enforcing policies.

To configure your installed component properly, see
[Configuring Supply Chains Security Tools - Sign](configuring.md).

## <a id="known-issues"></a> Known issues

See [Supply Chain Security Tools - Sign Known Issues](../release-notes.md).

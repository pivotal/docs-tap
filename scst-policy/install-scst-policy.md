# Install Supply Chain Security Tools - Policy Controller

Supply Chain Security Tools - Policy Controller is released as part of Tanzu Application
Platform's full, iterate and run profiles. Follow the instructions below to manually install this component.

## <a id='scst-policy-prereqs'></a> Prerequisites

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).
- A container image registry that supports TLS connections. This component does not work with insecure registries.
- During configuration for this component, you are asked to provide a cosign public key to use to
validate signed images. An example cosign public key is provided that can validate an image from the
public cosign registry. If you want to provide your own key and images, follow the
[cosign quick start guide](https://github.com/sigstore/cosign#quick-start) in GitHub to
generate your own keys and sign an image.

>**Caution:** This component rejects pods if the webhook fails or is incorrectly configured.
**TODO** is this true?? do we need a trouble shooting section??

## <a id='install-scst-policy'></a> Install

To install Supply Chain Security Tools - Policy:

1. List version information for the package by running:

    ```console
    tanzu package available list policy.apps.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list policy.apps.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for policy.apps.tanzu.vmware.com...
      NAME                                                VERSION        RELEASED-AT
      policy.apps.tanzu.vmware.com                        1.0.0          2022-06-03 18:00:00 -0500 EST
    ```

1. (Optional) Make changes to the default installation settings by running:

    ```console
    tanzu package available get policy.apps.tanzu.vmware.com/VERSION --values-schema --namespace tap-install
    ```

    Where `VERSION` is the version number you discovered. For example, `1.0.0`.

    For example:

    ```console
    $ tanzu package available get policy.apps.tanzu.vmware.com/1.0.0 --values-schema --namespace tap-install
    | Retrieving package details for policy.apps.tanzu.vmware.com/1.0.0...
      KEY                     DEFAULT              TYPE     DESCRIPTION
      custom_ca_secrets       <nil>                array    List of custom CA secrets that should be included in the application container for registry communication.
                                                            An array of secret references each containing a secret_name field with the secret name to be referenced
                                                            and a namespace field with the name of the namespace where the referred secret resides.

      custom_cas              <nil>                array    List of custom CA contents that should be included in the application container for registry communication.
                                                            An array of items containing a ca_content field with the PEM-encoded contents of a certificate authority.

      deployment_namespace    image-policy-system  string   Deployment namespace specifies the namespace where this component should be deployed to.
                                                            If not specified, "image-policy-system" is assumed.

      limits_cpu              200m                 string   The CPU limit defines a hard ceiling on how much CPU time that
                                                            the Image Policy Webhook controller manager container can use.
                                                            https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-cpu

      limits_memory           256Mi                string   The memory limit defines a hard ceiling on how much memory that
                                                            the Image Policy Webhook controller manager container can use.
                                                            https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-memory

      quota.pod_number        5                    string   The maximum number of Image Policy Webhook Pods allowed to be created with the priority class
                                                            system-cluster-critical. This value must be enclosed in quotes (""). If this value is not
                                                            specified then a default value of 5 is used.
      replicas                1                    integer  The number of replicas to be created for the Image Policy Webhook. This value must not be enclosed
                                                            in quotes. If this value is not specified then a default value of 1 is used.
      requests_cpu            100m                 string   The CPU request defines the minimum CPU time for the Image Policy
                                                            Webhook controller manager. During CPU contention, CPU request is used
                                                            as a weighting where higher CPU requests are allocated more CPU time.
                                                            https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-cpu

      requests_memory         50Mi                 string   The memory request defines the minium memory amount for the Image Policy Webhook controller manager.
                                                            https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-memory
    ```

1. Create a file named `scst-policy-values.yaml` and add the settings you want to customize:

    - `custom_ca_secrets`:
      This setting controls which secrets to be added to the application
      container as custom certificate authorities (CAs). It enables communication
      with registries deployed with self-signed certificates. `custom_ca_secrets`
      consists of an array of items. Each item contains two fields:
      the `secret_name` field defines the name of the secret,
      and the `namespace` field defines the name of the namespace where said
      secret is stored.

      For example:

      ```yaml
      custom_ca_secrets:
      - secret_name: first-ca
          namespace: ca-namespace
      - secret_name: second-ca
          namespace: ca-namespace
      ```

      >**Note:** This setting is allowed even if `custom_cas` was informed.

    - `custom_cas`:
      This setting enables adding certificate content in PEM format.
      The certificate content is added to the application container as custom
      certificate authorities (CAs) to communicate with registries deployed with
      self-signed certificates.
      `custom_cas` consists of an array of items. Each item contains
      a single field named `ca_content`. The value of this field must be a
      PEM-formatted certificate authority. The certificate content must be
      defined as a YAML block, preceded by the literal indicator (`|`) to
      preserve line breaks and ensure the certificates are interpreted correctly.

      For example:

      ```yaml
      custom_cas:
      - ca_content: |
            ----- BEGIN CERTIFICATE -----
            first certificate content here...
            ----- END CERTIFICATE -----
      - ca_content: |
            ----- BEGIN CERTIFICATE -----
            second certificate content here...
            ----- END CERTIFICATE -----
      ```

      >**Note:** This setting is allowed even if `custom_ca_secrets` was informed.

    - `deployment_namespace`:
      This setting controls the namespace to which this component is deployed.
      When not specified, the namespace `image-policy-system` is assumed.
      This component creates the specified namespace to deploy required
      resources. Select a namespace that is not used by any
      other components.

    - `limits_cpu`:
      This setting controls the maximum CPU resource allocated to the Image Policy
      Webhook controller. The default value is "200m". See [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-cpu) for more details.

    - `limits_memory`:
      This setting controls the maximum memory resource allocated to the Image Policy
      Webhook controller. The default value is "256Mi". See [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-memory) for more details.

    - `quota.pod_number`:
      This setting controls the maximum number of pods that are allowed in the
      deployment namespace with the `system-cluster-critical`
      priority class. This priority class is added to the pods to prevent
      preemption of this component's pods in case of node pressure.

      The default value for this field is `5`. If your use case requires
      more than 5 pods, change this value to allow the number of replicas you intend to deploy.

    - `replicas`:
      This setting controls the default amount of replicas to be deployed by this
      component. The default value is `1`.

      **For production environments**: VMware recommends you increase the number of replicas to
        `3` to ensure availability of the component and better admission performance.

    - `requests_cpu`:
      This setting controls the minimum CPU resource allocated to the Image Policy
      Webhook controller. During CPU contention, this value is used as a weighting
      where higher values indicate more CPU time is allocated. The default value is "100m".
      See [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-cpu) for more details.

    - `requests_memory`:
      This setting controls the minimum memory resource allocated to the Image Policy
      Webhook controller. The default value is "50Mi". See [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-memory) for more details.

1. Install the package:

    ```console
    tanzu package install policy-controller \
      --package-name policy.apps.tanzu.vmware.com \
      --version VERSION \
      --namespace tap-install \
      --values-file scst-policy-values.yaml
    ```

    Where `VERSION` is the version number you discovered earlier. For example, `1.0.0`.

    For example:

    ```console
    $ tanzu package install policy-controller \
        --package-name policy.apps.tanzu.vmware.com \
        --version 1.0.0 \
        --namespace tap-install \
        --values-file scst-policy-values.yaml

    | Installing package 'policy.apps.tanzu.vmware.com'
    | Getting namespace 'default'
    | Getting package metadata for 'policy.apps.tanzu.vmware.com'
    | Creating service account 'image-policy-webhook-default-sa'
    | Creating cluster admin role 'image-policy-webhook-default-cluster-role'
    | Creating cluster role binding 'image-policy-webhook-default-cluster-rolebinding'
    | Creating secret 'image-policy-webhook-default-values'
    / Creating package resource
    - Package install status: Reconciling

    Added installed package 'image-policy-webhook' in namespace 'tap-install'
    ```
**TODO** update console output for above^^

   After you run the commands above the policy controller will be running.

   >**Note:** This component requires extra configuration steps to work properly. See
   >[Configuring Supply Chain Security Tools - Policy](configuring.md)
   >for instructions on how to apply the required configuration.


## <a id="configure"></a> Configure

The WebHook deployed by Supply Chain Security Tools - Policy requires extra input
from the operator before it starts enforcing policies.

To configure your installed component properly, see
[Configuring Supply Chains Security Tools - Policy](configuring.md).

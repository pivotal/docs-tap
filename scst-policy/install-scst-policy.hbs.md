# Install Supply Chain Security Tools - Policy Controller

You install Supply Chain Security Tools - Policy Controller as part of Tanzu
Application Platform's Full, Iterate, and Run profiles. You can use the
instructions in this topic to manually install SCST - Policy Controller.

> **Note** Follow the steps in this topic if you do not want to use a profile to install Supply Chain Security Tools - Policy Controller. For more information about profiles, see [About Tanzu Application Platform components and profiles](../about-package-profiles.hbs.md).

## <a id='scst-policy-prereqs'></a> Prerequisites

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).
- A container image registry that supports TLS connections.

> **Important** This component does not work with not secure registries.

- For keyless authorities support, you must set `policy.tuf_enabled: true`. By
  default, the public official Sigstore The Update Framework (TUF) server is
  used. To target an alternative Sigstore stack, specify `policy.tuf_mirror` and
  `policy.tuf_root`.

- If you are installing in an air-gapped environment and require keyless
  authorities, you must deploy a Sigstore Stack on the cluster or be accessible
  from the air-gapped environment. For information, see [Install Sigstore
  Stack](./install-sigstore-stack.hbs.md).

- During configuration, you provide a cosign
public key to validate signed images. The Policy Controller only supports
ECDSA public keys. An example cosign public key is provided that can validate an
image from the public cosign registry. To provide your own key and images,
follow the [Cosign Quick Start
Guide](https://github.com/sigstore/cosign#quick-start) in GitHub.

> **Caution** This component rejects `pods` if they are not correctly configured.
>Test your configuration in a test environment before applying policies to your
>production cluster.

## <a id='install-scst-policy'></a> Install

To install Supply Chain Security Tools - Policy Controller:

1. List version information for the package by running:

    ```console
    tanzu package available list policy.apps.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list policy.apps.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for policy.apps.tanzu.vmware.com...
      NAME                          VERSION        RELEASED-AT
      policy.apps.tanzu.vmware.com  1.2.0          2023-10-01 20:00:00 -0400 EDT
    ```

1. (Optional) Make changes to the default installation settings by running:

    ```console
    tanzu package available get policy.apps.tanzu.vmware.com/VERSION --values-schema --namespace tap-install
    ```

    Where `VERSION` is the version number you discovered. For example, `1.2.0`.

    For example:

    ```console
    $ tanzu package available get policy.apps.tanzu.vmware.com/1.2.0 --values-schema --namespace tap-install
    | Retrieving package details for policy.apps.tanzu.vmware.com/1.2.0...

    KEY                        DEFAULT        TYPE     DESCRIPTION
    custom_cas                 <nil>          array    List of custom CA contents that should be included in the application container for registry communication.
                                                       An array of items containing a ca_content field with the PEM-encoded contents of a certificate authority.
    deployment_namespace       cosign-system  string   Deployment namespace specifies the namespace where this component should be deployed to.
                                                       If not specified, "cosign-system" is assumed.
    fail_on_empty_authorities  true           boolean  Configure if a ClusterImagePolicy will fail or allow empty authorities
    limits_cpu                 200m           string   The CPU limit defines a hard ceiling on how much CPU time
                                                       that the Policy Controller manager container can use.
                                                       https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-cpu

    no_match_policy            deny           string   The action when no policy matches the admitting image digest. Valid values are "warn", "allow", or "deny".
    quota.pod_number           6              string   The maximum number of Policy Controller Pods allowed to be created with the priority class
                                                       system-cluster-critical. This value must be enclosed in quotes (""). If this value is not
                                                       specified then a default value of 6 is used.
    replicas                   1              integer  The number of replicas to be created for the Policy Controller. This value must not be enclosed
                                                       in quotes. If this value is not specified then a default value of 1 is used.
    requests_memory            20Mi           string   The memory request defines the minium memory amount for the Policy Controller manager.
                                                       https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-memory

    tuf_root                                  string   The root.json file content of the TUF mirror

    custom_ca_secrets          <nil>          array    List of custom CA secrets that should be included in the application container for registry communication.
                                                       An array of secret references each containing a secret_name field with the secret name to be referenced
                                                       and a namespace field with the name of the namespace where the referred secret resides.
    limits_memory              200Mi          string   The memory limit defines a hard ceiling on how much memory
                                                       that the Policy Controller manager container can use.
                                                       https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-memory

    requests_cpu               20m            string   The CPU request defines the minimum CPU time for the Policy
                                                       Controller manager. During CPU contention, CPU request is used as
                                                       a weighting where higher CPU requests are allocated more CPU time.
                                                       https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-cpu

    tuf_mirror                                string   TUF mirror address
    ```

2. Create a file named `scst-policy-values.yaml` and add the settings you want to customize:

    - `custom_ca_secrets`:
      If your container registries are secured by self-signed certificates, this setting controls which secrets are added to the application
      container as custom certificate authorities (CAs). `custom_ca_secrets`
      consists of an array of items. Each item contains two text boxes:
      the `secret_name` text box defines the name of the secret,
      and the `namespace` text box defines the name of the namespace where said
      secret is stored.

      For example:

      ```yaml
      custom_ca_secrets:
      - secret_name: first-ca
          namespace: ca-namespace
      - secret_name: second-ca
          namespace: ca-namespace
      ```

      > **Note** This setting is allowed even if `custom_cas` is defined.

    - `custom_cas`:
      This setting enables adding certificate content in PEM format.
      The certificate content is added to the application container as custom
      certificate authorities (CAs) to communicate with registries deployed with
      self-signed certificates.
      `custom_cas` consists of an array of items. Each item contains
      a single text box named `ca_content`. The value of this text box must be a
      PEM-formatted certificate authority. The certificate content must be
      defined as a YAML block, preceded by the literal indicator (`|`) to
      preserve line breaks and ensure that the certificates are interpreted correctly.

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

      > **Note** This setting is allowed even if `custom_ca_secrets` is defined.

    - `deployment_namespace`:
      This setting controls the namespace to which this component is deployed.
      When not specified, the namespace `cosign-system` is assumed.
      This component creates the specified namespace to deploy required
      resources. Select a namespace that is not used by any
      other components.

    - `limits_cpu`:
      This setting controls the maximum CPU resource allocated to the Policy
      admission controller. The default value is "200m". See [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-cpu).

    - `limits_memory`:
      This setting controls the maximum memory resource allocated to the Policy
      admission controller. The default value is "200Mi". See [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-memory).

    - `quota.pod_number`:
      This setting controls the maximum number of pods that are allowed in the
      deployment namespace with the `system-cluster-critical`
      priority class. This priority class is added to the pods to prevent
      preemption of this component's pods in case of node pressure.

      The default value for this text box is `6`. If your use requires
      more than 6 pods, change this value to allow the number of replicas you intend to deploy.

      >**Note** VMware recommends to run this component with a critical priority
      >level to prevent the cluster from rejecting all admission requests if the
      >component's `pod`s are evicted due to resource limits.

    - `replicas`:
      This setting controls the default amount of replicas deployed by this
      component. The default value is `1`.

      **For production environments**: VMware recommends you increase the number of replicas to
        `3` to ensure that the availability of the component and better admission performance.

    - `requests_cpu`:
      This setting controls the minimum CPU resource allocated to the Policy
      admission controller. During CPU contention, this value is used as a weighting
      where higher values indicate more CPU time is allocated. The default value is `20m`.
      See [CPU resource units](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-cpu) in the Kubernetes documentation.

    - `requests_memory`:
      This setting controls the minimum memory resource allocated to the Policy
      admission controller. The default value is `20Mi`. See [Memory resource units](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-memory) in the Kubernetes documentation.

    - `tuf_enabled`:
      This setting defines whether the TUF initialization is done on startup. It is required for keyless verification support.
      The default value is `false`, which means that keyless authorities of `ClusterImagePolicy` are not supported. Also, policy-controller does not have an external dependency on setup.

    - `tuf_root`:
      The root.json file content of the TUF mirror.

    - `tuf_mirror`:
      This setting defines the TUF mirror address which is used for doing the initialization.

    - `no_match_policy`:
      The action when no policy matches the admitting image digest. Valid values are `"warn"`, `"allow"`, or `"deny"`. Default value is `"deny"`

    - `fail_on_empty_authorities`:
      Failing or allowing empty authorities when adding a new `ClusterImagePolicy`. Default value is `true`.

3. Install the package:

    ```console
    tanzu package install policy-controller \
      --package-name policy.apps.tanzu.vmware.com \
      --version VERSION \
      --namespace tap-install \
      --values-file scst-policy-values.yaml
    ```

    Where `VERSION` is the version number you discovered earlier. For example, `1.2.0`.

    For example:

    ```console
    $ tanzu package install policy-controller \
        --package-name policy.apps.tanzu.vmware.com \
        --version 1.2.0 \
        --namespace tap-install \
        --values-file scst-policy-values.yaml

      Installing package 'policy.apps.tanzu.vmware.com'
      Getting package metadata for 'policy.apps.tanzu.vmware.com'
      Creating service account 'policy-controller-tap-install-sa'
      Creating cluster admin role 'policy-controller-tap-install-cluster-role'
      Creating cluster role binding 'policy-controller-tap-install-cluster-rolebinding'
      Creating package resource
      Waiting for 'PackageInstall' reconciliation for 'policy-controller'
      'PackageInstall' resource install status: Reconciling
      'PackageInstall' resource install status: ReconcileSucceeded
      'PackageInstall' resource successfully reconciled

      Added installed package 'policy-controller'
    ```

After you run the commands earlier the policy controller is running.

Policy Controller is now installed, but it does not enforce any
policies by default. Policies must be explicitly configured on the cluster.
To configure signature verification policies, see [Configuring Supply Chain
Security Tools - Policy](configuring.md).

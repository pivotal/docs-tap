# Customize default resources in Namespace Provisioner

This topic tells you how to deactivate Grype in Namespace Provisioner and how to configure the `default` service account to work with private Git repositories in Tanzu Application Platform (commonly known as TAP).

## <a id='deactivate-grype'></a>Deactivate Grype install

Grype is installed with Namespace Provisioner by default. If you prefer to use a different scanner for namespaces instead of Grype, you can deactivate the installation of the default Grype scanner.

### Deactivate Grype for all namespaces

To deactivate the default installation of Grype for all namespaces managed by the Namespace Provisioner, set the `skip_grype` parameter to `true` in the `default_parameters` section of the `tap-values.yaml`:

```yaml
namespace_provisioner:
  default_parameters:
    skip_grype: true
```

By enabling the `skip_grype: true` setting, the PackageInstall and the secret `grype-scanner-{namespace}` are not generated in the `tap-install` namespace for any namespaces that are managed by the Namespace Provisioner.

### Deactivate Grype for a specific namespace

Using Namespace Provisioner Controller
: To deactivate the installation of Grype for a specific namespace, annotate or label the namespace
by setting the reserved [parameter](parameters.hbs.md#namespace-parameters) `skip_grype` to `true`. Use the default or customized `parameter_prefixes`. For more information, see [Customize the label and annotation prefixes that controller watches](customize-installation.hbs.md#con-custom-label).

    ```console
    kubectl annotate ns YOUR-NEW-DEVELOPER-NAMESPACE param.nsp.tap/skip_grype=true
    ```

Using GitOps
: Add the [parameter](parameters.hbs.md#namespace-parameters) `skip_grype` with the value `true` in the namespaces file in the GitOps repository.

    ```yaml
    #@data/values
    ---
    namespaces:
    - name: dev
      skip_grype: true
    - name: qa
    ```

<br>

## <a id='customize-sa'></a>Customize service accounts

This section provides instructions on how to configure the `default` service account to work with
private Git repositories for workloads and supply chain using Namespace Provisioner.

To configure the service account to work with private Git repositories, follow the steps below:

1. Create a secret in the `tap-install` namespace, or any namespace that
contains the Git credentials in the YAML format.
    - `host`, `username`, and `password` values for HTTP based Git Authentication.
    - `ssh-privatekey, identity, identity_pub`, and `known_hosts` for SSH based Git Authentication.

    >**Note** stringData key of the secret must have **.yaml** or **.yml** suffix at the end.

    ```yaml
    #! Example shows HTTP as well as SSH based authentication
    cat << EOF | kubectl apply -f -
    apiVersion: v1
    kind: Secret
    metadata:
      name: workload-git-auth
      namespace: tap-install
    type: Opaque
    stringData:
      content.yaml: |
        git:
          #! For HTTP Auth. Recommend using https:// for the git server.
          host: GIT-SERVER
          username: GIT-USERNAME
          token: GIT-PASSWORD
          #! For SSH Auth
          ssh_privatekey: SSH-PRIVATE-KEY
          identity: SSH-PRIVATE-KEY
          identity_pub: SSH-PUBLIC-KEY
          known_hosts: GIT-SERVER-PUBLIC-KEYS
    EOF
    ```

2. Create a scaffolding of a Git secret, this must be added to the service account in your developer namespace in your GitOps repository. A [sample secret](https://github.com/vmware-tanzu/application-accelerator-samples/blob/main/ns-provisioner-samples/credentials/git.yaml) is available
in the vmware-tanzu/application-accelerator-samples Git repository.
Instead of putting the user name and password in the secret in your Git repository, use the `data.values.imported` keys to put the reference to the values in the git-auth secret created in step 1. For example:

    ```yaml
    #@ load("@ytt:data", "data")
    #@ load("@ytt:base64", "base64")
    ---
    apiVersion: v1
    kind: Secret
    metadata:
      name: git
      annotations:
        tekton.dev/git-0: #@ data.values.imported.git.host
    type: kubernetes.io/basic-auth
    stringData:
      username: #@ base64.encode(data.values.imported.git.username)
      password: #@ base64.encode(data.values.imported.git.token)
    ```

3. Complete the process by customizing the SupplyChain ServiceAccount for all or specific namespaces
as described in the following sections.

### Update ServiceAccount for all namespaces

Customize the SupplyChain ServiceAccount by adding additional `secrets` or `imagePullSecrets` for all namespaces managed by the Namespace Provisioner. Edit the `supply_chain_service_account` [parameter](parameters.hbs.md#namespace-parameters) in the `default_parameters` section of
the `tap-values.yaml` file. If you have a separate Service Account for delivery purposes, configure it using the `delivery_service_account` parameter. For example:

```yaml
namespace_provisioner:
  controller: true
  additional_sources:
  - git:
      ref: origin/main
      subPath: ns-provisioner-samples/credentials
      url: https://github.com/vmware-tanzu/application-accelerator-samples.git
  import_data_values_secrets:
  - name: workload-git-auth
    namespace: tap-install
    create_export: true
  default_parameters:
    supply_chain_service_account:
      secrets:
      - git
      imagePullSecrets: [] #! optional
    delivery_service_account: #! Not required, specify only if the Service account is different from the Supply chain service account.
      secrets: [] #! optional
      imagePullSecrets: [] #! optional
```

- This adds the  `git` secret to the Service Account mentioned
in `ootb_supply_chain_*.service_account`. If not specified, it takes the `default` service account.
- `additional_sources` points to the location where the templated Git secret resides which will be created in all developer namespaces.
- Import the newly created `workload-git-auth` secret into Namespace Provisioner to use in `data.values.imported` by adding the secret to the `import_data_values_secrets`.
- Add the secret to be added to the ServiceAccount in the `default_parameters`

### Update ServiceAccount for a specific namespace

To customize the SupplyChain ServiceAccount for a specific namespace managed by the Namespace Provisioner and include additional `secrets` or `imagePullSecrets`, use the `supply_chain_service_account` parameter. This [parameter](parameters.hbs.md#namespace-parameters) allows you to edit the ServiceAccount and add any required `secrets` or `imagePullSecrets`.

If you have a separate ServiceAccount for delivery purposes, you can also configure it using the `delivery_service_account` parameter.

Using Namespace Provisioner Controller
: Add the following configuration to your `tap-values.yaml` file:

    ```yaml
    namespace_provisioner:
      controller: true
      additional_sources:
      - git:
          ref: origin/main
          subPath: ns-provisioner-samples/credentials
          url: https://github.com/vmware-tanzu/application-accelerator-samples.git
      import_data_values_secrets:
      - name: workload-git-auth
        namespace: tap-install
        create_export: true
    ```

    - `additional_sources` points to the location where the templated Git secret resides which will be created in all developer namespaces.
    - Import the newly created `workload-git-auth` secret into Namespace Provisioner to use in `data.values.imported` by adding the secret to the `import_data_values_secrets`.

    Annotate the namespace with the [parameter](parameters.hbs.md#namespace-parameters) so the ServiceAccount is updated

    ```console
    kubectl annotate ns dev param.nsp.tap/supply_chain_service_account.secrets='["git"]'
    ```

    The `desired-namespaces` ConfigMap will look like:

    ```yaml
    #@data/values
    ---
    namespaces:
    - name: dev
      supply_chain_service_account:
        secrets:
        - git
    ```

    If the ServiceAccount for delivery is different, then:

    ```console
    kubectl annotate ns dev param.nsp.tap/delivery_service_account.secrets='["git"]'
    ```

    The `desired-namespaces` ConfigMap will look like:

    ```yaml
    #@data/values
    ---
    namespaces:
    - name: dev
      supply_chain_service_account:
        secrets:
        - git
      delivery_service_account:
        secrets:
        - git
    ```

Using GitOps
: Add the following configuration to your `tap-values.yaml` file:

    ```yaml
    namespace_provisioner:
      controller: false
      additional_sources:
      - git:
          ref: origin/main
          subPath: ns-provisioner-samples/credentials
          url: https://github.com/vmware-tanzu/application-accelerator-samples.git
      gitops_install:
        ref: origin/main
        subPath: ns-provisioner-samples/gitops-install-params-sa
        url: https://github.com/vmware-tanzu/application-accelerator-samples.git
      import_data_values_secrets:
      - name: workload-git-auth
        namespace: tap-install
        create_export: true
    ```

    - `additional_sources` points to the location where the templated Git secret resides which will be created in all developer namespaces.
    - Configure the desired namespaces yaml in the GitOps repository with the [parameter](parameters.hbs.md#namespace-parameters) in the namespace. Check the sample [file](https://github.com/vmware-tanzu/application-accelerator-samples/blob/main/ns-provisioner-samples/gitops-install-params-sa/desired-namespaces.yaml) where you are adding the `git` secret to the supply chain service account.
    - Import the newly created `workload-git-auth` secret into Namespace Provisioner to use in `data.values.imported` by adding the secret to the `import_data_values_secrets`.

>**Note** `create_export` is set to `true` in `import_data_values_secrets` meaning that a
SecretExport is created for the `workload-git-auth` secret in the `tap-install` namespace
automatically by Namespace Provisioner. After the changes are reconciled, the secret named **git**
is in all provisioned namespaces and is also added to the default service account of those namespaces.

## <a id='custom-lr'></a>Customize Limit Range defaults

Namespace Provisioner creates the [LimitRange](https://kubernetes.io/docs/concepts/policy/limit-range/) resources on Run clusters in all Namespace Provisioner managed namespaces. For more information, see [Default Resources](default-resources.hbs.md).

You can opt-in to have the LimitRange resource created on Full and Iterate clusters. For more
information, see [Set/Update LimitRange defaults for all namespaces](#update-lr) and [Set/Update LimitRange defaults for a specific namespace](#update-lr-specific).

Namespace Provisioner does not create LimitRange resource in Build and View clusters.

Default values in LimitRange resource are as follows:

```yaml
limits:
  default:
    cpu : 1500m
    memory : 1Gi
  defaultRequest:
    cpu : 100m
    memory : 1Gi
```

### <a id='update-lr'></a>Set or Update LimitRange defaults for all namespaces

To update the values in LimitRange for all Namespace Provisioner managed namespaces, specify  the `default_parameters` configuration in `tap-values.yaml` as follows:

```yaml
namespace_provisioner:
  default_parameters:
    # overwrite default limits set by the OOTB LimitRange (in Run Cluster) for all namespaces
    # set default limits for Full and Iterate Cluster in all namespaces
    limits:
      default:
        cpu: 1000m
        memory: 1Gi
      defaultRequest:
        cpu: 200m
        memory: 500Mi
```

### <a id='update-lr-specific'></a>Set or Update LimitRange defaults for a specific namespace

Override the LimitRange for specific namespaces as follows:

Using Namespace Provisioner Controller
: Annotate or label a namespace using the default _parameter_prefix_ `param.nsp.tap/` followed by the
YAML path to CPU or memory limits as follows:

    ```shell
    kubectl annotate ns YOUR-NEW-DEVELOPER-NAMESPACE param.nsp.tap/limits.default.cpu=1100m

    kubectl annotate ns YOUR-NEW-DEVELOPER-NAMESPACE param.nsp.tap/limits.default.memory=2Gi

    kubectl annotate ns YOUR-NEW-DEVELOPER-NAMESPACE param.nsp.tap/limits.defaultRequest.cpu=1500m

    kubectl annotate ns YOUR-NEW-DEVELOPER-NAMESPACE param.nsp.tap/limits.defaultRequest.memory=1Gi
    ```

    * The controller detects the annotations and labels with the `param.nsp.tap/` prefix, and adds the keys and values in the desired-namespace ConfigMaps as parameters for that namespace.
    * If you want the controller to search for a custom prefix, instead of  the default `param.nsp.tap`, prefix, use the `parameter_prefixes` configuration option in the tap-values.yaml file. For more information, see [Customize the label and annotation prefixes that controller watches](customize-installation.hbs.md#con-custom-label).

    >**Note** Labels take precedence over annotations if the same key is provided in both.

Using GitOps
: Add the following configuration to your `tap-values.yaml` file to add parameterized limits to your developer namespace:

    ```yaml
    namespace_provisioner:
      controller: false
      gitops_install:
        ref: origin/main
        subPath: ns-provisioner-samples/gitops-install-with-params
        url: https://github.com/vmware-tanzu/application-accelerator-samples.git
    ```

    This adds `gitops_install` with this [sample GitOps location](https://github.com/vmware-tanzu/application-accelerator-samples/tree/main/ns-provisioner-samples/gitops-install-with-params) to create the namespaces and manage the desired namespaces from GitOps. For more information, see the GitOps tab in [Customize Installation of Namespace Provisioner](customize-installation.hbs.md).

    Sample of `gitops_install` files:

    ```yaml
    #@data/values
    ---
    namespaces:
    - name: dev
      limits:
        default:
          cpu: 1200m
          memory: 1.5Gi
        defaultRequest:
          cpu: 300m
          memory: 30Mi
    - name: qa
    ```

    ```yaml
    #@ load("@ytt:data", "data")
    #! This loop will now loop over the namespace list in
    #! in ns.yaml and will create those namespaces.
    #@ for ns in data.values.namespaces:
    ---
    apiVersion: v1
    kind: Namespace
    metadata:
      name: #@ ns.name
    #@ end
    ```

    The Namespace Provisioner creates a LimitRange with default values for `qa` namespace and with
    the given values for `dev` namespace.

## <a id='deactivate-lr'></a>Deactivate LimitRange Setup

The Namespace Provisioner generates a Kubernetes LimitRange object as a
[default resource](default-resources.hbs.md) in the namespaces it manages within the Run profile clusters. Additionally, the Namespace Provisioner offers the capability for Platform operators to enable LimitRange object stamping in Full and Iterate profile clusters using namespace parameters. The following options are available to deactivate the installation of the default LimitRange object:

### Deactivate for all namespaces

To exclude the installation of the default LimitRange, set the `skip_limit_range` [parameter](parameters.hbs.md#namespace-parameters) to `true` in the `default_parameters` section of the `tap-values.yaml` file as shown here:

```yaml
namespace_provisioner:
  default_parameters:
    skip_limit_range: true
```

### Deactivate for a specific namespace

Using Namespace Provisioner Controller
: To deactivate the LimitRange for a specific developer namespace, annotate or label the namespace using the [parameter](parameters.hbs.md#namespace-parameters) `skip_grype` and set its value to `true`. Use the default or customized `parameter_prefixes`, for more information, as explained in the [Customize the label and annotation prefixes that controller watches](customize-installation.hbs.md#con-custom-label) section.

    ```console
    kubectl annotate ns YOUR-NEW-DEVELOPER-NAMESPACE param.nsp.tap/skip_limit_range=true
    ```
Using GitOps
: Add the parameter `skip_limit_range` with the value `true` in the namespaces file in the GitOps repository as shown below:

    ```yaml
    #@data/values
    ---
    namespaces:
    - name: dev
      skip_limit_range: true
      limits:
        default:
          cpu: 1200m
          memory: 1.5Gi
        defaultRequest:
          cpu: 300m
          memory: 30Mi
    - name: qa
    ```

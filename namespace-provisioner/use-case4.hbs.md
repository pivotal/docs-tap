# Customize OOTB default resources

This topic describes how to disable Grype and how to configure the `default` service account to
work with private Git repositories.

## Disable Grype install

Namespace Provisioner creates Grype scanner install as one of the [default resources](reference.md#default-resources). If you want to use another scanner for namespaces instead of Grype, disable
Grype scanner as follows:

1. Create an overlay secret as follows which removes the Grype scanner and the secret that is automatically created by Namespace Provisioner.

    ```yaml
    cat << EOF | kubectl apply -f -
    apiVersion: v1
    kind: Secret
    metadata:
      name: disable-ootb-grype-overlay
      namespace: tap-install
      annotations:
        kapp.k14s.io/change-rule: "delete after deleting tap"
    stringData:
      disable-ootb-grype-overlay.yaml: |
        #@ load("@ytt:overlay", "overlay")
        #@ def matchGrypeStuff(index, left, right):
        #@   if (left["apiVersion"] != "packaging.carvel.dev/v1alpha1" or left["kind"] != "PackageInstall") and (left["kind"] != "Secret"):
        #@     return False
        #@   end
        #@   return "metadata" in left and "name" in left["metadata"] and left["metadata"]["name"].startswith("grype-scanner")
        #@ end

        #@overlay/match by=matchGrypeStuff, expects="0+"
        ---
    EOF
    ```

2. Import this overlay secret onto Namespace Provisioner configuration so it is applied to the
resources created by Namespace Provisioner for all managed namespaces.

Using Namespace Provisioner Controller
: Add the following configuration to your TAP values

    ```yaml
    namespace_provisioner:
      controller: true
      overlay_secrets:
      - name: disable-ootb-grype-overlay
        namespace: tap-install
        create_export: true
    ```

Using GitOps
: Add the following configuration to your TAP values

    ```yaml
    namespace_provisioner:
      controller: false
      overlay_secrets:
      - name: disable-ootb-grype-overlay
        namespace: tap-install
        create_export: true
      gitops_install:
        ref: origin/main
        subPath: ns-provisioner-samples/gitops-install
        url: https://github.com/vmware-tanzu/application-accelerator-samples.git
    ```
<br>
## Customize service accounts

This section provides instructions on how to configure the `default` service account to work with
private Git repositories for workloads and supply chain using Namespace Provisioner.

To configure the service account to work with private Git repositories, follow the steps below:

1.  Create a secret in the `tap-install` namespace (or any namespace of your preference) that
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
in the vmware-tanzu/application-accelerator-samples Git repo.
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

3. Create a secret to specify an overlay to patch the default service account adding reference to the secret **git**.

    ```yaml
    cat << EOF | kubectl apply -f -
    apiVersion: v1
    kind: Secret
    metadata:
      name: workload-git-auth-overlay
      namespace: tap-install
      annotations:
        kapp.k14s.io/change-rule: "delete after deleting tap"
    stringData:
      workload-git-auth-overlay.yaml: |
        #@ load("@ytt:overlay", "overlay")
        #@overlay/match by=overlay.subset({"apiVersion": "v1", "kind": "ServiceAccount","metadata":{"name":"default"}}), expects="0+"
        ---
        secrets:
        #@overlay/append
        - name: git
    EOF
    ```

4. Put all this together in Namespace Provisioner configuration in TAP values as follows:

Using Namespace Provisioner Controller
: Add the following configuration to your TAP values

    ```yaml
    namespace_provisioner:
      controller: true
      additional_sources:
      - git:
          ref: origin/main
          subPath: ns-provisioner-samples/credentials
          url: https://github.com/vmware-tanzu/application-accelerator-samples.git
        path: _ytt_lib/credentials-setup
      import_data_values_secrets:
      - name: workload-git-auth
        namespace: tap-install
        create_export: true
      overlay_secrets:
      - name: workload-git-auth-overlay
        namespace: tap-install
        create_export: true
    ```

Using GitOps
: Add the following configuration to your TAP values

    ```yaml
    namespace_provisioner:
      controller: false
      additional_sources:
      - git:
          ref: origin/main
          subPath: ns-provisioner-samples/credentials
          url: https://github.com/vmware-tanzu/application-accelerator-samples.git
        path: _ytt_lib/credentials-setup
      gitops_install:
        ref: origin/main
        subPath: ns-provisioner-samples/gitops-install
        url: https://github.com/vmware-tanzu/application-accelerator-samples.git
      import_data_values_secrets:
      - name: workload-git-auth
        namespace: tap-install
        create_export: true
      overlay_secrets:
      - name: workload-git-auth-overlay
        namespace: tap-install
        create_export: true
    ```

- First additional source points to the location where the templated Git secret resides which is
created in all developer namespaces.
- Second additional source points to the overlay file which adds the Git secret onto the default
service account.
- Import the newly created `workload-git-auth` secret into Namespace Provisioner to use in `data.values.imported` by adding the secret to the `import_data_values_secrets`.

>**Note** `create_export` is set to `true` in `import_data_values_secrets` meaning that a
SecretExport is created for the `workload-git-auth` secret in the `tap-install` namespace
automatically by Namespace Provisioner. After the changes are reconciled, the secret named **git**
is in all provisioned namespaces and is also added to the default service account of those namespaces.

## Customize Limit Range defaults

Namespace Provisioner creates the [LimitRange](https://kubernetes.io/docs/concepts/policy/limit-range/) resources on Run clusters in all Namespace Provisioner managed namespaces. For more information, see [Default Resources](reference.md#default-resources).

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

To update the values in LimitRange for all Namespace Provisioner managed namespaces, specify  the `default_parameters` configuration in Namespace Provisioner TAP values as follows:

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

Override the LimitRange for specific namespaces follows:

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
    * If you want the controller to search for a custom prefix, instead of  the default `param.nsp.tap`, prefix, use the `parameter_prefixes` configuration option in the Namespace Provisioner TAP values values. For more information, see [Customize the label and annotation prefixes that controller watches](customize-installation.md#con-custom-label).

    >**Note** Labels take precedence over annotations if the same key is provided in both.

Using GitOps
: Add the following configuration to your TAP values to add parameterized limits to your developer namespace:

    ```yaml
    namespace_provisioner:
      controller: false
      gitops_install:
        ref: origin/main
        subPath: ns-provisioner-samples/gitops-install-with-params
        url: https://github.com/vmware-tanzu/application-accelerator-samples.git
    ```

    This adds `gitops_install` with this [sample GitOps location](https://github.com/vmware-tanzu/application-accelerator-samples/tree/main/ns-provisioner-samples/gitops-install-with-params) to create the namespaces and manage the desired namespaces from GitOps. For more information, see the GitOps tab in [Customize Installation of Namespace Provisioner](customize-installation.md).

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

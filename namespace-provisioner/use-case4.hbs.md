# Customize default resources in Namespace Provisioner

This topic tells you how to deactivate Grype in Namespace Provisioner and how to configure the `default` service account to work with private Git repositories in Tanzu Application Platform (commonly known as TAP).

## Disable Grype install

Namespace Provisioner creates Grype scanner install as one of the [default resources](reference.md#default-resources). If you choose to use another scanner for namespaces instead of Grype, you can disable the installation of the Out-of-the-box Grype scanner as follows:

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

2. Import this overlay secret onto Namespace Provisioner configuration so it gets applied to the resources created by Namespace Provisioner for all managed namespaces.

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

## Customize service accounts

This section provides instructions on how to configure the `default` service account to work with private Git repositories for workloads and supply chain using Namespace Provisioner.

To configure the service account to work with private Git repositories, follow the steps below:

1.  Create a secret in the `tap-install` namespace (or any namespace of your preference) that contains the Git credentials in the YAML format.
    - `host`, `username` and `password` values for HTTP based Git Authentication.
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

2. Create a scaffolding of a Git secret that needs to be added to the service account in your developer namespace in your GitOps repository. See the [sample secret here.](https://github.com/vmware-tanzu/application-accelerator-samples/blob/main/ns-provisioner-samples/credentials/git.yaml) An example secret would look like the following. Instead of putting the actual username and password in the secret in your Git repository, put the reference to the values in the git-auth secret created in Step 1 by using the `data.values.imported` keys.

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

- First additional source points to the location where our templated git secret resides which will be created in all developer namespaces.
- Second additional source points to the overlay file which will add the git secret onto the default service account
- Finally, import the newly created `workload-git-auth` secret into Namespace Provisioner to use in `data.values.imported` by adding the secret to the `import_data_values_secrets`.

>**Note** `create_export` is set to` true` in `import_data_values_secrets` meaning that a SecretExport will be created for the `workload-git-auth` secret in the tap-install namespace automatically by Namespace Provisioner. After the changes are reconciled, you should see the secret named **git ** in all provisioned namespaces and also added to the default service account of those namespaces.

## Customize Limit Range defaults

Namespace Provisioner creates [LimitRange](https://kubernetes.io/docs/concepts/policy/limit-range/) resource, see [Default Resources](reference.md#default-resources) in all namespaces managed by provisioner. Default values in LimitRange resource are as follows:  

```yaml
limits:
  default:
    cpu : 1500m
    memory : 1Gi
  defaultRequest:
    cpu : 100m
    memory : 1Gi
```

### Update LimitRange defaults for all namespaces

Namespace Provisioner provides options for updating the values in LimitRange for all namespaces managed by the provisioner by specifying the `default_parameters` configuration in Namespace Provisioner TAP values as follows:

```yaml
namespace_provisioner:
  default_parameters:
    # overwrite default limits set by the OOTB LimitRange for all namespaces
    limits:
      default:
        cpu: 1000m
        memory: 1Gi
      defaultRequest:
        cpu: 200m
        memory: 500Mi
```

### Update LimitRange defaults for a specific namespace

If you wish to override the LimitRange for specific namespaces, you can do that via namespace parameters that can be applied as follows.

Using Namespace Provisioner Controller
: User can annotate/label namespace using the default _parameter_prefix_ `param.nsp.tap/` followed by the YAML path to cpu or memory limits as follows:

    ```shell
    kubectl annotate ns YOUR-NEW-DEVELOPER-NAMESPACE param.nsp.tap/limits.default.cpu=1100m

    kubectl annotate ns YOUR-NEW-DEVELOPER-NAMESPACE param.nsp.tap/limits.default.memory=2Gi

    kubectl annotate ns YOUR-NEW-DEVELOPER-NAMESPACE param.nsp.tap/limits.defaultRequest.cpu=1500m

    kubectl annotate ns YOUR-NEW-DEVELOPER-NAMESPACE param.nsp.tap/limits.defaultRequest.memory=1Gi
    ```

    * Controller will look at all the annotations/labels with prefix `param.nsp.tap/` and add the keys and its values in the desired-namespace configmaps as parameters for that namespace.
    * Users can provide a custom prefix for the controller to look at if they do not want to use the default `param.nsp.tap` using parameter_prefixes configuration in Namespace Provisioner TAP values. See [Controller Customization](customize-installation.md) for more information on setting parameter_prefixes.

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

    >**Note** We added `gitops_install` with this [sample GitOps location](https://github.com/vmware-tanzu/application-accelerator-samples/tree/main/ns-provisioner-samples/gitops-install-with-params) to create the namespaces and manage the desired namespaces from GitOps. See GitOps section of [Customize Installation of Namespace Provisioner](customize-installation.md) guide for more information.

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

    The Namespace Provisioner will create a LimitRange with default values for `qa` namespace and with the given values for `dev` namespace.

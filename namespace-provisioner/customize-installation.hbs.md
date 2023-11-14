# Customize Namespace Provisioner installation

This topic tells you how to customize a standard installation of Namespace Provisioner in
Tanzu Application Platform (commonly known as TAP).

Namespace Provisioner is packaged and distributed using a set of Carvel tools.
The Namespace Provisioner package is installed as part of all the standard installation profiles
except the View profile. For more information about installation profiles, see [Installation profiles in Tanzu Application Platform](../about-package-profiles.hbs.md#profiles-and-packages).

The default set of resources provisioned in a namespace is based on a combination of the
Tanzu Application Platform installation profile employed and the supply chain that is installed on
the cluster. For a list of what resources are created for different profile and supply chain
combinations, see the [Default Resources](reference.hbs.md#default-resource) mapping table.

To see the Namespace Provisioner Package Schema for all configurable values, run:

```console
tanzu package available get namespace-provisioner.apps.tanzu.vmware.com/0.3.0 --values-schema -n tap-install
```

Different package customization options are available depending on what method you use to manage
the list of developer namespaces:

## <a id='additional-resources'></a>Add additional resources to your namespaces from your GitOps repository

   - `additional_sources`: This is an array of Git repository locations that contain Platform Operator
   templated resources to create in the provisioned namespaces, in addition to the default
   resources. The format of the Git repository locations must follow the "fetch" section of the [kapp controller App](https://carvel.dev/kapp-controller/docs/v0.43.2/app-spec/) specification, and only the Git type fetch is supported.
   - `additional_sources[].git` This entry can include a secretRef specified for providing authentication
   details for connecting to a private Git repository. For more information, see [Git Authentication for Private repository](use-case3.hbs.md#git-private). The following parameters are available:

     - `name`: The name of the secret to be imported and used as valuesFrom in kapp.
     - `namespace`: The namespace where the secret exists.
     - `create_export`:  A Boolean flag that controls the creation of a SecretExport resource in the namespace. The default value is false. If the secret is already exported, make sure that it
     is exported to the `tap-namespace-provisioning` namespace.
     - `path`: (**Optional**) This must start with the prefix `_ytt_lib/`. Namespace Provisioner
     mounts all the additional sources as a [ytt library](https://carvel.dev/ytt/docs/v0.44.0/lang-ref-ytt-library/#what-is-a-library) so it can expand the manifests in the additional
     sources for all managed namespaces using the logic in the expansion template. The path after
     the `_ytt_lib`  prefix can be any string value, and must be unique across all additional
     sources. If you do not provide a `path`, Namespace Provisioner generates a `path` using `url`
     and `subPath`.

>**Important** Namespace Provisioner relies on kapp-controller for any tasks involving communication
with external services, such as registries or Git repositories. When operating in air-gapped
environments or other scenarios where external services are secured by a Custom CA certificate,
you must configure kapp-controller with the CA certificate data to prevent
X.509 certificate errors. For more information, see [Deploy onto Cluster](https://{{ vars.staging_toggle }}.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/deploy.html#deploy-onto-cluster-5)
in the Cluster Essentials for VMware Tanzu documentation.

  If the additional sources contain a resource that is scoped to a specific namespace, it is
  created in that namespace with a modified name that includes the developer namespace name.
  For example, the resource name will be "{resource name}-{developer namespace name}".

  If the additional sources include resources without any specified namespaces, and these resources
  are not cluster-scoped, Namespace Provisioner creates those resources in all of the namespaces it
  manages. However, if the resource is cluster-scoped, only a single instance of the resource is
  created.

Sample `tap-values.yaml` configuration:

Using Namespace Provisioner Controller
: The Git repository is configured under `additional_sources`.

  ```yaml
  namespace_provisioner:
    controller: true
    additional_sources:
    - git:
        ref: origin/main
        subPath: ns-provisioner-samples/testing-scanning-supplychain
        url: https://github.com/vmware-tanzu/application-accelerator-samples.git
        # secretRef section is only needed if connecting to a Private Git repo
        secretRef:
          name: git-auth
          namespace: tap-install
          create_export: true
      path: _ytt_lib/testing-scanning-supplychain-setup
  ```

Using GitOps
: The Git repository is configured under `additional_sources`.

  ```yaml
  namespace_provisioner:
    controller: false
    additional_sources:
    - git:
        ref: origin/main
        subPath: ns-provisioner-samples/testing-scanning-supplychain
        url: https://github.com/vmware-tanzu/application-accelerator-samples.git
        # secretRef section is only needed if connecting to a Private Git repo
        secretRef:
          name: git-auth
          namespace: tap-install
          create_export: true
      path: _ytt_lib/testing-scanning-supplychain-setup
    gitops_install:
      ref: origin/main
      subPath: ns-provisioner-samples/gitops-install
      url: https://github.com/vmware-tanzu/application-accelerator-samples.git
  ```

If a path is not specified in the `additional_sources` configuration, Namespace Provisioner
automatically generates a path as follows: `_ytt_lib/applicaton-accelerator-samples-git-ns-provisioner-samples-testing-scaning-supplychain-0`

For more information, see [Git Authentication for Private repository](use-case3.md#git-private).

## <a id='adjust-sync'></a>Adjust sync period of Namespace Provisioner

The `sync_period` parameter is the interval at which the Namespace Provisioner reconciles.
It must be specified in the format of time + unit. The minimum allowed `sync_period` is 30 seconds.
If a value lower than 30 seconds is specified in the `tap-values.yaml` file, Namespace Provisioner
automatically sets the `sync_period` to 30 seconds. If no value is specified, the default `sync_period` is `1m0s`.

Sample `tap-values.yaml` configuration:

Using Namespace Provisioner Controller
: Use the `sync_period` key.

  ```yaml
  namespace_provisioner:
    sync_period: 2m0s
  ```

Using GitOps
: Use the `sync_period` key.

  ```yaml
  namespace_provisioner:
    controller: false
    sync_period: 1m0s
    gitops_install:
      ref: origin/main
      subPath: ns-provisioner-samples/gitops-install
      url: https://github.com/vmware-tanzu/application-accelerator-samples.git
  ```

## <a id='import-user-defined'></a>Import user defined secrets in YAML format as ytt data.values

The `import_data_values_secrets` is an array of additional secrets in YAML format that can be
imported into the Namespace Provisioner as data.values under the `data.values.imported` key.
Namespace Provisioner creates a SecretImport for each secret listed in the array in the `tap-namespace-provisioning` namespace. Alternatively, you can manually create a SecretExport for
the same secrets and export them to the `tap-namespace-provisioning` namespace.
The following parameters are available:

- `name`: The name of the secret to be imported to use as valuesFrom in kapp.
- `namespace`: The namespace where the secret exists.
- `create_export`:  A Boolean flag that indicates whether a `SecretExport` resource is
created in the namespace. The default value is `false`. If the secret is already exported, ensure
that it is exported to the `tap-namespace-provisioning` namespace.

>**Note** The `stringData` key of the secret must have .`yaml` or .`yml` suffix.

 Example secret:

```yaml
# Format of the secret that is importable under data.values.imported
apiVersion: v1
kind: Secret
metadata:
  name: user-defined-secrets
type: Opaque
stringData:
  # Key needs to have .yaml or .yml at the end
  content.yaml: |
    key1: value1
    key2: value2
```

Sample `tap-values.yaml` configuration:

Using Namespace Provisioner Controller
: The list of secrets are imported under `import_data_values_secrets`.

  ```yaml
  namespace_provisioner:
    controller: true
    import_data_values_secrets:
    - name: user-defined-secrets
      namespace: tap-install
      create_export: true
  ```

Using GitOps
: The list of secrets are imported under `import_data_values_secrets`.

  ```yaml
  namespace_provisioner:
    controller: false
    import_data_values_secrets:
    - name: user-defined-secrets
      namespace: tap-install
      create_export: true
    gitops_install:
      ref: origin/main
      subPath: ns-provisioner-samples/gitops-install
      url: https://github.com/vmware-tanzu/application-accelerator-samples.git
  ```

## <a id='use-aws-iam'></a>Use AWS IAM roles

If you are installing Tanzu Application Platform on Amazon Elastic Kubernetes Service (EKS), you
can use the IAM Role specified in `aws_iam_role_arn` to configure the Kubernetes service account
used by the workload and the supply chain components.

Sample `tap-values.yaml` configuration:

Using Namespace Provisioner Controller
: Add the AWS IAM Role to `aws_iam_role_arn`.

  ```yaml
  namespace_provisioner:
    controller: yes
    aws_iam_role_arn: "arn:aws:iam::123456789012:role/EKSIAMRole"
  ```

Using GitOps
: Add the AWS IAM Role to `aws_iam_role_arn`.

  ```yaml
  namespace_provisioner:
    controller: false
    aws_iam_role_arn: "arn:aws:iam::123456789012:role/EKSIAMRole"
    gitops_install:
      ref: origin/main
      subPath: ns-provisioner-samples/gitops-install
      url: https://github.com/vmware-tanzu/application-accelerator-samples.git
  ```

## <a id='apply-default-params'></a>Apply default parameters to all namespaces

The `default_parameters` is an array of parameters that are applied to all namespaces. Use these
parameters as ytt, such as  `data.values.default_parameters` for templating default and
additional resources.

Sample `tap-values.yaml` configuration:

Using Namespace Provisioner Controller
: Use the `default_parameters` with the desired parameter.

  ```yaml
  namespace_provisioner:
    controller: yes
    default_parameters:
      limits:
        default:
          cpu: 1.7
          memory: 1Gi
        defaultRequest:
          cpu: 100m
          memory: 1Gi
  ```

Using GitOps
: Use the `default_parameters` with the desired parameter.

  ```yaml
  namespace_provisioner:
    controller: false
    default_parameters:
      limits:
        default:
          cpu: 1.7
          memory: 1Gi
        defaultRequest:
          cpu: 100m
          memory: 1Gi
    gitops_install:
      ref: origin/main
      subPath: ns-provisioner-samples/gitops-install
      url: https://github.com/vmware-tanzu/application-accelerator-samples.git
  ```

## <a id='import-overlay-secrets'></a> Import overlay secrets

The `overlay_secrets` is a list of secrets that contains [Carvel ytt overlay](https://carvel.dev/ytt/docs/latest/lang-ref-ytt-overlay/) definitions. These overlays are applied to the resources created by the Namespace Provisioner. If the secrets are located in a different namespace, they are imported to the `namespace-provisioner` namespace.

>**Note** The `stringData` key of the secret must have .`yaml` or .`yml` suffix.

Sample secret with overlay to be used:

  ```yaml
  cat << EOF | kubectl apply -f -
  apiVersion: v1
  kind: Secret
  metadata:
    name: grype-package-overlay
    namespace: tap-install
    annotations:
      kapp.k14s.io/change-rule: "delete after deleting tap"
  stringData:
    grype-package-overlay.yaml: |
      #@  load("@ytt:overlay", "overlay")
      #@
      #@  def matchGrypeScanners(index, left, right):
      #@    if left["apiVersion"] != "packaging.carvel.dev/v1alpha1" or left["kind"] != "PackageInstall":
      #@      return False
      #@    end
      #@    return "metadata" in left and "name" in left["metadata"] and left["metadata"]["name"].startswith("grype-scanner")
      #@  end

      #@overlay/match by=matchGrypeScanners, expects="0+"
      ---
      metadata:
        annotations:
          #@overlay/match expects="0+"
          ext.packaging.carvel.dev/ytt-paths-from-secret-name.0: my-grype-overlay-secret
  EOF
  ```

Sample `tap-values.yaml` configuration:

Using Namespace Provisioner Controller
: The list of secrets with the overlay are set under `overlay_secrets`.
  ```yaml
  namespace_provisioner:
    controller: true
    overlay_secrets:
    - name: grype-package-overlay
      namespace: tap-install
      create_export: true
  ```

Using GitOps
: The list of secrets with the overlay are set under `overlay_secrets`.

  ```yaml
  namespace_provisioner:
    controller: false
    overlay_secrets:
    - name: grype-package-overlay
      namespace: tap-install
      create_export: true
    gitops_install:
      ref: origin/main
      subPath: ns-provisioner-samples/gitops-install
      url: https://github.com/vmware-tanzu/application-accelerator-samples.git
  ```

Furthermore, you have the following options for customization:

Options if using Controller
: If you are using the controller to manage the list of developer namespaces, you have the following additional customization options available:

   - [Use a different label selector than default](#con-label-selector)
   - [Override the default CPU and memory limits for controller pods](#con-override-cpu)
   - [Customize the label and annotation prefixes that controller watches](#con-custom-label)

   **<a id='con-label-selector'></a>Use a different label selector than default**

   Use the `namespace_selector` to specify the [label selector](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#label-selectors) used by the [controller](about.hbs.md#nsp-controller) to identify the namespaces that will be included in the [desired-namespaces](about.hbs.md#desired-ns) ConfigMap.

   Sample `tap-values.yaml` configuration:

   ```yaml
   namespace_provisioner:
     controller: true
     namespace_selector:
       matchExpressions:
       - key: apps.tanzu.vmware.com/tap-ns
         operator: Exists
   ```

   **<a id='con-override-cpu'></a>Override the default CPU and memory limits for controller pods**

   To configure the compute resources for the Namespace Provisioner controllers, you can use the `controller_resources` section in the Namespace Provisioner configuration in `tap-values.yaml`.

   To set the maximum CPU and memory limits for the controllers, edit the `controller_resources.resources.limits.cpu` and `controller_resources.resources.limits.memory` values.

   Similarly, you can configure the minimum CPU capacity and memory requests for the controllers by
   adjusting the `controller_resources.resources.requests.cpu` and `controller_resources.resources.requests.memory` settings.

   Sample `tap-values.yaml` configuration:

   ```yaml
   namespace_provisioner:
     controller: true
     controller_resources:
       resources:
         limits:
           cpu: 500m
           memory: 100Mi
         requests:
           cpu: 100m
           memory: 20Mi
   ```
   **<a id='con-custom-label'></a>Customize the label and annotation prefixes that controller watches**

   The `parameter_prefixes` is an array of label and annotation prefixes that the Namespace Provisioner controller uses to identify and include namespace-specific parameters in the [desired-namespaces](about.hbs.md#desired-ns) ConfigMap. These parameters can then be used as ytt data.values for templating both default and additional resources.

   For example, if the value `tap.tanzu.vmware.com` is specified in `parameter_prefixes`, the
   Namespace Provisioner controller searches for annotations or labels in a provisioned namespace
   that begin with the prefix `tap.tanzu.vmware.com/`. It extracts those annotations or labels and
   uses them as parameters for further configuration and customization.

   Sample `tap-values.yaml` configuration:

   ```yaml
   namespace_provisioner:
     controller: yes
     parameter_prefixes:
     - tmc.cloud.vmware.com
     - tap.tanzu.vmware.com
   ```

Options if using GitOps
: If you are using GitOps to manage the list of developer namespaces, you have the following
customization option:

   **<a id ='git-install'></a>Use GitOps to manage developer namespaces list**

   `gitops_install` is a Git repository configuration with the list of namespaces to be provisioned.

   Only use the gitops_install section when `controller: false` is set. If this section
   is used in conjunction with `controller: true`, the Namespace Provisioner package fails to
   reconcile, resulting in an error message stating `controller: false when using 'gitops_install' in provided values`.

   Files in the Git repository must have a .`yaml` or .`yml` extension.

   The `gitops_install` section can have the following entries:

   - `url`: The Git repository URL (required)
   - `subPath`: The Git repository subpath where the file is
   - `ref`: The Git repository reference, the default is origin/main
   - `secretRef`: If the repository needs authentication, the reference to the secret is set here
      - `name`: The name of the secret to be used for the repository authentication, see [Git Authentication for Private repository](use-case3.hbs.md#git-private).
      - `namespace`: The namespace where the secret is created. Namespace Provisioner creates a Carvel secretgen [SecretImport](https://github.com/carvel-dev/secretgen-controller/blob/develop/docs/secret-export.md#secretimport) from this namespace to the Namespace Provisioner namespace.
      - `create_export`: A Boolean flag to create a Carvel secretgen [SecretExport](https://github.com/carvel-dev/secretgen-controller/blob/develop/docs/secret-export.md#secretexport) from the given namespace to Namespace Provisioner namespace. The default value is `false`.

     Sample `gitops_install` repository file:

     > **Note** The Carvel data header (#@data/values) is required in this file.

   ```yaml
   #@data/values
   ---
   namespaces:
   - name: dev
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

   This file in the sample repository creates the namespaces in the namespaces list so no manual
   intervention is required.

   Sample `tap-values.yaml` configuration:

   ```yaml
   namespace_provisioner:
     controller: false
     gitops_install:
       ref: origin/main
       subPath: ns-provisioner-samples/gitops-install
       url: https://github.com/vmware-tanzu/application-accelerator-samples.git
   ```

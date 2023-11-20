# Customize Namespace Provisioner installation

This topic tells you how to customize a standard installation of Namespace Provisioner in Tanzu Application Platform (commonly known as TAP).

Namespace Provisioner is packaged and distributed using a set of Carvel tools.
The Namespace Provisioner package is installed as part of all the standard installation profiles
except the View profile. For more information about installation profiles, see [Installation profiles in Tanzu Application Platform](../about-package-profiles.hbs.md#profiles-and-packages).

The default set of resources provisioned in a namespace is based on a combination of the Tanzu Application Platform installation profile employed and the supply chain that is installed on the cluster. For a list of what resources are created for different profile and supply chain combinations, see the [Default Resources](reference.md#default-resource) mapping table.

To see the Namespace Provisioner Package Schema for all configurable values, run:

```shell
tanzu package available get namespace-provisioner.apps.tanzu.vmware.com/0.3.0 --values-schema -n tap-install
```

Different package customization options are available depending on what method you use to manage the list of developer namespaces:

Options if using Controller
:

  The following customization options are available if you are using the controller to manage the list of developer namespaces:

  - [Add additional resources to your namespaces from your GitOps repository](#con-add-additional)
  - [Adjust sync period of Namespace Provisioner](#con-adjust-sync)
  - [Import user defined secrets in YAML format as ytt data.values](#con-import-secret)
  - [Use a different label selector than default](#con-label-selector)
  - [Override default CPU and memory limits for controller pods](#con-override-cpu)
  - [Use AWS IAM roles](#con-support-iam)
  - [Apply default parameters to all namespaces](#con-default-param)
  - [Customize the label and annotation prefixes that controller watches](#con-custom-label)
  - [Import Overlay secrets](#con-import-overlay)

  **<a id ='con-add-additional'></a>Add additional resources to your namespaces from your GitOps repository**

   - `additional_sources` is an array of Git repository locations that contain Platform Operator
   templated resources to create in the provisioned namespaces, in addition to the default
   resources. See the “fetch” section of the [kapp controller App](https://carvel.dev/kapp-controller/docs/v0.43.2/app-spec/) specification for the format. Only the Git type fetch is supported.
   - `additional_sources[].git` can have a secretRef specified for providing authentication details for
   connecting to a private Git repository. For more information, see [Git Authentication for Private repository](use-case3.md#git-private). The following parameters are available:

     - `name`: name of the secret to be imported to use as valuesFrom in kapp.
     - `namespace`: namespace where the secret exists.
     - `create_export`:  Boolean flag to control creation of a SecretExport resource in the namespace. The default value is false. If the secret is already exported, ensure that it is exported to the `tap-namespace-provisioning` namespace.
     - `path` must start with the prefix `_ytt_lib/`. Namespace Provisioner mounts all the additional sources as a [ytt library](https://carvel.dev/ytt/docs/v0.44.0/lang-ref-ytt-library/#what-is-a-library) so it can expand the manifests in the additional sources for all managed namespaces using the logic in the expansion template. The path after the `_ytt_lib`  prefix can be any string value, and must be unique across all additional sources.

>**Important** Namespace Provisioner relies on kapp-controller for any tasks involving communication
with external services, such as registries or Git repositories. When operating in air-gapped
environments or other scenarios where external services are secured by a Custom CA certificate,
you must configure kapp-controller with the CA certificate data to prevent
X.509 certificate errors. For more information, see [Deploy onto Cluster](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/1.5/cluster-essentials/deploy.html#deploying-cluster-essentials-v156-0)
in the Cluster Essentials for VMware Tanzu documentation.

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

   See [Git Authentication for Private repository](use-case3.md#git-private).

   **<a id ='con-adjust-sync'></a>Adjust sync period of Namespace Provisioner**

  `sync_period` defines the wait time for the Namespace Provisioner to reconcile. `sync_period` is specified in time + unit format. The minimum `sync_period` allowed is 30 seconds. Namespace Provisioner sets the `sync_period` value to `30s` if a lesser value is specified in TAP values. If not specified, the value defaults to `1m0s`.

   Sample TAP values configuration:

  ```yaml
  namespace_provisioner:
    sync_period: 2m0s
  ```

   **<a id ='con-import-secret'></a>Import user defined secrets in YAML format as ytt data.values**

  `import_data_values_secrets` is an array of additional secrets in YAML format to import in the
   provisioner as data.values under the `data.values.imported` key. SecretImport for the secrets
   listed in the array is created in the `tap-namespace-provisioning` namespace by the Namespace
   Provisioner package. Either, create SecretExport for the same secrets manually
   and export it to the `tap-namespace-provisioning` namespace, or let the Namespace
   Provisioner package create it. The following parameters are available:

   - `name`: Name of the secret to be imported to use as valuesFrom in kapp.
   - `namespace`: Namespace where the secret exists.
   - `create_export`:  Boolean flag to decide creation of a SecretExport resource in the
    namespace. The default value is `false`. If the secret is already exported,
    ensure that it is exported for the `tap-namespace-provisioning` namespace. 
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

  Sample TAP values configuration:

  ```yaml
  namespace_provisioner:
    controller: true
    import_data_values_secrets:
    - name: user-defined-secrets
      namespace: tap-install
      create_export: true
  ```

   **<a id= 'con-label-selector'></a>Use a different label selector than default**

   `namespace_selector` defines the [label selector](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#label-selectors) used by the [controller](about.hbs.md#nsp-controller) to determine which namespaces should be added to the [desired-namespaces](about.hbs.md#desired-ns) ConfigMap.

   Sample TAP values configuration:

  ```yaml
  namespace_provisioner:
    controller: true
    namespace_selector:
      matchExpressions:
      - key: apps.tanzu.vmware.com/tap-ns
        operator: Exists
  ```

   **<a id= 'con-override-cpu'></a>Override default CPU and memory limits for controller pods**

  Use the `controller_resources` section in Namespace Provisioner configuration in TAP values to configure Namespace Provisioner Compute Resources controllers.

  Set `controller_resources.resources.limits.cpu` and `controller_resources.resources.limits.memory` to configure the maximum CPU and memory available for the controller.

  Similarly, set `controller_resources.resources.requests.cpu` and `controller_resources.resources.requests.memory` to configure the minimum CPU capacity and memory available for the controller.

   Sample TAP values configuration:

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

   **<a id='con-support-iam'></a>Use AWS IAM roles**

   If the TAP installation is on AWS with EKS, use the IAM Role from `aws_iam_role_arn` for the Kubernetes Service Account that is used by Workload and the Supply chain to create resources.
   
   Sample TAP values configuration:

  ```yaml
  namespace_provisioner:
    controller: yes
    aws_iam_role_arn: "arn:aws:iam::123456789012:role/EKSIAMRole"
  ```

   **<a id='con-default-param'></a>Apply default parameters to all namespaces**

   `default_parameters` is an array of parameters applied to all namespaces which can be used as ytt (`data.values.default_parameters`) for templating default and additional resources.

   Sample TAP values configuration:

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

   **<a id='con-custom-label'></a>Customize the label and annotation prefixes that controller watches**

   `parameter_prefixes` is an array of label/annotation prefixes the controller looks for to add namespace specific parameters into the [desired-namespaces](about.hbs.md#desired-ns) ConfigMap which can be used as ytt data.values for templating default and additional resources. For example, the value `tap.tanzu.vmware.com` tells the Namespace Provisioner controller to look for the annotations/labels on a provisioned namespace that start with the prefix `tap.tanzu.vmware.com/` and use those as parameters.

   Sample TAP values configuration:

  ```yaml
  namespace_provisioner:
    controller: yes
    parameter_prefixes:
    - tmc.cloud.vmware.com
    - tap.tanzu.vmware.com
  ```

   **<a id='con-import-overlay'></a>Import overlay secrets**

  `overlay_secrets` is a list of secrets which contains [Carvel ytt overlay](https://carvel.dev/ytt/docs/latest/lang-ref-ytt-overlay/) definitions that are applied to the resources created by the Namespace Provisioner. The secrets are imported to `namespace-provisioner` namespace if it is in another namespace. 
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

   Sample TAP values configuration:

  ```yaml
  namespace_provisioner:
    controller: true
    overlay_secrets:
    - name: grype-package-overlay
      namespace: tap-install
      create_export: true
  ```

Options if using GitOps
:
  The following customization options are available if you are using GitOps to manage the developer namespaces list:

  - [Use GitOps to manage developer namespaces list](#git-install)
  - [Add additional resources to your namespace from your GitOps repo](#git-add-resources)
  - [Adjust sync period of Namespace Provisioner](#git-adjust-sync)
  - [Import user defined secrets in YAML format as ytt data.values](#git-import-user)
  - [Use for AWS IAM roles](#git-use-iam)
  - [Apply default parameters to all namespaces](#git-default-param)
  - [Import overlay secrets](#git-import)

  **<a id ='git-install'></a>Use GitOps to manage developer namespaces list**

  `gitops_install` is a Git repository configuration with the list of namespaces to be provisioned.

  The `gitops_install` section must be used only when `controller: false` is set or else the Namespace Provisioner package fails to reconcile with the following error message: `controller: false when using 'gitops_install' in provided values`.

  Files in the Git repository must have a .`yaml` or .`yml` extension.

  The `gitops_install` section can have the following entries:

  - `url`: the Git repository URL (mandatory)
  - `subPath`: the Git repository subpath where the file is
  - `ref`: the Git repository reference, the default is origin/main
  - `secretRef`: if the repository needs authentication, the reference to the secret is set here
     - `name`: the name of the secret to be used for the repository authentication, see [Git Authentication for Private repository](use-case3.md#git-private).
     - `namespace`: the namespace where the secret is created. Namespace Provisioner creates a Carvel secretgen [SecretImport](https://github.com/carvel-dev/secretgen-controller/blob/develop/docs/secret-export.md#secretimport) from this given namespaces to Namespace Provisioner namespace.
     - `create_export`: Boolean flag to create a Carvel secretgen [SecretExport](https://github.com/carvel-dev/secretgen-controller/blob/develop/docs/secret-export.md#secretexport) from the given namespace to Namespace Provisioner namespace. The default value is `false`.
     
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

  This file in the sample repository creates the namespaces in the namespaces list so no manual intervention is required.

  Sample TAP values configuration:

  ```yaml
  namespace_provisioner:
    controller: false
    gitops_install:
      ref: origin/main
      subPath: ns-provisioner-samples/gitops-install
      url: https://github.com/vmware-tanzu/application-accelerator-samples.git
  ```

  **<a id ='git-add-resources'></a>Add additional resources to your namespace from your GitOps repo**

   - `additional_sources` is an array of locations of your Git repositories that contain Platform Operator templated resources to be created on the provisioned namespaces, in addition to the default resources.
   - See the "fetch" section of the  [kapp controller App](https://carvel.dev/kapp-controller/docs/v0.43.2/app-spec/) specification  for the format. Only the Git type fetch is supported.
   - `additional_sources[].git` can have secretRef specified for providing authentication details for connecting to a private Git repository. See [Git Authentication for Private repository](use-case3.md#git-private) for more details. The following parameters are available:

      - `name`: name of the secret to be imported to use as valuesFrom in kapp.
      - `namespace`: namespace where the secret exists.
      - `create_export`: Boolean flag to decide creation of a SecretExport resource in the namespace. The default value is `false`. If the secret is already exported, ensure that it is exported for the `tap-namespace-provisioning` namespace.
   - `path` must start with the prefix `_ytt_lib/`. Namespace Provisioner mounts all the additional sources as a [ytt library](https://carvel.dev/ytt/docs/v0.44.0/lang-ref-ytt-library/#what-is-a-library) so it can expand the manifests in the additional sources for all managed namespaces using the logic in the expansion template. The path after the `_ytt_lib` prefix can be any string value and must be unique across all additional sources.

  Sample TAP values configuration:

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

  See [Git Authentication for using a private Git repository](use-case3.md#git-private) guide.

  **<a id ='git-adjust-sync'></a>Adjust sync period of Namespace Provisioner**

  `sync_period` defines the wait time for the Namespace Provisioner to reconcile. `sync_period` is specified in time + unit format. If a value less than 30 seconds is specified, it defaults to 30 seconds. If not specified, the value defaults to `1m0s`.

  Sample TAP values configuration:

  ```yaml
  namespace_provisioner:
    sync_period: 1m0s
  ```

  **<a id ='git-import-user'></a>Import user defined secrets in YAML format as ytt data.values**

  `import_data_values_secrets` is an array of additional secrets in YAML format to import in the provisioner as data.values under the `data.values.imported` key. SecretImport for the secrets listed in the array are created in the `tap-namespace-provisioning` namespace by the Namespace Provisioner package. Either, create SecretExport for the same secrets manually and export it to `tap-namespace-provisioning` namespace or let the Namespace Provisioner package create it. Parameters include:

  - `name`: Name of the secret to be imported to use as valuesFrom in kapp.
  - `namespace`: Namespace where the secret exists.
  - `create_export`:  Boolean flag to decide creation of a SecretExport resource in the namespace. The default value is `false`. If the secret is already exported, ensure that it is exported for the `tap-namespace-provisioning` namespace. 
  
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

  Sample TAP values configuration:

  ```yaml
  namespace_provisioner:
    controller: false
    import_data_values_secrets:
    - name: user-defined-secrets
      namespace: tap-install
      create_export: true
  ```

  **<a id ='git-use-iam'></a>Use for AWS IAM roles**

  If the TAP installation is on AWS with EKS, use the IAM Role from `aws_iam_role_arn` for the Kubernetes Service Account that is used by Workload and the Supply chain to create resources.

  Sample TAP values configuration:

  ```yaml
  namespace_provisioner:
    controller: false
    aws_iam_role_arn: "arn:aws:iam::123456789012:role/EKSIAMRole"
  ```

  **<a id ='git-default-param'></a>Apply default parameters to all namespaces**

  `Default_parameters` is an array of parameters applied to all namespaces which can be used as ytt (`data.values.default_parameters`) for templating default and additional resources.

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
  ```

  **<a id ='git-import'></a>Import Overlay secrets**

  `overlay_secrets` is a list of secrets which contains [Carvel ytt overlay](https://carvel.dev/ytt/docs/latest/lang-ref-ytt-overlay/) definitions that are applied to the resources created by the Namespace Provisioner. The secrets are imported to the `namespace-provisioner` namespace if it is in another namespace. 
  >**Note** The `stringData` key of the secret must have .`yaml` or .`yml` suffix.

  Sample secret with overlay to be used

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

  Sample TAP values configuration:

  ```yaml
  namespace_provisioner:
    controller: false
    overlay_secrets:
    - name: grype-package-overlay
      namespace: tap-install
      create_export: true
  ```

# Customize Installation (WIP)

Namespace Provisioner is packaged and distributed using a set of Carvel tools.

The Namespace Provisioner package is installed as part of all the standard installation profiles
except the view profile. The default set of resources provisioned in a namespace is based on a
combination of the Tanzu Application Platform installation profile employed and the supply chain
that is installed on the cluster. For a list of what resources are created for different profile
and supply chain combinations, see the [Default Resources](reference.md#default-resource) mapping table.

To see the Namespace Provisioner Package Schema for all configurable values, run the following command:

```console
tanzu package available get namespace-provisioner.apps.tanzu.vmware.com/0.3.0 --values-schema -n tap-install
```

Different package customization options are available depending on what is used to manage the list
of developer namespaces:

Options if using Controller
: Add additional resources to your namespace(s) from your GitOps repo

   - additional_sources is an array of Git repository locations which contain Platform Operator
   templated resources to be created in the provisioned namespaces, in addition to the default
   resources that are shipped with Tanzu Application Platform.
   - See the “fetch” section of the kapp controller App specification section for the format.
   Only the Git type fetch is supported.
   - additional_sources[].git can have a secretRef specified for providing auth details for
   connecting to a private Git repository, see [Git Authentication for Private repository](use-case3.md) for more details. It accepts name, namespace and create_export parameters as shown in the example below.
   name: Name of the secret to be imported to use as valuesFrom in kapp.
   namespace: Namespace where the secret exists.
   create_export:  Boolean flag to control creation of a SecretExport resource in the namespace mentioned above. Default value is false. If the Secret is already exported, make sure it is exported to tap-namespace-provisioning namespace for this feature to work.
   - path needs to start with the prefix _ytt_lib/. Namespace Provisioner mounts all the additional sources as a ytt library so it can expand the manifests in the additional sources for all managed namespaces using the logic in the expansion template. The path after the _ytt_lib prefix should be unique across all additional sources but it can be any string value.

   Sample TAP values configuration:

   ```console
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

   See [Git Authentication for Private repository](use-case3.md).

   ## Adjust sync period of Namespace Provisioner

   - sync_period defines the wait time for the provisioner to reconcile. sync_period is specified in time + unit format. The minimum sync_period allowed is 30 seconds. Namespace Provisioner will set the sync_period value to 30s if a lesser value is specified in TAP values. If not specified, value is defaulted to 1m0s.

   Sample TAP values configuration:

  ```console
   namespace_provisioner:
     sync_period: 2m0s
   ```

   ## Import user defined secrets in YAML format as ytt data.values

   - import_data_values_secrets is an array of additional secrets in YAML format to import in the
   provisioner as data.values under the data.values.imported key. SecretImport for the secrets
   listed in the array will be created in tap-namespace-provisioning namespace by the Namespace
   Provisioner package. Users have a choice to create SecretExport for the same secrets manually
   and export it to tap-namespace-provisioning namespace, or more broadly, let the namespace
   provisioner package create it for them.

   Parameters include:

   - name: Name of the secret to be imported to use as valuesFrom in kapp.
   - namespace: Namespace where the secret exists.
   - create_export:  Boolean flag to decide creation of a SecretExport resource in the
    namespace mentioned above. Default value is false. If the Secret is already exported by user,
    make sure it is exported for tap-namespace-provisioning namespace for this feature to work.

   >**Note** stringData key of the secret must have .yaml or .yml suffix at the end.

   Example secret:

    ```console
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

    ```console
      namespace_provisioner:
        controller: true
        import_data_values_secrets:
        - name: user-defined-secrets
          namespace: tap-install
          create_export: true
    ```

   ## Use a different label selector than default

   namespace_selector defines the label selector used by the controller to determine which namespaces should be added to the desired-namespaces ConfigMap.

   Sample TAP values configuration:

   namespace_provisioner:
     controller: true
     namespace_selector:
       matchExpressions:
       - key: apps.tanzu.vmware.com/tap-ns
         operator: Exists

   ## Override default CPU and memory limits for controller pods

   Compute Resources of Namespace Provisioner controllers are configurable using the controller_resources section in Namespace Provisioner configuration in TAP values.
   By setting controller_resources.resources.limits.cpu and controller_resources.resources.limits.memory one can configure the maximum cpu and memory that are allowed for the controller to use.
   Similarly, by setting controller_resources.resources.requests.cpu and controller_resources.resources.requests.memory one can configure the minimum cpu capacity and memory available for the controller.

   Sample TAP values configuration:

  ```console
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

   ## Support for AWS IAM roles

   If the TAP installation is on AWS with EKS, use the IAM Role from aws_iam_role_arn for the Kubernetes Service Account that is used by Workload and the Supply chain to create resources.
   Sample TAP values configuration:

    ```console
    namespace_provisioner:
      controller: yes
      aws_iam_role_arn: "arn:aws:iam::123456789012:role/EKSIAMRole"
    ```

   ## Default parameters to all namespaces

   default_parameters is an array of parameters applied to all namespaces which can be used as ytt (data.values.default_parameters) for templating default and additional resources.

   Sample TAP values configuration:

  ```console
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

   ## Customize label/annotation prefixes that controller watches

   - parameter_prefixes is an array of label/annotation prefixes the controller will look for to add namespace specific parameters into the desired-namespaces ConfigMap which can be used as ytt data.values for templating default and additional resources.
   - For Example the value tap.tanzu.vmware.com tells the Namespace Provisioner controller to look for the annotations/labels on a provisioned namespace that start with the prefix tap.tanzu.vmware.com/ and use those as parameters.

   Sample TAP values configuration:

   ```console
   namespace_provisioner:
     controller: yes
     parameter_prefixes:
     - tmc.cloud.vmware.com
     - tap.tanzu.vmware.com
   ```

   ## Import Overlay secrets

   - overlay_secrets is a list of secrets which contains carvel ytt overlay definitions that are applied to the resources created by the Namespace Provisioner. The secrets will be imported to namespace-provisioner namespace if it is in another namespace.

   >**Note** stringData key of the secret should have .yaml or .yml suffix at the end.

   Sample secret with overlay to be used

   ```console
   cat << EOF | kubectl apply -f -
   apiVersion: v1
   kind: Secret
   metadata:
    name: grype-package-overlay
    namespace: tap-install
    annotations:
      kapp.k14s.io/change-rule: "delete after deleting tap"
   stringData:
     package_overlay.yaml: |
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
  ```

   Sample TAP values configuration:

   ```console
   namespace_provisioner:
    controller: true
    overlay_secrets:
    - name: grype-package-overlay
      namespace: tap-install
      create_export: true
  ```

Options if using GitOps
: Use GitOps to manage developer namespaces list. `gitops_install` is a git repository configuration
  with the list of namespaces to be provisioned.

     - The gitops_install section may have the following entries:
         - url: the git repository url (mandatory)
         - subPath: the git repository subpath where the file is
         - ref: the git repository reference, default is origin/main
         - secretRef: if the repository needs authentication, the reference to the secret is set here
             - name: the name of the secret to be used for the repository authentication, see [Git Authentication for Private repository](use-case3.md) for more details.
             - namespace: the namespace where the secret is created. Namespace Provisioner will create a carvel secretgen SecretImport from this given namespaces to Namespace Provisioner namespace.
             - create_export: boolean flag to create a carvel secretgen SecretExport from the given namespace to Namespace Provisioner namespace, default value is false
     - The gitops_install section must be used only when controller: false or else the package will fail reconciliation with error message set `controller: false` when using `gitops_install` in provided values.
     - Files in the git repository must have a yaml or yml extension

     Sample gitops_install repo file:

     > **Note** Require carvel data header (#@data/values) in the file.

     ```console
     #@data/values
     ---
     namespaces:
     - name: dev
     - name: qa



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

     This file in the sample repo will create the namespaces in the namespaces list so no manual
     intervention is required

     Sample TAP values configuration:

     ```console
     namespace_provisioner:
       controller: false
       gitops_install:
         ref: origin/main
         subPath: ns-provisioner-samples/gitops-install
         url: https://github.com/vmware-tanzu/application-accelerator-samples.git
     ```

    ## Add additional resources to your namespace from your GitOps repo

     - additional_sources is an array of locations of your Git repositories which contain Platform Operator templated resources to be created on the provisioned namespaces, in addition to the default resources that are shipped with Tanzu Application Platform.
     - See the fetch section of the kapp controller App specification section for the format. Only the Git type fetch is supported.
     - additional_sources[].git can have secretRef specified for providing auth details for connecting to a private git repository see [Git Authentication for Private repository](use-case3.md) for more details. It accepts name, namespace of the secrets and create_export parameters as shown in the example below.
         - name: Name of the secret to be imported to use as valuesFrom in kapp.
         - namespace: Namespace where the secret exists.
         - create_export:  Boolean flag to decide creation of a SecretExport resource in the namespace mentioned above. Default value is false. If the Secret is already exported by user, make sure it is exported for tap-namespace-provisioning namespace for this feature to work.
     - path needs to start with the prefix _ytt_lib/. Namespace Provisioner mounts all the additional sources as a ytt library so it can expand the manifests in the additional sources for all managed namespaces using the logic in the expansion template. The path after the _ytt_lib prefix should be unique across all additional sources but it can be any string value.

     Sample TAP values configuration:

     ```console
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

     ## Adjust sync period of Namespace Provisioner

     - sync_period defines the wait time for the provisioner to reconcile. sync_period is specified in time + unit format. 30 seconds would be defaulted if a value less than 30 seconds is specified. If not specified, value is defaulted to 1m0s.

     Sample TAP values configuration:

     ```console
     namespace_provisioner:
       sync_period: 1m0s
     ```

     ## Import user defined secrets in YAML format as ytt data.values

     - import_data_values_secrets is an array of additional secrets in YAML format to import in the provisioner as data.values under the data.values.imported key. SecretImport for the secrets listed in the array will be created in tap-namespace-provisioning namespace by the Namespace Provisioner package. Users have a choice to create SecretExport for the same secrets manually and export it to tap-namespace-provisioning namespace or more broadly, or let the Namespace Provisioner package create it for them. Parameters include
         - name: Name of the secret to be imported to use as valuesFrom in kapp.
         - namespace: Namespace where the secret exists.
         - create_export:  Boolean flag to decide creation of a SecretExport resource in the namespace mentioned above. Default value is false. If the Secret is already exported by user, make sure it is exported for tap-namespace-provisioning namespace for this feature to work.

     > **Note** stringData key of the secret should have .yaml or .yml suffix at the end.

     Example secret:

     ```console
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

     ```console
     namespace_provisioner:
       controller: false
       import_data_values_secrets:
       - name: user-defined-secrets
         namespace: tap-install
         create_export: true
     ```

     ## Support for AWS IAM roles
     If the TAP installation is on AWS with EKS, use the IAM Role from aws_iam_role_arn for the Kubernetes Service Account that is used by Workload and the Supply chain to create resources.
     Sample TAP values configuration:

     ```console
     namespace_provisioner:
       controller: false
       aws_iam_role_arn: "arn:aws:iam::123456789012:role/EKSIAMRole"
     ```

     ## Default parameters to all namespaces

     Default_parameters is an array of parameters applied to all namespaces which can be used as ytt (data.values.default_parameters) for templating default and additional resources.

     ```console
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

     ## Import Overlay secrets

     overlay_secrets is a list of secrets which contains carvel ytt overlay definitions that are applied to the resources created by the Namespace Provisioner. The secrets will be imported to namespace-provisioner namespace if it is in another namespace.

     > **Note** stringData key of the secret should have .yaml or .yml suffix.

     Sample secret with overlay to be used

     ``` console
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

     ```console
     namespace_provisioner:
      controller: false
      overlay_secrets:
      - name: grype-package-overlay
        namespace: tap-install
        create_export: true
     ```

